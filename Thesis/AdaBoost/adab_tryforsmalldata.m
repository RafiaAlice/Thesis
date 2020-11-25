%%% arranged classes(at first e then a)
[~,data]=xlsread('main.xlsx');
dataset=cell2mat(data);
dataset=dataset(1:10,:)
[m,n]=size(dataset);
train=dataset(1:6,:)
train_class=train(:,1);
train_class=double(train_class);
train_features=train(:,2:23);
train_features=double(train_features);
 test=dataset(7:10,:)
 test_class=test(:,1);
 test_class=double(test_class);
 test_features=test(:,2:23);
 test_features=double(test_features);

%%% randomly selecting for 2/3 training 1/3 testing
% index_row=randsample(1:m,6)
% train=numeric_dataset(index_row,:);
% train_class=train(:,1);
% train_features=train(:,2:23);
% test=numeric_dataset;
% test(index_row,:)=[];
% test_class=test(:,1);
% test_features=test(:,2:23);
% 
% %Training Part
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
label=zeros(6,1);
label(1:size_edible,1)=1;
label(size_edible+1:size_poisonous,1)=2;

verbose = true;
classifier = AdaBoost_mult(two_level_decision_tree, verbose); % blank classifier
nTree =2;

C = classifier.train(train_features, label, [], nTree);

TP_TN=0;
for j=1:4
   y  = C.predict(test_features)
   if  y == 1
       predict_class=101
   else
       predict_class=112
   end
   
   if test_class(j)==predict_class;
       TP_TN = TP_TN+1;
   end
end
accu=TP_TN*100/4



