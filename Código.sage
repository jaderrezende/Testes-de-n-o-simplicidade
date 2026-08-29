def np(N):
    np= {}
    for n in list(factor(N)):
        np[n[0]]=[ 
            q for q in divisors(N/n[0]) if q%n[0]==1]
    return np

def teste(N):
    L=np(N)
    #Teste 1
    for p in L:
        for q in L[p][:]: # O [:] garante que o for tá trabalhando com uma cópia de L, portanto retiramos elementos sem ter problemas no for
            if factorial(q)/2<N:
                L[p].remove(q)
    print(L)
    #Teste 2

teste(180)
