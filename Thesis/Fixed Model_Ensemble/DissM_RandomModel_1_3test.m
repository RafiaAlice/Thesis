%-Bagging based on Dissimilarity Measure(Random models)(testing using 1/3 data)-%
%--------------------------------------------------------------------------%
[~,fileread]=xlsread('Main.xlsx');
dataset=cell2mat(fileread);
[m,n]=size(dataset);
index_row=randsample(1:m,5416);

for kk=1:5
    if kk==1
        index_col1 = randsample(2:22, 6);
        index_col = [1,index_col1]; 
    elseif kk==2
        index_col1 = randsample(2:22, 6);
        index_col = [1,index_col1];
    elseif kk==3
        index_col1 = randsample(2:22, 6);
        index_col = [1,index_col1];
    elseif kk==4
        index_col1 = randsample(2:22, 6);
        index_col = [1,index_col1];
    else
        index_col1 = randsample(2:22, 6);
        index_col = [1,index_col1];
    end

trainset=dataset(index_row,index_col);
testset=dataset(:,index_col);
testset(index_row,:)=[];
[r_train c_train]=size(trainset);
[r_test c_test]=size(testset);

for k=1:r_test
for i=1:r_train
  m=0;
  for j=2:7
      if testset(k,j) == trainset(i,j)
          m=m+1;
      end
  end
  d(i)=(6-m)/6;
end
%display(d); %dissimilarity matrix
index=find(d==min(d));
if numel(index)==1
    class(k)=trainset(index,1);
else
    %%%%% For Multiple Class %%%%
    p_c=nnz(trainset(index) == 'p');
    e_c=nnz(trainset(index) == 'e');
    if p_c > e_c
        class(k)='p';
    else
        class(k)='e';
    end
end

end
count=numel(find(testset(:,1)==class'));
accuracy=(count/r_test)*100;
sprintf('Accuracy of Model-%.15g : %.5g ',kk,accuracy)
miss_classify=2708-count;
sprintf('Miss_classify: %g ',miss_classify)
ff(kk).att=double(class);
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
real_class=(testset(:,1));
currect_classify=numel(find(real_class==predict_class')); %numel function gives number of element in a matrix
accuracy=(currect_classify/numel(real_class))*100;
miss_classify=2708-currect_classify;
sprintf('Final Accuracy: %.15g ',accuracy)
sprintf('Final_Miss_classify: %g ',miss_classify)