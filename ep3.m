# 
# MAC0315 - Programação Linear
# EP3 - Método Simplex (Full Tableau)
#
# Autores: Daniel Augusto Cortez - 2960291
#          Lucas Rodrigues Colucci - 6920251
#
# Versão: 18-06-2012
#

1;

function show_answer(ind, x, c)
	if ind == 0
		printf("Solução ótima encontrada com custo %7.5f:\n", c' * x);
		x
	elseif ind == 1
		printf("Problema inviável.\n");
	elseif ind == -1
		printf("Problema ilimitado.\n");
	endif
endfunction


# Exemplo 1 - Bertsimas & Tsitsiklis p. 101
printf("\n");
printf("-------------------------------------\n");
printf("Exemplo 1 - Solução Ótima - Linhas LI\n");
printf("-------------------------------------\n");
m = 3
n = 6
A = [1 2 2 1 0 0
     2 1 2 0 1 0
     2 2 1 0 0 1]
b = [20 20 20]'
c = [-10 -12 -12 0 0 0]'
[ind x] = simplex(A, b, c, m, n, true);
show_answer(ind, x, c);


# Exemplo 2 - Bertsimas & Tsitsiklis p. 114
printf("\n");
printf("-------------------------------------\n");
printf("Exemplo 2 - Solução Ótima - Linhas LD\n");
printf("-------------------------------------\n");
m = 4
n = 4
A = [1 2 3 0
    -1 2 6 0
     0 4 9 0
     0 0 3 1]
b = [3 2 5 1]'
c = [1 1 1 0]'
[ind x] = simplex(A, b, c, m, n, true);
show_answer(ind, x, c);


# Exemplo 3
printf("\n");
printf("---------------------------------------------------------------------\n");
printf("Exemplo 3 - Solução Ótima - Removendo Variáveis Artificiais na Fase I\n");
printf("---------------------------------------------------------------------\n");
m = 2 
n = 2
A = [1 -2
     2 -8]
b = [2 4]'
c = [-5 -1]'
[ind x] = simplex(A, b, c, m, n, true);
show_answer(ind, x, c);


# Exemplo 4
printf("\n");
printf("---------------------------------------\n");
printf("Exemplo 4 - Problema Inviável - Simples\n");
printf("---------------------------------------\n");
m = 2
n = 2
A = [1 2
     2 4]
b = [1 3]'
c = [1 1]'
[ind x] = simplex(A, b, c, m, n, true);
show_answer(ind, x, c);


# Exemplo 5
printf("\n");
printf("-----------------------------\n");
printf("Exemplo 5 - Problema Inviável\n");
printf("-----------------------------\n");
m = 3 
n = 5
A = [-2 -3  5 3 -6
      1 -13 4 1 -7
      0   6 2 3  1]
b = [-9 -12 1]'
c = [-1 -2 1 2 3]'
[ind x] = simplex(A, b, c, m, n, true);
show_answer(ind, x, c);


# Exemplo 6
printf("\n");
printf("----------------------------------------\n");
printf("Exemplo 6 - Problema Ilimitado - Simples\n");
printf("----------------------------------------\n");
m = 1 
n = 3
A = [0 1 1]
b = [1]'
c = [-1 0 0]'
[ind x] = simplex(A, b, c, m, n, true);
show_answer(ind, x, c);


# Exemplo 7
printf("\n");
printf("------------------------------\n");
printf("Exemplo 7 - Problema Ilimitado\n");
printf("------------------------------\n");
m = 3 
n = 5
A = [-5 1 1  0  0
     -2 1 0 -1  0
     -1 1 0  0 -1]
b = [1 -1 -2]'
c = [1 -1 1 1 -1]'
[ind x] = simplex(A, b, c, m, n, true);
show_answer(ind, x, c);