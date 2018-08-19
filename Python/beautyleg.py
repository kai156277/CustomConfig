# -*- coding: utf-8 -*-

from urllib.request import urlopen, Request
from urllib.error import HTTPError
from bs4 import BeautifulSoup
import re
import lxml
import os
import sys

# html = urlopen("http://www.beautyleg.com/photo/show.php?no=100.html")

# 如果用 urllib.request.urlopen 方式打开一个URL,服务器端只会收到一个单纯的对于该页面访问的请求,
# 但是服务器并不知道发送这个请求使用的浏览器,操作系统,硬件平台等信息,而缺失这些信息的请求往往都是非正常的访问,例如爬虫.
# 有些网站为了防止这种非正常的访问,会验证请求信息中的UserAgent(它的信息包括硬件平台、系统软件、应用软件和用户个人偏好),
# 如果UserAgent存在异常或者是不存在,那么这次请求将会被拒绝(HTTF Error 403)
# 所以可以尝试在请求中加入UserAgent的信息
# req = Request(url="https://www.jianshu.com/p/fdf10fd927fd.html", headers=header)

header = {'User-Agent':'Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'}

def beautylegDownload(begin, end):

    for i in range(begin, end):
        _url = "http://www.beautyleg.com/photo/show.php?no={0}".format(i)
        req = Request(url=_url, headers=header)
        try:
            html = urlopen(req)
        except HTTPError as e:
            print(e)
            continue
        bsObj = BeautifulSoup(html, 'lxml')

        print(_url)
        images = bsObj.findAll("a", {"href": re.compile(r"http://photo.beautyleg.com/.*.jpg")})
        if len(images) == 0:
            print("no image in this page: ", _url)
            continue

        log = "./{0}/beautyleg.log".format(i)
        os.system("mkdir {0}".format(i))
        os.system("touch {0}".format(log))
        print("download page: {0} imgs: {1} log:{2}".format(_url, len(images), log))
        for image in images:
            wget = "wget -P {0} {1} -a {2} -nv".format(i, image["href"], log)
            os.system(wget)
            print("Ok: " + image["href"])


if __name__ == '__main__':

    _min = 1
    _max = 200
    _argv = re.findall(r"--(min|max)[\s|=](\d+)", " ".join(sys.argv))
    print(_argv)

    for param in _argv:
        if "min" in param:
            _min = int(param[1])
        elif "max" in param:
            _max = int(param[1])

    print("min: {0} max: {1}".format(_min, _max))
    beautylegDownload(_min, _max)

    print("End download!")