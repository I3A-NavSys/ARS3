%% CARGA DE DATOS
clear; clc;

mon = MONITORclass("logAC1.90s.velProg.csv");
[posX,posY,posZ,psi,Vhor,Acel]       = mon.ACinfo(1,false);
[posXd,posYd,posZd,psid,Vhord,Aceld] = mon.ACinfo(1,true);
[dist,distXY,distZ] = mon.dist2ref(1);
[cdist,~,~,closestAC,~] = mon.dist2ACs(1,30);

for i=1:mon.lastTime-1
    Acel(i) = Vhor(i+1)-Vhor(i);
end
Acel(mon.lastTime) = Acel(mon.lastTime-1);
% for i=1:mon.lastTime-1
%     Aceld(i) = Vhord(i+1)-Vhord(i);
% end
% Aceld(mon.lastTime) = Aceld(mon.lastTime-1);

% Array de tiempos en que se cambia de WP
% VELOCIDAD PROGRESIVA
% logAC1.90s.velProg.csv
waypoints = [236 550 684 737 913 1167 1281 1526 1579 1631 1637 1920];
labels  = ["" "TOLSU (IAF)";"" "MARTIN"; "" "MG403"; "" "MG402 (IF)";"MG401" "(FAP)";...
    "" "Missed approach";"" "WPi1"; "" "WPi2";"" "WPi3"; "" "WPi4";"MG401" "(FAP)";"" "RWY13 (LTP)"];
% logAC1.80s.velProg.csv
% waypoints = [236 550 684 737 913 1167 1283 1492 1548 1602 1852];
% labels  = ["" "TOLSU (IAF)";"" "MARTIN"; "" "MG403"; "" "MG402 (IF)";"MG401" "(FAP)";...
%     "" "Missed approach";"" "WPi1"; "" "WPi2";"" "WPi3"; "" "WPi4";"" "RWY13 (LTP)"];
% VELOCIDAD CONSTANTE
% logAC1.90s.velCte.csv
% waypoints = [236 550 684 747 923 1209 1513 1553 1591 1651 1952];
% labels  = ["" "TOLSU (IAF)";"" "MARTIN"; "" "MG403"; "" "MG402 (IF)";"MG401" "(FAP)";...
%     "Missed" "approach";"" "WPi1"; "" "WPi2";"" "WPi3"; "MG401" "(FAP)";"" "RWY13 (LTP)"];

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

yyaxis left
ax1.YAxis(1).Color = 'black';
axis([800 2000  0 2500])
ylabel('altitude (m)')
% grid on
hold on

plot(1:mon.lastTime,posZd,'-r','LineWidth',1)
plot(1:mon.lastTime,posZ, '-' ,'LineWidth',1)

% plot([1169 1169],[150 700], ':k' ,'LineWidth',1)
% text(1150,1170,{'Miss','Approach','Point'},...
%     'FontSize',8,...
%     'HorizontalAlignment','center')
% plot([1635 1635],[1300 600], ':k' ,'LineWidth',1)
% text(1635,500,{'Reinjection','Point'},...
%     'FontSize',8,...
%     'HorizontalAlignment','center')

% Dibujamos las lineas de los WP
for i = 1:length(waypoints)
    if i == 11
        xline(waypoints(i),'--',labels(i,:),'Alpha',0.5,'LabelHorizontalAlignment','right');
        continue
    end
    xline(waypoints(i),'--',labels(i,:),'Alpha',0.5,'LabelHorizontalAlignment','left');
end

yyaxis right
ax1.YAxis(2).Color = 'black';
axis([800 2000  0 convlength(2500,'m','ft')])
ylabel('altitude (ft)') 

legend({'AC1 Dubins','AC1 flyable'},'Location','southwest')
xticklabels(ax1,{})


%% GRAFICA DE RUMBO
ax2 = nexttile;

yyaxis left
ax2.YAxis(1).Color = 'black';
axis([800 2000  -12 -2])
ylabel('heading (rad)')
% grid on
hold on

plot(1:mon.lastTime,psid,'-r','LineWidth',1)
plot(1:mon.lastTime,psi, '-' ,'LineWidth',1)

for wp = waypoints xline(wp,'--','Alpha',0.5); end

yyaxis right
ax2.YAxis(2).Color = 'black';
axis([800 2000  convang(-12,'rad','deg') convang(-2,'rad','deg')])
ylabel('heading (deg)') 

legend({'AC1 Dubins','AC1 flyable'},'Location','southwest')
xticklabels(ax2,{})


%% GRAFICA DE VELOCIDAD
ax3 = nexttile;

yyaxis left
ax3.YAxis(1).Color = 'black';
axis([800 2000  0 120])
ylabel('forward speed (m/s)')
% grid on
hold on

plot(1:mon.lastTime,Vhord,'-r','LineWidth',1)
plot(1:mon.lastTime,Vhor, '-' ,'LineWidth',1)

for wp = waypoints xline(wp,'--','Alpha',0.5); end

yyaxis right
ax3.YAxis(2).Color = 'black';
axis([800 2000  0 convvel(140,'m/s','kts')])
ylabel('forward speed (kt)') 

legend({'AC1 Dubins','AC1 flyable'},'Location','southwest')
xticklabels(ax3,{})

%% GRAFICA DE ACELERACION
ax4 = nexttile;


ax4.YAxis(1).Color = 'black';
axis([800 2000  -20 20])
ylabel('acceleration (m/s^{2})');
% grid on
hold on

plot(1:mon.lastTime,Aceld,'-r','LineWidth',1)
plot(1:mon.lastTime,Acel, '-','Color','#0072BD' ,'LineWidth',1)

for wp = waypoints xline(wp,'--','Alpha',0.5); end

legend({'AC1 Dubins','AC1 flyable'},'Location','southwest')
xticklabels(ax4,{})


%% GRAFICA DE DISTANCIA ENTRE AERONAVE REAL Y DUBINS
ax5 = nexttile;
% grid on
hold on
axis([800 2000  0 300])
ylabel('tracking error (m)')

plot(1:mon.lastTime,dist,'-' ,'LineWidth',1)

for wp = waypoints xline(wp,'--','Alpha',0.5); end

legend({'AC1 flyable following AC1 Dubins'},'Location','northwest')
xticklabels(ax5,{})


%% GRAFICA DE DISTANCIA DE LA AERONAVE REAL 1 AL RESTO DE AERONAVES REALES
ax6 = nexttile;
xlabel('time (s)')

yyaxis left
ax6.YAxis(1).Color = 'black';
axis([800 2000  4000 12000])
ylabel('distance (m)')
% grid on
hold on

plot(1:mon.lastTime,cdist,'-' ,'LineWidth',1)
plot([1 mon.lastTime],[5556 5556],'-.','LineWidth',1,'Color',[0.5 0.5 0.5]);
% plot(1:mon.lastTime,dist, '-r','LineWidth',1)

for wp = waypoints xline(wp,'--','Alpha',0.5); end

 yyaxis right
ax6.YAxis(2).Color = 'black';
axis([800 2000  convlength(4000,'m','naut mi') convlength(12000,'m','naut mi')])
ylabel('distance (NM)') 

legend({'AC1 flyable to closest AC flyable','conflict distance'},'Location','northeast')



linkaxes([ax1 ax2 ax3 ax4 ax5 ax6],'x')


%%

figHandler = findobj('Type','figure','Name','AC closest neighbour')';
if isempty(figHandler)
    figure( ...
        'Name','AC closest neighbour', ...
        'NumberTitle','off',   ...
        'Position',[550 250 600 200]); 
else
    figure(figHandler)
    clf
end
% grid on
hold on
axis([800 2000  0 11])
xlabel('time (s)')
ylabel('closest AC (id)')

 plot(1:mon.lastTime,closestAC,'LineWidth',2)


