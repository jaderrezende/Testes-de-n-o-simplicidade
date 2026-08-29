def np(N):
    np= {}
    for n in list(factor(N)):
        np[n[0]]=[ 
            q for q in divisors(N/n[0]) if q%n[0]==1]
    return np

def np_simples(N):
    np= {}
    for n in list(factor(N)):
        if n[1]==1:
            np[n[0]]=[ 
                q for q in divisors(N/n[0]) if q%n[0]==1]
        else:
            np[n[0]]=[]
    return np

def teste(N):
    L=np(N)
    P=dict(factor(N))
    S=np_simples(N)
    #Teste 1
    for p in L:
        for q in L[p][:]: # O [:] garante que o for tá trabalhando com uma cópia de L, portanto retiramos elementos sem ter problemas no for
            if factorial(q)/2<N:
                L[p].remove(q)
                if q in S[p]:
                    S[p].remove(q)
    # Teste 2
    for p in L:
        for q in L[p][:]:
            if q>5:
                if factorial(factorial(q)/2*N)<factorial(q)/2:
                    L[p].remove(q)
                    if q in S[p]:
                        S[p].remove(q)
    # Teate 3
    for p in L:
        for q in L[p][:]:
            if P[q]>1:
                if factorial(N/p**3)<N:
                    S[p].append(q)
            
    # Se eliminamos tudo
    if any([len(L[p]==0 for p in L)]):
        return True
    #Teste de contagem
    if sum((p**P[p]-1)*min(S[p]) for p in S)+1>N:
        return True

teste(180)
