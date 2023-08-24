library(scales)
library(data.table)
library(scatterplot3d)
library(grt)
library(pwr)
library(RColorBrewer)

rm( list = ls() )

# get a list of .txt file names in the directory of interest and store in a list
filenames_1 <- list.files(paste('txtData', sep=''), pattern=paste('^....._1.txt$', sep=''), full.names=TRUE)
filenames_2 <- list.files(paste('txtData', sep=''), pattern=paste('^....._2.txt$', sep=''), full.names=TRUE)

# 1 - Block
# 2 - X-Value
# 3 - Y-Value
# 4 - Y=X Category
# 5 - Response
# 6 - Y=-X Category
# 7 - Y=X Accuracy (shows what accuracy was/would have been had the trial been a Y=X trial)
# 8 - RT
# 9 - Accuracy Shown (This is what should be used for calculating subject accuracy. Shows accuracy of response, regardless of the underlying condition.
# 10 - Feedback Type (1: Y=X Training, 2: Y=-X Training, 3: Y=X Testing, 4: Y=-X Testing)
# Training simply means that feedback was given on that trial and Testing means that no feedback was given to participants on that trial.)

col_names <- c(
'block',
'x',
'y',
'cat_pos_slope',
'resp',
'cat_neg_slope',
'acc_pos_slope',
'rt',
'acc_shown',
'feedback_type'
)

# read files into data.tables
ldf_1 <- lapply(filenames_1, function(z) {z<-fread(z); setnames(z,col_names)})
ldf_2 <- lapply(filenames_2, function(z) {z<-fread(z); setnames(z,col_names)})

# Add subject column
ldf_1 <- lapply(seq_along(ldf_1), function(z) ldf_1[[z]][, subject := rep(z, .N)])
ldf_2 <- lapply(seq_along(ldf_2), function(z) ldf_2[[z]][, subject := rep(z, .N)])

# bind list of data.tables into one giant data.table
data_1 <- rbindlist(ldf_1)
data_2 <- rbindlist(ldf_2)

# add condition column
data_1[, condition := rep(1,.N)]
data_2[, condition := rep(1,.N)]

# add day column
data_1[, day := rep(1,.N)]
data_2[, day := rep(2,.N)]

# delete packaged block column and add our own plus a trial column
num_trials <- 800
block_size <- 50
num_blocks <- num_trials / block_size

data_1[, trial := rep(1:num_trials, .N/num_trials)]
data_1[, block := NULL]
data_1[, block := rep(1:num_blocks, .N/num_trials, each=block_size)]

data_2[, trial := rep((num_trials+1):1600, .N/num_trials)]
data_2[, block := NULL]
data_2[, block := rep((num_blocks+1):(2*num_blocks), .N/num_trials, each=block_size)]

# combine into single data.table
data <- rbind(data_1,data_2)

# ===================================================================================================================
# ===================================================================================================================

subs_counts_pre <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

exc_crit <- .0

# exclude participants with final training block acc < 40%
exc_subs <- data[trial %in% 501:600, mean(.SD[,acc_shown]) < exc_crit, .(condition,subject), .SDcols=c('acc_shown')]
exc_subs[is.na(exc_subs)] <- TRUE
exc_subs <- exc_subs[exc_subs$V1]

# perform the exclusions
data <- data[!(condition==1 & subject %in% exc_subs[condition==1, subject])]

subs_counts <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

# ===============================================================================================================
# ===============================================================================================================

setkey(data,condition,subject,block)

mean_per_subject <-
  setnames(data[, .(mean(acc_shown), mean(rt)), .(condition, subject, block)], c("V1","V2"), c("acc_mean","rt_mean"))

err_per_subject <-
  setnames(data[, .(sd(acc_shown), sd(rt)), .(condition, subject, block)], c("V1","V2"), c("acc_sd","rt_sd"))

mean_per_subject <- mean_per_subject[err_per_subject]



setkey(mean_per_subject,condition,block)

mean_per_block <-
  setnames(mean_per_subject[, .(mean(acc_mean), mean(rt_mean)), .(condition, block)], c("V1","V2"), c("acc_mean","rt_mean"))

err_per_block <-
  setnames(mean_per_subject[, .(sd(acc_mean)/sqrt(subs_counts[condition, N]), sd(rt_mean)/sqrt(subs_counts[condition, N])), .(condition, block)], c("V1","V2"), c("acc_err","rt_err"))

mean_per_block <- mean_per_block[err_per_block]

# ===============================================================================================================
# ===============================================================================================================

## plot_err_bars <- function(x,y,err,col) {
## 	segments(x, y+err, x, y-err, col=col, lwd=2, lty=1)
## }

## par(mfrow=c(1,1), pty="s")
## xlim<-c(1,64)
## ylim_acc<-c(0.5,1.0)

## plot(1, type="n", xlim=xlim, ylim=ylim_acc, xlab='Block', ylab='Accuracy', xaxt = "n", font.lab = 2)
## axis(side = 1, at = seq(2, 64, 2))

## # 600 trials y=x training
## lines(acc_mean ~ block, data=mean_per_block[block %in% 1:24], lwd = 2, col='red')
## abline(v=24.5,lty=2)

## # 200 trials y=-x training
## lines(acc_mean ~ block, data=mean_per_block[block %in% 25:32], lwd = 2, col='red')
## abline(v=32.5,lty=2)

## # 400 trials y=-x training
## lines(acc_mean ~ block, data=mean_per_block[block %in% 33:48], lwd = 2, col='red')
## abline(v=48.5,lty=2)

## # 200 trials y=x testing
## lines(acc_mean ~ block, data=mean_per_block[block %in% 49:56], lwd = 2, col='red')
## abline(v=56.5,lty=2)

## # 200 trials of y=-x testing
## lines(acc_mean ~ block, data=mean_per_block[block %in% 57:64], lwd = 2, col='red')
## abline(v=64.5,lty=2)

# ===============================================================================================================
# ===============================================================================================================

pdf('kp_all_subs.pdf', width=15, height=10)

par(mfrow=c(2,3), pty="s", cex.axis=1.5, cex.lab=2)

colors <- brewer.pal(6, "Dark2")

xlim<-c(1,64)
ylim_acc<-c(0.5,1.0)

for (i in 1:6) {

	plot(1, type="n", xlim=xlim, ylim=ylim_acc, xlab='Block', ylab='Accuracy', xaxt = "n", font.lab = 2)
	axis(side = 1, at = seq(2, 64, 2))

	# 600 trials y=x training
	lines(acc_mean ~ block, data=mean_per_subject[subject==i & block %in% 1:24], lwd = 2, col='red')
	abline(v=24.5,lty=2)

	# 200 trials y=-x training
	lines(acc_mean ~ block, data=mean_per_subject[subject==i & block %in% 25:32], lwd = 2, col='red')
	abline(v=32.5,lty=2)

	# 400 trials y=-x training
	lines(acc_mean ~ block, data=mean_per_subject[subject==i & block %in% 33:48], lwd = 2, col='red')
	abline(v=48.5,lty=2)

	# 200 trials y=x testing
	lines(acc_mean ~ block, data=mean_per_subject[subject==i & block %in% 49:56], lwd = 2, col='red')
	abline(v=56.5,lty=2)

	# 200 trials of y=-x testing
	lines(acc_mean ~ block, data=mean_per_subject[subject==i & block %in% 57:64], lwd = 2, col='red')
	abline(v=64.5,lty=2)
}

dev.off()

# ===============================================================================================================
# ===============================================================================================================

## fit_dec_bnd_models <- function(z) {

## 	z_lim <- 7
## 	opt <- 'optim'
## 	ctrl <- list(maxit=1000, lmm=100)

## 	z_lim <- Inf
## 	opt <- 'nlminb'
## 	ctrl <- list(iter.max=5000, eval.max=5000)

## 	# define models to fit
## 	fit_unix <- glc(resp ~ x, data=z, zlimit=z_lim, opt=opt, control=ctrl)
## 	fit_uniy <- glc(resp ~ y, data=z, zlimit=z_lim, opt=opt, control=ctrl)
## 	fit_guess_fixed <- grg(z$resp, fixed=TRUE)
## 	fit_guess_rand <- grg(z$resp, fixed=FALSE)
##   fit_glc <- glc(resp ~ x + y, data=z, zlimit=z_lim, opt=opt, control=ctrl)

##   bic_summary <- data.frame(
##     unix = extractAIC(fit_unix, k=log(100))[2],
##     uniy = extractAIC(fit_uniy, k=log(100))[2],
##     glc = extractAIC(fit_glc, k=log(100))[2],
##     guess_fixed = extractAIC(fit_guess_fixed, k=log(100))[2],
##     guess_rand = extractAIC(fit_guess_rand, k=log(100))[2])
    
## 	best_model_name <- names(bic_summary[which(bic_summary == min(bic_summary))])

## 	## pdf(paste(, 'bounds.pdf'),width=7,height=10) 
## 	## par(mfrow=c(1,1))
## 	## plot(1, type='n', xlim=xlim, ylim=ylim_acc, xlab='', ylab='', xaxt = 'n', font.lab = 2)
## 	## dev.off()

## 	return(best_model_name)
## }

# ===============================================================================================================
# ===============================================================================================================

# add block_bnd to fit decision bound models
block_bnd_size <- 100
data[, block_bnd := rep(1:(.N/block_bnd_size), each=block_bnd_size), .(condition, subject)]

trials_pos <- c(1:600, 1201:1400)
trials_neg <- c(601:800, 801:1200, 1401:1600)

data[, cat := ifelse(trial %in% trials_pos, cat_pos_slope, cat_neg_slope)]

## data[, bnd := fit_dec_bnd_models(.SD), .(subject, block_bnd), .SDcols=c('cat','x','y','resp')]

## # build table for fits
## bnd_data <- data[, head(bnd,1), .(block_bnd, condition, subject)]
## bnd_data[V1=='guess_fixed']$V1 <- 'guess'
## bnd_data[V1=='guess_rand']$V1 <- 'guess'
## bnd_data[V1=='unix']$V1 <- '1D'
## bnd_data[V1=='uniy']$V1 <- '1D'
## bnd_table <- table(bnd_data$V1, bnd_data$block_bnd, bnd_data$condition)

## pdf('fig_bnd_fits.pdf',width=7,height=10) 
## colors <- brewer.pal(3, 'Set1')
## colors <- colors[c(2,3)]

## par(mfrow=c(1,1))
## barplot(
## 	bnd_table[,,1], 
## 	beside=TRUE, 
## 	legend = rownames(bnd_table[,,1]), 
## 	args.legend = list(x = 'topright', inset = c(0,-.1)), 
## 	col=colors,
## 	xlab='Block',
## 	ylab='Number of Participants',
## 	main='Decision Bound Model Fits',
## 	)
## dev.off()


# ===============================================================================================================
# ===============================================================================================================
data[, acc := cat == resp]
data[, mean_test_pos := mean(acc[which(trial %in% 1201:1400)]), subject]
data[, mean_test_neg := mean(acc[which(trial %in% 1401:1600)]), subject]

kp_thresh <- 0.8
data[, kp := (mean_test_pos > kp_thresh) & (mean_test_neg > kp_thresh)]

# ===============================================================================================================
# ===============================================================================================================

pdf('fig_kp.pdf',width=8.5,height=3)

layout(matrix(c(1,1,1,1,1,2,2,2,2,2,0,3,3,3,3,3,3,3,3,3,3), 1, 21, byrow = TRUE))

parorig <- par()
par(oma = c(0,0,0,0), mai = c(.3,.1,.2,.1))
## bottom, left, top and right

par(pty = 's')
plot(x~y,data=data[subject==1 & trial%in%trials_pos, .(x,y)], font.lab = 2,
col=data[trial%in%trials_pos, cat], xaxt = 'n', yaxt = 'n', xlab = '', ylab = '')
title('II Category I')

par(pty = 's')
plot(x~y,data=data[subject==1 & trial%in%trials_neg, .(x,y)], font.lab = 2,
col=data[trial%in%trials_neg, cat], xaxt = 'n', yaxt = 'n', xlab = '', ylab = '')
title('II Category II')

xlim<-c(1,32)
ylim_acc<-c(0.5,1.0)

par(pty = 'm')
plot(1, type="n", xlim=xlim, ylim=ylim_acc, xlab='Block', ylab='Accuracy', xaxt = "n", font.lab = 2)
axis(side = 1, at = seq(2,32, 2))

# 600 trials y=x training
lines(V1 ~ block, data=data[kp == TRUE & trial %in% c(1:600), mean(acc), block], lwd = 2, col='red')
lines(V1 ~ block, data=data[kp == FALSE & trial %in% c(1:600), mean(acc), block], lwd = 2, col='blue')
abline(v=24.5/2,lty=2)

# 200 trials y=-x training
lines(V1 ~ block, data=data[kp == TRUE & trial %in% c(601:800), mean(acc), block], lwd = 2, col='red')
lines(V1 ~ block, data=data[kp == FALSE & trial %in% c(601:800), mean(acc), block], lwd = 2, col='blue')
abline(v=32.5/2,lty=2)

# 400 trials y=-x training
lines(V1 ~ block, data=data[kp == TRUE & trial %in% c(801:1200), mean(acc), block], lwd = 2, col='red')
lines(V1 ~ block, data=data[kp == FALSE & trial %in% c(801:1200), mean(acc), block], lwd = 2, col='blue')
abline(v=48.5/2,lty=2)

# 200 trials y=x testing
lines(V1 ~ block, data=data[kp == TRUE & trial %in% c(1201:1400), mean(acc), block], lwd = 2, col='red')
lines(V1 ~ block, data=data[kp == FALSE & trial %in% c(1201:1400), mean(acc), block], lwd = 2, col='blue')
abline(v=56.5/2,lty=2)

# 200 trials of y=-x testing
lines(V1 ~ block, data=data[kp == TRUE & trial %in% c(1401:1600), mean(acc), block], lwd = 2, col='red')
lines(V1 ~ block, data=data[kp == FALSE & trial %in% c(1401:1600), mean(acc), block], lwd = 2, col='blue')
abline(v=64.5/2,lty=2)

dev.off()


## ggplot version
library(ggplot2)

data[, phase := NA]
data[, phase := ifelse(block <= 12 & is.na(phase), 1, phase)]
data[, phase := ifelse(block <= 16 & is.na(phase), 2, phase)]
data[, phase := ifelse(block <= 24 & is.na(phase), 3, phase)]
data[, phase := ifelse(block <= 28 & is.na(phase), 4, phase)]
data[, phase := ifelse(block <= 32 & is.na(phase), 5, phase)]

d <- data[kp==TRUE, mean(acc), .(block, phase, kp)]
ggplot(d, aes(x=block, y=V1, group=interaction(phase,kp), colour=kp)) +
  geom_line(size=1) +
  xlab('Block') +
  ylab('Accuracy') +
  ylim(0.5,1) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  geom_vline(xintercept=12.5, linetype=2) +
  geom_vline(xintercept=16.5, linetype=2) +
  geom_vline(xintercept=24.5, linetype=2) +
  geom_vline(xintercept=28.5, linetype=2) +
  scale_color_manual(values=c('black','blue'), guide=FALSE) +
  theme_classic() +
  theme(
      text = element_text(size=12),
      ## axis.title.x = element_text(size=14),
      ## axis.title.y = element_text(size=14),
      axis.line = element_blank(),
      panel.border = element_rect(colour = "black", fill=NA, size=0.5)
  )
ggsave('fig_kp_gg.pdf', width = 100, height = 50, units='mm')

## ggplot(data[phase==1], aes(x,y, colour=factor(cat), shape=factor(cat))) +
ggplot(data[phase==1], aes(x,y, colour=factor(cat))) +
  geom_point() +
  xlab('') +
  ylab('') +
  scale_color_manual(values=c('black','gray'), guide=FALSE) +
  theme_classic() +
  theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    panel.border = element_rect(colour = "black", fill=NA, size=1),
    legend.position="none"
  )
ggsave('AB_cat_1.pdf', width = 4, height = 4)


ggplot(data[phase==3], aes(x,y, colour=factor(cat))) +
  geom_point() +
  xlab('') +
  ylab('') +
  scale_color_manual(values=c('black','gray'), guide=FALSE) +
  theme_classic() +
  theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.line = element_blank(),
    panel.border = element_rect(colour = "black", fill=NA, size=1)
  )
ggsave('AB_cat_2.pdf', width = 4, height = 4)
