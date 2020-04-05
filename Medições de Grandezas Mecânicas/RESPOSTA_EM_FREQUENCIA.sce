// Numerador
n=poly([2 1 1],'s','coeff');
// Denominador
d=poly([1 20 1],'s','coeff');
// Funcao de transferencia
G=syslin('c',n/d);

//           s^2+s+2
//  G(s) = ----------
//          s^2+20+1
G

// Vetor de frequencias em rad/s
w=logspace(-3,3,6000);
// Como o Scilab usa a frequencia em Hz na maioria dos cálculos, devemos
// modificar nosso vetor de w para fr, transformando a unidade de rad/s para Hz:
fr=w/(2*%pi);
// Podemos então determinar os vetores de fase e magnitude, 
// calculando a funcao de transferencia em cada ponto do vetor de frequencias.
// Os valores da funcao de transferencia calculados em cada valor da
// frequencia contida no vetor fr é armazenado no vetor vf:
vf=repfreq(G,fr);
// Calculando a magnitude (em db) e a fase (em graus):
[fase, mag]=phasemag(vf);
// Plotando o diagrama de Bode de ganho com a unidade de frequencia em rad/s:
// Abrindo uma nova janela de grafico:
xset('window',1)
// Dividindo a janela em nxm partes, n linhas e m colunas, e usando a parte p:
// subplot(n,m,p). Em nosso exemplo usaremos 2 subjanelas, 2 linhas e 1 coluna:
subplot(2,1,1)
// Plotando o Diagrama de Bode de ganho:
plot2d('ln',w,mag,rect=[10^(-3),-30,10^3,30]);xgrid(2)
// ‘ln’ significa que a escala horizontal eh logarítmica (l) e a escala vertical
// eh normal (n). O parametro ‘rect’ define os limites das escalas.
xtitle("Magnitude","rad/s","dB")
// Usando a segunda subjanela:
subplot(2,1,2)
// Plotando o diagrama de Bode de fase:
plot2d('ln',w,fase,rect=[10^(-3),-90,10^3,90]);xgrid(2)
xtitle("Fase","rad/s","graus")
