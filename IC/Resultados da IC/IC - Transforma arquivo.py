'''
  Lê arquivo .txt e devolve um arquivo .csv
  '''

import csv

nome_file = input('Nome do arquivo .txt: ')
epoch = int(input('Número de epochs: '))
dados = nome_file[:-3]
dados = dados+'csv'

with open(dados, 'a', newline = '') as planilha:
    c = csv.writer(planilha)
    c.writerow(["Epoch","Tempo de duração de cada época","loss","acc","val_loss","val_acc"])

    file = open(nome_file, 'r')

    texto = file.readlines()

    for i in range (0, 2*epoch, 2):
        if len(texto[i]) < 12:
            c.writerow([texto[i][6], (texto[i+1][43]+texto[i+1][44]), texto[i+1][55:61], texto[i+1][69:76], texto[i+1][88:95], texto[i+1][106:112]])
        else:
            c.writerow([texto[i][6:8], (texto[i+1][43]+texto[i+1][44]), texto[i+1][55:61], texto[i+1][69:76], texto[i+1][88:95], texto[i+1][106:112]])

file.close()

