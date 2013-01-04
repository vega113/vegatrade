
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
%   * s_r - vector, contains sorted sharpe_ratio
%   * stock_index - vector, contains original stock indexes before sort by
%       sharpe_ratio
%   * total_pos_rets_ind - vector of indexes of those stocks whose forecasted return is
%        higher than Rf, only these stocks wil be bought
%   
function [num_of_stock_in_portfolio  total_pos_rets_ind] = weightsStrg1(forecast_data, hist_data, today_prices, Rf, TOTAL_CASH_MONEY)
% calculate weights
    forecast_returns = (forecast_data' -today_prices)./forecast_data';
    varHist = var((hist_data-Rf),0,2);
     sharpe_ratio = (forecast_returns-Rf)./sqrt(varHist);
     if length(find(sharpe_ratio>0) ) == 0
        num_of_stock_in_portfolio = zeros(0,1);
        total_pos_rets_ind = zeros(0,1);
        return
    end
     [s_r stock_index] = sort(sharpe_ratio,1,'descend'); % use stock_index in order to recover orifinal stocks order.
     
     total_pos_rets_ind                    = find(forecast_returns > Rf );
     total_pos_rets                               = sum(forecast_returns(total_pos_rets_ind));
     weights                                                  = forecast_returns(total_pos_rets_ind)./total_pos_rets;
     money_per_stock                            = TOTAL_CASH_MONEY * weights;
     
     [total_pos_rets_ind] = protectInCaseLowOnMoney(money_per_stock,today_prices,stock_index,total_pos_rets_ind);
     
      [num_of_stock_in_portfolio new_total_pos_rets_ind] = calcQuantityPerStockInPortfolio(total_pos_rets_ind,today_prices,money_per_stock);
      total_pos_rets_ind = new_total_pos_rets_ind;
  
