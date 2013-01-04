function [num_of_stock_in_portfolio new_total_pos_rets_ind] = calcQuantityPerStockInPortfolio(total_pos_rets_ind,today_prices,money_per_stock)

if sum(money_per_stock)  < 0.00001
     [k v] = size(total_pos_rets_ind);
    num_of_stock_in_portfolio = zeros(size(total_pos_rets_ind));
    new_total_pos_rets_ind = total_pos_rets_ind;
    return
end
ii = 1;

for gg = 1: length(total_pos_rets_ind)
    curr_per_stock_price = today_prices(gg);
    if (abs (money_per_stock(gg))  < curr_per_stock_price)
        continue;
    end
 
    new_total_pos_rets_ind(ii) = total_pos_rets_ind(gg);
    num_of_stock_in_portfolio(ii) =fix( money_per_stock(gg)/curr_per_stock_price);
    ii= ii +1;
end
