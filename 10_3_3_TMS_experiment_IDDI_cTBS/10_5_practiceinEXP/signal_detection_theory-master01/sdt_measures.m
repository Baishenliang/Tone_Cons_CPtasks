function [d, c, cPrime, beta, lnBeta, A, B] = sdt_measures(hits, misses, CRs, FAs, varargin)
% sdt_measures.m: Signal detection theory
%
% Created: 02/19/2018, Evan Layher
% Revised: 03/11/2018, Evan Layher % Added more output measures
%
% --- LICENSE INFORMATION --- %
% Modified BSD-2 License - for Non-Commercial Use Only
%
% Copyright (c) 2018, The Regents of the University of California
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification, are 
% permitted for non-commercial use only provided that the following conditions are met:
%
% 1. Redistributions of source code must retain the above copyright notice, this list 
%    of conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright notice, this list 
%    of conditions and the following disclaimer in the documentation and/or other 
%    materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
% EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
% OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
% SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
% INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
% TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
% OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY 
% WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
% For permission to use for commercial purposes, please contact UCSB's Office of 
% Technology & Industry Alliances at 805-893-5180 or info@tia.ucsb.edu.
% --------------------------- %
%
% Signal detection theory: compute discriminability and criterion
%
% Inputs (4 required): hits, misses, CRs, FAs, (inf value adjustment)
% (1) hits: hit count
% (2) misses: miss count
% (3) CRs: correct rejection count
% (4) FAs: false alarm count
% (5) infAdjust (optional): custom default value when rate is 0% or 100%
%  - If infAdjust < 1 then value is numerator: infAdjust/[total responses]
%  - If infAdjust > 1 then value is denominator:
%  --- 0% becomes 1/infAdjust
%  --- 100% becomes (infAdjust - 1)/infAdjust
%
% Outputs (7): d', c, c', beta, ln(beta), A', B''
% (1) d: d'
% (2) c: criterion
% (3) cPrime: c'
% (4) beta: Beta
% (5) lnBeta: natural log of Beta
% (6) A: A' (nonparametric discriminability)
% (7) B: B'' (nonparametric criterion)

if hits == 0 && misses == 0 % Must have either hits or misses
    d = NaN;
    c = NaN;
    cPrime = NaN;
    beta = NaN;
    return
end

if CRs == 0 && FAs == 0 % Must have either CRs or FAs
    d = NaN;
    c = NaN;
    cPrime = NaN;
    beta = NaN;
    return
end

if isempty(varargin) % Check for infinite adjustment value
    infAdjust = 0; % Do not adjust infinite values
else
    infAdjust = varargin{1};
end

htRate = hits / (hits + misses); % Hit rate
faRate = FAs / (CRs + FAs); % False alarm rate

% Adjust htRate/faRate if equal to 0% or 100%
if infAdjust > 0 % Hit rate adjustment
    if hits == 0 % Hit rate = 0%
        if infAdjust < 1
            htRate = infAdjust / misses; % Avoid inf value
        else
            htRate = 1 / infAdjust; % Avoid inf value
        end
    elseif misses == 0 % Hit rate = 100%
        if infAdjust < 1
            htRate = (hits - infAdjust) / hits; % Avoid inf value
        else
            htRate = (infAdjust - 1) / infAdjust; % Avoid inf value
        end
    end % if hits == 0
end % if ~isempty(infAdjust)

if infAdjust > 0 % False alarm rate adjustment
    if CRs == 0 % Correct rejection rate = 0%
        if infAdjust < 1
            faRate = (FAs - infAdjust) / FAs; % Avoid inf value
        else
            faRate = (infAdjust - 1) / infAdjust; % Avoid inf value
        end
    elseif FAs == 0 % Correct rejection rate = 100%
        if infAdjust < 1
            faRate = infAdjust / CRs;
        else
            faRate = 1 / infAdjust; % Avoid inf value
        end
    end % if hits == 0
end % if ~isempty(infAdjust)

% Discriminability measures
d = norminv(htRate) - norminv(faRate); % d'

if htRate >= faRate % A' calculations
    A = 0.5 + ((htRate - faRate) * (1 + htRate - faRate)) / (4 * htRate * (1 - faRate));
else % htRate < faRate
    A = 0.5 - ((faRate - htRate) * (1 + faRate - htRate)) / (4 * faRate * (1 - htRate));
end

% Criterion measures
c = -0.5 * (norminv(htRate) + norminv(faRate)); % criterion
cPrime = c / d; % c'
beta = exp((norminv(htRate)^2 - norminv(faRate)^2) / -2); % beta
lnBeta = log(beta); % ln(beta)

if htRate >= faRate % B'' calculations
    B = (htRate * (1 - htRate) - faRate * (1 - faRate)) / (htRate * (1 - htRate) + faRate * (1 - faRate));
else % htRate < faRate
    B = (faRate * (1 - faRate) - htRate * (1 - htRate)) / (faRate * (1 - faRate) + htRate * (1 - htRate));
end

end % function