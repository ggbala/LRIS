function p=accselection(a)
l=length(a);
p=randperm(l);
p1=zeros(l/2,1);
p2=zeros(l/2,1);
for i=1:l/2
    if a(p(2*i-1))<a(p(2*i))
        p1(i)=p(2*i);
        p2(i)=p(2*i-1);
        
    else
        p1(i)=p(2*i-1);
        p2(i)=p(2*i);
    end
    
end
p=[p1;p2];
end