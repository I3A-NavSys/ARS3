clear
clc

logAC5 = csvread("logAC5.90s.progresiva.vel.csv");
[t1,h1,f1,fT1] = approach(logAC5,5,360,913,1568,   0,   0,1837,   0,2156);
t1 = t1 ./ 60;
h1 = convlength(h1,'m','ft') ./ 100;    % [ft]

logAC5 = csvread("logAC5.90s.xilvi.csv");
[t2,h2,f2,fT2] = approach(logAC5,5,360,913,1568,1918,2365,3010,3335,4123);
t2 = t2 ./ 60;
h2 = convlength(h2,'m','ft') ./ 100;    % [ft]


 %%
figHandler = findobj('Type','figure','Name','BADA analysis')';
if isempty(figHandler)
    figure( ...
        'Name','BADA analysis', ...
        'NumberTitle','off',   ...
        'Position',[400 00 600 600]); 
else
    figure(figHandler)
    clf
end


sp = subplot(3,1,1);
hold on
grid on
%axis([350 4020 0 2500])
axis([0 70 0 80])
plot(t2,h2,'linewidth',2)
plot(t1,h1,'linewidth',2)
%legend('conv Miss App','ARS')
%ylabel('altitude (m)')
ylabel('flight level (ft/100)')
sp.XTickLabel = [];

sp = subplot(3,1,2);
hold on
grid on
%axis([350 4020 0 120])
axis([0 70 0 120])
plot(t2,f2,'linewidth',2)
plot(t1,f1,'linewidth',2)
legend('XILVI','ARS')
ylabel('instant fuel (Kg/min)')
sp.XTickLabel = [];

subplot(3,1,3)
hold on
grid on
%axis([350 4020 0 3000])
axis([0 70 0 3000])
plot(t2,fT2,'linewidth',2)
plot(t1,fT1,'linewidth',2)
%legend('conv Miss App','ARS')
ylabel('total fuel (Kg)')
%xlabel('time (s)')
xlabel('time (min)')


f_ARS   = 1137 - 478.4;
f_XILVI = 2871 - 478.4;
prop = f_ARS / f_XILVI *100;




%%


function [vector_time,vector_h,vector_f,vector_fT] = approach(log,ACid,tcr,tap,tma,tw,tma2,tcr2,tap2,tl)
% log:  log de la simulación
%       t | ACid | status | X | Y | Z | phi
% ACid: avion a analizar consumo de combustible
% tcr:  momento de empezar la simulación
% tap:  momento de empezar el descenso
% tma:  momento de frustrar
% tw:   momento en entrar en la sala de espera
% tma2  momento de comenzar la reinyección
% tcr2  momento de comenzar la segunda vuelta
% tap2  momento de comenzar el descenso
% tl:   momento de aterrizaje


    %Filtramos datos específicos de una aeronave
    log = log(log(:,3)==6,:);       % Obtenemos los datos de las aeronaves reales
    log = log(log(:,2)==ACid,:);
    log = log(log(:,1)>tcr,:);
    log = log(log(:,1)<tl ,:);
    
    %definición de vectores de datos de análisis
    vector_time = log(:,1);                     
    vector_h    = ones(length(vector_time),1) * inf; 
    vector_gm   = ones(length(vector_time),1) * inf; 
    vector_f    = ones(length(vector_time),1) * inf; 
    vector_fT   = zeros(length(vector_time),1); 
    
    
    % cargamos valores
    load_BADA
    CRUISE  = A320PTF(:,[1,4]); 
    CLIMB   = A320PTD_MCLIMBS (:,[1,12]);
    DESCENT = A320PTD_DESCENTS(:,[1,12]);


    
    
    %%
    for i=3:length(vector_time)
        
        t = log(i,1);
        if t - log(i-1,1) ~= 1
            disp('error en intervalo temporal')
            return
        end
         
                  
        if     t<tap
            DATA = CRUISE;
        elseif t<tma
            DATA = DESCENT;
        elseif t<tw
            DATA = CLIMB;
        elseif t<tma2
            DATA = CRUISE;
        elseif t<tcr2
            DATA = CLIMB;
        elseif t<tap2
            DATA = CRUISE;
        else
            DATA = DESCENT;
        end
        
        
        % posiciones
        pos_t1 = log(i-1,4:6);
        pos_t0 = log(i  ,4:6);

            
        % altura y velocidad vertical
        h_t1  = pos_t1(3);              % [m]
        h     = pos_t0(3);              % [m]
        vector_h(i) = h;
        h_dot = h - h_t1;               % [m/s]

        
        % inclinación
        Vhor = norm(pos_t0(1:2)-pos_t1(1:2));
        gamma = atand (h_dot / Vhor);
        vector_gm(i) = gamma;

        % consumo de fuel
        FL = convlength(h,'m','ft') / 100;
        for j=1:length(DATA)
            if FL < DATA(j,1)
                break
            end
        end

        m = (DATA(j,2) - DATA(j-1,2)) / (DATA(j,1) - DATA(j-1,1));
        F = DATA(j-1,2) +  m * (FL - DATA(j-1,1));

        vector_f(i) = F;
        vector_fT(i) = vector_fT(i-1) + F/60;
    
    end

    plot(vector_time,vector_gm,'linewidth',2)
%    
end

