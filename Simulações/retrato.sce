//Lista de exercício 3 - 2º Tarefa
//Dados
pi = %pi;
r_e = 0.001; // raio da esfera em metros
r = 1; // raio da pista circular
rho = 7850; //densidade do aço em kg/m^3
g = 9.8; //m/s^2
m = (4/3)*pi*(r_e^3)*7850 // massa em kg


//Condições 1
theta_1 = [0;0];
//Condições 2
theta_2 = [-pi/180;0];
//Condições 3
theta_3 = [pi/4;1.8];
//Condições 4
theta_4 = [5*pi/6;0];
//Condições 5
theta_5 = [pi/2;2];
//Condições 6
theta_6 = [pi*2/3;0];
//Condições 7
theta_7 = [0;3];
//Condições 8
theta_8 = [pi/10;0.5];
//Condições 9
theta_9 = [pi*14/15;-2];
//Condições 10
theta_10 = [pi/3;6];
//Condições 10
theta_11 = [pi/3;6];
//Condições 10
theta_12 = [pi/3;6];
//Condições 10
theta_13 = [pi/3;6];
//Condições 10
theta_14 = [pi/45;1.9];
//Condições 10
theta_15 = [pi/2;0.35];
    

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
theta1 = ode(theta_1,0,t,f);
theta2 = ode(theta_2,0,t,f);
theta3 = ode(theta_3,0,t,f);
theta4 = ode(theta_4,0,t,f);
theta5 = ode(theta_5,0,t,f);
theta6 = ode(theta_6,0,t,f);
theta7 = ode(theta_7,0,t,f);
theta8 = ode(theta_8,0,t,f);
theta9 = ode(theta_9,0,t,f);
theta10 = ode(theta_10,0,t,f);


//Plotar gráficos
clf()
scf(0)
xtitle('Retrato do espaço de fases');
plot(theta1(1,:), theta1(2,:), 'k');
plot(theta2(1,:), theta2(2,:), 'k');
plot(theta3(1,:), theta3(2,:), 'k');
plot(theta4(1,:), theta4(2,:), 'k');
plot(theta5(1,:), theta5(2,:), 'k');
plot(theta6(1,:), theta6(2,:), 'k');
plot(theta7(1,:), theta7(2,:), 'k');
plot(theta8(1,:), theta8(2,:), 'k');
plot(theta9(1,:), theta9(2,:), 'k');
plot(theta10(1,:), theta10(2,:), 'k');





