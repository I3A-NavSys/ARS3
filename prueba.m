% construimos la figura en caso de que se haya cerrado

% figura
figHandler = figure( ...
    'Name','prueba', ...
    'NumberTitle','off', ...%  'MenuBar', 'none', ...
    'Resize','on');

% eje 
axesHandler = axes(      ...
  'Parent', figHandler,  ...
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
for i = 1:length(WP)
    t = text(WP(i,1)+1000, WP(i,2), WP(i,3), WPlabels(i));
    t.FontSize = 8;
    t.Color = [0.5 0.5 0.5];
end

% Quito manejadores de puntos eliminados
ACptos = plot3(0,0,0,'o','MarkerEdgeColor','none','Tag','0','Visible','off');


runway_lar = convlength(2,'naut mi','m');  % longitud de pista
runway_anc = 60;                           % ancho de pista
runway_lat =   36.6845346944444;                 % latitud 
runway_lon =  -4.51259438888889;                 % longitud 
runway_alt =   0;                          % altura 
runway_ori = 133;    


% velocidad frente a tiempo
% en nudos
vel = [273	268	266	268	273	271	268	270	273	269	251	235	215	204	207	208	209	209	210	213	210	212	214	205	204	203	200	198	196	187	171	153	142	139	138];
tiempo = [0	30	47	67	98	129	148	179	195	213	243	262	282	299	318	349	380	396	424	443	463	481	497	528	544	574	605	621	651	681	711	741	765	833	849];


latitud = [370.673	370.829	370.901	370.910	370.898	370.888	370.885	370.879	370.875	370.871	370.869	370.825	370.676	370.534	370.355	370.055	369.762	369.610	369.337	369.172	369.015	368.894	368.789	368.585	368.485	368.295	368.101	367.998	367.812	367.638	367.472	367.329	367.215	366.927	366.861]/10;
longitud = [-44.458	-44.898	-45.133	-45.439	-45.938	-46.396	-46.713	-47.175	-47.442	-47.729	-48.161	-48.440	-48.612	-48.645	-48.610	-48.545	-48.483	-48.450	-48.386	-48.276	-48.141	-47.980	-47.833	-47.551	-47.412	-47.149	-46.882	-46.739	-46.480	-46.239	-46.010	-45.811	-45.656	-45.240	-45.147]/10;
altura = [2804	2583	2469	2385	2294	2217	2172	2134	2111	2019	1905	1844	1821	1829	1821	1821	1821	1821	1722	1623	1532	1448	1471	1501	1448	1280	1113	1029	861	732	572	434	365	99	38];
loquesea = [latitud;longitud;altura].';
for i =1:length(altura)
    XYZ = lla2flat(loquesea(i,:),[runway_lat runway_lon],0,0);
    latitud(i) = XYZ(1);
    longitud(i) = XYZ(2);
    altura(i) = -XYZ(3);
end
plot3(longitud,latitud,altura)
for i =1:length(altura)
    text(longitud(i),latitud(i),altura(i),num2str(tiempo(i)));
end

figure
plot(tiempo,vel)
