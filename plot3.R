library(plyr, ggplot2)

NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

str(NEI)
str(SCC)

colnames(NEI)[1] <- "countyID"

Baltimore <- subset(NEI, countyID == 24510, na.rm = TRUE)

summary(Baltimore)


table(Baltimore$type)

emissionsBaltimoretype <- ddply(Baltimore, .(year, type), summarise, total.emissions = sum(Emissions, na.rm = TRUE))


#using qplot
qplot(year, total.emissions, data = emissionsBaltimoretype, col = type, geom = "point", stat = "smooth", title(main = "Emissions of different sources of pollutants in Baltimore city over the period 1999-2008"))

#using ggplot
p <- ggplot(data = emissionsBaltimoretype, aes(year, total.emissions, col = type)) + geom_point() 
p+geom_smooth()


#now choose one of these ways of plotting to produce the graphic and save it as a PNG file
png("plot3.png", bg = "white")
qplot(year, total.emissions, data = emissionsBaltimoretype, col = type, geom = "point", stat = "smooth", title(main = "Emissions of different sources of pollutants in Baltimore city over the period 1999-2008"))
dev.off()

emissionsBaltimore <- ddply(Baltimore, .(year), summarise, total.emissions = sum(Emissions, na.rm = TRUE))
emissionsBaltimore