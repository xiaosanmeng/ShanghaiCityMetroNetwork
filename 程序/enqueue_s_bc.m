function [q,d]=enqueue_s_bc(s,q,d,row,col)
%将图row-col中与顶点s相连的边放入队列q,并在v_in_q中标示
%注意进队列的条件!

s_t=find(col>=s & col<s+1);
[s_t_m,s_t_n]=size(s_t);
for i=1:s_t_m
    if d(row(s_t(i)))<0
        q=enqueue(q,[s,row(s_t(i))]);
        d(row(s_t(i)))=d(s)+1;
    elseif d(row(s_t(i))) == d(s)+1
        q=enqueue(q,[s,row(s_t(i))]);
    end
end

return;