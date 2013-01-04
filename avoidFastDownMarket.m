function [PortWts ] = avoidFastDownMarket(TOTAL_CASH_MONEY,cash_history,inPortWts,hist_data,indPositiveRetsAboveVaR)

len = (max(find(cash_history > 0) ) < 5);
if ~(length(cash_history) > 2) ||  length(len) == 0
    PortWts = inPortWts;
    return
end
MAX_ONE_DAY_LOSS = 0.05;
MAX_TWO_DAY_LOSS = 0.07;
MAX_THREE_DAY_LOSS = 0.09;
MIN_RSI_LEVEL = 30;
RSI_WINDOW_LENGTH = 14;

firstZero = find(cash_history == 0);
if ~isempty(firstZero) 
    if firstZero(1)-1 >0 
     oneDayDiffRet = (TOTAL_CASH_MONEY - cash_history(firstZero(1)-1) )/cash_history(firstZero(1)-1);
    end
    if firstZero(1)-2 >0 
        twoDayDiffRet = (TOTAL_CASH_MONEY - cash_history(firstZero(1)-2) )/cash_history(firstZero(1)-2);
    end
    if firstZero(1)-3 >0 
        threeDayDiffRet = (TOTAL_CASH_MONEY) - cash_history(firstZero(1)-3) /cash_history(firstZero(1)-3);
    end
end
  
%   
% synthStock= inPortWts(indPositiveRetsAboveVaR) * hist_data(indPositiveRetsAboveVaR,:);
%     stockLength = length(synthStock);
%     actualRSIWindow = min(RSI_WINDOW_LENGTH,stockLength-1);
%    rsiIndValueTemp = rsindex(  (synthStock(  stockLength - actualRSIWindow:end )') ,actualRSIWindow  ) ;   
%    rsiIndValue  =rsiIndValueTemp(end);
%    if rsiIndValue < MIN_RSI_LEVEL % don't trade
%      PortWts = zeros(size(inPortWts));
%      return;
%    end
       % calculate 
       
      
       %find indexes of stocks that do not exceed allowed risk
      
       if  exist('oneDayDiffRet','var')  && (oneDayDiffRet < -1*MAX_ONE_DAY_LOSS )
          PortWts = zeros(size(inPortWts));
          return;
       end
       if exist('twoDayDiffRet','var')  &&(twoDayDiffRet < -1*MAX_TWO_DAY_LOSS )
          PortWts = zeros(size(inPortWts));
          return;
       end
      if  exist('threeDayDiffRet','var') && (threeDayDiffRet < -1*MAX_THREE_DAY_LOSS)
          PortWts = zeros(size(inPortWts));
          return;
      end
      PortWts = inPortWts;
