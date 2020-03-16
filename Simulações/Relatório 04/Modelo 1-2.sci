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

//E=[-pi/6,pi/4,L/5,0] // alpha, beta, sigma zero, sigma_ponto_zero
//E=[-pi/6,pi/6,L/5,0]
//E=[-pi/6,pi/4,L/5,0]
//E=[-pi/4,-pi/3,L/5,0]
E=[-pi/4,pi/4,L/5,0]

// Integração das equações diferenciais:

alfa = E(1)
betha=E(2)
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
f = poly([(sigma_zero - sigma) k1 0.5*k2], 't', 'coeff')
a = roots(f)

disp(a)
//Deu dois valores = +-t. Desprezo o tempo negativo:

tempo_quina = abs(a(1))

// Espaço de estados:
function [z_dot]=esp_est_sigma(t,z) //Espaço de estados para o sigma
    k=z(1,:)
    kdot=z(2,:)
    dk_dt= kdot //Primeira componente espaço de estados
    d2k_dt2= -g*sin(alfa) //Segunda componente espaço de estados
    z_dot=[dk_dt;d2k_dt2]
endfunction

// Crio o vetor tempo

tempo = 0:0.05:tempo_quina

// ODE:

M = E
X = ode([M(3);M(4)], 0, tempo, esp_est_sigma)

clf()
scf(0)
xtitle('Posição')
plot(tempo,X(1,:),'r')
scf(1)
xtitle('Velocidade')
plot(tempo,-X(2,:),'g')
/////////// FIM PARTE I ///////////
