# Entrada N 
# Saida: um dicionário 'np'
# para cada primo p que divide N, np(p) será os 'possíveis n_p', no sentido de n tais que n | b e n == 1 mod p, onde N = p^k b 
def np(N):
    np= {}
    for n in list(factor(N)):
        np[n[0]]=[ 
            q for q in divisors(N/n[0]**n[1]) if q%n[0]==1]
    return np

# Entrada N 
# Saida: similar a np()
# só que apenas os p em que N = p^k b, k = 1
def np_simples(N):
    np= {}
    for n in list(factor(N)):
        if n[1]==1:
            np[n[0]]=[ 
                q for q in divisors(N/n[0]**n[1]) if q%n[0]==1]
        else:
            np[n[0]]=[]
    return np

# Entrada N um inteiro, e L um dicionário (exemplo: a saída de np(N))
# Se algum q em L[p] satisfaz q!/2 < N, então será removido de L[p]
# Denotando Syl_p o conjunto de p-Sylows (sabemos que G age transitivo neste conjunto)
# Corresponde ao fato: Se n_p = q, a ação de G no conjunto Syl_p dá um homo G --> S_{q} (na verdade A_{q}), e q!/2 < N implica o homo tem núclo 
def teste1(N,L):
    for p in L:
        for q in L[p][:]: # O [:] garante que o for tá trabalhando com uma cópia de L, portanto retiramos elementos sem ter problemas no for
            if factorial(q)/2<N:
                L[p].remove(q)
    return L

# ..................
def teste2(N,L):
    for p in L:
        for q in L[p][:]:
            if q>4:
                if factorial(q)/(2*N) < q/2:
                    L[p].remove(q)
    return L

# ................
def teste3(N,L):
    P=dict(factor(N))
    S={}
    for p in L:
        if P[p]== 1:
            S[p]=L[p]
        else:
            m = max([d for d in divisors(N) if d <= N/p**3 and (p**2).divides(int(N/d))]) # d=[G:N(I)]
            # Também pode incluir a condição : se N = p^2 b, tem que valer p^2 | # N_G(P \cap Q) ....... OK
            if factorial(m)<N:
                S[p]=L[p]
    if sum((p**P[p]-1)*min(S[p]) for p in S)+1>N:
        return True

    
    
def teste(N):
    if N==1:
        return True
    L=np(N)
    L=teste1(N,L)
    L=teste2(N,L)
    if any([len(L[p])==0 for p in L]):
        return True
        
    if teste3(N,L):
        return True
    return False
        
def find(a,b):
    L=[]
    for N in range(a,b):
        if not teste(N):
            L.append(N)
    print(L)
    

def MechanicalSylow(N, verbose):
    return 'For now this function returns this text'


# verbose = True means list all order
# verbose = False means skip cases N = p^m, pq, p^2q, p^2q^2, pqr
def SylowList(Nmin, Nmax, verbose):
    # Option 'w' so we are overwriting any contents in 'output.tex'
    with open('output.tex', 'w') as f:
            print('\\documentclass{article}\n\\usepackage{amsmath,amssymb}\n\\usepackage{parskip}\n\\usepackage{color}\n\\usepackage[a4paper, margin=2.5cm]{geometry}\n\n\\begin{document}\n\n', file=f)
    
    for N in range(Nmin,Nmax):
        s = MechanicalSylow(N, verbose)
        with open('output.tex', 'a') as f:
            print(s, file=f)
            print('\n\n', file=f)
    
    with open('output.tex', 'a') as f:
            print('\\end{document}', file=f)
    
    return []

find(1,1000)
