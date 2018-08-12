function final_prep(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Extracting only the tip and then from that the relevant [x,y] values %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
unified_skeleton = evalin('base', 'unified_skeleton');
%  % Creating a rotated matrix
[lastrow, junk] = find(unified_skeleton, 1, 'last' ); % last white pixel is tip of the root
unified_skeleton_size = size(unified_skeleton);
crop_window = [0, lastrow-50, unified_skeleton_size(2), 65];
   final_skeleton = imcrop(unified_skeleton,crop_window);
   final_skeletonR=imrotate(final_skeleton,90);
%  % Vectors for positions of 1's (new x ordered [x after rotation])
  [skerowx,skecolx] = find(final_skeletonR);
%  % And a matrix
  skelmatR = cat(2,skecolx,skerowx);
  
  % In order to be used in curvature script
  assignin('base','skelmatR',skelmatR);


end