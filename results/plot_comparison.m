%% plot_comparison.m
% ---------------------------------------------------------
% Comparison of metaheuristic optimizers (PI tuning)
% Exhaustive search provides the reference optimum (within grid).
% Metaheuristics show best-so-far fitness (not guaranteed optimal).
% ---------------------------------------------------------

clear; close all; clc;

%% ---------------- Load results ---------------------------
load('gf_exhaustive.mat','gf_exhaustive','bestfitness_exh');

load('gf_pso.mat','gf_pso');
load('gf_firefly.mat','gf_firefly');
load('gf_ga.mat','gf_ga');
load('gf_abc.mat','gf_abc');

% Reference optimum (fitness)
f_star = bestfitness_exh;

%% ---------------- Extract data ----------------------------
k_pso = gf_pso(:,3);     f_pso = gf_pso(:,4);
k_ff  = gf_firefly(:,3); f_ff  = gf_firefly(:,4);
k_ga  = gf_ga(:,3);      f_ga  = gf_ga(:,4);
k_abc = gf_abc(:,3);     f_abc = gf_abc(:,4);

%% Optional: align x-axis to shortest run (common horizon)
kmax = min([max(k_pso), max(k_ff), max(k_ga), max(k_abc)]);

% Trim all curves to common horizon (assumes k starts at 1)
f_pso_t = f_pso(1:kmax);
f_ff_t  = f_ff(1:kmax);
f_ga_t  = f_ga(1:kmax);
f_abc_t = f_abc(1:kmax);
k = (1:kmax).';

%% ---------------- Plot comparison -------------------------
figure('Name','Metaheuristic Comparison — Best-So-Far vs Exhaustive Optimum','Color','w');

% ---- (1) Best-so-far fitness evolution ----
subplot(2,1,1);
hold on; grid on; box on;

plot(k, f_pso_t, 'LineWidth', 1.8);
plot(k, f_ff_t,  'LineWidth', 1.8);
plot(k, f_ga_t,  'LineWidth', 1.8);
plot(k, f_abc_t, 'LineWidth', 1.8);

% Reference optimum line (exhaustive)
yline(f_star, '--', 'LineWidth', 1.6);

title('Best-So-Far Fitness Evolution (Exhaustive Search = Reference Optimum)', ...
      'FontName','Arial','FontSize',13);
xlabel('Iteration / Generation (k)','FontName','Arial','FontSize',11);
ylabel('Best-So-Far Fitness','FontName','Arial','FontSize',11);

legend({'PSO','Firefly','GA','ABC','Exhaustive Optimum (reference)'}, ...
       'Location','best');

xlim([1 kmax]);

% ---- (2) Relative gap to optimum ----
% gap(k) = (f* - f(k)) / f*
subplot(2,1,2);
hold on; grid on; box on;

gap_pso = (f_star - f_pso_t) ./ max(f_star, eps);
gap_ff  = (f_star - f_ff_t)  ./ max(f_star, eps);
gap_ga  = (f_star - f_ga_t)  ./ max(f_star, eps);
gap_abc = (f_star - f_abc_t) ./ max(f_star, eps);

plot(k, gap_pso, 'LineWidth', 1.8);
plot(k, gap_ff,  'LineWidth', 1.8);
plot(k, gap_ga,  'LineWidth', 1.8);
plot(k, gap_abc, 'LineWidth', 1.8);

yline(0, '--', 'LineWidth', 1.6);

title('Relative Gap to Exhaustive Optimum (Lower is Better)', ...
      'FontName','Arial','FontSize',13);
xlabel('Iteration / Generation (k)','FontName','Arial','FontSize',11);
ylabel('Gap = (f^* - f)/f^*','FontName','Arial','FontSize',11);

legend({'PSO','Firefly','GA','ABC','Zero gap'}, 'Location','best');
xlim([1 kmax]);
