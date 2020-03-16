//Lista de exercício 3 - 2º Tarefa
//Dados
pi = %pi
l = 0.001; // semi-comprimento da corrente
r = 3; // raio da pista circular
rho = 0.1; //densidade linear da corrente
g = 9.8; //m/s^2
m = rho*2*l // massa em kg


//Condições iniciais
alpha = l/r
theta_inicial = pi/2;
w0 = 0;
theta0 = [theta_inicial;w0];


//Vetor tempo
t0 = 0;
tf = 10; //Vamos integrar pelo tempo de 0 a 20 segundos
dt = 0.01;  //Define o passo, quanto menor mais preciso
t = t0:dt:tf;

//Espaço de estados
function dtheta = f(t,v)
//s é o vetor de estado, ou seja, s = [s, ds/dt]
    dtheta1 = v(2,:);
    dtheta2 = -(g/r)*(sin(alpha)/alpha)*sin(v(1,:));
    dtheta = [dtheta1; dtheta2];
endfunction
theta = ode(theta0,t0,t,f);
o = theta(1,:)
op = theta(2,:)

//Energia Cinética
function cinética = T(S)
    cinética = (1/2)*m*(theta(2,:))**2
endfunction

//Energia Potencial
function potencial = U(S)
    potencial = m*g*(theta(1,$))*sin(alfa)-(theta(1,:))*sin(alfa)*m*g
endfunction

//Energia Mecânica
function mecanica = E(U,T)
    mecanica = U+T
endfunction

//Aceleração
a = diff(theta(2,:))/0.01;
a($+1) = a($)

//Força Normal
N = m*g*cos(alfa)*ones(1,size(t)(2))

//Plotar gráficos
clf();
scf(0);
xtitle('Posição por tempo');
plot(t, o, 'r');

scf(1)
xtitle('Velocidade por tempo')
plot(t, op, 'b')

scf(6)
xtitle('Velocidade por posição')
plot(S(1,:), S(2,:), 'b')

scf(2)
xtitle('Aceleração em função do tempo')
plot(t, a)

scf(3)
xtitle('Energia cinética em função do tempo')
plot(t, T(S))

scf(4)
xtitle('Energia potencial em função do tempo')
plot(t, U(S))

scf(5)
xtitle('Energia mecânica em função do tempo')
plot(t, E(T(S),U(S)))

scf(7)
xtitle('Força normal por tempo')
plot(t, N)



