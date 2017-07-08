#!/usr/bin/env python

"""
One-liner kernel
Source: https://www.kaggle.com/paulorzp/one-line-solution-in-python-lb-0-55453
"""

import pandas as pd

if __name__ == '__main__':
    test = pd.read_csv('../data/test.csv')
    test = test.join(pd.read_csv('../data/train.csv').groupby(['X0'])[['y']].mean(), on=['X0']).fillna(100.669)
    test.to_csv('../data/submission.csv', columns=['ID', 'y'], index=False)
