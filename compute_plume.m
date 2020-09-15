function plume = compute_plume(section,is,source)
% function plume = compute_plume(section,is,source)
% 
% Perform Velkatram plume calculation using ITV's meteorological data set.
%
% B.I. Jun.2019

    % Use the same routine as used in the main code: run_plume.m
    [~,~,~,hour,~,~] = datevec(section.itv.mtime);
    % Add insolation here, first use raw estiamte, then check with inmet.
    switch hour
      case [7,8,9]
        insol = 200;
      case [10,11,12]
        insol = 800;
      case [13,14,15,16]
        insol = 800;
      case [17,18]
        insol = 200;
      otherwise
        insol = 0;
    end

    rad = section.inmet.rad/3.6;
    if(rad>insol)
     insol = rad;
    end
    %section.sbbe.insol = insol;

    data = struct();
    data.datafile = ['plumedata_' num2str(is) '.txt'];
    datavar = [section.itv.wdir section.itv.wspeed ...
               insol NaN ...
               section.sbbe.okta./8.0 section.sbbe.sunset ...
               section.itv.wdirsd ]
    save(data.datafile,'datavar','-ascii');

    data.ptype = 2; %velkatram 
    data.velkumin = 2.0;

    data.wind = 4; %file
    data.stability_used = 3; %file
    data.stab_param = 3;  % Briggs Urban

    data.stack_x = source.X;
    data.stack_y = source.Y;
    data.stacks = numel(source.X);
    data.mass = source.Q; %380/data.stacks*ones(data.stacks,1);
    data.height = source.H; %20*ones(data.stacks,1);
    data.xlim = 10000;
    data.dxy = 50;
    data.stab1 = NaN;
    data.ctype = 1; % Plane view
    data.output = 0; % no plot
    if(is==2)
      data.observation_height = 6;
    else
      data.observation_height = 2;
    end
    say(['Running plume ' num2str(is) ' with data: ' num2str([data.stacks, data.height(1), data.observation_height]) ' ' num2str(numel(source.Q)) ' sources and ' num2str(numel(section.itv.wdir)) ' wind directions.']);

    [DT, XX, YY, ZZ] = gaussian_plume_model_fun(data);

    plume.XX = [-data.xlim:data.dxy:data.xlim];
    plume.YY = [-data.xlim:data.dxy:data.xlim];
    plume.ZZ = data.observation_height;
    plume.Xg = XX;
    plume.Yg = YY;
    plume.Zg = ZZ;
    plume.DT = DT;

end
