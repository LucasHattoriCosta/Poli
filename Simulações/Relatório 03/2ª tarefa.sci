//Lista de exercício 3 - 2º Tarefa
//Dados
pi = %pi;
r_e = 0.001; // raio da esfera em metros
r = 1; // raio da pista circular
rho = 7850; //densidade do aço em kg/m^3
g = 9.8; //m/s^2
m = (4/3)*pi*(r_e^3)*7850 // massa em kg


//Condições iniciais
theta_inicial = -pi/180;
w0 = 0;
theta0 = [theta_inicial;w0];
    

//Vetor tempo
t0 = 0;
tf = 10; //Vamos integrar pelo tempo de 0 a 10 segundos
dt = 0.01;  //Define o passo, quanto menor mais preciso
t = t0:dt:tf;

//Espaço de estados
function dtheta = f(t,v)
//s é o vetor de estado, ou seja, s = [s, ds/dt]
    dtheta1 = v(2);
    dtheta2 = -g*sin(v(1))/r;
    dtheta = [dtheta1; dtheta2];
endfunction
theta = ode(theta0,0,t,f);

//Energia Cinética
function cinética = T(S)
    cinética = (1/2)*m*(S(2,:))**2
endfunction

//Aceleração angular
a = diff(theta(2,:))/0.01;
a($+1) = a($)

//Energia potencial
function potencial = V(S)
    potencial = m*g*r*(1-cos(S(1,:)))
endfunction

//Força Normal
function normal = N(S)
    normal = m*(r*S(2,:)**2) + g*cos(S(1,:))
endfunction
//Plotar gráficos

clf()
scf(0)
xtitle('Força normal em função do tempo', 'Tempo (s)','Força Normal (N)' );
plot(t, N(theta))
///scf(0)
scf(1)
subplot(2,2,1)
xtitle('Posição angular por tempo');
plot(t, theta(1,:), 'k');
subplot(2,2,2)
xtitle('Velocidade angular por tempo');
plot(t, theta(2,:), 'k');
subplot(2,2,3)
xtitle('Plano de fases do movimento');
plot(theta(1,:), theta(2,:), 'k');
subplot(2,2,4)
xtitle('Aceleração angular em função do tempo');
plot(t, a, 'k');

///scf(1)
xtitle('Energias')
subplot(2,2,1)
xtitle('Energia cinética por tempo');
plot(t, T(theta));
subplot(2,2,2)
xtitle('Energia potencial por tempo');
plot(t, V(theta), 'r');
subplot(2,2,3)
xtitle('Energia mecânica por tempo');
plot(t, (T(theta)+V(theta)), 'k');
subplot(2,2,4)
xtitle('Soma das energias')
plot(t, T(theta))
plot(t, V(theta), 'r')
plot(t, V(theta)+T(theta), 'k')

scf(2)
xtitle('Retrato do espaço de fases');
plot(theta(1,:), theta(2,:), 'k');
