%% APPROACH A: USE TIP AND EQUIDISTANT POINT FROM POINT WITH HIGHEST MEAN CURVATURE (MANUALLY CHOSEN)

% choose max_curv_point := [348, 9]
%turningP = skelmatR(349,:) % replace 349 by "get index of turning point":
% turningP = curvature(skelmatR)

% disenable this if we do not have max_curv_point as user input
skelmatR = skelmatR_simp;

turningP = max_curv_point;
turningP_ind = find(skelmatR(:,1)==max_curv_point(:,1) & skelmatR(:,2)==max_curv_point(2));
tip = skelmatR(end,:); % [305, 45]
len = length(skelmatR) - turningP_ind; % 132
top = skelmatR(turningP_ind - len,:);

%%
% % angle of each line to the x-axis
% angle1 = atan((top(2) - top(1)) / (turningP(2) - turningP(1)) )
% angle2 = atan((tip(2) - tip(1)) / (turningP(2) - turningP(1)) )
% 
% diff = (angle1 - angle2) * 180/pi
% % 
% % if diff<0
% % %     angle  = diff + 360
% %     angle = abs(diff)
% % else
% %     angle = diff
% % end
% % 
% % aoi = 180 - angle
%     

%%alternatively:
%%fit a straight line using polyval:
%p = polyval(x, y, 1)
%%p(1) is the gradient and you can calculate the angle:
%a = atan(p(1))
%%If you do this for each line you have two angles and can calculate the
%%difference.


%% WORKS BEST
v1 = turningP - tip;
v2 = turningP - top;
angle2 = acosd(sum(v1.*v2) / (norm(v1)*norm(v2)))
aoi = 180 - angle2 % 11.25

%%
%% https://uk.mathworks.com/matlabcentral/answers/38725-find-angle-between-two-line 

v1 = top - turningP;
v2 = tip - turningP;
a1 = mod(atan2( det([v1;v2;]) , dot(v1,v2) ), 2*pi ) % 3.3380, compare to angle1
angleout = abs((a1>pi/2)*pi-a1)  

%% 
v1 = turningP - tip;
v2 = turningP - top;
% To find the angle between two vectors, I take the dot product of the unit vectors
clamp = @(val, low, high) min(max(val,low), high);
% clamp prevents the value from exceeding 1 (or -1) due to floating point
% precision errors
angle1 = acos( clamp(dot(v1,v2) / norm(v1) / norm(v2), -1, 1) ) % 2.9452

% To know which direction that is in, we can do the trick with the
% cross-product. Since it is 2D, we can do this:
vc = cross([v1,0], [v2,0]);
anticlock = vc(3) > 0;

%Note: acos(dot(u,v)) is instable if u and v are near to (anti)parallel,
%but not the case here.

%% 
%% APPROACH B: USE TIP AND EQUIDISTANT POINT FROM POINT WITH HIGHEST MEAN CURVATURE (using approach 5)
