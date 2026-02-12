````markdown
# VPS 常用脚本集合

---

## 1️⃣ 综合测试脚本

### 融合怪测试脚本
```bash
bash <(wget -qO- --no-check-certificate https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh)

bash <(curl -sL https://run.NodeQuality.com)
````

---

## 2️⃣ 性能测试

### YABS 性能测试

```bash
# 完整测试
curl -sL yabs.sh | bash

# 跳过网络，仅测 GB5
curl -sL yabs.sh | bash -s -- -i5

# 跳过网络和磁盘，仅测 GB5
curl -sL yabs.sh | bash -s -- -if5

# 改测 GB5，不测 GB6
curl -sL yabs.sh | bash -s -- -5
```

---

## 3️⃣ 流媒体 & IP 质量测试
```

### IP 质量体检

```bash
bash <(curl -sL IP.Check.Place)
```

### 一键修改解锁 DNS

```bash
wget https://raw.githubusercontent.com/Jimmyzxk/DNS-Alice-Unlock/refs/heads/main/dns-unlock.sh && bash dns-unlock.sh
```

---

## 4️⃣ 网络测速脚本

### Speedtest

```bash
bash <(curl -sL bash.icu/speedtest)
```
```

### 全球测速

```bash
wget -qO- nws.sh | bash
```

### 区域测速

```bash
wget -qO- nws.sh | bash -s -- -r region_name
```

### Ping & 路由测试

```bash
wget -qO- nws.sh | bash -s -- -rt [region]
```

---

## 5️⃣ 回程测试

### 简化回程测试（新手）

```bash
curl https://raw.githubusercontent.com/ludashi2020/backtrace/main/install.sh -sSf | sh
```

### 详细回程测试（推荐）

#### 脚本一

```bash
wget -N --no-check-certificate https://raw.githubusercontent.com/Chennhaoo/Shell_Bash/master/AutoTrace.sh \
&& chmod +x AutoTrace.sh \
&& bash AutoTrace.sh
```

#### 脚本二

```bash
wget https://ghproxy.com/https://raw.githubusercontent.com/vpsxb/testrace/main/testrace.sh -O testrace.sh \
&& bash testrace.sh
```

---

## 6️⃣ 功能脚本

### 添加 SWAP

```bash
wget https://www.moerats.com/usr/shell/swap.sh && bash swap.sh
```

### 安装 Fail2ban

```bash
wget --no-check-certificate https://raw.githubusercontent.com/FunctionClub/Fail2ban/master/fail2ban.sh \
&& bash fail2ban.sh 2>&1 | tee fail2ban.log
```

### 一键开启 BBR（Debian / Ubuntu）

```bash
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr
```

### 多功能 BBR 管理脚本

```bash
wget -N --no-check-certificate "https://gist.github.com/zeruns/a0ec603f20d1b86de6a774a8ba27588f/raw/4f9957ae23f5efb2bb7c57a198ae2cffebfb1c56/tcp.sh" \
&& chmod +x tcp.sh \
&& ./tcp.sh
```

### 锐速 / BBRPLUS / BBR2 / BBR3

```bash
wget -O tcpx.sh "https://github.com/ylx2016/Linux-NetSpeed/raw/master/tcpx.sh" \
&& chmod +x tcpx.sh \
&& ./tcpx.sh
```

### TCP 窗口调优

```bash
wget http://sh.nekoneko.cloud/tools.sh -O tools.sh && bash tools.sh
```

### 添加 WARP

```bash
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh \
&& bash menu.sh [option] [license/url/token]
```

### 25 端口测试

```bash
telnet smtp.aol.com 25
```

---

## 7️⃣ 综合脚本集合

### 科技 Lion 脚本

```bash
apt update -y && apt install -y curl
bash <(curl -sL kejilion.sh)
```

### SKY-BOX 工具箱

```bash
wget -O box.sh https://raw.githubusercontent.com/BlueSkyXN/SKY-BOX/main/box.sh \
&& chmod +x box.sh \
&& clear \
&& ./box.sh
```

---

## 8️⃣ Docker 安装与清理

### 安装 Docker（国内镜像）

```bash
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

### Docker 镜像加速配置

```bash
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com",
    "https://ccr.ccs.tencentyun.com"
  ]
}
EOF
```

```bash
sudo systemctl daemon-reexec
sudo systemctl restart docker
```

### Docker 垃圾清理

```bash
docker system prune -a -f
```

**清理内容：**

* 未使用镜像
* 构建失败残留
* 停止的容器
* 构建缓存

```
```
推荐（现代系统）
ss -lntp

只看某个端口（例如 3000）
ss -lntp | grep ':3000'
