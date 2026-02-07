%% analyze_convergence.m
% ---------------------------------------------------------
% Finds:
%  (1) iteration where each method reaches its own max best-so-far fitness
%  (2) iteration where it first reaches the exhaustive reference fitness
% Also computes a weighted score with execution time.
% ---------------------------------------------------------

clear; close all; clc;

%% -------------------- User settings ----------------------
% Folder where .mat files live (use '.' if same folder)
results_dir = '.';   % e.g., '../results'

% Reference target tolerance (for reaching exhaustive optimum)
tol_ref = 1e-4;

% Time-weighted score (bigger alpha -> stronger penalty for slow methods)
alpha_time = 0.01;   % <-- tune this

% Provide execution time in seconds (from your updated table)
exec_time = struct( ...
  'exhaustive', 82, ...
  'pso',        107, ...
  'firefly',    108, ...
  'ga',         33, ...
  'abc',        363 ...
);

%% -------------------- Load reference ----------------------
Sref = load(fullfile(results_dir,'gf_exhaustive.mat'), 'bestfitness_exh', 'gf_exhaustive');
f_ref = Sref.bestfitness_exh;

%% -------------------- Load methods ------------------------
methods = { ...
  struct('key','pso',     'file','gf_pso.mat',     'var','gf_pso',     'name','PSO'), ...
  struct('key','firefly', 'file','gf_firefly.mat', 'var','gf_firefly', 'name','Firefly'), ...
  struct('key','ga',      'file','gf_ga.mat',      'var','gf_ga',      'name','GA'), ...
  struct('key','abc',     'file','gf_abc.mat',     'var','gf_abc',     'name','ABC') ...
};

%% -------------------- Analyze -----------------------------
rows = [];

for m = 1:numel(methods)
    M = methods{m};

    data = load(fullfile(results_dir, M.file), M.var);
    gf = data.(M.var);         % expected columns: [Kp Ti k bestFitness]

    k = gf(:,3);
    f = gf(:,4);

    % (A) Max of its own best-so-far curve
    f_max = max(f);
    idx_max_first = find(f == f_max, 1, 'first');
    k_at_max = k(idx_max_first);

    % (B) First iteration where it reaches the reference (exhaustive) fitness
    idx_ref = find(f >= (f_ref - tol_ref), 1, 'first');
    if isempty(idx_ref)
        k_to_ref = NaN;  % never reached reference within run
    else
        k_to_ref = k(idx_ref);
    end

    % Time
    tsec = exec_time.(M.key);

    % (C) Weighted score (example):
    % - reward higher max fitness
    % - penalize long runtimes
    score = f_max / (1 + alpha_time * tsec);

    rows = [rows; {M.name, f_max, k_at_max, k_to_ref, tsec, score}]; %#ok<AGROW>
end

%% -------------------- Report as table ---------------------
T = cell2table(rows, 'VariableNames', ...
    {'Technique','MaxBestFitness','IterAtMax','IterToRef','ExecTime_s','Score'});

% Sort by score (descending)
T = sortrows(T, 'Score', 'descend');

fprintf('\nReference fitness (exhaustive): %.6f\n', f_ref);
fprintf('tol_ref = %.1e | alpha_time = %.4f\n\n', tol_ref, alpha_time);
disp(T);

%% -------------------- Optional: save summary --------------
save(fullfile(results_dir,'convergence_summary.mat'), 'T', 'f_ref', 'tol_ref', 'alpha_time');
