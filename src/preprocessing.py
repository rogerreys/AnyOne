
from typing import Tuple
import numpy as np
import pandas as pd
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import MinMaxScaler, OneHotEncoder, OrdinalEncoder


def preprocess_data(
    train_df: pd.DataFrame, val_df: pd.DataFrame, test_df: pd.DataFrame
) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
    """
    Pre processes data for modeling. Receives train, val and test dataframes
    and returns numpy ndarrays of cleaned up dataframes with feature engineering
    already performed.

    Arguments:
        train_df : pd.DataFrame
        val_df : pd.DataFrame
        test_df : pd.DataFrame

    Returns:
        train : np.ndarrary
        val : np.ndarrary
        test : np.ndarrary
    """
    # Print shape of input data
    print("Input train data shape: ", train_df.shape)
    print("Input val data shape: ", val_df.shape)
    print("Input test data shape: ", test_df.shape, "\n")

    # Make a copy of the dataframes
    working_train_df = train_df.copy()
    working_val_df = val_df.copy()
    working_test_df = test_df.copy()

    # 1. Correct outliers/anomalous values in numerical
    # columns (`DAYS_EMPLOYED` column).
    working_train_df["DAYS_EMPLOYED"].replace({365243: np.nan}, inplace=True)
    working_val_df["DAYS_EMPLOYED"].replace({365243: np.nan}, inplace=True)
    working_test_df["DAYS_EMPLOYED"].replace({365243: np.nan}, inplace=True)

    # 2. TODO Encode string categorical features (dytpe `object`):
    #     - If the feature has 2 categories encode using binary encoding,
    #       please use `sklearn.preprocessing.OrdinalEncoder()`. Only 4 columns
    #       from the dataset should have 2 categories.
    #     - If it has more than 2 categories, use one-hot encoding, please use
    #       `sklearn.preprocessing.OneHotEncoder()`. 12 columns
    #       from the dataset should have more than 2 categories.
    # Take into account that:
    #   - You must apply this to the 3 DataFrames (working_train_df, working_val_df,
    #     working_test_df).
    #   - In order to prevent overfitting and avoid Data Leakage you must use only
    #     working_train_df DataFrame to fit the OrdinalEncoder and
    #     OneHotEncoder classes, then use the fitted models to transform all the
    #     datasets.
    two_categories = []
    rest_of_categories = []

    for column in train_df:
        if train_df[column].dtype == "object":
            if train_df[column].nunique() == 2:
                two_categories.append(column)
            else:
                rest_of_categories.append(column)

    ordinale_encode = OrdinalEncoder()
    ordinale_encode.fit(train_df[two_categories])

    train_df[two_categories] = ordinale_encode.transform(train_df[two_categories])
    val_df[two_categories] = ordinale_encode.transform(val_df[two_categories])
    test_df[two_categories] = ordinale_encode.transform(test_df[two_categories])

    '''def transform_data( X_train: pd.DataFrame, X_val: pd.DataFrame, X_test: pd.DataFrame, dos_categorias: list,
    mas_dos_categorias: list,
) -> pd.DataFrame:
    # One-hot encoding
    one_hot_encoder = OneHotEncoder()
    # Ordinal encoding
    ordinal_encoder = OrdinalEncoder()
    transformers = [
        ("one_hot", one_hot_encoder, mas_dos_categorias),
        ("ordinal", ordinal_encoder, dos_categorias),
    ]
    # Crear el ColumnTransformer
    column_transformer = ColumnTransformer(transformers, remainder="passthrough")
    # Aplicar la transformación a los datos de entrenamiento
    transformed_X_train = column_transformer.fit_transform(X_train)
    # Aplicar la transformación a los datos de prueba y validación
    transformed_X_val = column_transformer.transform(X_val)
    transformed_X_test = column_transformer.transform(X_test)
    return transformed_X_train, transformed_X_val, transformed_X_test
'''
    print("train_encoder ",train_df.shape)
    print("test_encoder ",test_df.shape)
    print("val_encoder ",val_df.shape)

    onehot_Encode = OneHotEncoder( handle_unknown='ignore', sparse_output=False)
    onehot_Encode.fit(train_df[rest_of_categories])

    train_transformed = onehot_Encode.transform(train_df[rest_of_categories])
    test_transformed = onehot_Encode.transform(test_df[rest_of_categories])
    val_transformed = onehot_Encode.transform(val_df[rest_of_categories])
    
    train_encoder = pd.DataFrame(train_transformed, columns=onehot_Encode.get_feature_names_out())
    test_encoder = pd.DataFrame(test_transformed, columns=onehot_Encode.get_feature_names_out())
    val_encoder = pd.DataFrame(val_transformed, columns=onehot_Encode.get_feature_names_out())

    print("\ntrain_encoder ",train_encoder.shape)
    print("test_encoder ",test_encoder.shape)
    print("val_encoder ",val_encoder.shape)
    
    train_df = train_df.reset_index(drop=True)
    val_df = val_df.reset_index(drop=True)
    test_df = test_df.reset_index(drop=True)

    train = pd.concat([train_df, train_encoder], axis=1)
    test = pd.concat([test_df, test_encoder], axis=1)
    val = pd.concat([val_df, val_encoder], axis=1)

    print("\ntrain ",train_encoder.shape)
    print("test ",test_encoder.shape)
    print("val ",val_encoder.shape)

    train_encoder = train.drop(columns=rest_of_categories)
    test_encoder = test.drop(columns=rest_of_categories)
    val_encoder = val.drop(columns=rest_of_categories)


    # 3. TODO Impute values for all columns with missing data or, just all the columns.
    # Use median as imputing value. Please use sklearn.impute.SimpleImputer().
    # Again, take into account that:
    #   - You must apply this to the 3 DataFrames (working_train_df, working_val_df,
    #     working_test_df).
    #   - In order to prevent overfitting and avoid Data Leakage you must use only
    #     working_train_df DataFrame to fit the SimpleImputer and then use the fitted
    #     model to transform all the datasets.

    simpleImputer = SimpleImputer(strategy='mean')
    simpleImputer.fit(train_encoder)

    train_imputer = simpleImputer.transform(train_encoder)
    test_imputer = simpleImputer.transform(test_encoder)
    val_imputer = simpleImputer.transform(val_encoder)

    # 4. TODO Feature scaling with Min-Max scaler. Apply this to all the columns.
    # Please use sklearn.preprocessing.MinMaxScaler().
    # Again, take into account that:
    #   - You must apply this to the 3 DataFrames (working_train_df, working_val_df,
    #     working_test_df).
    #   - In order to prevent overfitting and avoid Data Leakage you must use only
    #     working_train_df DataFrame to fit the MinMaxScaler and then use the fitted
    #     model to transform all the datasets.
    min_max = MinMaxScaler()
    min_max.fit(train_imputer)
    
    train_minmax = min_max.transform(train_imputer)
    test_minmax = min_max.transform(test_imputer)
    val_minmax = min_max.transform(val_imputer)

    return train_minmax, val_minmax, test_minmax
