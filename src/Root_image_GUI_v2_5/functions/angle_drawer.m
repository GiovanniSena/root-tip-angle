function angle_drawer(handles, tip_point, root_angle)
% We shall call it from the angle getting buttons. The user assisted one is
% easy because we have both the tip and the max_curv_point so we just need to
% use the line function to draw a line between them and also some random
% horizontal line from max_curv_point. The non user assisted one is a little tougher.
% I thought I'll just take a very long test line and then see where it intersects
% with the skeleton, so basically xtst = x - 50 * cos(root_angle) etc.
% From there it's the same. (from LOG 28.8.18 19:12)
% Sadly (see LOG same day 22:15) will only be able to use a method with a
% tip and an angle
unified_skeleton = evalin('base', 'unified_skeleton');
% Decided to draw the skeleton overlaid on the root in case there's something
% else there 28.8.18, 21:14
imshowpair(evalin('base', 'cropped_roots_img')*2, unified_skeleton, 'Parent', handles.alt_img);

% % OPTION A: The angle was from the curvature script
% if (isempty(max_curv_point) == 1)
% WILL NEED TO IMPLEMENT. REMEMBER turn_point

% OPTION B: The angle was helped by the user.
% else
%     turn_point = max_curv_point;
%     tiptocurv = line(handles.alt_img,[tip_point(2),turn_point(2)],[tip_point(1),turn_point(1)])
%     tiptocurv.Color = [1,0.5,0.86];
%     tiptocurv.LineWidth=2;
% end

% So now (22:39), I will find a function using the tip and the angle and
% see where it cuts the skeleton. With that I shall draw the line.
% 29.8.18, 15:09 - changed from 50 to 10 and rounded the angle dependant
% part.
coeff = polyfit([tip_point(2), tip_point(2) + round(10 * cosd(root_angle))], [tip_point(1), tip_point(1) - round(10 * sind(root_angle))], 1);
% skel_size = size(unified_skeleton);
% xpoints_from_line = tip_point(2)+1:skel_size(2)
% ypoints_from_line = coeff(1) .* xpoints_from_line + coeff(2);
% ypoints_from_line = round(ypoints_from_line)
% points_from_line = cat(2,xpoints_from_line',ypoints_from_line');
% size(points_from_line)
% Vectors for positions of 1's
[skerowx,skecolx] = find(unified_skeleton);
% And a matrix
skelmat = cat(2,skecolx,skerowx);
% size(skelmat)
% UPDATE (29.8.18, 14:08) - Just going directly for skelmat(:,2)- coeff(1) *
% skelmat(:,1) - coeff (2).
% The next line I took from getAngle code and altered.
% 29.8.18, 14:19 - Thanls to some low key debugging I realized I should change ==0
% with <0.5. I shall try it now
% 29.8.18, 19:51 - added round and chnged to polyval
[turningP_indy,~] = find(abs(skelmat(:,2) - round(polyval(coeff,skelmat(:,1)))) == 0);

% The next line I took from getAngle code
% UPDATE (29.8.18 12:18) tweaked it into a for loop
% for (i=1:length(points_from_line(:,1)))
% [turningP_indy,turningP_indx] = find(skelmat(:,1)==points_from_line(i,1) & skelmat(:,2)==points_from_line(i,2));
% end

% 29.8.18, 19:54 - I realized what a fool I've been!
% turningP_indy,turningP_indx are the indices INSIDE SKELMAT. So what we
% actually need is skelmat(turningP_indy,1) and skelmat(turningP_indy,2)
% 29.8.18, 19:56 - It wasn't perfect. We need the second element of
% turn_point since the first contains garbage or something
turn_point = [skelmat(turningP_indy,1),skelmat(turningP_indy,2)];
% Next line - see LOG 30.8.18 11:24
turn_point = turn_point(find(max(turn_point(:,1)) == turn_point(:,1)),:);
tiptocurv = line(handles.alt_img,[tip_point(2),turn_point(1,1)],[tip_point(1),turn_point(1,2)]);
tiptocurv.Color = [0.7,0.8,0.86];
tiptocurv.LineWidth=2;

%%%%%%%%%%%%%
% TEST
%%%%%%%%%%%%%
% hold on
% plot(1:64,polyval(coeff,1:64))
% plot(1:64,polyval(polyfit([tip_point(2), 1], [tip_point(1), 14], 1),1:64))
% hold off
%%%%%%%%%%%%%
% TEST
%%%%%%%%%%%%%
efline = line(handles.alt_img,[tip_point(2)-5,turn_point(1,1)],[turn_point(1,2),turn_point(1,2)]);
efline.Color = [0.7,0.8,0.86];
efline.LineWidth=2;
end