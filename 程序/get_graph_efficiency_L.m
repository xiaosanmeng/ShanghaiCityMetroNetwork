function [E,L,D]=get_graph_efficiency_L(Nodes)
%calculating the efficiency by ref.[Economic Small-World Behavior in
%Weighted Networks,Vito Latora,03]

[N,N]=size(Nodes);

inf_num=1e8;

for i=1:N
    Nodes(i,i)=0;
end

S_Nodes=sparse(Nodes);
Distance_V=zeros(N,1);
Predecessor_V=zeros(N,1);
E=0;
L=0;
D=0;

for i=1:N
    [DD,PP]=Dijkstra(S_Nodes,i);
    L=L+sum(DD);
    temp_D=max(DD);
    if D<temp_D
        D=temp_D;
    end
    DD(i)=inf_num;
    div_DD=1./DD;
    temp_E=sum(div_DD(find(div_DD>(1/inf_num))));
    E=E+temp_E;
end

E=E/(N*(N-1));
L=L/(N*(N-1));

return