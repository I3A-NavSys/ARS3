%% CARGA DE DATOS
clear; clc;

mon = MONITORclass("logAC5.90s.velProg.csv");
[posX,posY,posZ,psi,Vhor]      = mon.ACinfo(5,false);
[posXd,posYd,posZd,psid,Vhord] = mon.ACinfo(5,true);
[dist,distXY,distZ] = mon.dist2ref(5);
[cdist,~,~,closestAC,~] = mon.dist2ACs(5,30);



%% GRAFICA DE ALTURA
figHandler = findobj('Type','figure','Name','AC5 altitude')';
if isempty(figHandler)
    figure( ...
        'Name','AC5 altitude', ...
        'NumberTitle','off',   ...
        'Position',[550 250 350 200]); 
else
    figure(figHandler)
    clf
end

xlabel('time (s)')

yyaxis left
grid on
hold on
axis([900 940 2040 2160])
ylabel('altitude (m)')

plot(1:mon.lastTime,posZd,'-r','LineWidth',1)
plot(1:mon.lastTime,posZ, '-' ,'LineWidth',1)
% plot([1840 1840],[0 2500],'--','LineWidth',1,'Color',[0.5 0.5 0.5]);


yyaxis right
axis([900 940 convlength(2040,'m','ft') convlength(2160,'m','ft')])
ylabel('altitude (ft)') 

legend({'AC5 Dubins','AC5 flyable'},'Location','northeast')
ax = gca;
ax.YAxis(1).Color = 'black';
ax.YAxis(2).Color = 'black';



%% GRAFICA DE RUMBO
figHandler = findobj('Type','figure','Name','AC5 heading')';
if isempty(figHandler)
    figure( ...
        'Name','AC5 heading', ...
        'NumberTitle','off',   ...
        'Position',[550 250 350 200]); 
else
    figure(figHandler)
    clf
end

xlabel('time (s)')

yyaxis left
grid on
hold on
axis([1080 1160 -4.1 -3.6])
ylabel('heading (rad)')

plot(1:mon.lastTime,psid,'-r','LineWidth',1)
plot(1:mon.lastTime,psi, '-' ,'LineWidth',1)

yyaxis right
axis([1080 1160 convang(-4.1,'rad','deg') convang(-3.6,'rad','deg')])
ylabel('heading (deg)') 

legend({'AC5 Dubins','AC5 flyable'},'Location','northeast')
ax = gca;
ax.YAxis(1).Color = 'black';
ax.YAxis(2).Color = 'black';



%% GRAFICA DE VELOCIDAD
figHandler = findobj('Type','figure','Name','AC5 forward speed')';
if isempty(figHandler)
    figure( ...
        'Name','AC5 forward speed', ...
        'NumberTitle','off',   ...
        'Position',[550 250 350 200]); 
else
    figure(figHandler)
    clf
end

xlabel('time (s)')

yyaxis left
grid on
hold on
axis([1040 1065 80 130])  % detalle en otro lugar 
axis([1280 1310 70 85])

ylabel('forward speed (m/s)')

plot(1:mon.lastTime,Vhord,'-r','LineWidth',1)
plot(1:mon.lastTime,Vhor, '-' ,'LineWidth',1)

yyaxis right
axis([1280 1310 convvel(70,'m/s','kts') convvel(85,'m/s','kts')])
ylabel('forward speed (kt)') 

legend({'AC5 Dubins','AC5 flyable'},'Location','northeast')
ax = gca;
ax.YAxis(1).Color = 'black';
ax.YAxis(2).Color = 'black';







