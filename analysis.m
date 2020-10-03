
if(~exist('analysisdata.mat','file'))
  lgrdata = get_lgr_data();
  trackdata = get_track_data();
  meteodata.sbbe = get_meteo_data();
  meteodata.inmet = get_inmet_data(meteodata.sbbe.mtime,-3);
  meteodata.itv = get_vale_data(meteodata.sbbe.mtime);
  save('analysisdata.mat','lgrdata','trackdata','meteodata');
elseif(~exist('lgrdata') | ~exist('meteodata')|~exist('trackdata'))
  load('analysisdata.mat');
end

%figure; hold on
%plot(hour(meteodata.inmet.mtime),meteodata.inmet.rad/3.6,'.-')
%plot(hour(meteodata.itv.mtime),meteodata.itv.rad,'.-')
%plot(hour(meteodata.sbbe.mtime),meteodata.sbbe.sunset*1000,'.-')

%figure; hold on
%plot(meteodata.sbbe.mtime, meteodata.sbbe.mtime,'o')
%plot(lgrdata.mtime, lgrdata.mtime,'s')
%plot(meteodata.inmet.mtime,meteodata.inmet.mtime,'.')         
%plot(meteodata.itv.mtime,meteodata.itv.mtime,'x')         


if(~exist('sections.mat','file'))
  sections = make_time_overlap2(lgrdata, trackdata, meteodata.sbbe);
  for is=1:numel(sections)
    % Need to rename sections(:).meteodata to sections(:).sbbe;
    sections(is).sbbe = sections(is).meteodata;
    mtime = sections(is).sbbe.mtime;
    iinmet = find(meteodata.inmet.mtime==mtime);
    iitv = find(meteodata.itv.mtime==mtime);
    fni = fieldnames(meteodata.inmet);
    for ii=1:numel(fni)
      sections(is).inmet.(fni{ii}) = meteodata.inmet.(fni{ii})(:,iinmet);
    end
    fni = fieldnames(meteodata.itv);
    for ii=1:numel(fni)
      sections(is).itv.(fni{ii}) = meteodata.itv.(fni{ii})(:,iitv);
    end
  end
  % Remove meteodata field.
  sections = rmfield(sections,'meteodata');
  save('sections.mat','sections');
elseif(~exist('sections'))
  load('sections.mat')
end



if(~exist('plumes.mat','file'))
  ik=0; % Put sources in between grid points !!*******
  for sx = [-100+25:50:100+25]
    for sy = [-100+25:50:100+25]
      ik=ik+1;
      source.X(ik) = sx;
      source.Y(ik) = sy;
    end
  end
  source.Q = ones(1,ik)*380/ik;
  source.H = 20*ones(1,ik);
  say(['Created ' num2str(ik) ' point sources 50m appart']);

  % Keep only what seems to be usable cases
  addpath /home/imbiriba/matlab/gplume

  goodlist = [2 5 7 8 11 12 14 15 16 21];
  for is=1:numel(sections)
    plumes(is) = compute_plume(sections(is),is,source);
  end
  for is=1:numel(sections)
    % convert simulated micrograms to ppmv and add time
    plumes(is).PPM = plumes(is).DT.*1400;
    plumes(is).mtime = sections(is).sbbe.mtime;
    plumes(is).source = source;
  end
  save('plumes.mat','plumes');
elseif(~exist('plumes'))
  load('plumes.mat');
end


% Analysis
% 1. Compute data on tracks
% Interpolate plume data into observation points
%
for is=1:numel(sections)
  [ppmc_trk] = interp2(plumes(is).Xg, plumes(is).Yg, plumes(is).PPM, sections(is).trackdata.XX, sections(is).trackdata.YY);
  trackcalc(is).YY = sections(is).trackdata.YY;
  trackcalc(is).XX = sections(is).trackdata.XX;
  trackcalc(is).PPM = ppmc_trk;
end

% 2. Attempt to adjust wind angle based on bias minimization

if(~exist('trackcalc_adj.mat'))
  angle_adjust;
  save('trackcalc_adj.mat','trackcalc');
else
  load('trackcalc_adj.mat');
end

return
make_plots(sections,plumes,trackcalc)




