#!/usr/bin/env python

"""
Stack models (manually, with previously defined weights)
"""

import pandas as pd

from csv import QUOTE_NONE


class ModelStacker(object):

    def __init__(self, model_list, model_weights, response='y'):
        assert sum(model_weights) == 1.0
        self.models = model_list
        self.weights = model_weights
        self.response = response
        self.stacked = self.models[0]   # Just copy the structure
        self.stacked[self.response] = .0

    def stack(self):
        for model, weight in zip(self.models, self.weights):
            self.stacked[self.response] += weight * model[self.response]

    def save(self):
        self.stacked.to_csv('../data/submission_stacked.csv', columns=['ID', 'y'], index=False, quoting=QUOTE_NONE)


if __name__ == '__main__':
    models = [pd.read_csv('../data/submission_one-liner.csv'), pd.read_csv('../data/submission_xgboost.csv')]
    ms = ModelStacker(models, [0.8, 0.2])
    ms.save()
