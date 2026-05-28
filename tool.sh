#!/bin/bash
# ==============================================================================
# VPS 现代化综合运维工具箱
# 作者: Agent
# 描述: 包含《提取.txt》中记载的所有脚本，附带美观的交互菜单。
# ==============================================================================

# 定义颜色与样式
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # 重置颜色

# 获取当前 IP 和系统信息供显示
IPV4=$(curl -s4m8 https://ipinfo.io/ip || echo "获取失败")
OS_INFO=$(grep PRETTY_NAME /etc/os-release | cut -d '"' -f 2 || echo "未知系统")
CWD=$(pwd)

# --- 界面交互工具 --- #

# 打印分界线
print_divider() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# 打印带有颜色的标题
print_header() {
    clear
    print_divider
    echo -e "${BOLD}${GREEN}                   🚀 现代化 VPS 综合运维工具箱 🚀${NC}"
    echo -e "  系统: ${YELLOW}${OS_INFO}${NC}  |  IP: ${YELLOW}${IPV4}${NC}"
    print_divider
}

# 暂停功能
pause() {
    echo -e "\n${BOLD}${YELLOW}👉 按回车键 (Enter) 返回上一级菜单...${NC}"
    read -r
}

# 错误提示
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 成功提示
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# --- 1. 网络与内核优化功能 --- #

menu_network_kernel() {
    while true; do
        print_header
        echo -e "${BOLD}${BLUE}▶ 🌐 网络与内核优化管理${NC}\n"
        echo -e "  ${CYAN}[1]${NC} 一键安装 BBR (支持原生、BBR Plus、v3 等)"
        echo -e "  ${CYAN}[2]${NC} 一键安装 WARP (支持 IPv4/IPv6 / 解锁流媒体)"
        echo -e "  ${CYAN}[3]${NC} 注入 Linux 极致高并发网络内核优化参数"
        echo -e "  ${CYAN}[4]${NC} 修改系统时区为 Asia/Shanghai (北京时间)"
        echo -e "  ${CYAN}[5]${NC} 全自动切换最优公共 DNS (根据境内外环境)"
        echo -e "  ${CYAN}[0]${NC} ${PURPLE}返回主菜单${NC}"
        print_divider
        read -p "请输入选项对应的序号: " opt
        case $opt in
            1) 
                echo -e "\n${YELLOW}正在加载网络主流 BBR 脚本...${NC}"
                wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
                pause ;;
            2)
                echo -e "\n${YELLOW}正在加载 fscarmen WARP 脚本...${NC}"
                wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh
                pause ;;
            3)
                echo -e "\n${YELLOW}正在备份并注入 TCP高并发与吞吐内核优化参数...${NC}"
                cp /etc/sysctl.conf /etc/sysctl.conf.bak.$(date +%F)
                cat >> /etc/sysctl.conf << EOF
# --- 自定义极致网络优化 ---
fs.file-max = 1000000
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
# --------------------------
EOF
                sysctl -p >/dev/null 2>&1
                print_success "参数写入完成，并已立即生效!"
                pause ;;
            4)
                echo -e "\n${YELLOW}正在设置时区...${NC}"
                timedatectl set-timezone Asia/Shanghai
                echo -e "当前系统时间: ${GREEN}$(date)${NC}"
                print_success "时区已成功更改为: 北京时间"
                pause ;;
            5)
                echo -e "\n${YELLOW}正在评估网络环境并重新部署 DNS...${NC}"
                local country=$(curl -s4m8 ipinfo.io/country || echo "")
                
                # 备份当前 DNS 配置文件
                cp /etc/resolv.conf /etc/resolv.conf.bak.$(date +%F)
                > /etc/resolv.conf
                
                if [ "$country" = "CN" ]; then
                    echo "nameserver 223.5.5.5" >> /etc/resolv.conf
                    echo "nameserver 119.29.29.29" >> /etc/resolv.conf
                    echo "nameserver 2400:3200::1" >> /etc/resolv.conf
                    print_success "检测为国内节点，已切换为 阿里 / 腾讯 公共 DNS"
                else
                    echo "nameserver 1.1.1.1" >> /etc/resolv.conf
                    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
                    echo "nameserver 2606:4700:4700::1111" >> /etc/resolv.conf
                    print_success "检测为海外节点，已切换为 Cloudflare / Google 公共 DNS"
                fi
                pause ;;
            0) return ;;
            *) print_error "无效选项，请重试。" ; sleep 1 ;;
        esac
    done
}


# --- 2. Docker 高级管理 --- #

check_url_reachable() {
    local url="$1"
    curl -fsSL4m5 --connect-timeout 3 -o /dev/null "$url" 2>/dev/null
}

detect_network_region() {
    local country
    local endpoint

    for endpoint in "https://ipinfo.io/country" "https://ifconfig.co/country-iso" "https://ipapi.co/country/"; do
        country=$(curl -fsSL4m6 --connect-timeout 3 "$endpoint" 2>/dev/null | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
        if [ "$country" = "CN" ]; then
            echo "CN"
            return 0
        fi
        if [ -n "$country" ] && [ ${#country} -le 3 ]; then
            echo "GLOBAL"
            return 0
        fi
    done

    if check_url_reachable "https://mirrors.aliyun.com/docker-ce/linux/static/stable/" || check_url_reachable "https://docker.m.daocloud.io/v2/"; then
        if ! check_url_reachable "https://registry-1.docker.io/v2/"; then
            echo "CN"
            return 0
        fi
    fi

    echo "GLOBAL"
}

restart_docker_service() {
    if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files docker.service >/dev/null 2>&1; then
        systemctl daemon-reload
        systemctl restart docker
        return $?
    fi

    if command -v service >/dev/null 2>&1; then
        service docker restart
        return $?
    fi

    return 0
}

configure_docker_mirror() {
    local network_region="$1"
    local daemon_file="/etc/docker/daemon.json"

    if [ "$network_region" != "CN" ]; then
        echo -e "${YELLOW}检测为海外网络环境，跳过 Docker 国内镜像源注入。${NC}"
        return 0
    fi

    echo -e "\n${YELLOW}检测为国内网络环境，为 Docker 注入国内镜像加速源...${NC}"
    mkdir -p /etc/docker
    if [ -f "$daemon_file" ]; then
        cp "$daemon_file" "$daemon_file.bak.$(date +%F-%H%M%S)"
    fi

    if command -v python3 >/dev/null 2>&1; then
        python3 - <<'PY'
import json
from pathlib import Path

path = Path('/etc/docker/daemon.json')
mirrors = [
    'https://docker.1ms.run',
    'https://docker.m.daocloud.io',
    'https://dockerproxy.net',
    'https://hub.rat.dev',
]

config = {}
if path.exists() and path.read_text(encoding='utf-8').strip():
    try:
        config = json.loads(path.read_text(encoding='utf-8'))
    except json.JSONDecodeError:
        config = {}

existing = config.get('registry-mirrors', [])
if not isinstance(existing, list):
    existing = []
config['registry-mirrors'] = list(dict.fromkeys(mirrors + existing))
path.write_text(json.dumps(config, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
PY
    else
        cat > "$daemon_file" << EOF
{
  "registry-mirrors": [
    "https://docker.1ms.run",
    "https://docker.m.daocloud.io",
    "https://dockerproxy.net",
    "https://hub.rat.dev"
  ]
}
EOF
    fi

    if restart_docker_service; then
        print_success "Docker 国内镜像源配置完成！"
    else
        print_error "Docker 镜像源已写入，但 Docker 重启失败，请手动检查服务状态。"
        return 1
    fi
}

install_docker() {
    local network_region="$1"
    local install_script="/tmp/get-docker.sh"
    local install_status
    local install_url="https://get.docker.com"

    if ! curl -fsSL4m20 --connect-timeout 8 "$install_url" -o "$install_script"; then
        return 1
    fi

    if [ "$network_region" = "CN" ]; then
        bash "$install_script" docker --mirror Aliyun
    else
        bash "$install_script"
    fi
    install_status=$?
    rm -f "$install_script"
    return "$install_status"
}

ensure_docker_ready() {
    if ! command -v docker >/dev/null 2>&1; then
        print_error "未检测到 Docker，请先执行 [1] 一键安装 Docker。"
        return 1
    fi

    if ! docker info >/dev/null 2>&1; then
        print_error "Docker 服务不可用，请先启动 Docker 后再重试。"
        return 1
    fi

    return 0
}

install_watchtower_auto_update() {
    ensure_docker_ready || return 1

    echo -e "\n${YELLOW}正在部署 Watchtower 容器自动更新服务...${NC}"
    if docker ps -a --format '{{.Names}}' | grep -qx 'watchtower'; then
        echo -e "${YELLOW}检测到已存在 watchtower，正在重建以应用当前配置...${NC}"
        docker rm -f watchtower >/dev/null 2>&1 || return 1
    fi

    docker run -d \
      --name watchtower \
      --restart unless-stopped \
      -e DOCKER_API_VERSION=1.54 \
      -v /var/run/docker.sock:/var/run/docker.sock \
      containrrr/watchtower \
      --interval 21600 \
      --cleanup
}

menu_docker() {
    while true; do
        print_header
        echo -e "${BOLD}${BLUE}▶ 🐳 Docker 自动化高级控制平面${NC}\n"
        echo -e "  ${CYAN}[1]${NC} ⚡ 一键安装 Docker (根据网络环境决定是否注入国内镜像源)"
        echo -e "  ${CYAN}[2]${NC} 🔄 安装 Watchtower 自动更新容器 (每 6 小时检查并清理旧镜像)"
        echo -e "  ${CYAN}[3]${NC} 📦 快速容器管理 (启动 / 停止 / 重启 / 强制删除)"
        echo -e "  ${CYAN}[4]${NC} 💿 快捷镜像管理 (拉取 / 查看 / 删除映像)"
        echo -e "  ${CYAN}[5]${NC} 🧹 深层空间清理 (清空所有未使用容器, 网络及孤儿数据卷)"
        echo -e "  ${CYAN}[0]${NC} ${PURPLE}返回主菜单${NC}"
        print_divider
        read -p "请输入选项对应的序号: " opt
        case $opt in
            1) 
                echo -e "\n${YELLOW}正在检查并安装 Docker...${NC}"
                local docker_network_region
                docker_network_region=$(detect_network_region)
                if ! command -v docker &> /dev/null; then
                    if install_docker "$docker_network_region"; then
                        systemctl enable docker && systemctl start docker
                        print_success "Docker 本身安装完毕！"
                    else
                        print_error "Docker 安装失败，请检查网络或安装源。"
                        pause
                        continue
                    fi
                else
                    echo -e "${YELLOW}检测到系统已安装 Docker。${NC}"
                fi
                configure_docker_mirror "$docker_network_region"
                pause ;;
            2)
                if install_watchtower_auto_update; then
                    print_success "Watchtower 自动更新已启用：每 6 小时检查一次，并自动清理旧镜像。"
                else
                    print_error "Watchtower 自动更新部署失败。"
                fi
                pause ;;
            3)
                print_divider
                docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
                print_divider
                echo -e "操作指令: ${CYAN}[start]${NC}启动 | ${CYAN}[stop]${NC}停止 | ${CYAN}[restart]${NC}重启 | ${CYAN}[rm]${NC}删除"
                read -p "请输入 [操作指令 容器ID或名称] (例如: start my_nginx) : " ACTION TARGET
                if [ -n "$ACTION" ] && [ -n "$TARGET" ]; then
                    if [[ "$ACTION" =~ ^(start|stop|restart|rm)$ ]]; then
                        if [ "$ACTION" == "rm" ]; then
                            docker rm -f "$TARGET"
                        else
                            docker "$ACTION" "$TARGET"
                        fi
                        print_success "指令已下达"
                    else
                        print_error "无此操作指令"
                    fi
                fi
                pause ;;
            4)
                print_divider
                docker images
                print_divider
                echo -e "操作指令: ${CYAN}[pull]${NC}拉取镜像 | ${CYAN}[rm]${NC}删除镜像"
                read -p "请输入 [操作指令 镜像完整名或ID] (例如: pull redis:latest) : " ACTION TARGET
                if [ -n "$ACTION" ] && [ -n "$TARGET" ]; then
                    if [ "$ACTION" == "pull" ]; then
                        docker pull "$TARGET"
                    elif [ "$ACTION" == "rm" ]; then
                        docker rmi -f "$TARGET"
                    else
                        print_error "无此操作指令"
                    fi
                fi
                pause ;;
            5)
                echo -e "\n${YELLOW}⚠️ 警告：此操作将清理所有处于停止状态的容器、孤立镜像和无用的挂载卷！${NC}"
                read -p "确认执行清理? [y/N]: " confirm
                if [[ "$confirm" =~ ^[Yy]$ ]]; then
                    docker system prune -a -f --volumes
                    print_success "系统垃圾清理完毕！"
                fi
                pause ;;
            0) return ;;
            *) print_error "无效选项，请重试。" ; sleep 1 ;;
        esac
    done
}


# --- 3. 基础系统与磁盘控制 --- #

menu_system() {
    while true; do
        print_header
        echo -e "${BOLD}${BLUE}▶ 🔧 系统维护与基础控制${NC}\n"
        echo -e "  ${CYAN}[1]${NC} 一键分配 Swap 虚拟内存 (防 OOM 内存爆满)"
        echo -e "  ${CYAN}[2]${NC} 卸载并清空当前 Swap 虚拟内存"
        echo -e "  ${CYAN}[3]${NC} 🧹 系统垃圾清理与磁盘空间分析 (含日志、缓存清除)"
        echo -e "  ${CYAN}[0]${NC} ${PURPLE}返回主菜单${NC}"
        print_divider
        read -p "请输入选项对应的序号: " opt
        case $opt in
            1)
                echo -e "\n当前内存情况:"
                free -m
                read -p "请输入期望的 Swap 空间大小 (单位: MB, 例如: 2048): " swap_size
                if [[ "$swap_size" =~ ^[0-9]+$ ]]; then
                    echo -e "\n${YELLOW}正在创建 ${swap_size}MB 分页文件并激活...${NC}"
                    swapoff -a
                    dd if=/dev/zero of=/swapfile bs=1M count=$swap_size status=progress
                    chmod 600 /swapfile
                    mkswap /swapfile
                    swapon /swapfile
                    if ! grep -q "/swapfile" /etc/fstab; then
                        echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
                    fi
                    print_success "Swap 创建成功！分配结果如下："
                    free -m
                else
                    print_error "无效输入，请输入纯数字 (MB)。"
                fi
                pause ;;
            2)
                echo -e "\n${YELLOW}正在关闭和清理 Swap 文件...${NC}"
                swapoff -a
                rm -f /swapfile
                sed -i '/\/swapfile/d' /etc/fstab
                print_success "Swap 已被彻底清除。"
                pause ;;
            3)
                echo -e "\n${YELLOW}正在进行系统安全清理与磁盘分析...${NC}"
                
                # 依赖检查与安装 (优化：检测是否已安装 ncdu，只在不存在时进行包管理器更新与安装)
                if ! command -v ncdu >/dev/null 2>&1; then
                    echo -e "正在轻量级安装分析工具 ncdu..."
                    if command -v apt >/dev/null 2>&1; then
                        apt update -y >/dev/null 2>&1 && apt install -y ncdu >/dev/null 2>&1
                    elif command -v apk >/dev/null 2>&1; then
                        apk update >/dev/null 2>&1 && apk add ncdu >/dev/null 2>&1
                    elif command -v yum >/dev/null 2>&1; then
                        yum install -y epel-release ncdu >/dev/null 2>&1
                    fi
                fi

                print_divider
                echo -e "${CYAN}▶ 清理前磁盘使用情况:${NC}"
                df -h /
                
                echo -e "\n${YELLOW}▶ 开始执行深度清理...${NC}"
                
                # APT / YUM 清理 (优化：支持 yum，并且增加静默输出)
                if command -v apt >/dev/null 2>&1; then
                    apt clean -y && apt autoclean -y && apt autoremove -y >/dev/null 2>&1
                    echo -e "  ✔ APT 缓存及多余依赖已清理"
                elif command -v yum >/dev/null 2>&1; then
                    yum clean all >/dev/null 2>&1
                    echo -e "  ✔ YUM 缓存已清理"
                fi

                # 日志清理
                if command -v journalctl >/dev/null 2>&1; then
                    journalctl --vacuum-time=3d >/dev/null 2>&1
                    echo -e "  ✔ 系统日志已缩减至近 3 天"
                fi

                # npm 清理
                if command -v npm >/dev/null 2>&1; then
                    npm cache clean --force >/dev/null 2>&1
                fi
                rm -rf ~/.npm 2>/dev/null
                echo -e "  ✔ npm / 前端缓存冗余已清除"
                
                # nvm 清理
                if [ -d "$HOME/.nvm" ]; then
                    rm -rf ~/.nvm/.cache 2>/dev/null
                    echo -e "  ✔ nvm 缓存已清除"
                fi

                # 临时文件
                rm -rf /tmp/* /var/tmp/* 2>/dev/null
                echo -e "  ✔ /tmp 与 /var/tmp 系统临时文件已清理"

                # Docker 清理
                if command -v docker >/dev/null 2>&1; then
                    docker system prune -a -f --volumes >/dev/null 2>&1
                    echo -e "  ✔ Docker 无用镜像、停止的容器和孤离数据卷已清除"
                fi
                
                print_divider
                echo -e "${CYAN}▶ 清理后磁盘使用情况:${NC}"
                df -h /
                
                echo -e "\n${YELLOW}▶ 根目录占用空间分析排行 (Top 10):${NC}"
                du -h --max-depth=1 / 2>/dev/null | sort -hr | head -n 11
                
                echo -e "\n${YELLOW}▶ 查找 200MB 以上全局大文件 (Top 10):${NC}"
                # 优化：采用 exec {} + 方式合并处理不仅提升查询速度，同时也用 du 规避了 ls 带来的列对齐问题
                find / -type f -size +200M -exec du -h {} + 2>/dev/null | sort -hr | head -n 10
                
                echo ""
                print_success "磁盘垃圾清理与扫描完成！若想进行更精细排查，可直接运行 ncdu 命令。"
                pause ;;
            0) return ;;
            *) print_error "无效选项，请重试。" ; sleep 1 ;;
        esac
    done
}


# --- 4. 机器全方位监控与测速 --- #

menu_test() {
    while true; do
        print_header
        echo -e "${BOLD}${BLUE}▶ 📊 性能测速与媒体流解锁检测${NC}\n"
        echo -e "  ${CYAN}[1]${NC} 全量测试 (NodeQuality)"
        echo -e "  ${CYAN}[2]${NC} 追踪三网回程路由情况 (BestTrace)"
        echo -e "  ${CYAN}[3]${NC} 全球综合网络双向测速 (nws.sh)"
        echo -e "  ${CYAN}[4]${NC} 纯 IP 综合质量度体检 (IP.Check.Place)"
        echo -e "  ${CYAN}[0]${NC} ${PURPLE}返回主菜单${NC}"
        print_divider
        read -p "请输入选项对应的序号: " opt
        case $opt in
            1) 
                echo -e "\n${YELLOW}启动 NodeQuality 综合质量跑分...${NC}"
                bash <(curl -sL https://run.NodeQuality.com)
                pause ;;
            2) 
                echo -e "\n${YELLOW}执行回程路由智能追踪...${NC}"
                wget -qO- git.io/besttrace | bash
                pause ;;
            3) 
                echo -e "\n${YELLOW}启动 NWS 全球双向详细测速...${NC}"
                wget -qO- nws.sh | bash
                pause ;;
            4)
                echo -e "\n${YELLOW}全面扫描当前 IP 污染程度和真人检测值...${NC}"
                bash <(curl -sL IP.Check.Place)
                pause ;;
            0) return ;;
            *) print_error "无效选项，请重试。" ; sleep 1 ;;
        esac
    done
}


# --- 顶级主菜单循环 --- #

while true; do
    print_header
    echo -e "   ${CYAN}[1]${NC} 🌐 ${BOLD}网络与内核优化${NC} (BBR / WARP / 时区 / TCP内核注入)"
    echo -e "   ${CYAN}[2]${NC} 🐳 ${BOLD}Docker 运维面板${NC} (环境部署 / 容器控制 / 清理重置)"
    echo -e "   ${CYAN}[3]${NC} 🔧 ${BOLD}系统与底层控制${NC} (Swap 配置管理 / 空间清理)"
    echo -e "   ${CYAN}[4]${NC} 📊 ${BOLD}整机性能及测速${NC} (跑分 / 路由追踪 / 流媒体检测)\n"
    echo -e "   ${CYAN}[0]${NC} ❌ ${BOLD}退出工具箱${NC}"
    print_divider
    read -p " 🟢 期待您的指令 [0-4]: " main_opt
    case $main_opt in
        1) menu_network_kernel ;;
        2) menu_docker ;;
        3) menu_system ;;
        4) menu_test ;;
        0) 
            echo -e "\n${GREEN}拜拜！祝编码愉悦~ 👋${NC}\n"
            exit 0 
            ;;
        *) 
            print_error "非法输入，请选择给定范围内的菜单项。"
            sleep 1 
            ;;
    esac
done
