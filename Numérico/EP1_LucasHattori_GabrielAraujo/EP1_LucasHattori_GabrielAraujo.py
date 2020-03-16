# -*- coding: utf-8 -*-
"""
CABEÇALHO

ALUNO: Lucas Hattori da Costa - 10335847
ALUNO: Gabriel de Sousa Araujo - 9299341

Turma 11 - Profº Pedro Peixoto

EXERCÍCIO-PROGRAMA 1
"""

import numpy as np
import math
import time


'''---------------------------MAIN------------------------------------'''
def main():
    funcao = int(input('O que tu quer rodar?\n'+
                    '1- Tarefa I (com itens a e b)\n'+
                    '2- Tarefa I (com itens c e d)\n'+
                    '3- Tarefa II (com a matriz exemplo do enunciado)\n'+
                    '4- Treinamento (todos os casos possíveis)\n'+
                    '5- Treinamento para um caso específico dado\n'+
                    '6- Classificação para todos os casos possíveis\n'+
                    '7- Avaliação de acertos de todos os casos possíveis\n->'))
    if funcao == 1:
        Tarefa_Iab()
    elif funcao == 2:
        Tarefa_Icd()
    elif funcao == 3:
        A = np.array([[0.3,0.6,0],[0.5,0,1],[0.4,0.8,0]])
        a = np.array([[0.31,0.6,0],[0.5,0,0.98],[0.49,0.81,0]])
        print(nmf(a,2))
        b = np.array([[0.29,0.6,0],[0.51,0,0.988],[0.39,0.8,0]])
        print(nmf(b,2))
        print('-------------------------')
        A_a = np.subtract(A,a)
        A_b = np.subtract(A,b)
        print(A_a,'\n',A_b)
    elif funcao == 4:
        n_treinos = [100,1000,4000]
        p = [5,10,15]
        for i in n_treinos:
            for j in p:
                treinamento_total(i,j)       
    elif funcao == 5:
        i = int(input('Número de imagens de treino: '))
        j = int(input('Dimensão do matriz classificadora (p):'))
        treinamento_total(i,j)
    elif funcao == 6:
        n_treinos = [100,1000,4000]
        p = [5,10,15]
        for i in n_treinos:
            for j in p:
                classificacao_total(i,10000,j) 
    elif funcao==7:
        n_treinos = [100,1000,4000]
        p = [5,10,15]
        n_test = [10000]
        for i in n_treinos:
            for j in p:
                for k in n_test:
                    avaliacao(k,i,j)


'''-------------------------------------------------------------------'''
def theta(W,i,j,k):
    if abs(W[i][k]) > abs(W[j][k]):
        tau = -(W[j][k])/(W[i][k])
        c = (math.sqrt(1+tau**2))**(-1)
        s = c*tau
    else:
        tau =  -(W[i][k])/(W[j][k])
        s = (math.sqrt(1+tau**2))**(-1)
        c = s*tau
    return c,s

def rot_givens(W,i,j,n,m,c,s):
    W[i,0:m] , W[j,0:m] = c * W[i,0:m] - s * W[j,0:m] , s * W[i,0:m] + c * W[j,0:m]
    return W

def triangularizar(W,A,linhas, colunas):
# Função que recebe uma matriz W e devolve uma matriz U triangular superior
# (W) -> np.array de dim nXm
# Retorna uma matriz W com as últimas (n-m) linhas zeradas
    for coluna in range(colunas):
        for linha in range(linhas-1,coluna, -1):
            x = W[linha][coluna]
            if abs(x) != 0:
                c,s = theta(W,linha-1,linha,coluna)
                W = rot_givens(W,linha-1,linha,linhas,colunas,c,s)
                A = rot_givens(A,linha-1,linha,A.shape[0],A.shape[1],c,s)
    return W, A

def sobredet(W, linhas,colunas):
    X = np.ones(colunas-1)
    contador = -1
    for linha in range(colunas-2, -1,-1):
        linha_aux = W[linha][:-1]
        coef_var = linha_aux[contador]
        linha_aux[contador] = 0
        soma = np.matmul(linha_aux, X)
        X[contador] = ((W[linha][-1])-(soma))/(coef_var)
        contador -= 1
    return X

def simult(W,A):# as colunas de A são os vetores de dim nx1 contendo as soluções dos sistemas
    X = []
    linhas, colunas = W.shape
    W,A = triangularizar(W,A,linhas,colunas)
    for coluna in range (A.shape[1]):
        w = np.append(W,np.array([A[:,coluna]]).transpose(),axis=1)
        x = sobredet(w,w.shape[0],w.shape[1])
        X.append(list(x))
    X = np.array(X)
    return X.T

#yes = simult(np.array([[1.,2,2],[2,1,1],[1,3,1],[3,1,3],[1,2,1]]),np.array([[11.,5,8],[7,4,7],[12,5,7],[12,7,13],[9,4,6]]))
#a1 = np.array([[1.,5],[2,3],[4,5],[6,6],[5.5,8]])
#a2 = np.array([[2.,3],[1,1]])
#A = np.einsum('ij,jk->ik',a1,a2)
#resposta = simult(a1,A)

def normalizar(a):
    a[:,0:a.shape[1]] /= (np.sqrt(np.einsum('ij,ij->j',a,a)))[0:a.shape[1]]
    return a

def nmf (A,p):
    W = np.random.rand(A.shape[0],p)#gera uma matriz com elementos aleatórios
    print(W)
    error = 1
    i = 0
    while abs(error) > 1e-5 and i<100:
        W = normalizar(W)
        A_aux = A.copy()
        H = simult(W,A_aux).clip(0)
        A_aux = A.copy()
        W = simult(H.T,A_aux.T).T.clip(0)
        matrix_error = (A - np.einsum('ij,jk->ik',W,H))#Diferença entre a A aproximada e A original
        error = np.sqrt(np.einsum('ij,ij->', matrix_error, matrix_error))#Cálculo do erro quadrático
        i+=1
    return W

def treinar(dig, ndig_treino, p):
    file_name = ('train_dig'+str(dig)+".txt")
    cols = np.arange(0,ndig_treino)
    A = np.loadtxt(file_name, usecols = cols)
    W_dig = nmf(A, p)
    return W_dig

def treinamento():
    ndig_treino = int(input('Número de imagens usadas para treino[int]:'))
    p = int(input('Dimensão de W[int]:'))
    start_time = time.time()
    W_dig = []
    for i in range(10):#Vamos treinar uma W para cada dígito
        print('Treinando para o algarismo',i)
        dig_time = time.time()
        W_i = treinar(i, ndig_treino, p)
        W_dig.append(W_i)
        print(time.time() - dig_time,' tempo', i)
    W_dig = np.array(W_dig)
    file_name = 'W_dig para '+str(ndig_treino)+' imagens de treino e dim '+str(p)
    np.save(file_name, W_dig)
    end_time = time.time()
    print(end_time - start_time,' para treinamento de ',ndig_treino,'x',p)

def treinamento_total(ndig_treino, p):
    start_time = time.time()
    W_dig = []
    for i in range(10):#Vamos treinar uma W para cada dígito
        print('Treinando para o algarismo',i)
        dig_time = time.time()
        W_i = treinar(i, ndig_treino, p)
        W_dig.append(W_i)
        print(time.time() - dig_time,' tempo', i)
    W_dig = np.array(W_dig)
    file_name = 'W_dig para '+str(ndig_treino)+' imagens de treino e dim '+str(p)
    np.save(file_name, W_dig)
    end_time = time.time()
    print(end_time - start_time,' para treinamento de ',ndig_treino,'x',p)

def classificar(ndig_treino, n_test, p, W_dig, test_images):
    classify_time = time.time()
    error = np.zeros(n_test)
    X = np.zeros(n_test)
    for i in range(10):
        print('classificando', i)
        t = test_images.copy()
        A_i = np.einsum('ij,jk-> ik',W_dig[i],simult(W_dig[i], t))
        error_matrix = t - A_i
        new_error = np.sqrt(np.einsum('ij,ij->j', (error_matrix), (error_matrix)))
        for j in range(n_test):
            if abs(new_error[j]) < abs(error[j]) or  error[j] == 0.:
                error[j] = (new_error[j])
                X[j] = i
    end_time = time.time()
    print('Tempo de classificação para ', ndig_treino,'  ',p,': ',end_time-classify_time)
    return X, error



def classificacao():
    ndig_treino = int(input('Número de imagens de treino:'))
    n_test = int(input('Número de imagens para teste:'))
    p = int(input('Dimensão da W (p):'))
    w_name = 'W_dig para '+str(ndig_treino)+' imagens de treino e dim '+str(p)+'.npy'
    t = np.loadtxt('test_images.txt', usecols = np.arange(n_test))
    w = np.load(w_name)
    x, erro  = classificar(ndig_treino, n_test, p,w,t)
    file_x = 'X para '+str(ndig_treino)+' imagens de treino '+str(n_test)+' imagens de teste e dim '+str(p)
    np.save(file_x, x)
    file_erro = 'erro para '+str(ndig_treino)+' '+str(n_test)+' '+str(p)
    np.save(file_erro,erro)

def classificacao_total(ndig_treino, n_test, p):
    w_name = 'W_dig para '+str(ndig_treino)+' imagens de treino e dim '+str(p)+'.npy'
    t = np.loadtxt('test_images.txt', usecols = np.arange(n_test))
    w = np.load(w_name)
    x, erro  = classificar(ndig_treino, n_test, p,w,t)
    file_x = 'X para '+str(ndig_treino)+' imagens de treino '+str(n_test)+' imagens de teste e dim '+str(p)
    np.save(file_x, x)
    file_erro = 'erro para '+str(ndig_treino)+' '+str(n_test)+' '+str(p)
    np.save(file_erro,erro)

def cria_item_a():
    n = 64
    W=[]
    for i in range(n):
        linha_zero = (n+1)*[0]
        W.append(linha_zero)
    for i in range(len(W)):
        for j in range(len(W[0])):
            if j == n:
                W[i][j] = 1
            elif i==j:
                W[i][j] = 2.
            elif abs(i-j)==1:
                W[i][j] = 1
            elif abs(i-j)>1:
                W[i][j] = 0
    W = np.array(W)
    return W

def cria_item_b():
    n = 20
    m = 17
    W=[]
    for i in range(n):
        linha_zero = (m+1)*[0]
        W.append(linha_zero)
    
    for i in range(len(W)):
        for j in range(len(W[0])):
            if j ==m:
                W[i][j] = i
            
            elif abs(i-j)<=4:
                W[i][j] = 1./(i+j-1+2)
    
            else:
                W[i][j] = 0
    W = np.array(W)
    return W

def Tarefa_Iab():
    a = cria_item_a()
    b = cria_item_b()
    resposta_a = sobredet(a)
    resposta_b = sobredet(b)
    print('A resposta do item a é:\n',resposta_a,'\n--------------------\nA resposta do item b é:\n',resposta_b)

def Tarefa_Icd():
    a = cria_item_a()
    a = a[:,:-1]
    c1 = np.ones(64)
    c2 = np.arange(64)
    c3 = 2*np.arange(64) - np.ones(64)
    c12 = np.append(np.array([c1]).T, np.array([c2]).T, axis = 1)
    C = np.append(c12, np.array([c3]).T, axis = 1)
    resposta_c = simult(a, C)
    b = cria_item_b()
    b = b[:,:-1]
    print(b.shape)
    d = C[:20,:]
    resposta_d = simult(b,d)
    print('\n----------------------------------------\nA resposta do item c é:\n',resposta_c,'\n-----------------\nA resposta do item d é:\n',resposta_d)

def avaliacao(n_test,ndig_treino,p):
    resposta = np.loadtxt('test_index.txt')
    nome_x = 'X para '+str(ndig_treino)+' imagens de treino '+str(n_test)+' imagens de teste e dim '+str(p)+'.npy'
    X = np.load(nome_x)
    acertos = abs(X - resposta)
    n_acertos = 0
    for element in acertos:
        if element ==0:
            n_acertos +=1
    percent_acerto = (n_acertos/n_test)*100
    acertos_dig = np.zeros(10)
    count_dig = np.zeros(10)
    for indice in range(resposta.shape[0]):
        x = int(resposta[indice])
        if acertos[indice] == 0:
            acertos_dig[x] += 1
        count_dig[x] += 1
    print('Percent_total para ',n_test,' ',ndig_treino,' ',p,':',percent_acerto)
    percent_dig = (acertos_dig/count_dig)*100
    percent_dig = np.hstack((percent_dig,percent_acerto))
    percent_file = str(ndig_treino)+' '+str(p)+str('.txt')
    print(count_dig)
    np.savetxt(percent_file, percent_dig)

    
main()