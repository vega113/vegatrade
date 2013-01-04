%LRuc test, if number of  exceptions is too 
%high - reject the VaR model
% output:
%                    f - 1 if model accepted, 0 otherwise
% input:
%  T - amount of observations N -  amount of exceptions
%   c =1 - cLevel , where cLevel is the VaR significance
%   level
% By Yuri Zelikov, 
%Bar Ilan University, Israel.  email: vega113@gmail.com
function f=LRuc(T,N,c)
exp1 = -2*N*log(1-c);
exp2 = -2*(T-N)*log(c);
exp3= 2*N*log(N/T);
exp4= 2*(T-N)*log((T-N)/T);
exp5 = exp1 + exp2 + exp3 + exp4;
if(exp5 >3.84)
    f=0;
else
    f=1;
end