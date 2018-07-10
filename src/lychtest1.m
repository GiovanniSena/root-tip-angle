% % Lychee test
% 
% lych_tst1 = imread('Lychee_test1.jpg');
% % I=lych_tst1(1100:1200,1000:1750,:);
% % Itst=I;
% % tst1=Itst(:,:,1)>30;
% % tst2=Itst(:,:,2)>30;
% % tst3=Itst(:,:,3)>30;
% % suptst=(tst1+tst2+tst3==3);
% % ItstR=Itst(:,:,1);
% % ItstR(suptst)=255;
% % ItstG=Itst(:,:,2);
% % ItstG(suptst)=255;
% % ItstB=Itst(:,:,3);
% % ItstB(suptst)=255;
% % Itst(:,:,1)=ItstR;
% % Itst(:,:,2)=ItstG;
% % Itst(:,:,3)=ItstB;
% % image(Itst)
% % 
% % % For an even better refinement, instead of turning them all to 255, we will
% % % try to multiply them by 5, and in general for a general photo I will find
% % % the maximal value in a relevant region and use it to scale accordingly.
% % 
% % Itst2=I;
% % Itst2R=Itst2(:,:,1);
% % Itst2R(suptst)=Itst2R(suptst)*5;
% % Itst2G=Itst2(:,:,2);
% % Itst2G(suptst)=Itst2G(suptst)*5;
% % Itst2B=Itst2(:,:,3);
% % Itst2B(suptst)=Itst2B(suptst)*5;
% % Itst2(:,:,1)=Itst2R;
% % Itst2(:,:,2)=Itst2G;
% % Itst2(:,:,3)=Itst2B;
% % figure
% % image(Itst2)
% % 
% % Itst3=lych_tst1;
% % tst1=Itst3(:,:,1)>30;
% % tst2=Itst3(:,:,2)>30;
% % tst3=Itst3(:,:,3)>30;
% % suptst=(tst1+tst2+tst3==3);
% % Itst3R=Itst3(:,:,1);
% % Itst3R(suptst)=Itst3R(suptst)*5;
% % Itst3G=Itst3(:,:,2);
% % Itst3G(suptst)=Itst3G(suptst)*5;
% % Itst3B=Itst3(:,:,3);
% % Itst3B(suptst)=Itst3B(suptst)*5;
% % Itst3(:,:,1)=Itst3R;
% % Itst3(:,:,2)=Itst3G;
% % Itst3(:,:,3)=Itst3B;
% % figure
% % image(Itst3)
% 
% Imtst=lych_tst1(951:1473,564:2420,:); % Taking a region of interest out of the whole image.
% %Imtst=lych_tst1(1148:1184,1067:1457,:);
% ImtstR=Imtst(:,:,1);
% ImtstG=Imtst(:,:,2);
% ImtstB=Imtst(:,:,3);
% 
% % Next, we shall test for pixels which are in a certain range of R, G and B
% % and single them out.
% tst1=ImtstR>33 & ImtstR<45;
% tst2=ImtstG>33 & ImtstG<45;
% tst3=ImtstB>33 & ImtstB<45;
% % Now, we shall single out the pixels who apply to all 3 tests.
% suptst=(tst1+tst2+tst3==3);
% 
% %
% %
% % TEST TEST
% %
% %
% % tst1=ImtstR>32 & ImtstR<35;
% % tst2=ImtstG>32 & ImtstG<35;
% % tst3=ImtstB>32 & ImtstB<35;
% %
% % Now, we shall single out the pixels that pass all 3 tests.
% % suptst2=(tst1+tst2+tst3==3);
% %
% %
% % TEST TEST
% %
% %
% 
% % We shall separate the image to RGB components and alter the relevant
% % pixels.
% 
% ImtstR(suptst)=ImtstR(suptst)*2.3;
% % ImtstR(suptst2)=ImtstR(suptst2)*2.4;
% 
% ImtstG(suptst)=ImtstG(suptst)*3;
% % ImtstG(suptst2)=ImtstG(suptst2)*2.4;
% ImtstB(suptst)=ImtstB(suptst)*3.3;
% % ImtstB(suptst2)=ImtstB(suptst2)*2.1;
% % Imtst(:,:,1)=ImtstR;
% % Imtst(:,:,2)=ImtstG;
% % Imtst(:,:,3)=ImtstB;
% Imtst=cat(3, ImtstR, ImtstG, ImtstB); % Concatenating the seperate R G and B matrices to reproduce an altered image.
% % Taking the entire image and then changing only the altered region
% Imtstb=lych_tst1;
% Imtstb(951:1473,564:2420,:)=Imtst;
% %Imtstb(1148:1184,1067:1457,:)=Imtst;
% 
% figure
% image(Imtstb)
% 
% 
% 
% 
% %%
% 
% 
% lych_tst1 = imread('Lychee_test1.jpg');
% 
% % 0. convert image frm rgb to gray scale
% 
% lych_tst1_grey = rgb2gray(lych_tst1);
% 
% % 1. multiply by 3
% 
% lych_tst1_grey(805:1897,361:2815) = lych_tst1_grey(805:1897,361:2815) *3;
% 
% lych_tst1_grey=double(lych_tst1_grey) /255;
% 
% Imtst = lych_tst1_grey(805:1897,361:2815);
% 
% % colorrange_index = Imtst>0.36 & Imtst<0.39;
% % colorrange_index = Imtst>0.33 & Imtst<0.4;
% 
% Imtst(~colorrange_index)=0;
% Imtst(colorrange_index)=1;
% 
% imshow(Imtst)
% imagesc(Imtst)
% %colormap(gray)
% 
% 
% %%
% 
% lych_tst1 = imread('Lychee_test1.jpg');
% 
% lych_tst1=double(lych_tst1) /255; % Converting to double
% 
% lych_tst1 = lych_tst1*3;
% 
% Imtst=lych_tst1(805:1897,361:2815,:); % Taking a region of interest out of the whole image.
% 
% 
% % Seperate to R G & B matrices
% ImtstR=Imtst(:,:,1);
% ImtstG=Imtst(:,:,2);
% ImtstB=Imtst(:,:,3);
% 
% % Next, we shall test for pixels which are in a certain range of R, G and B
% % and single them out.
% tst1=ImtstR>0.42277 & ImtstR<0.42423;
% tst2=ImtstG>0.4091 & ImtstG<0.4127;
% tst3=ImtstB>0.40518 & ImtstB<0.40662;
% 
% % Now, we shall single out the pixels that pass all 3 tests.
% suptst=(tst1+tst2+tst3>0);
% 
% 
% % We shall alter (binarise) the relevant pixels.
% 
% 
% ImtstR(suptst)=1;
% ImtstR(~suptst)=0;
% % ImtstR(~suptst)=ImtstR(~suptst)/3;
% 
% ImtstG(suptst)=1;
% ImtstG(~suptst)=0;
% % ImtstG(~suptst)=ImtstG(~suptst)/3;
% 
% ImtstB(suptst)=1;
% ImtstB(~suptst)=0;
% % ImtstB(~suptst)=ImtstB(~suptst)/3;
% 
% Imtst = cat(3, ImtstR, ImtstG, ImtstB); % Concatenating the seperate R G and B matrices to reproduce an altered image.
% 
% % Grayscale the image
% %Imtst = rgb2gray(Imtst);
% Imtst = im2bw(Imtst);
% %imagesc(Imtst)
% imshow(Imtst)
% %colormap(gray)
% 
% 
% 
% %%
% % Scaled multi - phase filtarisation attempt
% %
% 
% lych_tst1 = imread('Lychee_test1.jpg');
% 
% lych_tst1=double(lych_tst1) /255; % Converting to double
% 
% % Rough first appending - multiplying
% lych_tst1 = lych_tst1*3;
% 
% % Choosing a relevant window
% Imtst=lych_tst1(805:1897,361:2815,:);
% 
% % Grayscaling it
% Imtst = rgb2gray(Imtst);
% 
% % Eliminating too bright cells.
% Imtst(Imtst>0.55)=0;
% 
% % Doing a scaled enhancment - everything that isn't black gets brighter,
% % and the brighter you are the brighter you get
% Imtst = Imtst.*1.1;
% Imtst = Imtst.*1.1;
% Imtst = Imtst.*(1.1+Imtst.^2);
% 
% % Eliminating too dark cells.
% Imtst(Imtst<0.55)=0;
% 
% 
% % Get histogram:
% [pixelCounts, grayLevels] = imhist(Imtst);
% % Computer probability density function:
% pdf = pixelCounts / numel(Imtst);
% 
% 
% % Converting back to RGB for for easier handling and showing the image
% ImtstRGB = cat(3, Imtst, Imtst, Imtst);
% 
% %figure
% % image(ImtstRGB)
% % 
% % title('Image after Scaled multi - phase filtarisation attempt');
% 
% % figure
% % 
% % edge(Imtst)
% % 
% % title('Edge detection on the previous image');
% 
% % % Creating an RGB edge image using Canny method
% % edge4RGB = cat(3, edge(Imtst,'Canny'), edge(Imtst,'Canny'), edge(Imtst,'Canny'));
% % 
% % % Display both results side-by-side.
% % % 
% % % imshowpair(BW1,BW2,'montage')
% % 
% % figure
% % 
% % imshowpair(ImtstRGB-edge4RGB,ImtstRGB,'montage')
% % 
% % title('On the right - the image, on the left - the image minus edges detected using the Canny method');
% % 
% % 
% % % Creating an RGB edge image using Roberts method
% % edge4RGB = cat(3, edge(Imtst,'Roberts'), edge(Imtst,'Roberts'), edge(Imtst,'Roberts'));
% % 
% % % Display both results side-by-side.
% % % 
% % % imshowpair(BW1,BW2,'montage')
% % 
% % figure
% % 
% % imshowpair(ImtstRGB-edge4RGB,ImtstRGB,'montage')
% % 
% % title('On the right - the image, on the left - the image minus edges detected using the Roberts method');
% % 
% % % Creating an RGB edge image using Prewitt method
% % edge4RGB = cat(3, edge(Imtst,'Prewitt'), edge(Imtst,'Prewitt'), edge(Imtst,'Prewitt'));
% % 
% % % Display both results side-by-side.
% % % 
% % % imshowpair(BW1,BW2,'montage')
% % 
% % figure
% % 
% % imshowpair(ImtstRGB-edge4RGB,ImtstRGB,'montage')
% % 
% % title('On the right - the image, on the left - the image minus edges detected using the Prewitt method');
% 
% 
% % Eliminating too bright cells again.
% Imtst(Imtst>0.8)=0;
% 
% ImtstRGBb = cat(3, Imtst, Imtst, Imtst);
% % figure
% % 
% % 
% % image(ImtstRGBb)
% % 
% % title('Image after Scaled multi - phase filtarisation attempt b');
% % 
% % figure
% % 
% % imshowpair(ImtstRGBb,ImtstRGB,'montage')
% % 
% % title('On the right - the image, on the left - the image after an extra brightness filter');
% 
% 
% sImtstRGBb= ImtstRGBb-mean(ImtstRGBb);
% 
% % figure
% % imshowpair(sImtstRGBb,ImtstRGBb,'montage')
% % 
% % title('On the right - the image after an extra brightness filter, on the left - the image after an extra brightness filter and reducing by the mean of matrix');
% 
% uImtstRGBb= sImtstRGBb-mean(sImtstRGBb);
% figure
% imshowpair(uImtstRGBb,ImtstRGBb,'montage')
% 
% title('On the right - the image after an extra brightness filter, on the left - the image after an extra brightness filter and reducing (twice) by the mean of matrix');
% 
% OLD ATTEMPTS.
%%
%
% From here are the accepted methods as of
% 04-07-18, 18:51
%
% %

%%
clear variables
% For a fresh start
% Having a string with the file name
file_name = '../img/Lychee_test1.jpg';

%showing the original photo
figure
image(imread(file_name));
lych_tst1 = imread(file_name);
lych_tst1=double(lych_tst1) /255; % Converting to double
% Rough first appending - multiplying
%lych_tst1 = lych_tst1*3;
lychcrop1 = imcrop(lych_tst1);
%
%% % Adding Color separation filtering

% We start with the same brightness based filteration as the previous
% section




% Choosing a relevant window - Found a much better approach - using imcrop
% if(strcmp(file_name,'Lychee_test1.jpg')==1)
%     Imtst=lych_tst1(805:1897,361:2815,:);
% end
% if(strcmp(file_name,'Lychee_test2.jpg')==1)
%     Imtst=lych_tst1(200:400,140:600,:);
% end
Imtst = lychcrop1*3;
% Eliminating too bright cells.
%Imtst(Imtst>0.55)=0;
% Doing a scaled enhancment - everything that isn't black gets brighter,
% and the brighter you are the brighter you get
Imtst = Imtst.*1.1;
Imtst = Imtst.*1.1;
Imtst = Imtst.*(1.1+Imtst.^2);
% Eliminating too dark cells.
%Imtst(Imtst<0.55)=0;

% Now performing RGB level difference based filtering. Basically, if the
% RGB components are too far apart the pixel is blackend

% First - R to G
Imtstdum1=Imtst;

% Creating the filtering mask
filmask = (Imtst(:,:,1)-Imtst(:,:,2))>0.3;

% Seperate to R G & B matrices
ImtstR=Imtstdum1(:,:,1);
ImtstG=Imtstdum1(:,:,2);
ImtstB=Imtstdum1(:,:,3);
% Applying the filtering mask to all 3 colors
ImtstR(filmask)=0;
ImtstG(filmask)=0;
ImtstB(filmask)=0;

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

% Second - G to B
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

% figure
% imshowpair(graywarden,Imtst,'montage','Scaling','none')
% 
% title('On the right : Image after Scaled multi - phase filtarisation attempt. On the left : grayscaling it');

% edge(graywarden)
% 
% title('The edges')

% Using the concatination trick to ease the handling of the grayscaled
% image by representing it as an RGB image - FOR TESTING
% graywardenRGB = cat(3,graywarden,graywarden,graywarden);
% 
% figure
% 
% image(graywardenRGB)

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
 
 
%% %IT IS OBSOLETE AFTER ALL
% Averaging the two previous approaches (Color filtering and repetitive
% brightness filtering) and then thresholding it with if <0.35 -> 0

% % Averaging
% holyavg = 0.5*(brighttst+graywarden);
% % Thresholding
% holyavg(holyavg<0.35)=0;
% % % RGBing  - FOR TESTING
% % holyRGB = cat(3,holyavg,holyavg,holyavg);
% % %Showing
% % figure
% % image(holyRGB)
% 
% % % Now trying to create a binary version that will help discern the roots
% % % and doing calculations on them
% % MIGHT USE VALUES LATER
% % holyavgbw=holyavg;
% % holyavgbw((holyavg>0.7) | (holyavg<0.5) )=0;
% % holyavgbw((holyavg<=0.7) & (holyavg>=0.5) )=1;
% 
% 
% % % RGBing - FOR TESTING
% % holyRGB = cat(3,holyavgbw,holyavgbw,holyavgbw);
% % %Showing
% % figure
% % image(holyRGB)
% % 
% % % Now trying to create a tighter binary version that will help discern the roots
% % % and doing an average on them afterwardscalculations on them
% % holyavgbw2=holyavg;
% % holyavgbw2((holyavg>0.6) | (holyavg<0.55) )=0;
% % holyavgbw2((holyavg<=0.6) & (holyavg>=0.55) )=1;
% % % RGBing
% % holyRGB = cat(3,holyavgbw2,holyavgbw2,holyavgbw2);
% % %Showing
% % figure
% % image(holyRGB)
% % 
% % % Now the average
% % 
% % bwavg = 0.5 * (holyavgbw+holyavgbw2);
% % 
% % % RGBing
% % holyRGB = cat(3,bwavg,bwavg,bwavg);
% % %Showing
% % figure
% % image(holyRGB)
% %Actually not obsolete cause Gmag made the skel. process worse
%%
% Idea - Using time to filter things. 
% Over the course of an experiment, the roots grow, but the noise is noise
% and any defects are static.
%% % Actually found out that if we want to skeletonize, Better leave the grad out of it
% %%
% % Let us try to add the gradient as another filter.
% 
% if(strcmp(file_name,'Lychee_test1.jpg')==1)
%     [Gmag, Gdir] = imgradient(rgb2gray(lych_tst1(805:1897,361:2815,:)*3),'prewitt');
% end
% if(strcmp(file_name,'Lychee_test2.jpg')==1)
%     [Gmag, Gdir] = imgradient(rgb2gray(lych_tst1(200:400,140:600,:)*3),'prewitt');
% end
% 
% 
% % Amplifying the Gmag
% % Gmag=Gmag*9;
% %%
% % 1.-imbinarize(imfill(Gmag),'adaptive','Sensitivity',0.98);
% % bwareaopen(ans,834680);
% % imshow(ans)
% % Too specific, trial and er0rory and unscalable. I literally incremented
% % the numbers until it fits. Msybe if we had a method to "Cut the roots"
% % and then count the pixel of the smallest root and using that number for
% % bwareaopen.
% 
% 
% 
% 
% %%
% % And now a super average of the 3
% 
% superavg = (1/3) * (temptst+graywarden+Gmag);
% 
% % Thresholding
% % superavg(superavg<0.35)=0;
% 
% %TESTING a new threshold which is double sided and hopefully more refind.
% %The upper limit will remove some of the pipettes and the refinment of the
% %lower on wil hopedully remove noise
% superavg((superavg<0.37) | (superavg>0.52))=0;
% % % RGBing FOR TESTING
% % superRGB = cat(3,superavg,superavg,superavg);
% % %Showing
% % figure
% % image(superRGB)
% 
% %%
% % Implement tomorrow/later:
% % morphy=superavg;
% % morphy(morphy>0.37)=1;
% %  BW3 = bwmorph(morphy,'skel',Inf);
% % figure
% % imshow(BW3)
% % BW4 = bwmorph(BW3,'clean');
% % figure
% % imshow(BW4)
% 
% % %%
% % morphy=Imtst;%superavg;
% % %morphy(morphy>0.37)=1;
% % 
% % %im2bw(morphy,0.38);
% % BW3 = bwmorph(morphy,'skel',Inf);
% % figure
% % imshow(BW3)
% % BW4 = bwmorph(BW3,'clean');
% % figure
% % imshow(BW4)
% % % NOT WORKING ANYMORE
%% %Not Necessary anymore since the holyavg version has better results.
%% %SCRATCH the above statement for now, for the price of salvaging the right one it shortens one of the middle ones. let's hold our judgment for now
%% % Another late addition that ,might do us good
% fibermetric(A) - Enhance elongated or tubular structures in image
% graywarden = fibermetric(graywarden,6);
%bckup = graywarden;
%imshow(fibermetric(graywarden,5,'StructureSensitivity',0.2)) % FOR TESTING
%imshow(0.25*(fibermetric(graywarden,5,'StructureSensitivity',0.15)+fibermetric(graywarden,4,'StructureSensitivity',0.1)+fibermetric(graywarden,6,'StructureSensitivity',0.15)+fibermetric(graywarden,7,'StructureSensitivity',0.1))) % FOR TESTING
%graywarden = (0.25*(fibermetric(graywarden,5,'StructureSensitivity',0.15)+fibermetric(graywarden,4,'StructureSensitivity',0.1)+fibermetric(graywarden,6,'StructureSensitivity',0.15)+fibermetric(graywarden,7,'StructureSensitivity',0.1))) % FOR TESTING;
%% %THE BEST APPROACH is this + the intensity filter. Not an average.
% % Trying aset of biarizing, getting rid of isolated points, filling stuff
% % and then skeletonizing and other methods.
skeletor=imbinarize(wiener2(graywarden,[1 2]),'adaptive','Sensitivity',0.45);
% Added the wiener2 noise filtering function

skeletor = medfilt2(skeletor);
% Added the medfilt2 filtering function to try and improve the process to
% exclude closed rings and such



skeletor=imfill(skeletor,'holes');
skeletor=bwmorph(skeletor,'clean',Inf);
skeletor=bwmorph(skeletor,'skel',Inf);
skeletor=imfill(skeletor,'holes');
skeletor=bwmorph(skeletor,'bridge',Inf);
skeletor=bwareaopen(skeletor,100);
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
skeletor = bwmorph(skeletor,'spur',10); 
skeletor = bwmorph(skeletor,'spur',1);


% Attempting to add several filters
%skeletor = entropyfilt(skeletor);
%skeletor = imgaussfilt(double(skeletor), 2);

%skeletor=bwmorph(skeletor,'skel',Inf);
% % New candidate
%skeletor=bwmorph(skeletor,'spur',Inf); % Kind of a success. With these functions we get roots without little branches.

% % Choosing a relevant window for comparison
% if(strcmp(file_name,'Lychee_test1.jpg')==1)
%     figure
%     imshowpair(lych_tst1(805:1897,361:2815,:),skeletor);
% end
% if(strcmp(file_name,'Lychee_test2.jpg')==1)
%     figure
%     imshowpair(lych_tst1(200:400,140:600,:),skeletor);
% end
 figure
 imshowpair(lychcrop1*3,skeletor);


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

figure
 imshowpair(lychcrop1*3,skeletor2);

% So - this one on its own is much less effective but it does see the right
% root. let's see what happens when we combine them.

% figure
% imshowpair(lych_tst1(805:1897,361:2815,:),skeletor+skeletor2);

figure
 imshowpair(lychcrop1*3,skeletor+skeletor2);

 % The avarage binarized:
 uniskel=0.5*(skeletor+skeletor2);
 uniskel(uniskel>0)=1;
 
 % Vectors for positions of 1's (new y ordered [y after rotation])
 [skerowy,skecoly] = find(uniskel);
 
 % And a matrix -(??Yaron not sure)
% skelmaty = cat(2,skerowy,1980.-skecoly);
% skelmaty = cat(2,skerowy,skecoly);
  
 % Creating a rotated matrix
 uniskelR=imrotate(uniskel,-90);
 
 % Vectors for positions of 1's (new x ordered [x after rotation])
 [skerowx,skecolx] = find(uniskelR);
 
 % And a matrix
 skelmatx = cat(2,skecolx,skerowx);
 
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
