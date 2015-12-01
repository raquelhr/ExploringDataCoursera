library(plyr, ggplot2)

NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

str(NEI)
str(SCC)

colnames(NEI)[1] <- "countyID"

Baltimore <- subset(NEI, countyID == 24510, na.rm = TRUE)


head(SCC$EI.Sector)


#want to subset the initial dataset to get all data related to coal

mobileSCC <- subset(SCC, grepl("Mobile", EI.Sector))

#now we merge the two databases, only keeping the rows corresponding to SCC
#can do this by joint 
mobile <- join(mobileSCC, NEI, type = "inner")

results_mobile <- ddply(mobile, .(year), summarise, total.emissions.of.motor.vehicles = sum(Emissions))
png("plot5.png", bg = 'white')
par(mar = c(4,4,4,4))
p1 <- ggplot(results_mobile, aes(year, total.emissions.of.motor.vehicles)) + geom_point(aes(col = "red")) 
p2 <- p1 + ggtitle("Total emissions of mobile motor source pollutants across the U.S.A.")
#don't want  legend, since we are interested in a single class of data (the sum)
p2+stat_smooth() + guides(colour=FALSE)
dev.off()