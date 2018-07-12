% % Lychee test

%%
%
% From here are the accepted methods as of
% 4.7.18, 18:51
%
% %

%%
clear variables
% For a fresh start
% Having a string with the file name
% file_name = '../../../img/Lychee_test1.jpg';
% file_name = '../../../img/Lychee_test2.jpg';
 file_name = '../../../img/Lychee_test3_2018-03-06_1630.jpg';
% file_name = '../../../img/Lychee_test4_2018-03-08_1220.jpg';

%showing the original photo
figure
image(imread(file_name));
lych_tst1 = imread(file_name);
lych_tst1=double(lych_tst1) /255; % Converting to double
% % % Rough first appending - multiplying
% % %lych_tst1 = lych_tst1*3;

% ask user to draw window
lychcrop1 = imcrop(lych_tst1);
%
%% % Adding Colour separation filtering

% We start with the brightness based filteration in order to enhance the
% difference between the color channels

Imtst = lychcrop1*3;

% Doing a scaled enhancment - everything that isn't black gets brighter,
% and the brighter you are the brighter you get
Imtst = Imtst.*1.1;
Imtst = Imtst.*1.1;
Imtst = Imtst.*(1.1+Imtst.^2);


% Now performing RGB level difference based filtering. Basically, if the
% RGB components are too far apart the pixel is blackend

% First - R to G
Imtstdum1=Imtst;

% Creating the filtering mask
% test if difference between R and G channel are above threshold
filmask = (Imtst(:,:,1)-Imtst(:,:,2))>0.3;

% Seperate to R G & B matrices
ImtstR=Imtstdum1(:,:,1);
ImtstG=Imtstdum1(:,:,2);
ImtstB=Imtstdum1(:,:,3);
% Applying the filtering mask to all 3 colour channels, ie set it to black
ImtstR(filmask)=0;
ImtstG(filmask)=0;
ImtstB(filmask)=0;

% rebuild RGB image
Imtstdum1 = cat(3, ImtstR, ImtstG, ImtstB); % Concatenating the seperate R G and B matrices to reproduce an altered image.

% figure
% imshowpair(Imtstdum1,Imtst,'montage')
% 
% title('On the right : Image after Scaled multi - phase filtarisation attempt. On the left : after an additional R -G difference based filtering');

% Second - R to B
Imtstdum2=Imtstdum1;

% Creating the filtering mask
filmask = (Imtstdum1(:,:,1)-Imtstdum1(:,:,3))>0.3;

% Seperate to R G & B matrices
ImtstR=Imtstdum2(:,:,1);
ImtstG=Imtstdum2(:,:,2);
ImtstB=Imtstdum2(:,:,3);
% Applying the filtering mask to all 3 colors
ImtstR(filmask)=0;
ImtstG(filmask)=0;
ImtstB(filmask)=0;

Imtstdum2 = cat(3, ImtstR, ImtstG, ImtstB); % Concatenating the seperate R G and B matrices to reproduce an altered image.


% figure
% imshowpair(Imtstdum2,Imtst,'montage')
% 
% title('On the right : Image after Scaled multi - phase filtarisation attempt. On the left : after an additional R-G & R-B difference based filtering');

% Third - G to B
Imtstdum3=Imtstdum2;

% Creating the filtering mask
filmask = (Imtstdum2(:,:,2)-Imtstdum2(:,:,3))>0.3;

% Seperate to R G & B matrices
ImtstR=Imtstdum3(:,:,1);
ImtstG=Imtstdum3(:,:,2);
ImtstB=Imtstdum3(:,:,3);
% Applying the filtering mask to all 3 colors
ImtstR(filmask)=0;
ImtstG(filmask)=0;
ImtstB(filmask)=0;

Imtstdum3 = cat(3, ImtstR, ImtstG, ImtstB); % Concatenating the seperate R G and B matrices to reproduce an altered image.


% figure
% imshowpair(Imtstdum3,Imtst,'montage')
% 
% title('On the right : Image after Scaled multi - phase filtarisation attempt. On the left : after an additional R-G & R-B & G-B difference based filtering');

% Grayscaling it now
graywarden = rgb2gray(Imtstdum3);

% figure
% imshowpair(graywarden,Imtst,'montage','Scaling','none')
% 
% title('On the right : Image after Scaled multi - phase filtarisation attempt. On the left : grayscaling it');

% Eliminating too bright cells.
% graywarden(graywarden>0.65)=1; % NOT GOOD ENOUGH, because it affects the roots AND the pipettes. needs refinement
graywarden(graywarden>0.76)=0; % Much better. Eliminates the pipettes without losing too much of the roots



%%
% The 'If it is brighter than bright eliminate it' approach:
% we'll carefully enhance brightness and then get rid of too bright spots.



% % Choosing a relevant window - Found a much better approach - using imcrop
% if(strcmp(file_name,'Lychee_test1.jpg')==1)
%     Imtstbri=lych_tst1(805:1897,361:2815,:);
% end
% if(strcmp(file_name,'Lychee_test2.jpg')==1)
%     Imtstbri=lych_tst1(200:400,140:600,:);
% end
Imtstbri = lychcrop1;
% Eliminating too bright cells.
Imtstbri(Imtstbri>0.55)=0;

% Showing the image after the basic filter
% figure
% image(Imtstbri)
% title('basic')


for i=1:5
    % Multiplication and elimination of >1
    Imtstbri = Imtstbri * 1.4;
    % Filtering on all color channels.
    % We check which color values have value over 1.
    afilmask = Imtstbri>1;
    % Then we create a filter which is 0 if even on of the channels is over
    % 1.
    filmask = (1.-afilmask(:,:,1)).* (1.-afilmask(:,:,2)).* (1.-afilmask(:,:,3));
    % Then we apply the mask to all color channels
    Imtstbri(:,:,1) = Imtstbri(:,:,1) .* (filmask);
    Imtstbri(:,:,2) = Imtstbri(:,:,2) .* (filmask);
    Imtstbri(:,:,3) = Imtstbri(:,:,3) .* (filmask);
    
%     % Showing the image after each iteration
%     figure
%     image(Imtstbri)
%     title(['Iteration number ',num2str(i)])
end

% % Showing the image after the whole loop
%     figure
%     image(Imtstbri)
%     title(['Iteration number ',num2str(i)])

% Grayscaling it and immediately reverting to RGB
brighttst = rgb2gray(Imtstbri);
% ImtstbrigrayRGB = cat(3,temptst,temptst,temptst);
% 
% % Showing the image after each iteration
%     figure
%     image(ImtstbrigrayRGB)
%     title('Grayscaled')
 % No need for those steps no more   
 
 

%% %THE BEST APPROACH is this + the intensity filter. Not an average.
% % Trying a set of binarizing, getting rid of isolated points, filling stuff
% % and then skeletonizing and other methods.
skeletor=imbinarize(wiener2(graywarden,[1 2]),'adaptive','Sensitivity',0.45);
% UPDATE - Added the wiener2 noise filtering function

skeletor = medfilt2(skeletor);
% Added the medfilt2 filtering function to try and improve the process to
% exclude closed rings (loops) and such


% fill in holes in the binarised image
skeletor=imfill(skeletor,'holes');
% clean isolated pixels until image series converges  -- DOES NOT CHANGE MUCH, sort of safety measure
skeletor=bwmorph(skeletor,'clean',Inf);
%  extract skeleton
skeletor=bwmorph(skeletor,'skel',Inf);
% fill in holes b/c skeltetisation creates holes sometimes
skeletor=imfill(skeletor,'holes');
% close small gaps
skeletor=bwmorph(skeletor,'bridge',Inf);
% get rid of isolated non-root structures (< 35 pixels), BUT BE CAREFUL: WE CAN
% DESTROY ROOTS
skeletor=bwareaopen(skeletor,35);
% skeletor=bwmorph(skeletor,'remove',Inf);

% % figure
% % imshow(ans)
% 
% % Took some trial and error. Changing the values, alternating between
% % different combinations and orders of bwareaopen, imfill and
% % bwmorph('skel').
% % let's see if we can improve
% % skeletor=bwmorph(skeletor,'clean',Inf); % TRY AGAin. Doesn't really help
% % Found a possible candidate
% bwmorph(skeletor,'branchpoints',1); %SUPER FAIL - black screen

% destroy small branches -- BE CAREFUL: IN PICTURE2 DESTROYS ROOTS --- FIX IT.
skeletor = bwmorph(skeletor,'spur',10); 
%skeletor = bwmorph(skeletor,'spur',1);


% Attempting to add several filters
%skeletor = entropyfilt(skeletor);
%skeletor = imgaussfilt(double(skeletor), 2);


%  figure
%  % show difference between enhanced image and skeleton (overlayed image)
%  imshowpair(lychcrop1*3,skeletor);


%%
% % Trying the above with superavg - ACTUALLY MUCH WORSE.
% skeletor=imbinarize(superavg,'adaptive','Sensitivity',0.45);
% 
% skeletor=bwareaopen(skeletor,10000);
% skeletor=imfill(skeletor,'holes');
% skeletor=bwmorph(skeletor,'skel',Inf);
% skeletor=imfill(skeletor,'holes');
% 
% skeletor=bwmorph(skeletor,'spur',Inf); % Kind of a success. With these functions we get roots without little branches.
% figure
% imshowpair(lych_tst1(805:1897,361:2815,:),skeletor);
% 

%% %Found a better way, the one below.
% % % Trying the above with holy avg - The Right root is SALVAGED thanks to
% % this!!!!!!!!!!!! This is the one we will use
% skeletor=imbinarize(holyavg,'adaptive','Sensitivity',0.45);
% 
% skeletor=bwareaopen(skeletor,10000);
% skeletor=imfill(skeletor,'holes');
% skeletor=bwmorph(skeletor,'skel',Inf);
% skeletor=imfill(skeletor,'holes');
% 
% skeletor=bwmorph(skeletor,'spur',Inf); % Kind of a success. With these functions we get roots without little branches.
% figure
% imshowpair(lych_tst1(805:1897,361:2815,:),skeletor);

%% % A new idea: combining the two methods: taking both the skeleton of the color method and the intensity method and adding instead of averaging
% I shall now add the second one here

skeletor2=imbinarize(wiener2(brighttst,[1 2]),'adaptive','Sensitivity',0.45);
% Added the wiener2 noise filtering function

skeletor2 = medfilt2(skeletor2);
% Added the medfilt2 filtering function

skeletor2=imfill(skeletor2,'holes');
skeletor2=bwmorph(skeletor2,'skel',Inf);
skeletor2=imfill(skeletor2,'holes');
skeletor2=bwmorph(skeletor2,'bridge',Inf);
skeletor2=bwareaopen(skeletor2,30);
skeletor2=bwmorph(skeletor2,'spur',10); % Kind of a success. With these functions we get roots without little branches.
% if(strcmp(file_name,'Lychee_test1.jpg')==1)
%     figure
%     imshowpair(lych_tst1(805:1897,361:2815,:),skeletor2);
% end
% if(strcmp(file_name,'Lychee_test2.jpg')==1)
%     figure
%     imshowpair(lych_tst1(200:400,140:600,:),skeletor2);
% end

% figure
%  imshowpair(lychcrop1*3,skeletor2);
% 
% % So - this one on its own is much less effective but it does see the right
% % root. let's see what happens when we combine them.
% 
% % figure
% % imshowpair(lych_tst1(805:1897,361:2815,:),skeletor+skeletor2);
% 
% figure
%  imshowpair(lychcrop1*3,skeletor+skeletor2);
%% %A unified front
 % The avarage binarized:
 uniskel=0.5*(skeletor+skeletor2);
 uniskel(uniskel>0)=1;

 
 
 %% % Instead of working on the whole window, we will work on each root separately and so ->
 
%  workskel = imcrop(uniskel);
%  
%  imshow(workskel)
%  
%  
%  % Vectors for positions of 1's (new y ordered [y after rotation])
%  [skerowy,skecoly] = find(workskel);
%  
%  % And a matrix -(??Yaron not sure)
%  % skelmaty = cat(2,skerowy,1980.-skecoly);
%  % skelmaty = cat(2,skerowy,skecoly);
%  
%  % Creating a rotated matrix
%  workskelR=imrotate(workskel,-90);
%  
%  % Vectors for positions of 1's (new x ordered [x after rotation])
%  [skerowx,skecolx] = find(workskelR);
%  
%  % And a matrix
%  skelmatx = cat(2,skecolx,skerowx);
 
%% % New idea to automatize the paramater search
% you define all threshold paramaters and an average intensity density paramater.
% You then set a threshold value for it with a control image and look for
% Parameters that get you below the threshold
% There should be minimal value as well
%  Let us count the variables:
% R-G separation, R-B sep., G-B sep., Color multiplier, Brightness
% multiplier, binarization sensitivity, bwareaopen pixel count.
% First, Let's try using only 2 variables:
% A general color separation one, and a bwareaopen pixel count.


%% % UPDATE,9.7.18 13:57 - There are many cool functions in the image processing 
% tool which kind of render a lot of this work obsolete



%  J = imcrop(lych_tst1);
% This one allows the user to crop the image as he/she desires.

% imcontrast
% When put after imshow or given a handle to an image, allows to control
% the contrast levels. VERY useful

% wiener2(J)
% Reduces noise



%% % ISOLATING middle root and working on it

% midrootcrop = imcrop(uniskel);
% 
% imshow(midrootcrop)
