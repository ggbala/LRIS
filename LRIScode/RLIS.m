function CIS_RLIS(aa,duli)
% aa means the order of dataset e.g.:aa=1 means that we use the first
% dataset

% the dataset was divided into five folds, e.g.:the dataset 'wdbc' was
% divided into  five folds, in the first fold, the training set is '1n1ftr',the
% test set is '1n1fte',in the second fold, the training set is '1n2ftr',the
% test set is '1n2fte',
%
r= 3;

Gmax=95;
tic;
% r=2;
rr=zeros(r,1);
rr1=zeros(r,1);
for i=1:r
    rr(i,1)=i*ceil(Gmax/(r+1));
    rr1(i,1)=rr(i,1)+ceil(rr(1,1)/2);
end
addpath(genpath('C:\Program Files\MATLAB\R2018b\bin\libsvm-3.22\matlab')); 
% n=24;%种群大小
% p=5;%子集的个数
n=100;

poptrain = {};
poptest = {};
popconverge = {};
time = {};
for dulix = 1 : duli
tic
for kk=1:5            %5折交叉
    shoulian=[];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--------------------------------------------收敛度量
    trainsetf=['E:\Codes\dataset\',int2str(aa),'n',int2str(kk),'f','tr.txt'];% read the data set,in this line,we read the kk-th flod training set in aa-th dataset 
    testsetf=['E:\Codes\dataset\',int2str(aa),'n',int2str(kk),'f','te.txt'];% read the data set,in this line,we read the kk-th flod test set in aa-th dataset 
    trainset=importdata(trainsetf);
    testset=importdata(testsetf);
    testlabal=testset(:,end);
    testset(:,end)=[];
    [tsize,m]=size(trainset);
    distance=pdist2(trainset(:,1:end-1),trainset(:,1:end-1));
    distance(logical(eye(size(distance))))=inf;
    kdd=exishou(trainset,distance,ones(1,tsize),tsize);
    population=zeros(n,tsize);
    setcode=ones(n,tsize);
% for k=1:n
%     d=normrnd(0,0.3);
%     for j=1:tsize
%         
%             if rand()<0.5*abs(d)
%                 population(k,j)=1;
%             else
%                 population(k,j)=0;
%             end
%      end
%        
% end
% 
%      [functionvalue1,~]=qifaeva(population,trainset);  
%      [FrontNo,~] = F_NDSort(functionvalue1);                             %非支配排序
%     
%      CrowdDis = CrowdingDistance(functionvalue1,FrontNo);
    functionvalue1=zeros(n,2);
    FrontNo=ones(1,n);
    CrowdDis=ones(1,n);
               
    functionvalue1(:,1)=0;
    functionvalue1(:,2)=1;

    
    for tt=1:Gmax %------------------------------------------------------------------------------------start
        
        newpopulation=zeros(n,tsize);  %子代种群
        newsetcode=zeros(n,tsize);
        MatingPool= TournamentSelection(2,2*n,FrontNo(1,:),-CrowdDis(1,:));
      
        pm1=0.01;
        pm0=0.01 ;
            for i=1:n/2                  %交叉产生子代
                p1=MatingPool(i);
                p2=MatingPool(n+i);
                newpopulation(i*2-1,:)=population(p1,:);
                newpopulation(i*2,:)=population(p2,:);
                
                newpopulation(i*2,setcode(p2,:)==0)=0;
                newpopulation(i*2-1,setcode(p1,:)==0)=0;
                r1=rand(1,tsize)<0.5;
                ex1=newpopulation(i*2-1,r1);
                ex2=newpopulation(i*2,r1);
                newpopulation(i*2,r1)=ex1;
                newpopulation(i*2-1,r1)=ex2;
         
                l1=newpopulation(i*2,:)==1;
                l2=newpopulation(i*2,:)==0;
                r1=rand(1,length(l1))<pm1;
                newpopulation(i*2,r1&l1)=0;
                r1=rand(1,length(l1))<pm0;
                newpopulation(i*2,r1&l2)=1;

                
                l1=newpopulation(i*2-1,:)==1;
                l2=newpopulation(i*2-1,:)==0;
                r1=rand(1,length(l1))<pm1;
                newpopulation(i*2-1,r1&l1)=0;
                r1=rand(1,length(l1))<pm0;
                newpopulation(i*2,r1&l2)=1;
                
                newsetcode(i*2-1,:)=setcode(p1,:);
                newsetcode(i*2,:)=setcode(p2,:);

          
            end
    p1=newpopulation&newsetcode;
    [functionvalue2,~]=qifaeva(p1,trainset);
    newpopulationl=[population;newpopulation]   ;                            %合并父子种群  
    functionvalue=[functionvalue1;functionvalue2];

    [FrontNo1,MaxFNo] =  F_NDSort(functionvalue);                           %非支配排序
    Next = FrontNo1 < MaxFNo;
    CrowdDis1 = CrowdingDistance(functionvalue,FrontNo1);
    Last     = find(FrontNo1==MaxFNo);
    [~,Rank] = sort(CrowdDis1(Last),'descend');
    Next(Last(Rank(1:n-sum(Next)))) = true;
    Next=Next';
    population=newpopulationl(Next,:);
    setcode1=[setcode;newsetcode];
    setcode=setcode1(Next,:);
    functionvalue1=functionvalue(Next,:);
    CrowdDis(1,:)=CrowdDis1(Next');
    FrontNo(1,:)=FrontNo1(Next');
        
    %----------------------------------------------------------------------
    if size(find(rr==tt),1)~=0 %reduce
            p=population&setcode;

            tongji=zeros(tsize,1);%统计
            for k=1:tsize
                    tongji(k,1)=sum(p(:,k))/n;
            end
            %kdd=exishou(trainset,distance,setcode(i,:),tsize);
            a=0.5;
            kdd1=zeros(1,tsize);
            for j=1:tsize
                             
                    kdd1(j)=(1-a)*kdd(j)+a*(tongji(j,1)); 
               
            end
            s=kdd1;
           [~,p]=sort(functionvalue1(:,1),'descend');
     
           for i=1:n

                dr=unifrnd (0,1)*(i/n-1/n);
                
%                 dr=0.5;
                l=sum(setcode(p(i),:));
              
                for del=1:floor(l*dr) %删点
                    rs=randperm(sum(setcode(p(i),:)));
                    dele=find(setcode(p(i),:));
                    dele1=dele(rs(1));
                    dele2=dele(rs(2));
                    if s(dele1)>s(dele2)
                        setcode(p(i),dele2)=0;
                    else
                        setcode(p(i),dele1)=0;          
                    end
                end
                populationeva=population(p(i),:)&setcode(p(i),:);
%                 pp=functionvalue1(p(i+n/2),:)
                [functionvalue1(p(i),:),~]=qifaeva(populationeva,trainset);
%                 pp=functionvalue1(p(i+n/2),:)
            end      
            
    end
    %----------------------------------------------------------------------
    if size(find(rr1==tt),1)~=0 %repair
        
        p=accselection(functionvalue1(:,1));
        for i=1:n/2
            p1=p(i);
            p2=p(i+n/2);
            
            for j=1:tsize
                if setcode(p2,j)==0 && setcode(p1,j)==1
                    setcode(p2,j)=1;
                    population(p2,j)=0;
                    
                end
            end
        end
       
    end
    %----------------------------------------------------------------------
   popconverge{dulix,kk,tt} = functionvalue1;
    end
    poptrain{dulix,kk} = functionvalue1;
    ptest = zeros(n,2);
    for ii = 1 : n
        [~,model]=qifaeva(population(ii,:),trainset);
        [~,acc,~]=svmpredict(testlabal, sparse(testset), model{1});
        ptest(ii,1) = acc(1)/100;
        ptest(ii,2) = functionvalue1(ii,2);
    end
    poptest{dulix,kk} = ptest;

 end
toc
time{dulix} = toc;
    
end
filename = ['dataset\','RLIS_',int2str(aa),'.mat'];
save(filename,'popconverge','poptest','time','poptrain');
% save the results, popconverge is the populations in each iteration ,poptest is the final popolation funcation values on test set
%poptrain  is the final popolation funcation values on traning set
end