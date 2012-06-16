1;

function show_answer(ind, x, n, c)
	if ind == 0
		printf("Solução encontrada:\n");
		for i = 1:n
			printf("x%-2d   = %7.5f\n", i, x(i));
		endfor
		printf("Custo = %7.5f\n", c' * x);
	elseif ind == 1
		printf("Problema inviável.\n");
	elseif ind == -1
		printf("Problema ilimitado.\n");
	endif
endfunction

# Exemplo 1
m = 2; n = 2;
A = [1 -2
     2 -4];
b = [2 4]';
c = [1 -1]';
[ind x] = simplex(A, b, c, m, n, true);
show_answer(ind, x, n, c);


#m = 3;
#n = 6;
#A = [1, 2, 2, 1, 0, 0; 2, 1, 2, 0, 1, 0; 2, 2, 1, 0, 0, 1];
#b = [20, 20, 20]';
#c = [-10, -12, -12, 0, 0, 0]';
#simplex(A, b, c, m, n, true);

#m = 2;
#n = 4;
#A = [1, 2, 1, 0; 2, 1, 0, 1];
#b = [3, 3]';
#c = [-1, -1, 0, 0]';
#simplex(A, b, c, m, n, true);

#m = 1;
#n = 3;
#A = [-1, 1, 1];
#b = [1]';
#c = [-1, -1, 0]';
#simplex(A, b, c, m, n, true);
