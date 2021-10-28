clear; clc;

BADA

   

%%
% 
% 
% Medium mass DESCENTS
% ====================
% 
%  FL[-] T[K] p[Pa] rho[kg/m3] a[m/s] TAS[kt] CAS[kt]    M[-] mass[kg] Thrust[N] Drag[N] Fuel[kgm] ESF[-] ROD[fpm] TDC[N] gammaTAS[deg]
%     60 276  81200   1.024     333   272.30   250.00    0.42  64000     13676     45221     8.4    0.91    1266   -31545    -2.63 
%
%%
        

% calculo de velocidad (airspeed) y aceleración

Vkt   = 272.30;            % [Kt]
V     = convvel(Vkt,'kts','m/s');
V_dot = -0.0427;   % sacado de despejar datos en formula del TEM





% altura y velocidad vertical
FL    = 60;
h     = convlength(FL*100,'ft','m');    % [m]

ROD   = 1266;                           % [ft/m]
h_dot = - convvel(ROD,'ft/min','m/s');


% inclinación
gamma = -2.63;


% calculo de C_L
[T, a, P, rho] = atmosisa(h);
C_L = (2 * m * g * cosd(gamma)) / (rho * V^2 * S);

% calculo de C_D approaching
C_D0 = C_D0_AP;
C_D2 = C_D2_AP;
C_D = C_D0 + C_D2 * C_L^2;

% calculo de la fuerza de arrastre
D = C_D * rho * V^2 * S / 2;
%esto encaja
D = 45221;

% calculo del empuje del motor
Thrust = D + m * (g * h_dot / V + V_dot);


% Calculo del consumo de combustible Fnom
eta   = C_f1 * (1 + Vkt / C_f2); % [kg/(min·kN)]
eta_N = eta / 1000;              % [kg/(min·N)]
Fnom = eta_N * Thrust;           % [kg * min]
%no coincide con la tabla, que es 8.4???

% Calculo del consumo de combustible Fmin
HP = FL * 100;                    %[ft]
Fmin = C_f3 * (1 - HP / C_f4);    % [kg * min]





