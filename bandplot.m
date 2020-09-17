function ax=bandplot(x,y,c,t)
% function ax=bandplot(x,y,c,t)
% Plot a colored band of thickness 't' (constant)
% Each band segment center is given by the coordinates 'x' and 'y', 
% and has color 'c' (3xN).
%
% Breno Imbiriba - 2019.09.16

% Delta X
dx = diff(x);
dy = diff(y);

% Mid points
mx = x(1:end-1)+dx/2;
my = y(1:end-1)+dy/2;

% Orthogonal direction
sz = sqrt(dx.^2+dy.^2);
ox = dy.*t./sz;
oy = -dx.*t./sz;

% Use pcolor to plot
ax = pcolor([mx; mx+ox],[my; my+oy],[c(1:end-1); c(1:end-1)]);


end
