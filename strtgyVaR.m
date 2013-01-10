
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
function [amountOfStockInPortfolioPerTurn  indPositiveRetsAfterProtectFinal] = strtgyVaR(forecast_data, hist_data, today_prices, Rf, TOTAL_CASH_MONEY, cash_history)

%constants
    MAX_VALUE_AT_RISK_PERCENT = 0.05;
    MIN_SHARP_RATIO = 0.03;
    MIN_STOCKS_BUY = 1;
    VaR_CLEVEL = 0.85;  
    MAX_WEIGHT_PER_STOCK = 0.08;
    
% calculate weights
  tickRets = tick2ret(hist_data');
     sharpeRatio = (sharpe(tickRets,Rf))';
    
    indPositiveRets = find(forecast_data > 0.101)';
    %forecast_returns = (forecast_data(indPositiveRets)' -today_prices(indPositiveRets))./forecast_data(indPositiveRets)';
    


     VaR = zeros(size(indPositiveRets));
     isVaRAcceptedLRuc = zeros(size(indPositiveRets));
    for ii =1:length(indPositiveRets)
         [VaR(ii) deviation isVaRAcceptedLRuc(ii)] = LegVaR(hist_data(indPositiveRets(ii),:),VaR_CLEVEL,1);
         if isVaRAcceptedLRuc(ii) == 0
             VaR(ii) = 100000000000000;
         end
    end
    %varHist = var((hist_data(indPositiveRets,:)-Rf),0,2);
    %-------------- Sharpe ----------------------------
     %sharpeRatio = (forecast_returns(end) - -Rf)./sqrt(varHist);
     %--------------------------------------------------------------------
     
   
     
     
     % now check for each stock if it's VaR greater than 5% of it's value
       % calculate 5%
       maxStocksVaRValue = today_prices(indPositiveRets)*MAX_VALUE_AT_RISK_PERCENT;
       %find indexes of stocks that do not exceed allowed risk
       isStockUnderVaR = maxStocksVaRValue > VaR;
       
     indStocksPassVaR = find(isStockUnderVaR > 0) ;
     indPositiveRetsAboveVaR                   = indPositiveRets(indStocksPassVaR); %filter by VaR
     sharpeRatio = sharpeRatio(indStocksPassVaR);
     indSharpeAboveMin = find(sharpeRatio> MIN_SHARP_RATIO);
     indPositiveRetsAboveVaRHighSharpe                    = indPositiveRetsAboveVaR(indSharpeAboveMin);  %filter by sharpe
     sharpeRatioFiltered = sharpeRatio(indSharpeAboveMin); %remove data with low sharpe ratio
     totalSharpeForPassedCriteriaStocks                               = sum(sharpeRatioFiltered); 
     %check that each money per stock is greater than stock's today price
     %so we use all of the cash
     %indPositiveRets = indPositiveRets(indStocksOrig );
     %MIN_STOCKS_BUY
     indPositiveRetsAboveVaRHighSharpeReduced = indPositiveRetsAboveVaRHighSharpe;
     sharpeRatioFilteredReduced = sharpeRatioFiltered;
     moneyPerStock=zeros(size(sharpeRatioFilteredReduced));
     weights = zeros(0,1);
    while 1 && totalSharpeForPassedCriteriaStocks > 0.0001
        totalSharpeForPassedCriteriaStocks                               = sum(sharpeRatioFiltered);    
        weights                                                 =  sharpeRatioFilteredReduced./totalSharpeForPassedCriteriaStocks;
        moneyPerStock                            = TOTAL_CASH_MONEY * weights;
        % now find all those stocks that can be bought for the alocated
        % money for this stock
        relevantTodayPrices = today_prices(indPositiveRetsAboveVaRHighSharpeReduced);
        indStocksAbove = find(moneyPerStock > relevantTodayPrices*MIN_STOCKS_BUY); %find such money to stock allocations, 
                                                                                                                                                                                                       %where we can buy less than MIN_STOCKS_BUY stock units
        if length(indPositiveRetsAboveVaRHighSharpeReduced) == length( indStocksAbove)
            break;
        end
           sharpeRatioFilteredReduced = sharpeRatioFilteredReduced(indStocksAbove);
           indPositiveRetsAboveVaRHighSharpeReduced = indPositiveRetsAboveVaRHighSharpeReduced(indStocksAbove);
           moneyPerStock = zeros(size(indStocksAbove));
    end
   % min amount of stocks to buy

    
    [fixedWeights fixedMoneyPerStock] = applyMaxWeightsRestriction(weights,today_prices,TOTAL_CASH_MONEY,MAX_WEIGHT_PER_STOCK);
     [indPositiveRetsAfterProtect moneyPerStockAfterProtect] = protectInCaseLowOnMoney(fixedMoneyPerStock,today_prices,indPositiveRetsAboveVaRHighSharpeReduced,TOTAL_CASH_MONEY);
     
      [amountOfStockInPortfolioPerTurn indPositiveRetsAfterProtectFinal] = calcQuantityPerStockInPortfolio(indPositiveRetsAfterProtect,today_prices,moneyPerStockAfterProtect);
      
    if sum(amountOfStockInPortfolioPerTurn) < MIN_STOCKS_BUY
        indPositiveRetsAboveVaRHighSharpeReduced = zeros(0,1);
        money_per_stock = zeros(0,1);
        weights = zeros(0,1);
    end
  
