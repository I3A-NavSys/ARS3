% Esta gráfica muestra para el aeropuerto de Málaga
% la fracción de tiempo (con respecto al miss approach convencional) 
% ahorrado al reinyectar una aeronave
% en función de la lejania del hueco
% para diferentes intervalos de separación T

clc; clear;
fig = figure;

%p_mac = plot([0 20],[100 100],'r:','LineWidth',3);
grid on
hold on
axis([0 20 0 1])
xlabel ('aircrafts before reinjection gap (m)')
ylabel ('normalized reinjection time (t_r)')
lw = 2;

ACs_detras = 1:20;            % ACs entre el ac1 y el hueco
simT60  = 2 + zeros(1,20);    % fraccion de tiempo empleado
simT90  = simT60;         
simT120 = simT60;         
simT150 = simT60;         
simT180 = simT60;         


%% Aterrizaje normal
%   240: aeronave   5 entra en espacio aereo
%  1577: aeronave   5 aterriza en 1337 s. Tiempo desde MAPt 127

t_MAPt = 127;


% Aterrizaje tras aproximación frustrada convencional
%   240: aeronave   5 entra en espacio aereo
%  1450: aeronave   5 ejecuta miss approach convencional
%  3369: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt 1919 
%  3370: aeronave   5 aterriza en 3130 s

t_cycle_conv_miss_app = 1919 - t_MAPt;


% Aterrizaje tras aproximación frustrada convencional con vuelta en sala de espera
%   240: aeronave   5 entra en espacio aereo
%  1450: aeronave   5 ejecuta miss approach convencional
%  3999: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt 2549 
%  4000: aeronave   5 aterriza en 3760 s

t_cycle_conv_miss_app = 2549 - t_MAPt;





%% intervalo entre aviones T=60

%   240: aeronave   5 entra en espacio aereo
%  1447: aeronave   5 reinyectada 241 segundos detras
%  1818: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  371 
%  1819: aeronave   5 aterriza en 1579 s
t_cycle = 371 - t_MAPt;
simT60(3)  = t_cycle / t_cycle_conv_miss_app;


%   240: aeronave   5 entra en espacio aereo
%  1447: aeronave   5 reinyectada 301 segundos detras
%  1875: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  428 
%  1876: aeronave   5 aterriza en 1636 s
t_cycle = 428 - t_MAPt;
simT60(4)  = t_cycle / t_cycle_conv_miss_app;


%   240: aeronave   5 entra en espacio aereo
%  1447: aeronave   5 reinyectada 364 segundos detras
%  1942: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  495 
%  1943: aeronave   5 aterriza en 1703 s
t_cycle = 495 - t_MAPt;
simT60(5)  = t_cycle / t_cycle_conv_miss_app;


%   240: aeronave   5 entra en espacio aereo
%  1447: aeronave   5 reinyectada 421 segundos detras
%  1997: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  550 
%  1998: aeronave   5 aterriza en 1758 s
t_cycle = 550 - t_MAPt;
simT60(6)  = t_cycle / t_cycle_conv_miss_app;


%   240: aeronave   5 entra en espacio aereo
%  1447: aeronave   5 reinyectada 783 segundos detras
%  2359: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  912 
%  2360: aeronave   5 aterriza en 2120 s
t_cycle = 912 - t_MAPt;
simT60(12)  = t_cycle / t_cycle_conv_miss_app;


%   240: aeronave   5 entra en espacio aereo
%  1450: aeronave   5 reinyectada 1140 segundos detras
%  2719: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt 1269 
%  2720: aeronave   5 aterriza en 2480 s
t_cycle = 1269 - t_MAPt;
simT60(18)  = t_cycle / t_cycle_conv_miss_app;



pSim = plot(ACs_detras,simT60,'ok');
linT60 = 60 * (ACs_detras+1) / t_cycle_conv_miss_app;
pT60 = plot(ACs_detras(3:18),linT60(3:18),...
            'LineWidth',lw,...
            'Color',[0.8500 0.3250 0.0980]);





%%

% intervalo entre aviones T=90

%   360: aeronave   5 entra en espacio aereo
%  1570: aeronave   5 reinyectada 357 segundos detras
%  2060: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  490 
%  2061: aeronave   5 aterriza en 1701 s
t_cycle = 490 - t_MAPt;
simT90(3)  = t_cycle / t_cycle_conv_miss_app;


%   360: aeronave   5 entra en espacio aereo
%  1570: aeronave   5 reinyectada 449 segundos detras
%  2144: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  574 
%  2145: aeronave   5 aterriza en 1785 s
t_cycle = 574 - t_MAPt;
simT90(4)  = t_cycle / t_cycle_conv_miss_app;


%   360: aeronave   5 entra en espacio aereo
%  1568: aeronave   5 reinyectada 638 segundos detras
%  2335: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  767 
%  2336: aeronave   5 aterriza en 1976 s
t_cycle = 767 - t_MAPt;
simT90(6)  = t_cycle / t_cycle_conv_miss_app;


%   360: aeronave   5 entra en espacio aereo
%  1570: aeronave   5 reinyectada 1080 segundos detras
%  2781: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt 1211 
%  2782: aeronave   5 aterriza en 2422 s
t_cycle = 1211 - t_MAPt;
simT90(11)  = t_cycle / t_cycle_conv_miss_app;



plot(ACs_detras,simT90,'ok')
linT90 = 90 * (ACs_detras+1) / t_cycle_conv_miss_app;
pT90 = plot(ACs_detras(2:12),linT90(2:12),...
            'LineWidth',lw,...
            'Color',[0.4940 0.1840 0.5560]);



%%

% intervalo entre aviones T=120

%   480: aeronave   5 entra en espacio aereo
%  1687: aeronave   5 reinyectada 241 segundos detras
%  2057: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  370 
%  2058: aeronave   5 aterriza en 1578 s
t_cycle = 370 - t_MAPt;
simT120(1)  = t_cycle / t_cycle_conv_miss_app;


%   480: aeronave   5 entra en espacio aereo
%  1687: aeronave   5 reinyectada 601 segundos detras
%  2418: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  731 
%  2419: aeronave   5 aterriza en 1939 s
t_cycle = 731 - t_MAPt;
simT120(4)  = t_cycle / t_cycle_conv_miss_app;


%   480: aeronave   5 entra en espacio aereo
%  1687: aeronave   5 reinyectada 721 segundos detras
%  2537: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  850 
%  2538: aeronave   5 aterriza en 2058 s
t_cycle = 850 - t_MAPt;
simT120(5)  = t_cycle / t_cycle_conv_miss_app;


%   480: aeronave   5 entra en espacio aereo
%  1690: aeronave   5 reinyectada 1080 segundos detras
%  2902: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt 1212 
%  2903: aeronave   5 aterriza en 2423 s
t_cycle = 1212 - t_MAPt;
simT120(8)  = t_cycle / t_cycle_conv_miss_app;



plot(ACs_detras,simT120,'ok')
linT120 = 120 * (ACs_detras+1) / t_cycle_conv_miss_app;
pT120 = plot(ACs_detras(1:9),linT120(1:9),...
             'LineWidth',lw,...
             'Color',[0.3010 0.7450 0.9330]);

%%

% intervalo entre aviones T=150
 
%   600: aeronave   5 entra en espacio aereo
%  1810: aeronave   5 reinyectada 298 segundos detras
%  2243: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  433
%  2244: aeronave   5 aterriza en 1644 s
t_cycle = 433 - t_MAPt;
simT150(1)  = t_cycle / t_cycle_conv_miss_app;

%   600: aeronave   5 entra en espacio aereo
%  1807: aeronave   5 reinyectada 604 segundos detras
%  2539: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  732 
%  2540: aeronave   5 aterriza en 1940 s
t_cycle = 732 - t_MAPt;
simT150(3)  = t_cycle / t_cycle_conv_miss_app;


%   600: aeronave   5 entra en espacio aereo
%  1810: aeronave   5 reinyectada 1050 segundos detras
%  2990: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt 1180 
%  2991: aeronave   5 aterriza en 2391 s
t_cycle = 1180 - t_MAPt;
simT150(6)  = t_cycle / t_cycle_conv_miss_app;


plot(ACs_detras,simT150,'ok')
linT150 = 150 * (ACs_detras+1) / t_cycle_conv_miss_app;
pT150 = plot(ACs_detras(1:7),linT150(1:7),...
             'LineWidth',lw,...
             'Color',[0 0.4470 0.7410]);



%%

% intervalo entre aviones T=180

%   720: aeronave   5 entra en espacio aereo
%  1930: aeronave   5 reinyectada 361 segundos detras
%  2424: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  494 
%  2425: aeronave   5 aterriza en 1705 s
t_cycle = 494 - t_MAPt;
simT180(1)  = t_cycle / t_cycle_conv_miss_app;


%   720: aeronave   5 entra en espacio aereo
%  1930: aeronave   5 reinyectada 722 segundos detras
%  2785: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt  855 
%  2786: aeronave   5 aterriza en 2066 s
t_cycle = 855 - t_MAPt;
simT180(3)  = t_cycle / t_cycle_conv_miss_app;


%   600: aeronave   5 entra en espacio aereo
%  1810: aeronave   5 reinyectada 1050 segundos detras
%  2990: aeronave   5 aterriza tras abortar el primer intento. Tiempo desde MAPt 1180 
%  2991: aeronave   5 aterriza en 2391 s
t_cycle = 1180 - t_MAPt;
simT180(6)  = t_cycle / t_cycle_conv_miss_app;


plot(ACs_detras,simT180,'ok')
linT180 = 180 * (ACs_detras+1) / t_cycle_conv_miss_app;
pT180 = plot(ACs_detras(1:5),linT180(1:5),...
             'LineWidth',lw,...
             'Color',[0.9290 0.6940 0.1250]);



         
plot([1,19],[0.4995,0.4995],':',...
                'LineWidth',1.5,...
                'Color','k');         
         

legend([pSim pT60 pT90 pT120 pT150 pT180],{'sim','T=60','T=90','T=120','T=150','T=180'})
legend('Location','southeast')



