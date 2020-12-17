library(ape)
library(HDInterval)
library(ggplot2)
library(dispRity)
library(patchwork)
library(tikzDevice)
library(ggplot2)
library(phangorn)
library(MASS)
library(smacof)
library(ggpubr)

get.arrow.mds.plot <- function(mds.config, model.description, measurement, color.values, shape.values, text.pos, arrow.pos, x.min, x.max, y.min, y.max){
  fig =  ggplot() + 
    geom_point(data = as.data.frame(mds.config), mapping = aes(x = D1, y = D2, shape = model.description, color = model.description), size = 1.5) +
    labs(x = "Dimension 1", y ="Dimension 2", title = measurement) + 
    scale_color_manual(name="Analysis", values=color.values) +
    scale_shape_manual(name="Analysis", values=shape.values) +
    scale_x_continuous(breaks=seq(x.min, x.max, length.out = 3)) +
    scale_y_continuous(breaks=seq(y.min, y.max, length.out = 3)) +
    annotate("text", x = text.pos[1], y =text.pos[2], label = "Analysis 1",size=5) + 
    geom_segment(aes(x = arrow.pos[1], y = arrow.pos[2], xend = arrow.pos[3], yend = arrow.pos[4]), colour='black', size = 0.8, arrow = arrow(length = unit(0.5, "cm"))) + 
    theme(
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      plot.background = element_blank(),
      plot.title = element_text(color="black", size=16, hjust=0.5),
      axis.line = element_line(),
      axis.ticks = element_line(color="black"),
      axis.text.x = element_text(color="black", size=15),
      axis.text.y = element_text(color="black", size=15),
      axis.title.x = element_text(color="black", size=15),
      axis.title.y = element_text(color="black", size=15),
      legend.key = element_rect(colour = "transparent", fill = alpha("red", 0)),
      legend.text = element_text(colour="black", size = 15),
      legend.title = element_text(color="black", size=15)
    )
  return (fig)
}

get.rect.mds.plot <- function(mds.config, model.description, measurement, color.values, shape.values, text.pos, rect.pos, x.min, x.max, y.min, y.max){
  fig =  ggplot() + 
    geom_point(data = as.data.frame(mds.config), mapping = aes(x = D1, y = D2, shape = model.description, color = model.description), size = 1.5) +
    labs(x = "Dimension 1", y ="Dimension 2", title = measurement) + 
    scale_color_manual(name="Analysis", values=color.values) +
    scale_shape_manual(name="Analysis", values=shape.values) +
    scale_x_continuous(breaks=seq(x.min, x.max, length.out = 3)) +
    scale_y_continuous(breaks=seq(y.min, y.max, length.out = 3)) +
    geom_rect( aes(xmin=rect.pos[1],xmax=rect.pos[2], ymin=rect.pos[3], ymax=rect.pos[4]), color="black", fill="transparent") +
    annotate("text", x = text.pos[1], y =text.pos[2], label = "Analysis 1",size=5) +
    theme(
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      plot.background = element_blank(),
      plot.title = element_text(color="black", size=16, hjust=0.5),
      axis.line = element_line(),
      axis.ticks = element_line(color="black"),
      axis.text.x = element_text(color="black", size=15),
      axis.text.y = element_text(color="black", size=15),
      axis.title.x = element_text(color="black", size=15),
      axis.title.y = element_text(color="black", size=15),
      legend.key = element_rect(colour = "transparent", fill = alpha("red", 0)),
      legend.text = element_text(colour="black", size = 15),
      legend.title = element_text(color="black", size=15)
    )
  return (fig)
}


