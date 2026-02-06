function fitness = getfitness(J, uMax, Tr)
% getfitness
% ---------------------------------------------------------
% Fitness evaluation for PI controller optimization
%
% Objective:
%   J = Integral of Squared Error (ISE)
%
% Constraints:
%   - Maximum control signal: uMax <= 5 V
%   - Minimum rise time:      Tr   >= 10 s
%
% Fitness mapping:
%   - Infeasible solutions -> fitness = 0
%   - Feasible solutions   -> fitness = 1 / (1 + 0.01 * J)
%
% Note:
%   Lower ISE => higher fitness
% ---------------------------------------------------------

% Hard constraints
if (uMax > 5) || (Tr < 10) || ~isfinite(J)
    fitness = 0;
    return;
end

% Fitness normalization (same as original implementation)
fitness = 1 / (1 + 0.01 * J);

end
