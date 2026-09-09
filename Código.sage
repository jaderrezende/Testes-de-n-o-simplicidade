# Entrada N 
# Saida: um dicionário 'np'
# para cada primo p que divide N, np(p) será os 'possíveis n_p', no sentido de n tais que n | b e n == 1 mod p, onde N = p^k b 
def np(N):
    np= {}
    for n in list(factor(N)):
        np[n[0]]=[ 
            q for q in divisors(N/n[0]**n[1]) if q%n[0]==1]
    return np

def np_note(N):
    t=''
    np= np(N)
    for p in np:
        t+=f'\[n_{p}\in\{{q for q in np[p]}\}\]'
    return t

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

def teste1_note(N,L):
    T='Note que:'
    for p in L:
        F= [q in L[p] if q not in teste1(N,L)[p]] # fora
        if len(F)!=0:
            T+=f'\[n_{p}\notin\{{x for x in F}\}\]'
    return T+'Pois teriamos \dfrac{n_p (G)!}{2}< N'


# A_np é simples para np>4. Se a imagem da ação de G nos p-sylows, supondo injetividade, for um subgrupo normal de A_np, temos um absurdo. Portanto, não é injetivo. Logo, G não é normal. 
def teste2(N,L):
    for p in L:
        for q in L[p][:]:
            if q>4:
                if factorial(q)/(2*N) < q/2:
                    L[p].remove(q)
    return L

# Se p^1 é o fator p de #G. Os p Sylows tem intercessão trivial, logo, totalizam np(p-1) elemntos não triviais.
# Se o fator é p^a, com a>1, a intecessão poderia ser não trivial. Contudo, se a não trivialidade da intercessão implica que G não é simples, assumimos que é trivial e repetimos o argumnto de contagem
#Tendo efetuado a contágem com os mínimos np's possíveis, se excedermos N, chegamos em um absurdo. Logo, G não é simples
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
        
    
def test_note(N):
    T=f'\section{N}'#texto
    if N==1:
        return 'Trivial'
    L=np(N)
    T+=np_note(N)
    T+=teste1_note(N,L)
    L=teste1(N,L)
    T+=teste2_note(N,L)
    L=teste2_note(N,L)
    if any([len(L[p])==0 for p in L]):
        return f'\\ Logo, para qualquer valor de np, com p\in\{{p in L if len(L[p])==0}\}, G podemos concluir que não é simples'
        
    if teste3_note(N,L):
        return True
    return False
    
    
def find(a,b):
    L=[]
    for N in range(a,b):
        if not teste(N):
            L.append(N)
    print(L)

# verbose = True means list all order
# verbose = False means skip cases N = p^m, pq, p^2q, p^2q^2, pqr
def SylowList(Nmin, Nmax):
    # Option 'w' so we are overwriting any contents in 'output.tex'
    with open('output.tex', 'w') as f:
            print('\\documentclass{article}\n\\usepackage{amsmath,amssymb}\n\\usepackage{parskip}\n\\usepackage{color}\n\\usepackage[a4paper, margin=2.5cm]{geometry}\n\n\\begin{document}\n\n', file=f)
    
    for N in range(Nmin,Nmax):
        s = test_note(N)
        with open('output.tex', 'a') as f:
            print(s, file=f)
            print('\n\n', file=f)
    
    with open('output.tex', 'a') as f:
            print('\\end{document}', file=f)
    
    return []

#find(1,1000)
SylowList(24,24,True)
