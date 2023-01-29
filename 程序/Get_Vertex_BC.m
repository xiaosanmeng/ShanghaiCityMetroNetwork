function [D, W,PP,SA,Vertex_BC] = Get_vertex_BC(SA, s)
%calculate the BC of  vertex s. Ref(Newman,Finding and evaluating community
%structure in networks)
%Input:SA -- n*n adjacent matrix with sparse format,every element is 0 or -1.
%      s  -- label of source node.
%Output:D -- n*1 vector, each element is distance to s.
%       W -- n*1 vector, each element is the times that shortest path whose
%            source is s pass through
%       SA --m*1 vector as sparse format, saving BC of each edge whose source is s. 
%       Vertex_BC--n*1 vector, saving BC of each vertex whose sourse is s.

TEST=0;

if TEST==1
    A=-[0,1,1,0,0,0,0;1,0,0,1,0,0,0;1,0,0,1,1,0,0;0,1,1,0,0,1,0;0,0,1,0,0,1,1;0,0,0,1,1,0,0;0,0,0,0,1,0,0];
    SA=sparse(A);
    s=1;
end

[row_obj,col_pre]=find(SA);
[n,temp]=size(SA);

D=-ones(n,1);%each vector's distance to s
W=zeros(n,1);%each vctor's weight 
%P=zeros(n,30);%each vector's predecessor vector
%P=zeros(n,1);%可以自动分配P的列数
P=zeros(n,ceil(n/5));
PP=zeros(n,1);
Order=-ones(n,1);%the order that each vector outputs from queue. 

%initial
W(s)=1;
D(s)=0;
i=0;%order
Order(s)=i;
%Cope with every vertex i adjacent to s
Q=create_queue(n);
[Q,D]=enqueue_s_bc(s,Q,D,row_obj,col_pre);
%calculate the distance and weight of each vector to s
while Q(1,1)~=0
    [Q,edge]=dequeue(Q);
    if Order(edge(1,2))<0
        i=i+1;
        Order(edge(1,2))=i;
    end
    W(edge(1,2))=W(edge(1,2))+1;
    if nnz(P(edge(1,2),:)==edge(1,1))==0
        P(edge(1,2) ,(nnz(P(edge(1,2),:))+1) )=edge(1,1);
    end
    [Q,D]=enqueue_s_bc(edge(1,2),Q,D,row_obj,col_pre);
end
PP=P(:,1);

%claculate each edge's BC to s according to W 
%calculate each vector's BC according to Order
Vertex_BC=zeros(n,1);
%claculate other edge's BC
for i=1:(n-1)
    obj_vertex=find(Order==(n-i));
    [SA,Vertex_BC]=get_edge_BC_pre_vertex(SA,P,W,obj_vertex,Vertex_BC);
end

%s
%Vertex_BC
%SA
return