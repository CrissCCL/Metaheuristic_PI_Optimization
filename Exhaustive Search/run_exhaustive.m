%% run_exhaustive.m
% ---------------------------------------------------------
% Baseline — Exhaustive Search (Grid Search)
% Reference optimum for PI tuning (within evaluated grid)
% Author: Cristian A. Castro Lagos
% ---------------------------------------------------------

clear; close all; clc;

%% ------------------- Configuration ------------------------
cfg = struct();

% Search grid
cfg.grid.Kp = 0.2:0.2:20;
cfg.grid.Ti = 0.2:0.2:20;

% Simulation / plant
cfg.sim.T      = 100;
cfg.sim.dt     = 0.01;
cfg.sim.t      = 0:cfg.sim.dt:cfg.sim.T;

cfg.plant.Uop  = 2.9;
cfg.plant.G    = tf(12,[53 1]);

%% ------------------- Run Exhaustive -----------------------
assert(exist('evalPIDopBusqExh','file')==2, ...
    'Function evalPIDopBusqExh.m not found. Add it to the MATLAB path.');

[Kp_min, Ti_min, bestfitness, soluciones] = ...
    evalPIDopBusqExh(cfg.grid.Kp, cfg.grid.Ti, cfg.plant.G, cfg.sim.T, cfg.plant.Uop);

%% ------------------- Report -------------------------------
[J, uMax, Tr] = evalrespPID(cfg.plant.G, cfg.sim.t, Kp_min, Ti_min, cfg.plant.Uop);

fprintf('\n===== Exhaustive Search Result (Reference Optimum) =====\n');
fprintf('Kp*   = %.4f\n', Kp_min);
fprintf('Ti*   = %.4f\n', Ti_min);
fprintf('Fitness* (reference) = %.6f\n', bestfitness);
fprintf('u_max = %.4f\n', uMax);
fprintf('tr    = %.4f s\n\n', Tr);

%% ------------------- Save results -------------------------
% Create results folder if needed
if ~exist('../results','dir')
    mkdir('../results');
end

% Reference optimum (compact)
opt_exh = [Kp_min, Ti_min, bestfitness];
bestfitness_exh = bestfitness;

% Minimal global_fitness format (single row)
gf_exhaustive = [Kp_min, Ti_min, 1, bestfitness];

save('../results/gf_exhaustive.mat', 'gf_exhaustive', 'opt_exh', 'bestfitness_exh', 'soluciones');
