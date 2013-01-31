clear all
close all

M = 512;
N = 512;

[X Y] = meshgrid(-M/2:M/2 - 1, -N/2:N/2 - 1);

a = -0.0001*(X.^2 + Y.^2);
b = (0.5*exp(-(X.^2 + Y.^2)/100^2)+0.1);
paso = pi/4;

fase = 0.3*X + 0.1*Y;

I = a + b.*cos(fase + paso) + 0.5*randn(M,N);

[step1 alpha magn] = calcStepAdvenced(cos(fase),-sin(fase),I,6);
step2 = calcStep(cos(fase), -sin(fase), I);


imshow(I, []);

disp('Paso Nuestro');
disp(step1);
disp('Paso AIA');
disp(step2);
disp('Paso Real');
disp(paso);