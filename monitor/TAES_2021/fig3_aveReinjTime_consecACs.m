% Esta gráfica muestra para el aeropuerto de Málaga
% la fracción de tiempo promedio (con respecto al miss approach convencional) 
% ahorrado al reinyectar aeronaves
% en función de la distancia entre huecos consecutivos
% para diferentes intervalos de separación T

%fig_reinjTime_distanceToGap;

fig = figure;
clc 
clf
grid on
hold on
axis([0 20 0 1])
xlabel ('consecutive aircraft (n)')
ylabel ('average normalized reinjection time (t_r)')
lw = 2;


t_cycle_conv_miss_app = 2549 - 127;

T1 = 240;

T    = 60;
avtr = zeros(1,20);
for n = 1:20
    for j = 1:n  % numero de saltos hasta el hueco
        tr = j*T;
        while tr < T1
            tr = tr + (n+1)*T;
        end
        avtr(n) = avtr(n) + tr;
    end
    avtr(n) = avtr(n) / n;
end
avtrnT60 = avtr / t_cycle_conv_miss_app;
pT60av = plot(1:19,avtrnT60(1:19),...
              'LineWidth',lw,...
              'Color',[0.8500 0.3250 0.0980]);



           
           
T    = 90;
avtr = zeros(1,20);
for n = 1:20
    for j = 1:n  % numero de saltos hasta el hueco
        tr = j*T;
        while tr < T1
            tr = tr + (n+1)*T;
        end
        avtr(n) = avtr(n) + tr;
    end
    avtr(n) = avtr(n) / n;
end
avtrnT90 = avtr / t_cycle_conv_miss_app;
pT90av = plot(1:12,avtrnT90(1:12),...
              'LineWidth',lw,...
              'Color',[0.4940 0.1840 0.5560]);



T    = 120;
avtr = zeros(1,20);
for n = 1:20
    for j = 1:n  % numero de saltos hasta el hueco
        tr = j*T;
        while tr < T1
            tr = tr + (n+1)*T;
        end
        avtr(n) = avtr(n) + tr;
    end
    avtr(n) = avtr(n) / n;
end
avtrnT120 = avtr / t_cycle_conv_miss_app;
pT120av = plot(1:9,avtrnT120(1:9),...
              'LineWidth',lw,...
              'Color',[0.3010 0.7450 0.9330]);


T    = 150;
avtr = zeros(1,20);
for n = 1:20
    for j = 1:n  % numero de saltos hasta el hueco
        tr = j*T;
        while tr < T1
            tr = tr + (n+1)*T;
        end
        avtr(n) = avtr(n) + tr;
    end
    avtr(n) = avtr(n) / n;
end
avtrnT150 = avtr / t_cycle_conv_miss_app;
pT150av = plot(1:7,avtrnT150(1:7),...
               'LineWidth',lw,...
               'Color',[0 0.4470 0.7410]);


T    = 180;
avtr = zeros(1,20);
for n = 1:20
    for j = 1:n  % numero de saltos hasta el hueco
        tr = j*T;
        while tr < T1
            tr = tr + (n+1)*T;
        end
        avtr(n) = avtr(n) + tr;
    end
    avtr(n) = avtr(n) / n;
end
avtrnT180 = avtr / t_cycle_conv_miss_app;
pT180av = plot(1:5,avtrnT180(1:5),...
              'LineWidth',lw,...
              'Color',[0.9290 0.6940 0.1250]);






legend([pT60av,pT90av,pT120av,pT150av,pT180av],{'T=60','T=90','T=120','T=150','T=180'})
legend('Location','northeast')



