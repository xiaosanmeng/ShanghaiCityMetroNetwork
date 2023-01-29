function [Distance,Predecessor,EdgeBC,VertexBC]=Get_Graph_BC(Nodes)
%calculate Graph Nodes's BC. Ref[Newman,Finding and evaluating community
%structure in networks]
%Input: Nodes -- n*n adjacent matrix with full format
%Output:Distance -- n*n matrix, Distance(i,j) is distance from i to j.
%       EdgeBC -- n*n matrix
%       VertexBC -- n*1 vector, saving each vertex's BC.
%Write by Rong zhihai on 05/06/08
%
%Calculate vertex BC according to VertexBC=(sum(edge_BC)/2+(n-1)) on 05.06.15
%
%Motified the define of vertex BC to: VertexBC=(sum(edge_BC)/2-(n-1)) on 05.06.23
%BC计算分为单向和双向，
%计算单向的[如A.Motter,Cascade control in complex networks, arXiv/0401074v1/Jan 2004]时候，
%edge BC 与 vertex BC的关系是：
%包含端点的vertex BC: g'(i)=( sum(edge_BC_i)+(n-1))/2=g(i)+(n-1);
%不包含端点的vertex BC: g(i)=g'(i)-(n-1)=( sum(edge_BC_i)-(n-1))/2;
%
%比如: 1<->2<->3:
%g(1)=g(3)=0,g(2)=1;
%g'(1)=g'(3)=2,g(2)=3;
%
%如果考虑双向[如Barthelemy : Betweenness centrality in large complex networks, The European Physical Journal B 38, 2004]
%则 上图中:
%g(1)=g(3)=0,g(2)=2;
%g'(1)=g'(3)=4,g(2)=6; 两者差了2倍!
%而vertex BC 与 edge BC的关系是:
%g'(i)=(edge_BC_i)/2 + (n-1) = 2(n-1)+g(i);
%[Barthelemy,E.B.38,2004,Eq.(8)],[D.Kim,PRL2001/278701-1按照这个定义计算BC-vertex]
%不包含端点的vertex BC g(i)与g'(i)的关系是: g(i)=g'(i)-2(n-1)=(edge_BC_i)/2 - (n-1)
%[Barthelemy,E.B.38,2004,按照这个定义计算BC-vertex]
%
%NOTE:
%通过Newman算法可以计算单向vertex-BC,但是,
%通过Newman论文不能够正确得到vertex_BC,因为每次对于顶点i，虽然它计算了其他n-1个
%点到i的BC(不包括终点)，但是作为源点的i,vertex_i=n-1,这是不对的，此次根据此累加
%得到的vertex_BC'是EdgeBC每一行的值，相差了(n-1)/2！！！
%Newman[Finding and evaluating community structure in networks]
%
%
%本程序计算双向 vertex BC
%including as follow 7 *.m functions and files:
%Get_Graph_BC();Get_vertex_BC.m();get_edge_BC_pre_vertex();
%create_queue(); enqueue_s_bc(); enqueue(); dequeue().

TEST=0;
if TEST==1    
    %[Newman, Fig4]
    Nodes=[0,1,1,0,0,0,0;1,0,0,1,0,0,0;1,0,0,1,1,0,0;0,1,1,0,0,1,0;0,0,1,0,0,1,1;0,0,0,1,1,0,0;0,0,0,0,1,0,0];
    %[Newman, Fig4]+(6<->7)
    %Nodes=[0,1,1,0,0,0,0;1,0,0,1,0,0,0;1,0,0,1,1,0,0;0,1,1,0,0,1,0;0,0,1,0,0,1,1;0,0,0,1,1,0,1;0,0,0,0,1,1,0];
    %[Newman, Fig4]+(7<->8)
    %Nodes=[0,1,1,0,0,0,0,0;1,0,0,1,0,0,0,0;1,0,0,1,1,0,0,0;0,1,1,0,0,1,0,0;0,0,1,0,0,1,1,0;0,0,0,1,1,0,0,0;0,0,0,0,1,0,0,1;0,0,0,0,0,0,1,0];
    %star network
    %Nodes=[0,0,0,0,0,0,1;0,0,0,0,0,0,1;0,0,0,0,0,0,1;0,0,0,0,0,0,1;0,0,0,0,0,0,1;0,0,0,0,0,0,1;1,1,1,1,1,1,0];
    %global connected network
    %Nodes=[0,1,1,1,1,1,1;1,0,1,1,1,1,1;1,1,0,1,1,1,1;1,1,1,0,1,1,1;1,1,1,1,0,1,1;1,1,1,1,1,0,1;1,1,1,1,1,1,0];
    %ring regular lattice
    %4 ring
    %Nodes=[0,1,0,1;1,0,1,0;0,1,0,1;1,0,1,0]
    %6 ring
    %Nodes=[0,1,0,0,0,1;1,0,1,0,0,0;0,1,0,1,0,0;0,0,1,0,1,0;0,0,0,1,0,1;1,0,0,0,1,0]
    %7 ring
    %Nodes=[0,1,0,0,0,0,1;1,0,1,0,0,0,0;0,1,0,1,0,0,0;0,0,1,0,1,0,0;0,0,0,1,0,1,0;0,0,0,0,1,0,1;1,0,0,0,0,1,0]
    %vertex BC: [1]<->[2]<->[3]
    %Nodes=[0,1,0;1,0,1;0,1,0];
end

%initialize
[n,n]=size(Nodes);

for i=1:n
    Nodes(i,i)=0;
end

SA=sparse(Nodes);


m=nnz(SA);
temp_SA_BC=zeros(m,3);
[row_obj,col_pre]=find(SA);
temp_SA_BC(:,1)=row_obj;
temp_SA_BC(:,2)=col_pre;
VertexBC=zeros(n,1);

Distance=zeros(n);
Predecessor=zeros(n);

%test_Vertex_BC=zeros(n,1);%delete on 05.06.15:
for i=1:n
    temp_SA=-SA;
    [D, W,P,temp_SA,temp_Vertex_BC] = Get_Vertex_BC(temp_SA, i);
    Distance(:,i)=D;
    Predecessor(:,i)=P;
    for j=1:m
        if temp_SA(row_obj(j),col_pre(j))>0
            temp_SA_BC(j,3)=temp_SA_BC(j,3)+temp_SA(row_obj(j),col_pre(j));
        end
    end
%    temp_Vertex_BC(i)=0;%delete on 05.06.15
%    test_Vertex_BC=test_Vertex_BC+temp_Vertex_BC;%delete on 05.06.15
    
    if TEST==2%测试程序正确性：与源点BC:n-1
        test2_i_neighbor=find(col_pre>=i & col_pre<(i+1) );
        test2_i_neighbor_num=nnz(test2_i_neighbor);
        test_i_BC(i)=0;
        for test_i=1:test2_i_neighbor_num
            test_i_BC(i) = test_i_BC(i) + temp_SA( row_obj(test2_i_neighbor(test_i)), i );%a bug!
        end
    end
    %i
end
%test_Vertex_BC=test_Vertex_BC/2;%delete on 05.06.15
if TEST==2
    test_i_BC
end

SA_BC=spconvert(temp_SA_BC); 
EdgeBC=full(SA_BC);

%双向Vertex_BC add on 05/07/12
%[D.Kim,PRL2001/278701-1按照这个定义计算BC-vertex]
%The load/Vertex BC g(k) of a vertex k includes N-1 packets leaving and another N-1
%packets arriving at the vertex.
%VertexBC(1:end)=( sum(EdgeBC(:,1:end)) + sum(EdgeBC(1:end,:)) )/2 + (n-1);
%[Barthelemy,E.B.38,2004,按照这个定义计算BC-vertex]
VertexBC(1:end)=( sum(EdgeBC(:,1:end)) + sum(EdgeBC(1:end,:)) )/2 - (n-1);

%单向:Vertex BC
%vertex BA calculates from edge vertex according to the formular in Ref[Cascade control in complex networks(Motter,2004)]
%col is vertex ID
%VertexBC(1:end)=( sum(EdgeBC(:,1:end)) +(n-1))/2;%add on 05.06.15
%VertexBC(1:end)=( sum(EdgeBC(:,1:end)) -(n-1))/2;


if TEST==1
    Distance
    Predecessor
    VertexBC
    EdgeBC
    %test_Vertex_BC
end

return