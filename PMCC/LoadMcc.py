import sys
import os
import numpy as np
import cv2

def LoadMinu(filename):
    A = [f for f in open(filename)]
    # get image information
    width = int(A[0])
    height = int(A[1])
    Res = int(A[2])
    NumMinu = int(A[3])
    # get minutiae list
    M = [A[i] for i in range(4, 4+NumMinu)];
    Minu = [np.array(m.split(' '),dtype=float) for m in M]
    Minu = np.row_stack(Minu)
    Minu[:,2] = 2*np.pi - Minu[:,2]
    return Minu

def LoadMcc(filename, NS, ND):
    #print filename
    print filename
    A = [f for f in open(filename)]
    # get image information
    width = int(A[0])
    height = int(A[1])
    Res = int(A[2])
    NumMinu = int(A[3])
    # get minutiae list
    M = [A[i] for i in range(4, 4+NumMinu)];
    Minu = [np.array(m.split(' '),dtype=float) for m in M]
    Minu = np.row_stack(Minu)
    Minu[:,2] = 2*np.pi - Minu[:,2]

    #assume all mcc are valid,thus a 'True' befre each line
    NumMcc = int(A[4+NumMinu])
    M = [A[i][5:] for i in range(5+NumMinu,4+1+NumMinu+NumMcc)]
    Msk = [np.array(m.split()[:NS*NS], dtype=np.int) for m in M]
    Msk = np.row_stack(Msk)
    #Msk = np.repeat(Msk, ND, axis=1)
    Mcc = [np.array(m.split()[NS*NS:], dtype=np.float) for m in M]
    Mcc = np.row_stack(Mcc)

    # show
    #im = [np.reshape(Mcc[np.ix_([0],range(i,Msk.shape[1],ND))],(NS,NS)) for i in range(ND)]
    #im = np.column_stack(im)
    #cv2.normalize(im, im, 0, 255, cv2.NORM_MINMAX)
    #im = cv2.resize(im, (0,0), im, 12, 12, cv2.INTER_NEAREST)
    #cv2.imshow('mcc', im.astype(np.uint8))
    #cv2.waitKey()
    return width,height,Res,NumMinu,NumMcc,Minu,Mcc,Msk

def SaveMcc(filename, width, height, Res, NumMinu, NumMcc, Minu, Mcc, Msk):
    f = open(filename,'w')
    f.write(str(width)+'\r\n')
    f.write(str(height)+'\r\n')
    f.write(str(Res)+'\r\n')
    f.write(str(NumMinu)+'\r\n')
    for m in Minu:
        for s in m[:-1]: f.write(str(int(s))+' ')
        f.write(str(m[-1])+'\r\n')
    f.write(str(NumMcc)+'\r\n')
    for i in range(NumMcc):
        f.write('True ')
        for b in Msk[i,:]: f.write(str(b)+' ')
        for s in Mcc[i,:-1]: f.write(str(s)+' ')
        f.write(str(Mcc[i,-1])+'\r\n')

def LoadPMcc(filename):
    if not os.path.isfile(filename):return None
    Lines=[f for f in open(filename)]
    V = [np.array(f[5:].split(),dtype=np.uint8) for f in Lines[1:] if f[:4]=='True']
    V = np.row_stack(V)
    return V

def SavePMcc(filename, PMcc):
    f = open(filename, 'w')
    f.write(str(PMcc.shape[0])+'\r\n')
    for i in range(PMcc.shape[0]):
        f.write('True ')
        for b in PMcc[i,:-1]: f.write(str(b)+' ')
        f.write(str(PMcc[i,-1])+'\r\n')
