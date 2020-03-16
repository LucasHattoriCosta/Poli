//Condições iniciais
R = 0.001;
ro = 7850;
volume = 4*%pi*(R^3)/3;
m = ro*volume;
g = 9.8;
r = 1;
teta0 = -%pi/180;
omega0 = 0;
t = linspace(0,10,1000);
teta02 = linspace(0,%pi,1000);
teta4 = -teta02;
clf();
//Espaço de estados
function [dTeta]=o(t, Teta)         //letra "a"
    dteta1 = Teta(2);
    dteta2 = (-g/r)*sin(Teta(1));
    dTeta = [dteta1;dteta2];
endfunction;

//Integração numérica
teta = zeros(1000)
omega = zeros(1000)
funcprot(0);

y = ode([teta0;omega0],0,t,o);

teta = y(1,:);
omega = y(2,:);

//Aceleração angular
gama = (-g/r)*sin(teta)
//Energia cinética, potencial e mecanica
T = (m*r*r/2)*(omega^2)
V = m*g*r*(1-cos(teta))
E = T + V;

//Uso da equação 19
a = (r^2)*(omega0^2)/(2*g) + r*sin(teta0)
tteta = integrate('r/(sqrt(2*g*(a-r*sin(teta))))','teta',teta0,teta($));
for i = 1:length(teta02)
    periodo(i) = -2*integrate("r/(sqrt(2*g*(a-r*sin(teta))))","teta",teta02(i),teta4(i));
end;
//letra "f"
per = integrate("r/(sqrt(2*g*(a-r*sin(teta))))","teta",teta0,teta0+2*%pi);
//Força normal
N = m*g*cos(teta);
//Espaço de fases
teta03 = linspace(0, 2*%pi, 25);
omega02 = linspace(-0.0001, 0.0001, length(teta02));
teta2 = zeros(length(teta03));
omega2 = zeros(length(omega02));
for i = 1:length(teta03)
  y2 = ode([teta03(i);omega02(i)],0,t,o);
  teta2 = y2(1,:)
  omega2 = y2(2,:)
  plot(teta2, omega2)
  xtitle("omega2 em funcao de teta2", "teta2", "omega2")
end

//Gráficos
f1=scf(1);
plot(t, teta);
xtitle("teta em função do tempo", "t", "teta")
f2=scf(2);
plot(t, omega);
xtitle("omega em função do tempo", "t", "omega")
f3=scf(3);
plot(t, gama);
xtitle("gama em função do tempo", "t", "gama")
f4=scf(4);
plot(t, T)
xtitle("energia cinética em função do tempo", "t", "T")
f5=scf(5);
plot(t, V)
xtitle("energia potencial em função do tempo", "t", "V")
f6=scf(6);
plot(t, E);
xtitle("energia em função do tempo", "t", "E")
f7=scf(7);
plot(teta, omega);
xtitle("plano de fase", "teta", "omega")
f8=scf(8);
plot(tteta, teta)
xtitle("teta em função do tempo", "tempo", "teta")
f9=scf(9);
plot(teta, tteta)
xtitle("tempo em funçao de teta", "teta", "tempo")
f10=scf(10);
plot(teta02, periodo')
xtitle("periodo em função de teta0", "teta0", "periodo")
f11=scf(11);
plot(teta, N)
xtitle("Normal em função de teta", "teta", "força normal")


