import pandas as pd
import numpy as np
import scipy.stats as stats

import matplotlib.pyplot as plt
import seaborn as sns

if __name__ == "__main__":
    data = pd.read_csv('./data.csv', sep = ";")

    data['Anel'] = pd.Series([15,15,15,4,4,4,11,11,11,7,7,7])

    # Se tiver uma coluna chamada Unnamed: 0 ele tira
    try:
        data = data.drop(columns = ['Unnamed: 0'])
    except:
        pass

    data = data.set_index(['Anel', 'Medida'])

    caracteristicas = data.copy().drop(columns = ['1','2','3','4','5','6','7','8','9','10'])
    
    caracteristicas['1º Quartil'] = data.apply(lambda row: row.quantile(q = 0.25), axis = 1)
    caracteristicas['Mediana'] = data.apply(lambda row: row.median(), axis = 1)
    caracteristicas['Média'] = data.apply(lambda row: row.mean(), axis = 1)
    caracteristicas['3º Quartil'] = data.apply(lambda row: row.quantile(q = 0.75), axis = 1)
    caracteristicas['Interquartil'] = data.apply(lambda row: stats.iqr(row), axis = 1)
    caracteristicas['Curtose'] = data.apply(lambda row: row.kurtosis(), axis = 1)

    caracteristicas.to_csv('./caracteristicas.csv')

    for medida in ['Diâmetro (mm)', 'Massa (g)', 'Comprimento (mm)']:
        df_medida = data.reset_index().loc[data.reset_index()['Medida'] == medida].drop(columns = ['Medida']).T
        df_medida = df_medida.rename(columns=df_medida.iloc[0]).drop(df_medida.index[0]).reset_index()
        df_medida = pd.melt(df_medida, id_vars=['index'], value_vars=[15.,4.,11.,7.])
        df_medida['index'] = df_medida['index'].apply(lambda x: int(x))
        df_medida.columns = ['Medição', 'Anel', medida]

        plt.figure(figsize=(20, 12))
        sns.set(style="whitegrid")
        ax = sns.boxplot(x="Anel", y=medida, data=df_medida)
        ax.set_xlabel("Anel",fontsize=20)
        ax.set_ylabel(medida,fontsize=20)
        ax.tick_params(labelsize=15)
        plt.savefig(f'boxplot_{medida}.png', dpi=300)
    
    def mean_confidence_interval(data, confidence=0.95):

        a = 1.0 * np.array(data)
        n = len(a)
        m, se = np.mean(a), stats.sem(a)
        h = se * stats.t.ppf((1 + confidence) / 2., n-1)
        return [m, m-h, m+h]

    ci = data.copy().drop(columns = ['1','2','3','4','5','6','7','8','9','10'])
    
    ci['aux'] = data.apply(lambda row: mean_confidence_interval(row), axis = 1)
    ci['Intervalo Superior'] = ci['aux'].apply(lambda x: x[2])
    ci['Média'] = ci['aux'].apply(lambda x: x[0])
    ci['Intervalo Inferior'] = ci['aux'].apply(lambda x: x[1])
    ci = ci.drop(columns = ['aux']).reset_index()

    ci.to_csv('./confidence_interval.csv', index = False)
