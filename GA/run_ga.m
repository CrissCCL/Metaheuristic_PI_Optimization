%% run_ga.m
% ---------------------------------------------------------
% Metaheuristic PI Optimization — Genetic Algorithm (GA)
% Process: Single Tank (linear model around operating point)
% Objective: Optimize PI parameters under constraints (ISE-based fitness)
% Author: Cristian A. Castro Lagos
% ---------------------------------------------------------

clear; close all; clc;

%% ------------------- Configuration ------------------------
cfg = struct();

% GA parameters
cfg.ga.cromN        = 40;   % number of chromosomes
cfg.ga.generations  = 100;  % number of generations

% Simulation / plant
cfg.sim.T      = 100;      % simulation horizon [s]
cfg.sim.dt     = 0.01;     % time step [s]
cfg.sim.t      = 0:cfg.sim.dt:cfg.sim.T;

cfg.plant.Uop  = 2.9;            % operating input
cfg.plant.G    = tf(12,[53 1]);  % linear tank model

%% -------------------- Run GA ------------------------------
assert(exist('evalPIDopGENETICO','file')==2, ...
    'Function evalPIDopGENETICO.m not found. Add it to the MATLAB path.');

% IMPORTANT:
% Use the "reproducible" evalPIDopGENETICO signature:
% [adaptacion, Cromosoma, grafevol, global_fitness]

[adaptacion, Cromosoma, grafevol, global_fitness] = ...
    evalPIDopGENETICO(cfg.sim.T, cfg.plant.Uop, cfg.plant.G, cfg.ga.cromN, cfg.ga.generations);

%% -------------------- Best candidate (report) -------------
% global_fitness row format: [Kp_best, Ti_best, K, bestFitness]
Kp_best     = global_fitness(end,1);
Ti_best     = global_fitness(end,2);
bestFitness = global_fitness(end,4);

% Evaluate constraints for reporting (common functions)
[J, uMax, Tr] = evalrespPID(cfg.plant.G, cfg.sim.t, Kp_best, Ti_best, cfg.plant.Uop);

fprintf('\n===== GA Result =====\n');
fprintf('Kp*   = %.4f\n', Kp_best);
fprintf('Ti*   = %.4f\n', Ti_best);
fprintf('Fitness (best) = %.6f\n', bestFitness);
fprintf('u_max = %.4f (constraint)\n', uMax);
fprintf('tr    = %.4f s (constraint)\n\n', Tr);

%% -------------------- Plot: adaptation history ------------
figure('Name','GA Adaptation Evolution','Color','w');
plot(grafevol(:,1), grafevol(:,3), 'or');
grid on; box on;
title('GA — Tournament Winner Fitness per Generation','FontName','Arial','FontSize',14);
xlabel('Generation','FontName','Arial','FontSize',12);
ylabel('Winner Fitness','FontName','Arial','FontSize',12);

%% -------------------- Plot: best fitness evolution --------
figure('Name','GA Best Fitness Evolution','Color','w');
plot(global_fitness(:,3), global_fitness(:,4), 'LineWidth', 1.5);
grid on; box on;
title('GA — Best Fitness Evolution','FontName','Arial','FontSize',14);
xlabel('Generation','FontName','Arial','FontSize',12);
ylabel('Best Fitness','FontName','Arial','FontSize',12);



if ~exist('../results','dir')
    mkdir('../results');
end

gf_ga = global_fitness;
save('../results/gf_ga.mat','gf_ga');
