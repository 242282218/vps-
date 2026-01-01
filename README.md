# vps-
1.综合测试脚本
融合怪 
bash <(wget -qO- --no-check-certificate https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh)
2.性能测试 
yabs

curl -sL yabs.sh | bash
跳过网络，测GB5

curl -sL yabs.sh | bash -s -- -i5
跳过网络和磁盘，测GB5

curl -sL yabs.sh | bash -s -- -if5
改测GB5不测GB6

curl -sL yabs.sh | bash -s -- -5
3、流媒体及IP质量测试
最常用版本

bash <(curl -L -s check.unlock.media)
原生检测脚本

bash <(curl -sL Media.Check.Place)
准确度最高

bash <(curl -L -s https://github.com/1-stream/RegionRestrictionCheck/raw/main/check.sh)
IP质量体检脚本

bash <(curl -sL IP.Check.Place)
一键修改解锁DNS
wget https://raw.githubusercontent.com/Jimmyzxk/DNS-Alice-Unlock/refs/heads/main/dns-unlock.sh && bash dns-unlock.sh
4、测速脚本
Speedtest

bash <(curl -sL bash.icu/speedtest)
Taier

bash <(curl -sL res.yserver.ink/taier.sh)
hyperspeed

bash <(curl -Lso- https://bench.im/hyperspeed)
全球测速

wget -qO- nws.sh | bash
区域速度测试

wget -qO- nws.sh | bash -s -- -r region_name
Ping 和路由测试

wget -qO- nws.sh | bash -s -- -rt [region]
5、回程测试
直接显示回程（小白用这个）

curl https://raw.githubusercontent.com/ludashi2020/backtrace/main/install.sh -sSf | sh
回程详细测试（推荐）

wget -N --no-check-certificate https://raw.githubusercontent.com/Chennhaoo/Shell_Bash/master/AutoTrace.sh && chmod +x AutoTrace.sh && bash AutoTrace.sh
wget https://ghproxy.com/https://raw.githubusercontent.com/vpsxb/testrace/main/testrace.sh -O testrace.sh && bash testrace.sh
6、功能脚本
添加SWAP

wget https://www.moerats.com/usr/shell/swap.sh && bash swap.sh
Fail2ban

wget --no-check-certificate https://raw.githubusercontent.com/FunctionClub/Fail2ban/master/fail2ban.sh && bash fail2ban.sh 2>&1 | tee fail2ban.log
一键开启BBR，适用于较新的Debian、Ubuntu

echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr
多功能BBR安装脚本

wget -N --no-check-certificate "https://gist.github.com/zeruns/a0ec603f20d1b86de6a774a8ba27588f/raw/4f9957ae23f5efb2bb7c57a198ae2cffebfb1c56/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
锐速/BBRPLUS/BBR2/BBR3

wget -O tcpx.sh "https://github.com/ylx2016/Linux-NetSpeed/raw/master/tcpx.sh" && chmod +x tcpx.sh && ./tcpx.sh
TCP窗口调优

wget http://sh.nekoneko.cloud/tools.sh -O tools.sh && bash tools.sh
添加warp

wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh [option] [lisence/url/token]
25端口开放测试

telnet smtp.aol.com 25
7、综合功能脚本
科技lion

apt update -y  && apt install -y curl

bash <(curl -sL kejilion.sh)
SKY-BOX

wget -O box.sh https://raw.githubusercontent.com/BlueSkyXN/SKY-BOX/main/box.sh && chmod +x box.sh && clear && ./box.sh
