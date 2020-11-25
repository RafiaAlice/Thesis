%--Bagging based on Naive Bayes(5 models)(testing using all data)--%
%------------------------------------------------------------------%
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
index_row=randsample(1:m,5416);

for k=1:5
    if k==1
       index_col=[1 2 3 4 5 6 7]; 
    elseif k==2
        index_col=[1 6 8 9 10 21 22];
    elseif k==3
        index_col=[1 6 11 12 13 14 15];
    elseif k==4
        index_col=[1 4 14 19 20 22 23];
    else
        index_col=[1 4 18 20 22 23];
    end
    
    train_features=features(index_row,index_col);
    class=train_features(:,1);
    test_features=features(:,index_col);
    
    nb_classifier = fitcnb(train_features(:,2:6),class);
    TP_TN=0;
    for j=1:8124
        res(j,1) = predict(nb_classifier,test_features(j,2:6));
        class=res(j,1);
        if test_features(j,1)==class
            TP_TN = TP_TN+1;
        end
    end
    ff(k).att=res;
    accu=TP_TN*100/8124;
    sprintf('Accuracy of Model-%g: %.5g%%',k,accu)
    miss_classify=8124-TP_TN;
    sprintf('Miss_classify: %g ',miss_classify)
end
%------------Bagging--------------
for i=1:length(ff(1).att)
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
%---------------Final Accuracy------------
predict_class=char(final_class);
real_class=char(test_features(:,1));
currect_classify=numel(find(real_class==predict_class')); %numel function gives number of element in a matrix
accuracy=(currect_classify/numel(real_class))*100;
miss_classify=8124-currect_classify;
sprintf('Final Accuracy: %.15g%%',accuracy)
sprintf('Final_Miss_classify: %g ',miss_classify)