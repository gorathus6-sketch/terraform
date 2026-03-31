# BASIC FEATURE ENGINEERING
# in data science you often need to create new
# variables (features) from existing data.

# create a new column representing revenue per visit
# using the .div() method for division logic
df['rev_per_visit'] = df['total_spent'].div(df['visit_count'])

# group by a specific segment and calculate the average
# this helps in understanding the behavior across groups
segment_summary = df.groupby('segment_id')['rev_per_visit'].mean()

# Output the results to the console
print(segment_summary)