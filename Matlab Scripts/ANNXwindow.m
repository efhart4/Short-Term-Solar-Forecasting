function [ mycell ] = ANNXwindow(matriX, vectorY)
[a, b] = size(matriX);
mycell = cell(2,a,1);
tophalf = con2seq(matriX'); % looks good
%{
tophalf = con2seq(testX(  (20- windowsize - 9) : (20 - 10)  ,:)')

tophalf = 1×5 cell array
    {4×1 double}    {4×1 double}    {4×1 double}    {4×1 double}    {4×1 double}
%}

    for j = 1:a
        mycell{1,j} = tophalf{1,j};
        mycell{2,j} = vectorY(j);
    end

%mycell = mycell';

end