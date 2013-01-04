
function [meanForecastRet]  = GarchMeanForecast(meanForecastPrices,horizon)
% 1) Estimating the Model
%Load the prices data set and convert daily closing prices to daily
%returns:
 load garchdata;
 prices = NASDAQ';
 horizon = 1;  % Define the forecast horizon
 
%Create a specification structure for an ARMA(1,1)/GJR(1,1) model with
%conditionally t-distributed residuals:
spec = garchset('VarianceModel','GJR',...
                'R',1,'M',1,'P',1,'Q',1);
spec = garchset(spec,'Display','off','Distribution','T');
%Estimate the parameters of the mean and conditional variance models via
%garchfit. 

[k v] = size(prices);

 rets = price2ret(prices');
 meanForecastRet =zeros(1,k);
 meanForecastPrices = zeros(1,k);
 for ii = 1:k

     [coeff,errors,LLF,eFit,sFit] = garchfit(spec,rets(:,ii));

     %to display estimation results
     %garchdisp(coeff,errors)

     % 2) Forecasting
    
     try
         [sigmaForecast,meanForecastRet(ii),sigmaTotal,meanRMSE] = ...
             garchpred(coeff,rets(:,ii),horizon);
     catch me
         meanForecastRet(ii) = 0;
         ii
     end
      meanForecastPrices(ii) =prices(ii,end)+  meanForecastRet(ii)*prices(ii,end);
 end
 
 % reconstruct price from mean ret
  return
  
% 3) Forecasting Using Monte Carlo Simulation
%Simulate 20000 paths (columns):
nPaths = 20000;  % Define the number of realizations.
randn('state',0);
rand('twister',0); 
[eSim,sSim,ySim] = garchsim(coeff,horizon,nPaths, ...
   [],[],[], eFit(end),sFit(end),prices(end));

% 4) Comparing Forecasts with Simulation Results
%Compare the first garchpred output, sigmaForecast (the conditional
%standard deviations of future innovations), with its counterpart derived from the Monte Carlo simulation:
figure
plot(sigmaForecast,'.-b')
hold('on')
grid('on')
plot(sqrt(mean(sSim.^2,2)),'.r')
title('Forecast of STD of Residuals')
legend('forecast results','simulation results')
xlabel('Forecast Period')
ylabel('Standard Deviation')

%Compare the second garchpred output, meanForecastRet(the MMSE forecasts of
%the conditional mean of the prices return series), with its counterpart derived from the Monte Carlo simulation:
figure(2)
plot(meanForecastRet,'.-b')
hold('on')
grid('on')
plot(mean(ySim,2),'.r')
title('Forecast of Returns')
legend('forecast results','simulation results',4)
xlabel('Forecast Period')
ylabel('Return')

%Compare the third garchpred output, sigmaTotal, that is, cumulative
%holding period returns, with its counterpart derived from the Monte Carlo simulation:
holdingPeriodReturns = log(ret2price(ySim,1)); 
figure(3)
plot(sigmaTotal,'.-b')
hold('on') 
grid('on')
plot(std(holdingPeriodReturns(2:end,:)'),'.r')
title('Forecast of STD of Cumulative Holding Period Returns')
legend('forecast results','simulation results',4)
xlabel('Forecast Period')
ylabel('Standard Deviation')

%Compare the fourth garchpred output, meanRMSE, that is the root mean
%square errors (RMSE) of the forecasted returns, with its counterpart derived from the Monte Carlo simulation:

figure(4)
plot(meanRMSE,'.-b')
hold('on')
grid('on')
plot(std(ySim'),'.r')
title('Standard Error of Forecast of Returns')
legend('forecast results','simulation results')
xlabel('Forecast Period')
ylabel('Standard Deviation')

%Use a histogram to illustrate the distribution of the cumulative holding
%period return obtained if an asset was held for the full 30-day forecast horizon.
figure(5)
hist(holdingPeriodReturns(end,:),30)
grid('on')
title('Cumulative Holding Period Returns at Forecast Horizon')
xlabel('Return')
ylabel('Count')

%Use a histogram to illustrate the distribution of the single-period return
%at the forecast horizon, that is, the return of the same mutual fund, the 30th day from now. This histogram is directly related to the final red dots in steps 2 and 4:
figure(6)
hist(ySim(end,:),30)
grid('on')
title('Simulated Returns at Forecast Horizon')
xlabel('Return')
ylabel('Count')

