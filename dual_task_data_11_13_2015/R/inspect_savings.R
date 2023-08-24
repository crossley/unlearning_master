##
## new savings bit
##

dd <- data[, mean(accuracy[block %in% 29:30] -
                  accuracy[block %in% 1:2]),
           .(condition, subject)]
setnames(dd, 'V1','savings')

fm <- lm(savings ~ condition, data=dd[condition != 5 & condition != 4])
anov <- anova(fm)
print(anov)
print(format(round(anov$Sum[1]/sum(anov$Sum), 2), nsmall=2))


t.test(dd[condition==1, savings], dd[condition==4, savings])

dd[, err := sd(savings) / sqrt(.N), condition]
limits <- aes(ymax=dd[, mean(savings) + err[1], condition]$V1,
              ymin=dd[, mean(savings) - err[1], condition]$V1)

ggplot(dd[, mean(savings), .(condition, err)], aes(x=condition, y=V1)) +
  geom_bar(stat='identity') +
  geom_pointrange(limits) +
  geom_abline(slope=0, intercept=0) +
  ylab('Savings') +
  xlab('Condition') +
  theme_classic() +
  theme(
    axis.text.x=element_text(size=14),
    axis.text.y=element_text(size=14),
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16)
    )
ggsave('../figures/fig_savings.pdf')

## ggplot(dd, aes(x=factor(condition), y=savings)) +
##   geom_boxplot() +
##   geom_point() +
##   geom_abline(slope=0, intercept=0, colour='red') +
##   ylab('Savings') +
##   xlab('Condition') +
##   theme(axis.text.x=element_text(size=12),
##         axis.text.y=element_text(size=12),
##         axis.title.x=element_text(size=14),
##         axis.title.y=element_text(size=14))
## ggsave('../figures/fig_savings.pdf')

for(i in dd[condition %in% 1:5, unique(condition)]) {
  t <- t.test(dd[condition==i, savings])
  print(
    paste(sep='', 't(',
          round(t$parameter), ') = ',
          format(round(t$statistic, 2), nsmall=2), ', p = ',
          format(round(t$p.value, 2), nsmall=2), ', d = ',
          format(round(t$statistic^2 / sqrt(t$parameter), 2), nsmall=2))
        )
}

dd[, cc := ifelse(condition==5, condition, 1)]

t <- t.test(dd[cc==1, savings], dd[cc==5, savings], alternative = 'less')
paste(sep='', 't(',
      round(t$parameter), ') = ',
      format(round(t$statistic, 2), nsmall=2), ', p = ',
      format(round(t$p.value, 2), nsmall=2), ', d = ',
      format(round(t$statistic^2 / sqrt(t$parameter), 2), nsmall=2))

for(i in dd[condition %in% 1:4, unique(condition)]) {
  t <- t.test(dd[condition==i, savings], dd[condition==5, savings], alternative = 'less')
  print(
    paste(sep='', 't(',
          round(t$parameter), ') = ',
          format(round(t$statistic, 2), nsmall=2), ', p = ',
          format(round(t$p.value, 2), nsmall=2), ', d = ',
          format(round(t$statistic^2 / sqrt(t$parameter), 2), nsmall=2))
        )
}

for(i in 1:5) {
  for(j in 1:5) {
    ## print(var.test(ddd[condition==toString(i)]$V1,d[condition==toString(j)]$V1))
    t <- t.test(
      dd[condition==toString(i)]$savings,
      dd[condition==toString(j)]$savings,
      alternative = 'greater')
    print(paste('condition ', toString(i), '> condition ', toString(j)))
    print(paste(sep='', 't(',
          round(t$parameter), ') = ',
          format(round(t$statistic, 2), nsmall=2), ', p = ',
          format(round(t$p.value, 2), nsmall=2), ', d = ',
          format(round(t$statistic^2 / sqrt(t$parameter), 2), nsmall=2))
	)
  }
}

##
## new savings bit in old graphics style
##

## savings <- setnames(data[, mean(accuracy[block %in% 29:30] - accuracy[block %in%
## 1:2]), .(condition, subject)],'V1','savings')

## ac <- data[block %in% 1:2, mean(accuracy), .(condition, subject, block)]
## reac <- data[block %in% 29:30, mean(accuracy), .(condition, subject, block)]
## reac[, block := rep(1:6, .N/6)]
## rt <- data[block %in% 29:30, mean(rt), .(condition, subject, block)]
## savings_per_block <- reac
## savings_per_block[, V1 := V1 - ac$V1]
## savings_per_block[, rt := rt$V1]

## pdf("../figures/fig_savings.pdf",width=10,height=7)
## boxplot(savings ~ condition, data=savings,
##         names=c('1','2','3','4','Control'), xlab='Condition',
##         ylab='Accuracy: Reacquisition - Acquisition')
## points(savings ~ condition, data=savings)
## abline(h=0, col='red')
## dev.off()

##
## original savings bit
##

## savings <- setnames(data[, mean(accuracy[block %in% 29:34] - accuracy[block %in%
## 1:6]), .(condition, subject)],'V1','savings')

## savings_ext5 <- setnames(data_ext5[, mean(accuracy[block %in% 25:30] -
## accuracy[block %in% 1:6]), .(condition, subject)],'V1','savings')

## savings <- rbind(savings,savings_ext5)
## ac <- data[block %in% 1:6, mean(accuracy), .(condition, subject, block)]
## reac <- data[block %in% 29:34, mean(accuracy), .(condition, subject, block)]
## reac[, block := rep(1:6, .N/6)]
## rt <- data[block %in% 29:34, mean(rt), .(condition, subject, block)]
## savings_per_block <- reac
## savings_per_block[, V1 := V1 - ac$V1]
## savings_per_block[, rt := rt$V1]

## pdf("../figures/fig_savings.pdf",width=10,height=7)
## boxplot(savings ~ condition, data=savings,
##         names=c('1','2','3','4','Control','Crossley et al. (2013)'), xlab='Condition',
##         ylab='Accuracy: Reacquisition - Acquisition')
## points(savings ~ condition, data=savings)
## abline(h=0, col='red')
## dev.off()

# ====================================================================================================================
# ====================================================================================================================

pdf("../figures/fig_savings_per_block.pdf",width=10,height=10) 

xlim <- c(1,6)
ylim <- c(-.15,.15)

clr <- brewer.pal(5, "Set1")

par(mfrow=c(1,1), pty="s")
plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Savings",cex.lab=2)

for(i in 1:5) {
  lines(savings_per_block[condition==i, mean(V1), block], ylim=ylim, col=clr[i], lwd=2)
  plot_err_bars(
    savings_per_block[condition==i, mean(V1), block]$block,
    savings_per_block[condition==i, mean(V1), block]$V1,
    savings_per_block[condition==i, sd(V1)/sqrt(subs_counts[condition==i,N]), block]$V1,
    clr[i]
	)
  abline(h=0,lty = 2)
}

lgnd_txt <- c('Condition 1','Condition 2','Condition 3','Condition 4','No Dual-Task Control')
legend('top',lgnd_txt,bty='n',lty=c(1,1),lwd=c(2.5,2.5),col=clr)

dev.off()

# ====================================================================================================================
# ====================================================================================================================

dt <- setnames(data[condition %in% 1:4,mean(wmAcc[trial%in%which(wmRT!=0)]),
                    .(condition,subject)], 'V1', 'dt')

setkey(savings, condition, subject)
setkey(dt, condition, subject)

dt[, savings := savings[condition %in% 1:4]$savings]

pdf("../figures/fig_savings_dt.pdf", 8, 8)
par(mfrow=c(2,2), pty='s')
for(i in 1:4) {
  fm <- lm(savings ~ dt , data = dt[condition==i])
  plot(dt[condition==i]$dt, dt[condition==i]$savings,
       xlab='Mean Numerical Stroop',
       ylab='Mean Savings',
       cex.lab=1.5
       )
  abline(fm, lwd=2)
  print(anova(fm))
}
dev.off()




int <- setnames(data[block %in% 13:24, mean(accuracy), .(condition, subject)], 'V1', 'int')
## int <- setnames(data[block %in% 13:18, mean(accuracy), .(condition, subject)], 'V1', 'int')

setkey(savings, condition, subject)
setkey(int, condition, subject)

int[, savings := savings[condition%in%1:5]$savings]

pdf("../figures/fig_savings_int.pdf", 8, 8)
par(mfrow=c(2,2), pty='s')
for(i in 1:4) {
  fm <- lm(savings ~ int , data = int[condition==i])
  plot(int[condition==i]$int, int[condition==i]$savings,
       xlab='Mean Intervention Accuracy',
       ylab='Mean Savings',
       cex.lab=1.5
       )
  abline(fm, lwd=2)
  print(anova(fm))
}
dev.off()




ac <- setnames(data[block %in% 1:12, mean(accuracy), .(condition, subject)], 'V1', 'ac')

setkey(savings, condition, subject)
setkey(ac, condition, subject)

ac[, savings := savings[condition%in%1:5]$savings]

pdf("../figures/fig_savings_ac.pdf", 8, 8)
par(mfrow=c(2,2), pty='s')
for(i in 1:4) {
  fm <- lm(savings ~ ac , data = ac[condition==i])
  plot(ac[condition==i]$ac, ac[condition==i]$savings,
       xlab='Mean Acquisition Accuracy',
       ylab='Mean Savings',
       cex.lab=1.5
       )
  abline(fm, lwd=2)
  print(anova(fm))
}
dev.off()
