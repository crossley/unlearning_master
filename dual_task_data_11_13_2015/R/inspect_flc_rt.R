pdf("../figures/fig_learning_curves_rt.pdf",width=8,height=8) 
xlim <- c(1,num_blocks)
ylim <- c(0,4)

# make figures
## bottom, left, top and right
par(mfrow=c(2,2), pty="s")
## par(mfrow = c(1,4), oma = c(5,4,0,0) + 0.1, mar = c(0,0,1,1) + 0.1)

plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="RT")
lines(data[condition==1, mean(rt), block], ylim=ylim, col='red', lwd=2)
lines(data[condition==5, mean(rt), block], ylim=ylim, col='blue', lwd=2)
plot_err_bars(
	data[condition==1, mean(rt), block]$block,
	data[condition==1, mean(rt), block]$V1,
	data[condition==1, sd(rt)/sqrt(subs_counts[condition==1,N]), block]$V1,
	'red'
	)
plot_err_bars(
	data[condition==5, mean(rt), block]$block,
	data[condition==5, mean(rt), block]$V1,
	data[condition==5, sd(rt)/sqrt(subs_counts[condition==5,N]), block]$V1,
	'blue'
	)

rfb <- which(data[condition==1 & subject==105]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==1 & subject==105]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))



## plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Rt", yaxt='n')
plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="RT")
lines(data[condition==2, mean(rt), block], ylim=ylim, col='red', lwd=2)
lines(data[condition==5, mean(rt), block], ylim=ylim, col='blue', lwd=2)
plot_err_bars(
	data[condition==2, mean(rt), block]$block,
	data[condition==2, mean(rt), block]$V1,
	data[condition==2, sd(rt)/sqrt(subs_counts[condition==2,N]), block]$V1,
	'red'
	)
plot_err_bars(
	data[condition==5, mean(rt), block]$block,
	data[condition==5, mean(rt), block]$V1,
	data[condition==5, sd(rt)/sqrt(subs_counts[condition==5,N]), block]$V1,
	'blue'
	)

rfb <- which(data[condition==2 & subject==205]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==2 & subject==205]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))



## plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Rt", yaxt='n')
plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="RT")
lines(data[condition==3, mean(rt), block], ylim=ylim, col='red', lwd=2)
lines(data[condition==5, mean(rt), block], ylim=ylim, col='blue', lwd=2)
plot_err_bars(
	data[condition==3, mean(rt), block]$block,
	data[condition==3, mean(rt), block]$V1,
	data[condition==3, sd(rt)/sqrt(subs_counts[condition==3,N]), block]$V1,
	'red'
	)
plot_err_bars(
	data[condition==5, mean(rt), block]$block,
	data[condition==5, mean(rt), block]$V1,
	data[condition==5, sd(rt)/sqrt(subs_counts[condition==5,N]), block]$V1,
	'blue'
	)

rfb <- which(data[condition==3 & subject==301]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==3 & subject==301]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))



## plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Rt", yaxt='n')
plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="RT")
lines(data[condition==4, mean(rt), block], ylim=ylim, col='red', lwd=2)
lines(data[condition==5, mean(rt), block], ylim=ylim, col='blue', lwd=2)
plot_err_bars(
	data[condition==4, mean(rt), block]$block,
	data[condition==4, mean(rt), block]$V1,
	data[condition==4, sd(rt)/sqrt(subs_counts[condition==4,N]), block]$V1,
	'red'
	)
plot_err_bars(
	data[condition==5, mean(rt), block]$block,
	data[condition==5, mean(rt), block]$V1,
	data[condition==5, sd(rt)/sqrt(subs_counts[condition==5,N]), block]$V1,
	'blue'
	)

rfb <- which(data[condition==4 & subject==401]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==4 & subject==401]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))

dev.off()
