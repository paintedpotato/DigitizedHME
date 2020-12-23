% Written by Timothy Sawe, supervised by Dr. Mohammed Ayoub
% 2020
function [outImage, indicator] = rowFiller(inImage)
I = inImage;
[m, n] = size(I);

if m<(0.5*n)
    
    while m<n  % We make it a square matrix because it's obvious only the minus
                % sign is the one which has been detected
        
        filler = ones(1,n);     % empty rows created
        I = [filler; I; filler];
        [m, n] = size(I);
    end
    indicator = 1;
    
else
    indicator = 0;
end

outImage = I;
end