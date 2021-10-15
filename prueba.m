
clc
clear

h  = [0  1];
xw = [0  10];

lado(xw,h)
a = angulo(xw,h)


function lado(V1,V2)
% angulo para alcanzar desde V1 a V2
% sentido positivo contrario a las agujas del reloj
% angulo de salida (-180 +180]

    prod_vec = V1(1)*V2(2) - V1(2)*V2(1);
    if prod_vec == 0
        disp('centro')
    else
        disp(sign(prod_vec))
    end
end

function a = angulo(V1,V2)
% angulo para alcanzar desde V1 a V2
% sentido positivo contrario a las agujas del reloj
% angulo de salida (-180 +180]

    V1 = V1 / norm(V1);
    V2 = V2 / norm(V2);

    prod_esc = V1(1)*V2(1) + V1(2)*V2(2);
    if prod_esc > 1
        prod_esc = 1;
    end
    if prod_esc < -1
        prod_esc = -1;
    end
    a1 = acosd(prod_esc);

    prod_vec = V1(1)*V2(2) - V1(2)*V2(1);
    a2 = asind(prod_vec);
    
    a = a1*sign(a2);
    
end
