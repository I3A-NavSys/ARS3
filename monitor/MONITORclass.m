classdef MONITORclass < handle
properties
    
    % log:  log de la simulación
    % 1       2     3   4           5           6          7       8
    % TIME    ID    S   posX        posY        posZ       psi     Vhor
    % 00001 , 001 , 1 , +31941.69 , +57969.59 , +2133.60 , -1.85 , 123.47 
    log;
    
    % cantidad de entradas del log
    numRows;
        
    % tiempo de la ultima entrada del log
    lastTime;

end
methods(Static)
function obj = MONITORclass(filename)
    
    obj.log = csvread(filename);
    obj.numRows  = length(obj.log);
    obj.lastTime = obj.log(end,1);
    
end
end

methods

function [posX,posY,posZ,psi,Vhor,Acel] = ACinfo(obj,ACid,isDubins)

% ACid: avion a analizar seguimiento
% isDubins: diferencia entre aviones reales y referencias Dubins
% vectores de datos de la aeronave monitorizada

   
    % vectores de posición de la aeronave ACid
    posX      = zeros(1,obj.lastTime);   
    posX(:)   = inf;        % -eje X
    posY      = posX;       % -eje Y
    posZ      = posX;       % -eje Z
    psi       = posX;       % -rotacion Psi
    Vhor      = posX;       % -velocidad horizontal
    Acel      = posX;       % -aceleracion
    
    for i = 1:obj.numRows
        if obj.log(i,2) ~= ACid
            continue
        end
        if isDubins 
            if obj.log(i,3) == 6
                continue
            end
        else
            if obj.log(i,3) ~= 6
                continue
            end
        end
        
        iAC = obj.log(i,4:9);

        currentTime = obj.log(i,1);
        posX(currentTime)    = iAC(1);
        posY(currentTime)    = iAC(2);
        posZ(currentTime)    = iAC(3);
        psi(currentTime)     = iAC(4);
        Vhor(currentTime)    = iAC(5);
        Acel(currentTime)    = iAC(6);
        %Acel(currentTime)    = 0;
    end
end


    
function [dist,distXY,distZ] = dist2ref(obj,ACid)
% ACid: avion a analizar seguimiento
%
% lastTime: tiempo de la ultima entrada del log
% mDist: matriz de distancias [vDist; vDXY; vDZ] entre la aeronave monitorizada y su referencia Dubins
% mAC:  matriz de AC [vX; vY; vZ; ] de la aeronave monitorizada

    [posX, posY, posZ, psi, Vhor]  = obj.ACinfo(ACid,false);
    [posXd,posYd,posZd,psid,Vhord] = obj.ACinfo(ACid,true);

    
    % vectores de distancia más corta
    distXY = sqrt((posX-posXd).^2 + (posY-posYd).^2);
    distZ  = abs(posZ - posZd);
    dist   = sqrt(distXY.^2 + distZ.^2);
    

end



function [dist,distXY,distZ,closestAC,conflicts] = dist2ACs(obj,ACid,minA)
% ACid: avion a analizar conflictos
% minA: altura mínima a la que dejar de detectar conflictos
%
% mDist: matriz de distancias [vDist; vDXY; vDZ] entre la aeronave monitorizada y la mas proxima

   
    % vectores de distancia más corta
    dist       = zeros(1,obj.lastTime);   
    dist(:)    = inf;                 % -euclídea
    distXY(:)  = dist;               % -horizontal
    distZ(:)   = dist;               % -vertical
        
    % vector de aeronave a distancia mas corta
    closestAC      = zeros(1,obj.lastTime);   
    closestAC(:)   = NaN; 
    
    % vector de detección de conflictos
    conflicts = zeros(1,obj.lastTime);  
    
    
    
    init = 1;
    while init < obj.numRows

        currentTime = obj.log(init,1);
        fin = find(obj.log(:,1) == currentTime,1,'last');

        for i = init:fin-1
            if obj.log(i,3) ~= 6
                continue            % ignoramos avión de Dubins
            end

            for j = i+1:fin
                if obj.log(j,3) ~= 6
                    continue        % ignoramos avión de Dubins
                end
                
                if (obj.log(i,2) ~= ACid) && (obj.log(j,2) ~= ACid)
                    continue        % ignoramos pares que no incluyen al ACid
                end
                
                if obj.log(i,1) ~= obj.log(j,1)
                    disp('error comparando tiempos distintos')
                    return
                end
                
                % Evaluamos par de aeronaves
                iAC = obj.log(i,4:6);
                jAC = obj.log(j,4:6);

                if iAC(3) < minA || jAC(3) < minA
                    % al menos un avión por debajo de la altura de control
                    % se omite comprobación
                    continue
                end
                
                %Calculo distancia entre aviones
                d   = norm(iAC - jAC);
                dxy = norm(iAC(1:2) - jAC(1:2));
                dz  = abs(iAC(3) - jAC(3));
                
                % verifico si existe conflicto: 3NM y 1000ft
                if dxy<5556 && dz<304.8        
                    disp('conflict')
                    conflicts(currentTime) = true;
                end
                
                % actual distancia más corta que la registrada?
                if d > dist(currentTime)
                    continue
                end

                % actual distancia más corta que la registrada: reemplazo
                dist(currentTime)   = d;
                distXY(currentTime) = dxy;
                distZ(currentTime)  = dz;
                if obj.log(i,2) == ACid
                    closestAC(currentTime)   = obj.log(j,2);
                else
                    closestAC(currentTime)   = obj.log(i,2);
                end
            end
        end

        init = fin+1;
    end
    
end





end % methods
end % classdef

