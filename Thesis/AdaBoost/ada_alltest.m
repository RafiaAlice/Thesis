%%% arranged classes(at first e then a)
[~,data]=xlsread('main.xlsx');
dataset=cell2mat(data);
[m,n]=size(dataset);
numeric_dataset=double(dataset);

%%% randomly selecting for 2/3 training all testing
index_row=randsample(1:m,5416);
train=numeric_dataset(index_row,:);
train_class=train(:,1);
train_features=train(:,2:23);
test=numeric_dataset;
test(index_row,:)=[];
test_class=test(:,1);
test_features=test(:,2:23);

%Training Part
ee=find(train_class==101);
pp=find(train_class==112);
matA=train_class(ee,1);
featureA=train_features(ee,:);
matB=train_class(pp,1);
featureB=train_features(pp,:);


% for i=1:length(ee)
%     matA(i)=x(ee(i))
%     featureA(i)=y(ee(i),2:23);
% end
% for i=1:length(pp)
%     matB(i)=x(pp(i));
%     featureB(i)=y(pp(i),2:23);
% end

%%% Arranging Edible & poisonous & creating label of train part
size_edible=size(matA);
size_poisonous=size(matB);
arranged_class=[matA',matB'];
arranged_class=arranged_class';
feature_data=[featureA',featureB'];
feature_data=feature_data';
label=zeros(5416,1);
label(1:size_edible,end)=1;
label(size_edible+1:size_poisonous,end)=2;

verbose = true;
classifier = AdaBoost_mult(two_level_decision_tree, verbose); % blank classifier
nTree =5;

C = classifier.train(feature_data, label, [], nTree);

TP_TN=0;
for j=1:2708
   y  = C.predict(test_features);
   if  y == 1
       predict_class=101;
   else
       predict_class=112;
   end
   
   if test_class(j)==predict_class;
       TP_TN = TP_TN+1;
   end
end
accu=TP_TN*100/2708