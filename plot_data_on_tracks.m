function h = plot_data_on_tracks(plumes,is,func)
% function plot_data_on_tracks(plumes,is,func)
%
% Plot simulated plume data on car tracks
%
% B.I. 2020.09.15
  if(nargin()==0)
   run_test();
   return
  end 

  if(nargin()<3)
    func = @max;
  end

  flat = @(x) x(:);

  nn = size(plumes(is).XX,2);
  ch4 = flat(plumes(is).PPM(:,:,1));
  xx = flat(plumes(is).Xg); %flat(plumes(is).XX'*ones(1,nn));
  yy = flat(plumes(is).Yg); %flat(ones(nn,1)*plumes(is).YY);
  [rx,ry,rch4] = minipath_compute(xx', yy', ch4', func); %, 50, false, 100);
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


