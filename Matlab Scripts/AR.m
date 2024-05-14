function [ predictionsreversenormal, NRMSE ] = AR(windowsize,testT, trainT)

[T, key] = mapminmax(trainT');
[T2, key2] = mapminmax(testT');
observedmean = mean(testT);
T= T';
T2 = T2';

model = arima(windowsize, 0,0);
model = estimate(model, T);

predictionend = length(testT);
predictionstart = windowsize + 10;

predictions = zeros(predictionend,2);
predictions(:,2) = 1: predictionend;

for i = predictionstart:predictionend
    windowofobservations = T2((i- windowsize - 9): (i - 10) );
    p = forecast(model,10,'Y0',windowofobservations);
    predictions(i,1) = p(10);
end

%Calculate error for predictions
predictionsreversenormal = mapminmax('reverse',predictions(:,1)',key);
predictionsreversenormal = predictionsreversenormal';
predictionsreversenormal(1:predictionstart) = 0;
NRMSE = (sqrt(mean((testT(predictionstart:predictionend) - predictionsreversenormal(predictionstart:predictionend)).^2)))/observedmean; 

plot(testT)
hold on
plot(predictions(predictionstart:predictionend))
legend({'observed values','predicted values'},'Location','southwest')
end

%{
implementation
clear all
close all
load('Data6')
windowsize = 3;
[ predictions, NRMSE ] = AR(windowsize,testIR, trainIR);
%}

