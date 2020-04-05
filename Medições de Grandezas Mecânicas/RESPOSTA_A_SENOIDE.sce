// Numerador
n=poly([2 1 1],'s','coeff');
// Denominador
d=poly([1 20 1],'s','coeff');
// Funcao de transferencia
G=syslin('c',n/d);

//           s^2+s+2
//  G(s) = ----------
//          s^2+20+1

// Resposta no tempo para entrada senoidal
// Vetor tempo
t=0:0.01:250;
// Vetor entrada
u=sin(0.1*t);
// Definindo o vetor de condicoes iniciais:
x0=[0;0];
// Realizando a simulacao:
[y]=csim(u,t,G,x0);
plot2d(t,y,5)
plot2d(t,u,2)
xtitle("GRAFICO 1 - Entrada: azul. Saída: vermelho. Frequência: 0,1 rad/s","tempo em s","amplitude")




// Resposta transitoria
// Vetor tempo
t=0:0.0001:0.6;
// Vetor entrada
u=sin(40*t);
// Definindo o vetor de condicoes iniciais:
x0=[0;0];
// Realizando a simulacao:
[y]=csim(u,t,G,x0);
// Abrindo uma nova janela de grafico:
xset('window',1)
plot2d(t,y,5)
plot2d(t,u,2)
xtitle("GRAFICO 2 - Entrada: azul. Saída: vermelho. Frequência: 40 rad/s","tempo em s","amplitude")
