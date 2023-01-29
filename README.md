
***software ver：MATLAB R2012a x86***

***Vmware17 system iso ver: Windows10pro x86***

github:

download matlab R2012a

## 在matlab运行程序test_12_26.m



### 1.Shrink_Matrix 中 Saved_ID 的含义
matlab报错：Select_ID缺少定义
```
Undefined function or variable 'Select_ID'.

Error in test_12_26 (line 21)
Shrink_Nodes=Shrink_Matrix(Topology_Nodes,Select_ID);
```
test_12_26.m相关代码段
```
fname='sh1';

Weight_Matrix=load([fname,'.txt']);

Row=zeros(length(Weight_Matrix(:,1))*2,1);

Row(1:end)=[Weight_Matrix(:,1);Weight_Matrix(:,2)];

Col=zeros(length(Weight_Matrix(:,1))*2,1);

Col(1:end)=[Weight_Matrix(:,2);Weight_Matrix(:,1)];

Weight=ones(length(Weight_Matrix(:,1))*2,1);

Topology_Nodes=spconvert([Row,Col,Weight]);

[Vertex_Component,Component_num]=IS_Connection(Topology_Nodes);%?????????????????? 

Comp_num=get_component_num(Vertex_Component,Component_num);
 
Shrink_Nodes=Shrink_Matrix(Topology_Nodes,Select_ID);


```

追加Select_ID相关定义，根据Shrink_Matrix函数中的属性
```
%save vertices and edges shown in Saved_ID,transform Nodes to 
Shrink_Nodes

%Input: Nodes--N*N adjacent matrix

%       Saved_ID--Shrink_N*1 vector,Saved_ID(i) is the ID in Nodes which

%                 will be saved into Shrink_Nodes

%Output:Shrink_Nodes--Shrink_N*Shrink_N adjacent matrix
```

Shrink_ID即函数内Saved_ID意为 **压缩N*1 向量，Saved_ID（i） 是节点中的 ID，其中将被保存到Shrink_Nodes**

故在test_12_26.m 加入Select_ID定义赋值，根据sh1.text有效列数为76添加

```
Select_ID=[1:76];
```




### 2.Cannot find an exact (case-sensitive) match for 'Dijkstra
```
Cannot find an exact (case-sensitive) match for 'Dijkstra'

The closest match is: dijkstra
in C:\Users\tianyu\Desktop\毕业设计\上海\程序\dijkstra.dll改为dDjkstra.dll
```

将dijkstra.dll改为Dijkstra.dll后同时报错
```
Cannot find an exact (case-sensitive) match for 'dijkstra'

The closest match is: Dijkstra
in C:\Users\tianyu\Desktop\毕业设计\上海\程序\Dijkstra.dll
```

将IS_Connection中dijkstra相关代码改为大写


```
while nnz(Vertex_Component==0)>0

    ID=find(Vertex_Component==0);

    [Vertex_D,Vertex_P]=Dijkstra(S_Nodes,ID(1));

    Component_ID=Component_ID+1;

    for i=1:N

        if Vertex_D(i)<100000000%100000000 set in funciton dijkstra, 
denote seperation!

            Vertex_Component(i)=Component_ID;

        end

    end

end


```
警告信息
```
Warning: Calling MEX-file 'C:\Users\tianyu\Desktop\毕业设计\上海\程序\Dijkstra.dll'.
MEX-files with .dll extensions will not execute in a future version of MATLAB. 
```
查询相关资料，dll相关文件在matlab2014尚可以使用，目前版本为2012




### 3.Cannot find an exact (case-sensitive) match for 'Get_vertex_BC'
同（2），相关大小写问题

```
Cannot find an exact (case-sensitive) match for 'Get_vertex_BC'

The closest match is: Get_Vertex_BC
in C:\Users\tianyu\Desktop\毕业设计\上海\程序\Get_Vertex_BC.m

```

更改代码
```
for i=1:n
    temp_SA=-SA;
    [D, W,P,temp_SA,temp_Vertex_BC] = Get_vertex_BC(temp_SA, i);
    Distance(:,i)=D;
    Predecessor(:,i)=P;
    for j=1:m
        if temp_SA(row_obj(j),col_pre(j))>0
            temp_SA_BC(j,3)=temp_SA_BC(j,3)+temp_SA(row_obj(j),col_pre(j));
        end
    end
```
其中代码
```
    [D, W,P,temp_SA,temp_Vertex_BC] = Get_vertex_BC(temp_SA, i);
```
改为
```
    [D, W,P,temp_SA,temp_Vertex_BC] = Get_Vertex_BC(temp_SA, i);
```

### 成功运行 得到数据
#### 输入:sh1中内容
[![屏幕截图 2023-01-29 194612.png](https://img1.imgtp.com/2023/01/29/IEfQr17e.png)](https://img1.imgtp.com/2023/01/29/IEfQr17e.png)
[![屏幕截图 2023-01-29 194647.png](https://img1.imgtp.com/2023/01/29/1loBHVGp.png)](https://img1.imgtp.com/2023/01/29/1loBHVGp.png)
#### 输出：
![1674992603040.png](https://img1.imgtp.com/2023/01/29/3POOlsyQ.png)
![屏幕截图 2023-01-29 194213.png](https://img1.imgtp.com/2023/01/29/wkSZoMLk.png)
