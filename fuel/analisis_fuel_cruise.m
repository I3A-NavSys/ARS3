% calculo del consumo de fuel en crucero
clear; clc;

load_BADA



FL  = A320PTF(6:end,1);               % [ft/100]
Vkt = A320PTF(6:end,2);
F   = A320PTF(6:end,4);

% Calculo de F
n   = C_f1 * (1 + Vkt / C_f2);    % [kg/(min·kN)]
n = n / 1000;                     % [kg/(min·N)]
Fnom = n .* Thr;                  % [kg * min]
Fnom = Fnom * C_fcr;             
Fnom = round(Fnom,1);


%no se puede calcular porque no tenemos datos sobre el empuje
