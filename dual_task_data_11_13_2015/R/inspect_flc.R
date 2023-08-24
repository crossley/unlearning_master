## pdf("../figures/fig_learning_curves.pdf",width=8.5,height=3)
pdf("../figures/fig_learning_curves.pdf",width=8,height=8)
xlim <- c(1,num_blocks)
ylim <- c(0,1)

# make figures
## bottom, left, top and right
par(mfrow=c(2,2), pty="s")
## par(mfrow = c(1,4), oma = c(5,4,0,0) + 0.1, mar = c(0,0,1,1) + 0.1)

plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy")
lines(data[condition==1, mean(accuracy), block], ylim=ylim, col='red', lwd=2)
lines(data[condition==5, mean(accuracy), block], ylim=ylim, col='blue', lwd=2)
plot_err_bars(
	data[condition==1, mean(accuracy), block]$block,
	data[condition==1, mean(accuracy), block]$V1,
	data[condition==1, sd(accuracy)/sqrt(subs_counts[condition==1,N]), block]$V1,
	'red'
	)
plot_err_bars(
	data[condition==5, mean(accuracy), block]$block,
	data[condition==5, mean(accuracy), block]$V1,
	data[condition==5, sd(accuracy)/sqrt(subs_counts[condition==5,N]), block]$V1,
	'blue'
	)

rfb <- which(data[condition==1 & subject==105]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)
abline(v=(rfb[length(rfb)]-1)/block_size)

dt <- which(data[condition==1 & subject==105]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size,
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))

mtext('A', side=3)

legend('top',
       c('No Dual-Task Control','Condition 1'),
       col=c('blue','red'),
       bty='n',
       lty=1
       )

## plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy", yaxt='n')
plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy")
lines(data[condition==2, mean(accuracy), block], ylim=ylim, col='red', lwd=2)
lines(data[condition==5, mean(accuracy), block], ylim=ylim, col='blue', lwd=2)
plot_err_bars(
	data[condition==2, mean(accuracy), block]$block,
	data[condition==2, mean(accuracy), block]$V1,
	data[condition==2, sd(accuracy)/sqrt(subs_counts[condition==2,N]), block]$V1,
	'red'
	)
plot_err_bars(
	data[condition==5, mean(accuracy), block]$block,
	data[condition==5, mean(accuracy), block]$V1,
	data[condition==5, sd(accuracy)/sqrt(subs_counts[condition==5,N]), block]$V1,
	'blue'
	)

rfb <- which(data[condition==2 & subject==205]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)
abline(v=(rfb[length(rfb)]-1)/block_size)

dt <- which(data[condition==2 & subject==205]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size,
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))

mtext('B', side=3)

legend('top',
       c('No Dual-Task Control','Condition 2'),
       col=c('blue','red'),
       bty='n',
       lty=1
       )

## plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy", yaxt='n')
plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy")
lines(data[condition==3, mean(accuracy), block], ylim=ylim, col='red', lwd=2)
lines(data[condition==5, mean(accuracy), block], ylim=ylim, col='blue', lwd=2)
plot_err_bars(
	data[condition==3, mean(accuracy), block]$block,
	data[condition==3, mean(accuracy), block]$V1,
	data[condition==3, sd(accuracy)/sqrt(subs_counts[condition==3,N]), block]$V1,
	'red'
	)
plot_err_bars(
	data[condition==5, mean(accuracy), block]$block,
	data[condition==5, mean(accuracy), block]$V1,
	data[condition==5, sd(accuracy)/sqrt(subs_counts[condition==5,N]), block]$V1,
	'blue'
	)

rfb <- which(data[condition==3 & subject==302]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)
abline(v=(rfb[length(rfb)]-1)/block_size)

dt <- which(data[condition==3 & subject==302]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size,
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))

mtext('C', side=3)

legend('top',
       c('No Dual-Task Control','Condition 3'),
       col=c('blue','red'),
       bty='n',
       lty=1
       )

## plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy", yaxt='n')
plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy")
lines(data[condition==4, mean(accuracy), block], ylim=ylim, col='red', lwd=2)
lines(data[condition==5, mean(accuracy), block], ylim=ylim, col='blue', lwd=2)
plot_err_bars(
	data[condition==4, mean(accuracy), block]$block,
	data[condition==4, mean(accuracy), block]$V1,
	data[condition==4, sd(accuracy)/sqrt(subs_counts[condition==4,N]), block]$V1,
	'red'
	)
plot_err_bars(
	data[condition==5, mean(accuracy), block]$block,
	data[condition==5, mean(accuracy), block]$V1,
	data[condition==5, sd(accuracy)/sqrt(subs_counts[condition==5,N]), block]$V1,
	'blue'
	)

rfb <- which(data[condition==4 & subject==402]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)
abline(v=(rfb[length(rfb)]-1)/block_size)

dt <- which(data[condition==4 & subject==402]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size,
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))

mtext('D', side=3)

legend('top',
       c('No Dual-Task Control','Condition 4'),
       col=c('blue','red'),
       bty='n',
       lty=1
       )

dev.off()
