function Write_into_Pajek__weighted(Nodes,filename)
%Input:Nodes:full format;filename:saved file name.+.net
%for example:Write_into_Pajek(Nodes,'test.net')
%Pajek Outfile format:
%*Vertices  4000
%1 "m1"
%2 "m2"
%....
%*Arcs
%*Edges 6644
%1 2 weight
%..............
%
%Writed by Rock on 06/02/27 for version 2

TEST=0;

if TEST==1
    N=10;
    k=2;
    Nodes=Nearest_Neighbor_Growing(N,k);
    filename='test.net';
    for i=1:N
        Nodes(i,i)=0;
    end
end

N=length(Nodes);
[Row,Col,Weight]=find(Nodes);
M=length(Weight);

fid=fopen(filename,'w');
%print nodes
fprintf(fid,'*Vertices  %d\r\n',N);
for i=1:N
    fprintf(fid,'%d "m%d"\r\n',i,i);
end %end for 'i'
%print edges
%fprintf(fid,'*Edges  %d\r\n',nnz(Nodes)/2);%function nnz() return the number of non-zero elements in Nodes
fprintf(fid,'*Edges \r\n');

for i=1:M
    if Row(i)>=Col(i)
        fprintf(fid,'%d %d %f\r\n',Row(i),Col(i),Weight(i));
    end
end

%for i=1:Row
%    for j=1:Col%Warning:Col should be i,or edge will be count double,but writing Col will be very easy to load into Matlab~£¡~£¬no problem to display with Pajek
%    for j=1:i
%        if(Nodes(i,j)>0)%modified on 05/11/2
%            fprintf(fid,'%d %d %d\r\n',i,j,Nodes(i,j));
%        end %for if
%    end %end for'j'
%end %end for 'i'

fclose(fid);
return