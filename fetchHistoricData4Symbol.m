%mm/dd/yy 
function hist_data = fetchHistoricData4Symbol(symbol, fromDate, toDate)

data = fetch(c1, symbol, 'HISTORY', 'Last_Price',... 
'07/15/99', '08/02/99')