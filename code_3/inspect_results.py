import os
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# TODO: investigate if there is any signal at the single
# subject level. Is it a context shift that some people are
# making and others are not? Or is it s gradual across the
# board kind of thing?

# data_dir = "../rb_data/data/"
# h = ["block", "x", "y", "rfv", "cat", "resp", "veridical", "acc", "rt", "fbc"]

# data_dir = "../nc_63_data/"
data_dir = "../nc_63_data_new_batch/"
h = ["block", "x", "y", "cat", "resp", "acc", "rt", "c1", "c2", "c3", "c4"]

d_list = []
for i, f in enumerate(os.listdir(data_dir)):
    d = pd.read_csv(data_dir + f, sep=" ", names=h)
    # d["condition"] = 1 if d["fbc"].iloc[400] == 3 else 2
    d["subject"] = i
    d["trial"] = np.arange(1, d.shape[0] + 1, 1)
    d_list.append(d)

d = pd.concat(d_list)
d.reset_index(inplace=True)

d["c1"] = d["c1"].astype("category")
d["c2"] = d["c2"].astype("category")
d["c3"] = d["c3"].astype("category")
d["c4"] = d["c4"].astype("category")

d["acc"] = d["cat"] == d["resp"]

d["acc_smooth"] = d.groupby(["subject"], group_keys=False)["acc"].apply(
    lambda x: x.rolling(window=5, win_type="gaussian", center=True).mean(std=10.0)
)

# TODO: different files have different condition encodings
d["condition"] = d["c3"].astype("category")

fig, ax = plt.subplots(1, 1, squeeze=False)
sns.lineplot(data=d, x="trial", y="acc_smooth", hue="condition")
ax[0, 0].set_ylim(0.0, 1.0)
plt.show()
