% calculo de HP para el calculo de fuel en idle descent
clear; clc;

load_BADA


%definición de valores

C_f1  = .75882E+00;     % [kg/(min·kN)]  thrust specific fuel consumption
C_f2  = .29385E+04;     % [kt]           thrust specific fuel consumption
C_f3  = .89418E+01;     % [kg/min]       descent fuel flow
C_f4  = .93865E+05;     % [ft]           descent fuel flow
C_fcr = .96358E+00;     % [-]            cruise fuel flow factor

   
FL   = A320PTD_DESCENTS(6:end,01) * 100;      %[ft]
Fmin = A320PTD_DESCENTS(6:end,12);


% Calculo HP
HP = C_f4 * (1 - Fmin / C_f3);
Ftest = C_f3 * (1 - HP / C_f4);    % [kg * min]


figure
hold on
grid
plot(FL,HP,'linewidth',2)

% podemos concluir que para simplificar podemos sustituir HP = FL en la
% formula de consumo de combustible en idle thrust


