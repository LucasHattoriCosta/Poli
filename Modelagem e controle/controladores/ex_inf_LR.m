clc; clear; close all;

%% Deixa os eixos em LaTeX
set(groot, 'defaultLegendInterpreter','latex');

%% Exercicio 23/06
K = 1;

num = [K K];
den = [1 3 12 -16 0];
G = tf(num, den);

real_pesc = input('Real_pesc :');
imag_pesc = input('Imag_pesc :');

pesc = complex(real_pesc, imag_pesc);
p1 = 1;
p2 = 0;
p3 = -1;
p4 = -2 + 3.464*1i;
p5 = -2 - 3.464*1i;
p = [p1 p2 p3 p4 p5];

thetas = [];
for i=1:5
    thetaproto = atand((abs(imag(pesc)-imag(p(i)))/(abs(real(pesc)-real(p(i))))));
    if real(p(i)) - real(pesc) > 0
        theta = 180 - thetaproto;
        thetas = [thetas theta];
    else 
        theta = thetaproto;
        thetas = [thetas theta];
    end
end
aux = (- thetas(1) - thetas(2) + thetas(3) - thetas(4) - thetas(5));
avanco = -180 - aux;
phi_2 = avanco/2;
bissec = thetas(2)/2;

AngZ = bissec - phi_2
AngP = bissec + phi_2
Lado = abs(pesc)
Ang0 = 180 - thetas(2)

%%% Da Prime, P e Z vão aparecer em b
P = input('P :');
Z = input('Z: ');

%%% Achando Kc
num_aux = [1 Z];
den_aux = [1 P];
Gc_aux = tf(num_aux,den_aux);
Gc_aux2 = Gc_aux*G;
Gc_aux3 = 1/Gc_aux2;
K_aux = abs(evalfr(Gc_aux3,pesc));
Kp = 29.5;
Kc = K_aux/Kp;

%%% Gc real
num_Gc = [Kc Kc*Z];
den_Gc = [1 P];
Gc = tf(num_Gc,den_Gc);

figure
margin(Gc*Kp*G)
hold
bode(Kp*G)
legend('Com Compensador','Sem Compensador')

%%% FTMF LR
FTMF_LR = feedback(Gc*Kp*G,1);

figure
step(FTMF_LR)
stepinfo(FTMF_LR)