function image_process(handles)

% 10.8.2018 11:03


% 10.8.18 11:13
% Extracting the variables
original_roots_img = evalin('base', 'original_roots_img');
cropped_roots_img = evalin('base', 'cropped_roots_img');
rootx = evalin('base', 'rootx');
rooty = evalin('base', 'rooty');



originalsize = size(original_roots_img);
triple_root_points = [0:2]*originalsize(1)*originalsize(2)+(rootx-1)*originalsize(1)+rooty;

% 19.7.18 18:54
% Mean extraction with a loop that will take the 3
% pixels in each column (3 columns)
means = 0;
for i = -1:1
    means = means + original_roots_img(triple_root_points-originalsize(1)+i) + original_roots_img(triple_root_points+i) + original_roots_img(triple_root_points + originalsize(1) + i);
end
% Finally we extract the colors themselves of the 5 chosen pixels
root_points_color = means./9;



% -- from here on original image no longer necessary

% We will make the ranges [mean-c*std,mean+c*std] where
%c = 2*(min(1,0.3+mean))
% see LOG 2.9.18 22:42. Will use the slider for "proc_str" for the color
% ranges and also for reducer
proc_str = 3 - handles.process_str.Value;
% Let's make it more readable by introducing more varables
colormeans = mean(root_points_color); % Introduced on 1.9.18
% And now we can calculate the mean +- 3*standard deviation for the range
% for each color
cfiltR = [colormeans(1)-proc_str*(min(1,0.4+colormeans(1)))*std(root_points_color(:,1)) colormeans(1)+proc_str*(min(1,0.4+colormeans(1)))*std(root_points_color(:,1))];
cfiltG = [colormeans(2)-proc_str*(min(1,0.4+colormeans(2)))*std(root_points_color(:,2)) colormeans(2)+proc_str*(min(1,0.4+colormeans(2)))*std(root_points_color(:,2))];
cfiltB = [colormeans(3)-proc_str*(min(1,0.4+colormeans(3)))*std(root_points_color(:,3)) colormeans(3)+proc_str*(min(1,0.4+colormeans(3)))*std(root_points_color(:,3))];
% tried 1*std, 2*std as well, but 3*std works best for now
% 2 to 3 1.9 10:48. and 0.3->0.4 10:51

% Now for the brightness range. We'll just take an average of the three
% above filters
brighfilt = (cfiltR+cfiltG+cfiltB)./3;

% Will try to use in force tip. 13.8.18 00:16 -CHANGED TO mean(brighfilt)
assignin('base','root_mean_color',mean(brighfilt))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% APPROACH 1: USING INPUT FROM USER TO ESTIMATE THE RANGE of the root colours %
%                       Adding Colour separation filtering                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPDATE 1.9.18 00:59 - Now that we receive the poins from the user, we can
% do an initial color filtering based on the RGB values of those
% points. Let's say the minimal value of the range is x1 and the maximal value of it
% is x2. First, we will take all x>x2 and apply: f(x) = (x-x2)*(x1/(1-x2)).
% Then, we will take the values in x1<x<x2, and apply: f(x) = [(1-x0)/(x2-x1)]*x + [(x2*x0-x1)/(x2-x1)]
% Where x0 I need to determine. The second one is 'Enhancement'
% For x1<0.25 x0 = x1 + 0.5. Else, we'll take max(x2, min(3 * x1,1)).

colortemp = cropped_roots_img;
% Readding the initial step and adding a while loop of imfill
% see LOG 2.9.18 19:15

% Seperate to RGB matrices
colortempR=colortemp(:,:,1);
colortempG=colortemp(:,:,2);
colortempB=colortemp(:,:,3);

% First step, taking the values above the ranges and taking them down a notch.
% So we create the masks
filmaskR = colortempR>cfiltR(2);
filmaskG = colortempG>cfiltG(2);
filmaskB = colortempB>cfiltB(2);

% see LOG 1.9.18 03:28 as to why I create the combined mask
% I add them all inside a logical function converting it to logical automatically.
% combmask = logical(filmaskR + filmaskG + filmaskB);
% see LOG 2.9.18 21:32 to make it tighter
combmask = filmaskR + filmaskG + filmaskB-1;
combmask(combmask<0) = 0;
combmask = logical(combmask);


% Applying the transformation discussed above using an auxillary function made for that purpose
colortempR= colortransform(colortempR, combmask, 0, cfiltR(2), 1, cfiltR(1));
colortempG= colortransform(colortempG, combmask, 0, cfiltG(2), 1, cfiltG(1));
colortempB= colortransform(colortempB, combmask, 0, cfiltB(2), 1, cfiltB(1));

% see LOG 2.9.18 19:00
thresh = 2;
% 
while(thresh > 0.01)
% see LOG 2.9.18 18:34
thresh = mean([max(max(abs(colortempR-imfill(colortempR)))),max(max(abs(colortempG-imfill(colortempG)))),max(max(abs(colortempB-imfill(colortempB))))]);
colortempR=imfill(colortempR);
colortempG=imfill(colortempG);
colortempB=imfill(colortempB);

end

% Now time to enhance the things inside the range and divide the rest.
% So first the enhancement
filmaskR = colortempR>cfiltR(1) & colortempR<cfiltR(2);
filmaskG = colortempG>cfiltG(1) & colortempG<cfiltG(2);
filmaskB = colortempB>cfiltB(1) & colortempB<cfiltB(2);

% see LOG 1.9.18 03:28 as to why I create the combined mask
% I add them all inside a logical function converting it to logical automatically.
% combmask = logical(filmaskR + filmaskG + filmaskB);
% see LOG 2.9.18 21:32 to make it tighter
combmask = filmaskR + filmaskG + filmaskB-1;
combmask(combmask<0) = 0;
combmask = logical(combmask);

% Applying the enhancement discussed above using the same auxillary function made for that purpose
% But let's remember % For x1<0.25 x0 = x1 + 0.5. Else, we'll take max(x2, min(3 * x1,1)).
% For compactness and readability we will create another auxillary function.
% see LOG 1.9.18 03:36 for the reasoning behind the use of brighfilt
x0 = determinex0(brighfilt(1),brighfilt(2));
colortempR= colortransform(colortempR, combmask, x0, cfiltR(1), cfiltR(2), 1);
colortempG= colortransform(colortempG, combmask, x0, cfiltG(1), cfiltG(2), 1);
colortempB= colortransform(colortempB, combmask, x0, cfiltB(1), cfiltB(2), 1);
% Figuring out the edge for the next stage
edgy = edge(colortempR,'log',0.0014,3.6);
edgy = bwareaopen(edgy,200);
% more edge related stuff
[edgerow,edgecol] = find(edgy);
[edgerowfull,~,edgerowcount] = unique(sort(edgerow));
edge_counts = accumarray(edgerowcount,1);
value_counts = [edgerowfull, edge_counts];

for i = value_counts(~(value_counts(:,2)>2))'
    % NOTE: I am aware that for loops in Matlab are not efficient
    % First we want to find if we have edges in this line.
    edgerowind = find(edgerow==i);
    % Then what is their x values
    edgecolind = edgecol(edgerowind);
    % Now I will have take for each point the average distance from the edge
    % First, I will put every column index in a neat line.
    j=1:size(colortemp,2);
    % Now I will take their distances from the edges and then the mean
    edgedist = abs(j-edgecolind);
    edgedist = mean(edgedist,1);
    % Now the distance based cast that will reduce you the further away you are from the edges.
    distcast = 1 - (edgedist./size(colortemp,2));
    
    colortempR(i,:) = colortempR(i,:).*distcast;
    colortempG(i,:) = colortempG(i,:).*distcast;
    colortempB(i,:) = colortempB(i,:).*distcast;
end

for i = value_counts((value_counts(:,2)>2))'
    % NOTE: I am aware that for loops in Matlab are not efficient
    % First we want to find if we have edges in this line.
    if(value_counts(:,2)>4)
        edgerowind = [find(edgerow==i,2,'first');find(edgerow==i,2,'last')];
        flag =1;
    else
        edgerowind = find(edgerow==i);
        flag =0;
    end
    
    % Then what is their x values
    edgecolind = edgecol(edgerowind);
    % Now I will have take for each point the average distance from the edge
    % First, I will put every column index in a neat line.
    j=1:size(colortemp,2);
    % Now I will take their distances from the edges and then the mean
    edgedist = abs(j-edgecolind);
    % I want to handle it more carefully if there are more than 2 edges.
    %     if (size(edgedist,1)<3)
    %     edgedist = mean(edgedist,1);
    %     else
    
    % Here I will try to take the mean between any 2 lines and find the minimum
    % I will go over every row  and compute the mean of it with every other row.
    % Now I am forced to use for but a short one... So I will reuse j.
    % I will preprepare the mean matrix using the number nchoosek(size(edgedist,1),2)
    meanmat = zeros(nchoosek(size(edgedist,1),2),size(edgedist,2));
    j=1;
     lines_to_treat = nchoosek(1:size(edgedist,1),2);
    while j < size(meanmat,1)+1
       
        line_up = cat(1,edgedist(lines_to_treat(j,1),:),edgedist(lines_to_treat(j,2),:));
        meanmat(j,:) = sum(line_up,1)./2;
        j = j+1; % I forgot this line what a noob mistake
    end
    edgedist = min(meanmat,[],1);
    %     end
    
    % Now the distance based cast that will reduce you the further away you are from the edges.
    distcast = 1 - (edgedist./size(colortemp,2));
    if(flag == 1)
        distcast(edgecolind(2):edgecolind(3)) = 1;
    end
    
    colortempR(i,:) = colortempR(i,:).*distcast;
    colortempG(i,:) = colortempG(i,:).*distcast;
    colortempB(i,:) = colortempB(i,:).*distcast;
    
end
% Sorry for not documenting it all :(
% see LOG 2.9.18 21:56
try
% 2.9.18 19:22 see LOG
% Will now take rows with no edge and reduce them considerably
% Basically, I check for all the possible row indices if they are in edge row
% and then do find on the inverted vecto, finding only the rows with no edge
edgerow=unique(sort(edgerow));
edgenorow = find(~ismember(1:size(edgy,1) ,edgerow));
% see LOG 2.9.18 19:44 for the reasoning behind reducer
reducer = min(0.5,((size(edgy,1)-edgenorow)./(size(edgy,1)-edgerow(end,1)+1))*proc_str);
% And now I just divide by reducer
colortempR(edgenorow,:) = colortempR(edgenorow,:).*reducer';
    colortempG(edgenorow,:) = colortempG(edgenorow,:).*reducer';
    colortempB(edgenorow,:) = colortempB(edgenorow,:).*reducer';
catch
    
end

colortemp = cat(3, colortempR, colortempG, colortempB); % Concatenating the seperate RGB matrices to reproduce an altered image.
% Grayscaling it now
color_filt_img = rgb2gray(colortemp);

% Added on 2.9.18
color_filt_img = imfill(color_filt_img);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% APPROACH 2:                         %
% BRIGHTNESS FILTER (intensity based) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The 'If it is brighter than bright eliminate it' approach:
% we'll carefully enhance brightness and then get rid of too bright spots.


brighttemp = cropped_roots_img;

% Grayscaling it. Sooner than before, and maybe the whole loop will become
% obsolete.
bright_filt_img = rgb2gray(brighttemp);
% Creating a filtering mask according to the brightness rank.
filmask = bright_filt_img>brighfilt(2);

% % Applying the transformation discussed above using an auxillary function made for that purpose
bright_filt_img= colortransform(bright_filt_img, filmask, 0, brighfilt(2), 1, brighfilt(1));
% see LOG 2.9.18 19:00
thresh = 2;
% 
while(thresh > 0.01)
% see LOG 2.9.18 18:34
thresh = max(max(abs(bright_filt_img-imfill(bright_filt_img))));
bright_filt_img=imfill(bright_filt_img);


end

% Creating a filtering mask according to the brightness rank.
filmask = bright_filt_img>brighfilt(1) & bright_filt_img<brighfilt(2);


% Applying the enhancement discussed above using the same auxillary function made for that purpose
% But let's remember % For x1<0.25 x0 = x1 + 0.5. Else, we'll take max(x2, min(3 * x1,1)).
% For compactness and readability we will create another auxillary function.
x0 = determinex0(brighfilt(1),brighfilt(2));
bright_filt_img= colortransform(bright_filt_img, filmask, x0, brighfilt(1), brighfilt(2), 1);
% Figuring out the edge for the next stage
edgy = edge(bright_filt_img,'log',0.0014,3.6);
edgy = bwareaopen(edgy,200);
% more edge related stuff
[edgerow,edgecol] = find(edgy);
[edgerowfull,~,edgerowcount] = unique(sort(edgerow));
edge_counts = accumarray(edgerowcount,1);
value_counts = [edgerowfull, edge_counts];

% for i=1:size(colortemp,1)
for i = value_counts(~(value_counts(:,2)>2))'
    % NOTE: I am aware that for loops in Matlab are not efficient
    % First we want to find if we have edges in this line.
    edgerowind = find(edgerow==i);
    % Then what is their x values
    edgecolind = edgecol(edgerowind);
    % Now I will have take for each point the average distance from the edge
    % First, I will put every column index in a neat line.
    j=1:size(bright_filt_img,2);
    % Now I will take their distances from the edges and then the mean
    edgedist = abs(j-edgecolind);
    edgedist = mean(edgedist,1);
    % Now the distance based cast that will reduce you the further away you are from the edges.
    distcast = 1 - (edgedist./size(bright_filt_img,2));
    
    bright_filt_img(i,:) = bright_filt_img(i,:).*distcast;
end

for i = value_counts((value_counts(:,2)>2))'
    % NOTE: I am aware that for loops in Matlab are not efficient
    % First we want to find if we have edges in this line.
    if(value_counts(:,2)>4)
        edgerowind = [find(edgerow==i,2,'first');find(edgerow==i,2,'last')];
        flag =1;
    else
        edgerowind = find(edgerow==i);
        flag =0;
    end
    
    % Then what is their x values
    edgecolind = edgecol(edgerowind);
    % Now I will have take for each point the average distance from the edge
    % First, I will put every column index in a neat line.
    j=1:size(bright_filt_img,2);
    % Now I will take their distances from the edges and then the mean
    edgedist = abs(j-edgecolind);
    
    
    % Here I will try to take the mean between any 2 lines and find the minimum
    % I will go over every row  and compute the mean of it with every other row.
    % Now I am forced to use for but a short one... So I will reuse j.
    % I will preprepare the mean matrix using the number nchoosek(size(edgedist,1),2)
    meanmat = zeros(nchoosek(size(edgedist,1),2),size(edgedist,2));
    j=1;
     lines_to_treat = nchoosek(1:size(edgedist,1),2);
    while j < size(meanmat,1)+1
       
        line_up = cat(1,edgedist(lines_to_treat(j,1),:),edgedist(lines_to_treat(j,2),:));
        meanmat(j,:) = sum(line_up,1)./2;
        j = j+1; % I forgot this line what a noob mistake
    end
    edgedist = min(meanmat,[],1);
    %     end
    
    % Now the distance based cast that will reduce you the further away you are from the edges.
    distcast = 1 - (edgedist./size(bright_filt_img,2));
    if(flag == 1)
        distcast(edgecolind(2):edgecolind(3)) = 1;
    end
    
    bright_filt_img(i,:) = bright_filt_img(i,:).*distcast;
    
end
% Sorry for not documenting it all :(
% see LOG 2.9.18 21:56
try
% 2.9.18 19:22 see LOG
% Will now take rows with no edge and reduce them considerably
% Basically, I check for all the possible row indices if they are in edge row
% and then do find on the inverted vecto, finding only the rows with no edge
edgerow=unique(sort(edgerow));
edgenorow = find(~ismember(1:size(edgy,1) ,edgerow));
% see LOG 2.9.18 19:44 for the reasoning behind reducer
reducer = min(0.5,((size(edgy,1)-edgenorow)./(size(edgy,1)-edgerow(end,1)+1))*proc_str);
% And now I just divide by reducer
bright_filt_img(edgenorow,:) = bright_filt_img(edgenorow,:).*reducer';
catch
    
end


assignin('base','color_filt_img',color_filt_img);
assignin('base','bright_filt_img',bright_filt_img);
%15.8.18 01:25
uiwait(msgbox('Image processing is done', 'Finished'));

imshow(color_filt_img, 'Parent', handles.alt_img);
hold on
title('color based filter')
hold off

imshow(bright_filt_img, 'Parent', handles.orig_img);
hold on
title('brightness based filter')
hold off


function result = colortransform(colormat, matmask, x0, xa, xb, xf)
% This aux. function will perform the: f(x) = (x-x2)*(x1/(1-x2)) or in the
% next case the: f(x) = [(1-x0)/(x2-x1)]*x + [(x2*x0-x1)/(x2-x1)] .
% So we arrive at f(x;x0,xa,xb,xf) = [(xf-x0)/(xb-xa)] * x + [(xb*x0-xa*xf)/(xb-xa)]
% For the derivation see LOG 01.09.2018 02:18.
% needs as input x (a matrix and a mask) and x0,x1,x2.
% And also after that it does result(matmask) = xf .- result(matmask)
% colormat - One of the channel of the cropped image (Optional: if I use the same function for
%            the intensity filter then maybe also can be the grayscaled image).
% matmask - The appropriate mask telling which elements should be changed in colormat.
% x0 - The lower bound of the new range.
% xa - The lower bound of the original range.
% xb - The upper bound of the original range.
% xf - The upper bound of the new range.

result = colormat; % The easier way to make it work is A(mask) = f[A(mask)]. So I put colormat into result as a first step
result(matmask) = ((xf-x0)/(xb-xa)) .* result(matmask) + ((xb*x0-xa*xf)/(xb-xa));%*matmask(matmask);
if(x0 == 0)
    result(matmask) = xf - result(matmask);
end
end
function x0 = determinex0(x1,x2)
% For x1<0.25 x0 = x1 + 0.5. Else, we'll take max(x2, min(3 * x1,0.85)).
if(x1<0.25)
    x0 = x1 + 0.7;
else
    x0 = max(x2, min(3 * x1,0.9)) ;
end
end
end