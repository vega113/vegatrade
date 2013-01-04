%function lp = LPoly(n ,x)
% Calculates the values of 
%Legendre Polynomial at points x input:
%n - the degree of highest polynomial
%x - the vector of x-es
%output:
%lp - matrix nxlength(x) each row contains
%values of Legendre
%		polynomial of degree i=(1:n)  at points x
function lp = LPoly(n ,x)
xlength=length(x);
lp=zeros(n,xlength);
lp(1,:)=1; %Pn(0)
if n>1
    lp(2,:)=x; %Pn(1)
end
if n>2 %Pn(n) n in [2,infinity]
    for i=3:n
        % the recusrsion
        lp(i,:)=(( 2*(i-2)+1).*x.*lp(i-1,:)-(i-2)*lp(i-2,:))/(i-1);  
    end
end
for i=1:n
    lp(i,:)=lp(i,:).*((( 2*(i-1)+1)/2)).^0.5;  %normalization
end


