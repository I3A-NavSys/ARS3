clear; clc;

logAC5 = csvread("logAC1.90s.velProg.csv");
[t1,h1,f1,fT1] = approach(logAC5,5,365,913,1571,   0,   0,1879,   0,2123);
t1 = t1 ./ 60;
h1 = convlength(h1,'m','ft') ./ 100;    % [ft]

logAC5 = csvread("logAC5.90s.xilvi.csv");
[t2,h2,f2,fT2] = approach(logAC5,5,365,913,1571,1918,2368,3021,3342,4011);
t2 = t2 ./ 60;
h2 = convlength(h2,'m','ft') ./ 100;    % [ft]




 %%
figHandler = findobj('Type','figure','Name','BADA analysis')';
if isempty(figHandler)
    figure( ...
        'Name','BADA computed analysis', ...
        'NumberTitle','off',   ...
        'Position',[400 00 600 800]); 
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


f_ARS   =  714.5 - 417.4;
f_XILVI = 1662.0 - 417.4;
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
    vector_hdot = ones(length(vector_time),1) * inf; 
    vector_V    = zeros(length(vector_time),1); 
    vector_Vdot = zeros(length(vector_time),1); 
    vector_Vkt  = zeros(length(vector_time),1); 
    vector_D    = zeros(length(vector_time),1); 
    vector_T    = zeros(length(vector_time),1); 
    vector_f    = ones(length(vector_time),1) * inf; 
    vector_fT   = zeros(length(vector_time),1); 
        
    
    % cargamos valores
    load_BADA

    
    %%
    for i=3:length(vector_time)
        
        t = log(i,1);
        if t - log(i-1,1) ~= 1
            disp('error en intervalo temporal')
            return
        end
        
        
        if     t<tap
            mode = 'CRUISE';
        elseif t<tma
            mode = 'DESCENT';
        elseif t<tw
            mode = 'CLIMB';
        elseif t<tma2
            mode = 'CRUISE';
        elseif t<tcr2
            mode = 'CLIMB';
        elseif t<tap2
            mode = 'CRUISE';
        else
            mode = 'DESCENT';
        end
     
        
        % posiciones
        pos_t2 = log(i-2,4:6);
        pos_t1 = log(i-1,4:6);
        pos_t0 = log(i  ,4:6);

        
        % calculo de velocidad (airspeed) y aceleración
        % (como el incremento de tiempo es 1 no hace falta dividir por t)
        V_t1  = norm(pos_t1-pos_t2);
        V     = norm(pos_t0-pos_t1);
        vector_V(i) = V;
        
        V_dot = V - V_t1;
        % Esto de abajo parece ser un parche cutrecillo para evitar los picos
        %V_dot = max(V_dot,-0.2); 
        %V_dot = min(V_dot, 0.2);
        
        vector_Vdot(i) = V_dot;
        
        Vkt   = V * 1.94384;            % [m/s] -> [Kt]
        vector_Vkt(i) = Vkt;

           
        % altura
        h_t1  = pos_t1(3);              % [m]
        h     = pos_t0(3);              % [m]
        vector_h(i) = h;
        FL = convlength(h,'m','ft');    % [ft]
        
        % velocidad vertical
        h_dot = h - h_t1;               % [m/s]
        vector_hdot(i) = h_dot;
        %ROD   = h_dot * 3.28084 * 60;  % [ft/m]
        %ROD   = convvel(h_dot,'m/s','ft/min'); % [ft/m]
        
        % inclinación
        Vhor = norm(pos_t0(1:2)-pos_t1(1:2));
        gamma = atand (h_dot / Vhor);
        
        
        % calculo de C_L
        [T, a, P, rho] = atmosisa(h);
        C_L = (2 * m * g * cosd(gamma)) / (rho * V^2 * S);
        
        % calculo de C_D
        if     strcmp(mode,'CRUISE')
            C_D0 = C_D0_CR;
            C_D2 = C_D2_CR;
        elseif strcmp(mode,'CLIMB')
            C_D0 = C_D0_IC;
            C_D2 = C_D2_IC;
        else  %strcmp(mode,'DESCENT')
            C_D0 = C_D0_AP;
            C_D2 = C_D2_AP;
        end
        C_D = C_D0 + C_D2 * C_L^2;
        
        % calculo de la fuerza de arrastre
        D = C_D * rho * V^2 * S / 2;
        vector_D(i) = D;
        
        
        % calculo del empuje del motor
        Thrust = D + m * (g * h_dot / V + V_dot);
        vector_T(i) = Thrust;
                
        
        % Calculo del consumo de combustible
        eta   = C_f1 * (1 + Vkt / C_f2); % [kg/(min·kN)]
        eta_N = eta / 1000;              % [kg/(min·N)]
        
        Fnom = eta_N * Thrust;           % [kg * min]
        Fmin = C_f3 * (1 - FL / C_f4);    % [kg * min]

        if strcmp(mode,'DESCENT') && FL > 2000
            F = Fmin;
        else
            F = Fnom;
        end
        vector_f(i) = F;
        
        %if t > tma
        vector_fT(i) = vector_fT(i-1) + F/60;
        %end
    
     end

%     plot(vector_time,vector_h);
%     plot(vector_time,vector_hdot);
%     
%     plot(vector_time,vector_Vdot);
%     plot(vector_time,vector_Vkt);
    if tl == 2123
        figure('Name','Vector_f');
        plot(vector_time,vector_f);
        figure('Name','Vector_V');
        plot(vector_time,vector_V);
        figure('Name','Vector_D');
        plot(vector_time,vector_D);
        figure('Name','Vector_T');
        plot(vector_time,vector_T);
    end
%     plot(vector_time,vector_fuel);    
%    
end

