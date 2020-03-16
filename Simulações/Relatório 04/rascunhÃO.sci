clc
clear

// Características do sistema:

pi = %pi
ro = 0.1 // kg/m
g = 9.80 // m/s²
l = 0.5 // m
comp = 2*l // m
L = 10 // m
m = comp*ro

// Condições iniciais:

//E=[-pi/6,pi/4,L/5,0,comp] // alpha, beta, sigma zero, sigma_ponto_zero, lambda_zero
//E=[-pi/6,pi/6,L/5,0,comp]
//E=[-pi/6,pi/4,L/5,0,comp]
//E=[-pi/4,-pi/3,L/5,0,comp]
E=[-pi/4,pi/4,10,0]

// Integração das equações diferenciais:

alfa = E(1)
betha =E(2)
sigma_zero = E(3)
sigma_ponto_zero = E(4)
sigma = 9.5 //coordenada da quina na abcissa curvilínea

////////////////// PARTE I _MAPA DO TESOURO_ ////////////////////

//como ö + g.sin(a) = 0
//isolo: g.sin(a) = -ö

// Pela 'equação do sorvetão':
// sigma = sigma_zero + sigma_zero_ponto . t + 1/2 . (g.sin(a)).t^2
// sigma = sigma_zero + sigma_zero_ponto . t + 1/2 . (-ö).t^2
// 0 = t^2 .[1/2.(-z_dot(2))] + t .[z_dot(1)] + (sigma_zero - sigma)

k1 = sigma_ponto_zero
k2 = -g*sin(alfa)
//(sigma_zero - sigma)
f = poly([(sigma_zero - sigma) k1 0.5*k2], 't', 'coeff')
a = roots(f)

//Deu dois valores = +-t. Desprezo o tempo negativo:

tempo_quina = abs(a(1))
disp(tempo_quina)

// Espaço de estados:
function [z_dot]=esp_est_sigma(t,z) //Espaço de estados para o sigma
    k=z(1,:)
    kdot=z(2,:)
    dk_dt= kdot //Primeira componente espaço de estados
    d2k_dt2= -g*sin(alfa) //Segunda componente espaço de estados
    z_dot=[dk_dt;d2k_dt2]
endfunction

// Crio o vetor tempo

tempo = 0:0.005:tempo_quina

// ODE:

M = E
X_1 = ode([M(3);M(4)], 0, tempo, esp_est_sigma)
x_1 = X_1(1,:)
xp_1 = X_1(2,:)

a_1 = diff(xp_1)/0.005
a_1($+1) = a_1($)

/////////// FIM PARTE I ///////////

////////// PARTE II_A PARTE DIFÍCIL////////////
function [z2_dot]=esp_est_sigma_II(t,z) //Espaço de estados para o lambda
    k=10.5 - z(1,:)
    kdot=z(2,:)
    dk_dt= kdot
    d2k_dt2= -g*(sin(betha) + (1/(2*l))*(sin(alfa)-sin(betha))*(k))
    z2_dot=[dk_dt;d2k_dt2]
endfunction

tempo_2 = 0:0.005:10

X_2 = ode([x_1(1,$);xp_1(1,$)], 0, tempo_2, esp_est_sigma_II)

x_2 = X_2(1,:) //Vetor de deslocamentos
xp_2 = X_2(2,:) //Vetor de velocidades

a_2 = diff(xp_2)/0.005
a_2($+1) = a_2($)

[nk, nc] = size(X_2)

for k=1:nc
    if x_2(k) > 10.5 then
        disp(tempo_2(k))
        break
    end
end

x_2_final = x_2(1:k-1)
xp_2_final = xp_2(1:k-1)
a_2_final = a_2(1:k-1)
tempo_2b = 0:tempo_2(k)/(k-1):tempo_2(k)

//////////// END PARTE II //////////////////////

/////////// PARTE III //////////////
function [z_dot]=esp_est_sigma_III(t,z) //Espaço de estados para o sigma
    k=z(1,:)
    kdot=z(2,:)
    dk_dt= kdot //Primeira componente espaço de estados
    d2k_dt2= -g*sin(betha) //Segunda componente espaço de estados
    z_dot=[dk_dt;d2k_dt2]
endfunction

tempo_3 = tempo_2(k):0.005:10

X_3 = ode([x_2_final(1,$);xp_2_final(1,$)], 0, tempo_3, esp_est_sigma_III)
x_3 = X_3(1,:)
xp_3 = X_3(2,:)
a_3 = diff(xp_3)/0.005
a_3($+1) = a_3($)

//////

////// VETORZÃO ////
Xzão = cat(2,x_1,x_2_final, x_3)
Xzão_ponto = cat(2,xp_1,xp_2_final, xp_3)
azão = cat(2, a_1, a_2_final, a_3)
tempozão = 0:10/(size(Xzão)(2)-1):10

///// PLOTS ///////////////
clf()
scf(0)
subplot(2,2,1)
plot(tempozão, Xzão)
subplot(2,2,2)
plot(tempozão, Xzão_ponto)
subplot(2,2,3)
plot(tempozão, azão)
