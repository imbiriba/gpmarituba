% compute lat/lon
    clat = -1.397379;
    clon = -48.337583;
    deg1m = 8.93e-6;
    lon2x = @(LON) (LON-clon)./deg1m;
    lat2y = @(LAT) (LAT-clat)./deg1m;


