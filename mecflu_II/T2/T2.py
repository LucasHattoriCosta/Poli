'''
 Script para resolução do item g do Trabalho II da disciplina Mecânica dos Fluidos II
 Autor: Lucas Hattori Costa
 NUSP: 10335847
'''

# Bibliotecas de vetores
import numpy as np

# Cálculo dos parâmetros
D = 0.05 # m
R = D/2 # m
C_D = 0.47
frac_rho = 1.1 + 0.4 * 1
V_0 = 1. + 0.1 * 0.0 # m/s
g = 9.81 # m/s^2
alpha = - g * (frac_rho - 1)
beta = - 0.75 * frac_rho * C_D / D

# Cálculo do tempo máximo
T = - 1 * np.arctan(V_0 / np.sqrt(alpha/beta)) / (beta * np.sqrt(alpha/beta))
t_final = 2*T

# Definição do vetor tempo de integração
vetor_tempo, dt = np.linspace(0,t_final,100, retstep=True)

# Método de Euler de 1ª ordem
z = np.zeros(len(vetor_tempo))
V = np.zeros(len(vetor_tempo))
V[0] = V_0

for t in range(len(vetor_tempo) - 1):
    V[t+1] = (alpha + beta * np.abs(V[t]) * V[t]) * dt + V[t]
    z[t+1] = V[t] * dt + z[t]

#####################################################
# Plotando e salvando as imagens
import matplotlib.pyplot as plt
import seaborn as sns

plt.figure(figsize=(15, 6))
sns.set(style="darkgrid")

ax = sns.lineplot(x = vetor_tempo, y = z, label = 'z(t)')
plt.scatter(vetor_tempo[0],z[0], color='red', marker='o', label='Profundidade inicial = 0')
plt.scatter(vetor_tempo[-1],z[-1],color='green', marker='o', label=f'Profundidade final = {round(z[-1],4)}')
plt.scatter(T, np.amax(z),color='orange', marker='o', label=f'Profundidade máxima = {round(np.amax(z),4)}')
ax.legend(fontsize = 15)
ax.set_title('Cota da esfera em função do tempo (m)', fontsize = 17)
ax.set_xlabel("Tempo (s)",fontsize=15)
ax.tick_params(labelsize=15)
plt.legend(loc='upper left')

plt.savefig('./z_t.png')

plt.figure(figsize=(15, 6))
sns.set(style="darkgrid")

ax1 = sns.lineplot(x = vetor_tempo, y = V, label = 'V(t)')
plt.scatter(vetor_tempo[0],V[0],color='red',  marker='o', label=f'Velocidade inicial = {round(V_0,4)}')
plt.scatter(vetor_tempo[-1],V[-1],color='green', marker='o', label=f'Velocidade final = {round(V[-1],4)}')
ax1.axhline(0, color='k', linestyle='--')
ax1.legend(fontsize = 15)
ax1.set_title('Velocidade vertical da esfera em função do tempo (m/s)', fontsize = 17)
ax1.set_xlabel("Tempo",fontsize=15)
ax1.tick_params(labelsize=15)

plt.savefig('./v_t.png')


########################################
# Salvar vetores
from tabulate import tabulate
import pandas as pd

array_complete = np.array((vetor_tempo, z, V)).T
array_complete = pd.DataFrame(array_complete)
array_complete.columns = ['Tempo', 'Cota', 'Velocidade']

np.savetxt(f"./mecflu_II/tabela_T2.txt", array_complete.to_numpy(), delimiter=' & ', fmt='%2.2e', newline=' \\\\\n')