# reproduced code from https://ntguardian.wordpress.com/2017/04/03/introduction-stock-market-data-r-2/
# quontmod is the data sourcing package
library(quantmod)
start <- as.Date("2010-01-01")
end <- as.Date("2016-10-01")
getSymbols("AAPL",src="yahoo",from=start, to=end)
class(AAPL)
head(AAPL)
summary(AAPL)
candleChart(AAPL,up.col="black",dn.col="red", theme = "white",subset ="2016-01-04/")
AAPL_sma_20 <- SMA(Cl(AAPL), n = 20) # Cl(AAPL) = Closing price of apple, obtained through Quantmod simple moving average
AAPL_sms_50 <- SMA(Cl(AAPL), n  =50)
AAPL_sms_200 <- SMA(Cl(AAPL), n  =200)
zoomChart("2016")
addTA(AAPL_sma_20, on = 1, col = "red") # on =1 plots SMA with dates
addTA(AAPL_sms_50, on = 1, col = "blue")
addTA(AAPL_sms_200, on = 1, col = "green")

AAPL_trade <- AAPL
AAPL_trade$'20d' <- AAPL_sma_20
AAPL_trade$'50d' <- AAPL_sms_50
AAPL_trade$'200d' <- AAPL_sms_200
library(quantstrat) # this package cannot be installed! :(
#regime_val <- sigComparison("",data = AAPL_trade, columns = c("20d","50d"), relationship = "gt")-
 # sigComparison("",data = AAPL_trade, columns = c("20d","50d"), relationship = "lt")
regime_val <- ifelse(AAPL_trade[,8]>AAPL_trade[,7],-1,1)
plot(regime_val["2016"],main="Regime",ylim=c(-2,2))

#plotting along the main window
candleChart(AAPL,up.col="black",dn.col="red", theme = "white",subset ="2016-01-04/")
addTA(regime_val,col="blue",yrange=c(-2,2))
addSMA(n=c(20,50),on= 1, col=c("red","blue"))
addLines(h=0,col="black",on=3)
table(as.vector(regime_val))
sig <- diff(regime_val)/2
plot(sig,main="Signal",ylim=c(-2,2))
table(sig)
#quantomod function is for financial data analyisis, Cl function calls up the closing value
#Buy prices
Cl(AAPL)[which(sig==1)]
#selling prices
Cl(AAPL)[which(sig==-1)]
#coumputing profit
#buy - sell
as.vector(Cl(AAPL)[sig == 1])[-1] - Cl(AAPL)[sig == -1][-table(sig)[["1"]]]
adjust
install.packages("devtools")
require(devtools)
install_github("braverock/FinancialInstrument")
install_github("joshuaulrich/xts")
install_github("braverock/blotter")
install_github("braverock/quantstrat")
install_github("braverock/PerformanceAnalytics")

#clear blotter environment
rm(list=ls(.blotter),envir = .blotter)
currency("USD")
# Allowing quanstrat to use timestamps
Sys.setenv(TZ="MDT")

AAPL_adj <- adjustOHLC(AAPL)
stock("AAPL_adj",currency = "USD", multiplier = 1)
