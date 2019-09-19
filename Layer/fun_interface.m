function [M] = fun_interface(na, nb)
    M = (1/(2 * nb)) .* [nb + na, nb - na; nb - na, nb + na];
end