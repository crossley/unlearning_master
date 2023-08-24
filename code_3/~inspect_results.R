## library(lme4)
## library(lmerTest)
library(scales)
library(data.table)

rm( list = ls() )

# get a list of .txt file names in the directory of interest and store in a list
filenames_ext5 <- list.files(paste('.', sep=''), pattern=paste('^', 'ext5', sep=''), full.names=TRUE)
filenames_ext6 <- list.files(paste('.', sep=''), pattern=paste('^', 'ext6', sep=''), full.names=TRUE)

# set col_names
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

# read files into data.tables
ldf_ext5 <- lapply(filenames_ext5, function(z) {z<-fread(paste("sed -e 's/^[ \t]*//' < ", z, "| tr -s [:space:]")); setnames(z,col_names)})
ldf_ext6 <- lapply(filenames_ext6, function(z) {z<-fread(paste("sed -e 's/^[ \t]*//' < ", z, "| tr -s [:space:]")); setnames(z,col_names)})

# Add subject column
ldf_ext5 <- lapply(seq_along(ldf_ext5), function(z) ldf_ext5[[z]][, subject := rep(z, .N)])
ldf_ext6 <- lapply(seq_along(ldf_ext6), function(z) ldf_ext6[[z]][, subject := rep(z, .N)])

# bind list of data.tables into one giant data.table
data_ext5 <- rbindlist(ldf_ext5)
data_ext6 <- rbindlist(ldf_ext6)

# add condition column
data_ext5[, condition := rep(1,.N)]
data_ext6[, condition := rep(2,.N)]

# combine into single data.table
data <- rbind(data_ext5,data_ext6)

# delete packaged block column and add our own plus a trial column
num_trials <- max(data[, .N, .(condition,subject)]$N)
block_size <- 25
num_blocks <- num_trials / block_size

data[, trial := rep(1:num_trials, .N/num_trials)]
data[, block := rep(1:num_blocks, .N/num_trials, each=block_size)]
data[, accuracy := as.numeric(cat == resp)]


# ====================================================================================================================
# ====================================================================================================================
subs_counts <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

setkey(data,condition,subject,block)
mean_per_subject <- setnames(data[, .(mean(cat == resp), mean(rt)), .(condition, subject, block)], c("V1","V2"), c("acc_mean","rt_mean"))
# err_per_subject <- setnames(data[, .(sd(cat == resp), sd(rt)/sqrt(subs_counts[condition, N])), .(condition, subject, block)], c("V1","V2"), c("acc_sd","rt_sd"))
# mean_per_subject <- mean_per_subject[err_per_subject]

setkey(mean_per_subject,condition,block)
mean_per_block <- setnames(mean_per_subject[, .(mean(acc_mean), mean(rt_mean)), .(condition, block)], c("V1","V2"), c("acc_mean","rt_mean"))
err_per_block <- setnames(mean_per_subject[, .(sd(acc_mean)/sqrt(subs_counts[condition, N]), sd(rt_mean)/sqrt(subs_counts[condition, N])), .(condition, block)], c("V1","V2"), c("acc_err","rt_err"))
mean_per_block <- mean_per_block[err_per_block]

# ====================================================================================================================
# ====================================================================================================================

subs_counts_pre <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

exc_crit <- .4

# exclude participants with final training block acc < 40%
exc_subs <- data[trial %in% 201:300, mean(.SD[,accuracy]) < exc_crit, .(condition,subject), .SDcols=c('accuracy')]
exc_subs[is.na(exc_subs)] <- TRUE
exc_subs <- exc_subs[exc_subs$V1]

# exclude participants based on dual-task performance
# data[, mean(wmAcc[trial %in% which(wmRT != 0)]), .(condition,subject)]

# perform the exclusions
data <- data[!(condition==1 & subject %in% exc_subs[condition==1, subject])]
data <- data[!(condition==2 & subject %in% exc_subs[condition==2, subject])]

subs_counts <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

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
par(mfrow=c(1,1), pty="s")

plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy")
lines(data[condition==1, mean(accuracy), block], ylim=ylim, col='red', lwd=2)
lines(data[condition==2, mean(accuracy), block], ylim=ylim, col='blue', lwd=2)

dev.off()

# ====================================================================================================================
# ====================================================================================================================

savings <- setnames(data[, mean(accuracy[block %in% 29:34] - accuracy[block %in% 1:6]), .(condition, subject)],'V1','savings')

pdf("fig_savings_hist.pdf",width=10,height=7) 

par(mfrow=c(1,2), pty="s")

hist(savings[condition==1,savings,subject]$savings, 10)
hist(savings[condition==2,savings,subject]$savings, 10)

dev.off()
