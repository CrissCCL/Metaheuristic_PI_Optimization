%% run_abc.m
% ---------------------------------------------------------
% Metaheuristic PI Optimization — Artificial Bee Colony (ABC)
% Process: Single Tank (linear model around operating point)
% Objective: Optimize PI parameters under constraints (ISE-based fitness)
% Author: Cristian A. Castro Lagos
% ---------------------------------------------------------

clear; close all; clc;

%% ------------------- Configuration ------------------------
cfg = struct();

% ABC parameters
cfg.abc.Fa          = 60;    % food sources / colony size parameter (as used in your code)
cfg.abc.generations = 400;   % iterations (generations)

% Simulation / plant
cfg.sim.T      = 100;      % simulation horizon [s]
cfg.sim.dt     = 0.01;     % time step [s]
cfg.sim.t      = 0:cfg.sim.dt:cfg.sim.T;

cfg.plant.Uop  = 2.9;            % operating input
cfg.plant.G    = tf(12,[53 1]);  % linear tank model

%% -------------------- Run ABC -----------------------------
assert(exist('evalPIDopABC','file')==2, ...
    'Function evalPIDopABC.m not found. Add it to the MATLAB path.');
tic
[LA, rentabilidad, Best_alimento, BestLA, Bee, global_fitness] = ...
    evalPIDopABC(cfg.sim.T, cfg.plant.Uop, cfg.plant.G, ...
                 cfg.abc.Fa, cfg.abc.generations);
toc
%% -------------------- Console Summary ---------------------
% NOTE: Once we see evalPIDopABC.m, we can report Kp/Ti best exactly.
Kp_best     = BestLA(1);
Ti_best     = BestLA(2);
bestFitness = global_fitness(end,4);

[J, uMax, Tr] = evalrespPID(cfg.plant.G, cfg.sim.t, ...
                            Kp_best, Ti_best, cfg.plant.Uop);

fprintf('\n===== ABC Result =====\n');
fprintf('Kp*   = %.4f\n', Kp_best);
fprintf('Ti*   = %.4f\n', Ti_best);
fprintf('Fitness (best) = %.6f\n', bestFitness);
fprintf('u_max = %.4f\n', uMax);
fprintf('tr    = %.4f s\n\n', Tr);
%% -------------------- Plot: membership function Tr --------
figure('Name','Membership Function for Tr','Color','w');

t = 0:cfg.sim.dt:cfg.sim.T;
f = (t<8)*0 + ((t>=8)&(t<=10)).*((t-8)/(10-8)) + (t>10)*1;

plot(t, f, 'LineWidth', 1.5);
grid on; box on;
title('Membership Function — Rise Time (Tr)','FontName','Arial','FontSize',14);
xlabel('Tr [s]','FontName','Arial','FontSize',12);
ylabel('Decision','FontName','Arial','FontSize',12);
axis([0 50 0 1.2]);

%% -------------------- Plot: quality evolution -------------
figure('Name','ABC Quality Evolution','Color','w');
plot(Bee(:,3), Bee(:,1), 'or');
grid on; box on;
title('ABC — Quality Evolution','FontName','Arial','FontSize',14);
xlabel('Iteration','FontName','Arial','FontSize',12);
ylabel('Quality','FontName','Arial','FontSize',12);


if ~exist('../results','dir')
    mkdir('../results');
end
gf_abc = global_fitness;
save('../results/gf_abc.mat','gf_abc');
