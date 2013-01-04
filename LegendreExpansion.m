% function coeffs = LegendreExpansion(n,f,x)

% Computes  the first m coefficients of the
%Legendre expansion for f(x).
% input:
%n - the harmonical value f - the values of 
%approximated function at
%points x x - the x-es
%output
%		coeffs - the Fourier coefficients
%
function coeffs = LegendreExpansion(n,f,x,step,mode)
m = length(x); % length of x-es vector.
pl=zeros(n,m); % matrix n:m,
ck(1:n)=0;           % the coefficients vector
if(mode == 1) % density
    % each m-th row contains value of  
    %P(m-1) legender polynomal at points
    % f
    pl=LPoly(n,f); 
    for i=1:n
        ck(i)=sum(pl(i,:))*step;
    end

end
if(mode == 0) % regression
     % each m-th row contains value of 
     %P(m-1) legender polynomal at points
     % x
    pl=LPoly(n,x);
    for i=1:n
        ck(i)=pl(i,:)*f'*step;
    end
end
coeffs = ck;



