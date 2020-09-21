function ax = pcolorcell(x,y,c)
% function ax = pcolorcell(x,y,c)
% pcolor for cell-centered data.
%
% Uses pcolor by adding extra row and colum and place data at midpoints.
%
% B.I. 2020.09.21

if(nargin()==0)
  testpcolorcell();
  return
end

  swap=[false false];
  if(diff(x(1:2,1))==0)
    x=x';
    swap(1)=true;
  end
  if(diff(y(1,1:2))==0)
    y=y';
    swap(2)=true;
  end
  if(xor(swap(1),swap(2)))
    disp(swap)
    error('X and Y are not consistent');
  end
  if(swap(1))
    c=c';
  end

  % Delta X
  dx = min(diff(x(:,1)));
  dy = min(diff(y(1,:)));

  % make new grid half dx,dy before
  mx = x-.5*dx; 
  mx(end+1,:) = mx(end,:)+dx; mx(:,end+1) = mx(:,end);

  my = y-.5*dy; 
  my(:,end+1) = my(:,end)+dy; my(end+1,:) = my(end,:);
 
  c(end+1,:) = NaN; c(end,:); %NaN;
  c(:,end+1) = NaN; c(:,end); %NaN; 
  % Use pcolor to plot
  ax = pcolor(mx,my,c);

  %ax = pcolor([mx; mx+ox],[my; my+oy],[c(1:end-1); c(1:end-1)]);

end
function testpcolorcell()

  [x y] = ndgrid([0:1:10],[0:10:100]);
  c = x+y.^.5;
 
  figure;
  pcolor(x,y,c); colorbar; caxis([0 20]); colormap(jet(20));
  title('pcolor');
  figure;
  ax = pcolorcell(x,y,c); colorbar; caxis([0 20]); colormap(jet(20));
  title('pcolorfix');

end
