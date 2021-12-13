log = csvread("logAC.csv");
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
tiemposProg = [236 550 684 737 913 1167 1281 1526 1579 1631 1920];
tiemposCte  = [236 550 684 747 923 1209 1513 1553 1591 1651];
labels  = ["TOLSU (IAF)","MARTIN","MG403","MG402 (IF)","MG401 (FAP)",...
    "Missed approach","WPi1","WPi2","WPi3","WPi4","RWY13 (LTP)"];
labelsCte  = ["","","","","","","WPi1","WPi2","WPi3","RWY13 (LTP)"];
vector_timecte = logDcte(1:l,1);
vector_vhorRcte = logRcte(1:l,8);
vector_vhorDcte = logDcte(1:l,8);

% diff = length(vector_timecte) - length(vector_time);
% if diff>0
%     vector_time = vector_timecte;
%     vector_vhorD = [vector_vhorD; zeros(diff,1)];
% else
%     vector_vhorDcte = [vector_vhorDcte; zeros(-1*diff,1)];
% end

figHandler = findobj('Type','figure','Name','Velocidad horizontal')';
if isempty(figHandler)
    figure( ...
        'Name','Velocidad horizontal', ...
        'NumberTitle','off',   ...
        'Position',[400 00 1000 600]); 
else
    figure(figHandler)
    clf
end
% tl = tiledlayout(2,1);
% %tl.Padding = 'none';
% tl.TileSpacing = 'none';
% 
% ax1 = nexttile;

hold on
grid on
% ax2 = nexttile;
% hold on
% grid on
%plot(vector_timecte,vector_vhorRcte,'linewidth',1)
plot(vector_timecte,vector_vhorDcte,'r','linewidth',1)
% %legend('Avión real','Avión Dubins')
% ylabel('Velocidad horizontal (m/s)')
% xlabel('Tiempo (s)')
% axis([0 vector_time(end) 0 140])

%plot(vector_time,vector_vhorR,'linewidth',1)
plot(vector_time,vector_vhorD,'b','linewidth',1)

    
    %     xl = xline(tiempos(i),'--',{labels(i)},'linewidth',0.5);
%     xl.LabelVerticalAlignment = 'bottom';
%     xl.LabelHorizontalAlignment = 'left';

title('Horizontal speed of reinjected aircraft','FontSize',18)

ylabel('Speed (m/s)','FontSize',14)
xlabel('Time (s)','FontSize',14)
axis([0 vector_time(end) 0 140])



plot(tiemposCte,vector_vhorDcte(tiemposCte),'or','linewidth',1)
t1 = text(tiemposCte,vector_vhorDcte(tiemposCte)+3,labelsCte,'VerticalAlignment','top','HorizontalAlignment','left','rotation',90,'Color','k');
t1(end).Color = 'r';
t1(end-1).Color = 'r';
t1(end-2).Color = 'r';
t1(end-3).Color = 'r';
plot(tiemposProg,vector_vhorD(tiemposProg),'ob','linewidth',1)
t = text(tiemposProg,vector_vhorD(tiemposProg)-3,labels,'VerticalAlignment','bottom','HorizontalAlignment','right','rotation',90,'Color','k');
t(end).Color = 'b';
t(end-1).Color = 'b';
t(end-2).Color = 'b';
t(end-3).Color = 'b';
t(end-4).Color = 'b';
legend('Constant speed','Progresive speed','Location','southwest','FontSize',12)
