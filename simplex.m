# 
# MAC0315 - Programação Linear
# EP3 - Método Simplex (Full Tableau)
#
# Autores: Daniel Augusto Cortez - 2960291
#          Lucas Rodrigues Colucci - 6920251
#
# Versão: 18-06-2012
#

function [ind x] = simplex(A, b, c, m, n, print)
	
	# Resolve a fase 1 do problema.
	[T B m] = phase_1(A, b, m, n, print);
	
	# Testa se o problema é inviável.
	if T(1, 1) < 0
		ind = +1;
		x = [];
		return;
	end
	
	# Problema é viável, então continua com a fase 2.
	[ind x] = phase_2(T, B, c, m, n, print);
endfunction 


function [T B m] = phase_1(A, b, m, n, print)
	
	if print
		printf("Simplex: Fase 1\n\n");
	endif
	
	# Coloca no formato b >= 0.
	[A b] = make_b_positive(A, b, m, n);
	
	# Matriz A com variáveis artificiais.
	A(1:m, n+1:m+n) = eye(m);
	
	# Tableau inicial para a fase 1.
	T = phase_1_tableau(A, b, m, n);
	
	# Vetor com os índices das variáveis básicas.
	B = n+1:n+m;
	
	# Itera o tableau até encontrar solução.
	[T B iter] = tableau_solve(T, B, m, m + n, print, 1);
		
	# Testa se o problema é viável.
	if T(1, 1) == 0
		
		# Remove colunas das variáveis artificiais do tableau.
		T(:, n+2:n+m+1) = [];

		# Remove restrições redundantes.
		[T B m] = remove_redundants(T, B, m, n, print, iter);
		
		# Retira variáveis artificiais da solução básica encontrada.
		[T B] = exit_artificials(T, B, m, n, print, iter);
		
		# Tableau final da fase 1.
		if print
			print_tableau(T, B, m, n, 0, 0, iter++, "tableau final da fase 1");
		endif
	endif
endfunction


function [A b] = make_b_positive(A, b, m, n)
	for i = 1:m
		if b(i) < 0
			b(i) = -b(i);
			A(i, :) = -A(i, :);
		endif
	endfor
endfunction


function T = phase_1_tableau(A, b, m, n)
	T(1, 1) = -sum(b);
	if m > 1
		T(1, 2:n+1) = -sum(A(:, 1:n));
	else
		T(1, 2:n+1) = -A(1, 1:n);
	endif
	T(1, n+2:n+m+1) = zeros(1, m);
	T(2:m+1, 1) = b;
	T(2:m+1, 2:m+n+1) = A;
endfunction


function [T B m] = remove_redundants(T, B, m, n, print, iter)
	remove_idx = []; 
	for i = 1:m
		if B(i) > n
			if is_zero_vector(T(i + 1, 2:n+1))
				remove_idx(end + 1) = i;
			endif
		endif
	endfor
	if length(remove_idx) > 0
		B(remove_idx) = [];
		T(remove_idx + 1, :) = [];
		m -= length(remove_idx);
		if print
			print_tableau(T, B, m, n, 0, 0, iter++, "removendo variáveis redundantes");
		endif
	endif
endfunction


function [T B] = exit_artificials(T, B, m, n, print, iter)
	for i = 1:m
		if B(i) > n
			for j = 1:n
				if T(i + 1, j + 1) != 0
					if print
						print_tableau(T, B, m, n, i + 1, j + 1, iter++, "removendo variável artificial");
					endif
					T = pivot(T, i + 1, j + 1, m + 1, n + 1);
					B(i) = j;
				endif
			endfor
		endif
	endfor
endfunction
	

function bool = is_zero_vector(v)
	for i = 1:length(v)
		if v(i) != 0
			bool = false;
			return;
		endif
	endfor
	bool = true;
endfunction


function [ind x] = phase_2(T, B, c, m, n, print)

	if print
		printf("Simplex: Fase 2\n\n");
	endif

	# Calcula linha 1 do tableau inicial da fase 2.
	c_B = c(B);
	T(1, 1) = -c_B' * T(2:m+1, 1);
	T(1, 2:n+1) = c' - c_B' * T(2:m+1, 2:n+1);

	# Itera o tableau até encontrar solução.
	[T B iter ind x] = tableau_solve(T, B, m, n, print, 1);
endfunction


function [T B iter ind x] = tableau_solve(T, B, m, n, print, iter)

	while true
		
		# Marca posição do pivot.
		i_pivot = j_pivot = 0;
	
		# Procura variável candidato a entrar na base.
		for j = 2:n+1
			if T(1, j) < 0
				min_val = Inf;
				j_pivot = j;
			
				# Procura candidato a sair da base (falta implementar a regra do mínimo).
				for i = 2:m+1
					if T(i, j) > 0
						theta = T(i, 1) / T(i, j);
						if theta < min_val
							min_val = theta;
							i_pivot = i;
						elseif theta == min_val
							# Fica com o menor índice no caso de igualdade.
							if B(i - 1) < B(i_pivot - 1)
								min_val = theta;
								i_pivot = i;
							endif
						endif 
					endif
				endfor
			
				# Testa se o problema é ilimitado (custo = -Inf)
				if i_pivot == 0
					ind = -1;
					x = [];
					
					if print
						print_tableau(T, B, m, n, 0, 0, iter++);
					endif
					
					return;
				endif
			
				break;
			endif
		endfor
	
		# Testa se solução ótima foi encontrada.
		if j_pivot == 0
			ind = 0;
			x = get_solution(T, B, m, n);
			
			if print
				print_tableau(T, B, m, n, 0, 0, iter++);
			endif
			
			return;
		endif
		
		if print
			print_tableau(T, B, m, n, i_pivot, j_pivot, iter++);
		endif
		
		# Atualiza o vetor com os índices das variáveis básicas.
		B(i_pivot - 1) = j_pivot - 1;

		# Pivota e continua.
		T = pivot(T, i_pivot, j_pivot, m + 1, n + 1);
	endwhile
endfunction


function x = get_solution(T, B, m, n)
	x = zeros(n, 1);
	for i = 1:m
		x(B(i)) = T(i + 1, 1);
	endfor
endfunction


function T = pivot(T, i_pivot, j_pivot, m, n)
	T(i_pivot, :) = T(i_pivot, :) / T(i_pivot, j_pivot); 
	for i = 1:m
		if i != i_pivot
			T(i, :) = T(i, :) - T(i, j_pivot) * T(i_pivot, :);
		endif
	endfor
endfunction


function print_tableau(T, B, m, n, i_pivot, j_pivot, iter, msg)
	# Imprime número da interação (e mensagem se passada).
	if nargin() == 7
		printf("Iteração %d\n", iter);
	else
		printf("Iteração %d (%s)\n", iter, msg);
	endif
	
	# Imprime linha com nome das variáveis.
	printf("            |");
	for j = 1:n
		printf(" x%-2d     |", j);
	endfor
	printf("\n");
	
	# Imprime linha com custo e custos reduzidos.
	printf("  %9.3f |", T(1, 1));
	for j = 2:n+1
		printf(" %7.3f |", T(1, j));
	endfor
	printf("\n");
	
	# Imprime linha pontilhada.
	printf("-------------");
	for j = 2:n+1
		printf("----------");
	endfor
	printf("\n");
	
	# Imprime demais linhas do tableau.
	for i = 2:m+1
		# Primeira coluna aparece com as variáveis básicas.
		printf("x%-2d %7.3f |", B(i - 1), T(i, 1));
		for j = 2:n+1
			if i_pivot != 0 && j_pivot != 0 && i == i_pivot && j == j_pivot
				mark = '*';
			else
			 	mark = ' ';
			endif
			printf(" %7.3f%c|", T(i, j), mark);
		endfor
		printf("\n");
	endfor

	printf("\n");
endfunction