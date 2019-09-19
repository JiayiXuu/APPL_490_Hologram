function [M] = fun_prop(lambda, d, n)
    a = exp(1i * (2 * pi * n * d) / lambda);
    a2 = exp(-1i * (2 * pi * n * d) / lambda);
    M = [a, 0; 0, a2];
end
