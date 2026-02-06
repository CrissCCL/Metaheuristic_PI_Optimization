function ganador_torneo = R_adaptados(adaptacion, cromN)
% R_adaptados
% Returns the best candidate: [index, fitness]

Candidato_torneo = zeros(cromN,2); % [index, fitness]

for i = 1:cromN
    if adaptacion(i) > 0
        Candidato_torneo(i,:) = [i, adaptacion(i)];
    else
        Candidato_torneo(i,:) = [i, 0];
    end
end

[val, pos] = max(Candidato_torneo(:,2));
ganador_torneo = [pos, val];

end
