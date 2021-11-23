log = csvread("logAC1.90s.velProg.csv");
logcte = csvread("logAC1.90s.velCte.csv");
%Filtramos datos específicos de la aeronave 1
log  = log(log(:,2)==1,:);
logR = log(log(:,3)==6,:); % Avion real
logD = log(log(:,3)~=6,:); % Avion Dubins
if length(logR) > length(logD)
    l = length(logD);
else
    l = length(logR);
end
vector_time = logD(1:l,1);
vector_vhorR = logR(1:l,8);
vector_vhorD = logD(1:l,8);

logcte  = logcte(logcte(:,2)==1,:);
logRcte = logcte(logcte(:,3)==6,:); % Avion real
logDcte = logcte(logcte(:,3)~=6,:); % Avion Dubins
if length(logRcte) > length(logDcte)
    l = length(logDcte);
else
    l = length(logRcte);
end

% Vector de tiempos en que cambia de WP
tiempos = [236 550 684 737 913 1167 1533 1586 1640 1918];
labels  = ["TOLSU (IAF)","MARTIN","MG403","MG402 (IF)","MG401 (FAP)",...
    "Missed approach","WPi1","WPi2","WPi3","RWY13 (LTP)","RWY13"];
vector_timecte = logDcte(1:l,1);
vector_vhorRcte = logRcte(1:l,8);
vector_vhorDcte = logDcte(1:l,8);

figHandler = findobj('Type','figure','Name','Velocidad horizontal')';
if isempty(figHandler)
    figure( ...
        'Name','Velocidad horizontal', ...
        'NumberTitle','off',   ...
        'Position',[400 00 1000 1000]); 
else
    figure(figHandler)
    clf
end
tl = tiledlayout(2,1);
%tl.Padding = 'none';
tl.TileSpacing = 'none';

ax1 = nexttile;

hold on
grid on
%plot(vector_time,vector_vhorR,'linewidth',1)
plot(vector_time,vector_vhorD,'linewidth',1)
for i=1:length(tiempos)
    xl = xline(tiempos(i),'--',{labels(i)},'linewidth',0.5)
    xl.LabelVerticalAlignment = 'bottom';
    xl.LabelHorizontalAlignment = 'left';
end
title('Velocidad horizontal del avión reinyectado con velocidad progresiva')
%legend('Avión real','Avión Dubins')
ylabel('Velocidad horizontal (m/s)')
xlabel('Tiempo (s)')
axis([0 vector_time(end) 0 140])

ax2 = nexttile;
hold on
grid on
%plot(vector_timecte,vector_vhorRcte,'linewidth',1)
plot(vector_timecte,vector_vhorDcte,'linewidth',1)
title('Velocidad horizontal del avión reinyectado con velocidad cte')
%legend('Avión real','Avión Dubins')
ylabel('Velocidad horizontal (m/s)')
xlabel('Tiempo (s)')
axis([0 vector_time(end) 0 140])
