library(scales)
library(data.table)
library(scatterplot3d)
library(grt)
library(pwr)
library(RColorBrewer)
library(ggplot2)
library(gridExtra)

rm( list = ls() )

T0 <- 0
n <- 4
lambda <- 2
t <- seq(1,30,1)
hrf <- ((t-T0)^(n-1) * exp(-(t-T0)/lambda)/((lambda^n)*factorial(n-1)))

delta.context <- fread('delta_context.txt')
delta.classic <- fread('delta_classic.txt')
contingency.classic <- fread('contingency2_classic.txt')

contingency.classic <- contingency.classic[, V1]
delta.classic[301:600, V1 := 10.0 * V1 * contingency.classic[301:600]]

delta.context <- delta.context$V1
delta.classic <- delta.classic$V1

delta.classic <- delta.classic[1:900]
delta.context <- delta.context[1:900]

bold.classic <- convolve(hrf, delta.classic, type='open')
bold.context <- convolve(hrf, delta.context, type='open')

b.classic <- data.table(bold=bold.classic, Model='RPE')
b.classic[, t := 1:.N]

b.context <- data.table(bold=bold.context, Model='Contingency-Scaled RPE')
b.context[, t := 1:.N]

b <- rbind(b.classic, b.context)
b[, Model := factor(Model, levels=c('Contingency-Scaled RPE', 'RPE'),
                    labels=c('Context-Gate Model: RPE',
                             'Simple-Gate Model: Contingency-Scaled RPE'
                             ))]

ggplot(b, aes(x=t, y=bold, colour=Model)) +
  geom_line(size=1) +
  geom_vline(xintercept = 300, size=1, linetype = 2, alpha=1) +
  geom_vline(xintercept = 600, size=1, linetype = 2, alpha=1) +
  ylab('Predicted BOLD') +
  xlab('Time') +
  ylim(-2, .9) +
  scale_color_manual(values=c('blue','red')) +
  theme_classic() +
  theme(
    legend.position = c(0.5,0.15),
    legend.text=element_text(size=14),
    legend.title=element_blank(),
    legend.background = element_rect(fill=alpha('white', 1.0)),
    text = element_text(size=14),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.border = element_rect(colour = "black", fill=NA, size=1)
  )
ggsave('predicted_bold.pdf', width = 7, height = 4)




acc <- fread('accuracy.txt')
acc2 <- fread('accuracy2.txt')

acc[, version := 1]
acc2[, version := 2]

acc = rbind(acc,acc2)

setnames(acc, 'V1', 'acc')

num.trials <- 1200
blk.size <- 25

acc[, blk := rep(1:(num.trials / blk.size), each = blk.size)]
acc[, phase := rep(1:4, each = 300)]

d <- acc[, mean(acc), .(version, phase, blk)]
setnames(d, 'V1', 'acc')

accplot <- ggplot(d[version==2], aes(blk, acc, group = phase)) +
  ylim(0,1) +
  geom_vline(xintercept=12.5, linetype=2, size=0.5) +
  geom_vline(xintercept=24.5, linetype=2, size=0.5) +
  geom_vline(xintercept=36.5, linetype=2, size=0.5) +
  geom_vline(xintercept=48.5, linetype=2, size=0.5) +
  stat_smooth(method ="auto",level=0.95, size=1, colour='red') +
  theme_classic() +
  theme(
    axis.line=element_blank(),
    legend.position="none",
    panel.background=element_blank(),
    panel.grid.major=element_blank(),
    panel.grid.minor=element_blank(),
    plot.background=element_blank(),
    panel.border = element_rect(colour = "black", fill=NA, size=.5),
    strip.background = element_blank(),
    strip.text = element_blank()
  )
ggsave('model_results2.pdf', width=4, height=2)


c <- fread('stimuli.csv')
c[, phase := rep(c(1,2,1,2), each = 300)]

cbPalette <- c('black','red','green','blue')

cats <- ggplot(c, aes(x, y, colour=factor(cat))) +
  geom_point(size=.5) +
  coord_fixed() +
  theme_classic() +
  theme(
    axis.line=element_blank(),
    axis.text.x=element_blank(),
    axis.text.y=element_blank(),
    axis.ticks=element_blank(),
    axis.title.x=element_blank(),
    axis.title.y=element_blank(),
    legend.position="none",
    panel.background=element_blank(),
    panel.grid.major=element_blank(),
    panel.grid.minor=element_blank(),
    plot.background=element_blank(),
    panel.border = element_rect(colour = "black", fill=NA, size=1),
    strip.background = element_blank(),
    strip.text = element_blank()
  ) +
  facet_wrap(~phase, ncol=1) +
  scale_colour_manual(values=cbPalette)
ggsave('model_cats.pdf', width=2, height = 4)

## grid.arrange(cats, accplot, ncol=2)
## ggsave(
##   "model_results_all.pdf",
##   arrangeGrob(
##     cats,
##     accplot,
##     ncol=2,
##     heights=c(2, 2),
##     widths=c(4,4))
## )
