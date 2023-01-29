function [new_q,v]=dequeue(q)
%function [q,v]=dequeue(q)
%出队列函数，如果q=[0,0]说明为空队列
%Input:q:n*2 matrix
%Output:q:n-1*2 matrix
%       v:1*2 vextor
%Writed by rong zhihai on 05/02/06

%[m,n]=size(find(q(1:end,1))>0);
[m,n]=size(q);

v(1,:)=q(1,:);

if m==1
    new_q=zeros(1,2);
%    q=zeros(1,2);
else
    %删除第一行
    new_q=zeros(m-1,n);
    new_q(1:m-1,:)=q(2:m,:);  
%    q(1:m-1,:)=q(2:m,:);    
%    q(m,:)=0;
end

return