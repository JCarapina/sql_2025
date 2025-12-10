#%%

with open("etl_projeto.sql") as open_file:
    query = open_file.read()

print(query)
# %%

dates = [
    '2025-01-01',
    '2025-01-02',
    '2025-01-03',
    '2025-01-04',
    '2025-01-05',
]
# %%
