function [J, uMax, Tr] = evalrespPID(g, t, Kp, Ti, Upt_op)
% evalrespPID
% ---------------------------------------------------------
% Evaluates closed-loop PI control performance for a tank system.
% Outputs:
%   J    : ISE objective
%   uMax : max control signal (with operating point)
%   Tr   : rise time (10–90%)
% ---------------------------------------------------------

% PI controller
C = tf((Kp/Ti)*[Ti 1], [1 0]);

% Closed-loop system
G_cl = feedback(C*g, 1);

% Output response and error
y = step(G_cl, t);
e = 1 - y;

% Control signal (reference -> u)
U_tf = C / (1 + C*g);
u = step(U_tf, t);

uReal = u + Upt_op;
uMax  = max(uReal);

% Rise time (same strategy as your original functional code)
S  = stepinfo(G_cl, 'RiseTimeLimits', [0.1 0.9]);
Tr = S.RiseTime;

% Objective: ISE
J = sum(e(:).^2);

end
