function Shrink_Nodes=Shrink_Matrix(Nodes,Saved_ID)
%save vertices and edges shown in Saved_ID,transform Nodes to Shrink_Nodes
%Input: Nodes--N*N adjacent matrix
%       Saved_ID--Shrink_N*1 vector,Saved_ID(i) is the ID in Nodes which
%                 will be saved into Shrink_Nodes
%Output:Shrink_Nodes--Shrink_N*Shrink_N adjacent matrix
%Write by Rock on 07.09.13 for v2
%Write by Rock on 08.08.21 for v3

TEST=0;

if TEST==1
    Nodes(1:3,1)=1:3;
    Nodes(1:3,2)=1:3;
    Nodes(1:3,3)=1:3;
    Saved_ID=[2,3];
end

N=length(Nodes);
M=nnz(Nodes);

Shrink_N=length(Saved_ID);

inv_ID=zeros(N,1);
for i=1:Shrink_N
    inv_ID(Saved_ID(i))=i;
end

[Col,Row,Weight]=find(Nodes);

Shrink_Nodes=sparse(Shrink_N,Shrink_N);

%Shrink_Nodes=spconvert([inv_ID(Row),inv_ID(Col),inv_ID(Weight)]);
%for i=1:M
%    if inv_ID(Row(i))*inv_ID(Col(i))>0
%        Shrink_Nodes(inv_ID(Row(i)),inv_ID(Col(i)))=Weight(i);
%    end
%end

temp_ID=find(inv_ID(Row).*inv_ID(Col)>0);
%for i=1:length(temp_ID)
%    Shrink_Nodes(inv_ID(Row(temp_ID(i))),inv_ID(Col(temp_ID(i))))=Weight(temp_ID(i))
%end
Shrink_Nodes=spconvert([inv_ID(Row(temp_ID)),inv_ID(Col(temp_ID)),Weight(temp_ID)]);

Shrink_Nodes(Shrink_N,Shrink_N)=0;%spconvert可能改变网络的规模

return