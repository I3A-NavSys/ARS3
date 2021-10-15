%% CARGA DE DATOS
clear; clc;

mon = MONITORclass("logAC5.90s.csv");
[posX,posY,posZ,psi,Vhor]      = mon.ACinfo(5,false);
[posXd,posYd,posZd,psid,Vhord] = mon.ACinfo(5,true);
[dist,distXY,distZ] = mon.dist2ref(5);
[cdist,~,~,closestAC,~] = mon.dist2ACs(5,30);


figHandler = findobj('Type','figure','Name','AC5')';
if isempty(figHandler)
    figure( ...
        'Name','AC5', ...
        'NumberTitle','off',   ...
        'Position',[1400 250 600 800]); 
else
    figure(figHandler)
    clf
end

tl = tiledlayout(5,1);
tl.Padding = 'none';
tl.TileSpacing = 'none';



%% GRAFICA DE ALTURA
ax1 = nexttile;

yyaxis left
ax1.YAxis(1).Color = 'black';
axis([300 2200 0 2500])
ylabel('altitude (m)')
grid on
hold on

plot(1:mon.lastTime,posZd,'-r','LineWidth',1)
plot(1:mon.lastTime,posZ, '-' ,'LineWidth',1)

plot([1570 1570],[150 700], ':k' ,'LineWidth',1)
text(1570,1000,{'Miss Approach','Point'},...
    'FontSize',8,...
    'HorizontalAlignment','center')
plot([1839 1839],[900 1200], ':k' ,'LineWidth',1)
text(1839,1500,{'Reinjection','Point'},...
    'FontSize',8,...
    'HorizontalAlignment','center')


yyaxis right
ax1.YAxis(2).Color = 'black';
axis([300 2200 0 convlength(2500,'m','ft')])
ylabel('altitude (ft)') 

legend({'AC5 Dubins','AC5 flyable'},'Location','southwest')
xticklabels(ax1,{})


%% GRAFICA DE RUMBO
ax2 = nexttile;

yyaxis left
ax2.YAxis(1).Color = 'black';
axis([300 2200 -12 0])
ylabel('heading (rad)')
grid on
hold on

plot(1:mon.lastTime,psid,'-r','LineWidth',1)
plot(1:mon.lastTime,psi, '-' ,'LineWidth',1)

yyaxis right
ax2.YAxis(2).Color = 'black';
axis([300 2200 convang(-12,'rad','deg') 0])
ylabel('heading (deg)') 

legend({'AC5 Dubins','AC5 flyable'},'Location','southwest')
xticklabels(ax2,{})


%% GRAFICA DE VELOCIDAD
ax3 = nexttile;

yyaxis left
ax3.YAxis(1).Color = 'black';
axis([300 2200 0 140])
ylabel('forward speed (m/s)')
grid on
hold on

plot(1:mon.lastTime,Vhord,'-r','LineWidth',1)
plot(1:mon.lastTime,Vhor, '-' ,'LineWidth',1)
 
yyaxis right
ax3.YAxis(2).Color = 'black';
axis([300 2200 0 convvel(140,'m/s','kts')])
ylabel('forward speed (kt)') 

legend({'AC5 Dubins','AC5 flyable'},'Location','southwest')
xticklabels(ax3,{})


%% GRAFICA DE DISTANCIA ENTRE AERONAVE REAL Y DUBINS
ax4 = nexttile;
grid on
hold on
axis([300 2200 0 400])
ylabel('tracking error (m)')

plot(1:mon.lastTime,dist,'-' ,'LineWidth',1)

legend({'AC5 flyable following AC5 Dubins'})
xticklabels(ax4,{})


%% GRAFICA DE DISTANCIA DE LA AERONAVE REAL 5 AL RESTO DE AERONAVES REALES
ax5 = nexttile;
xlabel('time (s)')

yyaxis left
ax5.YAxis(1).Color = 'black';
axis([300 2200 4000 12000])
ylabel('distance (m)')
grid on
hold on

plot(1:mon.lastTime,cdist,'-' ,'LineWidth',1)
plot([1 mon.lastTime],[5556 5556],'--','LineWidth',1,'Color',[0.5 0.5 0.5]);
% plot(1:mon.lastTime,dist, '-r','LineWidth',1)

 yyaxis right
ax5.YAxis(2).Color = 'black';
axis([300 2200 convlength(4000,'m','naut mi') convlength(12000,'m','naut mi')])
ylabel('distance (NM)') 

legend({'AC5 flyable to closest AC flyable','conflict distance'},'Location','northeast')



linkaxes([ax1 ax2 ax3 ax4 ax5],'x')


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
grid on
hold on
axis([300 2200 3 11])
xlabel('time (s)')
ylabel('closest AC (id)')

plot(1:mon.lastTime,closestAC,'LineWidth',2)



