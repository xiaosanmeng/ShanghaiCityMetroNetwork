function [cc,Node_CC,triangles]=get_clustering_coefficient_fast(Nodes)
%This progrom is to calculate the clustering coefficient of graph in Nodes.
%The clustering coefficient is defined in Newman Review[2003] IIIB.Eq.(5)(6)
%Ci=number of triangles connedted to vertex i/number of triples contered on vertex i
%C=sum(Ci)/n

%Input:Nodes--N*N matrix, saving the information graph with adjacent matrix
%             if nodes_attribute=1, or adjacent list if nodes_attribute=2.
%             Default value is nodes_attribute=1.NO Care of Nodes(i,i)
%Output:cc--reture the clustering coefficient of Nodes
%       Node_CC -- N*1 vector, saving each node's clustering, if Degree(i)=0 or 1, Nodes_CC(i)=0
%Writed by Rong zhihai on 05/03/16
%Add sparse matrix on 05/08/16
%Rewrite this function by fast algrithem on 07.10.29

%clear

TEST=0;
if TEST==1    
    tic
    N=5;
    Nodes=[0,1,1,0,0;1,0,1,0,0;1,1,0,1,1;0,0,1,0,0;0,0,1,0,0];%the example in Newman Review[03],Fig 5
    N=2000;
    Nodes=Nearest_Neighbor_Growing(N,5);
    t=toc

    tic
end

N=length(Nodes);
M=nnz(Nodes);

[Row,Col,Weight]=find(Nodes);
Weight(1:end)=1;
temp_Nodes=spconvert([Row,Col,Weight]);%for weighted network

Node_CC=zeros(N,1);
Degree=zeros(N,1);

%for i=1:N
%    Degree(i)=nnz(Nodes(i,:));
%end
Degree=full(sum(temp_Nodes(1:end,:)));
    


base_neighbor=1;

all_triangle_num=0;
for i=1:N
    triangle_num=0;
    Neighbor_num=Degree(i);
    if Neighbor_num>=2
        Neighbor=zeros(Neighbor_num,1);
        Neighbor(1:Neighbor_num)=Row(base_neighbor:base_neighbor+Neighbor_num-1);
    end
    base_neighbor=base_neighbor+Neighbor_num;

    if Neighbor_num==0||Neighbor_num==1
        Node_CC(i)=0;     
    else
        triple_num=Neighbor_num*(Neighbor_num-1)/2;
        for j=1:(Neighbor_num-1)%neighbor 1
            for k=(j+1):Neighbor_num%neighbor 2
                if Nodes(Neighbor(j),Neighbor(k))>0
                    triangle_num=triangle_num+1;
                end
                if Nodes(Neighbor(j),Neighbor(k))&&Nodes(i,Neighbor(k))&&Nodes(i,Neighbor(j))
                    if Neighbor(j)>=i                       
                        all_triangle_num=all_triangle_num+1;
                        triangles(all_triangle_num,:)=[i,Neighbor(j),Neighbor(k)];
                    end
                 else
                        all_triangle_num=all_triangle_num+1;
                        triangles(all_triangle_num,:)=[0,0,0];
                end
            end
        end%j=1:node_degree
        Node_CC(i)=triangle_num/triple_num;
    end%node_degree             
end

%求出网络中的三角形
if nnz(triangles)==0
    triangles=0;
else
    triangles(all(triangles==0,2),:)=[];
end
%triangles
cc=sum(Node_CC)/N;
if TEST==1;
   t=toc
    cc
end

return