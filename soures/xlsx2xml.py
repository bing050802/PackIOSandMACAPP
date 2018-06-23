import pandas as pd
xlsDf = pd.read_excel("OEM版本项目信息.xlsx", u'中文名称信息')
print(xlsDf.head(100))
print(xlsDf.index)
print(xlsDf.columns)
str="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
str=str+"\t<show-name>\n"
print(str)
for i in xlsDf.index:
    str=str+"\t\t<name-item>\n"
    str=str+"\t\t\t<key>"+xlsDf['nameId'][i]+"</key>\n"
    str=str+"\t\t\t<name>"+xlsDf['程序名'][i]+"</name>\n"
    str=str+"\t\t</name-item>\n"
    print(xlsDf['nameId'][i])
    print(xlsDf['程序名'][i])
str=str+"</show-name>"
f=open("plist_conf.xml","w")
f.write(str)
f.close()


#from xml.etree import ElementTree as ET
#
#
#print(type(xlsDf.head()))
#print('-----------  aAAAASSSSWxxszqX vxcvdddszx------------------')
#
#import requests
#r = requests.get('https://www.nytimes.com/interactive/2017/06/23/opinion/trumps-lies.html')
#
#from bs4 import BeautifulSoup
#soup = BeautifulSoup(r.text, 'html.parser')
#results = soup.find_all('span', attrs={'class':'short-desc'})
#
#records = []
#for result in results:
#    date = result.find('strong').text[0:-1] + ', 2017'
#    lie = result.contents[1][1:-2]
#    explanation = result.find('a').text[1:-1]
#    url = result.find('a')['href']
#    records.append((date, lie, explanation, url))
#
#import pandas as pd
#df = pd.DataFrame(records, columns=['date', 'lie', 'explanation', 'url'])
#df['date'] = pd.to_datetime(df['date'])
#df.to_csv('trump_lies.csv', index=False, encoding='utf-8')

