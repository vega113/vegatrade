
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
function [amountOfStockInPortfolioPerTurn  indPositiveRetsAfterProtectFinal indPositiveRetsAboveVaR] = strtgyCAPMRA2(forecast_data, hist_data, today_prices, Rf, TOTAL_CASH_MONEY,cash_history,weightsMinMax)

%constants
       MAX_VALUE_AT_RISK_PERCENT = 0.013;
    VaR_CLEVEL = 0.85;  
    MAX_WINDOW_VaR = 45;
    MAX_NUM_PORT = 5;
    MAX_WEIGHTS = 0.3;
    MIN_WEIGHTS = -0.7;
    
    
    %there's probably some bug which causes to return negative prices
    %- ---------------work around ----------
    [k v] = size(forecast_data);
for hj = 1: k
    for hkj = 1:v
        if forecast_data(hj,hkj) < 0.001
            forecast_data(hj,hkj) = 0.001;
        end
    end
end
    %---------------

     
       %-----------------------------------
   [RetSeries] = tick2ret((hist_data)');
     [ExpReturn, ExpCovariance, NumEffObs] = ewstats(RetSeries);
     expForecastRet = (forecast_data' -today_prices)./today_prices;

%  maxForecast = max(abs(forecast_data));
%      expForecastRet = forecast_data/maxForecast;
 
         [weightsMinMax] = filterByVaR(hist_data,today_prices,MAX_VALUE_AT_RISK_PERCENT,VaR_CLEVEL,1,MAX_WEIGHTS,MIN_WEIGHTS); 
     [PortRisk, PortReturn, PortWts] = frontcon((expForecastRet)',ExpCovariance,MAX_NUM_PORT,[],weightsMinMax',[],[],'algorithm', 'quadprog');

    
   indPositiveRetsAboveVaR = 1:size(hist_data,1);
   [riskAdjustedPortWts ] =  AdjustWeightsByVaR(PortWts,indPositiveRetsAboveVaR,hist_data,MAX_WINDOW_VaR,VaR_CLEVEL,...
    1,MAX_VALUE_AT_RISK_PERCENT);
 [outPortWts ] = avoidFastDownMarket(TOTAL_CASH_MONEY,cash_history,riskAdjustedPortWts,hist_data,indPositiveRetsAboveVaR);
     weights                                                  = outPortWts';
     fixedMoneyPerStock = TOTAL_CASH_MONEY *weights;
   % min amount of stocks to buy
     [ moneyPerStockAfterProtect] = ...
         protectInCaseLowOnMoney(fixedMoneyPerStock(indPositiveRetsAboveVaR),today_prices(indPositiveRetsAboveVaR),TOTAL_CASH_MONEY);
     
      [amountOfStockInPortfolioPerTurn indPositiveRetsAfterProtectFinal] = ...
          calcQuantityPerStockInPortfolio(indPositiveRetsAboveVaR,today_prices(indPositiveRetsAboveVaR),moneyPerStockAfterProtect);
  
