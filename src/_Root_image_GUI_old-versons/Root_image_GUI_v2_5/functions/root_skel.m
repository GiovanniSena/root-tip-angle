%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          AD APPROACH 1: the colour-based approach                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trying to use fibermetric to get rid of the annoying thorns without
% sacrificing root. Hopefully, it will make the rest of the section become
% better. First imfill though
% color_skeleton = imfill(evalin('base', 'color_filt_img'),'holes');

%see LOG 2.9.18 19:20
color_skeleton = evalin('base', 'color_filt_img');

% function that enhances tubular structures(?)
color_skeleton = fibermetric(color_skeleton,20, 'StructureSensitivity', 0.02);

%Some Testing showed that
% bwareaopen(imbinarize(wiener2(imfill(color_skeleton,'holes'),[1 12]),'adaptive','Sensitivity',0.45),400)
% is very good, so we will do the necessary steps (16.7.18 18:56)

color_skeleton = imfill(color_skeleton,'holes');
color_skeleton = wiener2(color_skeleton,[1 3]);
% The last added step is after the binarization.
% % Doing a set of binarizing, getting rid of isolated points, filling stuff
% % and then skeletonizing and other methods. One of the differnces from
% before are the 2 steps above.

% UPDATE 4.9.18 03:54 - since I added a toggle button that allows you not
% to choose the tip, will only do this step if
if((exist('tipx','var')) ==1)
% 10.8.18 16:15 - Now to turn the neighborhood of the tip to white and hope it helps.
croppedsize = size(color_skeleton);
tip_root_point = (evalin('base', 'tipx')-1)*croppedsize(1)+evalin('base', 'tipy');

% The whitening of the tip's neighborhood
i = -1:1;
color_skeleton(tip_root_point + i*croppedsize(1) + i) = 1;
end

color_skeleton=imbinarize(color_skeleton,'adaptive','Sensitivity',1);
% UPDATE - Added the wiener2 noise filtering function

% Last new step
color_skeleton = bwareaopen(color_skeleton,400);

color_skeleton = medfilt2(color_skeleton);
% Added the medfilt2 filtering function to try and improve the process to
% exclude closed rings (loops) and such


% fill in holes in the binarised image
color_skeleton = imfill(color_skeleton,'holes');
% clean isolated pixels until image series converges  -- DOES NOT CHANGE MUCH, sort of safety measure
color_skeleton = bwmorph(color_skeleton,'clean',Inf);
% get rid of isolated non-root structures (< 35 pixels), BUT BE CAREFUL: WE CAN
% DESTROY ROOTS
% Added another one before skeletonisation
color_skeleton = bwareaopen(color_skeleton,200);

%  extract skeleton
color_skeleton=bwmorph(color_skeleton,'skel',Inf);
% fill in holes b/c skeltetonisation creates holes sometimes
color_skeleton=imfill(color_skeleton,'holes');
% close small gaps
color_skeleton=bwmorph(color_skeleton,'bridge',Inf);
% get rid of isolated non-root structures (< 35 pixels), BUT BE CAREFUL: WE CAN
% DESTROY ROOTS
color_skeleton=bwareaopen(color_skeleton,35);



% destroy small branches -- BE CAREFUL: IN PICTURE2 DESTROYS ROOTS --- FIX IT.
color_skeleton = bwmorph(color_skeleton,'spur',10);

% get rid of isolated non-root structures (< 35 pixels), BUT BE CAREFUL: WE CAN
% DESTROY ROOTS
color_skeleton=bwareaopen(color_skeleton,35);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          AD APPROACH 2: The intensity method skeleton                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I shall now apply the new refined process in the hopes of it working
% smoothly.
% SEE COMMENTS IN PREVIOUS SECTION PLEASE.

%see LOG 2.9.18 20:15
% brightness_skeleton = imfill(evalin('base', 'bright_filt_img'),'holes');
brightness_skeleton = evalin('base', 'bright_filt_img');

brightness_skeleton = fibermetric(brightness_skeleton,20, 'StructureSensitivity', 0.02);

%Some Testing showed that
% bwareaopen(imbinarize(wiener2(imfill(color_skeleton,'holes'),[1 12]),'adaptive','Sensitivity',0.45),400)
% is very good, so we will do the necessary steps (16.7.18 18:56)

brightness_skeleton = imfill(brightness_skeleton,'holes');
brightness_skeleton = wiener2(brightness_skeleton,[1 2]);

% UPDATE 4.9.18 03:54 - since I added a toggle button that allows you not
% to choose the tip, will only do this step if
if((exist('tipx','var')) ==1)
% The whitening of the tip's neighborhood
brightness_skeleton(tip_root_point + i*croppedsize(1) + i) = 1;
end

brightness_skeleton=imbinarize(brightness_skeleton,'adaptive','Sensitivity',1);


% Last new step
brightness_skeleton = bwareaopen(brightness_skeleton,400);

brightness_skeleton = medfilt2(brightness_skeleton);
% Added the medfilt2 filtering function

brightness_skeleton=imfill(brightness_skeleton,'holes');
brightness_skeleton=bwmorph(brightness_skeleton,'skel',Inf);
brightness_skeleton=imfill(brightness_skeleton,'holes');
brightness_skeleton=bwmorph(brightness_skeleton,'bridge',Inf);
brightness_skeleton=bwareaopen(brightness_skeleton,100);
brightness_skeleton=bwmorph(brightness_skeleton,'spur',4); % Kind of a success. With these functions we get roots without little branches.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          COMBINING APPROACH 1 + 2: A unified front                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The avarage binarized:
unified_skeleton=0.5*(color_skeleton+brightness_skeleton);
unified_skeleton(unified_skeleton>0)=1;

unified_skeleton=bwmorph(unified_skeleton,'spur',1); % Kind of a success. With these functions we get roots without little branches.
unified_skeleton=bwmorph(unified_skeleton,'skel',Inf);

% To implement the optional additional cleaning, created a variable
% howClean instead of a static number
howClean = 70;
unified_skeleton=bwareaopen(unified_skeleton,howClean);

imshowpair(evalin('base', 'cropped_roots_img')*2,unified_skeleton, 'Parent', handles.alt_img);

assignin('base', 'unified_skeleton', unified_skeleton)

