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
            0) return ;;
            *) print_error "无效选项，请重试。" ; sleep 1 ;;
        esac
    done
}


# --- 2. Docker 高级管理 --- #

add_docker_mirror() {
    echo -e "\n${YELLOW}为 Docker 注入国内优质镜像加速源 (1ms.run, daocloud 等)...${NC}"
    mkdir -p /etc/docker
    cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": [
    "https://docker.1ms.run",
    "https://docker.m.ixdev.cn",
    "https://hub.rat.dev",
    "https://dockerproxy.net",
    "https://docker.m.daocloud.io"
  ]
}
EOF
    systemctl daemon-reload
    systemctl restart docker
    print_success "Docker 国内镜像源配置完成！"
}

menu_docker() {
    while true; do
        print_header
        echo -e "${BOLD}${BLUE}▶ 🐳 Docker 自动化高级控制平面${NC}\n"
        echo -e "  ${CYAN}[1]${NC} ⚡ 一键安装 Docker (自动识别系统并注入国内镜像源)"
        echo -e "  ${CYAN}[2]${NC} 📦 快速容器管理 (启动 / 停止 / 重启 / 强制删除)"
        echo -e "  ${CYAN}[3]${NC} 💿 快捷镜像管理 (拉取 / 查看 / 删除映像)"
        echo -e "  ${CYAN}[4]${NC} 🧹 深层空间清理 (清空所有未使用容器, 网络及孤儿数据卷)"
        echo -e "  ${CYAN}[0]${NC} ${PURPLE}返回主菜单${NC}"
        print_divider
        read -p "请输入选项对应的序号: " opt
        case $opt in
            1) 
                echo -e "\n${YELLOW}正在检查并安装 Docker...${NC}"
                if ! command -v docker &> /dev/null; then
                    curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
                    systemctl enable docker && systemctl start docker
                    print_success "Docker 本身安装完毕！"
                else
                    echo -e "${YELLOW}检测到系统已安装 Docker。${NC}"
                fi
                add_docker_mirror
                pause ;;
            2)
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
            3)
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
            4)
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
        echo -e "  ${CYAN}[1]${NC} 全网节点质量检测仪 (NodeQuality)"
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
    echo -e "   ${CYAN}[3]${NC} 🔧 ${BOLD}系统与底层控制${NC} (Swap 配置管理)"
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
