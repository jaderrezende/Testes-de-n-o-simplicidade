
#find(1,1000)
#SylowList(24,25)# Entrada N 
# Saida: um dicionário 'np'
# para cada primo p que divide N, np(p) será os 'possíveis n_p', no sentido de n tais que n | b e n == 1 mod p, onde N = p^k b 
def np(N):
    np_dict = {}
    for n in list(factor(N)):
        np_dict[n[0]]=[ 
            q for q in divisors(N/n[0]**n[1]) if q%n[0]==1]
    return np_dict


# Entrada N um inteiro, e L um dicionário (exemplo: a saída de np(N))
# Se algum q em L[p] satisfaz q!/2 < N, então será removido de L[p]
def teste1(N,L):
    for p in L:
        for q in L[p][:]: # O [:] garante que o for tá trabalhando com uma cópia de L
            if factorial(q)/2<N:
                L[p].remove(q)
    return L

# A_np é simples para np>4. 
def teste2(N,L):
    for p in L:
        for q in L[p][:]:
            if q>4:
                if factorial(q)/(2*N) < q:
                    L[p].remove(q)
    return L

def teste3(N,L): #Este teste é uma pequena extensão da demonstração do teorema 2n. Ele resolve o caso N=240
    if 2.divides(N):
        d=dict(factor(N))
        n= N/2**d[2] # N=2^a * n
        if n in L[2]: #Neste caso (n_2=n), qualquer 2-Sylow P é autonormalizante(i.e. P=N(P))
            # Olhe para um x em P de ordem 2 e para a ação de G nos 2-Sylows. Como P=N(P) o único ponto fixo da permutação induzida por x é P. Logo, p é o produto de (n-1)/2 transposições disjuntas.
            if not 2.divides((n-1)/2):   # Portanto, neste caso temos uma permutação impar.
                L[2].remove(n)
    return L

# Se, sob a hipótese de G ser simples, ao calcularmos uma cota para o tamanho dos Sylows e ela exceder o tamanho de G, temos um absurdo.
def teste_cont(N,L):
    cpb= False #contando por baixo. Caso tenhamos uma cota estritamente menor que o tamanho real, é suficiente que igualemos ao tamnho de G.
    P=dict(factor(N))
    S={} # É fácil contar os sylows que tem intercessão trivial
    for p in L:
        if P[p]== 1:
            S[p]=L[p] #Se os Sylows são p-grupos, eles tem intercessão trivial
        else: # Dado I a maior intercessão de p-Sylows, denotamos d=[G:N(I)]
            m = max([d for d in divisors(N) if d <= N/p**3 
                     and (p**2).divides(int(N/d))
                     and len(list(factor(int(N/d))))!=1]) 
            if factorial(m)<N:
                S[p]=L[p]
            else:
                cpb= True
                S[p]=[1]

    if sum((p**P[p]-1)*min(S[p]) for p in S)+1>N:
        return True
    elif cpb: #contando por baixo 
        if sum((p**P[p]-1)*min(S[p]) for p in S)+1>=N:
            return True
        
    return False

def teo_pq_fraco(N): # Se #N=p^a*q, temos um subgrupo normal
    l= list(factor(N)) 
    if len(l)==2:
        return any([p for p in l if p[1]==1])

def teo_2n(N): # Se #G é par mas #G/2 é impar, G não é simples
    if 2.divides(N):
        f=dict(factor(N))
        return f[2]==1
    
######
        
def teste(N):
    if N==1:
        return True
    if teo_pq_fraco(N):
        return True
    if teo_2n(N):
        return True
    L=np(N)
    L=teste1(N,L)
    L=teste2(N,L)
    if any([len(L[p])==0 for p in L]):
        return True
        
    if teste_cont(N,L):
        return True
    return False
        
    
def find(a,b):
    L=[]
    for N in range(a,b):
        if not teste(N):
            L.append(N)
    print(L)

    
  ##### Latex ####
    

def np_note(L):
    t=''
    for p in L:
        # Transforma a lista em set e ajusta as chaves para o formato LaTeX
        S = str(set(L[p])).replace('{', r'\{').replace('}', r'\}') 
        t+=f'\\[n_{{{p}}}\\in {S} \\]'
    return t
    
def teste1_note(N,L):
    T='Note que:'
    L_copia = {k: v[:] for k, v in L.items()} # Cópia para não destruir o L original
    for p in L:
        F= [q for q in L[p] if q not in teste1(N,L_copia)[p]] # fora
        if len(F)!=0:
            S = str(set(F)).replace('{', r'\{').replace('}', r'\}')
            T+=f'\n\\[n_{{{p}}}\\notin {S} \\]\n'
    return T+r'Pois teriamos $\dfrac{n_p (G)!}{2}< N$'


def teste2_note(N,L):
    T='Agora, veja que:' # Indentação corrigida aqui
    L_copia = {k: v[:] for k, v in L.items()} # Cópia para não destruir o L original
    for p in L:
        F= [q for q in L[p] if q not in teste2(N,L_copia)[p]] # fora
        if len(F)!=0:
            S = str(set(F)).replace('{', r'\{').replace('}', r'\}')
            T+=f'\\[n_{{{p}}}\\notin {S}\\]'
    T+='Pois, teste 2'
    return T+'Pois, teste 2'

    
def test_note(N):
    T=f'\\section{{{N}}}'
    if N==1:
        return 'Trivial'
    L=np(N)
    T+='Primeiramente, usando os Teoremas de Sylow, listaremos os possíveis valores de np:'
    T+=np_note(L)
    T+=teste1_note(N,L)
    L=teste1(N,L)
    T+=teste2_note(N,L)
    L=teste2(N,L)
    if any([len(L[p])==0 for p in L]):
        vazios = [p for p in L if len(L[p])==0]
        S = str(set(vazios)).replace('{', r'\{').replace('}', r'\}')
        return f'{T}\\\\ Logo, para qualquer valor de np, com $p\\in {S}$, G podemos concluir que não é simples'
        
    if teste_cont_note(N,L): # ainda não fiz
        return True
    return False
    

def SylowList(Nmin, Nmax):
    with open('output.tex', 'w') as f:
            print('\\documentclass{article}\n\\usepackage{amsmath,amssymb}\n\\usepackage{parskip}\n\\usepackage{color}\n\\usepackage[a4paper, margin=2.5cm]{geometry}\n\n\\begin{document}\n\n', file=f)
    
    for N in range(Nmin, Nmax):
        s = test_note(N)
        with open('output.tex', 'a') as f:
            print(s, file=f)
            print('\n\n', file=f)
    
    with open('output.tex', 'a') as f:
            print('\\end{document}', file=f)
    
    return []

#find(1,1000)
#SylowList(24,25)
