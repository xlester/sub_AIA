%% Generando Interferogramas Sinteticos.
close all;
clear all;
M       = 512; % Number of rows of each interferogram.
N       = 512; % Number of columns of each interferogram.
k       = 5;   % Number of frames.
A       = 30;  % Amplitud para la fase tipo Peaks.

step    = pi/3; % Valor del paso.
nv      = 0.2; % Varianza del Ruido.

DC      = makeParabola(M,N,10);
%DC      = makeGausiana(M,N,5,60);
rampa   = makeRampa(4*pi/M,4*pi/N,M,N);
phase   = makePeaks(N,M,A)+rampa;
b       = 0.1*makeGausiana(M,N,1,100)+0.1;
step_noise = 0.5;
 
[I,steps]       = makeI(DC,1,phase,step,step_noise,k,nv);
%steps = atan2(sin(steps),cos(steps));


%% Inicializando parametros del metodo RST.

Muestreo = 4; % Numero de pixeles a satar para el muestreo.
bit = Muestreo*Muestreo;
%% Inicializando parametros del metodo AIA.

iters = 10;
v     = 1;
Sk    = sin( v* (0:1:k-1) );
Ck    = cos( v* (0:1:k-1) );
Show  = 1; % 1 si se decea mostrar resultados parciales.

%% Aplicando metodos RST y AIA

% Aplicando algoritmo RST.
tic
[pasosRST f_subAIA] = sub_AIA(I,Sk,Ck,Muestreo,bit,iters,Show);
tRST = toc;
pasosRST=AntiAliasing(pasosRST);

% Aplicando algoritmo AIA.
tic
[pasosAIA f_AIA] = AIA(I,Sk,Ck,iters,Show);
tAIA = toc;
pasosAIA=AntiAliasing(pasosAIA);
%% Eliminando Piston de fase.
pasosRST = pasosRST-pasosRST(1);
Sk = sin(pasosRST);
Ck = cos(pasosRST);

[a1 f_RST] = MinCuaCpp(I,Sk,Ck);

pasosAIA = pasosAIA-pasosAIA(1);
Sk = sin(pasosAIA);
Ck = cos(pasosAIA);
[a1 f_AIA] = MinCuaCpp(I,Sk,Ck);
% pasosAIA = atan2(Sk,Ck);

%% Mostrando Resultados.

%SP_RSTreg = angle(f_RSTreg);
SP_RST    = angle(f_RST);
SP_AIA    = angle(f_AIA);
wfase     = angle(exp(-1i*phase));
%errorReg = mean2(abs(wfase+SP_RST));

std_RST = PhaseVar(wfase,SP_RST);
std_AIA = PhaseVar(wfase,SP_AIA);

eAveRST = mean(abs(steps - pasosRST));
eAveAIA = mean(abs(steps - pasosAIA));

%figure,imshow(-SP_RSTreg,[]),title('fase Estimada RST regularizada');
figure,imshow(SP_RST,[]),title('fase Estimada RST');
figure,imshow(SP_AIA,[]),title('fase Estimada AIA');
figure,imshow(wfase,[]),title('fase Esperada');
figure,imshow(I(:,:,1),[]),title('Interferograma de Entrada');

disp('Estimados AIA');
disp(pasosAIA);

disp('Estimados RST');
disp(pasosRST);

disp('Esperados');
disp(steps);
disp('--------------');

disp('Error Pasos AIA');
disp(abs(steps - pasosAIA));

disp('Error Pasos RST');
disp(abs(steps - pasosRST));
disp('--------------');

disp('Error Medio Pasos RST');
disp(eAveRST);

disp('Error Medio Pasos AIA');
disp(eAveAIA);
disp('--------------');

disp('Phase Error varianza RST');
disp(std_RST);

disp('Phase Error varianza AIA');
disp(std_AIA);