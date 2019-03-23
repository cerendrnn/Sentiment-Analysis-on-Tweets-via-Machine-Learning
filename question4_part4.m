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

train_features  = importdata('question-4-train-features.csv', delimiterIn);
train_labels = importdata('question-4-train-labels.csv', delimiterIn);
%disp(train_labels);
test_features = importdata('question-4-test-features.csv', delimiterIn);
test_labels = importdata('question-4-test-labels.csv', delimiterIn);
%disp(test_labels);

%Now, count the rows of training features which is # of tweets
numberOfTweets = size(train_features,1);
disp(numberOfTweets);%it obtained 11712 as number of tweets 

numberOfPositives = 0;
numberOfNeutral = 0;
numberOfNegatives = 0;

for i=1:numberOfTweets
    if strcmp(train_labels(i),"positive")
        numberOfPositives = numberOfPositives +1 ;     
    end  
    
    if strcmp(train_labels(i),"neutral")
        numberOfNeutral = numberOfNeutral +1 ;
    end 
    
    if strcmp(train_labels(i),"negative")
        numberOfNegatives = numberOfNegatives +1 ;
    end     
        
end

positiveArray = zeros(sizeVocab);
negativeArray = zeros(sizeVocab);
neutralArray = zeros(sizeVocab);

numCols = size(train_labels,1); % # of tweets

for i=1:sizeVocab
    for j=1:numberOfTweets
        if strcmp(train_labels(i),"positive")
            %this holds frequencies of each vocab words in positive tweets
            positiveArray(i) = positiveArray(i) + train_features(j,i);
        end
        if strcmp(train_labels(i),"negative")
            %this holds frequencies of each vocab words in negative tweets
            negativeArray(i) = negativeArray(i) + train_features(j,i);
        end
        if strcmp(train_labels(i),"neutral")
            %this holds frequencies of each vocab words in neutral tweets
            neutralArray(i) = neutralArray(i) + train_features(j,i);
        end
    end
end

mlePositive = zeros(sizeVocab);
mleNegative = zeros(sizeVocab);
mleNeutral = zeros(sizeVocab);

for i=1:sizeVocab    
    mlePositive(i) = double((mlePositive(i) + 1) / numberOfPositives);
    mleNegative(i) = double((mleNegative(i) + 1) / numberOfNegatives);
    mleNeutral(i) = double((mleNeutral(i) + 1) / numberOfNeutral);
    
    if mlePositive(i) ~= 0
        mlePositive(i) = log(mlePositive(i));
    end

    if mleNegative(i) ~= 0
        mleNegative(i) = log(mleNegative(i));
    end
    
    if mleNeutral(i) ~= 0
       mleNeutral(i) = log(mleNeutral(i));
    end
end

numberOfCorrectPrediction = 0;
test_tweets = size(test_features,1);

for i=1:test_tweets
    
    mleTestPositive = double(0);
    mleTestNegative = double(0);
    mleTestNeutral = double(0);
    
    for j=1:sizeVocab
        mleTestNegative = mleTestNegative + double(mleNegative(j) * test_features(i,j));
        mleTestPositive = mleTestPositive + double(mlePositive(j) * test_features(i,j));
        mleTestNeutral = mleTestNeutral + double(mleNeutral(j)*test_features(i,j));
    end

    predictNegative = log(double(numberOfNegatives / numberOfTweets)) + mleTestNegative;
    predictPositive = log(double(numberOfPositives /numberOfTweets)) + mleTestPositive;
    predictNeutral = log(double(numberOfNeutral/numberOfTweets)) + mleTestNeutral;
    
    if predictNegative > predictPositive && predictNegative>predictNeutral
        predict = 'negative';
    end
    
    if predictPositive > predictNegative && predictPositive>predictNeutral
        predict = 'positive';
    end
    
    if predictNeutral > predictPositive && predictNeutral>predictNegative
        predict = 'neutral';
    end
    
    if strcmp(predict, test_labels(i))
       numberOfCorrectPrediction = numberOfCorrectPrediction + 1;
    end
            
end

sizeTestFeatures = size(test_features,1);

accuracy = double(numberOfCorrectPrediction/sizeTestFeatures);
numberOfWrongPrediction = sizeTestFeatures - numberOfCorrectPrediction;

disp("Accuracy -> " + accuracy);
disp("False predictions -> " + numberOfWrongPrediction);


