//Lista de exercício 3 - 1º Tarefa
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


//Espaço de estados
function dS = f(t,s)
//s é o vetor de estado, ou seja, s = [s, ds/dt]
    dS1 = v0;
    dS2 = g*sin(alfa);
    dS = [dS1; dS2];
endfunction
t = linspace(0,0.5,10)
S = ode(S0,0,t,f);

//Energia Cinética
function cinética = T(S)
    cinética = (1/2)*m*(S(2,:))**2
endfunction

//Aceleração
a = diff(S(2,:))/0.5;
a($+1) = a($)
//Plotar gráficos
//Trajetória de M
clf();
scf(0)
Scomet=linspace(S(1,1),S(1,$),100);
comet(Scomet*cos(alfa)+1,2-Scomet*sin(alfa));
