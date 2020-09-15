function str = get_inmet_data(mtime,TZ)
% function meteodata = get_inmet_data(mtime,TZ)
%
% Load INMET meteological data from GEAs local repository
% and return data at provided times at timezone TZ.
%
% mtime - vector with hours of data to grab.
% TZ    - timezone offset (in hours) of provided mtime vector.
% 
% Note: INMET Time is UTC. 
%
% Breno Imbiriba - 2019.12.17
%                  2020.09.05


sdir = ['/gea/data/towers/inmet-belem'];

rname = 'belem';
varn = { 'mtime', 'temp', 'tmax', 'tmin', 'wspeed', 'wmax', 'wdir', 'relh', 'hmax', 'hmin', 'prec', 'rad'};
original_fields = {'codigo_estacao','data','hora','temp_inst','temp_max','temp_min','umid_inst','umid_max','umid_min','pto_orvalho_inst','pto_orvalho_max','pto_orvalho_min','pressao','pressao_max','pressao_min','vento_vel','vento_direcao','vento_rajada','radiacao','precipitacao'};
order = { [2 3], 4, 5, 6, 16, 18, 17, 7,8,9,20,19};
% for ii=1:12; disp([varn{ii} original_fields{order{ii}}]); end

% Convert mtime to UTC
utime = mtime-TZ./24.0;

% Find which months of data to look for
dvec = datevec(utime);
ymvec = dvec(:,1:2);
uvec = unique(ymvec,'rows');
nvec = size(uvec,1);

disp(['Will load ' num2str(nvec) ' months.']);

% look over days
dat1 = [];
ik=0; list=[];
for iv=1:nvec
  sy = num2str(uvec(iv,1),'%04d');
  sm = num2str(uvec(iv,2),'%02d');
  fname = fullfile(sdir, [rname '_' sy '_' sm '.csv']);
  disp(fname)
%  ik=0; list=[];
  if(exist(fname))
    % Datafiles won't work with CSVREAD because they contain
    % a mix of datatypes. Use my read_csv.m command.
    %
    addpath /home/imbiriba/matlab/Scr/IO/ 
    dat = read_csv(fname);
    for jj=2:numel(dat)
      ik=ik+1;
      for ii=1:numel(order) 
	if(numel(order{ii})==2)
	  tmp = dat{jj}{order{ii}(1)} + dat{jj}{order{ii}(2)}./24;
	else
	  tmp = dat{jj}{order{ii}};
	end
	str.(varn{ii})(ik,1) = tmp;
      end
    end
    continue 
  else
    disp(['File ' fname ' not found.']);
  end
end


% Select hours of interest
datatime = str.mtime;

ik=0;
list=[];
% find data points close (less or equal than one hour) to the requested time
for ih=1:numel(utime)
  [dt iok] = min(abs(utime(ih)-str.mtime));
  if(dt>1/24) 
%	disp(['Cannot find meteorological data for the hour ' datestr(mtime(ih)) '. Closest is ' num2str(dt*24) ' hours away.']);
    continue;
  end
  ik=ik+1;
  list(ik) = iok;
end

% subset structure - and flip
fn=fieldnames(str);
for ifn=1:numel(fn)
  nn = numel(list);
  strt.(fn{ifn}) = reshape(str.(fn{ifn})(list),[1,nn]);
end

str = strt;
% Convert inmet mtime to local time zone
str.mtime = str.mtime+TZ./24.0;

end
