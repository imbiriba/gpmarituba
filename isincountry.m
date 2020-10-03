function is=isincountry(lats,lons,xlat,xlon)
% function is=isincountry(lats,lons,xlat,xlon)
%
% Tells if point is inside a country using the Residue theorem.
%
% xlat and xlon define the country boundary. 
% NaNs define end of a contigouns area
% 
% Breno Imbiriba - 2015.09.15

val=6.2;

% Create connected regions %%%%%%%%%%%%%%%%%%%
% Find NaNs - termination points

% If there's a NAN at as the 1st or last entry, remove them
done=false;
while(~done)
  done=true;
  if(isnan(xlon(1))|isnan(xlat(1)))
    xlon = xlon(2:end);
    xlat = xlat(2:end);
    done=false;
  end
  if(isnan(xlon(end))|isnan(xlon(end)))
    xlon = xlon(1:end-1);
    xlat = xlat(1:end-1);
    done=false;
  end
end

inan = find(isnan(xlon) | isnan(xlat));

nsegments = numel(inan)+1;

ZZraw = complex(xlon, xlat);

% If only a single segment (no nans)
if(nsegments==1) 
  mZ = mid(ZZraw);
  dZ = diff(ZZraw);
else 
  % Do first segment
  ZZ{1} = ZZraw(1:inan(1)-1);
  ZZ{1}(end+1) = ZZ{1}(1);
end

% intermediary segments (if nseg>1)
for iseg=2:(nsegments-1)
  ZZ{iseg} =  ZZraw(inan(iseg-1)+1:inan(iseg)-1);
  ZZ{iseg}(end+1) = ZZ{iseg}(1);
end

% Last segment (if nseg>1)
if(nsegments>1)
  ZZ{nsegments} = ZZraw(inan(nsegments-1)+1:end);
  ZZ{nsegments}(end+1) = ZZ{nsegments}(1);

  % Compute mid and diff
  for iseg = 1:nsegments
    mZ{iseg} = mid(ZZ{iseg});
    dZ{iseg} = diff(ZZ{iseg});
  end
  % Now, join all segments:
  mZ = cat(1,mZ{:});
  dZ = cat(1,dZ{:});
end


%% Compute the residue %%%%%%%%%%%%%%%%%%%%%
% Loop over test points
is=[];
for ic=1:numel(lats)

  res(ic)=sum(flat(dZ./(mZ - (lons(ic)+i*lats(ic)))));
  if(abs(res(ic))>val)
    is(ic)=true;
  else
    is(ic)=false;
  end
end

end
