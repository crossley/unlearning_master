library(data.table)
library(ggplot2)
library(stringr)

f_ext5 <- list.files(paste('../nc_25_data', sep=''),
                             pattern=paste('^', 'ext5|unl1|ext6', sep=''),
                             full.names=TRUE)

f_unl1 <- list.files(paste('../nc_25_data', sep=''),
                                  pattern=paste('^', 'unl1[^m]', sep=''),
                                  full.names=TRUE)

f_ext6 <- list.files(paste('../nc_25_data', sep=''),
                                  pattern=paste('^', 'ext6', sep=''),
                                  full.names=TRUE)

f_rf40 <- list.files(paste('../nc_40_data', sep=''),
                             pattern=paste('^', 'nc40[^m]', sep=''),
                             full.names=TRUE)

f_rf40_m <- list.files(paste('../nc_40_data', sep=''),
                     pattern=paste('^', 'nc40m', sep=''),
                     full.names=TRUE)

f_mixed <- list.files(paste('../mix_2575_data', sep=''),
                              pattern=paste('^', 'unl7[^m]', sep=''),
                              full.names=TRUE)

f_mixed_m <- list.files(paste('../mix_2575_data', sep=''),
                      pattern=paste('^', 'unl7m', sep=''),
                      full.names=TRUE)

f_rf63 <- list.files(paste('../nc_63_data', sep=''),
                     pattern=paste('^', 'nc63[^m]', sep=''),
                     full.names=TRUE)

f_rf63_m <- list.files(paste('../nc_63_data', sep=''),
                       pattern=paste('^', 'nc63m', sep=''),
                       full.names=TRUE)

f <- c(
  f_ext5,
  f_unl1,
  f_ext6,
  f_rf40,
  f_rf40_m,
  f_mixed,
  f_mixed_m,
  f_rf63,
  f_rf63_m
)

ldf <- lapply(f, function(z) {y<-fread(z); y[,f_name := z]})
ldf <- lapply(seq_along(ldf), function(z) ldf[[z]][, sub := rep(z, .N)])

data <- rbindlist(ldf, fill=TRUE)

add_cnds <- function(z) {

  f_name <- z$f_name
  cnd1 <- NA
  cnd2 <- NA
  cnd3 <- NA

  if(grepl('ext5', f_name)) {
    cnd1 <- 'RF(.25)'
    cnd2 <- 'Relearning'
    cnd3 <- 'ext5'
  }

  if(grepl('unl1[^m]', f_name)) {
    cnd1 <- 'RF(.25)'
    cnd2 <- 'Relearning'
    cnd3 <- 'unl1'
  }

  if(grepl('ext6', f_name)) {
    cnd1 <- 'RF(.25)'
    cnd2 <- 'New Learning'
    cnd3 <- 'ext6'
  }

  if(grepl('nc40[^m]', f_name)) {
    cnd1 <- 'RF(.40)'
    cnd2 <- 'Relearning'
    cnd3 <- 'nc40'
  }

  if(grepl('nc40m', f_name)) {
    cnd1 <- 'RF(.40)'
    cnd2 <- 'New Learning'
    cnd3 <- 'nc40m'
  }

  if(grepl('unl7[^m]', f_name)) {
    cnd1 <- 'Mixed'
    cnd2 <- 'Relearning'
    cnd3 <- 'unl7'
  }

  if(grepl('unl7m', f_name)) {
    cnd1 <- 'Mixed'
    cnd2 <- 'New Learning'
    cnd3 <- 'unl7m'
  }

  if(grepl('nc63[^m]', f_name)) {
    cnd1 <- 'RF(.63)'
    cnd2 <- 'Relearning'
    cnd3 <- 'nc63'
  }

  if(grepl('nc63m', f_name)) {
    cnd1 <- 'RF(.63)'
    cnd2 <- 'New Learning'
    cnd3 <- 'nc63m'
  }

  return(list(c(cnd1),c(cnd2),c(cnd3)))
}

add_cnds2 <- function(z) {

  f_name <- z$f_name

  if(grepl('ext5', f_name)) {
    cat <- z[,2]
    resp <- z[,6]
  }

  if(grepl('unl1[^m]', f_name)) {
    cat <- z[,5]
    resp <- z[,6]
  }

  if(grepl('ext6', f_name)) {
    cat <- z[,2]
    resp <- z[,6]
  }

  if(grepl('nc40[^m]', f_name)) {
    cat <- z[,4]
    resp <- z[,5]
  }

  if(grepl('nc40m', f_name)) {
    cat <- z[,4]
    resp <- z[,5]
  }

  if(grepl('unl7[^m]', f_name)) {
    cat <- z[,5]
    resp <- z[,6]
  }

  if(grepl('unl7m', f_name)) {
    cat <- z[,5]
    resp <- z[,6]
  }

  if(grepl('nc63[^m]', f_name)) {
    cat <- z[,4]
    resp <- z[,5]
  }

  if(grepl('nc63m', f_name)) {
    cat <- z[,4]
    resp <- z[,5]
  }

  return(cat == resp)
}

data[, c('cnd1','cnd2', 'cnd3') := add_cnds(.SD), .(f_name), .SDcols = c('f_name')]

data[, acc := add_cnds2(.SD),
     .(f_name),
     .SDcols = c(paste0("V",1:12), 'f_name')]

num_trials <- max(data[, .N, .(cnd1,cnd2,sub)]$N)
block_size <- 25
num_blocks <- num_trials / block_size

data[, trial := rep(1:num_trials, .N/num_trials)]
data[, block := rep(1:num_blocks, .N/num_trials, each=block_size)]

data[, exc_acc := mean(acc[which(block %in% 9:12)]), .(cnd3, sub)]

d <- data[exc_acc > .4]

dd <- d[, .(mean(acc), sd(acc)/sqrt(length(unique(sub)))), .(cnd1, cnd2, block)]
dd[, cnd1 := factor(cnd1, levels=c('RF(.25)', 'Mixed', 'RF(.40)', 'RF(.63)'))]

ggplot(dd[cnd1 != c('RF(.40)')], aes(x=block, y=V1, colour=factor(cnd2))) +
  geom_line() +
  geom_errorbar(aes(ymin=V1-V2, ymax=V1+V2), width=.1) +
  geom_vline(xintercept = 12.5, linetype = "longdash", size=.25) +
  geom_vline(xintercept = 24.5, linetype = "longdash", size=.25) +
  facet_wrap(~cnd1, ncol=3) +
  ylab('Accuracy') +
  xlab('Block') +
  scale_color_manual(name="",values=c("blue", "red")) +
  scale_x_continuous(breaks=seq(0,36,4)) +
  scale_y_continuous(breaks=seq(0,1,.1)) +
  ylim(0,1) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(size=12),
    strip.text = element_blank(),
    strip.background = element_blank(),
    legend.position="bottom",
    legend.text = element_text(size=12),
    aspect.ratio=1
  )
ggsave('crossleyetal2013_nc63.pdf', width = 8, height = 3.5)
