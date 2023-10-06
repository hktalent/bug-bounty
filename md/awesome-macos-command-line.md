# mac os 系统完美命令大全
author: M.T.X. 2018-05-14 
Twitter: @Hktalent3135773

# 一键备份# 一键备份所有的images
```
bakdir=/Users/0x101/Downloads/myDcocker/
if [[  "$1" != "" ]];
then
bakdir="$1"
fi

docker images>>${bakdir}dockerListNames.txt
cat ${bakdir}dockerListNames.txt|grep -v "REPOSITORY"|awk '{print $1" "$2" "$3" "$7}'|sort -t ' ' -k 1,3 -u >${bakdir}dockerListNames.txt1
mv ${bakdir}dockerListNames.txt1 ${bakdir}dockerListNames.txt
docker images|grep -Ev "REPOSITORY|m\.t\.x"|awk '{print $3}'|xargs -I % bash -c "bakdir=/Users/0x101/Downloads/myDcocker/;[ -f ${bakdir}% ] || docker save % -o ${bakdir}%"

```
# 一键还原docker备份的images
```
bakdir=/Users/0x101/Downloads/myDcocker/
cat <<EOT>${bakdir}loadOne.sh
bakdir=${bakdir}
t="\$1"
if [[ -f "\${bakdir}\${t}" ]];
then
docker load -i \${bakdir}\${t}
tagname=\`cat \${bakdir}dockerListNames.txt|grep "\${t}"|awk '{print \$1":"\$2}'\`
docker tag \${t} \${tagname}
docker images |grep \$t
fi
EOT
cat ${bakdir}dockerListNames.txt|grep 567d1f9f6edc|grep -Ev "REPOSITORY|m\.t\.x"|awk '{print $3}'|xargs -I % ${bakdir}loadOne.sh %
```

所有的images
```
bakdir=/Users/0x101/Downloads/myDcocker/
docker images>${bakdir}dockerListNames.txt
docker images|grep -Ev "REPOSITORY|m\.t\.x"|awk '{print $3}'|xargs -I % bash -c "[ -f  ${bakdir}%]||docker save % ${bakdir}%"
```
# 一键还原docker备份的images
```
bakdir=/Users/0x101/Downloads/myDcocker/
cat <<EOT>${bakdir}loadOne.sh
bakdir=${bakdir}
t="\$1"
if [[ -f "\${bakdir}\${t}" ]];
then
docker load -i \${bakdir}\${t}
tagname=\`cat \${bakdir}dockerListNames.txt|grep "\${t}"|awk '{print \$1":"\$2}'\`
docker tag \${t} \${tagname}
docker images |grep \$t
fi
EOT
cat ${bakdir}dockerListNames.txt|grep 567d1f9f6edc|grep -Ev "REPOSITORY|m\.t\.x"|awk '{print $3}'|xargs -I % ${bakdir}loadOne.sh %
```
## To convert in.mov into out.gif
```
https://gist.github.com/spicycode/b5f25392b2a7359c6c27
 (filesize: 48KB), open Terminal to the folder with in.mov and run the following command:

ffmpeg -i in.mov -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > out.gif
Notes on the arguments:

-r 10 tells ffmpeg to reduce the frame rate from 25 fps to 10
-s 600x400 tells ffmpeg the max-width and max-height
--delay=3 tells gifsicle to delay 30ms between each gif
--optimize=3 requests that gifsicle use the slowest/most file-size optimization
To share the new GIF using Dropbox and Copy Public URL, run the following:

cp out.gif ~/Dropbox/Public/screenshots/Screencast-`date +"%Y.%m.%d-%H.%M"`.gif
```

## 安全审计
```
brew install lynis
lynis audit system
```

## brew 依赖关系查看
```
brew deps --installed
```

## other awesome-macos-command-line
```
https://github.com/iCHAIT/awesome-macOS
https://github.com/herrbischoff/awesome-macos-command-line
https://github.com/agarrharr/awesome-macos-screensavers
https://github.com/yenchenlin/awesome-watchos
```
## set history format 
```
vi ~/.bash_profile
export HISTTIMEFORMAT="%F %T `who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g'`  `whoami` "

source ~/.bash_profile
```

## kill X11
```
ps -ef|grep X11|awk '{print $2}'|xargs -I {} sudo kill -9 {}
```

## Swiss Army Knife for macOS
```
brew install m-cli
```

## 查看程序质检的依赖关系
```
brew deps --installed --tree 
```

## find and mv
'''
find . -name "*.dmg" -exec mv {} /Volumes/mtx_hktalent/tools/ \;
'''

## 查看当前机器数据包的发送顺序
```
$ip route list
```

## 获取文件类型、字符集
```
# linux
$file -i tools/gbk2utf8.js
tools/gbk2utf8.js: text/plain; charset=utf-8
# macos
$file -I tools/gbk2utf8.js

f=tools/gbk2utf8.js
encoding=`file -I $f | cut -f 2 -d";" | cut -f 2 -d=`
echo $encoding

```

## 查看目录1级深度子目录大小
```
du -d 1 -h /usr/local/Cellar/
```

### fish 命令自动补全
fish is a smart and user-friendly command line
shell for macOS, Linux, and the rest of the family.
https://fishshell.com

```
brew install fish
```

## 转换pdf为png
```
convert -thumbnail x500 2017新年给大家的第一封信.pdf[0] thumb.png
# 批量转换
gs -sDEVICE=pngalpha -o file-%03d.png -r144  '2017新年给大家的第一封信.pdf'

gs -sDEVICE=png16m -dTextAlphaBits=4 -r300 -o a.png 'one.pdf'

gs -sDEVICE=jpeg -dTextAlphaBits=4 -r300 -o a.jpg a.pdf

brew cask install inkscape
inkscape "/Users/`whoami`/Desktop/one.pdf" -z --export-dpi=600 --export-area-drawing --export-png="/Users/`whoami`/Desktop/one.png"

convert  -density 300  -define pdf:use-cropbox=true /Users/`whoami`/Desktop/one.pdf   /Users/`whoami`/Desktop/t.png

# https://stackoverflow.com/questions/653380/converting-a-pdf-to-png
```

### 合并merge图片文件 images file为一个one image
```
convert t-0.png t-1.png t-2.png t-3.png -append group_1.png

```
### 设置当前用户，后面的命令才更好使用
```
export xxx = `whoami`
```

## brew install
```
xcode-select --install
cd /usr/local/
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
brew update;brew upgrade;brew cleanup
```

## curl 安装最新的
为了规避在使用proxifier,proxychanis的时候发生
https://github.com/libressl-portable/portable/issues/369的问题

```
fatal: unable to access 'https://github.com/Homebrew/homebrew-services/': LibreSSL SSL_connect: SSL_ERROR_SYSCALL in connection to github.com:443

curl: (35) LibreSSL SSL_connect: SSL_ERROR_SYSCALL

这样的错误
brew install LibreSSL
brew reinstall --HEAD --with-rtmpdump --with-openssl --with-nghttp2 --with-libmetalink --with-gssapi --with-c-ares  curl
vi ~/.curlrc
--ciphers DEFAULT
```

### 服务启动、重启
```
brew services list 
brew services restart mongodb
```

## 更新修复brew bug
```
https://github.com/Homebrew/brew
cd "$(brew --repo)" && git fetch && git reset --hard origin/master && brew update
```

## 强烈推荐，终端工具	
```
brew install caskroom/cask/iterm2
```

## wget好东西
```
brew install wget
```


## 文本转语音
```
say -v Ting-Ting -f file.txt -o "output.m4a"
say -v Sin-ji '你好，你是猪吗'

say -v ?
Alex                en_US    # Most people recognize me by my voice.
Alice               it_IT    # Salve, mi chiamo Alice e sono una voce italiana.
Alva                sv_SE    # Hej, jag heter Alva. Jag är en svensk röst.
Amelie              fr_CA    # Bonjour, je m’appelle Amelie. Je suis une voix canadienne.
Anna                de_DE    # Hallo, ich heiße Anna und ich bin eine deutsche Stimme.
Carmit              he_IL    # שלום. קוראים לי כרמית, ואני קול בשפה העברית.
Damayanti           id_ID    # Halo, nama saya Damayanti. Saya berbahasa Indonesia.
Daniel              en_GB    # Hello, my name is Daniel. I am a British-English voice.
Diego               es_AR    # Hola, me llamo Diego y soy una voz española.
Ellen               nl_BE    # Hallo, mijn naam is Ellen. Ik ben een Belgische stem.
Fiona               en-scotland # Hello, my name is Fiona. I am a Scottish-English voice.
Fred                en_US    # I sure like being inside this fancy computer
Ioana               ro_RO    # Bună, mă cheamă Ioana . Sunt o voce românească.
Joana               pt_PT    # Olá, chamo-me Joana e dou voz ao português falado em Portugal.
Jorge               es_ES    # Hola, me llamo Jorge y soy una voz española.
Juan                es_MX    # Hola, me llamo Juan y soy una voz mexicana.
Kanya               th_TH    # สวัสดีค่ะ ดิฉันชื่อKanya
Karen               en_AU    # Hello, my name is Karen. I am an Australian-English voice.
Kyoko               ja_JP    # こんにちは、私の名前はKyokoです。日本語の音声をお届けします。
Laura               sk_SK    # Ahoj. Volám sa Laura . Som hlas v slovenskom jazyku.
Lekha               hi_IN    # नमस्कार, मेरा नाम लेखा है. मैं हिन्दी में बोलने वाली आवाज़ हूँ.
Luca                it_IT    # Salve, mi chiamo Luca e sono una voce italiana.
Luciana             pt_BR    # Olá, o meu nome é Luciana e a minha voz corresponde ao português que é falado no Brasil
Maged               ar_SA    # مرحبًا اسمي Maged. أنا عربي من السعودية.
Mariska             hu_HU    # Üdvözlöm! Mariska vagyok. Én vagyok a magyar hang.
Mei-Jia             zh_TW    # 您好，我叫美佳。我說國語。
Melina              el_GR    # Γεια σας, ονομάζομαι Melina. Είμαι μια ελληνική φωνή.
Milena              ru_RU    # Здравствуйте, меня зовут Milena. Я – русский голос системы.
Moira               en_IE    # Hello, my name is Moira. I am an Irish-English voice.
Monica              es_ES    # Hola, me llamo Monica y soy una voz española.
Nora                nb_NO    # Hei, jeg heter Nora. Jeg er en norsk stemme.
Paulina             es_MX    # Hola, me llamo Paulina y soy una voz mexicana.
Samantha            en_US    # Hello, my name is Samantha. I am an American-English voice.
Sara                da_DK    # Hej, jeg hedder Sara. Jeg er en dansk stemme.
Satu                fi_FI    # Hei, minun nimeni on Satu. Olen suomalainen ääni.
Sin-ji              zh_HK    # 您好，我叫 Sin-ji。我講廣東話。
Tessa               en_ZA    # Hello, my name is Tessa. I am a South African-English voice.
Thomas              fr_FR    # Bonjour, je m’appelle Thomas. Je suis une voix française.
Ting-Ting           zh_CN    # 您好，我叫Ting-Ting。我讲中文普通话。
Veena               en_IN    # Hello, my name is Veena. I am an Indian-English voice.
Victoria            en_US    # Isn't it nice to have a computer that will talk to you?
Xander              nl_NL    # Hallo, mijn naam is Xander. Ik ben een Nederlandse stem.
Yelda               tr_TR    # Merhaba, benim adım Yelda. Ben Türkçe bir sesim.
Yuna                ko_KR    # 안녕하세요. 제 이름은 Yuna입니다. 저는 한국어 음성입니다.
Yuri                ru_RU    # Здравствуйте, меня зовут Yuri. Я – русский голос системы.
Zosia               pl_PL    # Witaj. Mam na imię Zosia, jestem głosem kobiecym dla języka polskiego.
Zuzana              cs_CZ    # Dobrý den, jmenuji se Zuzana. Jsem český hlas.
```

## How to Set a Specific IP Address via Terminal in OS X
```
sudo ipconfig set en1 INFORM 192.168.0.150
sudo ifconfig en1 down ; sudo ifconfig en1 up
sudo ipconfig set en1 DHCP
```

## 获取本机ip
```
ifconfig | grep inet | grep -v inet6 | cut -d" " -f2 | tail -n1
ifconfig | grep inet | grep -v inet6 | cut -d" " -f2,3 
grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" jd.xm
sudo nmap -oX jd.xml -p- -iL jdIps.txt -T4 --version-all -A
```
### 文本中获取本机ip
```
cat 内网445漏洞主机.txt|grep -E "\.(28|29|31)\." |cut -d" " -f2 |cut -d":" -f1
cat 内网445漏洞主机.txt |cut -d" " -f2 |cut -d":" -f1
```
## 去除重复文件
```
brew reinstall fdupes
fdupes -d  -N -r  /Volumes/mtx_hktalent/
bak/loot
fdupes -d  -N -r  /Volumes/mtx_hktalent/Awesome
fdupes -d  -N -s -r  /Volumes/mtx_hktalent/
-s --symlinks    	follow symlinks
-H --hardlinks   	normally, when two or more files point to the same
                  	disk area they are treated as non-duplicates; this
                  	option will change this behavior
```

## 查找删除0字节文件、文件夹
```
find $dir -size 0 -type f -delete
find . -type d -empty -delete
```

## 关键字查找
```
cat ~/Downloads/20180706_095031AllJarName.txt |grep -e '.*spring.*boot.*'
```

# 屏幕截屏为gif
```
brew cask install gifcapture
Drag and resize to specify capture window
Press Cmd+R to start recording
Press Cmd+S to stop and save
```

## 查看数据包及路由情况
```
netstat -r
```
## 查看路由情况
```
route get google.com
```

## 查看当前ip
```
echo en0:
ipconfig getifaddr en0
echo bridge0:
ipconfig getifaddr bridge0
ip addr

ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'

ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'

ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'

hostname -I
```
## 显示网络配置
```
scselect
```
## 设置静态ip
```
networksetup -setmanual "Ethernet" 192.168.2.100 255.255.255.0 192.168.2.1
```
### 设置代理
```
$ networksetup -getmacaddress Ethernet
networksetup -getmacaddress 'Thunderbolt Ethernet'
networksetup -setwebproxy wi-fi ip port
https设置代理
networksetup -setsecurewebproxy wi-fi ip port
```
### 关闭代理
```
networksetup -setwebproxystate wi-fi off
networksetup -setsecurewebproxystate wi-fi off
```
### 获取mac地址
```
networksetup -listallnetworkservices | grep -v "An asterisk"
networksetup -getmacaddress wi-fi
```
## 参看特定端口进程、使用情况
```
netstat -lnta|grep LISTEN|grep tcp4
sudo lsof -i :5432
lsof -i -P | grep -i rapport
ps aux | grep rapportd
ps -ef | grep rapportd
sudo pkill -9 rapportd;sudo kill -9 rapportd;ps aux | grep rapportd
```
## 查看进城信息
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

## 显示所有分区信息
```
diskutil list
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

## 磁盘检查
```
fsck_hfs -fy -x /dev/rdisk2s1
```
## mac系统拒绝访问某些域名
```
sudo vi /etc/hosts
127.0.0.1	secclientgw.alipay.com
令生效
sudo dscacheutil -flushcache
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

## 防止ARP中间人攻击、设置静态mac 地址
```
sudo arp -s 192.168.24.1 84:5b:12:4a:bc:3a
sudo arp -s 192.168.0.1 CC:34:29:97:1C:CC
sudo arp -s 192.168.28.1 84:5b:12:4a:bc:3e
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

## 一些常用文本处理
```
cat mytels.vcf|grep 'TEL;TYPE=CELL:'|sed 's/TEL;TYPE=CELL://g'|sed 's/(-|\s|\t)//g'|sed -e 's/[^0-9]/\
/g'|sort -u

cat mytels.vcf |grep 'FN:' -A 1|sed 's/.*_//g'|sed 's/\n*N://g'|sed 's/;//g'
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
### port删除不使用的包
```
sudo port -f uninstall inactive
sudo port uninstall inactive
```

### 卸载所有port安装的软件
```
sudo port -f uninstall installed
sudo port clean all
sudo rm -rf \
/opt/local \
/Applications/DarwinPorts \
/Applications/MacPorts \
/Library/LaunchDaemons/org.macports.* \
/Library/Receipts/DarwinPorts*.pkg \
/Library/Receipts/MacPorts*.pkg \
/Library/StartupItems/DarwinPortsStartup \
/Library/Tcl/darwinports1.0 \
/Library/Tcl/macports1.0 \
~/.macports

```

### 清除编译临时文件
```
sudo port -f clean --all all
sudo rm -rf /opt/local/var/macports/build/*
```
### 清除下载临时文件
```
sudo rm -rf /opt/local/var/macports/distfiles/*
sudo rm -rf /opt/local/var/macports/packages/*
```
### brew清除旧版本和不用的服务
```
brew services cleanup;brew cleanup
```
### 批量删除.svn目录及文件、删除缓存文件
```
find . -name .svn -exec rm -rf "{}" \;
find . -name ._* -exec rm -rf "{}" \;
find . -name "._*.*"  -exec rm -rf "{}" \;
find . -name "._*.eml"  -exec rm -rf "{}" \;
find . -name "*).eml" -exec  rm -rf {} \;
find . -name ".DS_Store" -exec rm -rf "{}" \;
```
### 清理
```
rm -rf "/Users/`whoami`/Library/Developer/Xcode/iOS DeviceSupport/*"
rm -rf "/Users/`whoami`/Library/Application Support/iPhone Simulator/7.1/tmp/*"
sudo rm -rf /System/Library/Caches/com.apple.coresymbolicationd/data
ls -la /opt/local/var/macports
lrwxr-xr-x  1 ${xxx}  staff  36 Aug  7  2016 /opt/local/var/macports -> /Volumes/BOOK/`whoami`/local/macports
ln -s ~/macports  /opt/local/var/macports
rm /opt/local/var/macports
ln -s /Volumes/BOOK/`whoami`/local/macports /opt/local/var/macports
$ which port
/opt/local/bin/port
```
# 更新
### port更新
```
sudo proxychains4 -f ~/pc.conf port -v selfupdate
sudo proxychains4 -f ~/pc.conf port upgrade outdated
sudo proxychains4 -f ~/pc.conf port -d sync
sudo port upgrade outdated
sudo port upgrade outdated

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

pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U

python ~/pip2.py list --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple --outdated | sed 's/(.*//g' | xargs sudo python ~/pip2.py install -U --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple
pip list --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple --outdated | sed 's/(.*//g' | xargs sudo pip install -U --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple

pip list --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple --outdated | sed 's/(.*//g' | xargs pip install -U --trusted-host pypi.douban.com  -i http://pypi.douban.com/simple
cd ~/
brew
brew update;brew upgrade
nmap
sudo nmap --script-updatedb
/usr/local/Cellar/nmap/*/share/nmap/scripts
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
### brew自身更新和更新所有软件
```
sudo chown -R ${xxx}:wheel /usr/local/Homebrew
cd /usr/local && sudo chown -R ${xxx}:staff .
brew update;brew upgrade
```
### nessus升级
```
brew install proxychains-ng
sudo proxychains4 -f ~/pc.conf nessuscli update --all
sudo nessuscli update --plugins-only
sudo /Library/Nessus/run/sbin/nessusd start

nessuscli update --all
sudo /Library/Nessus/run/sbin/nessusd start
https://localhost:8834/#/
```
### 批量git更新工程
```
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
### 清除旧版本、更新
```
gem cleanup
gem update --system
gem update
gem install rubygems-update;update_rubygems
gem update
gem update --system
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

#### 使用默认系统ruby版本
```
rvm use system --default
```
## 磁盘空间情况
```
df -h | grep -v 100%
```

## How To Use SSHFS to Mount Remote File Systems Over SSH 挂载linux系统文件
```
https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh
download：http://osxfuse.github.io/
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
```
### 修改mac地址
```
vi /usr/local/bin/mymac
echo ${rtpswd} | sudo -S ifconfig en0 ether $1

sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport --disassociate
sudo ifconfig en0 ether $(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/./0/2; s/.$//')
networksetup -detectnewhardware


chmod +x  /usr/local/bin/mymac

sudo ifconfig bridge0 ether 54:9F:13:1A:CD:78
echo ${rtpswd} | sudo -S  ifconfig bridge0 ether b8:12:34:b6:bb:b8
echo ${rtpswd} | sudo -S ifconfig en0 ether  b4:48:b7:77:13:ab

sudo ifconfig en0 ether 54:9F:13:1A:CD:78
sudo ifconfig en0 ether 87:8B:8B:6b:13:75

sudo ifconfig bridge0 ether 8A:73:58:25:66:D5
sudo ifconfig bridge0 ether AB:CD:78:12:34:56

sudo ifconfig bridge0 inet6  8888::bbbb:6666:555:8888%bridge0 prefixlen 64 secured scopeid 0x6
sudo ifconfig bridge0 inet6  '8888::bbbb:6666:555:8888%bridge0 prefixlen 64 secured scopeid 0x6'
```

## whereami Install whereami on Mac OSX
```
# http://macappstore.org
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
brew install whereami
whereami
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

## 手机短信存储位置
```
/Users/${xxx}/Library/Containers/com.apple.iChat/Data/Library/Messages/Archive
/Users/${xxx}/Library/Containers/com.apple.iChat/Data/
```
## 修复airport
```
sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/local/bin/airport
```
## 批量去除背景
```
Adobe Acrobat Pro DC
可以批量处理背景图片哈
convert /mytools/hktools_MTX/app/static/img/ico.jpg -resize 64x64 /mytools/hktools_MTX/app/static/favicon.ico

http://www.imagemagick.org/script/convert.php

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

# 字体文件
经常丢失的字体文件在这里哦

```
cp '/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/Support/FontSubsets/Kaiti.ttc' /Library/Fonts

cp /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/Support/FontSubsets/*.ttc /Library/Fonts

```

# 很好的日志分析、转视频动态展现软件
```
brew install gource
https://github.com/acaudwell/Gource
https://github.com/acaudwell/Gource/wiki/Visualizing-Multiple-Repositories
https://github.com/acaudwell/Gource/wiki/Controls
https://github.com/acaudwell/Gource/wiki/Videos

```
<a href="https://youtu.be/InlfK8GQ-kM"><img align="left" width="400" src="https://img.youtube.com/vi/InlfK8GQ-kM/0.jpg" alt="gource video"></a>
<a href="https://youtu.be/qKLJjZ0TMqA"><img width="400" src="https://img.youtube.com/vi/qKLJjZ0TMqA/0.jpg" alt="gource video"></a>

```
svn log -r 1:HEAD --xml --verbose --quiet > my-project-log.xml
gource my-project-log.xml -a 36000 -c 1.0 -s 1 -o - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 -b:a 32k gource.mp4

ffmpeg -i gource.mp4 -r 10 -b:a 32k gource2.mp4
rm gource.mp4

git
gource  -a 36000 -c 1.0 -s 1 -o - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 -b:a 32k gource.mp4

```


# how save youtube video
如何下载、保存youtube视频

```
brew install homebrew/cask/clipgrab
open /Applications/ClipGrab.app
```

拷贝粘贴你要下载的url，或者，支持更多的you-get(Twitter、YouTube、)

```
brew install you-get
you-get 'https://www.youtube.com/watch?v=jNQXAC9IVRw'
```


# 下载twitter视频、gif
http://twittervideodownloader.com

# 让更多人在twitter分享

http://twitter.com/share?url=http://twittervideodownloader.com/&text=Download%20Twitter%20Videos%20online%20in%20MP4%20format