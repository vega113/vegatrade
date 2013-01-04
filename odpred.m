
function[xtau_tau, delta]=odpred(x, dgg, TA)
USE_VALLLE_POISSIN = true;
%clc;
% 30.09.2006; % A new version at 2.12.2006; 23.12.2006;
% this program calculated the one - dimensional trend
%forecasting of the one- dimesional array "x";
% Given:array  "x", truncation  from 1: to(n-tau)
% and prediction "x(n)" on the basis "x(1:(n-tau))".

n      = length(x); % General Length
tau    = 0; % !!! 1.9.007;   !not used at this version
winLen = n;

if (winLen <12)
    disp('non-correctness');
    return
end % if

XX = x(1:winLen);  % Truncation of array.
t  = 1:(winLen);   % times array;
tt = t/winLen;     %!   = [1/winLen, 2/winLen, .... ,1  ]  unit interval

QQ   = polyfit(tt,XX,dgg);
VV   = polyval(QQ,tt);         %! Trend values

xx0       = XX - VV;           %! stochastic component
XXtay_tau = polyval(QQ, 1+ TA/winLen);  % Is the deterministic value of prediction. (trend prediction)
XX_true   = XX(end);

%!  -------- preparation to construc covariance matrix ----------------
[c0, M, Argm] = Kroscov(xx0,xx0, 0);
c  = zeros(1,M+2); 
for K=1:(M+2)   %! why M+2 ?  we need M
    [c(K), M, Argm ]= Kroscov(xx0,xx0, abs(K));
end %for K

if (USE_VALLLE_POISSIN)
    lenC     = length(c);       % Cc =
    halfLenC = fix(lenC /2);
    VallePoissin = (lenC - [halfLenC:M+2]) / halfLenC;
    c(halfLenC:end) = c(halfLenC:end).*VallePoissin;
end
%! cov. matrix construction
%forming of matrix of system of equation.
for K=1:(M)
    for L = K:(M)
        if(K ~=L)
            cv(K,L) = c(abs(K-L));
            cv(L,K) = cv(K,L);            
        else
            cv(K,K) = c0; %! K==sL
        end
    end %for K
end  %for L

CNN = cond(cv);  %!  repair  cov mat if need 
if(CNN > 1000000)
    for KK = 1:(M)
        cv(KK,KK) = cv(KK,KK)*1.02;
    end % for KK =1...    
end % if

b = [c0 c(1:M-1)];
%solving of linear system  
%!!!  y*cv=b  !!!
y = b/cv;

zz = xx0(winLen:-1:winLen-M+1);  

ranpred_tau = sum(zz.*y);          %! % Is the stochastic value of prediction.

%!  XXtay_tau = polyval(QQ, 1+ TA/winLen);  % Is the deterministic value of prediction.
%!  XX_true   =  XX(end);

xtau_tau = ranpred_tau + XXtay_tau;  %! prediction to return % stochastic + deterministic
delta    = xtau_tau - XX_true;       %! deviation from the lest time point at window
  

return