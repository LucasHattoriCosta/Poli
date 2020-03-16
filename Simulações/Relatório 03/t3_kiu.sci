//Condições iniciais
R = 0.001;
ro = 7850;
volume = 4*%pi*(R^3)/3;
m = ro*volume;
g = 9.8;
r = 1;
s0 = -4*r;
v0 = 0;
t = linspace(0,10,1000);

s= zeros(1,1000);
v = zeros(1,1000);
funcprot(0);


function [ds]=f(t, y)
    ds1=y(2);
    ds2=(-g/(4*r))*(y(1));
    ds=[ds1;ds2];
endfunction
function [z]=h(t, y)
    z1=16+f(1)^2;
    z2=f(2);
    z=[z1;z2]
endfunction
x = ode("root",[s0;v0],0,t,f,1,h);
s = x(1,:);
v = x(2,:);
t1 = linspace(0,10,999)
dv = diff(v)
dt = diff(t)

for i = 1:(length(dv))
    a(i) = dv(i)/dt(i)
end

T = m*(v^2)/2;
V = m*g*(s^2)/(8*r);
E = T + V;

//Gráficos
f1=scf(1);
plot(t, s);
xtitle("posição em função do tempo", "t","s");
f2=scf(2);
plot(t, v);
xtitle("velocidade em função do tempo", "t","v");
f3=scf(3);
plot(t1, a');
xtitle("aceleração em função do tempo", "t", "a");
f4=scf(4);
plot(t, T);
xtitle("energia cinética em função do tempo", "t", "T")
f5=scf(5);
plot(t, V);
xtitle("energia potencial em função do tempo", "t", "V")
f6=scf(6);
plot(t, E);
xtitle("energia mecânica em função do tempo", "t", "E")
f7=scf(7);
plot(s, v);
xtitle("velocidade em função do espaço", "espaço", "velocidade")
