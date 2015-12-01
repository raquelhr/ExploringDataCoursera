library(plyr, ggplot2)
head(SCC)
head(SCC$EI.Sector)

#want to subset the initial dataset to get all data related to coal

coalSCC <- subset(SCC, grepl("Coal", EI.Sector))

#now we merge the two databases, only keeping the rows corresponding to SCC
#can do this by joint 
coal <- join(coalSCC, NEI, type = "inner")

results <- ddply(coal, .(year), summarise, total.emissions.of.coal = sum(Emissions))
png("plot4.png", bg = 'white')
par(mar = c(4,4,4,4))
p1 <- ggplot(results, aes(year, total.emissions.of.coal)) + geom_point(aes(col = "red")) 
p2 <- p1 + ggtitle("Total emissions of coal source pollutants across the U.S.A.")
#don't want  legend, since we are interested in a single class of data (the sum)
p2+stat_smooth() + guides(colour=FALSE)
dev.off()