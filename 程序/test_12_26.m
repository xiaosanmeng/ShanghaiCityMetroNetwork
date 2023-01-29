%上海网络拓扑建模及分析main函数
clear
close

fname='sh1';
Weight_Matrix=load([fname,'.txt']);

Row=zeros(length(Weight_Matrix(:,1))*2,1);
Row(1:end)=[Weight_Matrix(:,1);Weight_Matrix(:,2)];
Col=zeros(length(Weight_Matrix(:,1))*2,1);
Col(1:end)=[Weight_Matrix(:,2);Weight_Matrix(:,1)];
Weight=ones(length(Weight_Matrix(:,1))*2,1);

Topology_Nodes=spconvert([Row,Col,Weight]);

[Vertex_Component,Component_num]=IS_Connection(Topology_Nodes);%求连通块及连通块数 
Comp_num=get_component_num(Vertex_Component,Component_num);
Select_ID=[1:76];


Shrink_Nodes=Shrink_Matrix(Topology_Nodes,Select_ID);

[Vertex_Component,Component_num]=IS_Connection(Shrink_Nodes);
Comp_num=get_component_num(Vertex_Component,Component_num);
Select_ID(Vertex_Component==2);

[E,L,D]=get_graph_efficiency_L(Shrink_Nodes);

[Distance,Predecessor,EdgeBC,VertexBC]=Get_Graph_BC(Shrink_Nodes);
[BC_Val,BC_ID]=sort(VertexBC);

N=length(Shrink_Nodes)%节点数
L%平均路径长度Vertex_Component
D%直径

%max(max(Distance))
[a,b]=find(Distance==max(max(Distance)))
[Select_ID(a),Select_ID(b)]%直径的端点编号

Comp_num
Select_ID(find(Vertex_Component==2))

Select_ID(BC_ID(end-2:end))
BC_Val(end-2:end)%BC值前三的站点

%[E,L,D,Vertex_IC,Vertex_OP]=get_vertex_OP_IC(Shrink_Nodes,3);
%[IC_Val,IC_ID]=sort(Vertex_IC);

%Select_ID(IC_ID(end-2:end))
%IC_Val(end-2:end)

Degree=full(sum(Shrink_Nodes(1:end,:)));
[Degree_Val,Degree_ID]=sort(Degree);
Select_ID(Degree_ID(end-2:end))
Degree_Val(end-2:end)%度前三的站点

figure
hold on
plot(Degree,VertexBC,'ro')
xlabel('degree')
ylabel('BC')

%求网络度分布
%Dg=zeros(8,1);
%for i=1:8
%   for j=1:299
%        if Degree_Val(j)==i 
%            Dg(i)=Dg(i)+1;
%        end
%    end
%end
%Dg=Dg./299;
%t=1:1:8;
%plot(t,Dg,'ro')


[cc,Node_CC,triangles]=get_clustering_coefficient_fast(Shrink_Nodes);
cc%网络的聚类系数
triangles%网络中的三角形

Write_Matrix(Shrink_Nodes,[fname,'_test'])