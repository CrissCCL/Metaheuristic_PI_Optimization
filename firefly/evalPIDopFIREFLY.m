function [posicion_F, posicion_Fg, BrilloF, p0, p1, p2, p3, p4, p5,global_fitness] = ...
    evalPIDopFIREFLY(T, Upt_op, g, Np, maxiter)
% evalPIDopFIREFLY
% ---------------------------------------------------------
% Firefly Algorithm for PI tuning (Kp, Ti)
% Maximizes fitness (higher is better) using:
%   - attractiveness: beta = beta0 * exp(-gamma*r^2)
%   - randomization:  alpha*(rand-0.5)
%
% Outputs:
%   posicion_F  : final population positions [Kp Ti]
%   posicion_Fg : best global position found [Kp Ti]
%   BrilloF     : fitness of final population
%   p0..p5      : snapshots [Kp Ti k fitness] at specific iterations
% ---------------------------------------------------------

%% ------------------- Bounds / time ------------------------
MaxF = 20;
MinF = 0.2;

dt = 0.01;
t  = 0:dt:T;

%% ------------------- Firefly parameters -------------------
gamma = 0.1;
beta0 = 1;
alpha = 0.5;

%% ------------------- Init population ----------------------
posicion_F = (MaxF - MinF) .* rand(Np,2) + MinF;   % [Kp Ti]
BrilloF    = zeros(Np,1);

% snapshots init
p0=[]; p1=[]; p2=[]; p3=[]; p4=[]; p5=[];

%% ------------------- Evaluate initial fitness -------------
for i = 1:Np
    Kp = posicion_F(i,1);
    Ti = posicion_F(i,2);

    [J, uMax, Tr] = evalrespPID(g, t, Kp, Ti, Upt_op);
    BrilloF(i)    = getfitness(J, uMax, Tr);
end

% Best global after init
[~, idxBest] = max(BrilloF);
posicion_Fg  = posicion_F(idxBest,:);

% Snapshot k = 1 (como tu main esperaba p0 "k=1")
k = 1;
p0 = [posicion_F(:,1), posicion_F(:,2), k*ones(Np,1), BrilloF];

global_fitness = zeros(maxiter,4); 
% columns: [Kp_best, Ti_best, iteration, bestFitness]

%% ------------------- Main loop ----------------------------
for k = 1:maxiter

    % Flag: if there is no improvement relation in the population,
    % we apply a random move to all (your original intention).
    anyAttractionMove = false;

    % For each firefly i, compare with every j
    for i = 1:Np
        for j = 1:Np

            % Distance
            r = sqrt( (posicion_F(j,1)-posicion_F(i,1))^2 + (posicion_F(j,2)-posicion_F(i,2))^2 );
            beta = beta0 * exp(-gamma * r^2);

            % Move i towards j if j is brighter
            if BrilloF(j) > BrilloF(i)
                posicion_F(i,1) = posicion_F(i,1) + beta*(posicion_F(j,1)-posicion_F(i,1)) + alpha*(rand-0.5);
                posicion_F(i,2) = posicion_F(i,2) + beta*(posicion_F(j,2)-posicion_F(i,2)) + alpha*(rand-0.5);

                anyAttractionMove = true;

                % Bound handling (same as your original logic)
                if posicion_F(i,1) > MaxF, posicion_F(i,1) = MaxF; end
                if posicion_F(i,2) > MaxF, posicion_F(i,2) = MaxF; end
                if posicion_F(i,1) < 0,    posicion_F(i,1) = MinF; end
                if posicion_F(i,2) < 0,    posicion_F(i,2) = MinF; end
            end
        end
    end

    % If nothing moved by attraction, jitter whole population
    if ~anyAttractionMove
        posicion_F(:,1) = posicion_F(:,1) + alpha*(rand(Np,1)-0.5);
        posicion_F(:,2) = posicion_F(:,2) + alpha*(rand(Np,1)-0.5);

        % Clamp bounds
        posicion_F(:,1) = min(max(posicion_F(:,1), MinF), MaxF);
        posicion_F(:,2) = min(max(posicion_F(:,2), MinF), MaxF);
    end

    % Re-evaluate fitness after moves
    for i = 1:Np
        [J, uMax, Tr] = evalrespPID(g, t, posicion_F(i,1), posicion_F(i,2), Upt_op);
        BrilloF(i)    = getfitness(J, uMax, Tr);
    end

    % Update global best
    [~, idxBest] = max(BrilloF);
    posicion_Fg  = posicion_F(idxBest,:);

    bestFitness = BrilloF(idxBest);
    global_fitness(k,:) = [posicion_Fg(1), posicion_Fg(2), k, bestFitness];

    % Snapshots (exactly the ones you plot in the main)
    if k == 5
        p1 = [posicion_F(:,1), posicion_F(:,2), k*ones(Np,1), BrilloF];
    elseif k == 25
        p2 = [posicion_F(:,1), posicion_F(:,2), k*ones(Np,1), BrilloF];
    elseif k == 50
        p3 = [posicion_F(:,1), posicion_F(:,2), k*ones(Np,1), BrilloF];
    elseif k == 75
        p4 = [posicion_F(:,1), posicion_F(:,2), k*ones(Np,1), BrilloF];
    elseif k == 100
        p5 = [posicion_F(:,1), posicion_F(:,2), k*ones(Np,1), BrilloF];
    end
end

end
