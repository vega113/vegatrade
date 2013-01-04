
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
%   * posDeltaSorted - vector, contains sorted sharpe_ratio
%   * stockIndexSorted - vector, contains original stock indexes before sort by
%   * total_pos_rets_ind - vector of indexes of those stocks whose forecasted return is
%        higher than Rf, only these stocks wil be bought
%   

function [num_of_stock_in_portfolio_simple    total_pos_rets_ind_simple] = simpleStrg(forecast_data,temp_hist_data,today_prices,Rf,TOTAL_CASH_MONEY,cash_history);


delta                                                           = (forecast_data' - today_prices) ./forecast_data';
[total_pos_rets_ind_simple deltaPositive]   = find(delta>0); % filter by positive delta
deltaPositive                                     = delta(total_pos_rets_ind_simple);
deltaPosValNum                                  = length (total_pos_rets_ind_simple);
if deltaPosValNum == 0
    num_of_stock_in_portfolio_simple = zeros(0,1);
    return
end
[ posDeltaSorted   stockIndexSorted]    = sort(deltaPositive,1,'descend');

MAX_MAIN_CNT  = 4 ; 
MAX_MAIN_CNT = min(MAX_MAIN_CNT, deltaPosValNum );  
mainSum              =  sum(posDeltaSorted (1:MAX_MAIN_CNT)) ;
weights              =  posDeltaSorted (1:MAX_MAIN_CNT)/mainSum;   %return to do
money_per_stock  = TOTAL_CASH_MONEY * weights;

 % indexes of stocks  participating in game
 total_pos_rets_ind_simple = total_pos_rets_ind_simple(stockIndexSorted(1:MAX_MAIN_CNT)) ; % filter by value, take up to 4 highest

[money_per_stock] = protectInCaseLowOnMoney(money_per_stock,today_prices(total_pos_rets_ind_simple),TOTAL_CASH_MONEY);
% ------------------- TODO handle the case when there's enough money to buy
% some stock
% posDeltaSorted = posDeltaSorted( stockIndexSorted(availStockInd));
% mainSum              =  sum(posDeltaSorted (1:MAX_MAIN_CNT)) ;
% weights              =  posDeltaSorted (1:MAX_MAIN_CNT)/mainSum;   %return to do
% money_per_stock = TOTAL_CASH_MONEY * weights;
% if sum(money_per_stock>today_prices) >0
  
  [num_of_stock_in_portfolio_simple  new_total_pos_rets_ind] = calcQuantityPerStockInPortfolio(total_pos_rets_ind_simple,today_prices(total_pos_rets_ind_simple),money_per_stock);
  total_pos_rets_ind_simple = new_total_pos_rets_ind;
 


