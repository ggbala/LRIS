function [f,model]=qifaeva(population,trainx)
        
        %population为一个种群个体
        %trainx为训练集
        %vlabel为验证集得标签，vilidation_set为验证集
        f=zeros(size(population,1),2);
        
        [m1,n1]=size(population);
        model=cell(m1,1);
        [~,x]=size(trainx);
        label=trainx(:,x);
        model1=cell(1,1);
        for i=1:1:m1

            if sum(population(i,:))==0
                f(i,1)=0;
                f(i,2)=0;
            else
            
            Cpop1 = population(i,:);
            Cpop1 = logical(Cpop1);
           
            train_m=trainx(Cpop1,:);
          
            train_label=label(Cpop1,:);
       
            model1=svmtrain(train_label,sparse(train_m(:,1:x-1)));
           
            
            [~, acc, ~] =svmpredict(trainx(:,x), sparse(trainx(:,1:x-1)), model1);
            red=1-sum(population(i,:))/n1;
            f(i,1)=acc(1)/100;
            f(i,2)=red;
            model{i,1}=model1;
            end
        end
 end