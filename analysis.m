
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

%figure
%subplot(3,1,1)
%hold on
%for is=1:numel(sections)
%  plot(sections(is).sbbe.wdir, sections(is).itv.wdir,'.')
%end
%plot([22 34],[22 34]);
%plot([0 360],[0 360]);
%subplot(3,1,2)
%hold on
%for is=1:numel(sections)
%  plot(sections(is).sbbe.wdir, sections(is).inmet.wdir,'.')
%end
%plot([22 34],[22 34]);
%plot([0 360],[0 360]);
%subplot(3,1,3)
%hold on
%for is=1:numel(sections)
%  plot(sections(is).itv.wdir, sections(is).inmet.wdir,'.')
%end
%plot([22 34],[22 34]);
%plot([0 360],[0 360]);
%






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
  save('plumes.mat','plumes');
elseif(~exist('plumes'))
  load('plumes.mat');
end


for is=1:numel(plumes)
  % convert simulated micrograms to ppmv
  plumes(is).PPM = plumes(is).DT.*1400;
  plumes(is).mtime = sections(is).sbbe.mtime;
end


return
make_plots(sections,plumes)




