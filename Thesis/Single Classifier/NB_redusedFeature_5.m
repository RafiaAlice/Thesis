%----Naive Bayes (5 features) (Hold on)-------%
%---------------------------------------------%

[~,fileread]=xlsread('Main.xlsx');
dataset=cell2mat(fileread);
[m,n]=size(dataset);
matA = double(dataset);
[m,n]=size(dataset);
for i=1:n
   unique_value = unique(dataset(:,i));
   for j=1:m
       dataset(j,i) = find(unique_value==dataset(j,i));
   end
end
features = dataset();
features=double(features);
features(:,17) = [];

index_row=randsample(1:m,5416);
%index_col= [1 6 8 9 10 21 22]; %6 features give 100% accuracy
index_col= [1 6 8 9 21 22];     %5 features give 100% accuracy
train_features=features(index_row,index_col);
class=train_features(:,1);
test_features=features(:,index_col);
test_features(index_row,:)=[];%%% 1/3 test

nb_classifier = fitcnb(train_features(:,2:6),class);

%%%%---------accuracy for 1/3 test------------
TP_TN=0;
for j=1:2708
   class = predict(nb_classifier,test_features(j,2:6));
   if test_features(j,1)==class
       TP_TN = TP_TN+1;
   end
end
accu=TP_TN*100/2708 