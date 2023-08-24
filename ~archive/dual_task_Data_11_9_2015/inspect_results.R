library(lme4); 
library(lmerTest);
library(scales)
library(data.table)

rm( list = ls() )

# get a list of .txt file names in the directory of interest and store in a list
filenames_4b1 <- list.files(paste('~txtData', sep=''), pattern=paste('^', 'un4b1', sep=''), full.names=TRUE)
filenames_4b2 <- list.files(paste('~txtData', sep=''), pattern=paste('^', 'un4b2', sep=''), full.names=TRUE)
filenames_4b3 <- list.files(paste('~txtData', sep=''), pattern=paste('^', 'un4b3', sep=''), full.names=TRUE)
filenames_4b4 <- list.files(paste('~txtData', sep=''), pattern=paste('^', 'un4b4', sep=''), full.names=TRUE)
filenames_4bc <- list.files(paste('~txtData', sep=''), pattern=paste('^', 'un4bc', sep=''), full.names=TRUE)

# set col_names
col_names <- c(
'Block',
'StimLength',
'StimOrient',
'StimCategory',
'Response',
'randTrialCR',
'Accuracy',
'RT',
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

# combine into single data.table
data <- rbind(data_4b1,data_4b2,data_4b3,data_4b4,data_4bc)

# delete packaged block column and add our own plus a trial column
num_trials <- max(data[, .N, .(condition,subject)]$N)
block_size <- 25
num_blocks <- num_trials / block_size

data[, trial := rep(1:num_trials, .N/num_trials)]
data[, Block := NULL]
data[, block := rep(1:num_blocks, .N/num_trials, each=block_size)]

# delete packaed accuray and replace with our own
data[, Accuracy := NULL]
data[, accuracy := as.numeric(StimCategory == Response)]

# ====================================================================================================================
# ====================================================================================================================

# exclude participants with final training block acc < 40%
exc_subs <- data[trial %in% 201:300, mean(.SD[,accuracy]) < .4, .(condition,subject), .SDcols=c('accuracy')]
exc_subs[is.na(exc_subs)] <- TRUE
exc_subs <- exc_subs[exc_subs$V1]

# exclude participants based on dual-task performance
# data[, mean(wmAcc[trial %in% which(wmRT != 0)]), .(condition,subject)]

# perform the exclusions
data <- data[!(condition==1 & subject %in% exc_subs[condition==1, subject])]
data <- data[!(condition==2 & subject %in% exc_subs[condition==2, subject])]
data <- data[!(condition==3 & subject %in% exc_subs[condition==3, subject])]
data <- data[!(condition==4 & subject %in% exc_subs[condition==4, subject])]
data <- data[!(condition==5 & subject %in% exc_subs[condition==5, subject])]

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

rfb <- which(data[condition==1 & subject==min(subject)]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==1 & subject==min(subject)]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))



plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy")
lines(data[condition==2, mean(accuracy), block], ylim=ylim, col='red', lwd=2)
lines(data[condition==5, mean(accuracy), block], ylim=ylim, col='blue', lwd=2)

rfb <- which(data[condition==2 & subject==min(subject)]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==2 & subject==min(subject)]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))



plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy")
lines(data[condition==3, mean(accuracy), block], ylim=ylim, col='red', lwd=2)
lines(data[condition==5, mean(accuracy), block], ylim=ylim, col='blue', lwd=2)

rfb <- which(data[condition==3 & subject==min(subject)]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==3 & subject==min(subject)]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))



plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy")
lines(data[condition==4, mean(accuracy), block], ylim=ylim, col='red', lwd=2)
lines(data[condition==5, mean(accuracy), block], ylim=ylim, col='blue', lwd=2)

rfb <- which(data[condition==4 & subject==min(subject)]$randTrialCR != 0)
abline(v=(rfb[1]-1)/block_size)  
abline(v=(rfb[length(rfb)]-1)/block_size)  

dt <- which(data[condition==4 & subject==min(subject)]$wmRT != 0)
polygon(c(dt[1]-1,dt[1]-1,dt[length(dt)],dt[length(dt)])/block_size, 
		c(0,1,1,0), density=25, border = NA, col=alpha('black',.25))

dev.off()

# ====================================================================================================================
# ====================================================================================================================

savings <- setnames(data[, mean(accuracy[block %in% 29:34] - accuracy[block %in% 1:6]), .(condition, subject)],'V1','savings')


pdf("fig_savings.pdf",width=10,height=7) 

# bar <- barplot( savings[, mean(savings), condition]$V1, ylim = c(-.15,.15) )
# plot_err_bars( bar, savings[, mean(savings), condition]$V1, savings[, sem(savings), condition]$V1, 'black' )
boxplot(savings ~ condition, data=savings, names=c('1','2','3','4','Control'), xlab='Condition', ylab='Accuracy: Reacquisition - Acquisition')
points(savings ~ condition, data=savings)
abline(h=0, col='red')

dev.off()

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

savings[, t.test(savings, alternative='greater'), .(condition)]

