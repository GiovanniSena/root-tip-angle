% https://stackoverflow.com/questions/49519816/calculating-the-curvature-of-a-closed-curve-or-polygon-in-matlab

% definition of curvature: difference between edge direction vectors;
% geometrically, the curvature k measures how fast the unit tangent vector
% to the curve rotates

% FUTURE WORK: curvature on a sparse polygon like this might not be very
% meaningful but that does not mean it is not possible to apply the
% discrete approximation to the derivative to compute it. 
% The same code on a more densly samples outline will give a good
% approximation of the curvature of the outline

% In a computer even a smooth curve is a polygon with very small intervals
% WRONG
% 1. the curvature is not the second derivative, and the difference of the
% direction vectors is not the second derivative
% 2. in a computer a smooth curve can very well be handled as a smooth
% curve
% 3. differential geometry does exist
% 4. ignoring the unequal segment lengths may introduce a bias -- but we
% take that into account here


%x = [1.34, 0.92, 0.68, 0.25, -0.06, -0.34, -0.49, -0.72, -0.79, -0.94, -1.35, -0.35, 0.54, 0.68, 0.84, 1.20, 1.23, 1.32, 1.34];
%y = [0.30, 0.43, 0.90, 1.40, 1.13, 1.08, 1.14, 1.23, 0.52, 0.21, -0.20, -0.73, -0.73, -0.82, -0.71, -0.76,-0.46, -0.13, 0.30];

%x = transpose(skelmatR(:,1))
%y = transpose(skelmatR(:,2))

%x = [1;1;2;3;3;4;4;5;5;6;6;7;7;8;8;9;9;10;10;11;11;12;12;13;14;14;15;15;16;16;17;17;18;19;19;20;21;21;22;23;24;25;26;27;28;28;29;30;30;31;32;33;33;34;35;36;36;37;38;39;39;40;40;41;42;43;44;45;45;46;46;47;47;48;48;49;49;50;50;51;51;52;52;53;53;54;54;55;55;56;56;57;57;57;57;58;58;59;60;60;61;61;62;62;63;63;63;63;64;64;64;64;64;65;65;1]
x = transpose(x)
y = [27;26;27;26;27;25;26;25;26;24;25;24;25;23;24;23;24;22;23;22;23;22;21;22;21;22;20;21;20;21;20;19;20;19;18;19;18;18;17;17;16;16;15;16;15;14;15;14;14;13;14;13;13;12;13;12;12;11;12;11;12;11;11;11;11;10;11;10;11;10;11;10;11;10;11;10;11;10;12;11;12;11;12;12;13;12;13;12;14;12;13;14;15;15;16;17;18;19;19;20;21;22;22;23;24;25;25;26;27;28;29;28;29;27]
y = transpose(y)

% First derivative
% estimates the derivative in between pairs of samples
dsx = diff(x); % computes the difference between subsequent elements, yielding a vector with one fewer element
dsy = diff(y);
ds = sqrt(dsx.^2+dsy.^2); % to take into account unequal segment lengths
Tx = dsx./ds;
Ty = dsy./ds;

% Second derivative & curvature
% repeat procedure from above to get second derivative at samples, but not
% at the first or last sample (we have 2 fewer elements now)
ds2 = 0.5*(ds([end,1:end-1])+ds); % average of the length of two neighbouring edges,
% ie the length of edge in between neighbouring normals if you consider the
% normals to be halfway between vertices
Hx = diff(Tx([end,1:end]))./ds2; % replicate a point after the first derivative, 
% ie adding the last point to the beginning, do the elements are in the same order as in the input array
Hy = diff(Ty([end,1:end]))./ds2;

% Plot
% we plot the normals (Ty, -Tx) in black
clf
hold on
plot(x,y,'ro-');
x = x(1:end-1);
y = y(1:end-1); % remove repeated point
quiver(x+dsx/2,y+dsy/2,Ty,-Tx,'k','autoscalefactor',0.3); 
quiver(x,y,Hx,Hy,'b','autoscalefactor',1.2); 
set(gca,'xlim',[-2 2],'ylim',[-1.5 2]);
axis equal


% https://math.stackexchange.com/questions/1544800/curvature-measure-for-polygones-on-a-2d-space
% On how to approximate the curvature of discrete plane curves. 
% There are several potential formulas, depending on the precise properties 
% you are interested in: http://www.cs.utexas.edu/users/evouga/uploads/4/5/6/8/45689883/notes1.pdf