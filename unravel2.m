function stro = unravel2(dat)
% function stro = unravel2(dat)
%
% From a downloaded XML NOAA station data, convert it to a STRUCTURE.
% This routine wast REMADE because something changed on xml2struct! Maybe MATLAB versions?
%
% Example: 
% !noaa_xml_get.sh
% dat = xml2struct('noaa_sbbe_72.xml');
% str = unravel(dat);
%
% str.ob(:).time
% str.ob(:).variable(:).value
% str.ob(:).variable(:).description
%
% B.I. 2019.08.01


for ii=1:numel(dat.station.ob)
  if(numel(dat.station.ob)>1)
    stro.ob(ii).time = dat.station.ob{ii}.Attributes.time;
    for jj=1:numel(dat.station.ob{ii}.variable)
      stro.ob(ii).variable(jj).description = dat.station.ob{ii}.variable{jj}.Attributes.description;
      stro.ob(ii).variable(jj).value = dat.station.ob{ii}.variable{jj}.Attributes.value;
      stro.ob(ii).variable(jj).unit = dat.station.ob{ii}.variable{jj}.Attributes.unit;
      stro.ob(ii).variable(jj).var = dat.station.ob{ii}.variable{jj}.Attributes.var;
    end
  else
    stro.ob(ii).time = dat.station.ob.Attributes.time;
    for jj=1:numel(dat.station.ob.variable)
      stro.ob(ii).variable(jj).description = dat.station.ob.variable{jj}.Attributes.description;
      stro.ob(ii).variable(jj).value = dat.station.ob.variable{jj}.Attributes.value;
      stro.ob(ii).variable(jj).unit = dat.station.ob.variable{jj}.Attributes.unit;
      stro.ob(ii).variable(jj).var = dat.station.ob.variable{jj}.Attributes.var;
    end
  end
end

end
