%% run_pso.m
% ---------------------------------------------------------
% Metaheuristic PI Optimization — PSO
% Process: Single Tank (linear model around operating point)
% Objective: Optimize PI parameters under constraints (ISE-based fitness)
% Author: Cristian A. Castro Lagos
% ---------------------------------------------------------

clear; close all; clc;

%% ------------------- Configuration ------------------------
cfg = struct();

% PSO parameters
cfg.pso.Np      = 150;   % number of particles
cfg.pso.maxIter = 100;   % iterations
cfg.pso.phi1    = 0;     % cognitive component
cfg.pso.phi2    = 2;     % social component

% Simulation / plant
cfg.sim.T      = 100;      % simulation horizon [s]
cfg.sim.dt     = 0.01;     % time step [s]
cfg.sim.t      = 0:cfg.sim.dt:cfg.sim.T;

cfg.plant.Uop  = 2.9;            % operating input
cfg.plant.G    = tf(12,[53 1]);  % linear tank model

% Plot settings
cfg.plot.xlim = [-2 22];
cfg.plot.ylim = [-2 22];

%% -------------------- Run PSO ----------------------------
assert(exist('evalPIDopPSO','file')==2, ...
    'Function evalPIDopPSO.m not found. Add it to the MATLAB path.');

[Kp_best, Ti_best, uMax, Tr, bestFitness, ...
 p_k1, p_k25, p_k50, p_k75, p_k100, global_fitness] = ...
    evalPIDopPSO(cfg.sim.T, cfg.plant.Uop, cfg.plant.G, ...
                 cfg.pso.Np, cfg.pso.maxIter, cfg.pso.phi1, cfg.pso.phi2);

%% -------------------- Console Summary ---------------------
fprintf('\n===== PSO Result =====\n');
fprintf('Kp*   = %.4f\n', Kp_best);
fprintf('Ti*   = %.4f\n', Ti_best);
fprintf('Fitness (best) = %.6f\n', bestFitness);
fprintf('u_max = %.4f (constraint)\n', uMax);
fprintf('tr    = %.4f s (constraint)\n\n', Tr);

%% -------------------- Plot: fitness evolution -------------
figure('Name','PSO Fitness Evolution','Color','w');
plot(global_fitness(:,3), global_fitness(:,4), 'LineWidth', 1.5);
grid on; box on;
title('PSO — Best Fitness Evolution','FontName','Arial','FontSize',14);
xlabel('Iteration k','FontName','Arial','FontSize',12);
ylabel('Best Fitness','FontName','Arial','FontSize',12);

%% -------------------- Plot: snapshots (subplots) ----------
figure('Name','PSO Particle Snapshots','Color','w');

snapshots = {p_k1, p_k25, p_k50, p_k75, p_k100};
titles    = {'k = 1','k = 25','k = 50','k = 75','k = 100'};
markers   = {'*b','*r','xk','om','vk'};

for i = 1:numel(snapshots)
    P = snapshots{i};
    if isempty(P), continue; end

    subplot(2,3,i);
    hold on; grid on; box on;

    plot(P(:,1), P(:,2), markers{i}, 'MarkerSize', 6);

    title(titles{i}, 'FontName','Arial','FontSize',12);
    xlabel('Kp','FontName','Arial','FontSize',11);
    ylabel('Ti','FontName','Arial','FontSize',11);

    xlim(cfg.plot.xlim);
    ylim(cfg.plot.ylim);
end

if ~exist('../results','dir')
    mkdir('../results');
end

gf_pso = global_fitness;
save('../results/gf_pso.mat','gf_pso');
