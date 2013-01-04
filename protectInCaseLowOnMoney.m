function [money_per_stock] = protectInCaseLowOnMoney(money_per_stock,today_prices,currCashMoney)

if sum(money_per_stock ) < 0.000001
    total_pos_rets_ind = zeros(0,1);
    money_per_stock = zeros(size(money_per_stock));
    return
end
if length(money_per_stock) ~= length(today_prices)
    disp('bad');
end
isAllAvailble   = (money_per_stock > today_prices);
 availStockInd  = find(isAllAvailble==1);
if  length(availStockInd) ==0
        [minPrice minInd]                                             =  min( today_prices) ;
        if( minPrice > currCashMoney)
            disp('Error in protectInCaseLowOnMoney, fix it! minPrice > currCashMoney');
        end
        money_per_stock = fix(currCashMoney/today_prices);
end