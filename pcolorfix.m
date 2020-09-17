function ax = pcolorfix(x,y,c)

  % Add extra row and colum and place data at midpoints.
  %
  % Check orientation (ngrid/meshgrid confusion)
  if(diff(x(1:2,1))==0)
    x=x';
  end
  if(diff(y(1,1:2))==0)
    y=y';
  end

  % Delta X
  dx = min(diff(x(:,1)));
  dy = min(diff(y(1,:)));

  % make new grid half dx,dy before
  mx = x-.5*dx; mx(end+1,:) = mx(end,:) + .5*dx; mx(:,end+1) = mx(:,end);
  my = y-.5*dy; my(:,end+1) = my(:,end) + .5*dy; my(end+1,:) = my(end,:);
 
  c(end+1,:) = NaN;
  c(:,end+1) = NaN; 
  % Use pcolor to plot
  ax = pcolor(mx,my,c);

  %ax = pcolor([mx; mx+ox],[my; my+oy],[c(1:end-1); c(1:end-1)]);

end
