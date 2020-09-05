function trackdata = get_track_data(trackdatafiles, TZ)
% function trackdata = get_track_data(trackdatafiles, TZ)
% 
% Read GeoTracker data files.  (from the cellphone app)
%
% Output:		  - One cell for each track file
%     trackdata.mtime{:}  - Time in provided TZ timezone.
%     trackdata.lat{:}    - lat/lon/alt: 'gx:coord' field.
%     trackdata.lon{:}    - All from kml-like file generated
%     trackdata.alt{:}      from geotracker kml output.
%
% B.I. 2019.10.xx
  
  if(nargin()==0)
  trackdatafiles = {...
    'data/2_de_ago_de_2019_5_01_40_PM',
    'data/2_de_ago_de_2019_7_19_38_PM',
    'data/6_de_ago_de_2019_9_58_26_AM', 
    'data/6_de_ago_de_2019_11_45_48_AM', 
    'data/6_de_ago_de_2019_2_59_54_PM',
    'data/7_de_ago_de_2019_9_29_58_PM',
    'data/8_de_ago_de_2019_1_02_57_AM',
    'data/19_de_nov_de_2019_11_14_43_PM'};
  TZ = -3.0;
  end

  say('Loading geotrack data files')
  [mtg lat lon alt] = geotrackread(trackdatafiles);

%  % Fill track data gaps:
%  % When not moving, GPS seems to stop.
%  % Look for time gaps with almos not geographical gaps, and fill the time blaks.
%  igaps = find(diff((mtg-mtg(1))*86400)>2); % more than 2s
%  for ig=1:numel(igaps)
%    dlat = lat(igaps(ig)+1)-lat(igaps(ig));
%    dlon = lon(igaps(ig)+1)-lon(igaps(ig));
%    deg1m = 8.93e-6;
%    if(abs(dlat)<10*deg1m & abs(dlon)<10*deg1m)
%


  trackdata.mtime = mtg+TZ./24;;
  trackdata.lat = lat;
  trackdata.lon = lon;
  trackdata.alt = alt;
end

