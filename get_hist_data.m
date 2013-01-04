% [symbols hist_data] = get_hist_data()
function [symbols hist_data badSymbols] = get_hist_data(inSymbols)
inSymbols=cellstr(inSymbols);
if ~isempty(inSymbols)
    symbols = inSymbols;
end
%symbols =strvcat ( 'URBN', 'MSFT',  'CELG', 'FLEX', 'EBAY', 'GILD', 'INTU','VRTX','YHOO');
%symbols =strvcat (  'EBAY', 'GILD', 'INTU','VRTX','YHOO');
% Define starting year (the further back in time, the longer it takes to download)
start_year = '2004';
%  'URBN', 'MSFT', 'CELG', 'FLEX', 'EBAY', 'GILD', 'INTU','VRTX','YHOO',
%symbols =strvcat ( 'URBN', 'MSFT',  'CELG', 'FLEX', 'EBAY', 'GILD', 'INTU','VRTX','YHOO','FWLT','GENZ','GRMN','HANS','HSIC','IACI','ILMN','ISRG','JAVA','JOYG','NTAP','ORCL','PPDI','QCOM','RIMM','ROST','RYAAY','SBUX');
%symbols = (
symbols = cellstr(symbols);
sym_len = length(symbols);
newInd = 0;
numOfErrors = 0;
size(symbols)
badSymbols = cell(0,1);
for i=1:sym_len
    isCopy = 0;
    curSymbol = symbols(i)
    try
        [hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol] = get_hist_stock_data(symbols(i), start_year);
        newInd = newInd+1;
        isCopy =1;
    catch ME
        numOfErrors = numOfErrors +1;
        badSymbols(numOfErrors) = curSymbol;
        isCopy = 0;
        cprintf('red',' Error with symbol %s ' , char(curSymbol));
    end

    %     hist_data_cell{i}{1} =hist_date;
    %     hist_data_cell{i}{2} =hist_high;
    %     hist_data_cell{i}{3} = hist_low;
    %     hist_data_cell{i}{4} = hist_open;
    %     hist_data_cell{i}{5} =hist_close;
    %     hist_data_cell{i}{6} = hist_vol;

    if isCopy == 1
    try
         newSymbols{newInd} = symbols{i}; % todo - fix this
        hist_data(newInd,:) = hist_close;
    catch me1
        errLength = size(hist_close);
        disp(['error with ' char(symbols{i}) ' unregular length: ' num2str(errLength) ]);
        newInd=newInd-1;
    end
    end

end
dateStr = DATESTR(NOW);
date =  regexprep(dateStr, ':', '_');
filename = strcat('new_hist_data_',date);
symbols = newSymbols;
save (filename, 'hist_data', 'symbols');
badSymbols