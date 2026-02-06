%% funcion de busqueda exhaustiva
function [Kp_min, Ti_min, bestfitness, soluciones] = evalPIDopBusqExh(Kp, Ti, g, T, Upt_op)
% evalPIDopBusqExh
% ---------------------------------------------------------
% Exhaustive (grid) search for PI tuning over Kp x Ti grid.
% Returns reference optimum within the evaluated grid.
%
% soluciones format (rows):
%   [fitness, Kp, Ti, uMax, Tr]
% ---------------------------------------------------------

dt = 0.01;
t  = 0:dt:T;

nKp = numel(Kp);
nTi = numel(Ti);
N   = nKp * nTi;

% Preallocate (speed + stability)
soluciones = zeros(N, 5);

b = 0;
for i = 1:nKp
    for l = 1:nTi
        b = b + 1;

        [J, uMax, Tr] = evalrespPID(g, t, Kp(i), Ti(l), Upt_op);
        fit = getfitness(J, uMax, Tr);

        soluciones(b,:) = [fit, Kp(i), Ti(l), uMax, Tr];
    end
end

% Reference optimum (max fitness)
[bestfitness, pos] = max(soluciones(:,1));
Kp_min = soluciones(pos,2);
Ti_min = soluciones(pos,3);

end


