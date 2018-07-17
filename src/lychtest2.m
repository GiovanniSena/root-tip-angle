% Lychee test 2
% 
% 16.7.18, ~Noon
%
% %

%%
clear variables
% For a fresh start
% Having a string with the file name
 file_name = 'Lychee_test1.jpg';
% file_name = 'Lychee_test2.jpg';
% file_name = 'Lychee_test3_2018-03-06_1630.jpg';
% file_name = 'Lychee_test4_2018-03-08_1220.jpg';


lych_tst2 = imread(file_name);
lych_tst2=double(lych_tst2) /255; % Converting to double



% EPIC FAIL!!!!!!!!!! DO NOT RETURN TO!!!! CAUSED DISCREPANCY BETWEEN THE
% INDICES I GOT FROM THE USER AND WHAT I TRIED TO GET FROM THWE CROPPED
% IMAGE. TOOK ME VERY *VERY* LONG TO FIND THE ERROR.
% % % % % % % % % % UPDATE** **16.7.18 19:26** ---
% % % % % % % % % % DECIDED to let the user crop and then choose points for better choice of
% % % % % % % % % % points.
% % % % % % % % % % SO first more instructions for the user, then crop, and then the rest
% % % % % % uiwait(msgbox({'Please choose a window in which the root is (big window)' 'Press ENTER when finished'},'User instructions 1','modal'));
% % % % % % 
% % % % % % % ask user to draw window
% % % % % % lychcrop2 = imcrop(lych_tst2); % Were askede to make user choose points
% % % % % % % instead

%
% Will try to implement it in a different manner.



% Writing the instructions for the user
% UPDATE 16.7.18 15:07 - Added uiwait so that the image will not pop before
% the user clicks ok
uiwait(msgbox({'Please choose 5 evenly spaced points on the desired root starting with the tip.' 'Press BACKWARDS to delete point' 'Press ENTER when finished'},'User instructions','modal'));


%showing the original photo
figure
image(lych_tst2*3); % Changed foe UPDATE**
%image(imcrop(lych_tst2));



hold on
% Getting the 5 points from the user
[rootx,rooty] = getpts;
hold off
% Now that we have the points, we will use them for several purposes.

% First, we will use them to define a cropping window:
% We will create the cropping rectangle:
rxmin = min(rootx)-0.5*std(rootx); % The minimal x of the rect.
rymin = min(rooty)-0.5*std(rooty); % The minimal y of the rect.
rwidth = max(rootx)+0.5*std(rootx) - rxmin; % The width of the rect.
rheight = max(rooty)+0.5*std(rooty) - rymin; % The height of the rect.
crop_window = [rxmin, rymin, rwidth, rheight]; % The rect object that will be used in imcrop
% The cropping of the image using the crop_window
lychcrop2 = imcrop(lych_tst2,crop_window); 
clear('rxmin','rymin','rwidth','rheight');
%TEST - showing the cropped part
image(lychcrop2)


% Second, we will use the point to decide on the filtering range for the
% color filter, expanding it to filter using the information from the
% points before filtering according to the assumption that the rots are
% gray.
% We will now define three color filters: cfiltR, cfiltG and cfiltB, as
% 1X2 vectors. Anything outside of this range shall be filtered out. First,
% let's grab the data.
% First we round the index vectors
% Created new variables instead of changing the old ones for TESTING
% rootxr=round(rootx);
% rootyr=round(rooty);
% TESTING COMPLETE
rootx=round(rootx);
rooty=round(rooty);
% Next, we exract the linear indices so we can extract the
% colors.
% HAD SOME DIFFICULTY. SEARCHED FOR ANSWER. FOUND ONE:
% If you specify more than two subscripts, MATLAB extends its indexing scheme 
% accordingly. For example, consider four subscripts (i,j,k,l) into a 
% four-dimensional array with size [d1 d2 d3 d4]. MATLAB calculates the 
% offset into the storage column by
% (l-1)(d3)(d2)(d1)+(k-1)(d2)(d1)+(j-1)(d1)+i
lychsize = size(lych_tst2);
lychpoi = [0:2]*lychsize(1)*lychsize(2)+(rootx-1)*lychsize(1)+rooty;

% Finally we extract the colors themselves
lychpcolor = lych_tst2(lychpoi);

% And now we can calculate the mean +- 1*standard deviation for the reange
% for each color
cfiltR = [mean(lychpcolor(:,1))-1*std(lychpcolor(:,1)) mean(lychpcolor(:,1))+1*std(lychpcolor(:,1))];
cfiltG = [mean(lychpcolor(:,2))-1*std(lychpcolor(:,2)) mean(lychpcolor(:,2))+1*std(lychpcolor(:,2))];
cfiltB = [mean(lychpcolor(:,3))-1*std(lychpcolor(:,3)) mean(lychpcolor(:,3))+1*std(lychpcolor(:,3))];


% Now for the brightness range. We'll just take an average of the three
% above filters
brighfilt = (cfiltR+cfiltG+cfiltB)./3;
%% % Adding Colour separation filtering

% UPDATE 16.718 12:06 - Now that we receive the poins from the user, we can
% do an initial color filtering based on the R G & B values of those
% points. After that, we will apply the gray-ing filter from before.
Imtst = lychcrop2;

% Seperate to R G & B matrices
ImtstR=Imtst(:,:,1);
ImtstG=Imtst(:,:,2);
ImtstB=Imtst(:,:,3);

% Creating 3 filtering masks according to the three color ranges
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

Imtst = cat(3, ImtstR, ImtstG, ImtstB); % Concatenating the seperate R G and B matrices to reproduce an altered image.
Imbacktst = Imtst; % I'll back it up for now until TESTING some of the things is over

clear('filmaskR','filmaskG','filmaskB','rootx','rooty')
% We (no longer) start with the brightness based filteration in order to enhance the
% difference between the color channels

% Imtst = lychcrop2*3; % UNNECESSARY NOW that we have the filter above.

% Doing a scaled enhancment - everything that isn't black gets brighter,
% and the brighter you are the brighter you get
Imtst = Imtst.*1.1;
Imtst = Imtst.*1.1;
Imtst = Imtst.*(1.1+Imtst.^2);


% Now performing RGB level difference based filtering. Basically, if the
% RGB components are too far apart the pixel is blackend

% First - R to G

% Creating the filtering mask
% test if difference between R and G channel are above threshold
filmask = (Imtst(:,:,1)-Imtst(:,:,2))>0.05;

% Seperate to R G & B matrices
ImtstR=Imtst(:,:,1);
ImtstG=Imtst(:,:,2);
ImtstB=Imtst(:,:,3);
% Applying the filtering mask to all 3 colour channels, ie set it to black
ImtstR(filmask)=0;
ImtstG(filmask)=0;
ImtstB(filmask)=0;

% rebuild RGB image
Imtst = cat(3, ImtstR, ImtstG, ImtstB); % Concatenating the seperate R G and B matrices to reproduce an altered image.

% Second - R to B

% Creating the filtering mask
filmask = (Imtst(:,:,1)-Imtst(:,:,3))>0.05;

% Seperate to R G & B matrices
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
filmask = (Imtst(:,:,2)-Imtst(:,:,3))>0.05;

% Seperate to R G & B matrices
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



%%
% The 'If it is brighter than bright eliminate it' approach:
% we'll carefully enhance brightness and then get rid of too bright spots.


Imtstbri = lychcrop2;

% Grayscaling it. Sooner than before, and maybe the whole loop will become
% obsolete.
brighttst = rgb2gray(Imtstbri);

% Creating a filtering mask according to the brightness rang.
filmask = brighttst<brighfilt(1) | brighttst>brighfilt(2);

brighttst(filmask)=0;

% % Eliminating too bright cells.
% Imtstbri(Imtstbri>0.55)=0;
% OBSOLETE now that we have the filter above it.


% % Will soon decide if it is still necessary
% for i=1:5
%     % Multiplication and elimination of >1
%     Imtstbri = Imtstbri * 1.4;
%     % Filtering on all color channels.
%     % We check which color values have value over 1.
%     afilmask = Imtstbri>1;
%     % Then we create a filter which is 0 if even on of the channels is over
%     % 1.
%     filmask = (1.-afilmask(:,:,1)).* (1.-afilmask(:,:,2)).* (1.-afilmask(:,:,3));
%     % Then we apply the mask to all color channels
%     Imtstbri(:,:,1) = Imtstbri(:,:,1) .* (filmask);
%     Imtstbri(:,:,2) = Imtstbri(:,:,2) .* (filmask);
%     Imtstbri(:,:,3) = Imtstbri(:,:,3) .* (filmask);
%     
% 
% end
% For now will not use it




 
 

%% %THE BEST APPROACH is this + the intensity filter. Not an average.

% Trying to use fibermetric to get rid of the annoying thorns without
% sacrifiacing root. Hopefully, it will make the rest of the section become
% better. First imfill though
skeletor = imfill(graywarden,'holes');
skeletor = fibermetric(skeletor,20, 'StructureSensitivity', 0.04);

%Some Testing showed that
% bwareaopen(imbinarize(wiener2(imfill(skeletor,'holes'),[1 12]),'adaptive','Sensitivity',0.45),400)
% is very good, so we will do the necessary steps (16.7.18 18:56)

skeletor = imfill(skeletor,'holes');
skeletor = wiener2(skeletor,[1 12]);
% The last added step is after the binarization.
% % Doing a set of binarizing, getting rid of isolated points, filling stuff
% % and then skeletonizing and other methods. One of the differnces from
% before are the 2 steps above.
skeletor=imbinarize(skeletor,'adaptive','Sensitivity',0.45);
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
% Added another one before skeletization
skeletor = bwareaopen(skeletor,200);

%  extract skeleton
skeletor=bwmorph(skeletor,'skel',Inf);
% fill in holes b/c skeltetisation creates holes sometimes
skeletor=imfill(skeletor,'holes');
% close small gaps
skeletor=bwmorph(skeletor,'bridge',Inf);
% get rid of isolated non-root structures (< 35 pixels), BUT BE CAREFUL: WE CAN
% DESTROY ROOTS
skeletor=bwareaopen(skeletor,35);



% destroy small branches -- BE CAREFUL: IN PICTURE2 DESTROYS ROOTS --- FIX IT.
skeletor = bwmorph(skeletor,'spur',25); 

% get rid of isolated non-root structures (< 35 pixels), BUT BE CAREFUL: WE CAN
% DESTROY ROOTS
skeletor=bwareaopen(skeletor,35);


%  figure
%  imshowpair(lychcrop2*2,skeletor); %TEST

%% % The intensity method skeleton
% I shall now apply the new refined process in the hopes of it working
% smoothly.
% SEE COMMENTS IN PREVIOUS SECTION PLEASE.

skeletor2 = imfill(brighttst,'holes');

skeletor2 = fibermetric(skeletor2,20, 'StructureSensitivity', 0.04);

%Some Testing showed that
% bwareaopen(imbinarize(wiener2(imfill(skeletor,'holes'),[1 12]),'adaptive','Sensitivity',0.45),400)
% is very good, so we will do the necessary steps (16.7.18 18:56)

skeletor2 = imfill(skeletor2,'holes');
skeletor2 = wiener2(skeletor2,[1 12]);

skeletor2=imbinarize(skeletor2,'adaptive','Sensitivity',0.45);


% Last new step
skeletor2 = bwareaopen(skeletor2,400);

skeletor2 = medfilt2(skeletor2);
% Added the medfilt2 filtering function

skeletor2=imfill(skeletor2,'holes');
skeletor2=bwmorph(skeletor2,'skel',Inf);
skeletor2=imfill(skeletor2,'holes');
skeletor2=bwmorph(skeletor2,'bridge',Inf);
skeletor2=bwareaopen(skeletor2,30);
skeletor2=bwmorph(skeletor2,'spur',10); % Kind of a success. With these functions we get roots without little branches.

% figure
%  imshowpair(lychcrop2*2,skeletor2); % TEST

% So - this one on its own is much less effective but it does see the right
% root. let's see what happens when we combine them.

% figure
%  imshowpair(lychcrop2*2,skeletor+2*skeletor2); %TEST
%% %A unified front
 % The avarage binarized:
 uniskel=0.5*(skeletor+skeletor2);
 uniskel(uniskel>0)=1;
 
 uniskel=bwmorph(uniskel,'spur',16); % Kind of a success. With these functions we get roots without little branches.

 uniskel = imfill(uniskel,'holes');
uniskel = bwmorph(uniskel,'skel',Inf);
uniskel=bwmorph(uniskel,'spur',1);

% After some testing around, I arrived at this. Will now try other roots
% (16.7.18 19:18).
 figure
 %TESTING REGION
% figure
 % imshowpair(skeletor+2*skeletor2,uniskel,'montage');
 imshowpair(lychcrop2*2,uniskel);
 
 %% % Instead of working on the whole window, we will work on each root separately and so ->
 
 workskel = imcrop(uniskel);

% imshow(workskel)
 
 
 % Vectors for positions of 1's (new y ordered [y after rotation])
 [skerowy,skecoly] = find(workskel);
 
 % And a matrix -(??Yaron not sure)
% skelmaty = cat(2,skerowy,1980.-skecoly);
% skelmaty = cat(2,skerowy,skecoly);
  
 % Creating a rotated matrix
 workskelR=imrotate(workskel,-90);
 
 % Vectors for positions of 1's (new x ordered [x after rotation])
 [skerowx,skecolx] = find(workskelR);
 
 % And a matrix
 skelmatx = cat(2,skecolx,skerowx);
