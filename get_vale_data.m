function str = get_vale_data(mtime)
% function meteodata = get_vale_data(mtime)
%
% Load ITV-VALE meteological data from GEAs local repository.
%
% mtime - vector with hours of data to grab. These are in local time: TZ = -3.0;
% 
% Breno Imbiriba - 2019.12.17
%                  2020.09.05


sdir = ['/gea/data/towers/vale-ufpa'];

  rname = 'belem_itv';
  varn = {'mtime','temp','tmax','tmin','wspeed','wmax','wdir','wdirsd','relh','prec','rad','press'};


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
    dat = csvread(fname);

    datatime = datenum(dat(:,1:6));

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

str.mtime = datenum(dat1(:,1:6))';
for ii=2:numel(varn)
  str.(varn{ii}) = dat1(:,ii+5)';
end

% intersect with mtime to return the same order
[tt, ia, ib] = intersect(str.mtime, mtime);

for ii=1:numel(varn)
  strt.(varn{ii})(:,ib) = str.(varn{ii})(:,ia); 
end
str = strt;


end
