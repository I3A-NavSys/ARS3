% calculo del consumo de fuel en ascenso 
clear; clc;

load_BADA

Vkt = A320PTD_MCLIMBS(:,06);
Thr = A320PTD_MCLIMBS(:,10);
F   = A320PTD_MCLIMBS(:,12);

% Calculo de n
n   = C_f1 * (1 + Vkt / C_f2);    % [kg/(min·kN)]
n = n / 1000;                     % [kg/(min·N)]

Fnom = n .* Thr;                  % [kg * min]
%Fnom = Fnom * C_fcr;             
Fnom = round(Fnom,1);

figure
hold on
grid
plot(A320PTD_MCLIMBS(:,1),F,'o','linewidth',2)
plot(A320PTD_MCLIMBS(:,1),Fnom,'linewidth',2)



%podemos concluir que se aplica Fnom en todo el ascenso
