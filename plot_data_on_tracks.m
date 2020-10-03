function [h rx, ry, rch4] = plot_data_on_tracks(plumes,is,func,kpx, kpy, dist)
% function [h, rx, ry, rch4] = plot_data_on_tracks(plumes,is,func,kpx, kpy, dist)
%
% Plot simulated plume data on car tracks
%
% plumes - structe with "plumes" data
% is - plume ID to plot
% func - agregating function (mean, max, median, etc...)
% kpx, kpy - given track data to intersect with calculated data 
%          - returns values only dist close to these tracks
%
% B.I. 2020.09.15
  if(nargin()==0)
   run_test();
   return
  end 

  if(nargin()<3)
    func = @max;
  end

  dokeep=false;
  if(nargin()>=5)
    dokeep=true;
  end

  flat = @(x) x(:);

  nn = size(plumes(is).XX,2);
  ch4 = flat(plumes(is).PPM(:,:,1));
  xx = flat(plumes(is).Xg); %flat(plumes(is).XX'*ones(1,nn));
  yy = flat(plumes(is).Yg); %flat(ones(nn,1)*plumes(is).YY);
  [rx,ry,rch4] = minipath_compute(xx', yy', ch4', func); %, 50, false, 100);
  if(dokeep)
    % Keep only path datapoints that match kpx and kpy
    rz = complex(rx,ry);
    kz = complex(kpx,kpy);
    ik=0; keepz=[]; keepc=[];
    for ii=1:numel(kz)
      [~,jj] = find(abs(rz-kz(ii))<dist);
      if(numel(jj)>0)
%	disp(jj)
	ik=ik+1;
	isave(ik) = jj(1);
      end
    end
    isave = unique(isave);
    keepz = rz(isave);
    keepc = rch4(isave);
  end
  for ii=1:(numel(keepz)-1)
    if(abs(keepz(ii+1)-keepz(ii))>100)
      keepz([1:ii ii+1 ii+2:end+1]) = [keepz(1:ii) NaN keepz(ii+1:end)];
      keepc([1:ii ii+1 ii+2:end+1]) = [keepc(1:ii) NaN keepc(ii+1:end)];
    end
  end
  rx = real(keepz);
  ry = imag(keepz);
  rch4 = keepc;
  h = bandplot(rx,ry,rch4,100); shading flat

end 

function run_test()
  % test:
  flat = @(x) x(:);
  XX=[-10000:50:10000];
  YY=XX;
  [PPM1 PPM2] = ndgrid(XX,YY);
  nn = size(XX,2);
  ch4 = flat(PPM1);
  xx = flat(XX'*ones(1,nn));
  yy = flat(ones(nn,1)*YY);
  [rx,ry,rch4] = minipath_compute(xx', yy', ch4', @max);
  figure;
  scatter(rx,ry,20,rch4,'f');
  title('X')
  ch4 = flat(PPM2);
  [rx,ry,rch4] = minipath_compute(xx', yy', ch4', @max);
  figure;
  title('Y');
  scatter(rx,ry,20,rch4,'f');

end 


