#!/usr/bin/env python

"""
Main app: each function controls a step in the process

1. train_model(): load pre-processed train set and train a model on it
2. predict(): load test set and predict "y" using the trained model
"""

import pandas as pd

from csv import QUOTE_NONE
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder


# User-defined modules
from xgb import XgboostRegressor


def train_model():
    # Load train data
    df = pd.read_csv('../data/train_preprocessed.csv')
    # Encode categorical variables
    for feature in list(df):
        if df[feature].dtype == 'object':
            le = LabelEncoder()
            le.fit(list(df[feature].values))
            df[feature] = le.transform(list(df[feature].values))
    # Split train data for cross-validation
    train, validation = train_test_split(df, test_size=0.05)
    # Train model
    features = [column for column in list(train) if column not in ['y']]
    xgb = XgboostRegressor()
    xgb.train_model(
        train[features].as_matrix(), train['y'].as_matrix(),
        validation[features].as_matrix(), validation['y'].as_matrix()
    )
    # Save model
    xgb.save_model('../models')


def predict():
    # Load model
    xgb = XgboostRegressor(model_path='../models')
    # Load test data
    test = pd.read_csv('../data/test_preprocessed.csv')
    # Encode categorical variables
    for feature in list(test):
        if test[feature].dtype == 'object':
            le = LabelEncoder()
            le.fit(list(test[feature].values))
            test[feature] = le.transform(list(test[feature].values))
    # Predict
    test['y'] = xgb.predict(test.as_matrix())
    # Save submission
    test.to_csv('../data/submission.csv', columns=['ID', 'y'], index=False, quoting=QUOTE_NONE)

if __name__ == '__main__':
    train_model()
    predict()
