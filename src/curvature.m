% curvature.m
% 23.7. ~noon
% Computes the curvature of the root tip

%% APPROACH 1: TRIANGLE -- 3 POINTS

% MY formula for curvature is that of a curve defined in terms of a parameter t 
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

a = sqrt((x1-x2)^2+(y1-y2)^2); % The three sides
b = sqrt((x2-x3)^2+(y2-y3)^2);
c = sqrt((x3-x1)^2+(y3-y1)^2);
s = (a+b+c)/2;
A = sqrt(s*(s-a)*(s-b)*(s-c)); % Area of triangle
K = 4*A/(a*b*c); % Curvature of circumscribing circle

% % or alternatively:
% a = sqrt((x1-x2)^2+(y1-y2)^2); % The three sides
% b = sqrt((x2-x3)^2+(y2-y3)^2);
% c = sqrt((x3-x1)^2+(y3-y1)^2);
% A = 1/2*abs((x1-x2)*(y3-y2)-(y1-y2)*(x3-x2)); % Area of triangle
% K = 4*A/(a*b*c); % Curvature of circumscribing circle


%% APPROACH 2: INTERPOLATION -- 9 POINTS


% I = imread('curv_circle.tif');
% binaryImage = im2bw(I);
% %figure, imshow(binaryImage, []);
% %
% boundaries = bwboundaries(binaryImage);
% %
% x = boundaries{1}(:, 2);
% y = boundaries{1}(:, 1);
windowSize = 10;
halfWidth = floor(windowSize/2);   %half window size
curvatures = zeros(size(skelmatR(:,1)));
%
%k =10
for k = halfWidth+1 : length(x) - halfWidth
	theseX = skelmatR(k-halfWidth:k+halfWidth,1);   % 19 element of x
	theseY = skelmstR(k-halfWidth:k+halfWidth,2);   % 19 elemebt of y
	% Get a fit.
	coefficients = polyfit(theseX, theseY, 2);
	% Get the curvature
	curvatures(k) = coefficients(1);
	xc(k) = skelmatR(k,1);
	yc(k) = skelmatR(k,2);	

end
clc

% Get rid of ridiculous curvatures (straight line segments).
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
        if CurCur (i,j) < 0  %negative values
           CurCur (i,j) =  CurCur (i,j) +(abs(min_Cur))
        elseif CurCur (i,j) > 0  %positive values
            CurCur (i,j) =  CurCur (i,j) + 100
        end
    end
end

curvatures = CurCur;
%%

%%
% Make up a colormap
minC = min(curvatures)
maxC = max(curvatures)
range = ceil(maxC - minC)
myColorMap = jet(range);
% Display the image again.
imshow(binaryImage);
hold on;
%
for k = halfWidth+1 : length(skelmatR(:,1)) - halfWidth
	% Get the index in the color map.
	thisIndex = round(size(myColorMap, 1) * (curvatures(k) - minC) / range)
	
    fprintf('For point #%d, the colormap index is %d\n', k, thisIndex);
	if thisIndex <= 0
		thisIndex = 1;
	end
	if isnan(thisIndex)
		thisIndex = 1;
	end
	% Extract out the RGB triplet for this particular row in the color map.
	thisColor = myColorMap(thisIndex, :);
	plot(skelmatR(k,1), skelmatR(k,2), '.', 'MarkerSize', 25, 'Color', thisColor);
end
