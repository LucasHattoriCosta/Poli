clc
clear

// Características do sistema:

pi = %pi

// Item B
ro = 0.1 // kg/m
g = 9.80 // m/s²
l = 0.5 // m
comp = 2*l // m

L = 10 // m
m = comp*ro

// Condições iniciais:

//E=[-pi/6,pi/4,L/5,0] // alpha, beta, lambda zero, lambda_ponto_zero
//E=[-pi/6,pi/6, comp, 4.5]
//E=[-pi/6,pi/4,L/5,0]
//E=[-pi/4,-pi/3,L/5,0]
E=[-pi/4,-pi/2,comp,-4.5]


///////// INÍCIO PARTE II /////////

// alpha, beta, sigma zero, sigma_ponto_zero
//t0_p2 = tempo_quina
alfa = E(1)
betha = E(2)

function [z2_dot]=esp_est_sigma_II(t,z) //Espaço de estados para o lambda
    k=z(1,:)
    kdot=z(2,:)
    dk_dt= kdot //Primeira componente espaço de estados
    d2k_dt2= g*(sin(betha) + (1/(2*l))*(sin(alfa)-sin(betha))*(k))//Segunda componente espaço de estados - em relação ao ponto M
    z2_dot=[dk_dt;d2k_dt2]
endfunction

tempo_2 = 0:0.005:10

M = E
X = ode([E(3);E(4)], 0, tempo_2, esp_est_sigma_II)

x = X(1,:) //Vetor de deslocamentos
xp = X(2,:) //Vetor de velocidades


[nk, nc] = size(X)

for k=1:nc
    if x(k)<0 then
        disp(k)
        disp(tempo_2(k))
        break
    end
end

X_linha = [x(1:k);xp(1:k)] // O vetor [pos, vel] fatiado até o primeiro termo negativo de posição, quando o P passou pela quina.

x_linha = X_linha(1,:)//Novos vetores de velocidade e posição
xp_linha = X_linha(2,:)

tempo_2b = 0:tempo_2(k)/(k-1):tempo_2(k)


disp(size(tempo_2b))

scf(0)
plot(tempo_2b, x_linha,'r')
scf(1)
plot(tempo_2b, xp_linha,'g')

//como ï - g*(sin(betha) + (1/(2*l))*(k)*(sin(alfa)-sin(betha))) = 0
//isolo: ï = g*(sin(betha) + (1/(2*l))*(k)*(sin(alfa)-sin(betha)))

// Pela 'equação do sorvetão':
// sigma = sigma_zero + sigma_zero_ponto . t + 1/2 . (g.sin(a)).t^2
// sigma = sigma_zero + sigma_zero_ponto . t + 1/2 . (-ö).t^2
// 0 = t^2 .[1/2.(-z_dot(2))] + t .[z_dot(1)] + (sigma_zero - sigma)

//k1_2 = sigma_ponto_zero_2 //
//k2_2 = g*((sin(betha) + (1/(2*l))*(k)*(sin(alfa)-sin(betha))))
//f_2 = poly([0.5*k2_2 k1_2 (sigma_zero_2 - sigma_2)], 't', 'coeff')//
//a_2=roots(f_2)//

//Deu dois valores = +-t. Desprezo o tempo negativo:

//tempo_quina = abs(a_2(1))
