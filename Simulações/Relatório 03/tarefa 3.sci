clear
clc
//Lista de exercício 3 - 3º Tarefa
//Dados
pi = %pi
r = 0.001; // raio da esfera em metros
rho = 7850; //densidade do aço em kg/m^3
g = 9.8; //m/s^2
m = (4/3)*pi*(r^3)*7850 // massa em kg
R=1;//Raio da circunferencia geradora
//Condições iniciais
s0 = -1/10;
v0 = 0;
S0 = [s0;v0];
//Espaço de estados
function dS = f(t,s)
//s = [s, ds/dt]
    dS1 = s(2);
    dS2 = -g*s(1)/(4*R);
    dS = [dS1; dS2];
endfunction
t = linspace(0,0.5,10)
S = ode(S0,0,t,f);
//obtenção do cosseno de teta para cálculo de potencial
cosseno2=1-S(1,:)/(4*R)
cosseno1=2*cosseno2**2-1;
//Energia Cinética
function cinética = T(S)
    cinética = (1/2)*m*(S(2,:))**2
endfunction
//Energia Potencial
function potencial = V(S)
    potencial=m*g*(R-R*cosseno1)
endfunction
//Energia Mecânica
function mecanica=E(S)
    mecanica=V(S)+T(S)
endfunction
//Aceleração
a = diff(S(2,:))/0.5;
a($+1) = a($)
//Plotar gráficos
clf()
scf(0)
subplot(2,2,1)
xtitle('Posição por tempo');
plot(t, S(1,:), 'k');
subplot(2,2,2)
xtitle('Velocidade por tempo');
plot(t, S(2,:), 'k')
subplot(2,2,3)
xtitle('Velocidade por posição')
plot(S(1,:), S(2,:), 'k')
subplot(2,2,4)
xtitle('Aceleração em função do tempo')
plot(t, a, 'k')

scf(1)
xtitle('Energias')
subplot(2,2,1)
xtitle('Energia Cinética em função do tempo')
plot(t, T(S), 'b')
subplot(2,2,2)
xtitle('Energia Potencial em função do tempo')
plot(t, V(S), 'r')
subplot(2,2,3)
xtitle('Energia Mecânica em função do tempo')
plot(t, E(S), 'k')
subplot(2,2,4)
xtitle('Soma das energias')
plot(t, T(S))
plot(t, V(S), 'r')
plot(t, E(S), 'k')
