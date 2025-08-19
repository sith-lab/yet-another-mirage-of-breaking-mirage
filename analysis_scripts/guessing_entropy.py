import numpy as np

ranks = np.loadtxt("ranks.txt", dtype=int) 

ge = 0
for rank in ranks:
   ge = ge + np.floor(np.log2(rank))

print(ge)
