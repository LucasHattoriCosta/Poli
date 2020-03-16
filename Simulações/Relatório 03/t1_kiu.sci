//Condições iniciais
alfa = -%pi/6;
s0 = 1;
v0 = -1;
dt = 0.1;
t = linspace(0,10,1000);
g = 9.8;
r = 0.001;
ro = 7850;
volume = 4*%pi*(r^3)/3;
m = ro*volume;
x0=1;
z0=2;
x = linspace(1,25,1000);
z = tan(alfa)*x - tan(alfa)*x0

funcprot(0);
s = s0 + v0*t + (1/2)*(g*sin(alfa))*(t^2); 
v = v0 + g*sin(alfa)*t;
t1 = linspace(0,10,999)
dv = diff(v)
dt = diff(t)
a = zeros(length(dv))
for i = 1:(length(dv))
    a(i) = dv(i)/dt(i)
end

T = (m/2)*(v^2);
V = -m*g*s*sin(alfa) + m*g*s0*sin(alfa);
E = V + T;
for i=1:length(t)
    N(i) = m*g*cos(alfa);
end;
//O único caso em que não ocorre inversão do sentido é nas condições com velocidade inicial positiva
//Numérico
p = poly([v0 g*sin(alfa)], "t", ["coeff"])
roots(p)
//Analítico
t1 = (-v0)/(g*sin(alfa));

//Gráficos
f1=scf(1);
plot(t, s);
xtitle("posição em função do tempo", "t","s");
f2=scf(2);
plot(t, v);
xtitle("velocidade em função do tempo", "t","v");
f3=scf(3);
plot(t1, a');
xtitle("aceleração em função do tempo", "t","a");
f4=scf(4);
plot(t, T);
xtitle("energia cinética em função do tempo", "t", "T")
f5=scf(5);
plot(t, V);
xtitle("energia potencial em função do tempo", "t", "V");
f6=scf(6);
plot(t, E);
xtitle("energia mecânica em função do tempo", "t", "E");
f7 = scf(7);
plot(s,v)
xtitle("plano de fase", "s", "v")
f8 = scf(8);
plot(t, N)
xtitle("Força normal em função do tempo", "t", "N")
f9 = scf(9);
comet(x, z)
