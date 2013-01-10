%This function calculates VaR with Legendre 
%method - by means of non
%parametric probability density estimation 
%function VaR = LegVaR(assets,
%weights, tHorizon,cLevel,assetsOrder) Output :
% VaR -  value at risk in currency units 
%deviation - deviation
%from amount of expected "exceptions",
% i.e. there should be (1-cLevel)
%   percent exceptions
%Input:
%            assets - matrix of assets historical data, 
%time series. it can
%            contain
%close prices for some period, that period should 
%be relevant for
%determining Var at given time horizon. each row in 
%this matrix contains
%time series of a single asset. the last row is with
%the most recent data.
%            weights - those are weights for the assets. 
%the portfolio
%            value determined
%by multiplying assets matrix by weights vector 
%and then summing over the
%product vector
%            tHorizon - time horizon over which we want 
%to calculate the
%            value at risk.
%tHorizon ==1, means the absVaR of money could be 
%lost over 1 day with
%probability of 1-cLevel
%            cLevel  - confidence level usually
%0.95 or 0.99 assetsOrder -
%            1 if the first element contains the 
%oldest observation,
% and  the last element the most recent. 0 otherwise.
%
% By Yuri Zelikov, 
%Bar Ilan University, Israel.  email: vega113@gmail.com
% reference  : Hull - options, 
%features and other derivatives, 5th edition.
function [VaR deviation isVaRAcceptedLRuc MMr MMd] =...
    LegVaR(assets,cLevel,assetsOrder)
% estimate the trend
%fix the date order of time-series
[rowsN, colN] = size(assets);
temp = zeros(rowsN,colN);
if assetsOrder == 0
    for i = rowsN:-1:1
        temp(rowsN-i+1,:)=assets(i,:); 
        %reverts the assets time series order
    end
    assets = temp;
end

%check that we have column data
[m,n] = size(assets);
if(m>n)
    assets=assets';
end
%first step - estimate the trend - 
%by regression, and remove it from the
%data
x=linspace(1,length(assets),length(assets));
%[fr ,MMr, lowb, uppb ck] = LegendreApproximate(assets,x,0);
[fr] = Ratapp(assets);
RemTrend = assets - fr;
%compute the differences
date_differences = diff(RemTrend);
%now estimate the density
dens=date_differences;
k=zeros(1,length(dens'));
lowb=min(dens);
uppb=max(dens);
xlin=linspace(lowb,uppb,length(k));
[f_legendre MMd] = LegendreApproximate(dens,xlin,1);
 % save the data, we might need it later for making plots.
%find the VaR
%save legdata xlin f_legendre x fr assets dens;
intSum = 0;
i=2;
while ( intSum <= 1 - cLevel & i < length(f_legendre) -2 )
    intSum = trapsum(f_legendre(1:i),lowb,xlin(i));
    i=i+1;
    if(isnan(intSum) == 1) continue;
    end
end
VaR = abs(xlin(i));
% print backtesting info
[deviation isVaRAcceptedLRuc] =...
    AnalyseVaRExceptions(VaR,assets,cLevel,'LegVaR'); 

