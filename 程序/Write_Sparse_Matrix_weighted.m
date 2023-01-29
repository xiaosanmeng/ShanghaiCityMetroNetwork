function Write_Sparse_Matrix_weighted(Nodes,filename)
%Input:N:full format;filename:saved file name.+.net
%for example:Write_into_Chen_C(Nodes,'test.net')
%write by Rock version 2 on 06/02/01

[Row,Col,Weight]=find(Nodes);
M=length(Row);

fid=fopen(filename,'w');

for i=1:M
    fprintf(fid,'%d %d %f\r\n',Col(i),Row(i),Weight(i));    
end

fclose(fid);
return