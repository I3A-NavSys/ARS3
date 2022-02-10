%% CARGA DE DATOS
clear; clc;

mon    = MONITORclass("logAC.csv");
monCte = MONITORclass("logAC1.90s.velCte.csv");
[posX,posY,posZ,psi,Vhor,Acel]             = mon.ACinfo(1,false);
[posXCte,posYCte,posZCte,psiCte,VhorCte,~] = monCte.ACinfo(1,false);
[dist,distXY,distZ]           = mon.dist2ref(1);
[distCte,distXYCte,distZCte]  = monCte.dist2ref(1);
[cdist,~,~,closestAC,~]       = mon.dist2ACs(1,30);
[cdistCte,~,~,closestACCte,~] = monCte.dist2ACs(1,30);

for i=1:monCte.lastTime-1
    AcelCte(i) = VhorCte(i+1)-VhorCte(i);
end
AcelCte(monCte.lastTime) = AcelCte(monCte.lastTime-1);
% for i=1:mon.lastTime-1
%     Aceld(i) = Vhord(i+1)-Vhord(i);
% end
% Aceld(mon.lastTime) = Aceld(mon.lastTime-1);

% Array de tiempos en que se cambia de WP
% VELOCIDAD PROGRESIVA
% logAC1.90s.velProg.csv
% waypoints = [236 550 684 737 913 1167 1281 1526 1579 1631 1637 1920];
% labels  = ["" "TOLSU (IAF)";"" "MARTIN"; "" "MG403"; "" "MG402 (IF)";"MG401" "(FAP)";...
%     "" "Missed approach";"" "WPi1"; "" "WPi2";"" "WPi3"; "" "WPi4";"MG401" "(FAP)";"" "RWY13 (LTP)"];
% logAC1.90s.velProg.csv Velocidad XILVI
waypoints = [236 550 684 737 913 1167 1260 1498 1549 1603 1648 1929];
labels  = ["" "TOLSU (IAF)";"" "MARTIN"; "" "MG403"; "" "MG402 (IF)";"MG401" "(FAP)";...
    "" "Missed approach";"" "WPi1"; "" "WPi2";"" "WPi3"; "" "WPi4";"MG401" "(FAP)";"" "RWY13 (LTP)"];
% logAC1.80s.velProg.csv
% waypoints = [236 550 684 737 913 1167 1283 1492 1548 1602 1852];
% labels  = ["" "TOLSU (IAF)";"" "MARTIN"; "" "MG403"; "" "MG402 (IF)";"MG401" "(FAP)";...
%     "" "Missed approach";"" "WPi1"; "" "WPi2";"" "WPi3"; "" "WPi4";"" "RWY13 (LTP)"];
% VELOCIDAD CONSTANTE
% logAC1.90s.velCte.csv
waypointsCte = [236 550 684 747 923 1209 1513 1553 1591 1651 1952];
labelsCte  = ["" "TOLSU (IAF)";"" "MARTIN"; "" "MG403"; "" "MG402 (IF)";"MG401" "(FAP)";...
    "Missed" "approach";"" "WPi1"; "" "WPi2";"" "WPi3"; "MG401" "(FAP)";"" "RWY13 (LTP)"];

% Creamos la figura
figHandler = findobj('Type','figure','Name','AC1')';
if isempty(figHandler)
    figure( ...
        'Name','AC1', ...
        'NumberTitle','off',   ...
        'Position',[1400 250 600 900]); 
else
    figure(figHandler)
    clf
end

tl = tiledlayout(6,1);
tl.Padding = 'none';
tl.TileSpacing = 'none';

%% GRAFICA DE ALTURA
ax1 = nexttile;

yyaxis right
ax1.YAxis(2).Color = 'black';
axis([800 2000  0 convlength(2500,'m','ft')])
ylabel('altitude (ft)') 

yyaxis left
ax1.YAxis(1).Color = 'black';
axis([800 2000  0 2500])
ylabel('altitude (m)')
hold on

plot(1:monCte.lastTime,posZCte,'-r','LineWidth',1)
plot(1:mon.lastTime,posZ, '-' ,'LineWidth',1)

plot(waypointsCte,posZCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,posZ(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')

legend({'Constant speed','Progressive speed'},'Location','northwest')
xticklabels(ax1,{})

%% GRAFICA DE RUMBO
ax2 = nexttile;

yyaxis right
ax2.YAxis(2).Color = 'black';
axis([800 2000  convang(-12,'rad','deg') convang(-2,'rad','deg')])
ylabel('heading (deg)') 

yyaxis left
ax2.YAxis(1).Color = 'black';
axis([800 2000  -12 -2])
ylabel('heading (rad)')
hold on

plot(1:monCte.lastTime,psiCte,'-r','LineWidth',1)
plot(1:mon.lastTime,psi, '-' ,'LineWidth',1)

plot(waypointsCte,psiCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,psi(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')

legend({'Constant speed','Progressive speed'},'Location','northeast')
xticklabels(ax2,{})

%% GRAFICA DE VELOCIDAD
ax3 = nexttile;

yyaxis right
ax3.YAxis(2).Color = 'black';
axis([800 2000  0 convvel(140,'m/s','kts')])
ylabel('forward speed (kt)') 

yyaxis left
ax3.YAxis(1).Color = 'black';
axis([800 2000  0 120])
ylabel('forward speed (m/s)')
hold on

plot(1:monCte.lastTime,VhorCte,'-r','LineWidth',1)
plot(1:mon.lastTime,Vhor, '-' ,'LineWidth',1)

plot(waypointsCte,VhorCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,Vhor(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')


legend({'Constant speed','Progressive speed'},'Location','southwest')
xticklabels(ax3,{})

%% GRAFICA DE ACELERACION
ax4 = nexttile;

yyaxis right
ax4.YAxis(2).Color = 'black';
axis([800 2000  -10/9.8 10/9.8])
ylabel('acceleration (G)')

yyaxis left
ax4.YAxis(1).Color = 'black';
axis([800 2000  -10 10])
ylabel('acceleration (m/s^{2})');

hold on

plot(1:monCte.lastTime,AcelCte,'-r','LineWidth',1)
plot(1:mon.lastTime,Acel, '-','Color','#0072BD' ,'LineWidth',1)

plot(waypointsCte,AcelCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,Acel(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')

 

legend({'Constant speed','Progressive speed'},'Location','northeast')
xticklabels(ax4,{})

%% GRAFICA DE DISTANCIA ENTRE AERONAVE REAL Y DUBINS
ax5 = nexttile;

yyaxis right
ax5.YAxis(2).Color = 'black';
axis([800 2000  0 0.161987])
ylabel('tracking error (NM)')

yyaxis left
ax5.YAxis(1).Color = 'black';
axis([800 2000  0 300])
ylabel('tracking error (m)')

hold on

plot(1:monCte.lastTime,distCte,'-r' ,'LineWidth',1)
disp("Area tracking error cte: ");
disp( trapz (1209:1591 , distCte(1209:1591)));
disp( trapz (1:1979 , distCte(1:1979)));
plot(1:mon.lastTime,dist,'-','Color','#0072BD' ,'LineWidth',1)
disp("Area tracking error prog: ");
disp(trapz (1167:1631 , dist(1167:1631)));
disp( trapz (1:1979 , dist(1:1979)));

plot(waypointsCte,distCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,dist(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')

legend({'Constant speed','Progressive speed'},'Location','northwest')
xticklabels(ax5,{})

%% GRAFICA DE DISTANCIA DE LA AERONAVE REAL 1 AL RESTO DE AERONAVES REALES
ax6 = nexttile;

yyaxis right
ax6.YAxis(2).Color = 'black';
axis([800 2000  convlength(4000,'m','naut mi') convlength(12000,'m','naut mi')])
ylabel('distance (NM)') 

xlabel('time (s)')
yyaxis left
ax6.YAxis(1).Color = 'black';
axis([800 2000  4000 12000])
ylabel('distance (m)')
hold on

plot(1:monCte.lastTime,cdistCte,'-r' ,'LineWidth',1)
plot(1:mon.lastTime,cdist,'-' ,'LineWidth',1)
plot([1 mon.lastTime],[5556 5556],'-.','LineWidth',1,'Color',[0.5 0.5 0.5]);

plot(waypointsCte,cdistCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,cdist(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')

legend({'Constant speed','Progressive speed','conflict distance'},'Location','northeast')



linkaxes([ax1 ax2 ax3 ax4 ax5 ax6],'x')