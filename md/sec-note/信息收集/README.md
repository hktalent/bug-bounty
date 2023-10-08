# 信息收集的思路及工具
- 参考链接：
  - [信息收集之“骚”姿势 @鱼七](https://zone.huoxian.cn/d/618)
  - [做好信息收集是一次渗透测试的良好开端 @Paper-Pen](https://github.com/Paper-Pen/GatherInfo)
  - [干货|最全Web 渗透测试信息搜集-CheckList @mathwizard](https://mp.weixin.qq.com/s/x6vtRNKJ7lxv9_5cSFL5gw)

- 整体思路：
  - 子域名 -> IP -> 全端口 -> http、https -> 获取资产 -> 指纹识别
  - 小程序、公众号、APP
  - 通过端口识别的非web资产 -> 如数据库：先批量弱口令检测，后根据获得的相关信息构造字典进行爆破

- 内网信息收集的思路（不要一上来就用fscan扫描）
  - 先在拿下的机器看 网卡信息、`history` 历史命令、`netstat` 端口信息、`arp`表、`ps` 进程、配置文件等，收集已控机器所通的其它内网网段信息。
  - 在[微步在线](https://x.threatbook.cn/)等威胁情报社区查看域名信息。
    - 不存在解析IP，可能是内网才能访问的域名，尝试在已控机器上 `ping` 域名得到内网地址。
    - 存在互联网解析IP，也可以尝试在已控机器上 `ping` 域名得到内网地址。
  - 在互联网侧的网站上，有时会有一些内网系统的跳转，比如OA系统、统一身份认证系统，点击会跳转至内网，从而获得内网地址信息。
  - 通过什么洞打点成功 -> 比如泛微 -> 查看泛微配置文件，比如数据库配置文件，数据库系统可能在另一台内网服务器上，从而确认存在内网。
  - 更多手法可以看看这篇文章：[如何判断存不存在内网](https://github.com/reidmu/sec-note/blob/main/%E5%86%85%E7%BD%91%E6%B8%97%E9%80%8F/%E5%A6%82%E4%BD%95%E5%88%A4%E6%96%AD%E5%AD%98%E4%B8%8D%E5%AD%98%E5%9C%A8%E5%86%85%E7%BD%91.md)

# 综合利用工具
- [水泽-信息收集自动化工具](https://github.com/0x727/ShuiZe_0x727)
- [SRC子域名资产监控](https://github.com/LangziFun/LangSrcCurise)
- [ARL(Asset Reconnaissance Lighthouse)资产侦察灯塔系统](https://github.com/TophantTechnology/ARL)
- [Goby](https://gobies.org)
- [Xray](https://github.com/chaitin/xray)
- [Nuclei](https://github.com/projectdiscovery/nuclei)
- [fscan](https://github.com/shadow1ng/fscan)

 
# 公司名资产收集
- [天眼查](https://www.tianyancha.com/)
- [小蓝本](https://www.xiaolanben.com/)
- [爱企查](https://aiqicha.baidu.com/)
- [企查查](https://www.qcc.com/weblogin?back=%2F)
- [鹰图](https://user.skyeye.qianxin.com/user/sign-in?next=https://hunter.qianxin.com/)
- [360威胁情报中心](https://ti.360.net/#/homepage)
- [ENScan_GO](https://github.com/wgpsec/ENScan_GO)
  - 可查询指定占股比例的公司资产



# 子域名收集
- 枚举、第三方聚合服务
  - [phpinfo - 在线](https://phpinfo.me/domain/)
  - [dnsgrep - 在线](https://www.dnsgrep.cn/subdomain)
  - [bufferover - 在线](https://dns.bufferover.run/dns?q=baidu.com)
  - [OneForAll](https://github.com/shmilylty/OneForAll)
  - [subfinder](https://github.com/projectdiscovery/subfinder)
  - [knock](https://github.com/guelfoweb/knock)
  - [subDomainsBrute](https://github.com/lijiejie/subDomainsBrute)
  - [Layer子域名挖掘机](https://github.com/euphrat1ca/LayerDomainFinder)


- 搜索引擎
  - Google或者百度等 `site:xxx.com`
  - fofa `domain="xxx.com"`


- 证书透明性信息
  - 证书透明性（Certificate Transparency，CT）是Google的公开项目，通过让域所有者、CA和域用户对SSL证书的发行和存在进行审查，来纠正这些基于证书的威胁。因为它是一个开放的公共框架，所以任何人都可以构建或访问驱动证书透明性的基本组件，CA证书中包含了域名、子域名、邮箱等敏感信息，存在一定的安全风险。
  - 利用证书透明性进行域名信息收集，一般使用CT日志搜索引擎进行域名信息收集，如在线网站：
    - https://crt.sh/
    - https://transparencyreport.google.com/https/certificates
    - https://developers.facebook.com/tools/ct/


# CDN
## CDN判断
- 使用不同主机 ping 域名判断是否有 CDN
  - [站长之家多地ping](http://ping.chinaz.com/)
  - [ipip](http://tools.ipip.net/ping.php)
  - [全球Ping测试](https://www.wepcc.com/)
  - [爱站网Ping检测](https://ping.aizhan.com/)
  - 使用 ping 域名判断是否有 CDN
    - 直接使用 ping 域名查看回显地址来进行判断，如下回显 cname.vercel-dns.com ，很明显使用了 cdn 技术。
      - 图自mathwizard

<div align=center><img src="https://user-images.githubusercontent.com/84888757/165664408-c22dbe4d-6e69-4e2b-8a22-b7cc66e65c4d.png" /></div>

- 使用 nslookup 解析域名判断
  - 其中 Name 字段指向 cname.vercel-dns.com 这类的，说明使用了 CDN 技术。
  - 🌰 www.baidu.com ，其中 Address 字段指向两个不同 IP ，即 www.baidu.com 可能使用了 CDN。

<div align=center><img src="https://user-images.githubusercontent.com/84888757/165663648-e0074fbc-becc-4a32-a428-73f4c253784b.png" /></div>


## 绕过CDN，获取真实ip
- 解析子域名ip
  - 使用CDN是要掏钱的，所以很多网站只对主站做了CND加速，子域名就没做。子域名可能跟主站在同一个服务器或者同一个C段网络中，所以可以通过查询子域名的IP信息来辅助判断主站的真实IP信息。
- 查询历史DNS记录
  - 查询DNS与IP绑定的历史记录可能发现之前的真实IP信息

    - [dnsdb](https://dnsdb.io/zh-cn/)
    - [viewdns](https://viewdns.info/iphistory/)
    - [微步在线](https://x.threatbook.cn/)

- 使用国外主机请求域名
  - 部分国内的CDN加速服务商只对国内的线路做了CDN加速，但是国外的线路没有做加速，这样就可以通过国外的主机来探测真实的IP信息。可以使用自己的国外主机或者[全球Ping测试](https://www.wepcc.com/)选取国外的探测节点来判断真实ip信息。

- 邮件信息
  - 邮件系统一般都在内部，没有经过CDN的解析，通过利用目标网站的邮箱注册、找回密码或者RSS订阅等功能发送邮件，接收到目标回复的邮件后，查看邮件源码就 -> 获得目标的真实IP。
  - 图自mathwizard

<div align=center><img src="https://user-images.githubusercontent.com/84888757/165666189-feeb9187-8558-4f56-a50c-2f2771f3b4b6.png" /></div>

- 信息泄露
  - 利用信息泄露的敏感信息、文件（如：phpinfo页面、网站源码（备份）文件、Github泄露的信息等）获取真实的IP信息。
    - phpinfo页面的`SERVER_ADDR`字段会显示该主机真实IP。
  
 - 目标网站APP应用
    - 如果目标网站有自己的App，可以尝试利用Burp Suite等流量抓包工具抓取App的请求，从里面可能会找到目标的真实IP。



# IP反查域名（旁站查询）
- [360 ip反查](https://ti.360.net/#/homepage)
- [微步在线](https://x.threatbook.cn/)
- [站长工具同IP网站查询](http://s.tool.chinaz.com/same)
- [webscan](https://www.webscan.cc/)
- [云悉](https://www.yunsee.cn/)
- [dnsgrep ip反查](https://www.dnsgrep.cn/ip)
- [bugscaner ip反查](http://dns.bugscaner.com/203.107.33.157.html)
- bing
  - `https://cn.bing.com/search?q=ip:x.x.x.x`
- fofa
  - `ip="x.x.x.x"`



# 指纹识别
- 浏览器插件: Wappalyzer
- [潮汐 - 在线指纹识别](http://finger.tidesec.net/)
- [bugscaner - 在线指纹识别](http://whatweb.bugscaner.com/look/)
- [EHole - 红队重点攻击系统指纹探测工具](https://github.com/EdgeSecurityTeam/EHole)
- [云悉 - 在线指纹识别](https://www.yunsee.cn/)
- [what web - 在线指纹识别](https://www.whatweb.net/)


# js及接口信息
- JSFinder: https://github.com/Threezh1/JSFinder
- URLFinder: https://github.com/pingc0y/URLFinder
  - 可以看作是新版本的 JSFinder
- LinkFinder: https://github.com/GerbenJavado/LinkFinder
- Packer-Fuzzer: https://github.com/rtcatc/Packer-Fuzzer (webpack)
- 搜索关键接口
  - config/api
  - method:"get"
  - http.get("
  - method:"post"
  - http.post("
  - $.ajax
  - service.httppost
  - service.httpget
  - path
  - api
  - 存在xxx.js.map文件时
    - 搜索 axios 关键字，查找路由


# APP
- [小蓝本](https://www.xiaolanben.com/pc)
- [七麦](https://www.qimai.cn)
- [AppStore](https://www.apple.com/app-store)

# 邮箱收集
- [EmailAll](https://github.com/Taonn/EmailAll)

# WAF识别
- [WhatWaf](https://github.com/Ekultek/WhatWaf)
- [wafw00f](https://github.com/EnableSecurity/wafw00f)



# 敏感信息
## 网盘引擎
- [超能搜](https://www.chaonengsou.com)
- [优聚搜](https://ujuso.com/)
  - https://ujuso.com/
  - https://jujuso.com/

## Googlehack语法
- 后台地址
  - site:xxx.com intitle:管理|后台|登陆|管理员|系统|内部
  - site:xxx.com inurl:login|admin|system|guanli|denglu|manage|admin_login|auth|dev
- 敏感文件
  - site:xxx.com (filetype:doc OR filetype:ppt OR filetype:pps OR filetype:xls OR filetype:docx OR filetype:pptx OR filetype:ppsx OR filetype:xlsx OR filetype:odt OR --filetype:ods OR filetype:odg OR filetype:odp OR filetype:pdf OR filetype:wpd OR filetype:svg OR filetype:svgz OR filetype:indd OR filetype:rdp OR filetype:sql OR filetype:xml OR filetype:db OR filetype:mdb OR filetype:sqlite OR filetype:log OR filetype:conf)
- 测试环境
  - site:xxx.com inurl:test|ceshi
  - site:xxx.com intitle:测试
- 邮箱
  - site:xxx.com (intitle:"Outlook Web App" OR intitle:"邮件" OR inurl:"email" OR inurl:"webmail")
- 其他
  - site:xxx.com inurl:api|uid=|id=|userid=|token|session
  - site:xxx.com intitle:index.of "server at"

## Github
  - @xxx.com password/secret/credentials/token/config/pass/login/ftp/ssh/pwd
  - @xxx.com security_credentials/connetionstring/JDBC/ssh2_auth_password/send_keys
