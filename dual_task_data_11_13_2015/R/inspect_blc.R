setkey(data,condition,subject,block)
mean_per_subject <- setnames(data[, .(mean(cat == resp), mean(rt)), .(condition, subject, block)], c("V1","V2"), c("acc_mean","rt_mean"))
err_per_subject <- setnames(data[, .(sd(cat == resp), sd(rt)/sqrt(subs_counts[condition, N])), .(condition, subject, block)], c("V1","V2"), c("acc_sd","rt_sd"))
mean_per_subject <- mean_per_subject[err_per_subject]

setkey(mean_per_subject,condition,block)
mean_per_block <- setnames(mean_per_subject[, .(mean(acc_mean), mean(rt_mean)), .(condition, block)], c("V1","V2"), c("acc_mean","rt_mean"))
err_per_block <- setnames(mean_per_subject[, .(sd(acc_mean)/sqrt(subs_counts[condition, N]), sd(rt_mean)/sqrt(subs_counts[condition, N])), .(condition, block)], c("V1","V2"), c("acc_err","rt_err"))
mean_per_block <- mean_per_block[err_per_block]

# compute and plot backward learning curves (BLC)
criterion_blc <- 0.5

mean_per_subject_blc <- mean_per_subject[block %in% 29:34]
mean_per_subject_blc[, block_blc := block - head(block[which(acc_mean >= criterion_blc)],1), .(condition, subject)]

setkey(mean_per_subject_blc,condition,block_blc)
mean_per_block_blc <- setnames(mean_per_subject_blc[, mean(acc_mean), .(condition,block_blc)], 'V1', 'acc')
# err_per_block_blc <- setnames(mean_per_subject_blc[, sem(acc_mean), .(condition,block_blc)], 'V1', 'err')
# mean_per_block_blc <- mean_per_block_blc[err_per_block_blc]

pdf("../figures/fig_blc_reac.pdf",width=7,height=10) 

par(mfrow=c(2,2), pty="s")
xlim<-c(-5,5)
ylim<-c(0.25,0.75)

plot(1, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy", font.lab = 2)
points(acc ~ block_blc, data=mean_per_block_blc[condition==1], lwd = 2, col='red')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==1], lwd = 2, col='red')
points(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
legend(
	'topleft',
	c('Dual-Task', 'Control'),
	fill=c('red','blue')
	)

plot(1, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy", font.lab = 2)
points(acc ~ block_blc, data=mean_per_block_blc[condition==2], lwd = 2, col='red')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==2], lwd = 2, col='red')
points(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
legend(
	'topleft',
	c('Dual-Task', 'Control'),
	fill=c('red','blue')
	)

plot(1, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy", font.lab = 2)
points(acc ~ block_blc, data=mean_per_block_blc[condition==3], lwd = 2, col='red')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==3], lwd = 2, col='red')
points(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
legend(
	'topleft',
	c('Dual-Task', 'Control'),
	fill=c('red','blue')
	)

plot(1, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy", font.lab = 2)
points(acc ~ block_blc, data=mean_per_block_blc[condition==4], lwd = 2, col='red')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==4], lwd = 2, col='red')
points(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
legend(
	'topleft',
	c('Dual-Task', 'Control'),
	fill=c('red','blue')
	)

mtext("Backwards Learning Curves --- Reacquisition Phase", side = 3, line = -5, outer = TRUE)


dev.off()

# ====================================================================================================================
# ====================================================================================================================

# Do it again for acquisition blocks

setkey(data,condition,subject,block)
mean_per_subject <- setnames(data[, .(mean(cat == resp), mean(rt)), .(condition, subject, block)], c("V1","V2"), c("acc_mean","rt_mean"))
err_per_subject <- setnames(data[, .(sd(cat == resp), sd(rt)/sqrt(subs_counts[condition, N])), .(condition, subject, block)], c("V1","V2"), c("acc_sd","rt_sd"))
mean_per_subject <- mean_per_subject[err_per_subject]

setkey(mean_per_subject,condition,block)
mean_per_block <- setnames(mean_per_subject[, .(mean(acc_mean), mean(rt_mean)), .(condition, block)], c("V1","V2"), c("acc_mean","rt_mean"))
err_per_block <- setnames(mean_per_subject[, .(sd(acc_mean)/sqrt(subs_counts[condition, N]), sd(rt_mean)/sqrt(subs_counts[condition, N])), .(condition, block)], c("V1","V2"), c("acc_err","rt_err"))
mean_per_block <- mean_per_block[err_per_block]

# compute and plot backward learning curves (BLC)
criterion_blc <- 0.5

mean_per_subject_blc <- mean_per_subject[block %in% 1:12]
mean_per_subject_blc[, block_blc := block - head(block[which(acc_mean >= criterion_blc)],1), .(condition, subject)]

setkey(mean_per_subject_blc,condition,block_blc)
mean_per_block_blc <- setnames(mean_per_subject_blc[, mean(acc_mean), .(condition,block_blc)], 'V1', 'acc')
# err_per_block_blc <- setnames(mean_per_subject_blc[, sem(acc_mean), .(condition,block_blc)], 'V1', 'err')
# mean_per_block_blc <- mean_per_block_blc[err_per_block_blc]

pdf("../figures/fig_blc_ac.pdf",width=7,height=10) 

par(mfrow=c(2,2), pty="s")
xlim<-c(-5,5)
ylim<-c(0.25,0.75)

plot(1, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy", font.lab = 2)
points(acc ~ block_blc, data=mean_per_block_blc[condition==1], lwd = 2, col='red')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==1], lwd = 2, col='red')
points(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
legend(
	'topleft',
	c('Dual-Task', 'Control'),
	fill=c('red','blue')
	)

plot(1, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy", font.lab = 2)
points(acc ~ block_blc, data=mean_per_block_blc[condition==2], lwd = 2, col='red')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==2], lwd = 2, col='red')
points(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
legend(
	'topleft',
	c('Dual-Task', 'Control'),
	fill=c('red','blue')
	)

plot(1, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy", font.lab = 2)
points(acc ~ block_blc, data=mean_per_block_blc[condition==3], lwd = 2, col='red')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==3], lwd = 2, col='red')
points(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
legend(
	'topleft',
	c('Dual-Task', 'Control'),
	fill=c('red','blue')
	)

plot(1, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy", font.lab = 2)
points(acc ~ block_blc, data=mean_per_block_blc[condition==4], lwd = 2, col='red')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==4], lwd = 2, col='red')
points(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
lines(acc ~ block_blc, data=mean_per_block_blc[condition==5], lwd = 2, col='blue')
legend(
	'topleft',
	c('Dual-Task', 'Control'),
	fill=c('red','blue')
	)

mtext("Backwards Learning Curves --- Acquisition Phase", side = 3, line = -5, outer = TRUE)


dev.off()