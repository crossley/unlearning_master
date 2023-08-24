x1 <- fread('../model_fits/model_fits_1.txt',header=FALSE)
x2 <- fread('../model_fits/model_fits_2.txt',header=FALSE)
x3 <- fread('../model_fits/model_fits_3.txt',header=FALSE)
x4 <- fread('../model_fits/model_fits_4.txt',header=FALSE)
xc <- fread('../model_fits/model_fits_c.txt',header=FALSE)

x1[, condition := rep(1,.N)]
x2[, condition := rep(2,.N)]
x3[, condition := rep(3,.N)]
x4[, condition := rep(4,.N)]
xc[, condition := rep(5,.N)]

x <- rbind(x1,x2,x3,x4,xc)
x <- setnames(melt(x, c(1,11), 2:10), c('V1','variable','value'), c('subject','block','winning_model'))

x[winning_model=='OPT']$winning_model <- 'Procedural'
x[winning_model=='SPC']$winning_model <- 'Procedural'
x[winning_model=='SO']$winning_model <- 'Declarative'
x[winning_model=='flat']$winning_model <- 'Guessing'

xt <- table(x[,condition,.(winning_model,block)])
