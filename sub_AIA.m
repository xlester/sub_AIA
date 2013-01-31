function [steps f] = sub_AIA(I,Sk,Ck,Muestreo,bit,iters,Show)

    [M N L] = size(I);
    figure,
    for n=1:iters
        [DC f] = MinCuaCpp(I,Sk,Ck);
        
        for k=1:L
            [steps(k) alpha] = calcStepAdvenced(real(f),imag(f),I(:,:,k),Muestreo);
            stepsModa(k) = get_ModaPasos(alpha,bit);
        end
        
        
        Ck = cos(steps);
        Sk = sin(steps);
        steps = AntiAliasing(steps);

        % Mostrando Resultados Parciales si Show vale 1.
        if(Show == 1)
            faseMC = angle(f);
            drawnow expose
            imshow(faseMC,[]),title(['fase SUB-AIA en Iteracion: ' num2str(n)]);
            disp([n steps]);
        end

    end
end