# %%
import kaggle
api = kaggle.KaggleApi()
# %%
api.authenticate()
# %%
api.dataset_download_file(
    dataset='teocalvo/teomewhy-loyalty-system',
    file_name='database.db'
)
# %%
import shutil
shutil.move("database.db","data/database.db")
# %%