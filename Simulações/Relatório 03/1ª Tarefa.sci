//Lista de exercício 3 - 1º Tarefa - (a),(b) e (c)
//Dados
pi = %pi
r = 0.001; // raio da esfera em metros
rho = 7850; //densidade do aço em kg/m^3
g = 9.8; //m/s^2
m = (4/3)*pi*(r^3)*7850 // massa em kg

//Condições iniciais
alfa = pi/6;
s0 = 1;
v0 = -1;
S0 = [s0;v0];

//Vetor tempo
t0 = 0;
tf = 100; //Vamos integrar pelo tempo de 0 a 20 segundos
dt = 0.01;  //Define o passo, quanto menor mais preciso
t = t0:dt:tf;

//Espaço de estados
function dS = f(t,s)
//s é o vetor de estado, ou seja, s = [s, ds/dt]
    dS1 = s(2);
    dS2 = g*sin(alfa);
    dS = [dS1; dS2];
endfunction
S = ode(S0,0,t,f);

//Energia Cinética
function cinetica = T(S)
    cinetica = (1/2)*m*(S(2,:))**2
endfunction

//Energia Potencial
function potencial = U(S)
    potencial = m*g*(S(1,$))*sin(alfa)-(S(1,:))*sin(alfa)*m*g
endfunction

//Energia Mecânica
function mecanica = E(U,T)
    mecanica = U+T
endfunction

//Aceleração
a = diff(S(2,:))/0.01;
a($+1) = a($)

//Força Normal
N = m*g*cos(alfa)*ones(1,size(t)(2))

//Função comet
x0 = 0;
z0 = 0;
z = -S(1,:)*sin(alfa)+z0;
x = S(1,:)*cos(alfa)+x0;

//Plotar gráficos
scf(0)
subplot(2,2,1)
xtitle('Posição por tempo');
plot(t, S(1,:), 'k');

subplot(2,2,2)
xtitle('Velocidade por tempo')
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
xtitle('Energia cinética por tempo')
plot(t, T(S))
subplot(2,2,2)
xtitle('Energia potencial por tempo')
plot(t, U(S), 'k')
subplot(2,2,3)
xtitle('Energia mecânica por tempo')
plot(t, U(S)+T(S), 'r')
subplot(2,2,4)
xtitle('Soma das energias')
plot(t, T(S))
xlabel('(i)','fontsize',1)
plot(t, U(S), 'k')
xlabel('(ii)','fontsize',1)
plot(t, U(S)+T(S), 'r')

scf(2)
subplot(2,3,1)
xtitle('Normal - Condição 01')
plot(t, N)