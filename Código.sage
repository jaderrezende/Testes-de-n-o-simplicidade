def np(N):
    np= {}
    for n in list(factor(N)):
        np[n[0]]=[ 
            q for q in divisors(N/n[0]**n[1]) if q%n[0]==1]
    return np

def np_simples(N):
    np= {}
    for n in list(factor(N)):
        if n[1]==1:
            np[n[0]]=[ 
                q for q in divisors(N/n[0]**n[1]) if q%n[0]==1]
        else:
            np[n[0]]=[]
    return np

def teste1(N,L):
    for p in L:
        for q in L[p][:]: # O [:] garante que o for tá trabalhando com uma cópia de L, portanto retiramos elementos sem ter problemas no for
            if factorial(q)/2<N:
                L[p].remove(q)
        return L
    
def teste2(N,L):
    for p in L:
        for q in L[p][:]:
            if q>5:
                if factorial(factorial(q)/(2*N))<factorial(q)/2:
                    L[p].remove(q)
    return L
    
def teste3(N,L):
    P=dict(factor(N))
    S={}
    for p in L:
        if P[p]== 1:
            S[p]=L[p]
        else:
            if factorial(N/p**3)<N:
                S[p]=L[p]
    if sum((p**P[p]-1)*min(S[p]) for p in S)+1>N:
        return True

    
    
def teste(N):
    L=np(N)
    L=teste1(N,L)
    L=teste2(N,L)
    if any([len(L[p])==0 for p in L]):
        return True
    if teste3(N,L):
        return True
    
print(teste(180))
    
def find(a,b):
    L=[]
    for N in range(a,b):
        if not teste(N):
            L.append(N)
    print(L)
    
find(100,180)
