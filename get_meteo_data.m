function meteodata = get_meteo_data(meteodatafiles,TZ)
% function meteodata = get_meteo_data(meteodatafiles,TZ)
%
% Read NOAA Meteorologica data (from airport stations).
% TZ = time zone in hours from GMT
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
    TZ=-3.0;
  end

  meteodata = struct( 'mtime',[], 'duration',[], 'temp',[], 'wdir',[], 'wspd',[], 'okta',[], 'cldh',[], 'sunset',[]);

  hour = @(x) nearest((x-floor(x)).*24.0);
  for in=1:numel(meteodatafiles)
    [data val] = noaa_xml(meteodatafiles{in});

    % variables are: time, temp, wdir, wspd, okta, sunset
    npt = numel(data.utime); 
    meteodata.mtime(end+1:end+npt)   = data.utime+TZ./24.0;
    meteodata.duration(end+1:end+npt)= 3600*ones(size(data.utime)); % In seconds
    meteodata.temp(end+1:end+npt)    = data.temp;
    meteodata.wdir(end+1:end+npt)    = data.wdir;
    meteodata.wspd(end+1:end+npt)    = data.wspd;
    meteodata.okta(end+1:end+npt)    = data.okta;
    meteodata.cldh(end+1:end+npt)    = data.cldh;
    hh = hour(data.utime+TZ./24.0); 
    meteodata.sunset(end+1:end+npt)  = (hh==17 | hh==18);
  end

  meteodata.TZ = TZ;
end

