library(lme4)
library(lmerTest)
library(scales)
library(data.table)
library(scatterplot3d)

rm( list = ls() )

# get a list of .txt file names in the directory of interest and store in a list
filenames_4b1 <- list.files(paste('~txtData', sep=''), pattern=paste('^', 'un4b1', sep=''), full.names=TRUE)
filenames_4b2 <- list.files(paste('~txtData', sep=''), pattern=paste('^', 'un4b2', sep=''), full.names=TRUE)
filenames_4b3 <- list.files(paste('~txtData', sep=''), pattern=paste('^', 'un4b3', sep=''), full.names=TRUE)
filenames_4b4 <- list.files(paste('~txtData', sep=''), pattern=paste('^', 'un4b4', sep=''), full.names=TRUE)
filenames_4bc <- list.files(paste('~txtData', sep=''), pattern=paste('^', 'un4bc', sep=''), full.names=TRUE)

col_names <- c(
'Block',
'x',
'y',
'cat',
'resp',
'randTrialCR',
'Accuracy',
'rt',
'FeedbackGiven',
'feedbackType',
'wmAcc',
'wmRT', 
'meanWM'
)

# read files into data.tables
ldf_4b1 <- lapply(filenames_4b1, function(z) {z<-fread(z); setnames(z,col_names)})
ldf_4b2 <- lapply(filenames_4b2, function(z) {z<-fread(z); setnames(z,col_names)})
ldf_4b3 <- lapply(filenames_4b3, function(z) {z<-fread(z); setnames(z,col_names)})
ldf_4b4 <- lapply(filenames_4b4, function(z) {z<-fread(z); setnames(z,col_names)})
ldf_4bc <- lapply(filenames_4bc, function(z) {z<-fread(z); setnames(z,col_names)})

# Add subject column
ldf_4b1 <- lapply(seq_along(ldf_4b1), function(z) ldf_4b1[[z]][, subject := rep(z, .N)])
ldf_4b2 <- lapply(seq_along(ldf_4b2), function(z) ldf_4b2[[z]][, subject := rep(z, .N)])
ldf_4b3 <- lapply(seq_along(ldf_4b3), function(z) ldf_4b3[[z]][, subject := rep(z, .N)])
ldf_4b4 <- lapply(seq_along(ldf_4b4), function(z) ldf_4b4[[z]][, subject := rep(z, .N)])
ldf_4bc <- lapply(seq_along(ldf_4bc), function(z) ldf_4bc[[z]][, subject := rep(z, .N)]) 

# bind list of data.tables into one giant data.table
data_4b1 <- rbindlist(ldf_4b1)
data_4b2 <- rbindlist(ldf_4b2)
data_4b3 <- rbindlist(ldf_4b3)
data_4b4 <- rbindlist(ldf_4b4)
data_4bc <- rbindlist(ldf_4bc)

# add condition column
data_4b1[, condition := rep(1,.N)]
data_4b2[, condition := rep(2,.N)]
data_4b3[, condition := rep(3,.N)]
data_4b4[, condition := rep(4,.N)]
data_4bc[, condition := rep(5,.N)]

# add filename column
data_4b1[, filename := rep(filenames_4b1, 1, each=850)]
data_4b2[, filename := rep(filenames_4b2, 1, each=850)]
data_4b3[, filename := rep(filenames_4b3, 1, each=850)]
data_4b4[, filename := rep(filenames_4b4, 1, each=850)]
data_4bc[, filename := rep(filenames_4bc, 1, each=850)]

# combine into single data.table
data <- rbind(data_4b1,data_4b2,data_4b3,data_4b4,data_4bc)

# delete packaged block column and add our own plus a trial column
num_trials <- max(data[, .N, .(condition,subject)]$N)
block_size <- 25
num_blocks <- num_trials / block_size

data[, trial := rep(1:num_trials, .N/num_trials)]
data[, Block := NULL]
data[, block := rep(1:num_blocks, .N/num_trials, each=block_size)]

# delete packaged accuray and replace with our own
data[, Accuracy := NULL]
data[, accuracy := as.numeric(cat == resp)]

# ====================================================================================================================
# ====================================================================================================================

# add original unlearning data
filenames_ext5 <- list.files(paste('../nc_25_data', sep=''), pattern=paste('^', 'ext5', sep=''), full.names=TRUE)

col_names <- c(
'1',
'cat',
'x',
'y',
'5',
'resp',
'rt',
'8'
)

ldf_ext5 <- lapply(filenames_ext5, function(z) {z<-fread(paste("sed -e 's/^[ \t]*//' < ", z, "| tr -s [:space:]")); setnames(z,col_names)})
ldf_ext5 <- lapply(seq_along(ldf_ext5), function(z) ldf_ext5[[z]][, subject := rep(z, .N)]) 
data_ext5 <- rbindlist(ldf_ext5)

num_trials <- 900
block_size <- 25
num_blocks <- num_trials / block_size

data_ext5[, condition := rep(6,.N)]
data_ext5[, trial := rep(1:num_trials, .N/num_trials)]
data_ext5[, block := rep(1:num_blocks, .N/num_trials, each=block_size)]
data_ext5[, accuracy := as.numeric(cat == resp)]

# ====================================================================================================================
# ====================================================================================================================

data_2 <- rbind(data[, .(condition, subject, trial, block, cat,x,y,resp)], data_ext5[, .(condition, subject, trial, block, cat,x,y,resp)])

# ====================================================================================================================
# ====================================================================================================================

subs_counts_pre <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

exc_crit <- .4

# exclude participants with final training block acc < 40%
exc_subs <- data[trial %in% 201:300, mean(.SD[,accuracy]) < exc_crit, .(condition,subject), .SDcols=c('accuracy')]
exc_subs[is.na(exc_subs)] <- TRUE
exc_subs <- exc_subs[exc_subs$V1]

# perform the exclusions
data <- data[!(condition==1 & subject %in% exc_subs[condition==1, subject])]
data <- data[!(condition==2 & subject %in% exc_subs[condition==2, subject])]
data <- data[!(condition==3 & subject %in% exc_subs[condition==3, subject])]
data <- data[!(condition==4 & subject %in% exc_subs[condition==4, subject])]
data <- data[!(condition==5 & subject %in% exc_subs[condition==5, subject])]

subs_counts <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

subs_counts_acc <- subs_counts

# ====================================================================================================================
# ==============================================================================

exc_crit <- .85

# exclude participants with crappy dual-task
exc_subs <- data[condition!=5, mean(wmAcc[trial %in% which(wmRT != 0)]) < .8, .(condition,subject)]
exc_subs[is.na(exc_subs)] <- TRUE
exc_subs <- exc_subs[exc_subs$V1]

# perform the exclusions
data <- data[!(condition==1 & subject %in% exc_subs[condition==1, subject])]
data <- data[!(condition==2 & subject %in% exc_subs[condition==2, subject])]
data <- data[!(condition==3 & subject %in% exc_subs[condition==3, subject])]
data <- data[!(condition==4 & subject %in% exc_subs[condition==4, subject])]
data <- data[!(condition==5 & subject %in% exc_subs[condition==5, subject])]

subs_counts <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

subs_counts_dual <- subs_counts

# ====================================================================================================================
# ====================================================================================================================
# Todd's requests

# create list of included participants --- file names
included_subs <- unique(setnames(data[,.(condition,subject,filename)],c("condition","subject","filename")))

# included subjects block by block data file
setkey(data,condition,subject,block)
mean_per_subject <- setnames(data[, .(mean(cat == resp), mean(rt)), .(condition, subject, block)], c("V1","V2"), c("acc_mean","rt_mean"))

setkey(mean_per_subject,condition,block)
mean_per_block <- setnames(mean_per_subject[, .(mean(acc_mean), mean(rt_mean)), .(condition, block)], c("V1","V2"), c("acc_mean","rt_mean"))
err_per_block <- setnames(mean_per_subject[, .(sd(acc_mean)/sqrt(subs_counts[condition, N]), sd(rt_mean)/sqrt(subs_counts[condition, N])), .(condition, block)], c("V1","V2"), c("acc_err","rt_err"))
mean_per_block <- mean_per_block[err_per_block]

write.table(included_subs, file = "included_subs.txt", row.names = FALSE)
write.table(mean_per_subject, file = "mean_per_subject.txt", row.names = FALSE)

# ====================================================================================================================
# ====================================================================================================================

plot_err_bars <- function(x,y,err,col) {
	segments(x, y+err, x, y-err, col=col, lwd=2, lty=1)
}

# ====================================================================================================================
# ====================================================================================================================

pdf("fig_learning_curves.pdf",width=10,height=10) 

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

rfb <- which(data[condition==1 & subject==min(subject)]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==1 & subject==min(subject)]$wmRT != 0)
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

rfb <- which(data[condition==2 & subject==min(subject)]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==2 & subject==min(subject)]$wmRT != 0)
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

rfb <- which(data[condition==3 & subject==min(subject)]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==3 & subject==min(subject)]$wmRT != 0)
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

rfb <- which(data[condition==4 & subject==min(subject)]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==4 & subject==min(subject)]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))

dev.off()

# ====================================================================================================================
# ====================================================================================================================

savings <- setnames(data[, mean(accuracy[block %in% 29:34] - accuracy[block %in% 1:6]), .(condition, subject, filename)],'V1','savings')
savings_ext5 <- setnames(data_ext5[, mean(accuracy[block %in% 25:30] - accuracy[block %in% 1:6]), .(condition, subject, filename)],'V1','savings')

savings <- rbind(savings,savings_ext5)

pdf("fig_savings.pdf",width=10,height=7) 

# bar <- barplot( savings[, mean(savings), condition]$V1, ylim = c(-.15,.15) )
# plot_err_bars( bar, savings[, mean(savings), condition]$V1, savings[, sem(savings), condition]$V1, 'black' )
boxplot(savings ~ condition, data=savings, names=c('1','2','3','4','Control','Original'), xlab='Condition', ylab='Accuracy: Reacquisition - Acquisition')
points(savings ~ condition, data=savings)

abline(h=0, col='red')

dev.off()

write.table(savings, file = "savings_per_subject.txt", row.names = FALSE)

# ====================================================================================================================
# ====================================================================================================================

# give subjects unqiue numbers
data[, subject := subject + as.integer(condition*100), condition]
savings[, subject := subject + as.integer(condition*100), condition]

# make sure factors are treated as such
data[, condition := factor(condition)]
data[, subject := factor(subject)]
savings[, condition := factor(condition)]
savings[, subject := factor(subject)]


fm <- lm(savings ~ condition, data=savings)
anova(fm)

pairwise.t.test(savings$savings, savings$condition, p.adjust.method = "none")

savings[, t.test(savings), .(condition)]

