import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.svm import SVR
from sklearn.metrics import mean_squared_error
from sklearn.impute import SimpleImputer
import numpy as np

def sort_dataset(dataset_df):
    return dataset_df.sort_values(by='year')

def split_dataset(dataset_df):
    X = dataset_df.drop('salary', axis=1)
    y = dataset_df['salary']
    return train_test_split(X, y, test_size=0.2, random_state=42)

def extract_numerical_cols(dataset_df):
    return dataset_df.select_dtypes(include=['number'])

def train_predict_decision_tree(X_train, Y_train, X_test):
    model = DecisionTreeRegressor()
    model.fit(X_train, Y_train)
    return model.predict(X_test)

def train_predict_random_forest(X_train, Y_train, X_test):
    model = RandomForestRegressor()
    model.fit(X_train, Y_train)
    return model.predict(X_test)

def train_predict_svm(X_train, Y_train, X_test):
    model = SVR()
    model.fit(X_train, Y_train)
    return model.predict(X_test)

def calculate_RMSE(labels, predictions):
    return np.sqrt(mean_squared_error(labels, predictions))

if __name__=='__main__':
    # Loading data
    data_df = pd.read_csv('2019_kbo_for_kaggle_v2.csv')
    
    # data preprocessing
    sorted_df = sort_dataset(data_df)    
    X_train, X_test, Y_train, Y_test = split_dataset(sorted_df)
    X_train = extract_numerical_cols(X_train)
    X_test = extract_numerical_cols(X_test)

    # missing value processing
    imputer = SimpleImputer(strategy='mean')
    X_train = imputer.fit_transform(X_train)
    X_test = imputer.transform(X_test)

    # Training models and predictions
    dt_predictions = train_predict_decision_tree(X_train, Y_train, X_test)
    rf_predictions = train_predict_random_forest(X_train, Y_train, X_test)
    svm_predictions = train_predict_svm(X_train, Y_train, X_test)
    
    # Calculate and print RMSE
    print("Decision Tree Test RMSE: ", calculate_RMSE(Y_test, dt_predictions))
    print("Random Forest Test RMSE: ", calculate_RMSE(Y_test, rf_predictions))
    print("SVM Test RMSE: ", calculate_RMSE(Y_test, svm_predictions))
