import matplotlib.pyplot as plt
import pandas as pd

df = pd.read_csv("ELF-HAWK-dump.csv")

fig = plt.figure(figsize=(18, 4))  # use figsize to make the figure wider
ax1 = fig.add_subplot(111)
ax1.plot(df["OSD.longitude"], df["OSD.latitude"])
fig.savefig("plot.png")

