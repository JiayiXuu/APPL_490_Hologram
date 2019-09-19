
n = 1.333;
M1 = fun_interface(1, n);
M2 = fun_interface(n, 1);


lambda = (400:800)*1E-9;
Rvector = linspace(0,0,numel(lambda));
Tvector = linspace(0,0,numel(lambda));

for i = 1 : numel(lambda)
  M = M2 * fun_prop(lambda(i), 10E-6, n) * M1;
  R = -(M(2, 1)) / M(2, 2);
  T = M(1, 1) + M(1, 2) * R;
   Rvector(i) = abs(R ^ 2);
   Tvector(i) = abs(T ^ 2);
end

plot(lambda, Rvector, lambda, Tvector);
  

  