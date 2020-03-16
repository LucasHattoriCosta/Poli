//Tarefa 1 - Flavius

//Condições iniciais
pi=%pi
g=9.8 //Gravidade em m/s
R=3 //Raio do tubo (m)
l = 0.5 //Semicomprimento da corrente (m)
c = 0.1 //Coeficiente de atrito viscoso (kg/m*s)
ro = 0.1 //Densidade linear da corrente (kg/m)
m = ro*2*l //Massa total da corrente (kg)

//Espaço de estados
function [y_dot]=deriva(t,y0)
    k=y0(1,:)
    kdot=y0(2,:)
    dk_dt=kdot
    d2k_dt2=-((g*R*(cos((k-l)/R)-cos((k+l)/R)))/(2*l))-(2*l*c*kdot)
    y_dot=[dk_dt;d2k_dt2]
endfunction

//Item a
//1)
theta=-pi/4
theta_dot=0
sigma=theta*R
sigma_dot=theta_dot*R

//Tempo
t0=0
dt=0.005
tf=100
t=t0:dt:tf

//Integrações
X = ode([sigma;sigma_dot],t0,t,deriva)

//1) theta(t)
clf()
scf(0)
subplot(2,2,1)
title('Posição angular em função do tempo')
xlabel('t(s)')
ylabel('theta(rad)')
plot(t,X(1,:)/R)

//2) theta_dot(t)
subplot(2,2,2)
title('Velocidade angular em função do tempo')
xlabel('t(s)')
ylabel('Velocidade angular(rad/s)')
plot(t,X(2,:)/R)

//3) theta_dot2(t)
subplot(2,2,3)
title('Aceleração angular em função de tempo')
xlabel('t(s)')
ylabel('Aceleração angular(m/s²)')
plot(t,(-((g*R*(cos((X(1,:)-l)/R)-cos((X(1,:)+l)/R)))/(2*l))-(2*l*c*X(2,:)))/R)

//7) theta_dot=theta_dot(theta)
subplot(2,2,4)
title('Velocidade angular em função de theta')
xlabel('theta(rad)')
ylabel('Velocidade angular(rad/s)')
plot(X(1,:)/R,X(2,:)/R)

//4) T=T(t) Energia Cinética
T = ro*l*(X(2,:)**2)
scf(1)
title('Energia cinética em função do tempo')
xlabel('t(s)')
ylabel('T(J)')
plot(t,T,'r')

//5) V=V(t)
V=m*g*R*(1-cos(X(1,:)/R))
title('Energia potencial em função do tempo')
xlabel('t(s)')
ylabel('V(J)')
plot(t,V,'g')

//6) Energia total
title('Energia mecânica em função do tempo')
xlabel('t(s)')
ylabel('E(J)')
plot(t,V + T)


xs2png(0,'Q3ib1p1')
xs2png(1,'Q3ib1p2')
