clc
clear
//Condições iniciais
s0=0;
vs0=0;
S0=[s0;vs0]
g=9.78;
mu0 = 0.15;
Nt = 0.08;
m=0.033;
c=0.01;
t0=0;
tf=20;
teta=(%pi)/6;
//Passo de integração
h=0.5;
dt=h;
t=t0:dt:tf;
//Função para cálculo das derivadas temporais (letra b)
function dS=f(t,S)
    ds1=S(2);
    ds2=g*sin(teta)-4*mu0*Nt*(1/m);
    dS=[ds1;ds2];
endfunction
//Método de Adams
S=ode("adams", S0,t0,t,f); 
scf(0); 
xtitle('Adams: Posição x (m) para h = '+string(h)+' e para vx0 = '+string(vs0)); 
plot(t,S(1,:),'y') 
scf(1); 
xtitle('Adams: Velocidade Vx (m/s) para h = '+string(h)+' e para vx0 = '+string(vs0)); 
plot(t,S(2,:), 'y') 
//Método de Runge Kutta
T=ode("rk", S0,t0,t,f); 
scf(2); 
xtitle('Runge-Kutta: Posição s (m) por tempo (s) para h = '+string(h)+' e para vx0 = '+string(vs0)); 
plot(t,S(1,:),'y') 
scf(3);
xtitle('Runge-Kutta: Velocidade Vs (m/s) por tempo (s) para h = '+string(h)+' e para vx0 = '+string(vs0)); 
plot(t,S(2,:),'y') 
  
