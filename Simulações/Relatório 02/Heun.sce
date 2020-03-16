// C: Heun

// Referência: https://www.youtube.com/watch?v=F8urfp1HEKs

function y = f(t, u)
    y=sin(u+t)
endfunction

function [u]=heun(N, cor)
u(1) = 2; //CI
t(1) = 0;
T = 3;
h = (T-t(1))/N
for n=1:n
    t(n+1)=t(n)+h;
    util = u(n)+h*f(t(n),u(n))
    F1 = f(t(n), u(n))
    F2 = f(t(n+1), util)    //Heun
    u(n+1)=u(n)+(h/2)*(F1+F2)
     
end
endfunction
