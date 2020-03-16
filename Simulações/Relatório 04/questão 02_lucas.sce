clc
clear

// Definição dos Parametros e Constantes Físicas
ro=0.1 // kg/m
g=9.80 //m/s2
pi=%pi
R=3 //m
c = 0.1
l1=0.5 //m
m1 = 2*l1*ro
alpha = l1/R
L = 2*l1

//Vetor estado inicial E = [theta;velocidade]
E1 = [0,3.64]

// Função ODE
function [z_dot]=deriva1(t, z) //Pega a matriz z e deriva em relação a t
 dk_dt= z(2)
 d2k_dt2= -(g/R)*(sin(alpha)/alpha)*sin(z(1)) - L*c*dk_dt
 z_dot=[dk_dt;d2k_dt2]
endfunction

//Vetor Tempo
t0 = 0
dt = 0.2
tf = 100
t = t0:dt:tf

//Solução
X = ode([E1(1);E1(2)], 0, t, deriva1)

//Aceleração
a = diff(X(1,:))/dt
a($+1) = a($)

//Energias


//Plano de fases
scf(0)
subplot(2,2,1)
xtitle('Theta em função do tempo')
plot(t,X(1,:))
subplot(2,2,2)
xtitle('Velocidade angular em função do tempo')
plot(t,X(2,:))
subplot(2,2,3)
xtitle('Aceleração angular em função do tempo')
plot(t,a)
subplot(2,2,4)
xtitle('Plano de fases')
plot(X(1,:),X(2,:))

scf(1)
subplot(2,2,1)
xtitle('Energia potencial em função do tempo')
plot(t,V, 'r')
subplot(2,2,2)
xtitle('Energia cinética em função do tempo')
plot(t,T, 'g')
subplot(2,2,3)
xtitle('Energia Mecânica em função do tempo')
plot(t,E, 'k')
subplot(2,2,4)
xtitle('Energias em função do tempo')
plot(t,V,'r')
plot(t,T,'g')
plot(t,E,'k')
