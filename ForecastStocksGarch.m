
function[meanForecast]=ForecastStocksGarch(timeWindow,horizon,prices)
[STOCKS_NUM  TS_LENGTH] = size(prices);
if(timeWindow  > TS_LENGTH)
    disp('should be TS_WINDOW + 1 > TS_LENGTH');
    return;
end


from = TS_LENGTH - timeWindow+1;
to = TS_LENGTH;
cutPrices   = prices(:, from:to);

 [meanForecast]  = GarchMeanForecast(cutPrices,horizon);








