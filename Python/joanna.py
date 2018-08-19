# -*- coding: utf-8 -*-

from urllib.request import urlopen, Request
from urllib.error import HTTPError
from bs4 import BeautifulSoup
import re
import lxml
import os
import sys

header = {'User-Agent':'Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'}

def getModel(name):
    _url = "http://m.beautylegmm.com/{0}/".format(name)
    req = Request(url=_url, headers=header)
    try:
        html = urlopen(req)
    except HTTPError as e:
        print(e)
    bsObj = BeautifulSoup(html, 'lxml')

    print(_url)
    # images = bsObj.findAll("a", {"href": re.compile(r"http://photo.beautyleg.com/.*.jpg")})
    models = bsObj.findAll("a", {"href": re.compile(r"http://m.beautylegmm.com/{0}/.*.html".format(name))},rel='bookmark')
    os.system("mkdir {0}".format(name))
    log = name + ".log"
    wgetParam = {'user': "Mozila", 'log': log}
    for model in models:
        # [Beautyleg] 美腿寫真 No.1618 Joanna 2018.06.13 [57P]
        _tuple = (re.findall(r"No.(\d+).*(\d{4}).*\[(\d+)P\]", str(model.contents)))
        param = {'year': int(_tuple[0][1]), 'issn': int(_tuple[0][0]), 'num': int(_tuple[0][2])}
        path = os.path.join(name, "No."+_tuple[0][0])
        os.system("mkdir " + path)
        wgetParam['path'] = path
        print(str(model))
        for index in range(0, param['num']):
            img = "http://m.beautylegmm.com/photo/beautyleg/{year}/{issn}/beautyleg-{issn}".format(**param)
            img = img + "-{0:04d}.jpg".format(index)
            wgetParam['url'] = img
            wget = "wget --user-agent='{user}' {url} -P {path} -nv -a {log}".format(**wgetParam)
            os.system(wget)
            print("Ok: " , wget)


if __name__ == '__main__':
    getModel("Joanna")