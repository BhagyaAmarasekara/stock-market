# quontmod is the data sourcing package
library(quantmod)
start <- as.Date("2016-01-01")
end <- as.Date("2016-10-01")

#APPLES stock data
getSymbols("AAPL", src = "yahoo", from =start, to = end)
class("AAPL")
head(AAPL)
summary(AAPL)
plot(AAPL[,"AAPL.Close"],main ="AAPL")

#other stcok data
getSymbols(c("GOOG","MSFT"),src="yahoo", from = start, to = end)
#combining them into one dataframe
stocks <- as.xts(data.frame(AAPL = AAPL[,"AAPL.Close"], MSFT = MSFT[,"MSFT.Close"],GOOG=GOOG[,"GOOG.Close"]))
head(stocks)

plot(as.zoo(stocks), screens = 1, lty =1:3, xlab = "Date", ylab = "Price")
legend ("right", c("AAPL","MSFT","GOOG"),lty =1:3)
# this provides out of scale visualization, which will give a wrong impression on smoothing out lowest values

library(magrittr)
# so we are looking for the return
stock_return <- apply(stocks, 1, function(x) {x/stocks[1,]}) %>% t %>% as.xts
head(stock_return)
plot(as.zoo(stock_return), screens = 1, lty =1:3, xlab = "Date", ylab = "Returns")
legend ("right", c("AAPL","MSFT","GOOG"),lty =1:3)

stock_change = stocks %>% log %>% diff
plot(as.zoo(stock_change), screens = 1, lty =1:3, xlab = "Date", ylab = "Log return change")
legend ("topright", c("AAPL","MSFT","GOOG"),lty =1:3)

#candle chart
candleChart(AAPL,up.col ="black", dn.col = "red", theme ="white")
addSMA(n= c(20,50,180)) # adding moving average
