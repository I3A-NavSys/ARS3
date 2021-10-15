classdef RADARclass < handle
properties

    %figura del radar
    figName;
    figHandler;
    figPosition;
    
    %lista de puntos en pantalla
    ACptos;

end
methods(Static)

function obj = RADARclass()
    obj.figName = 'RADAR';
    obj.figHandler = findobj('Type','figure','Name',obj.figName)';
    if (isempty(obj.figHandler)) 
        obj.figPosition(1:2) = [500 100];   % asignamos la posición deseada
        obj.figPosition(3:4) = [700 700];   % asignamos el tamaño deseado
    else
        obj.figPosition = get(obj.figHandler,'Position');
        delete(obj.figHandler);
    end
end

end
methods

function checkFig(obj)
    % construimos la figura en caso de que se haya cerrado
    obj.figHandler = findobj('Type','figure','Name',obj.figName)';
    if ~isempty(obj.figHandler)
        return
    end
    
    % figura
    obj.figHandler = figure( ...
        'Name',obj.figName, ...
        'NumberTitle','off', ...%  'MenuBar', 'none', ...
        'Position',obj.figPosition, ...
        'Resize','on');

    % eje 
    axesHandler = axes(      ...
      'Parent', obj.figHandler,  ...
      'Units','normalized', ...%   'Position',[0.0800 0.0800 0.9000 0.9000], ...
      'Visible','on');
    xlabel('longitude (meters)')
    ylabel('latitude  (meters)')
    zlabel('altitude  (meters)')
    grid(axesHandler,'on')
    hold(axesHandler,'on')
    axis([-40000 +40000 -10000 +70000 0 3000]) % para Málaga
%    axis([-40000 +60000 -30000 +70000 0 3000]) % para Málaga ampliado
%   axis([-70000 +30000 -30000 +70000 0 4000]) % para Houston

    % runway
    global runway_pts
    hRW = patch(axesHandler,      ...
       'Vertices', runway_pts,    ...
       'Faces',    [1 2 3 4],     ...
       'FaceColor',[0.5 0.5 0.5], ...
       'EdgeColor',[0.5 1   0.5], ...
       'LineWidth', 3);
      %'LineStyle','none',        
   
    % waypoints
    global WP WPlabels
    line(WP(2:7,1), WP(2:7,2), WP(2:7,3), 'linewidth', 2); % para Málaga
%    line(WP(3:8,1), WP(3:8,2), WP(3:8,3),'linewidth', 2); % para Houston
    for i = 1:length(WP)
        t = text(WP(i,1)+1000, WP(i,2), WP(i,3), WPlabels(i));
        t.FontSize = 8;
        t.Color = [0.5 0.5 0.5];
    end
    
    % Quito manejadores de puntos eliminados
    obj.ACptos = plot3(0,0,0,'o','MarkerEdgeColor','none','Tag','0','Visible','off');
        
end
    
    
function updateACpto(obj,ACid,ACenabled,ACdubins,ACx,ACy,ACz)
    %Actualiza un punto en la pantalla del RADAR
    %Buscamos el punto correspondiente a este avion
    ACfound = false;
    ACid2 = num2str(ACid);
    if ACdubins
        ACid2 =strcat(ACid2,'d');
    end
    for i = 1:length(obj.ACptos)
        if strcmp(ACid2,obj.ACptos(i).Tag)
            ACfound = true;            
            break
        end
    end
    
    %Gestionamos el punto
    if (ACenabled)
        if (~ACfound)
            % Crea un nuevo punto
            if ACdubins
                ACpto = plot3(ACx,ACy,ACz,'o',...
                              'MarkerEdgeColor','red',...
                              'MarkerFaceColor','none',...
                              'Tag',ACid2);
            else
                ACpto = plot3(ACx,ACy,ACz,'o',...
                              'MarkerEdgeColor','none',...
                              'MarkerFaceColor','red',...
                              'Tag',ACid2);
            end
            obj.ACptos = [obj.ACptos ACpto];
        else        
            % Pintamos la estela del punto
%             if ACid == 5
%                 plot3([obj.ACptos(i).XData ACx],...
%                       [obj.ACptos(i).YData ACy],...
%                       [obj.ACptos(i).ZData ACz],...
%                        'Color','black');
%             end               

%  if ACdubins
%             plot3(ACx,ACy,ACz,'.','Color','red');
%  else
%             plot3(ACx,ACy,ACz,'.','Color','blue');
%  end
 
 
            % Actualiza la posición del punto
            obj.ACptos(i).XData = ACx;
            obj.ACptos(i).YData = ACy;
            obj.ACptos(i).ZData = ACz;         
%            text(ACx,ACy,ACz,num2str(ACid),'HorizontalAlignment','left','FontSize',8);
        end
    else
        if (ACfound)
            % borra el punto
            delete(obj.ACptos(i));
            obj.ACptos = [obj.ACptos(1:i-1) obj.ACptos(i+1:length(obj.ACptos))];
        end
    end

    %Redibuja la escena
    drawnow limitrate nocallbacks;


end
    


end % methods
end % classdef

