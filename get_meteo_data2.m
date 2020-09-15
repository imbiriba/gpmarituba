function str = get_meteo_data2(mtime, source)
% function meteodata = get_meteo_data2(mtime, source)
%
% Load meteological data from GEAs local repository.
%
% source - 'inmet-belem','vale-ufpa','sbbe'
% mtime - vector with hours of data to grab
% 
% Breno Imbiriba - 2019.12.17


sdir = ['/gea/data/towers/',source];

switch source
  case 'inmet-belem'
    rname = 'belem';
    varn = { 'mtime', 'temp', 'tmax', 'tmin', 'wspeed', 'wmax', 'wdir', 'relh', 'hmax', 'hmin', 'prec', 'rad'};
    original_fields = {'codigo_estacao','data','hora','temp_inst','temp_max','temp_min','umid_inst','umid_max','umid_min','pto_orvalho_inst','pto_orvalho_max','pto_orvalho_min','pressao','pressao_max','pressao_min','vento_vel','vento_direcao','vento_rajada','radiacao','precipitacao'};
    order = { [2 3], 4, 5, 6, 16, 18, 17, 7,8,9,20,19};
    % for ii=1:12; disp([varn{ii} original_fields{order{ii}}]); end

  case 'vale-ufpa'
    rname = 'belem_itv';
    varn = {'mtime','temp','tmax','tmin','wspeed','wmax','wdir','wdirsd','relh','prec','rad','press'};
  case 'sbbe'
    error('Not coded yet for SBBE'); 
  otherwise
    error(['Not coded to handle source ' source]);
end


% Find which months of data to look for
dvec = datevec(mtime);
ymvec = dvec(:,1:2);
uvec = unique(ymvec,'rows');
nvec = size(uvec,1);

disp(['Will load ' num2str(nvec) ' months.']);

% look over days
dat1 = [];
ik=0;
for iv=1:nvec
  sy = num2str(uvec(iv,1),'%04d');
  sm = num2str(uvec(iv,2),'%02d');

  fname = fullfile(sdir, [rname '_' sy '_' sm '.csv']);
  disp(fname)
  % final list counter
  ik=0; list=[];
  if(exist(fname))
    if(strcmp(source,'inmet-belem'))
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
      dat = csvread(fname);
    end 
    % Select hours of interest
    if(strcmp(source,'inmet-belem'))
      datatime = str.mtime;
    else
      datatime = datenum(dat(:,1:6));
    end
    for ih=1:numel(mtime)
      % find data points close (less or equal than one hour) to the requested time
      [dt iok] = min(abs(mtime(ih)-datatime));
      if(dt>1/24) 
%	disp(['Cannot find meteorological data for the hour ' datestr(mtime(ih)) '. Closest is ' num2str(dt*24) ' hours away.']);
	continue;
      end
      ik=ik+1;
      list(ik) = iok;
    end
  else
    disp(['File ' fname ' not found.']);
  end

  if(numel(dat1)==0)
    dat1 = dat(list,:);
  else
    dat1 = cat(1,dat1, dat(list,:));
  end

end

if(strcmp(source,'vale-ufpa'))
  str.mtime = datenum(dat1(:,1:6));
  for ii=2:numel(varn)
    str.(varn{ii}) = dat1(:,ii+5);
  end
end


end
