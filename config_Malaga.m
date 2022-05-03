%% Aeropuerto de Malaga

% Pista de aterrizaje
runway_lar = convlength(2,'naut mi','m');  % longitud de pista
runway_anc = 60;                           % ancho de pista
runway_lat =   36.6845346944444;                 % latitud 
runway_lon =  -4.51259438888889;                 % longitud 
runway_alt =   0;                          % altura 
runway_ori = 133;                          % orientacion
dcm = angle2dcm( deg2rad(runway_ori), 0, 0 );

global runway_pts
runway_pts(1,:) = dcm * [-runway_anc/2;        -50; runway_alt];
runway_pts(2,:) = dcm * [-runway_anc/2; runway_lar; runway_alt];
runway_pts(3,:) = dcm * [ runway_anc/2; runway_lar; runway_alt];
runway_pts(4,:) = dcm * [ runway_anc/2;        -50; runway_alt];


% Carta de navegación

%           latitud        |  longitud       | altura
%                          |                   (pies)
WP_gmsf = [ 037 12 26.0000   -004 09 14.0000   7000   ;  % 1 LOJAS    
            037 08 03.1780   -004 28 14.9829   7000   ;  % 2 TOLSU    IAF
            037 03 19.4630   -004 56 23.1343   7000   ;  % 3 MARTIN
            036 56 23.4620   -004 50 47.4385   5000   ;  % 4 MG 403
            036 53 52.1875   -004 48 45.4100   5000   ;  % 5 MG 402   IF
            036 48 49.9295   -004 41 39.0930   4200   ;  % 6 MG 401   FAP
            036 41 04.3249   -004 30 45.3398     52   ;  % 7 RWY 13   LTP
            036 40 00.0000   -004 29 19.8000     52   ;  % 8 RWY 13   FIN DE PISTA
            036 38 00.0000   -004 26 30.0000   2200   ;  % 9 miss approach
            036 36 52.0000   -004 06 01.0000   2200   ;  %10 XILVI
            036 33 52.0000   -004 01 01.0000   2200   ;  %11 XILVI2
            036 33 52.0000   -003 56 01.0000   2200   ;  %12 XILVI3
            036 36 52.0000   -003 56 01.0000   2200   ;  %13 XILVI4
            036 36 52.0000   -004 06 01.0000   2200   ;  %14 XILVI5
            036 33 52.0000   -004 06 01.0000   2200   ;  %15 XILVI6
            036 33 52.0000   -003 54 00.0000   2200 ] ;  %16 XILVI7


        
global WPlabels
WPlabels = [ "LOJAS"          % 1 LOJAS    
             "TOLSU (IAF)" ;  % 2 TOLSU    IAF
             "MARTIN"      ;  % 3 MARTIN
             "MG403"       ;  % 4 MG 403
             "MG402 (IF)"  ;  % 5 MG 402   IF
             "MG401 (FAP)" ;  % 6 MG 401   FAP
             "RWY13 (LTP)" ;  % 7 RWY 13   LTP
             "RWY13"       ;  % 8 RWY 13   FIN DE PISTA
             " "           ;  % 9 miss approach
             "XILVI"       ;  %10 XILVI
             " "           ;  %11 XILVI2
             " "           ;  %12 XILVI3
             " "           ;  %13 XILVI4
             " "           ;  %14 XILVI5
             " "           ;  %15 XILVI6
             " "         ] ;  %16 XILVI7
         
global WPnext        
WPnext  = [   2  ;  % 1 LOJAS    
              3  ;  % 2 TOLSU    IAF
              4  ;  % 3 MARTIN
              5  ;  % 4 MG 403
              6  ;  % 5 MG 402   IF
              7  ;  % 6 MG 401   FAP
              8  ;  % 7 RWY 13   LTP
              0  ;  % 8 RWY 13   FIN DE PISTA
             10  ;  % 9 miss app (maniobra frustrada)
             11  ;  %10 XILVI    (maniobra frustrada)
             12  ;  %11 XILVI    (maniobra frustrada)
             13  ;  %12 XILVI    (maniobra frustrada)
             14  ;  %13 XILVI    (maniobra frustrada)
             15  ;  %14 XILVI    (maniobra frustrada)
             16  ;  %15 XILVI    (maniobra frustrada)
              2 ];  %16 XILVI    (maniobra frustrada)

global WPspeed
WPspeed = [ 240  ;  % 1 LOJAS    
            240  ;  % 2 TOLSU    IAF
            240  ;  % 3 MARTIN
            240  ;  % 4 MG 403
            160  ;  % 5 MG 402   IF
            160  ;  % 6 MG 401   FAP
            140  ;  % 7 RWY 13   LTP
             50  ;  % 8 RWY 13   FIN DE PISTA
            220  ;  % 9 miss approach
            220  ;  %10 XILVI
            220  ;  %11 XILVI2
            220  ;  %12 XILVI3
            220  ;  %13 XILVI4
            220  ;  %14 XILVI5
            220  ;  %15 XILVI6
            220 ];  %16 XILVI7

global WPabort
WPabort = 9;        % waypoint al que dirigirse al frustrar el aterrizaje
        

numWP = size(WP_gmsf,1);         
WP_gf = zeros(numWP,3);
global WP
WP    = zeros(numWP,3);

for i = 1:numWP
    WP_gf(i,1) = gms2g(WP_gmsf(i,1:3));
    WP_gf(i,2) = gms2g(WP_gmsf(i,4:6));
    WP_gf(i,3) = convlength(WP_gmsf(i,7), 'ft', 'm');
    XYZ = lla2flat(WP_gf(i,:),[runway_lat runway_lon],0,0);
    WP(i,1) =  XYZ(2);
    WP(i,2) =  XYZ(1);
    WP(i,3) = -XYZ(3);
end

%% Carga los datos de los vuelos reales
maxLat = max(WP_gf(:,1)); % TODO: dejar un poco de margen luego
minLat = min(WP_gf(:,1));
maxLon = max(WP_gf(:,2));
minLon = min(WP_gf(:,2));

global pseudoWP
pseudoWP = load_data(".\data\LEMG.xlsx",[maxLat minLat maxLon minLon],[runway_lat runway_lon]);

%% Borra variables que ya no se van a usar
clear i XYZ
clear WP_gmsf numWP WP_gf
clear runway_lar runway_anc runway_alt runway_ori dcm runway_lat runway_lon


%% Información sobre el avión que aborta
% global AbortACid
% AbortACid = 0;
% global AbortTime
% AbortTime = 0;


%% Definiciones de funciones

function g = gms2g(gms)
    s = sign(gms(1));
    g = gms(1) + s*gms(2)/60 + s*gms(3)/3600;
end
