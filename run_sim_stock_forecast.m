
% runs the simulation
%input
%   -START_CAPITAL: starting cash, can be used to buy stocks
%   -MAX_RUN_DAYS: number of simulation days to run the simulation
%   -WINDOW_SIZE: the length of sliding window of history data that will be used to
%       calculate forecasts
%   -START_INDEX: the index in history_data from which we start the
%       simulation, it allows to start the simulation from some arbitary
%       index.
%   -symbols: the symbols of stocks, they are used in plot legend
%   -load_hist_data: the historical data to run simulations on it.
%   -stratgs_handles: vector that contains handles to functions of trade
%       strategies.
%output
%   -cash_history: cell array of cash history per strategy per day.
%   -portfolio_history: cell array of number of stocks held at each day per
%       strategy per day
function [ cash_history portfolio_history currStrtgRetSeries RetSeriesStocks meanRetSeries] =...
    run_sim_stock_forecast(START_CAPITAL,MAX_RUN_DAYS,WINDOW_SIZE, START_INDEX, Rf,symbols, load_hist_data, stratgs_handles, isShowPlot,forecastHist)

symbols = char(symbols);
[COMP_NUM TS_LEN ] = size(load_hist_data);

%protection
if MAX_RUN_DAYS + WINDOW_SIZE + START_INDEX > TS_LEN
    disp('error!!! should be : MAX_RUN_DAYS + WINDOW_SIZE + START_INDEX <= TS_LEN')
    cash_history      = [];
    portfolio_history = [];
    return
end

stratgs_num = length(stratgs_handles);

% preallocate
portfolio_history = cell(1,stratgs_num);
cash_history                = cell(1,stratgs_num);
TOTAL_CASH_MONEY      = cell(1,stratgs_num);
%------init
for hh = 1 : stratgs_num
    portfolio_history{hh} = zeros(MAX_RUN_DAYS,COMP_NUM); % size = stratgs_num x MAX_RUN_DAYS * COMP_NUM; contains number of stocks held during specific day
    cash_history{hh}               = zeros(1,MAX_RUN_DAYS); % cash history per each strategy
    TOTAL_CASH_MONEY{hh}     = START_CAPITAL; % current cash money per strategy
end

sim_start_index = START_INDEX+1;
sim_end_index       = MAX_RUN_DAYS + WINDOW_SIZE+START_INDEX;

% cut time seroes data, create sim data to work with
sim_hist_data = load_hist_data(:,sim_start_index:sim_end_index);

% the main loop - for each simulation day

tresholdToCalcVar = 5;
varWinSizeMax     = 20;
txtHeader = '**********************  format <[+-  mean buy/sell],[up/down sign],[today price],[tomorrow price], [num of stock for action],[symbol]>**************************';
for ii=1:MAX_RUN_DAYS
    % current day for simulation
    sim_today = WINDOW_SIZE+ii - 1;
    today_prices          = sim_hist_data(:,sim_today);
    if ii<MAX_RUN_DAYS
        tomorrow_prices =  sim_hist_data(:,sim_today+1);
    else
        tomorrow_prices = today_prices;
    end
    currentWindowData       = sim_hist_data(:,ii:sim_today);
    forecast_data = forecastHist(:,ii)'  ;
        sprintf(txtHeader);
    % for each strategy :
    for ss = 1:stratgs_num
        if ii > 1
            % sell stocks and calculate current balance
            TOTAL_CASH_MONEY{ss} = TOTAL_CASH_MONEY{ss} + portfolio_history{ss}(ii-1,:) * today_prices;
            if TOTAL_CASH_MONEY{ss}< min(today_prices)
                out = strcat(  ' strategy ',  char(stratgs_handles{ss}),  ' is a loser, not enough money to play!!! '    );
                continue
            end
        end
        total_pos_rets_ind = zeros(0,1);
        cur_strtgy = stratgs_handles{ss};
        [num_of_stock_in_portfolio    total_pos_rets_ind ] = cur_strtgy(forecast_data,currentWindowData,today_prices,Rf,TOTAL_CASH_MONEY{ss},cash_history{ss});
        
        [ portfolio_history{ss} cash_history{ss} out_txt{ii}{ss} TOTAL_CASH_MONEY{ss} ] =handleStratgyTrade (stratgs_handles{ss}, num_of_stock_in_portfolio, today_prices, total_pos_rets_ind, ...
            TOTAL_CASH_MONEY{ss} , portfolio_history{ss}, cash_history{ss}, symbols, ii,tomorrow_prices );
        
    end
    
    if mod(ii,100) == 0
        strd = datestr(now);
        strtmp = strcat('time is ', strd, ' count is: ', num2str(ii));
        out_txt{ii}{ss+1} = strtmp;
        sendGMail([],out_txt{ii});
    end
end

[currStrtgRetSeries RetSeriesStocks meanRetSeries] =...
    plotSimulationData(MAX_RUN_DAYS,START_CAPITAL,WINDOW_SIZE, stratgs_handles, symbols, cash_history, sim_hist_data,isShowPlot);





