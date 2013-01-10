function [riskAdjustedPortWts ] =  AdjustWeightsByVaR(PortWts,indPositiveRetsAboveVaR,hist_data,MAX_WINDOW_VaR,VaR_CLEVEL,...
    mode,MAX_VALUE_AT_RISK_PERCENT)
%--------------------------

MULT_MODIF_VAR_REJECTED_POSITIVE = 1.0;

iii = 1;
[numOfPort lenData] = size(PortWts);
port = max(fix(numOfPort*0.8),1);
riskAdjustedPortWts = PortWts(port,:);


for ii =1:numOfPort
    %let's create synthetic asset
    synthStock1{ii}= PortWts(ii,indPositiveRetsAboveVaR) * hist_data(indPositiveRetsAboveVaR,:);   %TODO maybe need to work with returns?
    % [VaR1(ii) deviation1(ii) isVaRAcceptedLRuc1(ii)] = LegVaR(synthStock1{ii}(lenData+1-MAX_WINDOW_VaR:lenData),VaR_CLEVEL,mode); 
    startIndex = max(1,lenData+1-MAX_WINDOW_VaR);
    [VaR1(ii) deviation1(ii) isVaRAcceptedLRuc1(ii)] = LegVaR(synthStock1{ii}(startIndex:lenData),VaR_CLEVEL,mode);
    if(deviation1(ii)  > 0 && isVaRAcceptedLRuc1(ii) == 0 )
        VaR1(ii) = VaR1(ii) * MULT_MODIF_VAR_REJECTED_POSITIVE;
    end

    maxStocksVaRValue = synthStock1{ii}(end)*MAX_VALUE_AT_RISK_PERCENT;
    sumMaxStocksVaR = maxStocksVaRValue;
    if VaR1(ii) > sumMaxStocksVaR
        break;
    end
    iii = max(1,ii-1);
    VaR = VaR1(iii);
end
deviation = deviation1(iii);
isVaRAcceptedLRuc = isVaRAcceptedLRuc1(iii);
riskAdjustedPortWts = PortWts(iii,:);
synthStock =  synthStock1{iii} ;
VaR = VaR1';