function kdd=exishou(trainset,distance,setcode,tsize)
    kdd=zeros(tsize,1);
    distance(~logical(setcode'),:)=inf;
    distance(:,~logical(setcode))=inf;

        for j=1:tsize
            if setcode(j)~=0
                distance(j,j)=inf;
                lab=trainset(j,end);
                l=logical(trainset(:,end)==lab);
                p1=distance(l,j);
                l1=logical(trainset(:,end)~=lab);
                p2=distance(l1,j);
             
                kdd(j)=min(p1)-min(p2);
            else
                kdd(j)=inf;
            end
%             for k=1:kk
%                 [~,m]=min(distance(j,:,i));
%                
%                 kdd(j,k,i)=distance(j,m,i);
%                 if trainset(m,end)~=lab
%                  
%                     kdd(j,k,i)= kdd(j,k,i)*1.5;%*(1+exp(-kdd(j,k,i)));
%                 end
%                 distance(j,m,i)=inf;
%             end
        end
        for j=1:tsize
            kdd(j)=kdd(j)+abs(min(kdd));
        end
        m=max(kdd(kdd(:)~=inf));
        for j=1:tsize
            if kdd(j)~=inf
                kdd(j)=kdd(j)/m;
            end
        end
end