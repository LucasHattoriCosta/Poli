clc
clear
driver("PPM")
// Definição dos Parametros e Constantes Físicas
ro=0.1 // kg/m
g=9.80 //m/s2
pi=%pi
R=3 //m
c = 0.1
l=0.5 //m
//l = 2 //m
L = 2*l
m = L*ro
alpha = l/R
// Definições dos estados iniciais das variáveis características do espaço de estados:
// Condições iniciais
//i)
Ei = [0, 0] // [theta; velocidade]
//ii)
Eii = [-pi/180,0]
// iii)
Eiii = [pi/4, 0]
//iv)
Eiv = [5*pi/6, 0]
//v)
Ev = [pi, 0]
//vi)
Evi = [pi, 1]
//vii)
Evii = [0, 3.64]
//Evii = [0,w0] ////// Calcular
E = [Ei; Eii; Eiii; Eiv; Ev; Evi; Evii] //Array com todas as condições iniciais
// Integração das equações diferenciais:
funcprot(0)
function [z_dot]=deriva(t, z) //Pega a matriz z e deriva em relação a t
 dk_dt= z(2)
 d2k_dt2= -(g/R)*(sin(alpha)/alpha)*sin(z(1))- L*c*dk_dt
 z_dot=[dk_dt;d2k_dt2]
endfunction
t = linspace(0,10,1000)//0.02
[nl, nc] = size(E)
// Apresentação gráfica dos resultados da simulação:
for i=1:nl
 M = E(i,1:nc)
 X = ode([M(1);M(2)], 0, t, deriva)

 theta = X(1,:)

 scf(0)

 plot(t,theta)
 xtitle("Deslocamento ("+string(i)+")em função do tempo para l = 0.5m", "t(s)", "Deslocamento(rad)")
end
// Integrate
th0=E(1)
thf=0
passo = 0.005
theta = th0:passo:thf
n=length(theta)
// Parâmetro a
a = ((R*(E(2)))^2)/2*g + R*(sin(E(1) - alpha) - sin(E(1) + alpha))/(2*alpha)
// Tempo
t0=0
tf = 10
dt = 10/(n-1)
t = t0:dt:tf
// Vetores
X = ode([E(1);E(2)], 0, t, deriva)
Y = integrate('R/sqrt([2*g*(a -(R/alpha)*(sin(theta-alpha) -sin(theta+alpha)))])','theta',th0,theta)
//scf(0)
//plot(X(1,:), Y)
//xtitle("t = t(theta) - condição 3",ar"theta (rad)", "t (s)")
//xs2jpg(0,"Q2-INT-3.jpg")
//close()
disp(Y(n-1))
