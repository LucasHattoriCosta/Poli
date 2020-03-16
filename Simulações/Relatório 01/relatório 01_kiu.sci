//Condições iniciais
alfa = %pi/6;
s0 = 0;
v0 = 0.1;
k1 = 1/v0;
k2 = -log(k1);
t = 0:0.05:10;
g = 9.78;
m = 0.033;
Cd = 0.3;
rho = 1.2;
A = 0.0003;
c = 0.1;
l = -c/m;
clf()

function [posicao]=s(t)
    posicao = t*sqrt((2*m*g*sin(alfa))/rho*Cd*A) + k2 //+ log((rho*Cd*A*t + (1/v0))*(1/rho*Cd*A))
endfunction
scf(1)
//xtitle('Posição do carrinho em função do tempo')
plot(t, s)

//function [velocidade]=v(t)
    //velocidade = (1/rho*Cd*A*t+k1)+sqrt((2*m*g*sin(alfa))/rho*Cd*A)
//endfunction
v = (1/rho*Cd*A*t+k1)+sqrt((2*m*g*sin(alfa))/rho*Cd*A)
scf(0)
xtitle('Velocidade do carrinho em função do tempo')
plot(t, v)

function [aceleracao]=a(t)
    aceleracao = numderivative(v, t)
endfunction
//plot(t, a)

function energiac=K(v)
    energiac = ((m*v)^2)/2
endfunction
//plot(t, T)

function energiap=V(s)
    energiap = -m*g*(s - s0)*sin(alfa)
endfunction
//plot(t, V)

function energia=E(V, K)
    energia = V + K
endfunction
//plot(t, E) - VERIFICAR, NÃO ESTAVA PLOTANDO

function normal=N(t)
    normal = m*g*cos(alfa)
endfunction
//plot(t, N)

//O único caso em que ocorre inversão do sentido é nas condições 3) (velocidade inicial negativa)
//Analiticamente obtém-se t=0.2040s
//t = (-v0)/(g*sin(alfa))
//linsolve(t, v)

