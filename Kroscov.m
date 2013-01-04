function [rr, M, Argm]=Kroscov(x,y,k)
%  10.01.2006;   17 h 45 min.
%6.7.6;
% This program calculated the crosscovariation function  Kroscov(x,y,k) between a two
%arrays: "x"  and "y"  at the point "k";  on the basis of too moderne adaptive  spectral
%density estimation; we calcilate also the number of harmonics  " M" in the
%Krossspecrtal density; wich will used further.

%  k= -10;  %for example % Necessary condition: |k| \le length - 2!
%Krosscov.m
% In the case Autocovariation function You need to substitude "y = x".
%x= rand(1,32);   % for instance; may be changed.
%y =x; % for instance; may be changed

[m1, n1]=size(x);

if (m1>n1)
    x  = x';
    n1 = m1;
end

[m2, n2]=size(y);

if (m2>n2)
    y  = y';
    n2 = m2;
end
n=min(n1,n2);

% X = mean(x); % average of x;
X = sum(x)/n1;
Y = sum(y)/n2;

x = x - X; %!centering of x;
y = y - Y; %!centering of y;

%NN = fix(sqrt(n));% calculation  of  amount harmonics; non - adaptive!
%N  = fix(n/3); % for an  adaptive  estimation!

N = fix(n/2); % here, 6.7.6;

r = zeros(1,n);  %! initialization of positive cross - covariations;
q = zeros(1,n);  %! initialization of negative cross - covariations;;
r1 = zeros(1,n);
for kk=1:N
%!     for l=1:(n-kk)
%!         r(kk)=r(kk)+x(kk+l)*(y(l)/(n-kk));
%!     end;
    r(kk) = r(kk) + sum(x(kk+1:n).*y(1:n-kk))/(n-kk);    
end; % calculation of positive cross -  covariances

for kk=1:N
%!     for l=1:(n-jjj)
%!         q(kk)=q(kk)+y(kk+l)*(x(l)/(n-l));
%!     end
     q(kk)=q(kk)+sum(y(kk+1:n).*x(1:n-kk))/(n-kk);       
end; % calculation of negative covariations: z(-k)= q(k).

%!v = x(1)*(y(1)/(n-1)); % calculation of zero crosskovariation.
%initialisation;

%! for l=2:n
%!     v= v +  x(l)*(y(l)/(n-1));
%! end    % calculation  of zero cross - covariation.
v = sum(x(1:n).*y(1:n))/(n-1);    


[bb  Dr] = max(r);
[cc  Dq] = max(q);

if (bb >= cc)
    Argm = Dr;
else
    Argm = -Dq;
end % if (bb >= cc)

if ( v >  max(bb,cc))
    Argm = 0;
end % if v > max..


%if     abs(k) > n
% break;
%end   % defence from  exceeding;

if k==0
    rr=v;
elseif k==1
    rr=r(1);
elseif (k>1 & k < n-1)
    rr=r(k);
elseif  k == (-1)
    rr = q(1);    
elseif (k> -n+1 & k <-1)
    rr = q( -k);
end;

Nsq= fix(sqrt(n)); % The classikal amount of harmonics;

N3 = min(Nsq, (fix(n/3) - 1)); % parameter for comprison;
N3 = min(N3,12);

TTa = (r(2))^2 + (q(2))^2;
Ta  = TTa;  % "Ta"  is the current value of Tau.
MM  = 1;

for m = 1:N3
    Z  = (r(2*m +1))^2 + (r(2*m+2))^2 + (q(2*m+1))^2 + (q(2*m+1))^2 + (q(2*m+2))^2 -(r(m+1))^2 - (q(m+1))^2;
    Ta = Ta + Z;
    if (Ta < TTa)
        TTa = Ta;
        MM = m + 1;
    end
end
min_tau =TTa;
%MM;
%[T MMa] = min(Ta)
%Ta

M = min(MM,Nsq);   % only if size = 1000 ot more.

if (M<6)
    M=M+3; % ???
end

M = min(M,n-1);

%end % Calculation of  important functional.
%[Tau, M] = min(tau1); % calculation of amount of harmonics (M);

%r(k);

%Harm  = M  % in such a case.

if (k >M)
    r(k)=0;
    q(k)=0;
end  % cutoff the amount of harmonics.


if k==0
    rr=v;
elseif k==1
    rr=r(1);
elseif  ( (k>1) & (k < min(n, (M+1))))
    rr=r(k);
elseif  k == (-1)
    rr = q(1);    %w=rr
elseif (   ( k> -min(n, (M+1)  ) & (k <-1)    )   )
    rr = q( -k);
end;



return