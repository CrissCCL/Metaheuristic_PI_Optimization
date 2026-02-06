function [velKp_actual, velTi_actual] = EvalVel( ...
    vel_Kp, vel_Ti, ...
    bestpospKp, bestpospTi, ...
    posicion_pKp, posicion_pTi, ...
    gbestKp, gbestTi, ...
    w1, phi1, phi2)
% EvalVel
% ---------------------------------------------------------
% PSO velocity update (2D: Kp, Ti)
% v(k+1) = w*v(k) + phi1*rand*(pbest - x) + phi2*rand*(gbest - x)
%
% This function preserves the original implementation behavior.
% ---------------------------------------------------------

velKp_actual = w1*vel_Kp + phi1*rand*(bestpospKp - posicion_pKp) + phi2*rand*(gbestKp - posicion_pKp);
velTi_actual = w1*vel_Ti + phi1*rand*(bestpospTi - posicion_pTi) + phi2*rand*(gbestTi - posicion_pTi);

end
