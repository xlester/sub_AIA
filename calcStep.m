function [alpha, magn] = calcStep(phi, psi, I)

sum_cos = sum(sum(phi));
sum_sin = sum(sum(psi));
sum2_cos = sum(sum(phi.^2));
sum2_sin = sum(sum(psi.^2));
sum_scin = sum(sum(phi.*psi));

[M,N]= size(I);

A = [M*N sum_cos sum_sin;
     sum_cos sum2_cos sum_scin;
     sum_sin sum_scin sum2_sin];
 
sum_I = sum(I(:));
sum_Icos = sum(I(:).*phi(:));
sum_Isin = sum(I(:).*psi(:));
 
b = [sum_I; sum_Icos; sum_Isin];

x = A\b;
alpha = atan2(x(3), x(2));
magn = x(3)^2 + x(2)^2;