function [ind x] = simplex(A, b, c, m, n, print)
	
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
	T
	[ind x] = tableau(T, b_idx, m, m + n, print) 
	
endfunction 


function [A b] = make_b_positive(A, b, m, n)
	for i = 1:m
		if b(i) < 0
			b(i) = -b(i);
			A(i, :) = -A(i, :)
		endif
	endfor
endfunction


function [ind x] = tableau(T, b_idx, m, n, print)

	while true
	
		# Marca posição do pivot.
		i_pivot = j_pivot = 0;
	
		# Procura candidato a entrar na base.
		for j = 2:n+1
			if T(1, j) < 0
				min_val = Inf;
				j_pivot = j;
			
				# Procura candidato a sair da base.
				for i = 2:m+1
					if T(i, j) > 0
						theta = T(i, 1)/T(i, j);
						if theta < min_val
							min_val = theta;
							i_pivot = i;
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
	
		# Testa se encontrado solução ótima
		if j_pivot == 0
			ind = 0;
			x = zeros(n, 1);
			for i = 1:m
				x(b_idx(i)) = T(i+1, 1);
			endfor
			return;
		endif
	
		# Atualiza base e pivota
		b_idx(i_pivot - 1) = j_pivot - 1;
		T = pivot(T, i_pivot, j_pivot, m + 1, n + 1)
		
	endwhile
endfunction

function T = pivot(T, i_pivot, j_pivot, m, n)
	T(i_pivot, :) = T(i_pivot, :) / T(i_pivot, j_pivot); 
	for i = 1:m
		if i != i_pivot
			T(i, :) = T(i, :) - T(i, j_pivot) * T(i_pivot, :);
		endif
	endfor
endfunction


function bool = is_zero(v)
	for i=1:lenght(v)
		if v(i) != 0
			bool = false;
			return;
		endif
	endfor
	bool = true;
endfunction