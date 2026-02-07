%% analyze_convergence.m
% ---------------------------------------------------------
% Finds:
%  (1) iteration where each method reaches its own max best-so-far fitness
%  (2) iteration where it first reaches the exhaustive reference fitness
%  (3) estimated time (s) to reach the reference optimum
% Also computes a weighted score with execution time.
% ---------------------------------------------------------

clear; close all; clc;

%% -------------------- User settings ----------------------
results_dir = '.';          % folder with .mat files
tol_ref     = 1e-4;         % tolerance to detect reference optimum
alpha_time  = 0.01;         % time penalty weight (score)
Niter       = 100;          % fixed iteration budget

exec_time = struct( ...
  'exhaustive', 82, ...
  'pso',        107, ...
  'firefly',    108, ...
  'ga',         33, ...
  'abc',        363 ...
);

%% -------------------- Load reference ----------------------
Sref  = load(fullfile(results_dir,'gf_exhaustive.mat'), ...
             'bestfitness_exh', 'gf_exhaustive');
f_ref = Sref.bestfitness_exh;

%% -------------------- Load methods ------------------------
methods = { ...
  struct('key','pso',     'file','gf_pso.mat',     'var','gf_pso',     'name','PSO'), ...
  struct('key','firefly', 'file','gf_firefly.mat', 'var','gf_firefly', 'name','Firefly'), ...
  struct('key','ga',      'file','gf_ga.mat',      'var','gf_ga',      'name','GA'), ...
  struct('key','abc',     'file','gf_abc.mat',     'var','gf_abc',     'name','ABC') ...
};

%% -------------------- Analyze -----------------------------
rows = {};

for m = 1:numel(methods)
    M = methods{m};

    data = load(fullfile(results_dir, M.file), M.var);
    gf   = data.(M.var);      % columns: [Kp Ti k bestFitness]

    k = gf(:,3);
    f = gf(:,4);

    % (A) Max best-so-far fitness
    f_max = max(f);
    idx_max_first = find(f == f_max, 1, 'first');
    k_at_max = k(idx_max_first);

    % (B) First iteration reaching reference region
    idx_ref = find(f >= (f_ref - tol_ref), 1, 'first');
    if isempty(idx_ref)
        k_to_ref = NaN;
        time_to_ref = NaN;
    else
        k_to_ref = k(idx_ref);
        time_to_ref = (k_to_ref / Niter) * exec_time.(M.key);
    end

    % (C) Total execution time
    tsec = exec_time.(M.key);

    % (D) Time-weighted score
    score = f_max / (1 + alpha_time * tsec);

    rows(end+1,:) = { ...
        M.name, f_max, k_at_max, k_to_ref, time_to_ref, tsec, score ...
    }; %#ok<SAGROW>
end

%% -------------------- Report as table ---------------------
T = cell2table(rows, 'VariableNames', ...
    {'Technique','MaxBestFitness','IterAtMax','IterToRef', ...
     'TimeToRef_s','ExecTime_s','Score'});

T = sortrows(T, 'Score', 'descend');

fprintf('\nReference fitness (exhaustive): %.6f\n', f_ref);
fprintf('tol_ref = %.1e | alpha_time = %.4f | Niter = %d\n\n', ...
        tol_ref, alpha_time, Niter);

disp(T);

%% -------------------- Save summary ------------------------
save(fullfile(results_dir,'convergence_summary.mat'), ...
     'T', 'f_ref', 'tol_ref', 'alpha_time', 'Niter');
