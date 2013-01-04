
%  input:
%   *forecast_data - vector of forecasted stock prices
%   *hist_data - matrix, each row contains historical data per stock
%   *today_prices - vector, can actually be taken from historical data
%   * Rf -  min forecasted return that should be met in order for the stock
%       to be included in next day portfolio
%   *TOTAL_CASH_MONEY - available cash money to buy stocks
% output:
%   * num_of_stock_in_portfolio - vector. at each index i is the amount of
%       total_pos_rets_ind(i) stocks that we will buy
%   * sortedSharpeRatio - vector, contains sorted sharpeRatio
%   * indStocksOrig - vector, contains original stock indexes before sort by
%       sharpeRatio
%   * total_pos_rets_ind - vector of indexes of those stocks whose forecasted return is
%        higher than Rf, only these stocks wil be bought
%   
function [amountOfStockInPortfolioPerTurn  indPositiveRetsAfterProtectFinal] = strtgyCAPM3(forecast_data, hist_data, today_prices, Rf, TOTAL_CASH_MONEY,cash_history)

%constants
    MAX_VALUE_AT_RISK_PERCENT = 0.05;
    VaR_CLEVEL = 0.7;  
    
    %there's probably some bug which causes to return negative prices
    % let's try to take abs as wrok around
    %- ---------------work around ----------
    forecast_data = abs(forecast_data);
    %---------------
  %-----------------------------------
    [RetSeries] = tick2ret((hist_data)');
     [ExpReturn, ExpCovariance, NumEffObs] = ewstats(RetSeries);
     expForecastRet = (forecast_data' -today_prices)./today_prices;
     [PortRisk, PortReturn, PortWts] = frontcon(expForecastRet',ExpCovariance,10);
     
[VaR deviation isVaRAcceptedLRuc riskAdjustedPortWts] = filterByVaR(hist_data,today_prices,cash_history,PortWts,MAX_VALUE_AT_RISK_PERCENT,VaR_CLEVEL,1);
     
      

     weights                                                  = riskAdjustedPortWts';
     fixedMoneyPerStock = TOTAL_CASH_MONEY *weights;
   % min amount of stocks to buy
   
     [indPositiveRetsAfterProtect moneyPerStockAfterProtect] = protectInCaseLowOnMoney(fixedMoneyPerStock,today_prices,indPositiveRetsAboveVaR,TOTAL_CASH_MONEY);
     
      [amountOfStockInPortfolioPerTurn indPositiveRetsAfterProtectFinal] = calcQuantityPerStockInPortfolio(indPositiveRetsAfterProtect,today_prices,moneyPerStockAfterProtect);
  
