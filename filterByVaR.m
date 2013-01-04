function [weightsMinMax] = filterByVaR(hist_data,today_prices,MAX_VALUE_AT_RISK_PERCENT,VaR_CLEVEL,mode,MAX_WEIGHTS,MIN_WEIGHTS)
%first of all check if we are fast trading and fast losing money
MAX_WINDOW_VaR = 45;

%TODO we need multi  dimensional version of LegVaR
    [compNum lenData ]  = size(hist_data);
    MAX_WINDOW_VaR = min(MAX_WINDOW_VaR,lenData);
     VaR1 = zeros(1,compNum);
     VaR = zeros(size(VaR1));
     isVaRAcceptedLRuc = zeros(size(VaR1));
     deviation = zeros(size(VaR1));
     
          %allow short selling
      %allow short selling
     weightsMinMax = ones(size(hist_data,1),2);
     weightsMinMax(:,1) = weightsMinMax(:,1)*MIN_WEIGHTS;
     weightsMinMax(:,2) = weightsMinMax(:,2)*MAX_WEIGHTS;
     
     
   
   for ii =1:compNum
         [VaR1(ii) deviation(ii) isVaRAcceptedLRuc(ii)] = LegVaR(hist_data(ii,lenData+1-MAX_WINDOW_VaR:lenData),VaR_CLEVEL,mode);
    end
  VaR = VaR1';
  
  %now revert hist_data  and compute for selling
  
    revHistData = fliplr(hist_data(:,lenData+1-MAX_WINDOW_VaR:lenData));
    for ii =1:compNum
         [VaRRev1(ii) deviationRev(ii) isVaRAcceptedLRucRev(ii)] = LegVaR(revHistData(ii,:),VaR_CLEVEL,mode);
    end
  VaRRev = VaRRev1';
  
     % now check for each stock if it's VaR greater than 5% of it's value
       % calculate 5%
       maxStocksVaRValue = today_prices*MAX_VALUE_AT_RISK_PERCENT;
       %find indexes of stocks that do not exceed allowed risk
       %filter for positve weights
       isStockUnderVaR = maxStocksVaRValue <= VaR;       
     indStocksFailVaR = find(isStockUnderVaR > 0) ;
   %  weightsMinMax(indStocksFailVaR, 2)    = 0.0001; %do not buy
     
      isStockUnderVaR = maxStocksVaRValue <= VaRRev;       
     indStocksFailVaR = find(isStockUnderVaR > 0) ;
     %weightsMinMax(indStocksFailVaR, 1)    = 0.0001; %do not sell

   
   