function Comp_num=get_component_num(Vertex_Component,Component_num)
%Input
%Vertex_Component -- N*1 vector
%Component_num -- component num
%Output:
%Comp_num -- Component_num*1 vecotr
%
%Write by Rock on 06.06.15

N=length(Vertex_Component);
Comp_num=zeros(Component_num,1);

for i=1:Component_num
     Comp_num(i)=nnz(find(Vertex_Component==i));
end

return