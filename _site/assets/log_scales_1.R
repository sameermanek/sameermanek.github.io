# Log scale vs linear for a handful of countries (BRINC + Singapore?)
library(Quandl)
library(ggplot2)
library(data.table)
library(scales)
library(ggthemes)

lst.symbols <- list(
  list(symbol = "MADDISON/GDPPC_SGP_NEW", name = "Singapore", colname = "GDP PER CAPITA"),
  list(symbol = "MADDISON/GDPPC_BRA", name = 'Brazil', colname = "GDP PER CAPITA"),
#  list(symbol = "MADDISON/GDPPC_RUS", name = 'Russia', colname = "GDP PER CAPITA"),
  list(symbol = "MADDISON/GDPPC_SUN", name = 'USSR', colname = "GDP PER CAPITA"),
  list(symbol = "MADDISON/GDPPC_IND", name = "India", colname = "GDP PER CAPITA"),
  list(symbol = "MADDISON/GDPPC_NGA", name = "Nigeria", colname = "GDP PER CAPITA"),
  list(symbol = "MADDISON/GDPPC_CHN", name = "China", colname = "GDP PER CAPITA"),
  list(symbol = "MADDISON/GDPPC_HKG", name = "Hong Kong", colname = "GDP PER CAPITA"),
  list(symbol = "MADDISON/GDPPC_JPN", name = "Japan", colname = "GDP PER CAPITA"),
  list(symbol = "MADDISON/GDPPC_MYS", name = "Malaysia", colname = "GDP PER CAPITA"),
  list(symbol = "MADDISON/GDPPC_IDN", name = "Indonesia", colname = "GDP PER CAPITA"),
  list(symbol = "MADDISON/GDPPC_USA", name = "United States", colname = "GDP PER CAPITA"),
  list(symbol = "MADDISON/GDPPC_ZAF", name = "South Africa", colname = "GDP PER CAPITA")
  )
Quandl.auth(readLines('~/Dropbox/code/Correlations/quandl.config', warn = FALSE)[1])

getQuandlData <- function(lst.symbol) {
  dt.data <- data.table(Quandl(lst.symbol[['symbol']]))
  setnames(dt.data, tolower(names(dt.data)))
  dt.data <- dt.data[, c('year',tolower(lst.symbol[['colname']])), with=FALSE]
  setnames(dt.data, c('date','value'))
  dt.data[, date:=as.character(date)]
  dt.data[, name:=lst.symbol[['name']]]
  return(dt.data)
}
  
dt.data <- rbindlist(lapply(lst.symbols, getQuandlData))

# There's some weird data. 
dt.data <- dt.data[month(date) == 12]

chr.colors <- c('Singapore' = 'red', 'United States' = 'lightskyblue', 'Hong Kong' = 'midnightblue',
                'Japan' = 'darkgreen', 'Malaysia' = 'gold', 'China' = 'firebrick4', 'Indonesia' = 'darkcyan')
num.size <- rep(1, length(chr.colors))
names(num.size) <- names(chr.colors)
num.size['Singapore'] <- 2

a <-
ggplot(dt.data[name %in% names(chr.colors)], aes(as.Date(date), value/1e3, colour = name, size = name)) + 
  geom_line() + 
  coord_cartesian(xlim = as.Date(c('1960-01-01','2012-12-31'))) + 
  scale_colour_manual(values = chr.colors) + 
  scale_size_manual(values = num.size) + 
#  theme_bw() + 
  labs(x = 'Date', y = 'Per Capita GDP ($k)', colour = 'Country', size = 'Country') + 
  theme_economist()
  
ggsave(plot = a, '~/GitHub/sameermanek.github.io/assets/gdp_linear.png', width = 10, height = 7.5)

ggsave(plot = a + scale_y_log10() + annotation_logticks(sides = 'l'), '~/GitHub/sameermanek.github.io/assets/gdp_log.png', width = 10, height = 7.5)
  


# Do again w/ the BRINC countries
chr.colors <- c('South Africa' = 'red', 'USSR' = 'orange',
                'Brazil' = 'brown', 'China' = 'darkolivegreen4', 'India' = 'purple', 'Nigeria' = 'lightblue4')
num.size <- rep(1, length(chr.colors))
names(num.size) <- names(chr.colors)
num.size['Nigeria'] <- 2

a <-
  ggplot(dt.data[name %in% names(chr.colors)], aes(as.Date(date), value/1e3, colour = name, size = name)) + 
  geom_line() + 
  coord_cartesian(xlim = as.Date(c('1960-01-01','2012-12-31'))) + 
  scale_colour_manual(values = chr.colors) + 
  scale_size_manual(values = num.size) + 
  theme_bw() + 
  labs(x = 'Date', y = 'GDP Per Capita ($k)', colour = 'Country', size = 'Country') 

ggsave(plot = a, '~/GitHub/sameermanek.github.io/assets/gdp_nigeria_linear.png', width = 10, height = 7.5)

ggsave(plot = a + scale_y_log10() + annotation_logticks(sides = 'l'), '~/GitHub/sameermanek.github.io/assets/gdp_nigeria_log.png', width = 10, height = 7.5)

  
# calculate CAGRs
dt.data[year(date) >= 1960, 
        list(
          latest = value[date == max(date)], 
          earliest = value[date == min(date)], 
          start = year(min(date)), 
          end = year(max(date))), by=list(country = name)
        ][, list(country, cagr = (latest/earliest)^(1/(end - start)) - 1 )][order(cagr)]


dt.data[year(date) %between% c(2000,2015), 
        list(
          latest = value[date == max(date)], 
          earliest = value[date == min(date)], 
          start = year(min(date)), 
          end = year(max(date))), by=list(country = name)
        ][, list(country, cagr = (latest/earliest)^(1/(end - start)) - 1 )][order(cagr)]