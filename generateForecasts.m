
function [forecastHist] = generateForecasts(MAX_RUN_DAYS,WINDOW_SIZE,START_INDEX,load_hist_data)
sprintf('Starting with firecast generation');
[COMP_NUM TS_LEN ] = size(load_hist_data);
forecastHist = zeros(COMP_NUM,MAX_RUN_DAYS);
sim_start_index = START_INDEX+1;
sim_end_index       = MAX_RUN_DAYS + WINDOW_SIZE+START_INDEX;

% cut time seroes data, create sim data to work with
sim_hist_data = load_hist_data(:,sim_start_index:sim_end_index);
tic
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
%       [forecast_data]       = ForecastStocks(WINDOW_SIZE, 1, currentWindowData);
        [forecast_data]       = ForecastStocksGarch(WINDOW_SIZE, 1, currentWindowData);
        forecastHist(:,ii)    = forecast_data';
        elapsedTime = toc;
         timePerDay = elapsedTime/ii;
        if ii == 1
            %make some statistics
            sprintf('time per 1 day is %4.2f\n',timePerDay)
             daysLeft = MAX_RUN_DAYS -ii;
            sprintf('remaining time : %4.2f\n', daysLeft*timePerDay)
        end
       cprintf('blue','%s','*')
    if mod(ii,40) == 0
        sprintf('\n')
    end
end