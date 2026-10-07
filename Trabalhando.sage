# Entrada N 
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

def teste3(N,L): # Exemplo de caso eliminado 336
    for p in L:
        if p+1 in L[p]:
            N_S= Integer(N/(p+1))
            # Sabemos que np(A_p+1)=#p-ciclos/#quantidade de p-ciclos por Sylow = (p+1)*(p-1)!/ p-1. Assim, seja S um Sylow, #N(S)=#A_p+1 / np = p*(p-1)/2
            if not N_S.divides(int((p*(p-1))/2)): # Se G é simples, caso np=p+1, G é isomorfo a um subgrupo de A_p+1. Assim, N_G(S)< N_Ap+1(S)  
                L[p].remove(p+1)
    return L


# Se, sob a hipótese de G ser simples, ao calcularmos uma cota para o tamanho dos Sylows e ela exceder o tamanho de G, temos um absurdo.
def teste_cont(N,L):
    cpb= False #contando por baixo. Caso tenhamos uma cota estritamente menor que o tamanho real, é suficiente que igualemos ao tamnho de G.
    P=dict(factor(N))
    S={} # É fácil contar os sylows que tem interseção trivial
    for p in L:
        if P[p]== 1:
            S[p]=L[p] #Se os Sylows são p-grupos, eles tem interseção trivial
        else: # Dado I a maior intercessão de p-Sylows, denotamos d=[G:N(I)]
            m = max([d for d in divisors(N) if d <= N/p**3 
                     and (p**2).divides(int(N/d))
                     and len(list(factor(int(N/d))))!=1
                     and np(N/d)[p]!=[1]]) 
            if factorial(m)<N:
                S[p]=L[p]
            else:
                cpb= True
                S[p]=[1]

    print(S)
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
    L=teste3(N,L)
    if any([len(L[p])==0 for p in L]):
        return True
        
    if teste_cont(N,L):
        return True
    return False
        
############## Calculando ##########
def teste(N):
    if N==1:
        return True
    if teo_pq_fraco(N):
        print("p^a b")
        break
    if teo_2n(N):
        print("2n")
        break
    L=np(N)
    L=teste1(N,L)
    L=teste2(N,L)
    L=teste3(N,L)
    print(L)
     if any([len(L[p])==0 for p in L]):
        break
    teste_cont(N,L)
    
    
def find(a,b):
    L=[]
    for N in range(a,b):
        if not teste(N):
            L.append(N)
    print(L)
    
