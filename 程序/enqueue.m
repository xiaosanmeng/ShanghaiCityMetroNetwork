function q=enqueue(q,v)
%入队列函数，q=[0,0]说明为空队列
%将v加入到队列q中.
%Input:q:n*2矩阵，含有n个元素，[s1,t1;s2,t2;...;sn,tn]
%      v:1*2矩阵，新加入的元素
%Output:q:(n+1)*2矩阵,[s1,t1;s2,t2;...;sn,tn;v]
%Writed by rong zhihai on 04/02/06

%test
%q=[0,0];
%v=[1,2];

%[m,n]=size(find(q(1:end,1))>0);
[m,n]=size(q);

if q(1,:)==[0,0]%空队列
    q(1,:)=v(1,:);
else
    q(m+1,:)=v(1,:);
end

return;