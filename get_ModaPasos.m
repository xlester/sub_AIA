function ModaPasos = get_ModaPasos(pasos,rango)

    %pasos = atan2(-S,C);
    
%     for x=1:M
%         for y=1:N
%             pasos(x,y,:) = AntiAliasing(pasos(x,y,:));
%         end
%     end
   
        mi = min(pasos(:));
        ma = max(pasos(:));
        bits = (ma-mi)/rango;
        tmp = pasos(:);

        [values xPlace] = hist(tmp(:),mi:bits:ma);
        [mModa mPlace]  = max(values);
        ModaPasos    = xPlace(mPlace);


end
