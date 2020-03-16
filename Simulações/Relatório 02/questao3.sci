function dS=f(t,S)
    ds1=S(2);
    ds2=(g*sin(teta)-(Evs(i)**2)*(ro)*(Cd)*(A)*(0.5)/(m));
    dS=[ds1;ds2];
endfunction
//Método de Adams
S=ode("adams",S0,t0,t,f);
plot(t,S(1,:),'y');
//Método de Runge Kutta de quarta ordem
S=ode("rk4",S0,t0,t,f);
plot(t,S(1,:),'y');
//Método de Runge Kutta de Fehlberg de ordens 4 e 5
S=ode("rkf45",S0,t0,t,f);
scf(2)
plot(t,S(1,:),'y');
