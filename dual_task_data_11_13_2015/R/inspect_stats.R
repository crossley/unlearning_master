
# refresh memory for sample size
data[, unique(subject),.(condition, subject)][,.N,condition]

# make sure factors are treated as such
data[, condition := factor(condition)]
data[, subject := factor(subject)]
savings[, condition := factor(condition)]
savings[, subject := factor(subject)]

## are there differences in acquisition between conditions?
d <- data[block %in% 1:10, mean(accuracy), .(condition, subject, block)]
fm <- lm(V1 ~ condition*block, data=d)
anov <- anova(fm)
print(anov)

pairwise.t.test(d$V1, d$condition, p.adjust.method = "none")

print('Effect of Condition ')
paste(sep='', 'F(',
	round(anov$Df[1]), ',',
	round(anov$Df[4]), ') = ',
	format(round(anov$F[1], 2), nsmall=2), ', p = ',
	format(round(anov$Pr[1], 2), nsmall=2), ', Omega = ',
	format(round(anov$Sum[1]/sum(anov$Sum), 2), nsmall=2)
	)

print('Effect of Block ')
paste(sep='', 'F(',
	round(anov$Df[2]), ',',
	round(anov$Df[4]), ') = ',
	format(round(anov$F[2], 2), nsmall=2), ', p = ',
	format(round(anov$Pr[2], 2), nsmall=2), ', Omega = ',
	format(round(anov$Sum[2]/sum(anov$Sum), 2), nsmall=2)
	)

print('Effect of Interaction')
paste(sep='', 'F(',
	round(anov$Df[3]), ',',
	round(anov$Df[4]), ') = ',
	format(round(anov$F[3], 2), nsmall=2), ', p = ',
	format(round(anov$Pr[3], 2), nsmall=2), ', Omega = ',
	format(round(anov$Sum[3]/sum(anov$Sum), 2), nsmall=2)
	)

ddd <- d[, mean(V1), .(condition, subject)]
for(i in 1:5) {
  for(j in 1:5) {
    t <- t.test(ddd[condition==toString(i)]$V1,ddd[condition==toString(j)]$V1)
    print(paste('condition ', toString(i), '> condition ', toString(j)))
    print(paste(sep='', 't(',
          round(t$parameter), ') = ',
          format(round(t$statistic, 2), nsmall=2), ', p = ',
          format(round(t$p.value, 2), nsmall=2), ', d = ',
          format(round(t$statistic^2 / sqrt(t$parameter), 2), nsmall=2))
	)
  }
}

## are there differences in intervention between conditions?
## d <- data[block %in% 13:28, mean(accuracy), .(condition, subject, block)]
d <- data[block %in% 13:16, mean(accuracy), .(condition, subject, block)]
## d <- data[block %in% 17:28, mean(accuracy), .(condition, subject, block)]
fm <- lm(V1 ~ condition*block, data=d)
anov <- anova(fm)
print(anov)
pairwise.t.test(d$V1, d$condition, alternative = 'less', p.adjust.method = "none")

print('Effect of Condition ')
paste(sep='', 'F(',
	round(anov$Df[1]), ',',
	round(anov$Df[4]), ') = ',
	format(round(anov$F[1], 2), nsmall=2), ', p = ',
	format(round(anov$Pr[1], 2), nsmall=2), ', Omega = ',
	format(round(anov$Sum[1]/sum(anov$Sum), 2), nsmall=2)
	)

print('Effect of Block ')
paste(sep='', 'F(',
	round(anov$Df[2]), ',',
	round(anov$Df[4]), ') = ',
	format(round(anov$F[2], 2), nsmall=2), ', p = ',
	format(round(anov$Pr[2], 2), nsmall=2), ', Omega = ',
	format(round(anov$Sum[2]/sum(anov$Sum), 2), nsmall=2)
	)

print('Effect of Interaction')
paste(sep='', 'F(',
	round(anov$Df[3]), ',',
	round(anov$Df[4]), ') = ',
	format(round(anov$F[3], 2), nsmall=2), ', p = ',
	format(round(anov$Pr[3], 2), nsmall=2), ', Omega = ',
	format(round(anov$Sum[3]/sum(anov$Sum), 2), nsmall=2)
	)

ddd <- d[, mean(V1), .(condition, subject)]
for(i in 1:5) {
  for(j in 1:5) {
    ## print(ddd[condition==toString(i), .N])
    ## print(ddd[condition==toString(j), .N])
    ## print(var.test(ddd[condition==toString(i)]$V1,ddd[condition==toString(j)]$V1))
    t <- t.test(ddd[condition==toString(i)]$V1,ddd[condition==toString(j)]$V1)
    print(paste('condition ', toString(i), '> condition ', toString(j)))
    print(paste(sep='', 't(',
          round(t$parameter), ') = ',
          format(round(t$statistic, 2), nsmall=2), ', p = ',
          format(round(t$p.value, 2), nsmall=2), ', d = ',
          format(round(t$statistic^2 / sqrt(t$parameter), 2), nsmall=2))
	)
  }
}


## are there differences in intervention between conditions (only 1 throuh 4)?
d <- data[block %in% 13:28 , mean(accuracy), .(condition, subject, block)]
fm <- lm(V1 ~ condition*block, data=d)
anov <- anova(fm)
print(anov)
pairwise.t.test(d$V1, d$condition, alternative = 'less', p.adjust.method = "none")

print('Effect of Condition ')
paste(sep='', 'F(',
	round(anov$Df[1]), ',',
	round(anov$Df[4]), ') = ',
	format(round(anov$F[1], 2), nsmall=2), ', p = ',
	format(round(anov$Pr[1], 2), nsmall=2), ', Omega = ',
	format(round(anov$Sum[1]/sum(anov$Sum), 2), nsmall=2)
	)

print('Effect of Block ')
paste(sep='', 'F(',
	round(anov$Df[2]), ',',
	round(anov$Df[4]), ') = ',
	format(round(anov$F[2], 2), nsmall=2), ', p = ',
	format(round(anov$Pr[2], 2), nsmall=2), ', Omega = ',
	format(round(anov$Sum[2]/sum(anov$Sum), 2), nsmall=2)
	)

print('Effect of Interaction')
paste(sep='', 'F(',
	round(anov$Df[3]), ',',
	round(anov$Df[4]), ') = ',
	format(round(anov$F[3], 2), nsmall=2), ', p = ',
	format(round(anov$Pr[3], 2), nsmall=2), ', Omega = ',
	format(round(anov$Sum[3]/sum(anov$Sum), 2), nsmall=2)
	)

ddd <- d[, mean(V1), .(condition, subject)]
for(i in 1:5) {
  for(j in 1:5) {
    t <- t.test(d[condition==toString(i)]$V1,ddd[condition==toString(j)]$V1)
    print(paste('condition ', toString(i), '> condition ', toString(j)))
    print(paste(sep='', 't(',
          round(t$parameter), ') = ',
          format(round(t$statistic, 2), nsmall=2), ', p = ',
          format(round(t$p.value, 2), nsmall=2), ', d = ',
          format(round(t$statistic^2 / sqrt(t$parameter), 2), nsmall=2))
	)
  }
}

## are there differences in savings between conditions?
fm <- lm(V1 ~ condition*block, data=savings_per_block)
anov <- anova(fm)
pairwise.t.test(savings$savings, savings$condition, alternative = 'greater', p.adjust.method = "none")

print('Effect of Condition ')
paste(sep='', 'F(',
	round(anov$Df[1]), ',',
	round(anov$Df[4]), ') = ',
	format(round(anov$F[1], 2), nsmall=2), ', p = ',
	format(round(anov$Pr[1], 2), nsmall=2), ', Omega = ',
	format(round(anov$Sum[1]/sum(anov$Sum), 2), nsmall=2)
	)

print('Effect of Block ')
paste(sep='', 'F(',
	round(anov$Df[2]), ',',
	round(anov$Df[4]), ') = ',
	format(round(anov$F[2], 2), nsmall=2), ', p = ',
	format(round(anov$Pr[2], 2), nsmall=2), ', Omega = ',
	format(round(anov$Sum[2]/sum(anov$Sum), 2), nsmall=2)
	)

print('Effect of Interaction')
paste(sep='', 'F(',
	round(anov$Df[3]), ',',
	round(anov$Df[4]), ') = ',
	format(round(anov$F[3], 2), nsmall=2), ', p = ',
	format(round(anov$Pr[3], 2), nsmall=2), ', Omega = ',
	format(round(anov$Sum[3]/sum(anov$Sum), 2), nsmall=2)
	)

for(i in 1:5) {
  for(j in 1:5) {
    t <- t.test(savings[condition==toString(i)]$savings,
                savings[condition==toString(j)]$savings,
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

## is there asvings greater than zero in any condition?
savings[, t.test(savings, alternative='greater'), .(condition)]
savings_per_block[, t.test(V1, alternative='greater'), .(condition, block)]

## Numerical Stroop stats
for (i in 1:4) {
  print(mean(data[condition==i, mean(wmAcc[trial%in%which(wmRT!=0)]), .(condition,subject)]$V1))
}

fm <- lm(savings ~ condition*dt, data=dt)
anova(fm)

## can we figure out what drives savings and possibly rule out the fatigue
## hypothesis?
## data[, condition := as.integer(condition)]
## data[, subject := as.integer(subject)]
## savings[, condition := as.integer(condition)]
## savings[, subject := as.integer(subject)]

## data[, savings := mean(accuracy[block %in% 29:34] - accuracy[block %in% 1:6]), .(condition, subject)]
## data[, savings := mean(accuracy[block %in% 29] - accuracy[block %in% 1]), .(condition, subject)]

## data[, dtacc := mean(wmAcc[trial %in% which(wmRT != 0)]), .(condition, subject)]
## data[, dtrt := mean(wmRT[trial %in% which(wmRT != 0)]), .(condition, subject)]
## data[, acmean := mean(accuracy[block %in% 1:12]), .(condition, subject)]
## data[, intmean := mean(accuracy[block %in% 13:28]), .(condition, subject)]
## data[, intmeandt := mean(accuracy[block %in% 13:28 & trial %in% which(wmRT != 0)]), .(condition, subject)]
## data[, intdur := length(which(wmRT != 0)), .(condition,subject)]
## data[, reacmean := mean(accuracy[block %in% 29:34]), .(condition, subject)]
## data[, rtmeanac := mean(rt[block %in% 1:12]), .(condition, subject)]
## data[, rtmeanint := mean(rt[block %in% 13:28]), .(condition, subject)]
## data[, rtmeanreac := mean(rt[block %in% 29:34]), .(condition, subject)]
## data[, time := sum(c(dtrt,rtmeanac,rtmeanint),na.rm=TRUE), .(condition,subject)]

## data[, dual_cnd := ifelse(condition==5,0,1)]

## d <- data[condition %in% 1:5, head(.SD,1) ,.(condition, subject)]

## ## mod <- savings ~ time+dtacc+dtrt+acmean+intmean+intdur+rtmeanac+rtmeanint+rtmeanreac
## mod <- savings ~ time
## fm <- lm(mod, data=d)
## summary(fm)

## mod <- savings ~ dtacc + intmean + acmean
## fm <- lm(mod, data=d)
## summary(fm)

## pdf('../figures/fig_save_rt_reac.pdf',width=8,height=5)
## par(mfrow=c(2,3),pty='s')
## for(i in 1:5) {
##   plot(savings ~ rtmeanreac, data=d[condition==i])
##   fm <- lm(savings ~ rtmeanreac, data=d[condition==i])
##   print(i)
##   print(summary(fm))
##   abline(fm)
## }
## boxplot(rtmeanreac ~ condition, data=d)
## dev.off()

## pdf('../figures/fig_save_time.pdf',width=8,height=5)
## par(mfrow=c(2,3),pty='s')
## for(i in 1:5) {
##   plot(savings ~ time, data=d[condition==i])
##   fm <- lm(savings ~ time, data=d[condition==i])
##   print(i)
##   print(summary(fm))
##   abline(fm)
## }
## boxplot(time ~ condition, data=d)
## dev.off()



## pdf('../figures/fig_save_mixed.pdf',width=8,height=3)
## par(mfrow=c(1,4), pty='s')
## par(oma = c(1, 0, 0, 0))
## clrs <- brewer.pal(5, "Set1")

## plot(NA, type="n", xlim=c(.4,1), ylim=c(-.5,.5), xlab="Mean Dual-Task Accuracy",
##      ylab="Savings",cex.lab=1)

## mod <- savings ~ dtacc
## for(i in 1:5) {
##   points(mod, data=d[condition==i], col=clrs[i])
##   fm <- lm(mod, data=d[condition==i])
##   abline(fm, col=clrs[i], lwd=1.5)
## }
## mtext('A',3)


## plot(NA, type="n", xlim=c(.2,.8), ylim=c(-.5,.5), xlab="Mean Intervention Accuracy",
##      ylab="Savings",cex.lab=1)

## mod <- savings ~ intmean
## for(i in 1:5) {
##   points(mod, data=d[condition==i], col=clrs[i])
##   fm <- lm(mod, data=d[condition==i])
##   abline(fm, col=clrs[i], lwd=1.5)
##   print(summary(fm))
## }
## mtext('B',3)

## plot(NA, type="n", xlim=c(.2,.85), ylim=c(-.5,.5), xlab="Mean Acquisition Accuracy",
##      ylab="Savings",cex.lab=1)

## mod <- savings ~ acmean
## for(i in 1:5) {
##   points(mod, data=d[condition==i], col=clrs[i])
##   fm <- lm(mod, data=d[condition==i])
##   abline(fm, col=clrs[i], lwd=1)
## }
## mtext('C',3)


## plot(NA, type="n", xlim=c(500, 10000), ylim=c(-.5,.5), xlab="Total Experiment Time",
##      ylab="Savings",cex.lab=1)

## mod <- savings ~ time
## for(i in 1:5) {
##   points(mod, data=d[condition==i], col=clrs[i])
##   fm <- lm(mod, data=d[condition==i])
##   abline(fm, col=clrs[i], lwd=1)
## }
## mtext('D',3)

## lgnd_txt <- c('Condition 1','Condition 2','Condition 3','Condition 4','No Dual-Task Control')
## par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
## plot.new()
## legend("bottom", lgnd_txt, xpd = TRUE, horiz = TRUE, inset = c(0, 0), bty = "n",
##        lty=1, lwd=1.5, col=clrs, cex=1, text.width=c(.45,.45,.45,.45,.45)*.5)

## dev.off()




## pdf('../figures/fig_save_mixed_2.pdf',width=8,height=3)
## par(mfrow=c(1,4), pty='s')
## par(oma = c(1, 0, 0, 0))
## clrs <- brewer.pal(5, "Set1")

## plot(NA, type="n", xlim=c(.4,1), ylim=c(-.5,.5), xlab="Mean Dual-Task Accuracy",
##      ylab="Savings",cex.lab=1)

## mod <- savings ~ dtacc
## points(mod, data=d)
## fm <- lm(mod, data=d)
## abline(fm, lwd=1.5)
## mtext('A',3)


## plot(NA, type="n", xlim=c(.2,.8), ylim=c(-.5,.5), xlab="Mean Intervention Accuracy",
##      ylab="Savings",cex.lab=1)

## mod <- savings ~ intmean
## points(mod, data=d)
## fm <- lm(mod, data=d)
## abline(fm, lwd=1.5)
## print(summary(fm))
## mtext('B',3)

## plot(NA, type="n", xlim=c(.2,.85), ylim=c(-.5,.5), xlab="Mean Acquisition Accuracy",
##      ylab="Savings",cex.lab=1)

## mod <- savings ~ acmean
## points(mod, data=d)
## fm <- lm(mod, data=d)
## abline(fm, lwd=1)
## mtext('C',3)


## plot(NA, type="n", xlim=c(500, 10000), ylim=c(-.5,.5), xlab="Total Experiment Time",
##      ylab="Savings",cex.lab=1)

## mod <- savings ~ time
## points(mod, data=d)
## fm <- lm(mod, data=d)
## abline(fm, lwd=1)
## mtext('D',3)

## dev.off()
