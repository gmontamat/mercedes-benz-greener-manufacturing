#!/usr/bin/env python

"""
Main app: each function controls a step in the process

1. load_data(): load train and test sets and encode their categorical variables
2. train_model(): load pre-processed train set and train a model on it
3. predict(): load test set and predict "y" using the trained model
"""

import numpy as np
import pandas as pd

from csv import QUOTE_NONE
from sklearn.preprocessing import LabelEncoder
from sklearn.decomposition import PCA, FastICA, TruncatedSVD
from sklearn.random_projection import GaussianRandomProjection, SparseRandomProjection
from sklearn.metrics import r2_score

# User-defined modules
from xgb import XgboostRegressor


def add_decomposed_components(train, test, n=12):
    # Compute decomposed components
    pca = PCA(n_components=n)
    pca_results_train = pca.fit_transform(train.drop(['y'], axis=1))
    pca_results_test = pca.transform(test)
    ica = FastICA(n_components=n)
    ica_results_train = ica.fit_transform(train.drop(['y'], axis=1))
    ica_results_test = ica.transform(test)
    tsvd = TruncatedSVD(n_components=n)
    tsvd_results_train = tsvd.fit_transform(train.drop(['y'], axis=1))
    tsvd_results_test = tsvd.transform(test)
    grp = GaussianRandomProjection(n_components=n, eps=0.1)
    grp_results_train = grp.fit_transform(train.drop(['y'], axis=1))
    grp_results_test = grp.transform(test)
    srp = SparseRandomProjection(n_components=n, dense_output=True)
    srp_results_train = srp.fit_transform(train.drop(['y'], axis=1))
    srp_results_test = srp.transform(test)
    # Append decomposition components to data
    for i in xrange(1, n + 1):
        train['pca_{}'.format(i)] = pca_results_train[:, i - 1]
        train['ica_{}'.format(i)] = ica_results_train[:, i - 1]
        train['tsvd_{}'.format(i)] = tsvd_results_train[:, i - 1]
        train['grp_{}'.format(i)] = grp_results_train[:, i - 1]
        train['srp_{}'.format(i)] = srp_results_train[:, i - 1]
        test['pca_{}'.format(i)] = pca_results_test[:, i - 1]
        test['ica_{}'.format(i)] = ica_results_test[:, i - 1]
        test['tsvd_{}'.format(i)] = tsvd_results_test[:, i - 1]
        test['grp_{}'.format(i)] = grp_results_test[:, i - 1]
        test['srp_{}'.format(i)] = srp_results_test[:, i - 1]
    return train, test


def load_data(drop_groups=True, drop_features_in_groups=False):
    # Load data
    train = pd.read_csv('../data/train_preprocessed.csv')
    test = pd.read_csv('../data/test_preprocessed.csv')
    # Drop unwanted columns if required
    if drop_features_in_groups:
        features = set('::'.join([feature for feature in list(train) if '::' in feature]).split('::'))
        train = train.drop([feature for feature in list(train) if feature in features], axis=1)
        test = test.drop([feature for feature in list(test) if feature in features], axis=1)
    if drop_groups:
        train = train.drop([feature for feature in list(train) if '::' in feature], axis=1)
        test = test.drop([feature for feature in list(test) if '::' in feature], axis=1)
    # Encode categorical variables
    for feature in list(train):
        if train[feature].dtype == 'object':
            le = LabelEncoder()
            le.fit(list(train[feature].values) + list(test[feature].values))
            train[feature] = le.transform(list(train[feature].values))
            test[feature] = le.transform(list(test[feature].values))
    return add_decomposed_components(train, test)


def train_model(train):
    # Set model parameters
    params = {
        'objective': 'reg:linear',
        'eval_metric': 'rmse',
        'n_trees': 520,
        'eta': 0.0045,
        'max_depth': 4,
        'subsample': 0.93,
        'base_score': np.mean(train['y']),
        'silent': 1
    }
    xgb = XgboostRegressor(params=params)
    xgb.train_model(train.drop('y', axis=1).as_matrix(), train['y'].as_matrix())
    print "In-sample r^2: {}".format(r2_score(train['y'], xgb.predict(train.drop('y', axis=1).as_matrix())))
    # Save model
    xgb.save_model('../models')


def predict(test):
    # Load model
    xgb = XgboostRegressor(model_path='../models')
    # Predict
    test['y'] = xgb.predict(test.as_matrix())
    # Save submission
    test.to_csv('../data/submission_xgboost.csv', columns=['ID', 'y'], index=False, quoting=QUOTE_NONE)


if __name__ == '__main__':
    train, test = load_data()
    train_model(train)
    predict(test)
