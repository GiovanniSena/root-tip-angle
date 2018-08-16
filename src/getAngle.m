%% FINAL CURVATURE AND ANGLE COMPUTATION

function a=getAngle(skelmatR_simp, max_curv_point)

% disenable this if we do not have max_curv_point as user input
skelmatR = skelmatR_simp;

% just take lower/ RHS half of the skeleton  -- ADJUST THIS, MIGHT ADD INPUT
% PARAMETER HOW MUCH OF THE ROOT TIP WE WANT TO CONSIDER, ~0.2
vertices = skelmatR(round(length(skelmatR) - length(skelmatR)/5):end, :);
% vertices = skelmatR(length(skelmatR)/2):end, :);
% vertices = skelmatR(end-(length(skelmatR)/5)+1:end, end-(length(skelmatR)/5)+1:end)
curv = LineCurvature(vertices);
[maxValue, linearIndexesOfMaxes] = max(curv(:));


% OPTION A:
if ~exist('max_curv_point','var')
    % third parameter does not exist, so default it to something
    turningP_ind = round(length(skelmatR) - length(skelmatR)/5) + linearIndexesOfMaxes;
    turningP = skelmatR(turningP_ind,:);
end

% OPTION B:
if exist('max_curv_point','var')
    turningP = max_curv_point;
    turningP_ind = find(skelmatR(:,1)==max_curv_point(:,1) & skelmatR(:,2)==max_curv_point(2));
end

% % Take last 20% of whole root
% % index_max = length(skelmatR)/2 + linearIndexesOfMaxes
% turningP_ind = round(length(skelmatR) - length(skelmatR)/5) + linearIndexesOfMaxes 

%% APPROACH A: USE TIP AND EQUIDISTANT POINT FROM POINT WITH HIGHEST MEAN CURVATURE (MANUALLY CHOSEN)

% choose max_curv_point := [348, 9]
%turningP = skelmatR(349,:) % replace 349 by "get index of turning point":
% turningP = curvature(skelmatR)

tip = skelmatR(end,:); % [305, 45]
len = length(skelmatR) - turningP_ind; % 132
top = skelmatR(turningP_ind - len,:);


%% WORKS BEST for angle coputation, most stable/robust, 
% slight changes to other angle computations

v1 = turningP - tip;
v2 = turningP - top;
angle2 = acosd(sum(v1.*v2) / (norm(v1)*norm(v2)));
%aoi = 180 - angle2 % 11.25 % wrong angle
aoi = angle2 - 90

end

%% LineCurvature.m
% only takes the vertices for now, if we had lines (see getline()) between 
% information, we could add this information. GOOD FOR NOW

function k=LineCurvature(Vertices,Lines)
% This function calculates the curvature of a 2D line. It first fits 
% polygons to the points. Then calculates the analytical curvature from
% the polygons
%
%  k = LineCurvature(Vertices,Lines)
% 
% inputs,
%   Vertices : A M x 2 list of line points.
%   (optional)
%   Lines : A N x 2 list of line pieces, by indices of the vertices
%         (if not set assume Lines=[1 2; 2 3 ; ... ; M-1 M])
%
% outputs,
%   k : M x 1 Curvature values
%
% If no line-indices, assume a x(1) connected with x(2), x(3) with x(4) ...
if(nargin<2)
    Lines=[(1:(size(Vertices,1)-1))' (2:size(Vertices,1))'];
end

% Get left and right neighbour of each points
Na=zeros(size(Vertices,1),1); Nb=zeros(size(Vertices,1),1);
Na(Lines(:,1))=Lines(:,2); Nb(Lines(:,2))=Lines(:,1);

% Check for end of line points, without a left or right neighbour
checkNa=Na==0; checkNb=Nb==0;
Naa=Na; Nbb=Nb;
Naa(checkNa)=find(checkNa); Nbb(checkNb)=find(checkNb);

% If no left neighbour use two right neighbours, and the same for right... 
Na(checkNa)=Nbb(Nbb(checkNa)); Nb(checkNb)=Naa(Naa(checkNb));

% Correct for sampeling differences
Ta=-sqrt(sum((Vertices-Vertices(Na,:)).^2,2));
Tb=sqrt(sum((Vertices-Vertices(Nb,:)).^2,2)); 

% If no left neighbor use two right neighbors, and the same for right... 
Ta(checkNa)=-Ta(checkNa); Tb(checkNb)=-Tb(checkNb);

% Fit a polygons to the vertices 
% x=a(3)*t^2 + a(2)*t + a(1) 
% y=b(3)*t^2 + b(2)*t + b(1) 
% we know the x,y of every vertice and set t=0 for the vertices, and
% t=Ta for left vertices, and t=Tb for right vertices,  
x = [Vertices(Na,1) Vertices(:,1) Vertices(Nb,1)];
y = [Vertices(Na,2) Vertices(:,2) Vertices(Nb,2)];
M = [ones(size(Tb)) -Ta Ta.^2 ones(size(Tb)) zeros(size(Tb)) zeros(size(Tb)) ones(size(Tb)) -Tb Tb.^2];
invM=inverse3(M);
a(:,1)=invM(:,1,1).*x(:,1)+invM(:,2,1).*x(:,2)+invM(:,3,1).*x(:,3);
a(:,2)=invM(:,1,2).*x(:,1)+invM(:,2,2).*x(:,2)+invM(:,3,2).*x(:,3);
a(:,3)=invM(:,1,3).*x(:,1)+invM(:,2,3).*x(:,2)+invM(:,3,3).*x(:,3);
b(:,1)=invM(:,1,1).*y(:,1)+invM(:,2,1).*y(:,2)+invM(:,3,1).*y(:,3);
b(:,2)=invM(:,1,2).*y(:,1)+invM(:,2,2).*y(:,2)+invM(:,3,2).*y(:,3);
b(:,3)=invM(:,1,3).*y(:,1)+invM(:,2,3).*y(:,2)+invM(:,3,3).*y(:,3);

% Calculate the curvature from the fitted polygon
k = 2*(a(:,2).*b(:,3)-a(:,3).*b(:,2)) ./ ((a(:,2).^2+b(:,2).^2).^(3/2));

function  Minv  = inverse3(M)
% This function does inv(M) , but then for an array of 3x3 matrices
adjM(:,1,1)=  M(:,5).*M(:,9)-M(:,8).*M(:,6);
adjM(:,1,2)=  -(M(:,4).*M(:,9)-M(:,7).*M(:,6));
adjM(:,1,3)=  M(:,4).*M(:,8)-M(:,7).*M(:,5);
adjM(:,2,1)=  -(M(:,2).*M(:,9)-M(:,8).*M(:,3));
adjM(:,2,2)=  M(:,1).*M(:,9)-M(:,7).*M(:,3);
adjM(:,2,3)=  -(M(:,1).*M(:,8)-M(:,7).*M(:,2));
adjM(:,3,1)=  M(:,2).*M(:,6)-M(:,5).*M(:,3);
adjM(:,3,2)=  -(M(:,1).*M(:,6)-M(:,4).*M(:,3));
adjM(:,3,3)=  M(:,1).*M(:,5)-M(:,4).*M(:,2);
detM=M(:,1).*M(:,5).*M(:,9)-M(:,1).*M(:,8).*M(:,6)-M(:,4).*M(:,2).*M(:,9)+M(:,4).*M(:,8).*M(:,3)+M(:,7).*M(:,2).*M(:,6)-M(:,7).*M(:,5).*M(:,3);
Minv=bsxfun(@rdivide,adjM,detM);
end

end
