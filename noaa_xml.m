function [data val] = noaa_xml(station, nhours)
% function [data val] = noaa_xml(station, nhours)
%                               () - defalts
%                               (nhours) - default station
%                               (filename) - given filename
% 
% Download NOAA's XML data for station 'stations' for the last 'nhours'.
% Default are 
% 	station='SBBE' 	
% 	nhours = 1
% data - five variables needed to run "gaussian_plume_model_fun.m", except radiation.
% val  - all variables present in the TAF station report.
%
% B.I. - 2019.06.04
% B.I. - 2020.09.05 - using utime instead of time - this is UTC
%                     do not estimate sunset.

fname='';
if(nargin()==0)
  station = 'SBBE';
  nhours = '1';
end
if(nargin()==1)
  if(isnumeric(station))
    nhours = num2str(station);
    station = 'SBBE';
  elseif(ischar(station))
    fname = station;
  end
end
if(nargin()==2)
  nhours = num2str(nhours);
end

if(numel(fname)==0)
  disp(['Fetching ' station ' station data - ' nhours ' hours.']);
  system(['./noaa_xml_get.sh ' station ' ' nhours]);
  fname=['NOAA_' station '_' nhours '.xml'];
else
  disp(['Loading data file ' fname]);
end

dat = xml2struct(fname);
%str = unravel(dat); % for xml2struct.m in MATLAB repo
str = unravel2(dat); % for my own xml2struct.m



% Get all variables of interest:

variables = { 'Temp'    'Dewp'    'Relh'    'Direction'    'Wind Card'    'Wind'     'Visibility'    'Weather'    'Coded Weather'    'Clouds' 'SL Pres'    'Altimeter'    'Station Pressure'    'Station Quality'};

varname = { 'temp'    'dewp'    'relh'    'direction'    'windcard'    'wind'     'visibility'    'weather'    'codedweather'    'clouds' 'slpres'    'altimeter'    'stationpressure'    'stationquality'};



% Grab data
for ii=1:numel(str.ob)
  % get UTC from UTIME - unix time
  utc_utime = str2double(str.ob(ii).utime);
  val.utime(ii) = datenum(1970,1,1,0,0,utc_utime);

  disp(['UTC utime=' datestr(val.utime(ii)) '. Speed = ' num2str(str.ob(ii).variable(6).value) '. Angle = ' num2str(str.ob(ii).variable(4).value)]);
   
  thisvar = {str.ob(ii).variable.description};

  for jj=1:numel(variables)
    kk = find(strcmp(variables(jj), thisvar));
    if(numel(kk)==0)
      continue
    end
    val.(varname{jj}){ii} = str.ob(ii).variable(kk).value;
  end
end

%  Compute what's important
%  speed, direction, insolation, cloud, sunset hour.
% Keep only integer hours:
disp('Keeping only INTEGER hours');
hours = 24*(val.utime-floor(val.utime));
ikeep = find(round(100*hours)/100==round(hours));
data.utime = val.utime(ikeep)';
data.temp = str2num(char(val.temp{ikeep}));
data.temp = (data.temp-32)*5/9;
data.wdir = str2num(char(val.direction{ikeep}));
data.wspd = str2num(char(val.wind{ikeep}));
data.wspd = data.wspd*1.6/3.6;
[data.okta, data.cldh] = taf_metar2okta(val.clouds(ikeep));
%hour = (val.utime(ikeep) - floor(val.utime(ikeep)))*24;
%data.sunset = (hour==7 | hour == 5)';

end
