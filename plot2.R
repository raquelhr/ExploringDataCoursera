library(plyr)

NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

str(NEI)
str(SCC)

colnames(NEI)[1] <- "countyID"

Baltimore <- subset(NEI, countyID == 24510, na.rm = TRUE)

summary(Baltimore)


png("plot2.png", bg = "white")
plot(emissionsBaltimore, pch = 19, col = 4)
abline(h = mean(emissionsBaltimore$total.emissions), col = 1 , lty = 3, lwd = 4) #dashed line
dev.off()

emissionsBaltimore <- ddply(Baltimore, .(year), summarise, total.emissions = sum(Emissions, na.rm = TRUE))
emissionsBaltimore