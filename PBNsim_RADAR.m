function [] = PBNsim_RADAR( u )
   
    global radar
    persistent firstIteration
    if(isempty(firstIteration))
        firstIteration = false;
        radar = RADARclass;
    end
    
    radar.checkFig();


    %% Cargo datos
    ACid      = u(1);
    ACenabled = u(2);
    ACdubins  = u(3);
    ACx       = u(4);
    ACy       = u(5);
    ACz       = u(6); 
    ACpsi     = u(7); 

    % Datos invalidos
    if (ACid == 0)
        return;
    end

    
    %Actualizo el punto en la pantalla del RADAR
    radar.updateACpto(ACid,ACenabled,ACdubins,ACx,ACy,ACz);
    
%     coder.extrinsic('get_param')
%     simtime = get_param('simulator','SimulationTime');

    


    
        
    

end
