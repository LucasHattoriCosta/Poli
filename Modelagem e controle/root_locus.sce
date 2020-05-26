// Questão 1 //
t = 0:0.01:10
s = %s
num = s + 1
den = s^4 + 3*s^3 + 12*s^2 - 16*s
Kp = 30
Kd = 700
PD = Kp + Kd*s
FTMA_1 = syslin('c', (PD*num)/(den + PD*num))
disp(FTMA_1)
y = csim('step', t, tf2ss(FTMA_1))
scf(0)
plot2d(t, y, 2)
xgrid()
xtitle("Ganho Kd = 700", "Tempo (segundos)", "Resposta")
// Questão 2 //
// Em MA
G = 1/(s^2+4*s+5)
H = 1/(s+1)
FTMA = syslin('c', G*H)
scf(1)
evans(FTMA)
// Em MF
Kp = 25
FTMF = syslin('c', Kp*G/(1+Kp*G*H))
y = csim('step', t, tf2ss(FTMF))
scf(2)
plot2d(t, y, 3)
xgrid()
xtitle("Kp = 25", "Tempo (segundos)", "Resposta")
// Questão 3 //
i = %i
s = %s
G3 = ((s+i)*(s-i))/(s*(s+1))
FTMA_3 = syslin('c', G3)
// Questão 4 //
G4 = (s+2)/((s+1+i)*(s+1-i))
FTMA_4 = syslin('c', G4)
// Questão 5 //
Gc = (1+(2/3)*s+1/(3*s))
Gp = 1/((20*s+1)*(10*s+1))
H = 1/((s/2)+1)
K = 1
FTMA_5 = syslin('c', Gc*Gp*H)
FTMF_5 = syslin('c', K*Gc*Gp/(1+K*H*Gc*Gp))
disp(FTMA_5)
disp(FTMF_5)
scf(3)
evans(FTMA_5)
// Questão 6 //
G = (s+1)/(s^2*(s+9))
FTMA_6 = syslin('c', G)
scf(4)
evans(FTMA_6)
