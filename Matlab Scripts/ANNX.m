function [ predictions, NRMSE ] = ANNX(windowsize, hiddenlayers, trainT, trainX, testT, testX)

T = cellconverter(trainT);
X = con2seq(trainX');

 %              Prepare data ---------------------------
observedmean = mean(testT);
predictionend = length(testT);
predictionstart = windowsize + 10; 
predictions = zeros(predictionend,1);
[~ , b ] = size(testX); % b is the number of exogenous factors
netvector = cell(b,1);
futureMatrix = zeros(10, b); % matrix to hold predicted exogenous values


 %          Training ----------------------------------
net = narxnet(1:windowsize,1:windowsize, hiddenlayers);% create ANN w/ EXO
[Xs,Xi,Ai,Ts] = preparets(net,X,{},T);
net = train(net,Xs,Ts,Xi,Ai);                           % train ANNX
[~,~,Af] = net(Xs,Xi,Ai);

for j = 1:b % loop to create and train networks for exogenous factors
    netvector{j} = TrainNet_Exo(trainX(:,j), windowsize, hiddenlayers);
end



%       Prediction loop -------------------------------
for i = predictionstart:predictionend % i shifts the window

% first prep the known window of observation
windowofobservations = ANNXwindow(testX((i- windowsize - 9): (i-10),:), testT((i- windowsize - 9) :(i-10) ));
[netc,Xic,Aic] = closeloop(net,windowofobservations,Af);

% Predict future value of exogenous factors for next 10 minutes
for j = 1:b
futureMatrix(:,j) = predict_Exo(testX((i- windowsize-9): (i-10),j), netvector{j},Af);
end
futureX = con2seq(futureMatrix'); 

% Last make ten predictions using window and futureX, save number 10
y2 = netc(futureX, Xic, Aic);
predictions(i) = y2{10};
end % prediction loop


%           Error -----------------------------------------
NRMSE = (sqrt(mean((testT(predictionstart:predictionend) - predictions(predictionstart:predictionend)).^2)))/observedmean; 

plot(testT)
hold on
plot(predictions(predictionstart:predictionend))
legend({'observed values','predicted values'},'Location','southwest')
xlabel('Minutes')
ylabel('Normal Irradiance')
end % function
 

%{
clear all 
close all
load('Data6')
windowsize = 3;
hiddenlayers = 3;
[ predictions, NRMSE ] = ANNX(windowsize, hiddenlayers, trainT, traincase1,testT, testcase1);

%}


%           Graph prediction --------------------
%{
plot(predictions_AR_2)
hold on
plot(predictions_ANN_1_1)
hold on
plot(predictions_ANNX_1_w_4_case_1(:,1))
hold on
plot(testIR)
legend({'Observed', 'Autoregression','NARNET','NARXNET', },'Location','southwest')
%}
