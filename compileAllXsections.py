import pandas as pd 

inputData = pd.read_csv('input.csv')

allData = pd.DataFrame()

for index, row in inputData.iterrows():

    print("Retrieving: n2={}, ch1={} and n1 = {}".format(row['n2'], row['ch1'], row['n1']))
    
    temp = pd.read_csv('./results/xSection/n2_{}_ch1_{}_n1_{}/xsection.dat'.format(row['n2'], row['ch1'], row['n1']))
    
    allData = pd.concat([allData,temp])
    
    allData.to_csv('./results/xSection/allRestuls.csv', index=False)

print(allData)


