function [rx ry rc] = minipath_compute(xx, yy, cc, fn, s, docells, averaging)
% function [rx ry rc] = minipath_compute(xx, yy, cc, fn, s, docells, averaging)
% 
% Use predefined "minipath" pathes and agregate provided data into it.
% xx, yy - define the x and y coordinates of data points (path or area). 
% cc     - defines the quantity to be aggregated.
% fn     - is the function performing the aggregation (@mean or @max);
%    (- optionals -)
% s      - path discretization spacing (default 50m)
% docells- logical, is TRUE, return variables are cell arrays for each minipath.
% averaging - radius of data aggregation (default 100m). Usefull for model data;
%
% If no input arguments are provideds, will run a diagnostic test. 
%
% based on minipath1.m
%
% B.I. 2019.10.01
% B.I. 2019.11.27
% B.I. 2020.09.17 - fixed to work woth non-path data (model data)

%%%%%%%%
% Run TEST 
if(nargin()==0)
  run_test();
  return
end

%%%%%%%% Base pathes definition
if(nargin()<=4)
  s=50;
end
if(nargin()<=5)
  docells=false;
end
if(nargin()<=6)
  averaging = 50;
end

% Compute pathes with grid spacing 's'
[paths NN] = get_paths(s);

%keyboard
%%%% Aggregate values
z = complex(xx,yy);
nz = numel(z);

if(nz<10)
  rx=[]; ry=[]; rc=[];
  return
end
val = cc; 

% Compute distance of a point "z" to a particular path.
for ii=1:numel(NN)
  [distpaths{ii}] = min(abs(paths{ii}.'*ones(1,nz)-ones(NN(ii),1)*z),[],1);
  vpaths{ii} = zeros(size(paths{ii}));
end

% Find the closest path to each point "z"
[~,ipath] = min(cat(1,distpaths{:}),[],1);

for ii=1:numel(NN)
  % find points closer to path "ii"
  ik = find(ipath==ii);

  % Find which path point is closer to which "z" point
  zp = z(ik);
  nzp = numel(zp);
  [dist, izp] = min(abs(paths{ii}.'*ones(1,nzp)-ones(NN(ii),1)*zp),[],1);

  % keep only data that's inside averaging circle
  iclose = find(dist<averaging);

  % compute the mean/max values
  zpaths{ii}=[];
  dataused{ii}=[];
  %vpathsavg{ii}=[];
  vpathsmax{ii}=[];
  for ix = unique(izp)
    ikk = find(izp==ix);
    ikkc= intersect(ikk,iclose);
    zpaths{ii}(ix) = paths{ii}(ix);
    dataused{ii} = [dataused{ii} zp(ikkc)];
    %vpathsavg{ii}(ix) = mean(val(ik(ikk)));
    %vpathsmax{ii}(ix) = max(val(ik(ikk)));
    if(numel(ikkc)==0)
      vpathsmax{ii}(ix) = NaN;
    else
      vpathsmax{ii}(ix) = fn(val(ik(ikkc)));
    end
  end
  if(numel(zpaths)~=numel(vpathsmax))
    error('Inconsistent lengths!');
  end
end

if(~docells)
  rx=[]; ry=[]; rc=[];
  for ii=1:numel(NN)
    rx = [rx real(zpaths{ii}) NaN];
    ry = [ry imag(zpaths{ii}) NaN];
  rc = [rc vpathsmax{ii} NaN];
  end
  rx(rc==0)=NaN;
  ry(rc==0)=NaN;
  rc(rc==0)=NaN;
else
  for ii=1:numel(NN)
    rx{ii} = real(zpaths{ii});
    ry{ii} = imag(zpaths{ii});
    rc{ii} = vpathsmax{ii};
    rx{ii}(rc{ii}==0) = NaN;
    ry{ii}(rc{ii}==0) = NaN;
    rc{ii}(rc{ii}==0) = NaN;
  end
end

%% Plot Landfill location
%latlon=load('marituba_todo.dat');
%[xx yy]=latlon2xy(latlon(:,2),latlon(:,1));

end

function run_test()
%keyboard
    flat = @(x) x(:);
    x=[-5000:50:5000];
    y=x;
    [XX YY] = meshgrid(x,y);
    PPMX = abs(cos(XX/1000*2*pi));
    PPMY = abs(cos(YY/1000*2*pi));
    figure; pcolor(XX,YY,PPMX); shading flat; title('Area data - X'); 
    [rx,ry,rcx] = minipath_compute(flat(XX)', flat(YY)', flat(PPMX)', @max, 50, false, 55);
    caxis([0 1]);
    figure
    scatter(rx,ry,20,rcx,'f'); title('Road collect - X');
    caxis([0 1]);
    
    figure; pcolor(XX,YY,PPMY); shading flat; title('Area data - Y'); 
    caxis([0 1]);
    [rx,ry,rcy] = minipath_compute(flat(XX)', flat(YY)', flat(PPMY)', @max);
    figure
    scatter(rx,ry,20,rcy,'f'); title('Road collect - Y');
    caxis([0 1]);

    % Make path data
    [paths NN] = get_paths(10);
    xx=[]; yy=[];
    for ii=1:numel(paths)
      xx = [xx real(paths{ii})];
      yy = [yy imag(paths{ii})];
    end
    ch4 = abs(cos(xx/1000*2*pi));
    [rx ry rc] = minipath_compute(xx, yy, ch4,@max);
    figure;
    scatter(rx,ry,20,rc,'f');
    caxis([0 1]);
    title('Line - X');
    ch4 = abs(cos(yy/1000*2*pi));
    [rx ry rc] = minipath_compute(xx, yy, ch4,@max);
    figure;
    scatter(rx,ry,20,rc,'f');
    caxis([0 1]);
    title('Line - Y');

end
