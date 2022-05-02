maxLat = max(WP_gf(:,1));
minLat = min(WP_gf(:,1));
maxLon = max(WP_gf(:,2));
minLon = min(WP_gf(:,2));

points = readtable("config_LEMG_MAC611C.xlsx",'Sheet','Points');
points = points( ...
    points.Latitude<maxLat ...
    & points.Latitude>minLat ...
    & points.Longitude<maxLon ...
    & points.Longitude>minLon,:);
disp(points);
disp(WP_gf);