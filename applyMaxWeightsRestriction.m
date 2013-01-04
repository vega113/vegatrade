%let us restrict max weights on single stock, we don't want to put too much
%eggs in same basket.
function   [fixedWeights fixedMoneyPerStock] = applyMaxWeightsRestriction(weights,todayPrices,TOTAL_CASH_MONEY,MAX_WEIGHT_PER_STOCK)
if isempty(weights)
    fixedWeights = weights;
    fixedMoneyPerStock = zeros(0,1);
    return
end

totalOverMoney = 0;
for ii = 1:length(weights)
    currentWeight = weights(ii);
    if currentWeight < MAX_WEIGHT_PER_STOCK && totalOverMoney < todayPrices(ii)
        continue
    end
    if(currentWeight > MAX_WEIGHT_PER_STOCK)
        diffWeight = currentWeight - MAX_WEIGHT_PER_STOCK;
         currentWeight = MAX_WEIGHT_PER_STOCK;
         totalOverMoney = TOTAL_CASH_MONEY*diffWeight; % we can redistribute this money to other stocks
    end
    if currentWeight < MAX_WEIGHT_PER_STOCK ...
            && fix((currentWeight* TOTAL_CASH_MONEY)/ todayPrices(ii)) <   ...
            fix((currentWeight* TOTAL_CASH_MONEY + totalOverMoney)/ todayPrices(ii))  % we can buy some more of this
        addStocks = fix((currentWeight* TOTAL_CASH_MONEY + totalOverMoney)/ todayPrices(ii)) - ...
            fix((currentWeight* TOTAL_CASH_MONEY)/ todayPrices(ii)) ;
        addMoney = addStocks * todayPrices(ii);
        addWeight = min(addMoney/TOTAL_CASH_MONEY,MAX_WEIGHT_PER_STOCK - currentWeight);
        currentWeight = addWeight + currentWeight;
        totalOverMoney = totalOverMoney - addWeight*TOTAL_CASH_MONEY;
    end
    weights(ii) = currentWeight;    
end
fixedWeights = weights;
fixedMoneyPerStock = TOTAL_CASH_MONEY*weights;