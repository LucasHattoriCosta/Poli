//Tarefa 2 - Flavius

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
//7)
theta0=0
theta_dot0=sqrt(4*g/R)
theta = 0:0.05:2*pi
a=(R*theta_dot0)**2/(2*g)+R*sin(theta0)

//Tempo
t0=0
dt=0.05
tf=10
t=t0:dt:tf

//Integrações
X = ode([theta0;theta_dot0],t0,t,deriva)
Y = integrate('R/sqrt(2*g*(a-R*sin(theta)))','theta',0,theta)


for theta0=0:pi/10:pi/2
    i = 0
    X = ode([theta0;theta_dot0],t0,t,deriva)
    Y = integrate('R/sqrt(2*g*(a-R*sin(theta)))','theta',0,theta)
    periodo = 4*(max(X)-min(Y))
    periodos = list(0)
    periodos($+1) = periodo
    angulo = theta
end
disp(periodos)

disp(4*(max(Y)-min(Y)))
