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

% And now we can calculate the mean +- 3*standard deviation for the range
% for each color
cfiltR = [mean(root_points_color(:,1))-3*std(root_points_color(:,1)) mean(root_points_color(:,1))+3*std(root_points_color(:,1))];
cfiltG = [mean(root_points_color(:,2))-3*std(root_points_color(:,2)) mean(root_points_color(:,2))+3*std(root_points_color(:,2))];
cfiltB = [mean(root_points_color(:,3))-3*std(root_points_color(:,3)) mean(root_points_color(:,3))+3*std(root_points_color(:,3))];
% tried 1*std, 2*std as well, but 3*std works best for now

% Now for the brightness range. We'll just take an average of the three
% above filters
brighfilt = (cfiltR+cfiltG+cfiltB)./3;

% Will try to use in force tip. 13.8.18 00:16 -CHANGED TO mean(brighfilt)
assignin('base','root_mean_color',mean(brighfilt))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% APPROACH 1: USING INPUT FROM USER TO ESTIMATE THE RANGE of the root colours %
%                       Adding Colour separation filtering                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPDATE 16.7.18 12:06 - Now that we receive the poins from the user, we can
% do an initial color filtering based on the RGB values of those
% points. After that, we will apply the graying filter from before.
colortemp = cropped_roots_img;
% Seperate to RGB matrices
colortempR=colortemp(:,:,1);
colortempG=colortemp(:,:,2);
colortempB=colortemp(:,:,3);

% Creating 3 filtering masks according to the three color ranges for each
% channel separately
filmaskR = colortempR<cfiltR(1) | colortempR>cfiltR(2);
filmaskG = colortempG<cfiltG(1) | colortempG>cfiltG(2);
filmaskB = colortempB<cfiltB(1) | colortempB>cfiltB(2);


% Applying the filtering masks to all 3 colour channels, ie set it to black
colortempR(filmaskR)=0;
colortempG(filmaskR)=0;
colortempB(filmaskR)=0;
colortempR(filmaskG)=0;
colortempG(filmaskG)=0;
colortempB(filmaskG)=0;
colortempR(filmaskB)=0;
colortempG(filmaskB)=0;
colortempB(filmaskB)=0;

colortemp = cat(3, colortempR, colortempG, colortempB); % Concatenating the seperate RGB matrices to reproduce an altered image.

% We (no longer) start with the brightness based filteration in order to enhance the
% difference between the color channels

% Now performing RGB level difference based filtering. Basically, if the
% RGB components are too far apart the pixel is blackend

% First - R to G

% Creating the filtering mask
% test if difference between R and G channel are above threshold
filmask = (colortemp(:,:,1)-colortemp(:,:,2))>(1.5*mean([cfiltR(2)-cfiltR(1),cfiltG(2)-cfiltG(1)]));

% Separate to RGB matrices
colortempR=colortemp(:,:,1);
colortempG=colortemp(:,:,2);
colortempB=colortemp(:,:,3);
% Applying the filtering mask to all 3 colour channels, ie set it to black
colortempR(filmask)=0;
colortempG(filmask)=0;
colortempB(filmask)=0;

% rebuild RGB image
colortemp = cat(3, colortempR, colortempG, colortempB); % Concatenating the seperate RGB matrices to reproduce an altered image.

% Second - R to B

% Creating the filtering mask
filmask = (colortemp(:,:,1)-colortemp(:,:,3))>(1.5*mean([cfiltR(2)-cfiltR(1),cfiltB(2)-cfiltB(1)]));

% Seperate to RGB matrices
colortempR=colortemp(:,:,1);
colortempG=colortemp(:,:,2);
colortempB=colortemp(:,:,3);
% Applying the filtering mask to all 3 colors
colortempR(filmask)=0;
colortempG(filmask)=0;
colortempB(filmask)=0;

colortemp = cat(3, colortempR, colortempG, colortempB); % Concatenating the seperate R G and B matrices to reproduce an altered image.


% Third - G to B

% Creating the filtering mask
filmask = (colortemp(:,:,2)-colortemp(:,:,3))>(1.5*mean([cfiltB(2)-cfiltB(1),cfiltG(2)-cfiltG(1)]));

% Seperate to RGB matrices
colortempR=colortemp(:,:,1);
colortempG=colortemp(:,:,2);
colortempB=colortemp(:,:,3);
% Applying the filtering mask to all 3 colors
colortempR(filmask)=0;
colortempG(filmask)=0;
colortempB(filmask)=0;

colortemp = cat(3, colortempR, colortempG, colortempB); % Concatenating the seperate R G and B matrices to reproduce an altered image.

% Grayscaling it now
color_filt_img = rgb2gray(colortemp);

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
filmask = bright_filt_img<brighfilt(1) | bright_filt_img>brighfilt(2);

bright_filt_img(filmask)=0;

assignin('base','color_filt_img',color_filt_img);
assignin('base','bright_filt_img',bright_filt_img);
%15.8.18 01:25
uiwait(msgbox('Image processing is done', 'Finished'));
end