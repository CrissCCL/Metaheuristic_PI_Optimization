function [LA, rentabilidad, Best_alimento, BestLA, Bee, global_fitness] = ...
    evalPIDopABC(T, Upt_op, g, Fa, generaciones)
% evalPIDopABC (safe/correct version)
% ---------------------------------------------------------
% Artificial Bee Colony (ABC) for PI tuning (Kp, Ti).
% Changes vs original:
%   - kz is now a valid food-source index: kz = randi(Fa)
%   - No plotting inside the optimizer
%   - BestLA safely initialized
%   - global_fitness added: [Kp_best Ti_best k bestFitness]
% ---------------------------------------------------------

MaxF = 20;
MinF = 0.2;

dt = 0.01;
t  = 0:dt:T;

max_limite = 120;
limite     = 0;

%% --------- Init food sources ------------------------------
Alimento = zeros(Fa,2);
for i = 1:Fa
    for j = 1:2
        Alimento(i,j) = round(((MaxF - MinF)*rand + MinF)*10)/10;
    end
end

%% --------- Evaluate initial profitability -----------------
FuentesAl = zeros(Fa,5);
for x = 1:Fa
    Kp = Alimento(x,1);
    Ti = Alimento(x,2);

    [J, uMax, Tr] = evalrespPID(g, t, Kp, Ti, Upt_op);
    fit = getfitness(J, uMax, Tr);

    FuentesAl(x,:) = [fit, Alimento(x,1), Alimento(x,2), uMax, Tr];
end

rentabilidad = FuentesAl(:,1);
LA           = [FuentesAl(:,2), FuentesAl(:,3)];

% Initial best
[val, pos]          = max(rentabilidad);
calidad             = val;
Best_fuente_espera  = [val, pos];
Best_alimento       = [val, pos];

% Ensure BestLA exists
BestLA = LA(pos,:);

% History logs
Bee            = zeros(generaciones, 3); % [bestFitness, bestIndex, k]
global_fitness = zeros(generaciones, 4); % [Kp_best, Ti_best, k, bestFitness]

%% ---------------- Main ABC loop --------------------------
for k = 1:generaciones

    %% --- Employed bees: generate candidate solutions ------
    u = zeros(Fa,2);

    for j = 1:Fa
        % SAFE neighbor selection (valid index)
        kz = randi(Fa);
        while kz == j
            kz = randi(Fa);
        end

        u(j,1) = LA(j,1) + rand*(LA(j,1) - LA(kz,1));
        u(j,2) = LA(j,2) + rand*(LA(j,2) - LA(kz,2));

        % Clamp bounds
        if u(j,1) > MaxF, u(j,1) = MaxF; end
        if u(j,2) > MaxF, u(j,2) = MaxF; end
        if u(j,1) < 0,    u(j,1) = MinF; end
        if u(j,2) < 0,    u(j,2) = MinF; end

        % Evaluate candidate
        [J, uMax, Tr] = evalrespPID(g, t, u(j,1), u(j,2), Upt_op);
        fit = getfitness(J, uMax, Tr);

        if calidad < fit
            rentabilidad(j) = fit;
            calidad         = fit;
            LA(j,1) = round(u(j,1)*10)/10;
            LA(j,2) = round(u(j,2)*10)/10;
        else
            limite = limite + 1;
        end
    end

    %% --- Onlooker bees ------------------------------------
    for i = 1:Fa
        [~, bpos] = max(rentabilidad);

        if rentabilidad(bpos) > Best_fuente_espera(1)
            Best_fuente_espera = [rentabilidad(bpos), bpos];
        end

        LA(i,1) = round((LA(i,1) + rand*(LA(Best_fuente_espera(2),1)) - LA(i,1))*10)/10;
        LA(i,2) = round((LA(i,2) + rand*(LA(Best_fuente_espera(2),2)) - LA(i,2))*10)/10;

        % Clamp
        if LA(i,1) > MaxF, LA(i,1) = MaxF; end
        if LA(i,2) > MaxF, LA(i,2) = MaxF; end
        if LA(i,1) < 0,    LA(i,1) = MinF; end
        if LA(i,2) < 0,    LA(i,2) = MinF; end
    end

    %% --- Re-evaluate and update global best ---------------
    for j = 1:Fa
        [J, uMax, Tr] = evalrespPID(g, t, LA(j,1), LA(j,2), Upt_op);
        fit = getfitness(J, uMax, Tr);

        rentabilidad(j) = fit;

        if fit > Best_alimento(1)
            Best_alimento = [fit, j];
            BestLA        = [LA(j,1), LA(j,2)];
        end
    end

    % History logs
    Bee(k,:)            = [Best_alimento(1), Best_alimento(2), k];
    global_fitness(k,:) = [BestLA(1), BestLA(2), k, Best_alimento(1)];

    %% --- Scout bees ---------------------------------------
    if limite > max_limite
        for i = 1:Fa
            LA(i,1) = round(((MaxF-MinF)*rand + MinF)*10)/10;
            LA(i,2) = round(((MaxF-MinF)*rand + MinF)*10)/10;
        end
        limite = 0;
    end
end

end
