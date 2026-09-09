# Entrada N 
# Saida: um dicionário 'np'
# para cada primo p que divide N, np(p) será os 'possíveis n_p', no sentido de n tais que n | b e n == 1 mod p, onde N = p^k b 
def np(N):
    np_dict = {} # Mudei apenas o nome da variável para não conflitar com o nome da função
    for n in list(factor(N)):
        np_dict[n[0]]=[ 
            q for q in divisors(N/n[0]**n[1]) if q%n[0]==1]
    return np_dict

def np_note(N):
    t=''
    L = np(N)
    for p in L:
        # Transforma a lista em set e ajusta as chaves para o formato LaTeX
        S = str(set(L[p])).replace('{', r'\{').replace('}', r'\}') 
        t+=f'\\[n_{{{p}}}\\in {S} \\]'
    return t

# Entrada N um inteiro, e L um dicionário (exemplo: a saída de np(N))
# Se algum q em L[p] satisfaz q!/2 < N, então será removido de L[p]
def teste1(N,L):
    for p in L:
        for q in L[p][:]: # O [:] garante que o for tá trabalhando com uma cópia de L
            if factorial(q)/2<N:
                L[p].remove(q)
    return L

def teste1_note(N,L):
    T='Note que:'
    L_copia = {k: v[:] for k, v in L.items()} # Cópia para não destruir o L original
    for p in L:
        F= [q for q in L[p] if q not in teste1(N,L_copia)[p]] # fora
        if len(F)!=0:
            S = str(set(F)).replace('{', r'\{').replace('}', r'\}')
            T+=f'\\[n_{{{p}}}\\notin {S} \\]'
    return T+r'Pois teriamos \dfrac{n_p (G)!}{2}< N'


# A_np é simples para np>4. 
def teste2(N,L):
    for p in L:
        for q in L[p][:]:
            if q>4:
                if factorial(q)/(2*N) < q/2:
                    L[p].remove(q)
    return L

def teste2_note(N,L):
    T='Agora, veja que:' # Indentação corrigida aqui
    L_copia = {k: v[:] for k, v in L.items()} # Cópia para não destruir o L original
    for p in L:
        F= [q for q in L[p] if q not in teste2(N,L_copia)[p]] # fora
        if len(F)!=0:
            S = str(set(F)).replace('{', r'\{').replace('}', r'\}')
            T+=f'\\[n_{{{p}}}\\notin {S}\\]'
    return T+'Pois, teste 2'


# Se p^1 é o fator p de #G...
def teste3(N,L):
    P=dict(factor(N))
    S={}
    for p in L:
        if P[p]== 1:
            S[p]=L[p]
        else:
            m = max([d for d in divisors(N) if d <= N/p**3 and (p**2).divides(int(N/d))]) # d=[G:N(I)]
            if factorial(m)<N:
                S[p]=L[p]
    if sum((p**P[p]-1)*min(S[p]) for p in S)+1>N:
        return True
    return False

        
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
    T=f'\\section{{{N}}}' # texto: corrigidas as chaves do LaTeX
    if N==1:
        return 'Trivial'
    L=np(N)
    T+='Primeiramente, usando os Teoremas de Sylow, listaremos os possíveis valores de np:'
    T+=np_note(N)
    T+=teste1_note(N,L)
    L=teste1(N,L)
    T+=teste2_note(N,L)
    L=teste2(N,L)
    if any([len(L[p])==0 for p in L]):
        vazios = [p for p in L if len(L[p])==0]
        S = str(set(vazios)).replace('{', r'\{').replace('}', r'\}')
        return f'{T}\\\\ Logo, para qualquer valor de np, com p\\in {S}, G podemos concluir que não é simples'
        
    if teste3(N,L): # Corrigido: era teste3_note(N,L) que não existia
        return True
    return False
    
    
def find(a,b):
    L=[]
    for N in range(a,b):
        if not teste(N):
            L.append(N)
    print(L)

def SylowList(Nmin, Nmax):
    with open('output.tex', 'w') as f:
            print('\\documentclass{article}\n\\usepackage{amsmath,amssymb}\n\\usepackage{parskip}\n\\usepackage{color}\n\\usepackage[a4paper, margin=2.5cm]{geometry}\n\n\\begin{document}\n\n', file=f)
    
    # Adicionei +1 pois no Python range(24, 24) seria vazio
    for N in range(Nmin, Nmax):
        s = test_note(N)
        with open('output.tex', 'a') as f:
            print(s, file=f)
            print('\n\n', file=f)
    
    with open('output.tex', 'a') as f:
            print('\\end{document}', file=f)
    
    return []

#find(1,1000)
SylowList(24,25)
