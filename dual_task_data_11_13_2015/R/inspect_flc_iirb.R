pdf("../figures/fig_learning_curves.pdf",width=10,height=10) 

xlim <- c(1,num_blocks)
ylim <- c(0,1)

# make figures
par(mfrow=c(2,2), pty="s")

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

rfb <- which(data[condition==1 & subject==5]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==1 & subject==5]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))



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

rfb <- which(data[condition==2 & subject==5]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==2 & subject==5]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))



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

rfb <- which(data[condition==3 & subject==2]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==3 & subject==2]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))



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

rfb <- which(data[condition==4 & subject==3]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==4 & subject==3]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))

dev.off()
