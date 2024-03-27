function [c, perCor, htRate, faRate] = sdt_optimal_c(tProb,d)
% sdt_optimal_c.m: Signal detection theory
%
% Created: 03/11/2018, Evan Layher
% Revised: 03/11/2018, Evan Layher
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
% Signal detection theory: Calculate optimal criterion (c) placement
% c = z(Hit rate) + z(False Alarm rate) / -2
%
% Calculate the optimal c value for a given d' and target probability
%
% Inputs (2 required)
% [1] (tProb) target probability
% [2] (d) d' value
%
% Outputs (4)
% [1] (c) optimal criterion
% [2] (perCor) optimal percent correct
% [3] (htRate) optimal hit rate
% [4] (faRate) optimal false alarm rate

if tProb < 0 || tProb > 1 % Ensure valid target probability
    error('TARGET PROBABILITY MUST BE FROM 0 TO 1\n');
end

if d < 0 % If below chance performance, assume chance
    d = 0; % d' at chance
end

if d == 0 && tProb == 0.5 % Avoid calculation: 0 / 0
    c = 0;
else
    c = log((1 - tProb) / tProb) / d; % Optimal criterion
end

htRate = normcdf(d / 2 - c); % Optimal hit rate
faRate = normcdf(-d / 2 - c); % Optimal false alarm rate
perCor = htRate * tProb + (1 - faRate) * (1 - tProb); % Optimal percent correct
end % function

