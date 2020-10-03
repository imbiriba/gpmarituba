
%{
for is=[2 5 7 8 11 12 14 15 16 21 22];
% match correlation by rotating plume
%
% Compute points with maximum data
% Use only points at BR and Alça Viária roads.

ikeep = keep_only_road_area(trackcalc(is).XX, trackcalc(is).YY);

[~,imax] = max(trackcalc(is).PPM(ikeep));
[~,jmax] = max(sections(is).lgrdata.data(iCH4,ikeep));
thetai = atan2(trackcalc(is).YY(ikeep(imax)),trackcalc(is).XX(ikeep(imax)));
thetaj = atan2(sections(is).trackdata.YY(ikeep(jmax)),sections(is).trackdata.XX(ikeep(jmax)));
dth = thetaj-thetai;

% rotate:
x = trackcalc(is).XX;
y = trackcalc(is).YY;
tmpd = [cos(dth) sin(dth); -sin(dth) cos(dth)]*[x; y];
xnew = tmpd(1,:); 
ynew = tmpd(2,:);
[ppmc_trk] = interp2(plumes(is).Xg, plumes(is).Yg, plumes(is).PPM, xnew, ynew);

figure; set(gcf,'OuterPosition',[675 5 570 1049]);
subplot(4,1,1); scatter(sections(is).trackdata.XX(ikeep), sections(is).trackdata.YY(ikeep), 20, sections(is).lgrdata.data(iCH4,ikeep),'f'); colorbar

subplot(4,1,2); scatter(trackcalc(is).XX(ikeep), trackcalc(is).YY(ikeep), 20, trackcalc(is).PPM(ikeep),'f'); colorbar
subplot(4,1,3); scatter(trackcalc(is).XX(ikeep), trackcalc(is).YY(ikeep), 20, ppmc_trk(ikeep),'f'); colorbar
legend(num2str(nearest(dth/pi*180)))
subplot(4,1,4); plot(sections(is).lgrdata.data(iCH4,ikeep), ppmc_trk(ikeep),'.');
cc = corrcoef(sections(is).lgrdata.data(iCH4,ikeep), ppmc_trk(ikeep));
legend(num2str(cc(1,2)));

pause
end
%}

dofigs = false;

% Test 2 - rotate until minimum is found
addpath /home/imbiriba/matlab/Scr/Math

iCH4d=7;

ang = [-180:180]/180*pi; val=NaN(size(ang));
for is=[2 5 7 8 11 12 14 15 16 21 22];
  ikeep = keep_only_road_area(trackcalc(is).XX, trackcalc(is).YY);
  obs = sections(is).lgrdata.data(iCH4d,ikeep);
  for iang=1:numel(ang)
    x = trackcalc(is).XX;
    y = trackcalc(is).YY;
    tmpd = [cos(ang(iang)) sin(ang(iang)); -sin(ang(iang)) cos(ang(iang))]*[x; y];
    xnew = tmpd(1,:); 
    ynew = tmpd(2,:);
    [ppmc_trk] = interp2(plumes(is).Xg, plumes(is).Yg, plumes(is).PPM, xnew, ynew);
    calc = ppmc_trk(ikeep);
%    val(iang) = sqrt(sum((obs./max(obs)-calc./max(calc)).^2));
    cc = corrcoef(obs,calc);
    val(iang) = cc(1,2);
  end
  [minval,ibestang(is)] = max(val);
  dth = ang(ibestang(is));


  % Rotate
  x = trackcalc(is).XX;
  y = trackcalc(is).YY;
  tmpd = [cos(dth) sin(dth); -sin(dth) cos(dth)]*[x; y];
  xnew = tmpd(1,:); 
  ynew = tmpd(2,:);
  [ppmc_trk] = interp2(plumes(is).Xg, plumes(is).Yg, plumes(is).PPM, xnew, ynew);
  trackcalc(is).PPMnew = ppmc_trk;
  trackcalc(is).anglefix = dth;
  trackcalc(is).ikeep = ikeep;

  ch4b = quantile(sections(is).lgrdata(1).data(iCH4d,:),.1);
  %xch4 = sections(is).lgrdata(1).data(iCH4d,:)-ch4b;

  cc = corrcoef(sections(is).lgrdata.data(iCH4d,ikeep)-ch4b, ppmc_trk(ikeep));
  ccprev = corrcoef(sections(is).lgrdata.data(iCH4d,ikeep)-ch4b, trackcalc(is).PPM(ikeep)); 

  trackcalc(is).ccprev = ccprev(1,2);
  trackcalc(is).ccnew = cc(1,2);

if(dofigs)
  figure; hold on; plot(ang/pi*180,val); plot(ang(ibestang(is))/pi*180,minval,'o'); title(num2str(is));

  figure; set(gcf,'OuterPosition',[675 5 570 1049]);
  subplot(4,1,1); scatter(sections(is).trackdata.XX(ikeep), sections(is).trackdata.YY(ikeep), 20, sections(is).lgrdata.data(iCH4d,ikeep)-ch4b,'f'); colorbar; set(gca,'DataAspectRatio',[1 1 1]);axis([-4000 2000 -2000 4000]); grid;
  subplot(4,1,2); scatter(trackcalc(is).XX(ikeep), trackcalc(is).YY(ikeep), 20, trackcalc(is).PPM(ikeep),'f'); colorbar; 
  hold on;  plot_vector_wind(sections, is); set(gca,'DataAspectRatio',[1 1 1]); axis([-4000 2000 -2000 4000]); grid;
  subplot(4,1,3); scatter(trackcalc(is).XX(ikeep), trackcalc(is).YY(ikeep), 20, ppmc_trk(ikeep),'f'); colorbar
  legend(num2str(nearest(dth/pi*180))); set(gca,'DataAspectRatio',[1 1 1]); axis([-4000 2000 -2000 4000]); grid;
  subplot(4,1,4); 
  hold on
  plot(sections(is).lgrdata.data(iCH4d,ikeep)-ch4b, trackcalc(is).PPM(ikeep),'r.');
  plot(sections(is).lgrdata.data(iCH4d,ikeep)-ch4b, ppmc_trk(ikeep),'.');
  legend(num2str(ccprev(1,2)), num2str(cc(1,2))); 
  title([datestr(plumes(is).mtime) ' ' num2str(is)]);
  pause;
end

end

