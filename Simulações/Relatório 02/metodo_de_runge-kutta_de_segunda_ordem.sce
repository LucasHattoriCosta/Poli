clc
clear
//Condições iniciais
s0=0;
vs0=1;
S0=[s0,vs0];
g=9.78;
m=0.033;
c=0.01;
t0=0;
tf=5;
teta=(%pi)/6;
ro=1.2;
Cd=0.3;
A=0.0003;
//Passo de integração
h=0.5;
dt=h;
t=t0:dt:tf;
function dS=f(t,S)
    ds1=S(2);
    ds2=g*sin(teta)-(S(2)**2)*(ro)*(Cd)*(A)*(0.5)/(m);
    dS=[ds1;ds2];
endfunction
//Método de Runge-Kutta de segunda ordem 
final=length(t)-1;
Evs(1)=vs0;
Es(1)=s0;
Et(1)=t0;
Evs2(1)=0+(g*sin(teta)-(vs0**2)*(ro)*(Cd)*(A)*(0.5)/(m))*(dt);
Evs3(1)=0+(g*sin(teta)-(Evs2(1)**2)*(ro)*(Cd)*(A)*(0.5)/(m))*(dt);
for i=1:final
    Evs2(i)=Evs(i)-(g*sin(teta)-(Evs(i)**2)*(ro)*(Cd)*(A)*(0.5)/(m))*(dt/2);
    Evs3(i)=Evs(i)-(g*sin(teta)-(Evs2(i)**2)*(ro)*(Cd)*(A)*(0.5)/(m))*(dt/2);
    Evs(i+1)=Evs(i)/(1+(dt)*(g*sin(teta)-(Evs(i)**2)*(ro)*(Cd)*(A)*(0.5)/(m)));
    Et(i+1)= dt +Et(i);
    Es(i+1)=Es(i)+(Evs(i))*(dt);
end
scf(0)
xtitle('Runge-kutta:Posição s (m) por tempo para h= '+string(h)+' e para vs0='+string(vs0));
plot(Et,Es,'y')
scf(1)
xtitle('Runge-Kutta: Velocidade Vs (m/s)por tempo (s) para h = '+string(h)+' e para vs0 = '+string(vs0));
plot(Et,Evs,'y')
