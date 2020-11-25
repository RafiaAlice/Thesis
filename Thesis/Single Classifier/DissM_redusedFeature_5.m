%----Single Dissimilarity Measure (5 features) (Hold on)-------%
%--------------------------------------------------------------%
[~,fileread]=xlsread('Main.xlsx');
dataset=cell2mat(fileread);
[m,n]=size(dataset);
index_row=randsample(1:m,5416);
%index_col= [1 6 8 9 10 21 22]; %6 features give 100% accuracy
index_col= [1 6 8 9 21 22];     %5 features give 100% accuracy
trainset=dataset(index_row,index_col);
testset=dataset(:,index_col); 
testset(index_row,:)=[];
[r_train c_train]=size(trainset);
[r_test c_test]=size(testset);

for k=1:r_test
for i=1:r_train
  m=0;
  for j=2:6
      if testset(k,j) == trainset(i,j)
          m=m+1;
      end
  end
  d(i)=(5-m)/5;
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
sprint('Final accuracy: %.3g%%',accuracy)