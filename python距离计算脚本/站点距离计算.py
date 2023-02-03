
from geopy.distance import geodesic


# 去除数据中相同站点，（相同站点在不同线的代号不同保留靠前线的比如一号线站0111和2号线0211一样时保留0111）
def quchong(station_list):
    """
    :param station_list: 未去重的站点数据列表[[站点代号,(lat,lon)]...]
    :return:去重后的站点数据列表
    """
    quchong_station_list = []
    Station_str = read_station_info('./Station_inf.txt')
    # 处理查询相同站
    Station_list1 = []
    Station_list2 = []
    Station_quchong_list = []
    for i in Station_str.split('\n')[1:-1]:
        i_list = i.split('\t')
        Station_list1.append([i_list[0], i_list[1]])
    # print(Station_list1)
    for j in Station_list1:
        if j[1] not in Station_list2:
            Station_list2.append(j[1])
            Station_quchong_list.append(j[0])
            #去重Station_inf
            with open('./station_inf_quchong.txt', 'a') as fp:
                fp.write(j[0] + '\t' + j[1] + '\t' + '\n')
    # 用得到的去重后的站点再去获得其相应的lat,lon
    result = [item for item in station_list if item[0] in set(Station_quchong_list)]
    return result


# 读取文件信息
def read_station_info(path):
    with open(path, 'r', encoding='utf8') as fp:
        result_str = fp.read()
    return result_str


# 提取每站点位置的信息
def station():
    result_str = read_station_info('./latlon.txt')
    # print(result_list)
    station_list = []
    # 读取字符串通过\n分割再遍历，再通过\t分割每行数据中的每列数据，存入station_dict[站点序号]=(lat,lon)
    for i in result_str.split('\n')[1:-1]:
        i_list = i.split('\t')
        station_list.append([i_list[0], (float(i_list[2]), float(i_list[1]))])
    # print(station_dict)
    return station_list


# 计算输入两个站点位置距离
def cal_dist(lat1, lat2):
    return int(round(geodesic(lat1, lat2).miles, 3) * 1000)


if __name__ == '__main__':
    # 提取信息
    sta_list = station()
    # 去重
    sta_list=quchong(sta_list)
    for i in range(0, len(sta_list)):
        lat1 = sta_list[i]
        #当倒数第2个和倒数第一个比较完后，就退出循环['1327', (31.237245, 121.418989)] ['1623', (31.159221, 121.599723)]
        if i+1>=len(sta_list):
            break
        lat2 = sta_list[i + 1]
        with open('./result.txt','a') as fp:
            fp.write(lat1[0]+"\t"+lat2[0]+"\t"+str(cal_dist(lat1[1],lat2[1]))+"\n")
