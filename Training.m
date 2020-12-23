% Written by Timothy Sawe, supervised by Dr. Mohammed Ayoub
% 2020

%% 1. Loading datasets and labels for training and testing
% When using Model 22, uncomment the line below
% load('layers_4.mat');
% load('SqueezeNet_mod');
load('SqueezeNet_mod2');

load('data_test.mat');
load('data_train.mat');
load('label_test.mat');
load('label_train.mat');

%% 2. Training the network
XTrain = data_train;
YTrain = label_train;
YTrain = categorical(YTrain);

% From 40 Models trained these two performed the best, uncomment the one 
% needed when training and comment out the other

% -----------------------------------------------------------------------
% Model 22, Modified Faruqui (Uncomment line 6, with layers_4.mat)
% Modifications:
% filtersize: 4,4 for conv2d layer
% No shuffling

% options = trainingOptions('adam', ...
%     'ExecutionEnvironment','gpu', ...
%     'Verbose',false, ...
%     'Plots','training-progress');
% net = trainNetwork(XTrain,YTrain,layers_4,options);

%------------------------------------------------------------------------
% Model 17, SqueezeNet Transfer Learning (Uncomment line 7 to load 
% SqueezeNet_mod to use lgraph_2) created by importing SqueezeNet to
% MATLAB's deepNetworkDesigner and making the modifications:
% input layer: 45,45,1
% Added a fully connnected layer before softmax: 78
% output layer: auto

% (Refer line 8 which uses SqueezeNet_mod2 with lgraph_1 to include a 
% replaced 2nd layer conv1 which has no weights nor biases but same
% properties)

layers_17 = lgraph_1;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','multi-gpu', ...
    'Shuffle','every-epoch', ...
    'Verbose',false, ...
    'Plots','training-progress');
net = trainNetwork(XTrain,YTrain,layers_17,options);


%% 3. Testing the network

XTest = data_test;
YTest = label_test;
YTest = categorical(YTest);

tic
YPred = classify(net,XTest);
toc

%% 4. Predicting accuracy and saving the trained network

accuracy = sum(YPred == YTest)/numel(YTest)

% The trained network is saved to CNN40.mat which will be used in
% Main.m to run the code that preprocesses images and digitization
save('CNN17.mat','net') 