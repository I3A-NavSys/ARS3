clear; clc;

figHandler = findobj('Type','figure','Name','AC distances')';
if isempty(figHandler)
    figure( ...
        'Name','AC distances', ...
        'NumberTitle','off',   ...
        'Position',[500 200 1000 400]); 
else
    figure(figHandler)
    clf
end

grid on
hold on
axis([300 2200 0 12000])
xlabel('time (s)')
ylabel('values (m)')


%%

% logAC5 = csvread("logACsLanding.csv");
% [lastTime,vDist,~,~,~,vZ] = dist2ACs(logAC5,5,30);
% 
% st = 5;
% plot(1:st:lastTime,vDist(1:st:lastTime),'.');
% plot(1:st:lastTime,   vZ(1:st:lastTime),'.');


%%
logAC5 = csvread("logAC5.90s.csv");
[lastTime,mDist,vAC,mXYZ] = dist2ACs(logAC5,5,30);
plot(1:lastTime,mDist(1,:),'LineWidth',2);
plot(1:lastTime,mXYZ(3,:),'LineWidth',2);

plot([1 lastTime],[5556 5556],'--k','LineWidth',1);
legend('distance','altitude','conflict');

% plot(1:lastTime,mDist(2,:),'LineWidth',2);
% plot(1:lastTime,mDist(3,:),'LineWidth',2);
% legend('3D distance','altitude','XY distance', 'Z distance');


%%

figHandler = findobj('Type','figure','Name','closest AC')';
if isempty(figHandler)
    figure( ...
        'Name','closest AC', ...
        'NumberTitle','off',   ...
        'Position',[550 250 1000 400]); 
else
    figure(figHandler)
    clf
end

plot(1:lastTime,vAC,'LineWidth',2)
grid on
axis([300 2200 0 14])
xlabel('time (s)')
ylabel('closest AC (id)')



% subplot(3,1,2)
% hold on
% grid
% axis([0 currentTime -40000 40000])
% plot(1:currentTime,vector_X,'LineWidth',2);
% 
% subplot(3,1,3)
% hold on
% grid
% axis([0 currentTime 0 60000])
% plot(1:currentTime,vector_Y,'LineWidth',2);




%%


function [lastTime,mDist,vAC,mXYZ] = dist2ACs(log,ACid,minA)
% log:  log de la simulación
%             1   2  3      4         5       6        7
%           TIME ID  S      X         Y       Z       PSI
%           0002,001,1,+31941.69,+57969.59,2133.60,-1.8494


% ACid: avion a analizar conflictos
% minA: altura mínima a la que dejar de detectar conflictos

    lastTime = log(end,1);
    
    vDist    = zeros(1,lastTime);   % vector de distancia más corta
    vDist(:) = inf;                 % euclídea
    vDXY(:)  = vDist;               % horizontal
    vDZ(:)   = vDist;               % vertical
        
    vAC    = zeros(1,lastTime);     % vector de aeronave a distancia mas corta
    vAC(:) = NaN; 
    vX     = vAC;
    vY     = vAC;
    vZ     = vAC;
    
    vConflict = zeros(1,lastTime);  % vector de detección de conflictos

    
    init = 1;
    while init < length(log)

        currentTime = log(init,1);
%         sameTime = find(log(:,1) == currentTime);
%         fin = max(sameTime);
        fin = find(log(:,1) == currentTime,1,'last');

        for i = init:fin-1
            if log(i,3) ~= 6
                continue            % Ignoramos avión de Dubins
            end
            iAC = log(i,4:6);

            for j = i+1:fin
                if log(j,3) ~= 6
                    continue        % Ignoramos avión de Dubins
                end
                jAC = log(j,4:6);

                if log(i,1) ~= log(j,1)
                    disp('error comparando tiempos distintos')
                    return
                end

                if iAC(3) < minA || jAC(3) < minA
                    % al menos un avión por debajo de la altura de control
                    % se omite comprobación
                    continue
                end

                d   = norm(iAC - jAC);
                dxy = norm(iAC(1:2) - jAC(1:2));
                dz  = abs(iAC(3) - jAC(3));
                d2  = norm(dxy, dz);
                
                
                if dxy<5556 && dz<304.8
                    % detección de conflicto
                    % disp('conflict')
                    vConflict(currentTime) = true;
                end
                
                
                if d > vDist(currentTime)
                    continue
                end

                if log(i,2) == ACid
                    vDist(currentTime) = d;
                    vDXY(currentTime)  = dxy;
                    vDZ(currentTime)   = dz;
                    vX(currentTime)    = log(i,4);
                    vY(currentTime)    = log(i,5);
                    vZ(currentTime)    = log(i,6);
                    vAC(currentTime)   = log(j,2);
                end
                if log(j,2) == ACid
                    vDist(currentTime) = d;
                    vDXY(currentTime)  = dxy;
                    vDZ(currentTime)   = dz;
                    vX(currentTime)    = log(j,4);
                    vY(currentTime)    = log(j,5);
                    vZ(currentTime)    = log(j,6);
                    vAC(currentTime)   = log(i,2);
                end
            end
        end

        init = fin+1;
    end
    
    mDist = [vDist; vDXY; vDZ];
    mXYZ  = [vX; vY; vZ];

end
