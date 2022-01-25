% Esta gráfica muestra para el aeropuerto de Málaga
% la productividad (en aterrizajes/hora) 
% en función de la distancia entre huecos consecutivos
% para diferentes intervalos de separación T

clc; 
fig = figure;
grid on
hold on
axis([0 20 0 60])
xlabel ('consecutive aircraft (n)')
%ylabel ('landings / hour (L)')
ylabel ('airport capacity (L) (landings/hour)')
lw = 2;


n1 = 0:20;      % aeronaves consecutivas antes de un hueco
n2 = n1 + 1;      
fr = n1 ./ n2;


prodT60  = 3600/60  * fr;
pT60     = plot(n1(2:20),prodT60(2:20),...
                'LineWidth',lw,...
                'Color',[0.8500 0.3250 0.0980]);

%pT60max  = plot(19,60,'o','Color',[0.8500 0.3250 0.0980]);
          
            
prodT90  = 3600/90  * fr;
pT90     = plot(n1(2:13),prodT90(2:13),...
                'LineWidth',lw,...
                'Color',[0.4940 0.1840 0.5560]);

%pT90max  = plot(12,40,'o','Color',[0.4940 0.1840 0.5560]);
     

prodT120 = 3600/120 * fr;
pT120    = plot(n1(2:11),prodT120(2:11),...
                'LineWidth',lw,...
                'Color',[0.3010 0.7450 0.9330]);

%pT120max = plot(10,30,'o','Color',[0.3010 0.7450 0.9330]);


prodT150 = 3600/150 * fr;
pT150    = plot(n1(2:9),prodT150(2:9),...
                'LineWidth',lw,...
                'Color',[0 0.4470 0.7410]);

%pT150max = plot(8,24,'o','Color',[0 0.4470 0.7410]);


prodT180 = 3600/180 * fr;
pT180    = plot(n1(2:7),prodT180(2:7),...
                'LineWidth',lw,...
                'Color',[0.9290 0.6940 0.1250]);

%pT180max = plot(6,20,'o','Color',[0.9290 0.6940 0.1250]);


pTmax = plot([6 8 10 12 19],[20 24 30 40 60],'ok');


legend([pTmax,pT60,pT90,pT120,pT150,pT180],{'max L','T=60','T=90','T=120','T=150','T=180'})
legend('Location','southeast')



