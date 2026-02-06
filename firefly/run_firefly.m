%% run_firefly.m
% ---------------------------------------------------------
% Metaheuristic PI Optimization — Firefly Algorithm
% Process: Single Tank (linear model around operating point)
% Objective: Optimize PI parameters under constraints (ISE-based fitness)
% Author: Cristian A. Castro Lagos
% ---------------------------------------------------------

clear; close all; clc;

%% ------------------- Configuration ------------------------
cfg = struct();

% Firefly parameters
cfg.ff.Nf      = 150;   % number of fireflies
cfg.ff.maxIter = 100;   % iterations

% Simulation / plant
cfg.sim.T      = 100;      % simulation horizon [s]
cfg.sim.dt     = 0.01;     % time step [s]
cfg.sim.t      = 0:cfg.sim.dt:cfg.sim.T;

cfg.plant.Uop  = 2.9;            % operating input
cfg.plant.G    = tf(12,[53 1]);  % linear tank model

% Plot settings
cfg.plot.xlim = [-2 22];
cfg.plot.ylim = [-2 22];

% Optional overlay (the red circle you used before)
cfg.plot.drawCircle = true;
cfg.plot.circle = struct('cx',0.6,'cy',15,'r',0.5,'n',100);

%% -------------------- Run Firefly -------------------------
assert(exist('evalPIDopFIREFLY','file')==2, ...
    'Function evalPIDopFIREFLY.m not found. Add it to the MATLAB path.');

[posicion_F, posicion_Fg, brillo, p0, p1, p2, p3, p4, p5, global_fitness] = ...
    evalPIDopFIREFLY(cfg.sim.T, cfg.plant.Uop, cfg.plant.G, ...
                     cfg.ff.Nf, cfg.ff.maxIter);

%% -------------------- Best candidate (report) -------------
% NOTE:
% Here we assume posicion_Fg contains at least [Kp Ti] as the global best.
% Once you share evalPIDopFIREFLY.m, we can extract this 100% precisely.
Kp_best = posicion_Fg(1);
Ti_best = posicion_Fg(2);

% Evaluate best point using the common objective + fitness
[J, uMax, Tr] = evalrespPID(cfg.plant.G, cfg.sim.t, Kp_best, Ti_best, cfg.plant.Uop);
bestFitness   = getfitness(J, uMax, Tr);

%% -------------------- Console Summary ---------------------
fprintf('\n===== Firefly Result =====\n');
fprintf('Kp*   = %.4f\n', Kp_best);
fprintf('Ti*   = %.4f\n', Ti_best);
fprintf('Fitness (best) = %.6f\n', bestFitness);
fprintf('u_max = %.4f (constraint)\n', uMax);
fprintf('tr    = %.4f s (constraint)\n\n', Tr);

%% -------------------- Plot: Firefly snapshots---------------------

figure('Name','Firefly Particle Evolution','Color','w');

snapshots = {p0, p1, p2, p3, p4, p5};
titles    = {'k = 1','k = 5','k = 25','k = 50','k = 75','k = 100'};
markers   = {'*m','*g','*r','*k','*m','*b'};

for i = 1:numel(snapshots)

    P = snapshots{i};
    if isempty(P), continue; end

    subplot(2,3,i);
    hold on; grid on; box on;

    plot(P(:,1), P(:,2), markers{i}, 'MarkerSize', 6);

    % Optional circle overlay (igual a tu versión original)
    if cfg.plot.drawCircle
        th = linspace(0,360,cfg.plot.circle.n+1);
        x1 = cosd(th)*cfg.plot.circle.r + cfg.plot.circle.cx;
        y1 = sind(th)*cfg.plot.circle.r + cfg.plot.circle.cy;
        plot(x1, y1, 'r', 'LineWidth', 1.0);
    end

    title(titles{i}, 'FontName','Arial','FontSize',12);
    xlabel('Kp','FontName','Arial','FontSize',11);
    ylabel('Ti','FontName','Arial','FontSize',11);

    xlim(cfg.plot.xlim);
    ylim(cfg.plot.ylim);
end
%% -------------------- Plot: fitness evolution -------------
figure('Name','Firefly Fitness Evolution','Color','w');
plot(global_fitness(:,3), global_fitness(:,4),'LineWidth',1.5);
grid on; box on;
xlabel('Iteration k');
ylabel('Best Fitness');
title('Firefly – Fitness Evolution');



if ~exist('../results','dir')
    mkdir('../results');
end

gf_firefly = global_fitness;
save('../results/gf_firefly.mat','gf_firefly');
