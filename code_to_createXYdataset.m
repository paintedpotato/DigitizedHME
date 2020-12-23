% Written by Timothy Sawe, supervised by Dr. Mohammed Ayoub
% 2020

%% To read images to code
clc
clear
% there's a problem using a1 with -, [, ]. Manual entry needed

% <300, >1000
% [,] = 778 elements, so 500 train, 50 test as well as:
% geq = 693
% div = 868
% ldots = 609
% leq = 973
% neq = 558
% w = 556
% pm = 802
% 7

a1 = ['-'; '!'; '('; ')'; ','; '['; ']'; '+'; '='; '0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'];
a1 = [a1; ['A'; 'b'; 'C'; 'd'; 'e'; 'f'; 'G'; 'H'; 'i'; 'j'; 'k'; 'l'; 'M'; 'N'; 'p'; 'q'; 'R'; 'S']];
a1 = [a1; ['T'; 'u'; 'v'; 'X'; 'y'; 'z'; "alpha"; "ascii_124"]];
a1 = [a1; ["beta";"cos";"infty";"int";"lim";"log";"pi";"rightarrow";"sin";"sqrt";"sum";"tan";"theta";"times"]];
a1 = [a1; ["geq";"div";"ldots";"leq";"neq";"w";"pm";"{";"}";"gamma";"lt";"o";"phi";"prime"]];
    %these are the characters with less than 300
a1 = [a1; ["gt";"forward_slash";"lambda";"mu";"sigma"]];
% 63+16

%%
u = 1;      % count for data_train
v = 1;      % count for data_test
% a2 = ['{'; '}'; 'Delta'; 'Div'];

total = 22400; %100*300; % should be 22400
data_train = zeros(45,45,1,total);     % 300*(82-8) + (100*
data_test = zeros(45,45,1,total*0.1);

% Do not predeclare these string arrays into the fields I've shown
% label_train = []; %zeros(total,1);
% label_test = []; %zeros(total*0.1,1);

% {, }, Delta have 376, 377, 486 items
% gamma = 409
% lt = 477
% o = 449
% phi = 355
% prime = 329
% 8

%% this is for 
% >300 <100
% gt = 258
% 1

% Ignored ones
% exists = 21, forall = 45
% in = 47

% forward_slash = 199
% lambda = 109
% mu = 177
% sigma = 201
% 4

%% Applies for the case of single characters with more than 1000 sample set
for i=1:length(a1)

    %% in case of manual entry
%     %clc
%     %clear
    %a1 = zeros(1,1);
%     i = 1; a1 = ['alpha'];
%     
    
    % case2 = 500;
    
    count1 = 300;
    count2 = count1*0.1;
    
    if i >= 74 %length(a1)-5
        count1 = 100;
        count2 = 10;
    end
myFolder = strcat('[insert dir]\kaggle\For a sample size of 100,000 expressions\extracted_images\',a1(i,1));
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.jpg');
jpegFiles = dir(filePattern);

j = 1;
for k = 1:(count1+count2)          %1000%length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  %fprintf(1, 'Now reading %s\n', fullFileName);
  imageArray = imread(fullFileName);
  
  if k<=count1
      data_train(:,:,:,u) = imbinarize(imageArray);
      label_train(u,1) = a1(i,1);
%        if mod(u,1200) == 0
%            imshow(data_train(:,:,:,u))
%        end
      u = u + 1;
  elseif k>count1 && k<=(count1+count2)
      
      data_test(:,:,:,v) = imbinarize(imageArray);
      label_test(v,1) = a1(i,1);
      v = v + 1;
  end
  
  %drawnow; % Force display to update immediately.
end

end

save('data_train.mat','data_train');
save('data_test.mat','data_test');

save('label_train.mat','label_train');
save('label_test.mat','label_test');

% X is dataset, Y is label
