clear()

// Parametros do sistema
b = 1
m = 1
M = 1
g = 9.8
L = 1
c = 1
dt = 0.1

// Espaco de estados

A_til = [
    [0 1 0 0 0 0],
    [0 -b*L 0 0 0 0],
    [0 0 0 1 0 0],
    [0 0 -3*m*g*L/2 -c -m*g*L/2 0],
    [0 0 0 0 0 1],
    [0 0 0 c -m*g*L/2 -c]
]

B_til = [
    [0 0 0 0 0 0],
    [L 0 0 0 0 0],
    [0 0 0 0 0 0],
    [0 1 0 0 0 0],
    [0 0 0 0 0 0],
    [0 0 1 0 0 0]
]

M = [
    [1 0 0 0 0 0],
    [0 (2*m+M)*L 0 3*m*L^2/2 0 m*L^2/2],
    [0 0 1 0 0 0],
    [0 2*m*L 0 2*m*L^2/2 0 2*m*L^2/3],
    [0 0 0 0 1 0],
    [0 m*L/2 0 m*L^2/6 0 m*L^2/3]
]

A = M' * A_til
B = M' * B_til

// Analise de controlabilidade e observabilidade
[n,U]=contr(A,B)

//[Ao,Bo,Co]=obsvss(A,B,C)

// definição da matriz de ganhos de controle K por alocacao de polos
polos = [-4+6*%i -4-6*%i -1+2*%i -1-2*%i -2 -1]
K_aloc = ppol(A, B, polos)
disp(K_aloc(1,:), 'K = ')

F_aloc = A - B * K
phi_aloc = expm(F_aloc*dt)

vetor_tempo = 0:dt:10;

X = [zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo)];
X(1,1) = 3.7;
X(2,1) = 1.2;
X(3,1) = 2.6;

m=size(vetor_tempo);
n=m(2);
for i = 1:n-1
    X(:,i+1) = phi*X(:,i);
