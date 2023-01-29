function [Vertex_Component,Component_num]=IS_Connection(Nodes)
%connection junction
%Input: Nodes -- N*N adjacent matrix
%Output: Vertex -- N*1 vector, vertices in the same component are flagged as the same ID.
%        Component_num -- the seperated component number of Nodes
%Write by Rong Zhihai on 05/06/12

TEST=0;
if TEST==1
    Nodes=[0,1,1,0,0,0;1,0,1,0,0,0;1,1,0,0,0,0;0,0,0,0,1,1;0,0,0,1,0,1;0,0,0,1,1,0];
end

[N,N]=size(Nodes);

%for i=1:N
%    Nodes(i,i)=0;
%end
Vertex_Component=zeros(N,1);
Vertex_D=zeros(N,1);
Vertex_P=zeros(N,1);

S_Nodes=sparse(Nodes);

Component_ID=0;
while nnz(Vertex_Component==0)>0
    ID=find(Vertex_Component==0);
    [Vertex_D,Vertex_P]=Dijkstra(S_Nodes,ID(1));
    Component_ID=Component_ID+1;
    for i=1:N
        if Vertex_D(i)<100000000%100000000 set in funciton dijkstra, denote seperation!
            Vertex_Component(i)=Component_ID;
        end
    end
end
Component_num=max(Vertex_Component);

if TEST==1
    Vertex_Component
    Component_num    
end

return