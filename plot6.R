library(plyr, gridExtra, ggplot2)

NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

str(NEI)
str(SCC)

colnames(NEI)[1] <- "countyID"

Baltimore <- subset(NEI, countyID == "24510", na.rm = TRUE)
LA <- subset(NEI, countyID == "06037", na.rm = TRUE)


head(SCC$EI.Sector)


#want to subset the initial dataset to get all data related to coal

mobileSCC <- subset(SCC, grepl("Mobile", EI.Sector))

#now we merge the two databases, only keeping the rows corresponding to SCC
#can do this by joint 
baltimore_mobile <- join(mobileSCC, Baltimore, type = "inner")
LA_mobile <- join(mobileSCC, LA, type = "inner")


results_baltimore_mobile <- ddply(baltimore_mobile, .(year), summarise, total.emissions.of.motor.vehicles = sum(Emissions))
results_LA_mobile <- ddply(LA_mobile, .(year), summarise, total.emissions.of.motor.vehicles = sum(Emissions))

dim(results_baltimore_mobile)

baltimore_table <- cbind(results_baltimore_mobile, city= rep("Baltimore", 4))
LA_table <- cbind(results_LA_mobile, city= rep("LA", 4))


baltimore_LA <- arrange(rbind(baltimore_table, LA_table), year)

#two plots side by side
png("plot6.png", bg = 'white')
#first plot
p1 <- ggplot(results_baltimore_mobile, aes(year, total.emissions.of.motor.vehicles), ylim=11000) + geom_point(aes(col = "red")) +ggtitle("Motor pollution in Baltimore") + stat_smooth() + guides(colour=FALSE)
#second plot
p2 <- ggplot(results_LA_mobile, aes(year, total.emissions.of.motor.vehicles), ylim=11000) + geom_point(aes(col = "red")) + ggtitle("Motor pollution in L.A.") + stat_smooth() + guides(colour=FALSE)
#plotting both, side by side
grid.arrange(p1, p2, ncol=2)
dev.off()


#one single plot
png("plot6alternative.png", bg = 'white')
qplot(year, total.emissions.of.motor.vehicles, data = baltimore_LA, colour = city, geom = c("point", "smooth"), main = "Mobile pollution")
dev.off()

