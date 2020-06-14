import pandas as pd
import os

data = pd.read_csv('input.csv')

for index, row in data.iterrows():
    if row['ranXSec'] == 0:
        print("calculating xsections for: n2={}, ch1={} and n1 = {}".format(row['n2'], row['ch1'], row['n1']))
        
        os.system('./xSection/calcXSection.sh {} {} {}'.format(row['n2'], row['ch1'], row['n1']))

        data.at[index,'ranXSec'] = 1

        data.to_csv('input.csv',index=False)

    else:
        print("already calculated xsections for: n2={}, ch1={} and n1 = {}".format(row['n2'], row['ch1'], row['n1']))

    break
