%Output is Approximation by Legendre orthonormal
%polynomials This function
%receives values vector of a function . X-es of these 
%values are assumed to
%be from a grid [a,b]  The output is approximated
%values of this function
%at points xs
%  input :
%  y - values vector of function we want to estimate
%   x - vector of X-s that we want to get the function
% estimates at.xs - points over which we want to know the
% interpolated values of estimated function
%the mode - regression = '0', density estimation = '1'
% ck_tau - the resulting Fourier-Legendre
%coefficients 1:N,
%                 N = argmin Tau
%output: estimation of f(x) at points  x
function [f, n, lowb, uppb, ck_tau] =...
    LegendreApproximate(y,x,mode)
step = 0; lowb=0;uppb=0;
if(mode == 1) % density
    z=y;
    z1=x;
    uppb = 1;
    lowb = -1;
    maxy = max(y);
    miny=min(y);
    if(maxy > uppb | miny < lowb )
		%Legendre polynomials don't behave well on the endpoints
        % edgeFactor - need them in order to get some padding, 
        %it's bad idea to start
        % right away with [-1,1]
        c1=10;
        c2=10;
        edgeFactorMin = (length(y)+c1)/length(y);
        edgeFactorMax = (length(y)+c2)/length(y);

        lowb=miny*edgeFactorMin;
        uppb=maxy*edgeFactorMax;
		% map [lowb,uppb] to [-1,1]
        z = (2*y - lowb - uppb)/(uppb-lowb); 
        z1= (2*x - lowb - uppb)/(uppb-lowb);
    end
    step =  1/(length(y));  %length of step
    ck = LegendreExpansion(length(z),z,x,step,mode);
    n=Tau(ck);%adaptively estimate the n - 
    %number of ck-s  we need to use
    ck_tau=ck(1:n);
    m = length(x); % length of x-es vector.
    % matrix n:m, each m-th row contains value of  
    %P(m-1) legender
    % polynomal at points x
    pl=zeros(n,m); 
    pl=LPoly(n,z1);
    ifunc=zeros(n,m);
    for i=1:n
        ifunc(i,:)=(ck(i)*pl(i,:));
    end
    f(1:m)=0;
    f = sum(ifunc);
    for i=1:length(x)
        if(x(i)> uppb | x(i) < lowb )
            f(i) = 0;
        end
    end
    for i=1:length(f)
        if(f(i)< 0 )
            f(i) = 0;
        end
    end
    intSum = 0;
    intSum=trapsum(f,lowb,uppb); 
    % calculate integral over[lowb,uppb] using the
    %trapezoid rule
    %     intsum = SymIntLeg(ck(1:n),lowb,uppb);%calculate
    %integral using
    %     symbolic toolbox
    f=f/intSum; % let's try  forcing the 
    %trapezoid sum to be 1
end
if(mode == 0) % regression
    lowb=min(x);
    uppb=max(x)+1;
    z1 = (2*x - lowb - uppb)/(uppb-lowb);
    z2=y;
    step = (max(z1)-min(z1))/(length(z1));  %length of step
    ck = LegendreExpansion(length(z1),z2,z1,step,mode);
    n=Tau(ck);
    %adaptively estimate the n - number of ck-s  we need to use
    ck_tau=ck(1:n);
    m = length(z1); % length of x-es vector.
    pl=zeros(n,m);
    % matrix n:m, each m-th row contains value of
    %P(m-1) legendre polynomal at points x
    pl=LPoly(n,z1);
    ifunc=zeros(n,m);
    for i=1:n
        ifunc(i,:)=ck(i)*pl(i,:);
    end
    f(1:m)=0;
    f = sum(ifunc);
end

