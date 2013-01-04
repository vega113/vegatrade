
function[Hiz]=ForecastStocks(TS_WINDOW,TA,B )
Gvul = 7;
%! 11/11/2009
[STOCKS_NUM  TS_LENGTH] = size(B);
if(TS_WINDOW  > TS_LENGTH)
    disp('should be TS_WINDOW + 1 > TS_LENGTH');
    return;
end

lowb = TS_LENGTH - TS_WINDOW+1;
uppb = TS_LENGTH;
BI   = B(:, lowb:uppb);
%--------------------------------------------------------------------------
stocksTrend = zeros(STOCKS_NUM, TS_WINDOW);
for ind_stock = 1:STOCKS_NUM
    stocksTrend(ind_stock,:) = Ratapp(BI(ind_stock,:));         
end %for ind_stock
NOISE_STOCK = BI - stocksTrend;  % centered traectories!!
%--------------------------------------------------------------------------


CovSize = min(STOCKS_NUM, TS_LENGTH ); % !!! important

KOV     = zeros(CovSize,CovSize);

NOISE_STOCK = NOISE_STOCK(1:CovSize,:); %cut (if need) by min dimension

for ii = 1:CovSize %STOCKS_NUM
    iTime  = NOISE_STOCK(:,ii);
    for jj = ii:CovSize %STOCKS_NUM       
        jTime  = NOISE_STOCK(:,jj);  % Array;
        KOV(ii, jj) = xcorr(iTime, jTime, 0,'unbiased');
        KOV(jj, ii) =  KOV(ii, jj);
    end % for jj
end % for ii
%--------------------------------------------------------------------------
try
[UU VV] = eig(KOV); %  
UU      = real(UU); % eigen vectors 
VV      = real(VV); % eigen values

%sob  = STOCKS_NUM;                    % TODO handle this constant, should be calculated - min number of main components
%Gvul = max(round(STOCKS_NUM/10),sob); % EG;
%Gvul = min(Gvul,STOCKS_NUM);          % In such a case;
%--------------------------------------------------------------------------
%EgU = UU(:,STOCKS_NUM-Gvul+1:STOCKS_NUM);
%EgU = UU;  mainCompCnt = STOCKS_NUM;
%EgU = UU(:, eigInd(1:mainCompCnt) );          % the best mainCompCnt eig vectors
%EgU = UU(:, STOCKS_NUM-mainCompCnt+1 : end  ); % the last  mainCompCnt eig vectors
for ii=1:Gvul
    EgU(:,ii) = UU(:,min(CovSize,STOCKS_NUM - ii+1));
end
%--------------------------------------------------------------------------

ETA = EgU'*BI(1:CovSize,:);

deltas = zeros(STOCKS_NUM,TA);
for indStock = 1: Gvul %mainCompCnt %STOCKS_NUM    
        xa = ETA(indStock, :);    
       %[ xtau(indStock,:), deltas(indStock,:) ] = Mododpred(xa, 4, TA); % The main component prediction;
       [ xtau1(indStock), deltas1(indStock,:) ] = odpred(xa, 4, TA); % The main component prediction;
        
end % 
Hiz = xtau1*EgU'; % correct 
% Hiz = abs(Hiz);
catch me
    disp('catched exception in Forecast stocks!');
    Hiz = 0;
end








