function Cromosoma = mutacion(Cromosoma, cromN, MaxF, MinF)
% mutacion
% ---------------------------------------------------------
% Mutation operator for real-coded GA.
% For each chromosome:
%   - with probability 0.6
%   - mutate ONE randomly selected gene (Kp or Ti)
%   - new gene is uniformly sampled in [MinF, MaxF]
%   - quantized to 0.1
% ---------------------------------------------------------

for i = 1:cromN
    posM  = round(1 + rand); 
    RateM = rand;
    if RateM < 0.6
        Cromosoma(i,posM) = round(((MaxF-MinF)*rand + MinF)*10)/10;
    end
end
end