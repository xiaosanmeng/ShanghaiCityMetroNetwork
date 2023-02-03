import os
import pandas as pd
import numpy as np
import json
import urllib
import requests
import re
from geopy.distance import geodesic
from bs4 import BeautifulSoup
# 获取每条线路的信息
return_data = requests.get('http://m.shmetro.com/interface/metromap/metromap.aspx?func=exfltime&line1=1')
tem = return_data.text
allline = pd.DataFrame(json.loads(tem))
# 获取每个站点的名称及key
return_data = requests.get('http://m.shmetro.com/core/shmetro/mdstationinfoback_new.ashx?act=getAllStations')
tem = return_data.text
allshop = pd.DataFrame(json.loads(tem))
#allshop.to_csv('Station_inf.txt',sep='\t',index=False)

# 获取每条线路经过哪些站点
return_data = requests.get('http://service.shmetro.com/skin/js/pca.js')
soup = BeautifulSoup(return_data.text, 'html.parser')
pauth = re.compile('var lines = {\r\n(.*?)\r\n}', re.S)
tem = re.findall(pauth, return_data.text)
tem1 = pd.DataFrame(re.split('[\[:\]\r\n]', tem[0]))
tem1 = tem1[(tem1[0] != '') & (tem1[0] != ',')].reset_index(drop=True)
line_sta = pd.DataFrame({'station': list(tem1[0][::2]), 'line': list(tem1[0][1::2])})
line_sta.to_csv('line_inf1.txt',sep='\t',index=False)

# 获取站点经纬度
return_data = requests.get('http://service.shmetro.com/skin/js/pca.js')
# soup = BeautifulSoup(return_data.text, 'html.parser')
pauth = re.compile('var gis = {(.*?)}', re.S)
tem = re.findall(pauth, return_data.text)
tem1 = pd.DataFrame(re.split('[: ,]', tem[0]))
tem1 = tem1[tem1[0] != ''].reset_index(drop=True)
latlon = pd.DataFrame({'station': list(tem1[0][::3]), 'lat': list(tem1[0][1::3]), 'lon': list(tem1[0][2::3])})
latlon.to_csv('latlon1.txt',sep='\t',index=False)


# lat1 = (31.23868,121.48085)
# lat2 = (31.244699,121.474802)
# print(geodesic(lat1, lat2).miles)