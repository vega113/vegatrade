
%Analysis and Estimation Using the Default Model
%Pre-Estimation Analysis

%1. Load the MATLAB® binary file garchdata.mat
load garchdata

%Converting the Prices to a Return Series
dem2gbp = price2ret(DEM2GBP);

%Now, use the plot function to see the return series:
plot(dem2gbp)
set(gca,'XTick',[1 659 1318 1975])
set(gca,'XTickLabel',{'Jan 1984' 'Jan 1986' 'Jan 1988' ...
    'Jan 1992'})
ylabel('Return')
title('Deutschmark/British Pound Daily Returns')

%Checking for Correlation in the Return Series
autocorr(dem2gbp)
title('ACF with Bounds for Raw Return Series')
parcorr(dem2gbp)
title('PACF with Bounds for Raw Return Series')

%Checking for Correlation in the Squared Returns
autocorr(dem2gbp.^2)
title('ACF of the Squared Returns')

%Use lbqtest to verify (approximately) that no significant correlation is
%present in the raw returns when tested for up to 10, 15, and 20 lags of the ACF at the 0.05 level of significance:
[H,pValue,Stat,CriticalValue] = ...
      lbqtest(dem2gbp-mean(dem2gbp),[10 15 20]',0.05);
[H  pValue  Stat  CriticalValue]

%serial correlation in the squared returns when you test them with the same
%inputs:

[H,pValue,Stat,CriticalValue] = ...
      lbqtest((dem2gbp-mean(dem2gbp)).^2,[10 15 20]',0.05);
[H  pValue  Stat  CriticalValue]

%Perform Engle's ARCH test using the function archtest:
[H,pValue,Stat,CriticalValue] = ...
      archtest(dem2gbp-mean(dem2gbp),[10 15 20]',0.05);
[H  pValue  Stat  CriticalValue]

%Parameter Estimation
%se the estimation function garchfit to estimate the model parameters.
%Assume the default GARCH model described in The Default Model. 

[coeff,errors,LLF,innovations,sigmas,summary] = ...
   garchfit(dem2gbp);

%display the parameter estimates and their standard errors using the
%garchdisp function:
garchdisp(coeff,errors)

%Use the garchplot function to inspect the relationship between the
%innovations (residuals) derived from the fitted model, the corresponding conditional standard deviations, and the observed returns.

garchplot(innovations,sigmas,dem2gbp)

%Plot the standardized innovations (the innovations divided by their
%conditional standard deviation):
plot(innovations./sigmas)
ylabel('Innovation')
title('Standardized Innovations')

%Plot the ACF of the squared standardized innovations:
autocorr((innovations./sigmas).^2)
title('ACF of the Squared Standardized Innovations')

%Compare the results of the Q-test and the ARCH test with the results of
%these same tests in Pre-Estimation Analysis:
[H, pValue,Stat,CriticalValue] = ...
    lbqtest((innovations./sigmas).^2,[10 15 20]',0.05);
[H  pValue  Stat  CriticalValue]


[H, pValue, Stat, CriticalValue] = ...
    archtest(innovations./sigmas,[10 15 20]',0.05);
[H  pValue  Stat  CriticalValue]




