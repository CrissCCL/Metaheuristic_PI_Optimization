function [Cromosoma, adaptacion] = Evolucion(adaptaciond, Cromosomad, adaptacion, Cromosoma, cromN)
% Evolucion
% ---------------------------------------------------------
% Replacement / elitism operator for GA.
% For each chromosome i:
%   - if offspring fitness > current fitness
%     replace parent with offspring
%   - otherwise keep parent
% ---------------------------------------------------------

for i = 1:cromN
    if adaptaciond(i) > adaptacion(i)
        Cromosoma(i,:) = Cromosomad(i,:);
        adaptacion(i)  = adaptaciond(i);
    end
end

end
