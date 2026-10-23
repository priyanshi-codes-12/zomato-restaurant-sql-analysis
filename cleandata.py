import pandas as pd

df = pd.read_csv('zomato.csv', encoding='latin1')
# print(df.shape)
# print(df.columns.tolist())
# print(df.head(2))

cols_to_drop = ['url', 'address', 'phone', 'menu_item', 'reviews_list', 'dish_liked']
df = df.drop(columns=cols_to_drop, errors='ignore')
# print("Columns drop hone ke baad shape:", df.shape)

df = df.drop_duplicates(subset=['name','location'], keep='first')
# print("Unique restaurants bachne ke baad shape:", df.shape)

# print(df['rate'].unique()[:15])
# Check karte hain kitni rows me '/5' ya 'NEW' ya '-' nahi hai
import numpy as np

def clean_rate(val):
    val = str(val)
    if val == 'nan' or val == 'NEW' or val == '-':
        return np.nan
    # Agar '/5' laga hua hai toh pehla part uthao
    if '/5' in val:
        return float(val.split('/')[0].strip())
    return np.nan
# Ab ise rate column par apply karo
df['rate'] = df['rate'].apply(clean_rate)

# print("Clean hone ke baad unique rates (sample):")
# print(df['rate'].dropna().unique()[:10])
# print("\nRate column ka data type:", df['rate'].dtype)




# approx_cost
# print(df['approx_cost(for two people)'].unique()[:15])
# 1. Column rename karo
df.rename(columns={'approx_cost(for two people)': 'cost_for_two'}, inplace=True)

# 2. Comma hata kar float me convert karne ka function
def clean_cost(val):
    if pd.isna(val):
        return np.nan
    val_str = str(val).replace(',', '').strip()
    return float(val_str)

df['cost_for_two'] = df['cost_for_two'].apply(clean_cost)

# print("Cost clean hone ke baad data type:", df['cost_for_two'].dtype)
# print("Cost summary (Min, Max, Mean):")
# print(df['cost_for_two'].describe())  #61 rows had missing/empty this column


# na koi missing value hai, aur dono me sirf binary 'Yes' aur 'No' values hain.
# print("Online order values:\n", df['online_order'].value_counts(dropna=False))
# print("\nBook table values:\n", df['book_table'].value_counts(dropna=False))


# Clean data ko nayi CSV file me save karo
# df.to_csv('zomato_cleaned.csv', index=False)
# print("File successfully saved as zomato_cleaned.csv!")

# 4 steps of data cleaning
'''
print("--- 1. DATA TYPES CHECK ---")
print(df.dtypes)

print("\n--- 2. MISSING VALUES (NULLS) CHECK ---")
print(df.isnull().sum())

print("\n--- 3. DUPLICATES CHECK ---")
print("Duplicate count:", df.duplicated(subset=['name', 'location']).sum())

print("\n--- 4. DATA SANITY CHECK ---")
print("Min-Max of Rate:", df['rate'].min(), "to", df['rate'].max())
print("Min-Max of Cost:", df['cost_for_two'].min(), "to", df['cost_for_two'].max())
'''


# Jin 11 rows me location missing hai unhe drop karo
df = df.dropna(subset=['location'])

# print("Location me ab nulls:", df['location'].isnull().sum())
# print("Total valid restaurants bache:", len(df))
# print("Location me total nulls:", df['location'].isnull().sum()) #11