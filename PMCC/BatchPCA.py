import os
import sys
import pickle
import numpy as np
from sklearn.decomposition import PCA, KernelPCA
from LoadMcc import *

if len(sys.argv)!=5:
    print 'BatchPMcc real_mcc_dir save_pmcc_dir pca_model sample_mean'
    exit()


def Transform(Model,sample_mean,X,sigma=None):
    if not sigma is None:
        X = np.exp(-1*X/(2*sigma))
    X = X-sample_mean
    X = np.dot(X, Model)
    return X

#pca = pickle.load(open(sys.argv[3],'rb'))
pca = np.load(sys.argv[3])
sample_mean = np.loadtxt(sys.argv[4])

if not os.path.isdir(sys.argv[2]):
    os.mkdir(sys.argv[2])
NS = 16
ND = 5
for f in open(sys.argv[1]):
    f = f.strip()
    print f
    #X = np.loadtxt(f)
    Mcc,Msk=LoadMcc(f, NS, ND)[-2:]
    Msk = np.repeat(Msk, ND, axis=1)
    Mcc = Mcc[Msk==1]
    Mcc = np.reshape(Mcc, (Msk.shape[0],Mcc.shape[0]/Msk.shape[0]))
    #X = X-sample_mean
    #X = pca.transform(X)
    #X = Transform(pca,sample_mean,Mcc,0.256225809315)
    X = Transform(pca,sample_mean,Mcc)
    X[X>=0] = 1
    X[X<0] = 0
    X = X.astype(np.uint8)
    SavePMcc(sys.argv[2]+'/'+f.split('/')[-1], X)
