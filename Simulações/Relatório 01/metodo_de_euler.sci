
clc
clear
//Condições iniciais
s0=0;
vs0=0;
S0=[s0,vs0];

g=9.81;
m=0.033;
Cd = 0.3;
A = 0.0003;
rho = 1.2;
c=0.01;
t0=0;
tf=10;
teta=(%pi)/6;
//Passo de integração
h=0.01;
dt=h;
t=t0:dt:tf;
//Método de Euler letra a 
final=length(t)-1;
Evs(1)=vs0;
Es(1)=s0;
Et(1)=t0;
for i=1:final
    Evs(i+1)=Evs(i)+(g*sin(teta)- rho*Cd*A)
    Et(i+1)= dt +Et(i)
    Es(i+1)=Es(i)+(Evs(i))*(dt)
end
scf(0)
xtitle('Euler:Posição s (m) por tempo para h= '+string(h)+' e para vs0='+string(vs0));
plot(Et,Es,'y')
scf(1)
xtitle('Euler: Velocidade Vs (m/s)por tempo (s) para h = '+string(h)+' e para vs0 = '+string(vs0));
plot(Et,Evs,'y')
