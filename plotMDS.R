library(ggplot2)
library(hrbrthemes)
library(ggtext)
library(writexl)

#file read
f3 <- read.table("~/f3/f3.list1125.csv",header = T, sep = ",",row.names = 1)
f3[is.na(f3)] = 0
f3_TP<-f3[1:47,1:47]
#rn  <- row.names(f3_TP)
#write_xlsx(data.frame(Column_Names = rn), "~/f3/column_names.xlsx")
#mds calculate
loc <- cmdscale(f3_TP)

#plot
group <- read.table('~/f3/group_zongri.txt',col.names = 'Group')
db <- as.data.frame(loc)
attach(db)
db$Group <- group[,1]


colorlist=c("#E80D0D","#E80D0D","#00BCDA","#FF966E","#281713")
shapelist=c(18,19,20,21,22)
ggplot(db, aes(x=V1, y=V2,color=Group)) + 
  geom_point(size=2) +
  scale_color_manual(values=colorlist, 
                    breaks = c("Zongri2020","Mabuco","south-southwest","southeast-central","northeast"),
                    labels=paste("<span style='color:",
                                 colorlist,
                                 "'>",
                                 unique(c("Zongri2020","Mabu Co", "South-southwest", "Southeast-central","Northeast")),
                                 "</span>"))+
  geom_text(label=rownames(db),size=6,nudge_x = 0, nudge_y = 0,check_overlap = FALSE )+
  expand_limits(x=0.22,y=0.22)+
  theme(legend.background = element_rect(colour = 'white',fill = "white"),
        legend.justification=c(0,0),
        legend.position=c(0.7,0.8),
        legend.title=element_blank(),
        legend.text = element_markdown(size = 18),
        panel.border = element_rect(color = "black",fill = NA,size=1),
        panel.background = element_rect(colour = "white",fill = "white"),
        panel.grid = element_blank(),
        axis.title = element_text(size = 14,colour = "black",face = "plain"),
        axis.text.y = element_text(size = 12,face = "plain"),
        axis.text.x = element_text(size = 12,face = "plain"))
   #theme_ipsum()
