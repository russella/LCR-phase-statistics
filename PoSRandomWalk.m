pkg load statistics

##### load command-line arguments
arg_list = argv ();
alpha = str2double(arg_list{1})
ratio = str2double(arg_list{2})
#ratio = 4 # Cardano pessimistic

#alpha = 0.8	% honest stake ratio
#D = 2 * 1/20	% network delay (measured in block interval)
				      % Cardano 20s per block
D = 1/ratio  	% network delay (measured in block interval)

Alphabet = 10
States = 19
KK = 1000
% Alphabet is max possible epoch length
%   need to be large enough to ensure numeric precision of P(j, 2) 
%   as well as negligible probability of larger j
% States is the number of states in the Markov chain tracked
% KK is the max number of confirmation to evaluate

[Pa, PH, PD, PA, PAD] = PoSSlotPdf(alpha, D, Alphabet);

% PoS warmup and final stages are the same as PoW
St0 = PoWMCWarmupUB(PAD, Alphabet, States); 
Error = zeros(KK, 1);
#tic
for K = 1:KK
    St2 = PoSMCConfirmUB(K, Pa, PH, PD, PA, St0, Alphabet, States);
    Error(K) = PoWMCFinalUB(PAD, St2, Alphabet, States);
    printf("%d    %d    %d    %d\n",alpha,ratio,K,Error(K))
end
#toc
#ErrorUB = Error

#St0 = PoWMCWarmupLB(PAD, Alphabet, States);
#Error = zeros(KK, 1);
#tic
#for K = 1:KK
#    K
#    % private mining as lower bound 
#    St2 = PoSMCConfirmPM(K, Pa, PH, PD, PA, PAD, St0, Alphabet, States);
#    Error(K) = PoWMCFinalLB(PAD, St2, Alphabet, States)
#end
#toc
#ErrorLB = Error

