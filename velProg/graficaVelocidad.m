log = csvread("logAC.csv");
%Filtramos datos específicos de la aeronave 1
log  = log(log(:,2)==1,:);
logR = log(log(:,3)==6,:); % Avion real
logD = log(log(1:end-1,3)~=6,:); % Avion Dubins
vector_time = logD(:,1);
vector_vhorR = logR(:,8);
vector_vhorD = logD(:,8);

figHandler = findobj('Type','figure','Name','Velocidad horizontal')';
if isempty(figHandler)
    figure( ...
        'Name','Velocidad horizontal', ...
        'NumberTitle','off',   ...
        'Position',[400 00 600 600]); 
else
    figure(figHandler)
    clf
end

hold on
grid on
plot(vector_time,vector_vhorR,'linewidth',1)
plot(vector_time,vector_vhorD,'linewidth',1)
title('Velocidad horizontal del avión reinyectado con velocidad progresiva')
legend('Avión real','Avión Dubins')
ylabel('Velocidad horizontal (m/s)')
xlabel('Tiempo (s)')

