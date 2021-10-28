% calculo de la aceleración lineal segun la tabla (FL60)

clear; clc;

load_BADA
    

Thr  = A320PTD_DESCENTS(:,10);
D    = A320PTD_DESCENTS(:,11);

Vkt  = A320PTD_DESCENTS(:,6);            % [Kt]
VTAS = convvel(Vkt,'kts','m/s');




% altura
FL   = A320PTD_DESCENTS(:,01);
h    = convlength(FL*100,'ft','m');     % [m]

% velocidad vertical
ROD   = A320PTD_DESCENTS(:,14);                           % [ft/m]
h_dot = - convvel(ROD,'ft/min','m/s');
gamma = A320PTD_DESCENTS(:,16);
h_dot2 = VTAS .* sind(gamma); % dos metodos para comprobar que coincide


%Aceleracion lineal
V_dot = (Thr - D) .* VTAS;
V_dot = V_dot - (m * g * h_dot);
V_dot = V_dot ./ (m * VTAS);

figure
hold on
grid
plot(FL,V_dot,'linewidth',2)

%La aceleración lineal no supera los +-0.2 [m/s2]
