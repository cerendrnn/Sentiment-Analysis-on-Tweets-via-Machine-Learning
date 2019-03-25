%CS464 Introduction to Machine Learning Homework-01
%Author: Aybüke Ceren Duran
%Section-01
%21302686
%Date: 24.03.2019

format compact

delimiterIn = ',';
%Now, count the columns for obtaining the # of the features
delimiter = ',';
fid = fopen('question-4-train-features.csv','rt');
tLines = fgets(fid);
sizeVocab = numel(strfind(tLines,delimiter)) + 1;
fclose(fid);
disp(sizeVocab);%numCols will hold the size of the vocabulary which is 5722
train_labels = importdata('question-4-train-labels.csv', delimiterIn);

train_features  = importdata('question-4-train-features.csv', delimiterIn);
numberOfTweets = size(train_features,1);


for i=1:sizeVocab
    
   B=sort(train_features(i),'descend');   
  
   for h=1:20
       disp('For tweet i  most commonly used 20 words are: ');
   end
end





    