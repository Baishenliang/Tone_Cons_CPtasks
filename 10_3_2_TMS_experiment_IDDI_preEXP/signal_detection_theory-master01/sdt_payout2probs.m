function [tProb] = sdt_payout2probs(hit,cr,miss,fa)
% sdt_payout2probs.m: Signal detection theory
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
% Signal detection theory: Convert payout structure to equivalent base rate
%
% Example: +$0.05 for correct, -$0.10 for miss, no penalty for false alarm
% Input: tProb = sdt_payout2probs(0.05, 0.05, -0.10, 0);
%
% Calculations for optimal criterion placement require base rate
% information. That is the probability of targets vs. lures
%
% However, a varied payout structure (e.g. cash or point bonuses) also
% affect optimal criterion placement.
%
% This script will output the equivalent target probability that would
% elicit the same optimal criterion given the payout structure
%
% Inputs (4 required): Rewards (cash or points)
% [1] (hit) Bonus for hits 
% [2] (cr) Bonus for correct rejections
% [3] (miss) Penalty for misses
% [4] (fa) Penalty for false alarms
%
% Output (1): Target probability 
% [1] (tProb) Target probability with equivalent optimal criterion

if hit <= miss || cr <= fa % Bonuses must exceed penalties
    error(['HIT BONUS (%s) MUST BE GREATER THAN MISS PENALTY (%s)\nCORRECT ' ...
        'REJECTION BOUNS (%s) MUST BE GREATER THAN FALSE ALARM PENALTY (%s)\n'], ...
        num2str(hit), num2str(miss), num2str(cr), num2str(fa));
end

tProb = (-miss + cr) / (hit - miss + cr - fa);

end