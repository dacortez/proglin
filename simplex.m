function [ind x] = simplex(A, b, c, m, n, print)
	
	# Fase 1 ##########################################################
	
	# Coloca no formato b >= 0.
	[A b] = make_b_positive(A, b, m, n);
	
	# Vetor de custos da fase 1. 
	c1(1:n) = zeros(1, n);
	c1(n+1:n+m) = ones(1, m);
	
	# Matriz A com variáveis artificiais.
	A(1:m, n+1:m+n) = eye(m);
	
	# Tableau inicial para a fase 1.
	T(1, 1) = -sum(b);
	T(1, 2:n+1) = -sum(A(:, 1:n));
	T(1, n+2:n+m+1) = zeros(1, m);
	T(2:m+1, 1) = b;
	T(2:m+1, 2:m+n+1) = A;
	
	# Vetor de índices das variáveis básicas.
	b_idx = n+1:n+m;
	
	# Itera o tableau até encontrar solução.
	[T b_idx ind x] = tableau(T, b_idx, m, m + n, print);
		
	# Testa se o problema é viável.
	if T(1, 1) > 0
		ind = +1;
		x = [];
		printf("Problema inviável.\n");
		return;
	endif
	
	# Elimina variáveis artificiais na solução básica da fase 1.
	[T b_idx m] = remove_artificial(T, b_idx, m, n);
	
	# Imprime tableau final da fase 1.
	if print
		print_tableau(T, b_idx, m, n, 0, 0);
	endif
	
	# Fase 2 ##########################################################
	
	# Calcula linha 1 do tableau inicial da fase 2.
	c_B = c(b_idx);
	T(1, 1) = -c_B' * T(2:m+1, 1);
	T(1, 2:n+1) = c' - c_B' * T(2:m+1, 2:n+1);
	
	# Itera o tableau até encontrar solução.
	[T b_idx ind x] = tableau(T, b_idx, m, n, print);

	# Imprime tableau final da fase 2.
	if print
		print_tableau(T, b_idx, m, n, 0, 0);
	endif

	# Solução ilimitada (custo = -Inf)
	if ind == -1
		printf("Solução ilimitada.\n");
	elseif ind == 0
		printf("Solução ótima encontrada:\n");
		printf("Custo = %2.4f\n", -T(1, 1));
		for i = 1:n
			printf("x%d = %2.4f\n", i, x(i));
		endfor 
		printf("\n");
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


function [T b_idx ind x] = tableau(T, b_idx, m, n, print)

	while true
		
		# Marca posição do pivot.
		i_pivot = j_pivot = 0;
	
		# Procura candidato a entrar na base.
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
							if b_idx(i - 1) < b_idx(i_pivot - 1)
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
					return;
				endif
			
				break;
			endif
		endfor
	
		# Testa se encontrado solução ótima.
		if j_pivot == 0
			ind = 0;
			x = zeros(n, 1);
			for i = 1:m
				x(b_idx(i)) = T(i + 1, 1);
			endfor
			return;
		endif

		# Imprime o tableau se aplicável.
		if print
			print_tableau(T, b_idx, m, n, i_pivot, j_pivot);
		endif
	
		# Atualiza o vetor com os índices das variáveis básicas.
		b_idx(i_pivot - 1) = j_pivot - 1;

		# Pivota e continua.
		T = pivot(T, i_pivot, j_pivot, m + 1, n + 1);
	endwhile
endfunction


function print_tableau(T, b_idx, m, n, i_pivot, j_pivot)
	T
endfunction


function T = pivot(T, i_pivot, j_pivot, m, n)
	T(i_pivot, :) = T(i_pivot, :) / T(i_pivot, j_pivot); 
	for i = 1:m
		if i != i_pivot
			T(i, :) = T(i, :) - T(i, j_pivot) * T(i_pivot, :);
		endif
	endfor
endfunction


function [T b_idx m] = remove_artificial(T, b_idx, m, n)
	
	# Remove variáveis artificiais
	T(:, n+2:n+m+1) = [];
	
	# Procura e remove restrições redundantes.
	remove_idx = []; 
	for i = 1:m
		if b_idx(i) > n
			if is_zero(T(i + 1, 2:n+1))
				remove_idx(end + 1) = i + 1;
				m--;
			endif
		endif
	endfor
	T(remove_idx, :) = [];
	b_idx(remove_idx - 1) = [];
	
	# Remove variáveis artificiais da base.
	for i = 1:m
		if b_idx(i) > n
			for j = 2:n+1
				if T(i + 1, j) != 0
					T = pivot(T, i + 1, j, m + 1, n + 1);
					b_idx(i) = j - 1;
				endif
			endfor
		endif
	endfor
endfunction


function bool = is_zero(v)
	for i = 1:length(v)
		if v(i) != 0
			bool = false;
			return;
		endif
	endfor
	bool = true;
endfunction