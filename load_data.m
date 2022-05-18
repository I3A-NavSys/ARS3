function points = load_data(xslx_name,airspace,runway_coords)
    % TODO: meter explicación de los parámetros y formato del excel
    % points:
    % Cada sheet genera una tabla como esta:
    % Time  X   Y   Z  Speed wpNext  
    % (s)  (m) (m) (m) (m/s) {2,3...}
    if length(airspace)~=4 ||airspace(1)<airspace(2) || airspace(3)<airspace(4)
        error("The second parameter should be a 1x4 vector containing, respectively, the max. and min. latitude of the airspace, and the max. and min. longitude of the airspace");
    end
    if length(runway_coords)~=2 ||airspace(1)<airspace(2) || airspace(3)<airspace(4)
        error("The third parameter should be a 1x2 vector containing, respectively, the latitude and the longitude of the runway.");
    end
    
    sheets = sheetnames(xslx_name);
    %points = cell(1,length(sheets));
    points = zeros(0,7);

    %emptyPoint = struct(               ...
    %   'pos',[0 0 0],                ...
    %   'speed',0,'next',0,'time',0);

    for i = 1:length(sheets)
        rawPoints = readtable(xslx_name,'Sheet',sheets(i));
        % Eliminamos los puntos fuera de nuestro espacio aéreo
        rawPoints = rawPoints( ...
            rawPoints.Latitud<airspace(1) ...
            & rawPoints.Latitud>airspace(2) ...
            & rawPoints.Longitud<airspace(3) ...
            & rawPoints.Longitud>airspace(4),:);
        nPoints = height(rawPoints);
        %points{i} = repmat(emptyPoint,nPoints,1);
        points_i = zeros(nPoints,7);
        
        % tiempo en segundos; 
        % TODO: de momento asumimos que no se cambia de día ni de PM-AM, habrá que tocarlo 
        % luego
        cero = str2double(rawPoints.Horario{1}(5:6))*3600 + ...
               str2double(rawPoints.Horario{1}(8:9))*60   + ...
               str2double(rawPoints.Horario{1}(11:12));
        %points{i}(1).time = 0;
        points_i(1,1) = 0;
        for j = 2:nPoints
            points_i(j,1) = str2double(rawPoints.Horario{j}(5:6))*3600 + ...
                            str2double(rawPoints.Horario{j}(8:9))*60   + ...
                            str2double(rawPoints.Horario{j}(11:12))    - ...
                            cero;
        end
        % coordenadas respecto a la pista de aterrizaje
        coord = [rawPoints.Latitud,rawPoints.Longitud,rawPoints.metros];
        for j =1:nPoints
            XYZ = lla2flat(coord(j,:),runway_coords,0,0);
%             points{i}(j).pos(1) =  XYZ(2);
%             points{i}(j).pos(2) =  XYZ(1);
%             points{i}(j).pos(3) = -XYZ(3);
            points_i(j,2) =  XYZ(1);
            points_i(j,3) =  XYZ(2);
            points_i(j,4) = -XYZ(3);
        end
        % velocidad en m/s
        for j = 1:nPoints
            %points{i}(j).speed = rawPoints.km_h*1000/3600;
            points_i(i,5) = rawPoints.km_h*1000/3600;
        end
        % wpID and wpNext
        for j = 1:nPoints-1
            %points{i}(j).next = j+1;
            points_i(j,6) = j+1;
        end
        %points{i}(nPoints).next = 0;
        points_i(nPoints,6) = 0;
        points_i(:,7) = i;
        points = [points;points_i];
    end
end
