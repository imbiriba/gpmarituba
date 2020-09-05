function meteodata = get_meteo_data(meteodatafiles)
% function meteodata = get_meteo_data(meteodatafiles)
%
% Read NOAA Meteorologica data (from airport stations).
%
% Output:
%     meteodata.mtime 		- time is local time by default
%     meteodata.duration        - Time width of validity (1hr)
%     meteodata.temp            - Temperature (C)
%     meteodata.wdir            - Wind direction (deg from North)
%     meteodata.wspd            - wind speed (m/s)
%     meteodata.okta            - Estimate of Okta from cloud description
%     meteodata.sunset          - Flag for 1hr after of before 6pm.
%
 
  if(~exist('meteodatafiles')) 
    meteodatafiles = {'data/NOAA_SBBE_19nov19.xml','data/NOAA_SBBE_30jul19_19aug19.xml'};
  end

  meteodata = struct( 'mtime',[], 'duration',[], 'temp',[], 'wdir',[], 'wspd',[], 'okta',[], 'cldh',[], 'sunset',[]);

  for in=1:numel(meteodatafiles)
    [data val] = noaa_xml(meteodatafiles{in});

    % variables are: time, temp, wdir, wspd, okta, sunset
    npt = numel(data.time); 
    meteodata.mtime(end+1:end+npt)   = data.time;
    meteodata.duration(end+1:end+npt)= 3600*ones(size(data.time)); % In seconds
    meteodata.temp(end+1:end+npt)    = data.temp;
    meteodata.wdir(end+1:end+npt)    = data.wdir;
    meteodata.wspd(end+1:end+npt)    = data.wspd;
    meteodata.okta(end+1:end+npt)    = data.okta;
    meteodata.cldh(end+1:end+npt)    = data.cldh;
    meteodata.sunset(end+1:end+npt)  = data.sunset;
  end
end

