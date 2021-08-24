function [FrontNO,MaxFNO] = F_NDSorts(ifvaule)
[n,~]=size(ifvaule);
FrontNO=zeros(1,n);
indices=zeros(1,n);
np=zeros(1,n);
fn=zeros(1,n);
for i=1:n
    for j=1:n
        if i~=j
           if ifvaule(i,1)<=ifvaule(j,1)
                if ifvaule(i,2)<ifvaule(j,2)
                   indices(i)=1;
                   np(i)=np(i)+1;
                end
           end
           if ifvaule(i,1)<ifvaule(j,1)
                if ifvaule(i,2)<=ifvaule(j,2)
                   indices(i)=1;
                   np(i)=np(i)+1;
                end
           end
        end
    end
    if np(i)==0
        FrontNO(i)=1;
        fn(1)=fn(1)+1;
    end
end
MaxFNO=1;

while sum(indices)~=0
    MaxFNO=MaxFNO+1;
    for i=1:n
        if indices(i)==1
           
   
            np(i)=np(i)-sum(fn(:,1:MaxFNO-1));
        
            if np(i)<=0
                FrontNO(i)=MaxFNO;
                indices(i)=0;

                fn(MaxFNO)=fn(MaxFNO)+1;
            end
        end
    end
end
s=0;
MaxFNO=1;
for i=1:20
    s=s+sum(MaxFNO==FrontNO);
    if s>50
        break;
    end
    MaxFNO=MaxFNO+1;
end

end