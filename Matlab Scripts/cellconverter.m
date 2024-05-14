function [ mycell ] = cellconverter(matrix)
[a,b] = size(matrix);
mycell = cell(a,b,1);
for i = 1:a
    for j = 1:b
        
        mycell{i,j} = matrix(i,j);
    end
end
mycell = mycell';

end
