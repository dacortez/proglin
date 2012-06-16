1;

function show_answer(ind, x, n, c)
	if ind == 0
		printf("Solução ótima encontrada com custo %7.5f:\n", c' * x);
		x
	elseif ind == 1
		printf("Problema inviável.\n");
	elseif ind == -1
		printf("Problema ilimitado.\n");
	endif
endfunction


# Exemplo 1
printf("---------\n");
printf("Exemplo 1\n");
printf("---------\n");
m = 2 
n = 2
A = [1 -2
     2 -8]
b = [2 4]'
c = [-5 -1]'
[ind x] = simplex(A, b, c, m, n, true);
show_answer(ind, x, n, c);


# Exemplo 2
printf("---------\n");
printf("Exemplo 2\n");
printf("---------\n");
m = 3
n = 6
A = [1 2 2 1 0 0
     2 1 2 0 1 0
     2 2 1 0 0 1]
b = [20, 20, 20]'
c = [-10, -12, -12, 0, 0, 0]'
[ind x] = simplex(A, b, c, m, n, true);
show_answer(ind, x, n, c);