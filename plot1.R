library(plyr)

NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

str(NEI)
str(SCC)

colnames(NEI)[1] <- "countyID"

totalemissions <- ddply(NEI, .(year), summarise, total.emissions = sum(Emissions, na.rm = TRUE))
names(totalemissions)

png("plot1.png", bg = "white")
with(totalemissions, plot(year, total.emissions, pch = 19, col = 4))
abline(h = mean(totalemissions$total.emissions), col = 1 , lty = 3, lwd = 4) #dashed line
dev.off()
