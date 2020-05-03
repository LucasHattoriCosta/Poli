//Programa para gerar as matrizes de transição Phi e simular o comportamento do sistema
clear
clc()

//FUNÇÃO GRÁFICO
function [x, t] = grafico(x1_0, x2_0, x3_0, x4_0, x5_0, x6_0, phi, Tf, Delta_t, str, num)
    t(1)=0               //Instante inicial
    n=round(Tf/Delta_t)  //Número de passos
    
    x(1, 1) = x1_0;
    x(2, 1) = x2_0;
    x(3, 1) = x3_0;
    x(4, 1) = x4_0;
    x(5, 1) = x5_0;
    x(6, 1) = x6_0;
    
    //Cálculo de x e t
    for i=1:n
        t(i+1) = t(i) + Delta_t;
        x(:, i+1) = phi*x(:, i)
    end

    //Plotagem do gráfico
    scf(num)
    xgrid(1)
    xset('font size',4)
//    title(["Figura "+string(num)+" "str+" para x1(0) = "+string(x(1, 1))+"m, x2(0) = "+string(x(2, 1))+"m, x3(0) = "+string(x(3, 1))+"m, x4(0) = "+string(x(4, 1))+"m, x5(0) = "+string(x(5, 1))+"m, x6(0) = "+string(x(6, 1))+"m"], "fontsize", 4)
    xlabel("Tempo (s)", "fontsize", 4)
    ylabel("x(m) ou ângulo(rad)", "fontsize", 4)
    plot2d(t, x(1, :), 5)
    plot2d(t, x(3, :), 3)
    plot2d(t, x(5, :), 2)
    legends(["x", "teta1", "teta2"], [5, 3, 2], 1, "fontsize", 1)
endfunction 

//PARÂMETROS E MATRIZES CARACTERÍSTICAS DO SISTEMA
m = 2;
Mbase = 6;
L = 0.5;
c = 8.5e-5;
b = 7.12e-3;
g = 9.8;

M = [1, 0, 0, 0, 0, 0; 0, (2*m+Mbase)*L, 0, 3*m*(L^2)/2, 0, m*(L^2)/2; 0, 0, 1, 0, 0, 0; 0, 2*m*L, 0, 3*m*(L^2)/2, 0, 2*m*(L^2)/3; 0, 0, 0, 0, 1, 0; 0, m*L/2, 0, m*(L^2)/6, 0, m*(L^2)/3];

I = eye(6);

Minv = inv(M);

Atil = [0, 1, 0, 0, 0, 0; 0, -b*L, 0, 0, 0, 0; 0, 0, 0, 1, 0, 0; 0, 0, -3*m*L*g/2, -c, -m*L*g/2, 0; 0, 0, 0, 0, 0, 1; 0, 0, 0, c, -m*L*g/2, c];

Btil = [0;L;0;0;0;0];

A = Minv*Atil;

B = Minv*Btil;

C = [1,0,0,0,0,0];

D = [0];

//DEFINIÇÕES DE VETORES E CONDIÇÕES INICIAIS
dt = 0.1; //passo
ti = 0; //tempo inicial
tf = 100; //tempo final
t = ti:dt:tf; //vetor tempo
//VETOR INICIAL
x1_0 = 0; //x
x2_0 = 0; //xp
x3_0 = 0.1; //teta1
x4_0 = 0; //teta1p
x5_0 = 0.2; //teta2
x6_0 = 0; //teta2p
j = 1

phi_aberta = [
    [1 0.0099999 0.00024794 8.2884e-07 3.3073e-05 1.1109e-07],
    [0 0.99999 0.049573 0.00024839 0.0066156 3.3244e-05],
    [0 9.598e-08 0.99831 0.0099944 0.00036353 1.196e-06],
    [0 1.9192e-05 -0.33709 0.99831 0.072665 0.00036033],
    [0 1.1997e-07 9.9144e-05 3.6206e-07 0.99825 0.0099942],
    [0 2.3987e-05 0.019817 0.00010544 -0.35031 0.99825]
]

[x_aberta, t_aberta] = grafico(x1_0, x2_0, x3_0, x4_0, x5_0, x6_0, phi_aberta, tf, dt, "Comportamento do Sistema em Malha Aberta", j)




////MALHA ABERTA
////Autovalores e autovetores 
//[Autovetores, Autovalores] = spec(A)
//disp(Autovalores(1,1), Autovalores(2,2), Autovalores(3,3), Autovalores(4,4), Autovalores(5,5), Autovalores(6,6), "Autovalores/Polos para malha aberta = ")
//disp(Autovetores, "Autovetores = ")
////Análise de estabilidade
//Estável = %T
//for i = 1:size(A)(1)
//    if real(Autovalores(i, i))>0 then
//         Estável = %F
//    end
//end
//if Estável == %T then
//    disp("Sistema Estável")
//else
//    disp("Sistema Não Estável")
//end
////matriz de transição
//Φ1 = expm(A*dt) //cálculo da matriz
//disp(Φ1, "Matriz de transição Φ (para malha aberta):")
//disp('')
////simulação do sistema
//[x1, t1] = grafico(x1_0, x2_0, x3_0, x4_0, x5_0, x6_0, Φ1, tf, dt, "Comportamento do Sistema em Malha Aberta", j)
//j = j+1
//
//
////MALHA FECHADA (ALOCAÇÃO DE POLOS)
////definição de polos, K1 e matriz de transição
//v = [complex(-4, 6); complex(-4, -6); complex(-1, +2); complex(-1, +2); complex(-1); complex(-2)] //vetor dos polos
//Kl = ppol(A, B, v) //cálculo do vetor K1
//disp(Kl, "Vetor K1:") //mostrando vetor K1 para polos escolhidos
//F1 = (A - B*Kl) //nova matriz para cálculo da matriz de transição
//Φ2  = expm(F1*dt) //cálculo da matriz
//disp(Φ2, "Matriz de transição Φ para malha fechada (alocação de polos):")
//disp('')
////simulação do sistema
//[x2, t2] = grafico(x1_0, x2_0, x3_0, x4_0, x5_0, x6_0, Φ2, tf, dt, "Comportamento do Sistema em Malha Fechada (alocação de polos)", j)
//j = j+1
//
//
////MALHA FECHADA (Controle LQ)
////polos, K2 e matriz de transição
//R = 1*[1] //Matriz P arbitrária
//Q = eye((6,6))//Matriz Q arbitrária
//P = ricc(A, B*inv(R)*B', Q, "cont") //conta q tinha lá p fazer, n sei
//K2 = inv(R)*B'*P //cálculo do vetor K2
//disp(K2, "Vetor K2:") //mostrando vetor K2
//F2 = (A - B*K2) //nova matriz para cálculo da matriz de transição
//Polos_LQ = spec(F2)//cálculo de novos polos para controle LQ
//disp(Polos_LQ, "Polos LQ:")
//Φ3  = expm(F2*dt) //cálculo da matriz
//disp(Φ3, "Matriz de transição Φ para malha fechada (para o controle LQ):")
//disp('')
////simulação do sistema
//[x3, t3] = grafico(x1_0, x2_0, x3_0, x4_0, x5_0, x6_0, Φ3, tf, dt, "Comportamento do Sistema em Malha Fechada (controle LQ)", j)
//j=j+1
