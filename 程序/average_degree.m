%求网络平均度

clear

%巴黎部分
fname='bali42'

Weight_Matrix=load([fname,'.txt']);

Row=zeros(length(Weight_Matrix(:,1)),1);
Row(1:end)=[Weight_Matrix(:,1)];
Col=zeros(length(Weight_Matrix(:,2)),1);
Col(1:end)=[Weight_Matrix(:,2)];
Weight=ones(length(Weight_Matrix(:,1)),1);

Topology_Nodes=spconvert([Row,Col,Weight]);

[Vertex_Component,Component_num]=IS_Connection(Topology_Nodes);%qiu lian tong kuai & lian tong kuai shu 
Comp_num=get_component_num(Vertex_Component,Component_num);
Select_ID=find(Vertex_Component==1);

Shrink_Nodes=Shrink_Matrix(Topology_Nodes,Select_ID);
Shrink_R=nnz(Shrink_Nodes);
Shrink_N=length(Shrink_Nodes);
kb=Shrink_R./Shrink_N


%上海部分
fname='sh5'

Weight_Matrix=load([fname,'.txt']);

Row=zeros(length(Weight_Matrix(:,1))*2,1);
Row(1:end)=[Weight_Matrix(:,1);Weight_Matrix(:,2)];
Col=zeros(length(Weight_Matrix(:,1))*2,1);
Col(1:end)=[Weight_Matrix(:,2);Weight_Matrix(:,1)];
Weight=ones(length(Weight_Matrix(:,1))*2,1);

Topology_Nodes=spconvert([Row,Col,Weight]);

[Vertex_Component,Component_num]=IS_Connection(Topology_Nodes);%qiu lian tong kuai & lian tong kuai shu 
Comp_num=get_component_num(Vertex_Component,Component_num);
Select_ID=find(Vertex_Component==1);

Shrink_Nodes=Shrink_Matrix(Topology_Nodes,Select_ID);
Shrink_R=nnz(Shrink_Nodes);
Shrink_N=length(Shrink_Nodes);
ks=Shrink_R./Shrink_N