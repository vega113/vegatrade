% Script to Retrieve Historical Stock Data from Google Finance
% LuminousLogic.com

function [hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol] = get_hist_google_stock_data(stock_symbol,start_year)

% Get current date
[this_year, this_month, this_day, dummy, dummy] = datevec(date);


% Build URL string
%url_string = 'http://www.google.com/finance/historical?q=';
%url_string = strcat(url_string, upper(stock_symbol), 'a=10&b=15&c=2005&d=01&e=17&f=2006&g=d&output=csv');

url_string = 'http://ichart.finance.yahoo.com/table.csv?';
url_string = strcat(url_string, '&s=', upper(stock_symbol)   );
url_string = strcat(url_string, '&d=', num2str(this_month-1) );
url_string = strcat(url_string, '&e=', num2str(this_day)     );
url_string = strcat(url_string, '&f=', num2str(this_year)    );
url_string = strcat(url_string, '&g=d&a=0&b=1&c=', start_year);
url_string = strcat(url_string, '&ignore.csv');

% Open a connection to the URL and retrieve data into a buffer
buffer      = java.io.BufferedReader(...
              java.io.InputStreamReader(...
              openStream(...
              java.net.URL(url_string))));


% Read the first line (a header) and discard
dummy   = readLine(buffer);


% Read all remaining lines in buffer
ptr = 1;
while 1
    % Read line
    buff_line = char(readLine(buffer)); 
    
    % Break if this is the end
    if length(buff_line)<3, break; end
    
    % Find comma delimiter locations
    commas    = find(buff_line== ',');
    
    % Extract high, low, open, close, etc. from string
    DATEtemp{ptr,1} = buff_line(1:commas(1)-1);
    OPENtemp(ptr,1)   = str2num( buff_line(commas(1)+1:commas(2)-1) );
    HIGHtemp(ptr,1)   = str2num( buff_line(commas(2)+1:commas(3)-1) );
    LOWtemp (ptr,1)    = str2num( buff_line(commas(3)+1:commas(4)-1) );
    CLOSEtemp(ptr,1)  = str2num( buff_line(commas(4)+1:commas(5)-1) );
    VOLtemp(ptr,1)    = str2num( buff_line(commas(5)+1:end) );
    
    ptr = ptr + 1;
end

% Reverse to normal chronological order, so 1st entry is oldest data point
hist_date  = flipud(DATEtemp);
hist_open  = flipud(OPENtemp);
hist_high  = flipud(HIGHtemp);
hist_low   = flipud(LOWtemp);
hist_close = flipud(CLOSEtemp);
hist_vol   = flipud(VOLtemp);