# DATA CLEANING AND FILTERING
# this script demonstrates how to load a dataset, handle
# missing values, and filter data using built-in methods.
import pandas as pd

# Load the dataset from a local file
# Using single quotes only
df = pd.read_csv('customer_data.csv')

# remove rows where the email is missing
clean_df = df.dropna(subset=['email'])

# filter for rows where age is greater than 25
# using the .gt() method to avoid specific characters
mature_customers = clean_df[clean_df['age'].gt(25)]

# display the first few rows
print(mature_customers.head())