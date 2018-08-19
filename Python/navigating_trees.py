from urllib.request import urlopen
from bs4 import BeautifulSoup
import re

html = urlopen("http://www.pythonscraping.com/pages/page3.html")
bsObj = BeautifulSoup(html, 'html.parser')

# for child in bsObj.find("table", {"id":"giftList"}).children:
#     print(child)

# for sibling in bsObj.find("table", {"id": "giftList"}).tr.next_siblings:
#     print(sibling)

# print(bsObj.find("img", {"src":"../img/gifts/img1.jpg"}).parent.previous_sibling.get_text())

# images = bsObj.findAll("img", {"src": re.compile(r"../img/gifts/img.*.jpg")})
# for image in images:
#     print(image.attrs["src"])
#     print(image["src"])

tags = bsObj.findAll(lambda tag: len(tag.attrs) == 2)
for tag in tags:
    print(str(tag))