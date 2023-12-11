#library
library(ggplot2)
library(forcats)
library(dplyr)
library(tibble)
library(hrbrthemes)
library(ggrepel) 

#windowsFonts(A=windowsFont("Arial"))
#data prepare
df2 <- read.table("~/PCA/0406/mabuco_pca0610.evec",strip.white = TRUE,col.names =c("sample","PC1","PC2","PC3","V4","V5","V6","V7",'V8','V9','V10','Population'))
df2 <- df2[,-c(5:11)]
df2 <- df2[-c(495,190,498,224,507,230,500,229,622,623),]
df3<- read.table("~/PCA/0406/popgroup_Aesthetics10.csv",comment.char = "",check.names=FALSE, sep = ',',col.names = c("Population","group","color","symbol"), encoding='UTF-8')
newtable <- merge(df2,df3,by='Population')
mabuco <- newtable[c(263:271),]
#mabuco$Population<-c("mabuco1","mabuco10","mabuco11","mabuco2","mabuco3","mabuco4","mabuco5","mabuco6","mabuco7","mabuco8","mabuco9" )
newtable<- newtable[order(newtable[,6]),]
#rename group
#newtable[167:177,1]<-c("MabucoE2","MabucoL","MabucoL","MabucoE1","MabucoE1","MabucoE1","MabucoE1","MabucoE1","MabucoE2","MabucoE1","MabucoE2" )
#extract subset
tibet <- subset(newtable,PC1 > 0.026 & PC2 < -0.031)
atibet <- subset(tibet, group!="Tibetan")
#tibet %>% arrange(match(Reg, c("C","A","B")), desc(Res), desc(Pop))
rows <- rownames(tibet)
new_rows <- c(rows[7:15],rows[1:6],rows[16:length(rows)])
tibet<-tibet[new_rows,]
#tibet[7:17,1]<-c("mabuco1","mabuco10","mabuco11","mabuco2","mabuco3","mabuco4","mabuco5","mabuco6","mabuco7","mabuco8","mabuco9" )
ancient<- subset(newtable,group!="Tibetan"& group!="SouthernEA"& group!="NorthernEA"&group!="CentralEA"&group!="aMabuco")

 #list_shape <- atibet %>% select(Population,symbol) %>% deframe()
 #list_color <- atibet %>% select(Population,color) %>% deframe()
list_shape <- newtable %>% select(Population,symbol) %>% deframe()
list_color <- newtable %>% select(Population,color) %>% deframe()

#plot pca
p1 <- ggplot((newtable),aes(PC1, PC2,color=Population,shape=Population, fill="Firebrick2"))+
  geom_point(size=8) +
  xlab("PC1(3.7%)")+ylab("PC2(2.9%)")+
  #guides(Population = guide_legend(nrow = 6))+
  scale_color_manual(values = list_color) +
  scale_shape_manual(values = list_shape) +
  theme_bw()+
  theme(legend.position = "none",
        legend.background = element_rect(colour = 'black',fill =NA),
        panel.border = element_rect(color = "black",fill = NA,size=1),
        panel.grid = element_blank(),
        axis.title = element_text(size = 20,colour = "black",face = "plain"),
        legend.title = element_blank(),
        legend.text = element_text(colour="black", size = 12), 
        axis.text.y = element_text(size = 16,face = "plain"),
        axis.text.x = element_text(size = 16,face = "plain"))+
  geom_point(data=ancient, aes(x = PC1, y = PC2),size=8)+
  geom_point(data=mabuco, aes(x = PC1, y = PC2),size=8,fill="#C17A9F",color="black",stroke = 2)
  #theme(legend.position = "right",legend.background = element_rect(colour = 'black',fill =NA),panel.border = element_rect(color = "black",fill = NA),panel.grid = element_blank(),legend.title = element_text(colour="black", size=16, face="bold"),legend.text = element_text(colour="black", size = 6, face = "bold"))
  #geom_text_repel(data=mabuco,aes(x = PC1, y = PC2,label=Population),size=6, check_overlap=TRUE,color=mabuco$color)
# tiff size 1000*1200
#pdf size 6*8
#ggsave("0626.pdf", plot = last_plot(),width = 6, height = 8, units = "in", path = "~/PCA/0406/")


# ----------------------------------------------------------------------------------------------------------



shapeM <- data.frame(
  shape = c(22,24),
  color=rep("#C17A9F",times=2),
  x = rep(1.5,times=2),
  y = c(1.25,1.45)
)

p2<-ggplot(shapeM,aes(x,y))+
  geom_point(aes(shape=shape,color=color),size=8,fill="#C17A9F",color="black",stroke = 2)+
  scale_shape_identity() +
  scale_color_identity()+
  expand_limits(x = 3,y=4.0)+
  theme_void()+
  # annotate("text",label="NortheastTP",x=xp,y=2.25,color="#00C0E0",size=12,hjust = 0)+
  # annotate("text",label="CentralTP",x=xp,y=2.75,color="#00A3FF",size=12,hjust = 0)+
  # annotate("text",label="Nepal",x=xp,y=3.25,color="#0082FF",size=12,hjust = 0)+
  # annotate("text",label="SouthTP",x=xp,y=3.75,color="#0059FF",size=12,hjust = 0)+
  # annotate("text",label="Published ancient data",x=xp,y=3.95,color="#737373",size=12,hjust = 0)+
  annotate("text",label="MabucoE2",x=1.6,y=1.26,color="black",size=8,hjust = 0,)+
  annotate("text",label="MabucoE1",x=1.6,y=1.46,color="black",size=8,hjust = 0,)+
  annotate("text",label="New ancient data",x=1.4,y=1.68,color="#737373",size=8,hjust = 0)

p3 <- ggplotGrob(p2)
p1 + annotation_custom(p3, xmin=-0.08,xmax=0,ymin = -0.1,ymax = 0.05) 
