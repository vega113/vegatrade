% function  f = Tau( ck) Calculates
%the harmonic number which minimizes the
% Tau functional input:
%		ck - array of Fourrier coefficients
% output:
%		f - the value that minimizes sum(ck(i:2*i).^2)
%
function  f = Tau( ck)
n = floor(length(ck)/2);
maxi = n;
m=zeros(1,maxi);
for i=1:maxi
    m(i) = sum(ck(i:2*i).^2);
end
[t f]=min(m);
f_t=f;








