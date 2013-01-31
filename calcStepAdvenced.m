function [step, alpha] = calcStepAdvenced(phi, psi, I, nimgs)

[M N] = size(I);
Ms = floor(M/nimgs);
Ns = floor(N/nimgs);

alpha = zeros(1,nimgs*nimgs);
magn = zeros(1,nimgs*nimgs);
cont =0;
for m = 1:Ms-1:(M-Ms)
    for n = 1:Ns-1:(N-Ns)
        Itmp = I(m:m+Ms, n:n+Ns);
        Phitmp = phi(m:m+Ms, n:n+Ns);
        Psitmp = psi(m:m+Ms, n:n+Ns);
        [alpha(cont+1) magn(cont+1)] = calcStep(Phitmp, Psitmp, Itmp);
        cont = cont+1;
    end
end

%disp(cont);

step = sum(alpha)/cont;

