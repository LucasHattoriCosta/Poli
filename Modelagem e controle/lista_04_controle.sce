clear()

A = [[-3,1,0];[2,-3,2];[0,1,-3]];
dt = 0.1

B = zeros(3,1)
B(1,1) = 1 //com atuacao no tanque 1

C = zeros((3,3))
C(1,1) = 1

// Cálculo de K
polos_K = [-1-1*%i, -1+1*%i, -1.5]
K = ppol(A, B, polos_K)

//Cálculo de Ko
polos_Ko = [-2-2*%i, -2+2*%i,-3]
Ko = (ppol(A', C', polos_Ko))'

lambda_1 = A - B * K
lambda_2 = B * K
lambda_3 = zeros(3,3)
lambda_4 = A - Ko * C

lambda = [[lambda_1, lambda_2];[lambda_3, lambda_4]];  
autovalores = spec(lambda)


phi_lambda = expm(lambda * dt)

vetor_tempo = 0:dt:5;
X_lambda = [zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo)];
X_lambda(1,1) = 3.7;
X_lambda(2,1) = 1.2;
X_lambda(3,1) = 2.6;

X_lambda(4,1) = 0.7;
X_lambda(5,1) = 0.2;
X_lambda(6,1) = 1.5;

m=size(vetor_tempo);
n=m(2);
for i = 1:n-1
    X_lambda(:,i+1) = phi_lambda*X_lambda(:,i);
end;

clf()
scf(0)
plot(vetor_tempo, X_lambda(1,:))
plot(vetor_tempo, X_lambda(2,:), 'red')
plot(vetor_tempo, X_lambda(3,:), 'green')

plot(vetor_tempo, X_lambda(4,:), ':')
plot(vetor_tempo, X_lambda(5,:), 'red:')
plot(vetor_tempo, X_lambda(6,:), 'green:')

legend('Tanque 1', 'Tanque 2', 'Tanque 3', 'Erro Tanque 1', 'Erro Tanque 2', 'Erro Tanque 3',[-1])


Q = eye((3,3));
P = [1];
Qo = eye((3,3));
Po = [1];

R = ricc(A, B * inv(P) * B', Q, "cont");
K_LQ = inv(P) * B' * R;

Ro = ricc(A',C'*inv(Po)*C,Qo,'cont')
Ko_LQ = inv(Po) * C' * Ro

LQ_lambda_1 = A - B * K_LQ
LQ_lambda_2 = B * K_LQ
LQ_lambda_3 = zeros(3,3)
LQ_lambda_4 = A - Ko_LQ * C

LQ_lambda = [[LQ_lambda_1, LQ_lambda_2];[LQ_lambda_3, LQ_lambda_4]];  
LQ_autovalores = spec(LQ_lambda)

phi_lambda_LQ = expm(LQ_lambda * dt)

X_lambda_LQ = [zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo)];
X_lambda_LQ(1,1) = 3.7;
X_lambda_LQ(2,1) = 1.2;
X_lambda_LQ(3,1) = 2.6;


X_lambda_LQ(4,1) = 0.7;
X_lambda_LQ(5,1) = 0.2;
X_lambda_LQ(6,1) = 1.5;

m=size(vetor_tempo);
n=m(2);
for i = 1:n-1
    X_lambda_LQ(:,i+1) = phi_lambda_LQ*X_lambda_LQ(:,i);
end;

scf(1)
plot(vetor_tempo, X_lambda_LQ(1,:))
plot(vetor_tempo, X_lambda_LQ(2,:), 'red')
plot(vetor_tempo, X_lambda_LQ(3,:), 'green')

plot(vetor_tempo, X_lambda_LQ(4,:), ':')
plot(vetor_tempo, X_lambda_LQ(5,:), 'red:')
plot(vetor_tempo, X_lambda_LQ(6,:), 'green:')

legend('Tanque 1', 'Tanque 2', 'Tanque 3', 'Erro Tanque 1', 'Erro Tanque 2', 'Erro Tanque 3',[-1])
