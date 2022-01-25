% Esta gráfica muestra para el aeropuerto de Málaga
% la productividad (en aterrizajes/hora) 
% en función de la distancia entre huecos consecutivos
% para diferentes intervalos de separación T

% clc;
% fig = figure;
% grid on
% hold on
% axis([0 20 0 1])
% xlabel ('consecutive aircraft')
% ylabel ('relative landings / hour')

fig3_aveReinjTime_consecACs;


lw = 2;


n1 = 0:19;                      % distancia entre huecos consecutivos
n2 = 1:20;
fr = n1 ./ n2;

prod  = 3600/60  * fr;
p     = plot(n1(2:end),prod(2:end)./60,...
                'LineWidth',lw,...
                'Color','black');


legend([p,pT60av,pT90av,pT120av,pT150av,pT180av],{'norm L','T=60','T=90','T=120','T=150','T=180'})
legend('Location','southeast')



