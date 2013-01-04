
%Output is the numerical integral using trapezoid rule over [a,b]
%  input :
%  fvalues - values vector of function we want to integrate
%  at the grid on [a,b] a - lower bound b - higher bound
%output:
%                I - numerical integral
%trapsum.m
function I= trapsum(fvalues,a,b)
N=length(fvalues);
I=((b-a)/(N-1))*(1/2*fvalues(1)+sum(fvalues(2:N-1))+1/2*fvalues(N));
