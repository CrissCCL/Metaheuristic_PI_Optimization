function [adaptacion, Cromosoma, grafevol, global_fitness] = ...
    evalPIDopGENETICO(T, Upt_op, g, cromN, generaciones)
% evalPIDopGENETICO (reproducible version)
% ---------------------------------------------------------
% Same behavior as original implementation:
% - real-coded genes quantized to 0.1
% - selection: R_adaptados (returns [winner_index, winner_fitness])
% - crossover: Cruza_poblacion (original)
% - mutation: mutacion (original)
% - replacement: Evolucion (original)
%
% Added:
% - grafevol is sized to [generaciones x 3]
% - global_fitness: [Kp_best Ti_best k bestFitness] per generation
%   (computed from population fitness without re-evaluating the plant)
% ---------------------------------------------------------

MaxF = 20;
MinF = 0.2;

dt = 0.01;
t  = 0:dt:T;

%% --------- Init population (same as original) -------------
Gen = zeros(cromN,2);
for i = 1:cromN
    for j = 1:2
        Gen(i,j) = round(((MaxF-MinF)*rand + MinF)*10)/10;
    end
end

%% --------- Evaluate initial adaptation --------------------
PoblacionCrom = zeros(cromN,5);
for x = 1:cromN
    Kp = Gen(x,1);
    Ti = Gen(x,2);

    [funcObj_control, ContrSig, Tr] = evalrespPID(g, t, Kp, Ti, Upt_op);
    fitness = getfitness(funcObj_control, ContrSig, Tr);

    PoblacionCrom(x,:) = [fitness, Gen(x,1), Gen(x,2), ContrSig, Tr];
end

adaptacion = PoblacionCrom(:,1);
Cromosoma  = [PoblacionCrom(:,2), PoblacionCrom(:,3)];

%% --------- Logs (fixed size) ------------------------------
grafevol       = zeros(generaciones, 3); % [K, winner_index, winner_fitness]
global_fitness = zeros(generaciones, 4); % [Kp_best Ti_best K bestFitness]

%% --------- Evolution loop (same operators) ----------------
for K = 1:generaciones

    % Selection (returns [pos,val])
    ganador_torneo = R_adaptados(adaptacion, cromN);

    % Crossover + Mutation (original)
    Cromosomad = Cruza_poblacion(ganador_torneo, Cromosoma, cromN);
    Cromosomad = mutacion(Cromosomad, cromN, MaxF, MinF);

    % Evaluate children fitness
    adaptaciond = zeros(cromN,1);
    for j = 1:cromN
        [funcObj_control, ContrSig, Tr] = evalrespPID(g, t, Cromosomad(j,1), Cromosomad(j,2), Upt_op);
        adaptaciond(j) = getfitness(funcObj_control, ContrSig, Tr);
    end

    % Replacement (original)
    [Cromosoma, adaptacion] = Evolucion(adaptaciond, Cromosomad, adaptacion, Cromosoma, cromN);

    % Log (same meaning as your original)
    grafevol(K,:) = [K, ganador_torneo];  % => [K, pos, val]

    % Global best of current population (NO re-evaluation)
    [bestFitness, idxBest] = max(adaptacion);
    global_fitness(K,:) = [Cromosoma(idxBest,1), Cromosoma(idxBest,2), K, bestFitness];
end

end
