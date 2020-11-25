%----Single Decision Tree (5 features) (Hold on)-------%
%------------------------------------------------------%

%Input train data file(fixed)
[~,fileread2] = xlsread('Main.xlsx');
Dataset = cell2mat(fileread2);
[m,n]=size(Dataset);
index_row = randsample(1:m, 5416);
%index_col= [1 6 8 9 10 21 22]; %6 features give 100% accuracy
index_col= [1 6 8 9 21 22];     %5 features give 100% accuracy
   
MatA=Dataset(index_row,index_col);
classname=MatA(:,1);
disp('Train')
MatB=Dataset(:,index_col);
MatB(index_row,:)=[]; %%% 1/3 test;
     
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

%Accuracy
predict_class=char(final_class);
real_class=(MatB(:,1));
currect_classify=numel(find(real_class==predict_class)); %numel function gives number of element in a matrix
accuracy=(currect_classify/numel(real_class))*100;
sprintf('Final Accuracy: %.15g%%',accuracy)