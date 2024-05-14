function [ predictions, NRMSE ] = ANN(windowsize, hiddenlayers, trainT, testT)

T = cellconverter(trainT);
observedmean = mean(testT);

predictionend = length(testT);
predictionstart = windowsize + 10; 
 
predictions = zeros(predictionend,1);
net = narnet(1:windowsize,hiddenlayers);
[Xs,Xi,Ai,Ts] = preparets(net,{},{},T);
net = train(net,Xs,Ts,Xi,Ai);
[~,~,Af] = net(Xs,Xi,Ai);% this creates Af for use below. not sure what it does

for i = predictionstart:predictionend
windowofobservations = cellconverter(testT(  (i- windowsize - 9) : (i - 10)  ));
[netc,Xic,Aic] = closeloop(net,windowofobservations,Af);
y2 = netc(cell(0,10),Xic,Aic);
predictions(i) = y2{10};
end

%Calculate error for predictions
NRMSE = (sqrt(mean((testT(predictionstart:predictionend) - predictions(predictionstart:predictionend)).^2)))/observedmean; 

plot(testT)
hold on
plot(predictionsreversenormal(predictionstart:predictionend))
legend({'observed values','predicted values'},'Location','southwest')



end

%{
%NARNET
clear all
close all
load('Data6')
windowsize = 5;
hiddenlayers = 21;
[ predictions, NRMSE ] = ANN(windowsize, hiddenlayers, trainIR, testIR);


plot(predictionsAR7)
hold on
plot(predictions)
hold on
plot(testIR)
legend({'AR','NARNET', 'observed'},'Location','southwest')





%}


