clc;
fig = figure;
grid on
hold on
axis([0 0.5 0.6 0.9])
%xlabel ('reducción de productividad')
xlabel ('capacity reduction')
%ylabel ('ahorro en tiempo de reinyección')
ylabel ('time saving')




X = prod(2:end)./60;
X = 1 - X;



benT60   = 1 - avtrnT60(2:end);
pT60     = plot(X,benT60,...
                'LineWidth',lw,...
                'Color',[0.8500 0.3250 0.0980]);


            
benT90   = 1 - avtrnT90(2:13);
pT90     = plot(X(1:12),benT90,...
                'LineWidth',lw,...
                'Color',[0.4940 0.1840 0.5560]);

     

benT120  = 1 - avtrnT120(2:10);
pT120    = plot(X(1:9),benT120,...
                'LineWidth',lw,...
                'Color',[0.3010 0.7450 0.9330]);



benT150  = 1 - avtrnT150(2:8);
pT150    = plot(X(1:7),benT150,...
                'LineWidth',lw,...
                'Color',[0 0.4470 0.7410]);



benT180  = 1 - avtrnT180(2:6);
pT180    = plot(X(1:5),benT180,...
                'LineWidth',lw,...
                'Color',[0.9290 0.6940 0.1250]);



legend([pT60,pT90,pT120,pT150,pT180],{'T=60','T=90','T=120','T=150','T=180'})
legend('Location','southeast')


