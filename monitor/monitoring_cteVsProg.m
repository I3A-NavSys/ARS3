%% CARGA DE DATOS
clear; clc;

mon    = MONITORclass("logAC5.90s.velProg.csv");
monCte = MONITORclass("logAC5.90s.velCte.csv");
[posX,posY,posZ,psi,Vhor,Acel]             = mon.ACinfo(5,false);
[posXCte,posYCte,posZCte,psiCte,VhorCte,~] = monCte.ACinfo(5,false);
[dist,distXY,distZ]           = mon.dist2ref(5);
[distCte,distXYCte,distZCte]  = monCte.dist2ref(5);
[cdist,~,~,closestAC,~]       = mon.dist2ACs(5,30);
[cdistCte,~,~,closestACCte,~] = monCte.dist2ACs(5,30);

AcelCte = zeros(1,monCte.lastTime);
VverCte = zeros(1,monCte.lastTime);
for i=1:monCte.lastTime-1
    AcelCte(i) = VhorCte(i+1)-VhorCte(i);
    VverCte(i) = posZCte(i+1)-posZCte(i);
end
AcelCte(monCte.lastTime) = AcelCte(monCte.lastTime-1);
VverCte(monCte.lastTime) = VverCte(monCte.lastTime-1);

Vver = zeros(1,mon.lastTime);
for i=1:mon.lastTime-1
%     Aceld(i) = Vhord(i+1)-Vhord(i);
    Vver(i) = posZ(i+1)-posZ(i);
end
% Aceld(mon.lastTime) = Aceld(mon.lastTime-1);
Vver(mon.lastTime) = Vver(mon.lastTime-1);

%% Array de tiempos en que se cambia de WP
% VELOCIDAD PROGRESIVA logAC1.90s.velProg.csv
% waypoints = [236 550 684 735 910 1177 1223 1502 1555 1608 1634 1915];
% VELOCIDAD CONSTANTE logAC1.90s.velCte.csv
% waypointsCte = [236 550 684 747 923 1209 1513 1553 1591 1651 1952];

% VELOCIDAD PROGRESIVA logAC5.90s.velProg.csv
waypoints = [596 910 1044 1095 1270 1537 1584 1778 1832 1888 2092 2153];
% VELOCIDAD CONSTANTE logAC5.90s.velCte.csv
waypointsCte = [596 910 1044 1107 1283 1569 1800 1838 1876 2131 2247];
%% Creamos la figura
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

tl = tiledlayout(7,1);
tl.Padding = 'none';
tl.TileSpacing = 'none';

%% GRAFICA DE ALTURA
ax0 = nexttile;

yyaxis right
ax0.YAxis(2).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  0 convlength(2500,'m','ft')])
ylabel('altitude (ft)') 

yyaxis left
ax0.YAxis(1).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  0 2000])
ylabel('altitude (m)')
hold on
grid on
plot(1:monCte.lastTime,posZCte,'-r','LineWidth',1)
plot(1:mon.lastTime,posZ, '-' ,'LineWidth',1)

plot(waypointsCte,posZCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,posZ(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')

legend({'Constant speed','Progressive speed'},'Location','northeast')
xticklabels(ax0,{})

%% GRAFICA DE VELOCIDAD VERTICAL
ax1 = nexttile;

yyaxis right
ax1.YAxis(2).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  convvel(-30,'m/s','kts') convvel(30,'m/s','kts')])
ylabel('Vertical speed (kt)') 

yyaxis left
ax1.YAxis(1).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  -10 10])
ylabel('Vertical speed (m/s)')
hold on
grid on
plot(1:monCte.lastTime,VverCte,'-r','LineWidth',1)
plot(1:mon.lastTime,Vver, '-' ,'LineWidth',1)

plot(waypointsCte,VverCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,Vver(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')
hold off
%legend({'Constant speed','Progressive speed'},'Location','northwest')

xticklabels(ax1,{})

%% GRAFICA DE RUMBO
ax2 = nexttile;

yyaxis right
ax2.YAxis(2).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  convang(-12,'rad','deg') convang(-2,'rad','deg')])
ylabel('heading (deg)') 

yyaxis left
ax2.YAxis(1).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  -12 -2])
ylabel('heading (rad)')
hold on
grid on
plot(1:monCte.lastTime,psiCte,'-r','LineWidth',1)
plot(1:mon.lastTime,psi, '-' ,'LineWidth',1)

plot(waypointsCte,psiCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,psi(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')

%legend({'Constant speed','Progressive speed'},'Location','northeast')
xticklabels(ax2,{})

%% GRAFICA DE VELOCIDAD
ax3 = nexttile;

yyaxis right
ax3.YAxis(2).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  0 convvel(140,'m/s','kts')])
ylabel('forward speed (kt)') 

yyaxis left
ax3.YAxis(1).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  0 140])
ylabel('forward speed (m/s)')
hold on
grid on
plot(1:monCte.lastTime,VhorCte,'-r','LineWidth',1)
plot(1:mon.lastTime,Vhor, '-' ,'LineWidth',1)

plot(waypointsCte,VhorCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,Vhor(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')


%legend({'Constant speed','Progressive speed'},'Location','southwest')
xticklabels(ax3,{})

%% GRAFICA DE ACELERACION
ax4 = nexttile;

yyaxis right
ax4.YAxis(2).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  -20/9.8 20/9.8])
ylabel('acceleration (G)')

yyaxis left
ax4.YAxis(1).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  -20 20])
ylabel('acceleration (m/s^{2})');

hold on
grid on
plot(1:monCte.lastTime,AcelCte,'-r','LineWidth',1)
plot(1:mon.lastTime,Acel, '-','Color','#0072BD' ,'LineWidth',1)

plot(waypointsCte,AcelCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,Acel(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')

 

%legend({'Constant speed','Progressive speed'},'Location','northeast')
xticklabels(ax4,{})

%% GRAFICA DE DISTANCIA ENTRE AERONAVE REAL Y DUBINS
ax5 = nexttile;

yyaxis right
ax5.YAxis(2).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  0 200*0.0005399568])
ylabel('tracking error (NM)')

yyaxis left
ax5.YAxis(1).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  0 200])
ylabel('tracking error (m)')

hold on
grid on
plot(1:monCte.lastTime,distCte,'-r' ,'LineWidth',1)
% disp("Area tracking error cte: ");
% disp( trapz (1209:1591 , distCte(1209:1591)));
% disp( trapz (1:1979 , distCte(1:1979)));
plot(1:mon.lastTime,dist,'-','Color','#0072BD' ,'LineWidth',1)
% disp("Area tracking error prog: ");
% disp(trapz (1167:1631 , dist(1167:1631)));
% disp( trapz (1:1979 , dist(1:1979)));

plot(waypointsCte,distCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,dist(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')

%legend({'Constant speed','Progressive speed'},'Location','northwest')
xticklabels(ax5,{})

%% GRAFICA DE DISTANCIA DE LA AERONAVE REAL 1 AL RESTO DE AERONAVES REALES
ax6 = nexttile;

yyaxis right
ax6.YAxis(2).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  convlength(4000,'m','naut mi') convlength(12000,'m','naut mi')])
ylabel('distance (NM)') 

xlabel('time (s)')
yyaxis left
ax6.YAxis(1).Color = 'black';
axis([waypoints(3)-5 waypoints(end)  4000 12000])
ylabel('distance (m)')
hold on
grid on
plot([1 mon.lastTime],[5556 5556],'-.','LineWidth',1,'Color',[0.5 0.5 0.5]);
plot(1:monCte.lastTime,cdistCte,'-r' ,'LineWidth',1)
plot(1:mon.lastTime,cdist,'-' ,'LineWidth',1)

plot(waypointsCte,cdistCte(waypointsCte), 'or', 'MarkerSize', 3, 'MarkerFaceColor', 'r')
plot(waypoints,cdist(waypoints), 'o', 'MarkerSize', 3, 'MarkerFaceColor', '#0072BD')

legend('conflict distance','Location','northeast')



linkaxes([ax0 ax1 ax2 ax3 ax4 ax5 ax6],'x')