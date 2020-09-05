function [mtime lat lon alt] = geotrackread(cname)
% function [mtime lat lon alt] = geotrackread(fname);
%
% Read lat/lon/time information from geotrack KML generated file.
% 
% Breno Imbiriba - 2019.08.01

  if(~iscell(cname))
    cname = {cname};
  end

  nf=numel(cname);
  for ii=1:nf
    [mti{ii}, lati{ii}, loni{ii}, alti{ii}] = geotrackread_core(cname{ii});
  end

  mtime = [mti{:}];
  lat = [lati{:}];
  lon = [loni{:}];
  alt = [alti{:}];

end

function [mtime lat lon alt] = geotrackread_core(fname);
% function [mtime lat lon alt] = geotrackread(fname);
%
% Read lat/lon/time information from geotrack KML generated file.
% 
% Breno Imbiriba - 2019.08.01
disp(['Reading GeoTrack data file ', fname]);

sdata=xml2struct(fname);

ntracks = numel(sdata.kml.Document.Placemark.gx_colon_MultiTrack.gx_colon_Track);
for itrack=1:ntracks
  if(ntracks>1)
    disp(['Reading track ', num2str(itrack)]);
    npts = numel(sdata.kml.Document.Placemark.gx_colon_MultiTrack.gx_colon_Track{itrack}.gx_colon_coord);
  else
    npts = numel(sdata.kml.Document.Placemark.gx_colon_MultiTrack.gx_colon_Track.gx_colon_coord);
  end


  for ii=1:npts
    if(ntracks>1)
      idat = sscanf(sdata.kml.Document.Placemark.gx_colon_MultiTrack.gx_colon_Track{itrack}.gx_colon_coord{ii}.Text,'%f %f %f');
    else
      idat = sscanf(sdata.kml.Document.Placemark.gx_colon_MultiTrack.gx_colon_Track.gx_colon_coord{ii}.Text,'%f %f %f');
    end
    lon{itrack}(ii) = idat(1);
    lat{itrack}(ii) = idat(2);
    alt{itrack}(ii) = idat(3);
  end

  for ii=1:npts
    if(ntracks>1)
      idat = datenum(sdata.kml.Document.Placemark.gx_colon_MultiTrack.gx_colon_Track{itrack}.when{ii}.Text,'yyyy-mm-ddTHH:MM:SS.FFFZ');
    else
      idat = datenum(sdata.kml.Document.Placemark.gx_colon_MultiTrack.gx_colon_Track.when{ii}.Text,'yyyy-mm-ddTHH:MM:SS.FFFZ');
    end
    mtime{itrack}(ii) = idat;
  end

end

% Merge cells
lon = cat(2,lon{:});
lat = cat(2,lat{:});
alt = cat(2,alt{:});
mtime = cat(2,mtime{:});

end

