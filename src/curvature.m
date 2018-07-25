% curvature.m
% 23.7. ~noon
% Approaches to compute the curvature/angle of the root tip

%% APPROACH 1: CURVATURE VIA TRIANGLE -- 3 POINTS 
%%%%% DOES NOT WORK WELL B/C OF NON-DIFFERENTIABILITY OF LINE

% My formula for curvature is that of a curve defined in terms of a parameter t 
% in which x?, y?, x?, and y? all refer to derivatives with respect to that parameter. 
% If I have only the x and y coordinates of points on a curve, that formula will 
% not be very useful.
% If I have confidence in the accuracy of your point coordinates, I can use 
% the formula for the curvature of a circle through three adjacent points on my curve. 
% That would be an approximation for the curvature at the middle point. 
% That formula is: curvature equals four times the area of the triangle formed 
% by the three points divided by the product of the triangle?s three side lengths. 
% Suppose (x1,y1), (x2,y2), and (x3,y3) are the coordinates of three adjacent points 
% on the curve. The computation can go as follows:

% x1 = skelmatR(1,1);
% x2 = skelmatR(2,1);
% x3 = skelmatR(3,1);
% 
% y1 = skelmatR(1,2);
% y2 = skelmatR(2,2);
% y3 = skelmatR(3,2);

for i = 1:length(skelmatR(:,1))-2
    a = sqrt((skelmatR(i,1)-skelmatR(i+1,1))^2+(skelmatR(i,2)-skelmatR(i+1,2))^2); % The three sides
    b = sqrt((skelmatR(i+1,1)-skelmatR(i+2,1))^2+(skelmatR(i+1,2)-skelmatR(i+2,2))^2);
    c = sqrt((skelmatR(i+2,1)-skelmatR(i,1))^2+(skelmatR(i+2,2)-skelmatR(i,2))^2);
    s = (a+b+c)/2;
    A = sqrt(s*(s-a)*(s-b)*(s-c)); % Area of triangle
    K(i) = 4*A/(a*b*c) % Curvature of circumscribing circle
    K_2(i) = 2*abs((x2-x1).*(y3-y1)-(x3-x1).*(y2-y1)) ./ ...
        sqrt(((skelmatR(i+1,1)-skelmatR(i,1)).^2+(skelmatR(i+1,2)-skelmatR(i,2)).^2)*((skelmatR(i+2,1)-skelmatR(i,1)).^2+(skelmatR(i+2,2)-skelmatR(i,2)).^2)*((skelmatR(i+2,1)-skelmatR(i+1,1)).^2+(skelmatR(i+2,2)-skelmatR(i+1,2)).^2));
end
plot(K)
plot(K_2)
% % or alternatively:
% a = sqrt((x1-x2)^2+(y1-y2)^2); % The three sides
% b = sqrt((x2-x3)^2+(y2-y3)^2);
% c = sqrt((x3-x1)^2+(y3-y1)^2);
% A = 1/2*abs((x1-x2)*(y3-y2)-(y1-y2)*(x3-x2)); % Area of triangle
% K = 4*A/(a*b*c); % Curvature of circumscribing circle


% Approximation to the curve's curvature at the middle point. (x2,y2), of the three points."
% To have used 'cftool' you must have had the coordinates of a set of points that determined your curve. 
% If you are very confident of the accuracy of these points, you can approximate the curvature at a point (x2,y2) 
% by the curvature of the unique circle that goes through the three successive points (x1,y1), (x2,y2), and (x3,y3). 
% Let (x1,y1), (x2,y2), and (x3,y3) be three successive points on your curve. 
% The curvature of a circle drawn through them is simply four times the area of the triangle 
% formed by the three points divided by the product of its three sides. 
% Using the coordinates of the points this is given by:
% K = 2*abs((x2-x1).*(y3-y1)-(x3-x1).*(y2-y1)) ./ ...
%   sqrt(((x2-x1).^2+(y2-y1).^2)*((x3-x1).^2+(y3-y1).^2)*((x3-x2).^2+(y3-y2).^2));
%   see K_2(i)



%% APPROACH 2:  ANGLE BETWEEN TWO POINTS USING SCALAR PRODUCT
% using matlab function 'atan2' (more accurate for this purpose than 'acos'). 
% Let P0 = [x0;y0] be a vector of x,y coordinates for the vertex of the angle 
% to be measured and P1 = [x1;y1] and P2 = [x2;y2] be vectors for points on 
% the two lines connecting them to P0.

for i = 1:length(skelmatR(:,1))-2
    x10 = skelmatR(i,1)-skelmatR(i+1,1);
    y10 = skelmatR(i+1,2)-skelmatR(i,2);
    x20 = skelmatR(i+2,1)-skelmatR(i+1,1);
    y20 = skelmatR(i+2,2)-skelmatR(i+1,2); 
    ang(i) = atan2(abs(x10*y20-x20*y10),x10*y10+x20*y20)
end
plot(ang)

%%  APPROACH 3: CURVATURE USING FORMULA FROM PAPER ROBERT ISRAEL 
% https://math.stackexchange.com/questions/1483105/matlab-code-for-finding-the-curvature-of-a-curve-using-given-data-points
%%%%% DOES NOT WORK WELL: inf values

i = 3
%for i = 1:length(skelmatR(:,1)) 
%     x = skelmatR(i,1);
%     y = skelmatR(i,2);
%     mx = mean(x); my = mean(y);
    mx = mean(skelmatR(:,1)); my = mean(skelmatR(:,2));
    X = x - mx; Y = y - my; % Get differences from means
    dx2 = mean(X.^2); dy2 = mean(Y.^2); % Get variances
    t = [X,Y]\(X.^2-dx2+Y.^2-dy2)/2; % Solve least mean squares problem
    a0 = t(1); b0 = t(2); % t is the 2 x 1 solution array [a0;b0]
    r = sqrt(dx2+dy2+a0^2+b0^2); % Calculate the radius
    a = a0 + mx; b = b0 + my; % Locate the circle's center
    curv(i) = 1/r % Get the curvature
%end
plot(curv)

%% APPROACH 4: 
% https://www.researchgate.net/post/What_are_simple_methods_for_calculating_curvature_of_a_curve


%% APPROACH 5: INTERPOLATION -- 9 POINTS

% Use skeleton/bwboundaries to get a list of the (x,y) boundary coordinates. 
% Run around that border taking a section of the curve, say 9 elements, and fit 
% a polynomial to it. Knowing the derivative of the curve model I used, and 
% the coefficients polyfit() gave me, I can get the curvature at each point. 
% Then I run around the list of (x,y) edge coordinates using a marker color 
% that corresponds to the curvature. 

% A large radius of curvature means a "flat" part of the curve while a small radius 
% of curvature means "pointy" parts of the curve.
% Whether it's positive or negative just says which side of the curve it's bending to. 
% I could just take the absolute value of the curvature if I don't care which 
% side it bends toward; however, we do care as the root bends positively
% (clockwise).


% I = imread('curv_circle.tif');
% binaryImage = im2bw(I);
% %figure, imshow(binaryImage, []);
% %
% boundaries = bwboundaries(binaryImage);
% %
% x = boundaries{1}(:, 2);
% y = boundaries{1}(:, 1);
windowSize = 10;
halfWidth = floor(windowSize/2);   % half window size
curvatures = zeros(size(skelmatR(:,1)));
%
%k =10
for k = halfWidth+1 : length(skelmatR(:,1)) - halfWidth
	theseX = skelmatR(k-halfWidth:k+halfWidth,1);   % 19 element of x
	theseY = skelmatR(k-halfWidth:k+halfWidth,2);   % 19 element of y
	% get a fit
	coefficients = polyfit(theseX, theseY, 2);
	% get the curvature
	curvatures(k) = coefficients(1);
	xc(k) = skelmatR(k,1);
	yc(k) = skelmatR(k,2);	

end
clc

% get rid of ridiculous curvatures (straight line segments)
curvatures(abs(curvatures) > 20) = 0;

%curvatures = flip(curvatures)
%
plot(skelmatR(:,1), curvatures, 'b-');
hold on 
plot(skelmatR(:,2), curvatures, 'r-');

min_Cur = min(curvatures)
%
max_Cur = max(curvatures)
[L W] = size(curvatures);
%
CurCur = curvatures;
for i = 1 :L
    for j = 1 : W
        if CurCur (i,j) < 0  % negative values
           CurCur (i,j) =  CurCur (i,j) +(abs(min_Cur))
        elseif CurCur (i,j) > 0  % positive values
            CurCur (i,j) =  CurCur (i,j) + 100
        end
    end
end

curvatures = CurCur;
%%

%%
% make up a colormap
minC = min(curvatures)
maxC = max(curvatures)
range = ceil(maxC - minC)
myColorMap = jet(range);
% display the image again
imshow(workskelR);
hold on;
%
for k = halfWidth+1 : length(skelmatR(:,1)) - halfWidth
	% get the index in the color map
	thisIndex = round(size(myColorMap, 1) * (curvatures(k) - minC) / range)
	
    fprintf('For point #%d, the colormap index is %d\n', k, thisIndex);
	if thisIndex <= 0
		thisIndex = 1;
	end
	if isnan(thisIndex)
		thisIndex = 1;
	end
	% extract out the RGB triplet for this particular row in the color map
	thisColor = myColorMap(thisIndex, :);
	plot(skelmatR(k,1), skelmatR(k,2), '.', 'MarkerSize', 25, 'Color', thisColor);
end


%% COMPUTE CENTRAL ANGLE
% central angle in radians a = arc length s / radius r

% TODO:
% compute arc length using pairwise segment lengths
