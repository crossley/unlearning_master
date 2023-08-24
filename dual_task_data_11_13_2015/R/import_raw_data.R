# get a list of .txt file names in the directory of interest and store in a list
filenames_4b1 <- list.files(paste('../txtData', sep=''), pattern=paste('^', 'un4b1', sep=''), full.names=TRUE)
filenames_4b2 <- list.files(paste('../txtData', sep=''), pattern=paste('^', 'un4b2', sep=''), full.names=TRUE)
filenames_4b3 <- list.files(paste('../txtData', sep=''), pattern=paste('^', 'un4b3', sep=''), full.names=TRUE)
filenames_4b4 <- list.files(paste('../txtData', sep=''), pattern=paste('^', 'un4b4', sep=''), full.names=TRUE)
filenames_4bc <- list.files(paste('../txtData', sep=''), pattern=paste('^', 'un4bc', sep=''), full.names=TRUE)

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

# give subjects unqiue numbers
data[, subject := subject + as.integer(condition*100), condition]
# ====================================================================================================================
# ====================================================================================================================

# add original unlearning data
filenames_ext5 <- list.files(paste('../../nc_25_data', sep=''), pattern=paste('^', 'ext5', sep=''), full.names=TRUE)

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
