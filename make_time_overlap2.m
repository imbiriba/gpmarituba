function sections = make_time_overlap(lgrdata, trackdata, meteodata)
  % LGR data and Trackdata are at random time points (close by)
  % meteodata are in blocks os given duration

  % Loop over meteodata time blocks
  % Find LGR and Trackdata that fit in the block
  % Make the intersection

  isec = 0;
  sections = [];

  isin = @(x,a,b) (x>=a & x<=b);
  for it=1:numel(meteodata.mtime)
    blockkeep(it) = false;

    ilgr = find(isin(lgrdata.mtime,meteodata.mtime(it),meteodata.mtime(it)+meteodata.duration(it)/3600/24));
    if(numel(ilgr)==0)
      continue;
    end
    itrk = find(isin(trackdata.mtime,meteodata.mtime(it),meteodata.mtime(it)+meteodata.duration(it)/3600/24));
    if(numel(itrk)==0)
      continue
    end

    blockkeep(it) = true;
    disp(['Found block at ', datestr(meteodata.mtime(it))])

    % In each block, make intersection of data.
    t0=datenum(2019,7,1); 
%    [mtime ia jb] = intersect(floor(86400*(lgrdata.mtime(ilgr)-t0)), floor(86400*(trackdata.mtime(itrk)-t0)));

    % In each block, interpolate into LGR time points
    nmtime = interp1(trackdata.mtime(itrk), trackdata.mtime(itrk), lgrdata.mtime(ilgr));
    nlat = interp1(trackdata.mtime(itrk), trackdata.lat(itrk), lgrdata.mtime(ilgr));
    nlon = interp1(trackdata.mtime(itrk), trackdata.lon(itrk), lgrdata.mtime(ilgr));
    nalt = interp1(trackdata.mtime(itrk), trackdata.alt(itrk), lgrdata.mtime(ilgr));


    dt = diff(nmtime);

    % in case there's large data break, create new sections
    ibreaks = find(dt>1000);  
    if(numel(ibreaks)==0)
      istart = 1;
      iend = numel(nmtime);
    else
      disp(['Found ' num2str(numel(ibreaks)) ' data breaks']);
      istart = 0;
      iend = 0;
      for ib=1:numel(ibreaks)
	istart(ib) = iend(ib)+1;
	iend(ib) = ibreaks(ib);
      end
      istart(ib+1) = iend(ib)+1;
      iend(ib+1) = numel(nmtime);
    end

    % compute lat/lon
    clat = -1.397379;
    clon = -48.337583;
    deg1m = 8.93e-6;
    lon2x = @(LON) (LON-clon)./deg1m;
    lat2y = @(LAT) (LAT-clat)./deg1m;

    for is=1:numel(iend)
      isec=isec+1;
%      idx = itrk(jb(istart(is):iend(is)));
%      strk.mtime = trackdata.mtime(idx);
%      strk.lat   =   trackdata.lat(idx);
%      strk.lon   =   trackdata.lon(idx);
%      strk.alt   =   trackdata.alt(idx);
      idx = [istart(is):iend(is)];
      strk.mtime = nmtime(idx);
      strk.lat   =   nlat(idx);
      strk.lon   =   nlon(idx);
      strk.alt   =   nalt(idx);
      strk.XX = lon2x(strk.lon);
      strk.YY = lat2y(strk.lat);
      sections(isec).trackdata = strk;


      %idx = ilgr(ia(istart(is):iend(is)));
      idx = ilgr((istart(is):iend(is)));
      slgr.mtime = lgrdata.mtime(idx);
      slgr.data  = lgrdata.data(:,idx);
      sections(isec).lgrdata = slgr;
  
      smet.mtime = meteodata.mtime(it);
      smet.temp   = meteodata.temp(it);
      smet.wdir   = meteodata.wdir(it);
      smet.wspd   = meteodata.wspd(it);
      smet.okta   = meteodata.okta(it);
      smet.sunset = meteodata.sunset(it);
      sections(isec).meteodata = smet;
    end
  end
end

