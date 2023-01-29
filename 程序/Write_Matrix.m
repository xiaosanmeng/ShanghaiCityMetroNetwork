function Write_Matrix(Nodes,fname)
%saving Nodes as .adj and .net

N=length(Nodes);

for i=1:N
    Nodes(i,i)=0;
end

Write_Sparse_Matrix(Nodes,[fname,'.adj']);
Write_into_Pajek(Nodes,[fname,'.net']);


return