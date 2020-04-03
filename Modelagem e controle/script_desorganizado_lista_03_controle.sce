
clear()

A = [[-3,1,0];[2,-3,2];[0,1,-3]];
dt = 0.1

phi = expm(A*dt);

vetor_tempo = 0:dt:10;

X = [zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo)];
X(1,1) = 3.7;
X(2,1) = 1.2;
X(3,1) = 2.6;

m=size(vetor_tempo);
n=m(2);
for i = 1:n-1
    X(:,i+1) = phi*X(:,i);
end;

clf()
//scf(0)
//plot(vetor_tempo, X(1,:))
//plot(vetor_tempo, X(2,:), 'red')
//plot(vetor_tempo, X(3,:), 'green')
//legend('Tanque 1', 'Tanque 2', 'Tanque 3', [-1])

B = zeros(3,1);
for i = 1:3;
    B(i,:) = 1;
    csi = [B A*B A*A*B];
    if rank(csi) == 3 then;
        disp('Sistema controlável para',i);
        end;
    B = zeros(3,1);
end;


C = zeros(3,3);
for i = 1:3;
    C(i,i) = 1;
    sigma = [C;C*A;C*A*A];
//    disp(size(sigma))
    if rank(sigma) == 3 then;
//        disp('Sistema observável para',i);
        end;
    C = zeros(3,3);
end;

B = zeros(3,3)
B(1,1) = 1
v = [-1-1*%i, -1+1*%i, -1.5]
K = ppol(A, B, v)
disp(K(1,:), 'K = ')


F = A - B * K
phi_F = expm(F*dt)

X_ = [zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo)];
X_(1,1) = 3.7;
X_(2,1) = 1.2;
X_(3,1) = 2.6;

m=size(vetor_tempo);
n=m(2);
for i = 1:n-1
    X_(:,i+1) = phi_F*X_(:,i);
end;

//scf(1)
//plot(vetor_tempo, X_(1,:))
//plot(vetor_tempo, X_(2,:), 'red')
//plot(vetor_tempo, X_(3,:), 'green')
//legend('Tanque 1', 'Tanque 2', 'Tanque 3', [-1])

for j = 1:4;
    Q = eye((3,3))*rand(1)*j;
    P = [1];
    arg = B * inv(P) * B';
    R = ricc(A, arg, Q, "cont");
    
    KLQ = inv(P) * B' * R;
    
    disp(KLQ, 'K =');
    
    FLQ = A - B * KLQ;
    phi_FLQ = expm(FLQ*dt);
    disp(phi_FLQ, 'phi_FLQ = ');
    
    
    XLQ = [zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo)];
    XLQ(1,1) = 3.7;
    XLQ(2,1) = 1.2;
    XLQ(3,1) = 2.6;
    
    m=size(vetor_tempo);
    n=m(2);
    for i = 1:n-1
        XLQ(:,i+1) = phi_FLQ*XLQ(:,i);
    end;
    
//    scf(j)
//    plot(vetor_tempo, XLQ(1,:))
//    plot(vetor_tempo, XLQ(2,:), 'red')
//    plot(vetor_tempo, XLQ(3,:), 'green')
//    legend('Tanque 1', 'Tanque 2', 'Tanque 3', [-1])
end


polos = [-2-2*%i, -2+2*%i,-3]
C = zeros((3,3))
C(1,1) = 1
Ko = (ppol(A', C', polos))'
disp(Ko, 'Ko = ')

C = zeros((3,3))
C(1,1) = 1
Po = [1]
Qo = eye((3,3))

Ro=ricc(A',C'*inv(Po)*C,Qo,'cont')
Ko = inv(Po) * C' * Ro


O = A - Ko * C
phi_O = expm(O*dt)

X_O = [zeros(vetor_tempo); zeros(vetor_tempo); zeros(vetor_tempo)];
X_O(1,1) = 0.5;
X_O(2,1) = 0.5;
X_O(3,1) = 0.5;

m=size(vetor_tempo);
n=m(2);
for i = 1:n-1
    X_O(:,i+1) = phi_O*X_O(:,i);
end;

scf(0)
plot(vetor_tempo, X_O(1,:))
plot(vetor_tempo, X_O(2,:), 'red')
plot(vetor_tempo, X_O(3,:), 'green')
legend('Tanque 1', 'Tanque 2', 'Tanque 3', [-1])
