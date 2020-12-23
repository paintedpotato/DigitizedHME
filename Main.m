% Written by Timothy Sawe, supervised by Dr. Mohammed Ayoub
% 2020

% Shortcoming: Needs proper writing and not too cursive handwriting.
% I need to find a way to clean the image coming in, so that pixels of a
% certain dimension are ignored or turned into white. To stop false
% positives i.e. If before thinning, the black pixels don't reach a certain
% quantity then make them all white.

% function a = boundingbox2(net,I)

clc
clear
addpath '[insert dir]\MATLAB\Examples\R2019b\matlab\DeclareFunctionWithOneOutputExample'

YPrediction = [];
real_YPrediction = [];
indicator = 0;
load('CNN17.mat'); % commented out

% Note a 0.6 threshold level is the one that worked best for my picture -
% though the computed one via graythresh(rgb2gray()) was 0.7 which gave bad
% pixel ratio
T = imread('[insert dir]\sample.jpg'); % testimage

figure
subplot(2,1,1)
imshow(T)

%gray = 0.1*floor(-1 + 10*graythresh(rgb2gray(T)));
BW = imbinarize(rgb2gray(T));%,gray);  % imread('D:\CNN\data_template_part2\ohh.jpg')),0.6);    % commented out
BW = imcomplement(BW);
% BW = bwmorph(BW,'thin',Inf);

% BW = ~BW;
subplot(2,1,2)
imshow(BW)  % Commented out
hold all                     % commented out
st = regionprops(BW, 'BoundingBox' );
for k = 1 : length(st)
  thisBB = st(k).BoundingBox;
  
  sI = imcrop(BW,thisBB);
  sI = imcomplement(sI);
  
  I = sI;
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

sI = I;
  
  
  sI = imresize(sI, [45 45]);
  % Thinning
  if indicator == 1
      sI = imbinarize(sI); % We binarize again just in case sth goes wrong in resizing (happens
                        % in the case of A3.jpg minus sign
      indicator = 0;
  end
  sI = imcomplement(bwmorph(imcomplement(sI),'thin',Inf));
%   imshow(sI)    % commented out

  YPred = classify(net,sI);
  if YPred == "times"
      YPred = "x";
  end
  YPrediction = [YPrediction; YPred];
  
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...       % Commented out
  'EdgeColor','r','LineWidth',2 ); % I put a semicolon here but it still does whatever
  end


%compute area centroid and boundingbox
bw6=BW;
  stats = regionprops(bw6, ['basic']);
  s = regionprops(bw6, 'centroid');
  centroids = cat(1, s.Centroid);
%   imshow(bw6);
  %find size of stats
  [N,M] = size(stats);
  if (bw6==0)
%       break;
  else
      tmp = stats(1);
      
  for i = 2 : N
      if stats(i).Area > tmp.Area
          tmp = stats(i);
      end
  end
  end
 
  % To calculate height
 bbMatrix = vertcat(st(:).BoundingBox);
 % Now the third column is the height and the fourth is the width:
 height = bbMatrix(:,3);
 
 % Alternate way to calculate height
%  CC = bwconncomp(BW);
%  RP = regionprops(CC);
%  Bboxes = {RP(:).BoundingBox};
%  idheight = cellfun(@(x)(x(3)),Bboxes);
 
 
  % Uncomment the code below to plot centroids
  bb = tmp.BoundingBox;
  bc = tmp.Centroid;
%   imshow(data)
  hold on
  rectangle('Position', bb, 'EdgeColor', 'r', 'LineWidth', 2)
  plot(centroids(:,1), centroids(:,2), 'b*');     % I commented this out
  hold off
  
  YPrediction = string(YPrediction);
  
  %% Edit made when testing
%   YPrediction(10) = "-";
aver = [];
  t = length(YPrediction);
  %% One method of checking for '=' sign
  i = 1;
  k = "";
  cent_roids = [];
  while i<=t
      if i~= t
          if YPrediction(i) == "-" && YPrediction(i+1) == "-"
            k = "=";
            real_YPrediction = [real_YPrediction; k];
            k = "";
            cent_roids = [cent_roids; centroids(i,:)];
            i = i+1;  % skips the next iteration because it assumes there will never be
                    % a scenario with 3 hyphens successively following each
                    % other NOR a situation where the equation ends in "="
          else
            real_YPrediction = [real_YPrediction; YPrediction(i)];
            cent_roids = [cent_roids; centroids(i,:)];
         end
      else
          real_YPrediction = [real_YPrediction; YPrediction(i)];
          cent_roids = [cent_roids; centroids(i,:)];
      end
      i = i + 1;
  end
  
  
  %% Method for checking '0' zero
  real_YPrediction2 = real_YPrediction(1,1);
  t = length(cent_roids);
  for i = 1:t-1
      % Checking zero
      if (real_YPrediction(i,1) == "=" || real_YPrediction(i,1) == "0" || real_YPrediction(i,1) == "1" || real_YPrediction(i,1) == "2" || real_YPrediction(i,1) == "3" || real_YPrediction(i,1) == "4" || real_YPrediction(i,1) == "5" || real_YPrediction(i,1) == "6" || real_YPrediction(i,1) == "7" || real_YPrediction(i,1) == "8" || real_YPrediction(i,1) == "9" || real_YPrediction(i,1) == ".") && real_YPrediction(i+1,1) == "o" 
          k = "0";
      else
          k = real_YPrediction(i+1,1);
      end
      
      real_YPrediction2 = [real_YPrediction2; k];
  end
  
  %% THIS METHOD WAS EXCLUDED WHEN TESTING 'Checking lines iteratively,'
  % however it can still be added in perhaps when about to save line into T.
%     %% Method for checking superscript
%   t = length(cent_roids);
%   real_YPrediction3 = real_YPrediction2(1,1);
%   for i = 1:t-1
%       y1 = cent_roids(i,2);
%       y2 = cent_roids(i+1,2);
%       height1 = y1 - (height(i,1))/2;
%       avg = average([height1, y1]);
%       if y2 <= avg && real_YPrediction(i,1) ~= "="
%           k = strcat("superscript(",real_YPrediction2(i+1,1),")");
%       else
%           k = real_YPrediction2(i+1,1);
%       end
%       real_YPrediction3 = [real_YPrediction3; k];
%   end
    

 %% Checking lines iteratively
  uy = cent_roids(:,2);
 
  k_temp = 0;
  l_temp = 1;
  bc = 0;
  %a = "hi";
  anomaly = 0;
  generosity = [];
  %generosity(1) = uy(1);
  y3 = [];
  y11 = [];
  k1 = [];
  o = 0;

while isempty(uy) == 0
  
  i = 1;
  y1 = uy(i);
  y11 = [y11; y1];
  height1 = y1 - (height(i,1))/2;
  height2 = y1 + (height(i,1))/2;
  a(l_temp) = real_YPrediction2(i,1);
  y3 = uy(i);
  t = length(uy);
%   o = 0;
  
  for i = 2:t           

          y2 = uy(i);      % will iterate y2
          
          % To increase the sliding window by 1.00x, I tried 1.25, 1.15,
          % 1.05, and 1.005x they all gave bad results.
          dh = height2-height1;
          dh = (dh*1.00)/2;      % change 1.00 to the value of choice       
          avg = (height2+height1)/2;
          height2 = avg + dh;
          height1 = avg - dh;
          
          if y2>height1 && y2<height2
              %UNCOMMENT
              y1_2 = uy(i); % new character in if-statement 's centroid
              if o == 1
%                   aver = y1_1

              
              % It's supposed to be the average of the last character that
              % passed by in the parent if-statement with that of the
              % and NOT the last character in uy(i) cause it may not be in
              % the same row.
              if y1_2 <= aver && real_YPrediction(i,1) ~= "="
                k = strcat("superscript(",real_YPrediction2(i,1),")");
                a(l_temp) = strcat(a(l_temp),k);
                y3 = [y3; y2];
              else
                a(l_temp) = strcat(a(l_temp),real_YPrediction2(i,1));
                y3 = [y3; y2];
              end
              else
                a(l_temp) = strcat(a(l_temp),real_YPrediction2(i,1));
                y3 = [y3; y2];
              end
                  
              y1_1 = uy(i); % last character in if-statement 's centroid
%               h1 = height(i,1)/2;
              aver = average([height1, y1_1]);
              o = 1;

          end
          
%           k1 = real_YPrediction2(i,1);
          
  end      
       
      %k_temp = k_temp + 1;
% Here's where superscript code is supposed to be      
  %% SUPERSCRIPT
%   t = length(cent_roids);
%   real_YPrediction3 = real_YPrediction2(1,1);
%   for i = 1:t-1
%       y1 = cent_roids(i,2); % uy(i+1)
%       y2 = cent_roids(i+1,2); % uy(i+1)
%       height1 = y1 - (height(i,1))/2;
%       avg = average([height1, y1]);
%       if y2 <= avg && real_YPrediction(i,1) ~= "="
%           k = strcat("superscript(",real_YPrediction2(i+1,1),")");
%       else
%           k = real_YPrediction2(i+1,1);
%       end
%       real_YPrediction3 = [real_YPrediction3; k];
%   end
  
  %% Arranging the text
g = 1;
ti = length(uy);
while g<=length(y3)
  j = 1;
  while j<=ti
      if uy(j,1) == y3(g,1)
          uy(j) = [];
          real_YPrediction2(j) = [];
          ti = length(uy);
      end
      
      j= j + 1;
  end
  g = g + 1;
end
%disp(cent_roids);
l_temp = l_temp + 1;
end

disp(a);      % commented out

% Sorting
for i = 1:length(y11)-1
    
    if y11(i) > y11(i+1)
        temp = y11(i);
        temp_a = a(1,i);
        
        y11(i) = y11(i+1);
        a(1,i) = a(1,i+1);
        
        y11(i+1) = temp;
        a(i+1) = temp_a;
    end
end

disp(a);  % commented out
