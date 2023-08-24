blk_ac <- 1:6
blk_int <- 12:28
blk_reac <- 29:34

pdf("../figures/fig_fit.pdf",width=10,height=10) 
par(mfrow=c(3,2), pty="s")
xlim <- c(1,34)
ylim <- c(0,1)

m_ac_record <- vector("list", 5)
m_int_record <- vector("list", 5)
m_reac_record <- vector("list", 5)

for (i in 1:5) {

  m_ac <- nls(V1 ~ a-b*exp(-c*V2),
              data=data[condition==i & block%in%blk_ac, .(mean(accuracy), block-1), block],
              start = list(a=1,b=1,c=1))

  m_int <- nls(V1 ~ a-b*exp(-c*V2),
               data=data[condition==i & block%in%blk_int, .(mean(accuracy), block-12), block],
               start = list(a=1,b=1,c=1))

  m_reac <- nls(V1 ~ a-b*exp(-c*V2),
                data=data[condition==i & block%in%blk_reac, .(mean(accuracy), block-28), block],
                start = list(a=1,b=1,c=1))

  m_ac_record[[i]] <- m_ac
  m_int_record[[i]] <- m_int
  m_reac_record[[i]] <- m_reac

  plot(NA, type="n", xlim=xlim, ylim=ylim, xlab="Block", ylab="Accuracy")
  lines(data[condition==i, mean(accuracy), block], ylim=ylim, col='red', lwd=2, lty=1)
  lines(blk_ac, predict(m_ac), ylim=ylim, col='blue', lwd=2, lty=1)
  lines(blk_int, predict(m_int), ylim=ylim, col='blue', lwd=2, lty=1)
  lines(blk_reac, predict(m_reac), ylim=ylim, col='blue', lwd=2, lty=1)

}

dev.off()

## compute goodness of fit
## (RSS.p <- sum(residuals(m.exp)^2))  # Residual sum of squares
## (TSS <- sum((y - mean(y))^2))  # Total sum of squares
## 1 - (RSS.p/TSS)  # R-squared measure

## compare estimated parameters between conditions
exp_model_stats <-data.table(p1=numeric(0),
                             p2=numeric(0),
                             se1=numeric(0),
                             se2=numeric(0),
                             df1=numeric(0),
                             df2=numeric(0),
                             t=numeric(0),
                             p=numeric(0),
                             c1=character(0),
                             c2=character(0),
                             param=character(0),
                             phase=character(0))

m_record <- list(m_ac_record,m_int_record,m_reac_record)
cond <- c("ac","int","reac")
for (i in 1:5) {
  for (j in 1:5) {
    for (k in c("a","b","c")) {
      for (l in 1:3) {
        p1 <- summary(m_record[[l]][[i]])$coefficients[,1][k]
        p2 <- summary(m_record[[l]][[j]])$coefficients[,1][k]
        se1 <- summary(m_record[[l]][[i]])$coefficients[,2][k]
        se2 <- summary(m_record[[l]][[j]])$coefficients[,2][k]
        df1 <- summary(m_record[[l]][[i]])$df[2]
        df2 <- summary(m_record[[l]][[j]])$df[2]
        t = (p1-p2) / sqrt(se1^2 + se2^2)
        p <- 2*pt(-abs(t), df1+df2)
        exp_model_stats <- rbind(exp_model_stats,
                                 data.table(p1=p1,
                                            p2=p2,
                                            se1=se1,
                                            se2=se2,
                                            df1=df1,
                                            df2=df2,
                                            t=t,
                                            p=p,
                                            c1=i,
                                            c2=j,
                                            param=k,
                                            phase=cond[l]))
      }
    }
  }
}

setkey(exp_model_stats,c1,c2,phase,param)
exp_model_stats[p<.05, .(c1,c2,phase,param)]

## pdf("../figures/fig_fit_params.pdf",width=10,height=10) 
## par(mfrow=c(1,3))
## boxplot(

## )
## dev.off()
