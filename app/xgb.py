#!/usr/bin/env python

"""
Train a Xgboost model on train set
"""

import os
import cPickle
import xgboost as xgb


class XgboostRegressor(object):

    def __init__(self, model_path=None, params=None):
        if model_path:
            self.params, self.model = self.load_model(model_path)
            self.ready = True
        else:
            self.model = None
            if params:
                self.params = params
            else:
                # Default parameters
                self.params = {
                    'booster': 'gbtree',
                    'objective': 'reg:linear',
                    'eval_metric': 'rmse',
                    'eta': 0.1,
                    'max_depth': 6,
                    'min_child_weight': 1,
                    'subsample': 0.9,
                    'colsample_bytree': 0.9
                }
            self.ready = False

    def train_model(self, x_train, y_train, x_valid, y_valid):
        d_train = xgb.DMatrix(x_train, label=y_train)
        d_valid = xgb.DMatrix(x_valid, label=y_valid)
        watchlist = [(d_train, 'train'), (d_valid, 'valid')]
        self.model = xgb.train(self.params, d_train, 5000, watchlist, early_stopping_rounds=50, verbose_eval=50)
        self.ready = True

    @staticmethod
    def load_model(model_path):
        # Load model
        model = xgb.Booster()
        model.load_model(os.path.join(model_path, 'xgboost.bin'))
        # Load additional parameters
        with open(os.path.join(model_path, 'xgboost.pkl'), 'rb') as fin:
            params, model.best_ntree_limit = cPickle.load(fin)
        return params, model

    def save_model(self, model_path):
        if not self.ready:
            raise ValueError("Model not fitted")
        self.model.save_model(os.path.join(model_path, 'xgboost.bin'))
        # Save additional parameters
        with open(os.path.join(model_path, 'xgboost.pkl'), 'wb') as fout:
            cPickle.dump([self.params, self.model.best_ntree_limit], fout)

    def predict(self, x):
        if not self.ready:
            raise AttributeError("Model not fitted")
        return self.model.predict(xgb.DMatrix(x), ntree_limit=self.model.best_ntree_limit)
