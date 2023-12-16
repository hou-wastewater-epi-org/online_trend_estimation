## f is a data 
fplot <- function(f, title_char, points=F, line_colors = c("#17266D", "#D96D2C")){
  if(points){
    x <- {ggplot2::ggplot(f, aes(x = date, y = est, color = name, fill = name)) +
        ggplot2::theme_minimal()+
        
        ggplot2::geom_line(linewidth=2) +
        
        ggplot2::geom_ribbon(aes(ymin=lwr,ymax=upr),alpha=.2) +
        
        ggplot2::scale_color_manual(values = c(line_colors[1], line_colors[2])) +
        
        ggplot2::scale_fill_manual(values = c(paste(line_colors[1], "50", sep = ""), paste(line_colors[2], "50", sep = "")), guide = "none") +
        
        #ylim(2, 8) + 
        ggplot2::geom_point(aes(x=date, y=obs)) +
        
        ggplot2::labs(title = paste(title_char), x= "Date", y = "Log10 Copies/L-WW", color = "") 
    }
  }
  if(!points){
    x <- {ggplot2::ggplot(f, aes(x = date, y = est, color = name, fill = name)) +
        ggplot2::theme_minimal()+
        
        ggplot2::geom_line(linewidth=2) +
        
        ggplot2::geom_ribbon(aes(ymin=lwr,ymax=upr),alpha=.2) +
        
        ggplot2::scale_color_manual(values = c(line_colors[1], line_colors[2])) +
        
        ggplot2::scale_fill_manual(values = c(paste(line_colors[1], "50", sep = ""), paste(line_colors[2], "50", sep = "")), guide = "none") +
        
        #ylim(2, 8) + 
        
        ggplot2::labs(title = paste(title_char), x= "Date", y = "Log10 Copies/L-WW", color = "") 
        }
  }
  return(x)
  
}
