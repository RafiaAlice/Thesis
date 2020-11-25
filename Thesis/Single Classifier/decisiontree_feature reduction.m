%%%%%%1/3 test

     %Input train data file(fixed)
     [~,fileread2] = xlsread('Main.xlsx');
     Dataset = cell2mat(fileread2);
     [m,n]=size(Dataset);
     index_row = randsample(1:m, 5416);
     index_col= [1 5 7 8 20 21];
     MatA=Dataset(index_row,index_col);
     classname=MatA(:,1);
     disp('Train')
     MatB=Dataset(:,index_col);
     MatB(index_row,:)=[]; %%% 1/3 test;
    
     %Input test data file(give)
%     [filename2 pathname2] = uigetfile({'*.xlsx'}, 'File selector');
%     file2 = strcat(pathname2, filename2);
%     [~,fileread2] = xlsread(file2);
%     MatB = cell2mat(fileread2);
%     disp('Test')

%      %Input test data file(fixed)
%      [~,fileread2] = xlsread('Main.xlsx');
%      MatB = cell2mat(fileread2);
%      disp('Test')
    
    %Separated class & attributes from train matrix
    [mA,nA]=size(MatA);
    MatC=MatA(:,2:nA);
    MatC = double(MatC);
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
    final_class=res;
    %ff(k).att=res;  
%end

% %Random forest
% for i=1:size(ff(1).att)
%    dd=[ff(1).att(i),ff(2).att(i),ff(3).att(i)];
%    %dd=[ff(1).att(i),ff(2).att(i),ff(3).att(i),ff(4).att(i),ff(5).att(i)];
%    unique_value=unique(dd);
%    if numel(unique_value)==1
%        final_class(i)=unique_value;
%    else
%         [freq,value]=hist(dd,unique(dd));  %hist find frequency for value
%         index=find(freq==max(freq));
%         final_class(i)=value(index);
%    end
%    
% end

%Accuracy
predict_class=char(final_class);
real_class=(MatB(:,1));
currect_classify=numel(find(real_class==predict_class)); %numel function gives number of element in a matrix
accuracy=(currect_classify/numel(real_class))*100



