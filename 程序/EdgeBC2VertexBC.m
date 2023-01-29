function VertexBC=EdgeBC2VertexBC(EdgeBC, flag)
%function VertexBC=EdgeBC2VertexBC(EdgeBC)
%
%Input: EdgeBC -- N*N matrix,EdgeBC(i,j) is this edge's BC
%       flag -- if flag==1,VertexBC(1:end)=( sum(EdgeBC(:,1:end)) + sum(EdgeBC(1:end,:)) )/2 - (n-1);
%               elseif VertexBC(1:end)=( sum(EdgeBC(:,1:end)) + sum(EdgeBC(1:end,:)) )/2 + (n-1);
%Output: VertexBC -- N*1 vector
%
%Write by rock on 06/04/29

TEST=1;
if TEST==1
    %EdgeBC=[0,1,0;1,0,1;1,0,0]
    fname='2'
    EdgeBC=spconvert(load([fname,'.edgeBC']));
    flag=1
end

N=length(EdgeBC);
M=nnz(EdgeBC);

VertexBC=zeros(N,1);

[Row,Col,Weight]=find(EdgeBC);

for i=1:M
    VertexBC(Row(i))=VertexBC(Row(i))+Weight(i);
    VertexBC(Col(i))=VertexBC(Col(i))+Weight(i);
end


if flag==1
    VertexBC=(VertexBC/2)-(N-1);    
elseif flag==2
    VertexBC=(VertexBC/2)+(N-1);    
end

if TEST==1
    VertexBC
end

return