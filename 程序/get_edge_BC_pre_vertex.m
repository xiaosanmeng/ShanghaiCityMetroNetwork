function [SA,Vertex_BC]=get_edge_BC_pre_vertex(SA,P,W,obj_vertex,Vertex_BC)
%calculate the edge's BC, whose endpoints are obj_vertex and pre_vertex in P.
%edge BC: SA(obj,pre)=(Vertex_BC(obj)+1)*W(pre)/W(obj).
%vertex BC:Vertex_BC(pre)=Vertex_BC(pre)+SA(obj,pre).

Pre_vertex = find(P(obj_vertex,:)>0);
Pre_v_num=nnz(Pre_vertex);

for i=1:Pre_v_num
    pre_vertex=P(obj_vertex,Pre_vertex(i));
    SA(obj_vertex,pre_vertex)=(Vertex_BC(obj_vertex)+1)*W( pre_vertex)/W(obj_vertex);
    Vertex_BC(pre_vertex)=Vertex_BC(pre_vertex)+SA(obj_vertex,pre_vertex);
end

return