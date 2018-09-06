% lychtst for GUI
% 10.8.2018 11:03


% 10.8.18 11:13
% Extracting the variables
lych_tst2 = evalin('base', 'lych_tst2');
rootx = evalin('base', 'rootx');
rooty = evalin('base', 'rooty');

% UPDATE 18.7.18 10:45 -
% Will try to implement an approach where the crop window will get smaller
% if the area around the points is bright. See log.

% First the default value
crop_str = 0.5;


% Inverted back to avoid a lot of problems - 18.7.18 11:07
% Inverting the image
lych_tst2 = 1.- lych_tst2;
% Rounding the indices
rootx=round(rootx);
rooty=round(rooty);

rxmin = min(rootx)- crop_str * std(rootx); % The minimal x of the rect.
rymin = min(rooty)- crop_str * std(rooty); % The minimal y of the rect.
rwidth = max(rootx)+ crop_str * std(rootx) - rxmin; % The width of the rect.
rheight = max(rooty)+ crop_str * std(rooty) - rymin; % The height of the rect.
crop_window = [rxmin, rymin, rwidth, rheight]; % The rect object that will be used in imcrop
% The cropping of the image using the crop_window
lychcrop2 = imcrop(lych_tst2,crop_window);
clear('rxmin','rymin','rwidth','rheight');
%TEST - showing the cropped part
image(lychcrop2)

lychsize = size(lych_tst2);
lychpoi = [0:2]*lychsize(1)*lychsize(2)+(rootx-1)*lychsize(1)+rooty;

% Finally we extract the colors themselves of the 5 chosen pixels
% lychpcolor = lych_tst2(lychpoi);


% 19.7.18 18:54
% Mean extraction with a loop that will take the 3
% pixels in each column (3 columns)
means = 0;
for i = -1:1
    means = means + lych_tst2(lychpoi-lychsize(1)+i) + lych_tst2(lychpoi+i) + lych_tst2(lychpoi + lychsize(1) + i);
end
% Finally we extract the colors themselves of the 5 chosen pixels
lychpcolor = means./9;


% -- from here on original image no longer necessary

% % Added (18.7 13:46)
% % Doing a scaled enhancement to differentiate them better - everything that isn't black gets brighter,
% % and the brighter you are the brighter you get
% lychpcolor = lychpcolor.*1.1;
% lychpcolor = lychpcolor.*1.1;
% lychpcolor = lychpcolor.*(1.1+lychpcolor.^2);
% Gamma correction conflixts with this and is better

% And now we can calculate the mean +- 3*standard deviation for the range
% for each color
cfiltR = [mean(lychpcolor(:,1))-3*std(lychpcolor(:,1)) mean(lychpcolor(:,1))+3*std(lychpcolor(:,1))];
cfiltG = [mean(lychpcolor(:,2))-3*std(lychpcolor(:,2)) mean(lychpcolor(:,2))+3*std(lychpcolor(:,2))];
cfiltB = [mean(lychpcolor(:,3))-3*std(lychpcolor(:,3)) mean(lychpcolor(:,3))+3*std(lychpcolor(:,3))];
% tried 1*std, 2*std as well, but 3*std works best for now

% Now for the brightness range. We'll just take an average of the three
% above filters
brighfilt = (cfiltR+cfiltG+cfiltB)./3;

%% APPROACH 1: USING INPUT FROM USER TO ESTIMATE THE RANGE of the root colours
%% Adding Colour separation filtering

% UPDATE 16.718 12:06 - Now that we receive the poins from the user, we can
% do an initial color filtering based on the RGB values of those
% points. After that, we will apply the graying filter from before.
Imtst = lychcrop2;
% Seperate to RGB matrices
ImtstR=Imtst(:,:,1);
ImtstG=Imtst(:,:,2);
ImtstB=Imtst(:,:,3);

% Creating 3 filtering masks according to the three color ranges for each
% channel separately
filmaskR = ImtstR<cfiltR(1) | ImtstR>cfiltR(2);
filmaskG = ImtstG<cfiltG(1) | ImtstG>cfiltG(2);
filmaskB = ImtstB<cfiltB(1) | ImtstB>cfiltB(2);


% Applying the filtering masks to all 3 colour channels, ie set it to black
ImtstR(filmaskR)=0;
ImtstG(filmaskR)=0;
ImtstB(filmaskR)=0;
ImtstR(filmaskG)=0;
ImtstG(filmaskG)=0;
ImtstB(filmaskG)=0;
ImtstR(filmaskB)=0;
ImtstG(filmaskB)=0;
ImtstB(filmaskB)=0;

Imtst = cat(3, ImtstR, ImtstG, ImtstB); % Concatenating the seperate RGB matrices to reproduce an altered image.
Imbacktst = Imtst; % I'll back it up for now until TESTING some of the things is over

clear('filmaskR','filmaskG','filmaskB') %  ,'rootx','rooty')
% We (no longer) start with the brightness based filteration in order to enhance the
% difference between the color channels

% Now performing RGB level difference based filtering. Basically, if the
% RGB components are too far apart the pixel is blackend

% First - R to G

% Creating the filtering mask
% test if difference between R and G channel are above threshold
filmask = (Imtst(:,:,1)-Imtst(:,:,2))>(1.5*mean([cfiltR(2)-cfiltR(1),cfiltG(2)-cfiltG(1)]));

% Separate to RGB matrices
ImtstR=Imtst(:,:,1);
ImtstG=Imtst(:,:,2);
ImtstB=Imtst(:,:,3);
% Applying the filtering mask to all 3 colour channels, ie set it to black
ImtstR(filmask)=0;
ImtstG(filmask)=0;
ImtstB(filmask)=0;

% rebuild RGB image
Imtst = cat(3, ImtstR, ImtstG, ImtstB); % Concatenating the seperate RGB matrices to reproduce an altered image.

% Second - R to B

% Creating the filtering mask
filmask = (Imtst(:,:,1)-Imtst(:,:,3))>(1.5*mean([cfiltR(2)-cfiltR(1),cfiltB(2)-cfiltB(1)]));

% Seperate to RGB matrices
ImtstR=Imtst(:,:,1);
ImtstG=Imtst(:,:,2);
ImtstB=Imtst(:,:,3);
% Applying the filtering mask to all 3 colors
ImtstR(filmask)=0;
ImtstG(filmask)=0;
ImtstB(filmask)=0;

Imtst = cat(3, ImtstR, ImtstG, ImtstB); % Concatenating the seperate R G and B matrices to reproduce an altered image.


% Third - G to B

% Creating the filtering mask
filmask = (Imtst(:,:,2)-Imtst(:,:,3))>(1.5*mean([cfiltB(2)-cfiltB(1),cfiltG(2)-cfiltG(1)]));

% Seperate to RGB matrices
ImtstR=Imtst(:,:,1);
ImtstG=Imtst(:,:,2);
ImtstB=Imtst(:,:,3);
% Applying the filtering mask to all 3 colors
ImtstR(filmask)=0;
ImtstG(filmask)=0;
ImtstB(filmask)=0;

Imtst = cat(3, ImtstR, ImtstG, ImtstB); % Concatenating the seperate R G and B matrices to reproduce an altered image.

% Grayscaling it now
graywarden = rgb2gray(Imtst);


%% APPROACH 2:
%% BRIGHTNESS FILTER (intensity based)
% The 'If it is brighter than bright eliminate it' approach:
% we'll carefully enhance brightness and then get rid of too bright spots.


Imtstbri = lychcrop2;

% Grayscaling it. Sooner than before, and maybe the whole loop will become
% obsolete.
brighttst = rgb2gray(Imtstbri);

% Creating a filtering mask according to the brightness rank.
filmask = brighttst<brighfilt(1) | brighttst>brighfilt(2);

brighttst(filmask)=0;







%% NEW SECTION 19.7.18 23:28 (see LOG)
%% Optional free hand cropping

answer = questdlg('Would you like to crop a region around the root by hand to improve the efficiency1?', 'Cropping query','Yes','No','No');

% It wasn't happy with using 'Yes' as a condition when 'No' was chosen.
% So a new variable was created. logical

switch answer
    case 'Yes'
        flag = true;
    case 'No'
        flag = false;
end

% A while loop that allows the user to try again if he is not pleased with
% the result.
brightcrop = brighttst; % see LOG 20.7 11:42
while (flag == true)
    graycrop = graywarden; % temp matrix
    imshow(graycrop);
    h = imfreehand; %draw the cropping window
    M = ~h.createMask(); % Creates a mask in which the outside of the region will later be zeroed
    graycrop(M) = 0; % Zeroes it
    brightcrop(M) = 0; % see LOG 20.7 11:42
    imshow(graycrop); %Shows the result.
    answer = questdlg('Would you like to redo the cropping?', 'Another try?','Yes','No','No');
    
    switch answer
        case 'Yes'
            flag = true;
        case 'No'
            flag = false;
            graywarden = graycrop; % Finally returning the cropped image home
            brighttst = brightcrop; % see LOG 20.7 11:42
            clear graycrop
    end
    
    
end
%% %%%THE BEST APPROACH is this + the intensity filter. Not an average.

%% AD APPROACH 1: the colour-based approach
% Trying to use fibermetric to get rid of the annoying thorns without
% sacrificing root. Hopefully, it will make the rest of the section become
% better. First imfill though
skeletor = imfill(graywarden,'holes');
% function that enhances tubular structures(?)
skeletor = fibermetric(skeletor,20, 'StructureSensitivity', 0.02);

%Some Testing showed that
% bwareaopen(imbinarize(wiener2(imfill(skeletor,'holes'),[1 12]),'adaptive','Sensitivity',0.45),400)
% is very good, so we will do the necessary steps (16.7.18 18:56)

skeletor = imfill(skeletor,'holes');
skeletor = wiener2(skeletor,[1 3]);
% The last added step is after the binarization.
% % Doing a set of binarizing, getting rid of isolated points, filling stuff
% % and then skeletonizing and other methods. One of the differnces from
% before are the 2 steps above.
skeletor=imbinarize(skeletor,'adaptive','Sensitivity',1);
% UPDATE - Added the wiener2 noise filtering function

% Last new step
skeletor = bwareaopen(skeletor,400);

skeletor = medfilt2(skeletor);
% Added the medfilt2 filtering function to try and improve the process to
% exclude closed rings (loops) and such


% fill in holes in the binarised image
skeletor = imfill(skeletor,'holes');
% clean isolated pixels until image series converges  -- DOES NOT CHANGE MUCH, sort of safety measure
skeletor = bwmorph(skeletor,'clean',Inf);
% get rid of isolated non-root structures (< 35 pixels), BUT BE CAREFUL: WE CAN
% DESTROY ROOTS
% Added another one before skeletonisation
skeletor = bwareaopen(skeletor,200);

%  extract skeleton
skeletor=bwmorph(skeletor,'skel',Inf);
% fill in holes b/c skeltetonisation creates holes sometimes
skeletor=imfill(skeletor,'holes');
% close small gaps
skeletor=bwmorph(skeletor,'bridge',Inf);
% get rid of isolated non-root structures (< 35 pixels), BUT BE CAREFUL: WE CAN
% DESTROY ROOTS
skeletor=bwareaopen(skeletor,35);



% destroy small branches -- BE CAREFUL: IN PICTURE2 DESTROYS ROOTS --- FIX IT.
skeletor = bwmorph(skeletor,'spur',15);

% get rid of isolated non-root structures (< 35 pixels), BUT BE CAREFUL: WE CAN
% DESTROY ROOTS
skeletor=bwareaopen(skeletor,35);



%% % AD APPROACH 2: The intensity method skeleton
% I shall now apply the new refined process in the hopes of it working
% smoothly.
% SEE COMMENTS IN PREVIOUS SECTION PLEASE.

skeletor2 = imfill(brighttst,'holes');

skeletor2 = fibermetric(skeletor2,20, 'StructureSensitivity', 0.02);

%Some Testing showed that
% bwareaopen(imbinarize(wiener2(imfill(skeletor,'holes'),[1 12]),'adaptive','Sensitivity',0.45),400)
% is very good, so we will do the necessary steps (16.7.18 18:56)

skeletor2 = imfill(skeletor2,'holes');
skeletor2 = wiener2(skeletor2,[1 2]);

skeletor2=imbinarize(skeletor2,'adaptive','Sensitivity',1);


% Last new step
skeletor2 = bwareaopen(skeletor2,400);

skeletor2 = medfilt2(skeletor2);
% Added the medfilt2 filtering function

skeletor2=imfill(skeletor2,'holes');
skeletor2=bwmorph(skeletor2,'skel',Inf);
skeletor2=imfill(skeletor2,'holes');
skeletor2=bwmorph(skeletor2,'bridge',Inf);
skeletor2=bwareaopen(skeletor2,100);
skeletor2=bwmorph(skeletor2,'spur',15); % Kind of a success. With these functions we get roots without little branches.


%% COMBINING APPROACH 1 + 2: A unified front
% The avarage binarized:
uniskel=0.5*(skeletor+skeletor2);
uniskel(uniskel>0)=1;

uniskel=bwmorph(uniskel,'spur',15); % Kind of a success. With these functions we get roots without little branches.


% To implement the optional additional cleaning, created a variable
% howClean instead of a static number
howClean = 70;
uniskel=bwareaopen(uniskel,howClean);

imshowpair(lychcrop2*2,uniskel);

%% Optional additional cleaning (see LOG 19.7.18 19:01)
% Will ask the user whether it wants additional cleaning, and then loop on
% it until he is satisfied.

answer = questdlg('Would you like the script to attempt additional cleaning?', 'Cleaning query','Yes','No','No');

% It wasn't happy with using 'Yes' as a condition when 'No' was chosen.
% So a new variable was created. logical

switch answer
    case 'Yes'
        flag = true;
    case 'No'
        flag = false;
end


if (flag == true)
    superskel = uniskel; % That new addition that allows reverting to the one step before last.
    while (flag == true)
        % First will take the one from the last iteration. The statement is here so
        % that the undoing of the last step will be possible. If I put it
        % at the end of the while loop, the information will be lost.
        uniskel = superskel;
        % Now that the howClean variable exists, we can increment it.
        howClean = howClean + 30;
        superskel=bwareaopen(uniskel,howClean);
        imshowpair(lychcrop2*2,superskel);
        answer = questdlg('Would you like more cleaning?', 'Cleaning query','Yes','No','Yes');
        
        % It wasn't happy with using 'Yes' as a condition when 'No' was chosen.
        % So a new variable was created. logical.
        % Again. maybe Matlab has 'do while'
        switch answer
            case 'Yes'
                flag = true;
            case 'No'
                flag = false;
        end
    end
    % Now I shall offer the possibility to undo last step.
    % In actuallity, if you press 'Yes' nothing will happen because the
    % information of the last step is in superskel which is not used later.
    % If you press 'No' the info from superskel will be put in uniskel.
    answer = questdlg('Would you like to undo last step?', 'Undo last step','Yes','No','No');
    switch answer
        case 'No'
            uniskel = superskel;
    end
end

% And finally, showing results
imshowpair(lychcrop2*2,uniskel);

%% % Instead of working on the whole window, we will work on each root separately and so ->


%  % Creating a rotated matrix
[lastrow, junk] = find(uniskel, 1, 'last' ); % last white pixel is tip of the root
uniskelsize = size(uniskel);
crop_window = [0, lastrow-50, uniskelsize(2), 65];
   workskel = imcrop(uniskel,crop_window);
   workskelR=imrotate(workskel,90);
%  % Vectors for positions of 1's (new x ordered [x after rotation])
  [skerowx,skecolx] = find(workskelR);
%  % And a matrix
  skelmatR = cat(2,skecolx,skerowx);
  
  % In order to be used in curvature script
  assignin('base','skelmatR',skelmatR);

%% % LOG - Started updating at 17.7.18 10:53

% Had a problem that the colour filter kind of destroyed the root. So I
% opened a live script and started tweaking. Turns out the grayness
% checker was too restrictive. So I'm trying out an approach based on the
% original color ranges' size.

% 11:10
% Decided to adjust the previous idea by applying a multiplication to
% adjust to the multiplication of the data itself. Noticed another
% problem: now the root is cut. Will first try to reduce spur.
% It was fixd at the cost of a thorn.
% Will now apply to original code.

% 11:26
% Decided to check to loop I previously used in the broghtness filter.
% The original one is too much. Will try tweaking.
% Found that if I tweak the mult. factor to 1.1 And add a scaled filter
% for a bottom constraint I get better results. Will try some more
% tweaking. Changed the number of runs to 7.
% Will now apply to original code.

% 12:26
% We will now try inverting the image at the beginning as per
% request.
% Also, will now try median filtering before the user chooses points, both for
% his sake and the script's.
% The median filtering was a complete failure. Will try to somehow
% deconvolve/deblur. The good functions require something called PSF but
% there is a blind function that uses a guess for PSF and returns a better
% estimate. So it is possible to then immidiately use a better function.
% I shall test in the live script.



% %18.7.18% %

%10:41
% Had an idea: checking the surroundings of the points and if they are
% bright then choose a smaller crop window. Will try to implement now.

% 13:16
% There are some updates written all over, but that's not why I'm here.
% It would seem the filters are being too restrictive on one of the
% roots. first og all, removed 2 excess medfilts and decided to add a
% condition that if the color ranges are too small so we'll enlarge them.

% 13:36
% Still didn't do the condition but I did tweak the color difference,
% which didn't work well, which made me decide to do the
% *1.1*1.1*(1.1+_^2) even earlier and activate it on the color filters as
% well. and ergo the brightness filter will also be affected.

% 18:13
% Had a genius idea on how to remove thorns EFFECTIVELY
% Doing skel-bwmorph(branchpoints) and then bwareaopen and then fill in
% the gaps. Wiil try

% 18:28
% maybe removing the end points before performing the cleaning will hell.

% 19.7.18

% 1:23
% Will try to use 'adaptthresh' function on the lychcrop2 at the beginning

% 1:47
% After finding that you can change the neighborhood size achieved good
% results. Will try to implement at the beginning.

% 12:39
% Accidently came acrros gamma adjustment, and it might just solve all of
% our problems. will try to implement at the beginning.

% 12:59
% Tweaked some more - sensitivity in imbinarize to 0.95 and spur to 15
% Then tweaked to 1.

% 13:05
% Tweaked so all 3 final bwareaopen (skeletor 1+2 and uniskel) will have
% the number 400. Seems to drastically improve.
% Also removed spur from unskel.
% Tweaked back for skeletor2 to 100.
% And was forced to tweak in uniskel to 70.

% 13:23
% In 4th image, multiplying by 3 from the beginning was problematic. I'll
% try moving it to after the gamma and check.
% Now I'll try to move to after the local thresh.
% Forced to cancel. Let's go over the other images and hope for the best.
% Changed the multiplication in front of the gamma correction to 18 as a
% result. But now I think that I should change it to 10 and then multiply
% the local thresh by 2. will try.

% 13:33
% Decided instead that I will try to implement a condition that if the
% image is too dark multiply by 3.
% After looking at the mean of the 4 pictures, decided on:
% if(mean(mean(mean(lych_tst2)))<0.4)

%14:33
% Changed the statistic of the adpative thresholding to median.
% I think it improved it.

%15:17
% I have decided to try and have the user choose the file.
% I have successfully found a function for that
% uigetfile
% Will implement.

% 15:24
% Needed to change to include path. Also added the '*.jpg'.

% 15:33
% UPDATE - Replaced the content of imread to accomodate the user
% choosing the file.

% 17:40
% Time to implement the feedback of tking an average of the colors of the
% neighborhoods for the points.

% 18:52
% After dawdling, I will move the implementation to main code.

% 19:01
% will try to implement a question for the user whether to clean the photo
% further. Then will try to implement cleaning

% 19:36
% Decided to add a new variable if the user wants cleaning so that he could
% revert one step back if he chooses to. Will also present the choice to
% revert of course.

% 23:26
% I have now found a way to do a "freehand" crop of sorts.
% Will add an optional section that allows the user to freehand crop.

% 20.7.18

% 11:42
% wanted to try to implement a cropping out of offshoots, using the imfreehand
% like yesterday night. But just before I started I had a better idea.
% I will use the freehand crop the user chose for graywarden for BOTH
% graywarden AND brighttst.



% 10.8.18, 09:35

% Started lychtst3.

% 09:50 
% I'm exploring things. For example, uisave for saving the workspace.



% 11:25
% Added the assignin for workskelR so that it can be used in curvature