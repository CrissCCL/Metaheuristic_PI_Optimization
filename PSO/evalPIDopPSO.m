function [Kp_min, Ti_min, uMax_best, Tr_best, gbest_fitness, ...
          p1, p2, p3, p4, p5, global_fitness] = ...
          evalPIDopPSO(T, Upt_op, g, Np, maxiter, phi1, phi2)
% evalPIDopPSO
% ---------------------------------------------------------
% Particle Swarm Optimization (PSO) for PI tuning (Kp, Ti)
% Maximizes fitness (higher is better).
%
% Outputs:
%   Kp_min, Ti_min     : best PI parameters found
%   uMax_best, Tr_best : constraints metrics at best solution
%   gbest_fitness      : best fitness achieved
%   p1..p5             : snapshots [Kp Ti k] at k=1,25,50,75,100
%   global_fitness     : [Kp_best Ti_best k bestFitness] per iteration
% ---------------------------------------------------------

%% ------------------- Bounds / settings --------------------
MaxP = 20;
MinP = 0.2;

MaxV = 0.1;
MinV = -0.1;

Wmax = 0.9;
Wmin = 0.4;

dt = 0.01;
t  = 0:dt:T;

%% ------------------- Init population ----------------------
% Velocities
V = (MaxV - MinV) .* rand(Np,2) + MinV;
vel_Kp = V(:,1);
vel_Ti = V(:,2);

% Positions [Kp Ti]
posicion_p = (MaxP - MinP) .* rand(Np,2) + MinP;

% Evaluate initial fitness
fitness_p = zeros(Np,1);

for i = 1:Np
    [J, uMax_i, Tr_i] = evalrespPID(g, t, posicion_p(i,1), posicion_p(i,2), Upt_op);
    fitness_p(i)      = getfitness(J, uMax_i, Tr_i);
end

% Personal bests
pbest_pos     = posicion_p;
pbest_fitness = fitness_p;

% Global best
[gbest_fitness, idxBest] = max(pbest_fitness);
gbest_pos = pbest_pos(idxBest,:);

% History (same structure you want everywhere)
global_fitness = zeros(maxiter,4);  % [Kp_best Ti_best k bestFitness]

% Snapshots
p1=[]; p2=[]; p3=[]; p4=[]; p5=[];

%% ------------------- PSO loop -----------------------------
for k = 1:maxiter

    % inertia
    w = Wmax - ((Wmax - Wmin) * (k / maxiter));

    % --- Update pbest and gbest from current fitness ---
    for i = 1:Np
        if fitness_p(i) > pbest_fitness(i)
            pbest_fitness(i) = fitness_p(i);
            pbest_pos(i,:)   = posicion_p(i,:);
        end
    end

    [iter_best, idxBest] = max(pbest_fitness);
    if iter_best > gbest_fitness
        gbest_fitness = iter_best;
        gbest_pos     = pbest_pos(idxBest,:);
    end

    global_fitness(k,:) = [gbest_pos(1), gbest_pos(2), k, gbest_fitness];

    % --- Move particles ---
    for i = 1:Np
        [vKp, vTi] = EvalVel( ...
            vel_Kp(i), vel_Ti(i), ...
            pbest_pos(i,1), pbest_pos(i,2), ...
            posicion_p(i,1), posicion_p(i,2), ...
            gbest_pos(1), gbest_pos(2), ...
            w, phi1, phi2);

        vel_Kp(i) = vKp;
        vel_Ti(i) = vTi;

        posicion_p(i,1) = posicion_p(i,1) + vKp;
        posicion_p(i,2) = posicion_p(i,2) + vTi;

        % clamp bounds (idéntico a tu intención)
        if posicion_p(i,1) > MaxP, posicion_p(i,1) = MaxP; end
        if posicion_p(i,2) > MaxP, posicion_p(i,2) = MaxP; end
        if posicion_p(i,1) < 0,    posicion_p(i,1) = MinP; end
        if posicion_p(i,2) < 0,    posicion_p(i,2) = MinP; end

        % quantize to 0.1
        posicion_p(i,:) = round(posicion_p(i,:)*10)/10;

        % re-evaluate
        [J, uMax_i, Tr_i] = evalrespPID(g, t, posicion_p(i,1), posicion_p(i,2), Upt_op);
        fitness_p(i)      = getfitness(J, uMax_i, Tr_i);
    end

    % Snapshots (si maxiter < 100, los que no existan quedan vacíos)
    if k == 1
        p1 = [posicion_p(:,1), posicion_p(:,2), k*ones(Np,1)];
    elseif k == 25
        p2 = [posicion_p(:,1), posicion_p(:,2), k*ones(Np,1)];
    elseif k == 50
        p3 = [posicion_p(:,1), posicion_p(:,2), k*ones(Np,1)];
    elseif k == 75
        p4 = [posicion_p(:,1), posicion_p(:,2), k*ones(Np,1)];
    elseif k == 100
        p5 = [posicion_p(:,1), posicion_p(:,2), k*ones(Np,1)];
    end
end

%% ------------------- Final outputs ------------------------
Kp_min = gbest_pos(1);
Ti_min = gbest_pos(2);

% Report constraints at best solution (re-evaluate best)
[J_best, uMax_best, Tr_best] = evalrespPID(g, t, Kp_min, Ti_min, Upt_op);
gbest_fitness = getfitness(J_best, uMax_best, Tr_best);

end
