% calculo del consumo de fuel en descenso 
clear; clc;

load_BADA

    
FL  = A320PTD_DESCENTS(:,01);      %[ft/100]
HP = FL * 100;                     %[ft]
Vkt = A320PTD_DESCENTS(:,06);
Thr = A320PTD_DESCENTS(:,10);
F   = A320PTD_DESCENTS(:,12);

% Calculo de n
n   = C_f1 * (1 + Vkt / C_f2);    % [kg/(min·kN)]
n = n / 1000;                     % [kg/(min·N)]

Fnom = n .* Thr;                  % [kg * min]
Fnom = round(Fnom,1);

Fmin = C_f3 * (1 - HP / C_f4);    % [kg * min]


figure
hold on
grid
plot(FL,F,'o','linewidth',2)
plot(FL,Fnom,'linewidth',2)
plot(FL,Fmin,'linewidth',2)

%podemos concluir que 
%por encima de FL30 se aplica Fmin, 
%y por debajo se activan motores y se aplica Fnom

