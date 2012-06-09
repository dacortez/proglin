m = randi([1, 20])
n = randi([m, 20])
A = randn(m, n)
b = randn(m, 1)
c = randn(n, 1)
[ind x] = simplex(A, b, c, m, n, true)


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
