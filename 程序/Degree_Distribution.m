%Degree Distribution
Dg=zeros(8,1);
for i=1:8
   for j=1:N
        if Degree_Val(j)==i 
            Dg(i)=Dg(i)+1;
        end
    end
end
Dg=Dg./N;
t=1:1:8;
plot(t,Dg,'bo')