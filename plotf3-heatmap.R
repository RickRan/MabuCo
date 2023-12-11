library(gplots)
library(ggplot2)
library(hrbrthemes)
library(RColorBrewer)
windowsFonts(A=windowsFont("Arial"))

f3 <- read.table("~/f3/f3.list1125.csv",header = T, sep = ",",row.names = 1)
#f3[is.na(f3)] = 0

f3_TP<-f3[1:47,1:47]
list1 <- colnames(f3_TP)
plotpop <- list1[c(1,2,5,12,20,21,29,36,42)]
f3_plot <- f3_TP[plotpop,plotpop]
data <- f3_TP
filtered_rows <- data[!(rownames(data) %in% c("Longlin", "AR33K","Tianyuan","AR19K","ZongriM6R1","Zongri4.5k_o1","Zongri4.1k")), ]
filtered_data <- filtered_rows[, !(colnames(filtered_rows) %in% c("Longlin", "AR33K","Tianyuan","AR19K","ZongriM6R1","Zongri4.5k_o1","Zongri4.1k"))]
f3_TP <- filtered_data
x <- as.matrix(f3_TP)
col2 <- colorRampPalette(brewer.pal(9,"Blues"))(16)
#heatmap.2(x,trace = "none",dendrogram="row",breaks = seq(0.31,0.35,0.0025),col = col2,margins = c(20,20),keysize = 3.0,cexRow = 1.6,cexCol = 1.6,
#          key.title = NA,
#          key.ylab = NA,
#          key.xlab = NA,
#          key.ytickfun =NA,
#          )
heatmap.2(x,trace = "none",margins = c(12,12),density.info = "none",keysize = 0.5)

