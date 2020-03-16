//Tarefa 2 - Flavius
clc()
clear()

//Condições iniciais
pi=%pi
g=9.8 //Gravidade em m/s
r=1e-3 //Raio da esfera
ro=7850 //Densidade da esfera
vol=(4/3)*pi*r^3 //Volume da esfera
m=ro*vol //Massa da esfera
R=1 //Raio do tubo (m)

//Item a
//Espaço de estados
function [y_dot]=deriva(t,y0)
    k=y0(1,:)
    kdot=y0(2,:)
    dk_dt=kdot
    d2k_dt2=-(g/R)*sin(k)
    y_dot=[dk_dt;d2k_dt2]
endfunction
//Item e
//4)
theta0=5*pi/6
theta_dot0=0
theta = -5*pi/6:(5*pi/3)/200:5*pi/6
a=(R*theta_dot0)**2/(2*g)+R*sin(theta0)

//Tempo
t0=0
dt=0.05
tf=10
t=t0:dt:tf

//Integrações
X = ode([theta0;theta_dot0],t0,t,deriva)
Y = integrate('R/sqrt(2*g*(a-R*sin(theta)))','theta',0,theta)
disp(length(X(1,:)))
disp(length(Y)) 
//1) theta(t)
clf()
scf(0)
subplot(121)
title('theta=theta(t)')
xlabel('t(s)')
ylabel('theta(rad)')
plot(t,X(1,:))

//2) t(theta)
subplot(122)
title('t=t(theta)')
xlabel('theta(rad)')
ylabel('t(s)')
plot(X(1,:),Y)

    

disp(2*(max(Y)-min(Y)))
