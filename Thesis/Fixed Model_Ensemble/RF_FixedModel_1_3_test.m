%---Ensemble based on Decision Tree (5 models) (testing using 1/3 data)---%
%-------------------------------------------------------------------------%
[~,data]=xlsread('Main.xlsx');
dataset=cell2mat(data);
[m,n]=size(dataset);
index_row = randsample(1:m, 5416);
for k=1:5
    if k==1
        %index_row = randsample(1:m, 5416);
        index_col=[1 2 3 4 5 6 7];
        MatA = dataset(index_row,index_col);
        disp('Train')
        MatB=dataset(:,index_col);
        MatB(index_row,:)=[];
        disp('Test')
    elseif k==2
        %index_row = randsample(1:m, 5416);
        index_col=[1 6 8 9 10 21 22];
        MatA = dataset(index_row,index_col);
        disp('Train')
        MatB=dataset(:,index_col);
        MatB(index_row,:)=[];
        disp('Test')
    elseif k==3
        %index_row = randsample(1:m, 5416);
        index_col=[1 6 11 12 13 14 15];
        MatA = dataset(index_row,index_col);
        disp('Train')
        MatB=dataset(:,index_col);
        MatB(index_row,:)=[];
        disp('Test')
    elseif k==4
        %index_row = randsample(1:m, 5416);
        index_col=[1 4 14 19 20 22 23];
        MatA = dataset(index_row,index_col);
        disp('Train')
        MatB=dataset(:,index_col);
        MatB(index_row,:)=[];
        disp('Test')
    else
        %index_row = randsample(1:m, 5416);
        index_col=[1 4 17 18 20 22 23];
        MatA = dataset(index_row,index_col);
        disp('Train')
        MatB=dataset(:,index_col);
        MatB(index_row,:)=[];
        disp('Test')
    end
    
    %Separated class & attributes from train matrix
    [mA,nA]=size(MatA);
    MatC=MatA(:,2:nA);
    MatC = double(MatC);
    classname=MatA(:,1);
    classname = double(classname);
    
    %Separated  attributes from test matrix
    [mB,nB]=size(MatB);
    MatD=MatB(:,2:nB);
    MatD = double(MatD);
    
    %decision tree
    tree = fitctree(MatC,classname);
    view(tree,'mode','graph');
    for i = 1:size(MatD,1)
        res(i,1) = predict(tree,MatD(i,:));
   
    end
    ff(k).att=res; 
    final_c=res;
    %acc
    predict_class=char(final_c);
   real_class=(MatB(:,1));
   currect_classify=numel(find(real_class==predict_class)); %numel function gives number of element in a matrix
   accuracy=(currect_classify/numel(real_class))*100;
   sprintf('Accuracy of Model-%g : %.5g%% ',k,accuracy)
   miss_classify=2708-currect_classify;
   sprintf('Miss_classify: %g ',miss_classify)
end

%Random forest
for i=1:size(ff(1).att)
   %dd=[ff(1).att(i),ff(2).att(i),ff(3).att(i)];
   dd=[ff(1).att(i),ff(2).att(i),ff(3).att(i),ff(4).att(i),ff(5).att(i)];
   unique_value=unique(dd);
   if numel(unique_value)==1
       final_class(i)=unique_value;
   else
        [freq,value]=hist(dd,unique(dd));  %hist find frequency for value
        index=find(freq==max(freq));
        final_class(i)=value(index(1));
   end
   
end

%Accuracy
tt=dataset(:,index_col); %Testset
tt(index_row,:)=[];      %Testset
predict_class=char(final_class);
real_class=(tt(:,1));
currect_classify=numel(find(real_class==predict_class')) %numel function gives number of element in a matrix
accuracy=(currect_classify/numel(real_class))*100;
sprintf('Final Accuracy: %.15g%% ',accuracy)
miss_classify=2708-currect_classify;
sprintf('Final_Miss_classify: %g ',miss_classify)
