log = csvread("logAC1.90s.velProg.csv");
logcte = csvread("logAC1.90s.velCte.csv");
%Filtramos datos específicos de la aeronave 1

% log:  log de la simulación
    % 1       2     3   4           5           6          7       8
    % TIME    ID    S   posX        posY        posZ       psi     Vhor
    % 00001 , 001 , 1 , +31941.69 , +57969.59 , +2133.60 , -1.85 , 123.47

% WP_gmsf = [ 037 03 19.4630   -004 56 23.1343   7000   ;  % 3 MARTIN
%             036 56 23.4620   -004 50 47.4385   5000   ;  % 4 MG 403
%             036 53 52.1875   -004 48 45.4100   5000   ]  % 5 MG 402   IF    
% numWP = size(WP_gmsf,1);         
% WP_gf = zeros(numWP,3);
% WP    = zeros(numWP,3);
% runway_lat =   36.6845346944444;                 % latitud 
% runway_lon =  -4.51259438888889;                 % longitud 
% for i = 1:numWP
%     WP_gf(i,1) = gms2g(WP_gmsf(i,1:3));
%     WP_gf(i,2) = gms2g(WP_gmsf(i,4:6));
%     WP_gf(i,3) = convlength(WP_gmsf(i,7), 'ft', 'm');
%     XYZ = lla2flat(WP_gf(i,:),[runway_lat runway_lon],0,0);
%     WP(i,1) =  XYZ(2);
%     WP(i,2) =  XYZ(1);
%     WP(i,3) = -XYZ(3);
% end

log  = log(log(:,2)==1,:);
logR = log(log(:,3)==6,:); % Avion real
logD = log(log(:,3)~=6,:); % Avion Dubins
if length(logR) > length(logD)
    l = length(logD);
else
    l = length(logR);
end

vector_xR = logR(1:l,4);
vector_xD = logD(1:l,4);
vector_yR = logR(1:l,5);
vector_yD = logD(1:l,5);

logcte  = logcte(logcte(:,2)==1,:);
logRcte = logcte(logcte(:,3)==6,:); % Avion real
logDcte = logcte(logcte(:,3)~=6,:); % Avion Dubins
if length(logRcte) > length(logDcte)
    l = length(logDcte);
else
    l = length(logRcte);
end

vector_xRcte = logRcte(1:l,4);
vector_xDcte = logDcte(1:l,4);
vector_yRcte = logRcte(1:l,5);
vector_yDcte = logDcte(1:l,5);

figHandler = findobj('Type','figure','Name','Posición horizontal')';
if isempty(figHandler)
    figure( ...
        'Name','Posición horizontal', ...
        'NumberTitle','off',   ...
        'Position',[400 00 500 500]); 
else
    figure(figHandler)
    clf
end
% tl = tiledlayout(1,2);
% tl.Padding = 'none';
% tl.TileSpacing = 'none';

% ax1 = nexttile;
hold on
grid on
plot(vector_xDcte,vector_yDcte,'linewidth',0.5)
plot(vector_xD,vector_yD,'linewidth',0.5)
plot(WP(:,1),WP(:,2),'o')
%axis([-4 -3 3.5 4.5]*10000)
legend({'cte','prog'})
title('curva dubins')

% ax2 = nexttile;
% hold on
% grid on
% plot(vector_xRcte,vector_yRcte,'linewidth',1)
% plot(vector_xDcte,vector_yDcte,'linewidth',1)
% plot(WP(:,1),WP(:,2),'o')
% axis([-4 -3 3.5 4.5]*10000)
% legend({'Real','Dubins'})
% title('Velocidad cte')
% 
% function g = gms2g(gms)
%     s = sign(gms(1));
%     g = gms(1) + s*gms(2)/60 + s*gms(3)/3600;
% end