clc
clear

// Características do sistema:

pi = %pi
R = 3
c = 0.1
ro = 0.1 // kg/m
g = 9.80 // m/s²
l = 0.5 // m
L = 2*l // m
m = L*ro
alpha = l/R

//Vetor de Estados Iniciais
theta_0 = pi/6
omega_0 = 9
E = [theta_0,omega_0]

//Vetor Tempo
t0 = 0
dt = 0.005
tf = 100
t = t0:dt:tf

//Integração
function z_dot = deriva(t,z)
    dk_dt = z(2)
    d2k_dt2 = -(g/R)*(sin(alpha)/alpha)*sin(z(1)) - L*c*z(2)
    z_dot  = [dk_dt;d2k_dt2]
endfunction
//ODE
X = ode([theta_0;omega_0], 0, t, deriva)

////Plots
clf()
scf(0)
plot(t, X(2,:))
