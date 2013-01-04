
function[portfolio_history cash_history outTxt TOTAL_CASH_MONEY ] =handleStratgyTrade (stratgy_name,num_of_stock_in_portfolio,today_prices,total_pos_rets_ind,...
    TOTAL_CASH_MONEY,portfolio_history,cash_history,  symbols, ii, tomorrow_prices)
%sum the total value of stocks
isPrintStocks = true;
if(isempty(total_pos_rets_ind) || isempty(num_of_stock_in_portfolio))
    curr_total_stock_value = 0;
    num_of_stock_in_portfolio  = zeros(0,1);
    total_pos_rets_ind = zeros(1,0);
    isPrintStocks = false;
else
    [k v] = size(num_of_stock_in_portfolio);
    if k > v
        num_of_stock_in_portfolio = num_of_stock_in_portfolio'; % it's stupid but it's because i cant' return zeros(0,1)
        isPrintStocks = false;
        % only zeros(1,0)
    end
    if(size(num_of_stock_in_portfolio,2) == 1 && num_of_stock_in_portfolio(1) == 0)
        curr_total_stock_value = 0;
        isPrintStocks = false;
    else
         curr_total_stock_value = num_of_stock_in_portfolio*(today_prices(total_pos_rets_ind))  ;
    end
end
TOTAL_CASH_MONEY                          = TOTAL_CASH_MONEY - curr_total_stock_value;

% buy stocks with new weights
portfolio_history(ii,total_pos_rets_ind) =num_of_stock_in_portfolio;
sub_total = TOTAL_CASH_MONEY + curr_total_stock_value;
if ii == 1 || sub_total == cash_history(ii-1)
    tradeColor = 'blue';
else
    if(sub_total > cash_history(ii-1))
        tradeColor = 'green';
    end
    if(sub_total < cash_history(ii-1))
        tradeColor = 'red';
    end
end

%out_txt = strcat(out_txt, ': ', char(stratgy_name),  '. cash: ',  num2str(TOTAL_CASH_MONEY),  ', stocks: ', num2str(curr_total_stock_value) , '. total: ',  num2str(sub_total) ,'. ');
outTxt1 = strcat( '#', num2str(ii), ': ', char(stratgy_name),  '. cash: ',  num2str(TOTAL_CASH_MONEY),  ', stocks: ', num2str(curr_total_stock_value) , '. total: ',  num2str(sub_total) ,'. ');
cprintf(tradeColor,outTxt1)
cash_history(ii) = sub_total;

if isPrintStocks
    upDownInd = 'o';
    for jj = 1: length(total_pos_rets_ind)
        action = '+'; % TODO in future need to sell/buy
        if num_of_stock_in_portfolio(jj) < 0
            action = '-';

            tradeColor = 'blue';
            upDownInd='o';
            if tomorrow_prices(total_pos_rets_ind(jj)) < today_prices(total_pos_rets_ind(jj))
                upDownInd='v';
                tradeColor = 'green';
            end
            if  tomorrow_prices(total_pos_rets_ind(jj)) > today_prices(total_pos_rets_ind(jj))
                upDownInd='^';
                tradeColor = 'red';
            end
        else

            tradeColor = 'blue';
            upDownInd='o';
            if tomorrow_prices(total_pos_rets_ind(jj)) < today_prices(total_pos_rets_ind(jj))
                upDownInd='v';
                tradeColor = 'red';
            end
            if  tomorrow_prices(total_pos_rets_ind(jj)) > today_prices(total_pos_rets_ind(jj))
                upDownInd='^';
                tradeColor = 'green';
            end
        end
       
        outTxt2 = strcat( '<',action,',', upDownInd, ',', num2str(today_prices(total_pos_rets_ind(jj))),',',num2str(tomorrow_prices(total_pos_rets_ind(jj))), ',',  num2str(num_of_stock_in_portfolio(jj)) , ',',  symbols(total_pos_rets_ind(jj),: ),  '> ' );
       if(mod(jj,5) == -1)
            cprintf(tradeColor,outTxt2);
       end
        outTxt = strcat(outTxt1,outTxt2);

    end
end
if ~exist('outTxt','var') || isempty(outTxt)
    outTxt='no game - weights are empty';
end
    disp(' ');