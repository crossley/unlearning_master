## Plot final block acquisition accuracy per subject histogram
exc_ind <- 201:250
y_lim <- 7
bs <-  seq(.1,1,.05)
xl <- 'Mean Classification Accuracy'

pdf("../figures/fig_exc_ac.pdf", 8, 5)
par(mfrow=c(2,2))
for(i in 1:4) {
  hist(
    data[condition==i & trial %in% exc_ind, mean(.SD[,accuracy]), .(condition,subject), .SDcols=c('accuracy')]$V1,
    breaks=bs,
    ## freq=FALSE,
    ylim=c(0,y_lim),
    col=rgb(1,0,0,0.5),
    main='',
    xlab=xl
  )
  hist(
    data[condition==5 & trial %in% exc_ind, mean(.SD[,accuracy]), .(condition,subject), .SDcols=c('accuracy')]$V1,
    breaks=bs,
    ## freq=FALSE,
    ylim=c(0,y_lim),
    col=rgb(0,0,1,0.5),
    main='',
    xlab=xl,
    add=T
  )
}
dev.off()



t <- c('A','B','C','D')
y_lim <-15
bs <-  seq(.1,1,.05)
xl <- 'Mean Numerical Stroop Accuracy'
yl <- 'Number of Participants'
pdf("../figures/fig_exc_dual.pdf", 8, 5)
par(mfrow=c(2,2))
for(i in 1:4) {
  hist(
    data[condition==i, mean(wmAcc[trial%in%which(wmRT!=0)]), .(condition,subject), .SDcols=c('accuracy')]$V1,
    breaks=bs,
    ## freq=FALSE,
    ylim=c(0,y_lim),
    main='',
    xlab=xl,
    ylab=yl
  )
  mtext(t[i], side=3)
}
dev.off()


# ====================================================================================================================
# ====================================================================================================================

subs_counts_pre <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

# ====================================================================================================================
# ====================================================================================================================

# participants that didn't finish the experiment
exc_subs <- data[, .N < 850, .(condition, subject)][V1==TRUE, .(condition, subject)]

# perform the exclusions
data <- data[!(condition==1 & subject %in% exc_subs[condition==1, subject])]
data <- data[!(condition==2 & subject %in% exc_subs[condition==2, subject])]
data <- data[!(condition==3 & subject %in% exc_subs[condition==3, subject])]
data <- data[!(condition==4 & subject %in% exc_subs[condition==4, subject])]
data <- data[!(condition==5 & subject %in% exc_subs[condition==5, subject])]

subs_counts <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

subs_counts_failed <- subs_counts

# ====================================================================================================================
# ====================================================================================================================

print(subs_counts)

## watch out for trial indices below
exc_crit <- .4

# exclude participants with final training block acc < exc_crit
exc_subs <- data[trial %in% 251:300, mean(.SD[,accuracy]) < exc_crit, .(condition,subject), .SDcols=c('accuracy')]
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

print(exc_subs[,.N,condition])

# ====================================================================================================================
# ====================================================================================================================

exc_crit <- .8

# exclude participants with crappy dual-task
exc_subs <- data[condition!=5, mean(wmAcc[trial %in% which(wmRT != 0)]) < exc_crit, .(condition,subject)]
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

print(exc_subs[,.N,condition])

print(subs_counts)

# ====================================================================================================================
# ====================================================================================================================

## exc_crit <- 0.-4

## savings <- setnames(data[, mean(accuracy[block %in% 29:34] - accuracy[block %in% 1:6]), .(condition, subject)],'V1','savings')

## savings[, exclude := savings < exc_crit]

## # exclude participants with large interference
## exc_subs <- savings[exclude==TRUE]

## # perform the exclusions
## data <- data[!(condition==1 & subject %in% exc_subs[condition==1, subject])]
## data <- data[!(condition==2 & subject %in% exc_subs[condition==2, subject])]
## data <- data[!(condition==3 & subject %in% exc_subs[condition==3, subject])]
## data <- data[!(condition==4 & subject %in% exc_subs[condition==4, subject])]
## data <- data[!(condition==5 & subject %in% exc_subs[condition==5, subject])]

## subs_counts <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

## subs_counts_save <- subs_counts

# ====================================================================================================================
# ====================================================================================================================
# do exclusions based on model fit

## x[, subject := gsub("^.*? ","",subject)]
## x[, subject := gsub("a|c","",subject)]

## data[, new_subject := gsub("^.*?b","",filename)]
## data[, new_subject := gsub("^.*?c","",new_subject)]
## data[, new_subject := gsub(".txt","",new_subject)]

## ## # exclude participants that were not best fit by a procedural model at end of acquisition
## exc_subs <- x[block %in% c('V4'), winning_model != 'Procedural', .(condition,subject)]
## exc_subs[is.na(exc_subs)] <- TRUE
## exc_subs <- exc_subs[exc_subs$V1]

## # perform the exclusions
## data <- data[!(condition==1 & new_subject %in% exc_subs[condition==1, subject])]
## data <- data[!(condition==2 & new_subject %in% exc_subs[condition==2, subject])]
## data <- data[!(condition==3 & new_subject %in% exc_subs[condition==3, subject])]
## data <- data[!(condition==4 & new_subject %in% exc_subs[condition==4, subject])]
## data <- data[!(condition==5 & new_subject %in% exc_subs[condition==5, subject])]

## ## # exclude participants that were best fit by a guessing model at beginning of reacquisition
## ## exc_subs <- x[block %in% c('V4'), winning_model == 'Guessing', .(condition,subject)]
## ## exc_subs[is.na(exc_subs)] <- TRUE
## ## exc_subs <- exc_subs[exc_subs$V1]

## # perform the exclusions
## ## data <- data[!(condition==1 & new_subject %in% exc_subs[condition==1, subject])]
## ## data <- data[!(condition==2 & new_subject %in% exc_subs[condition==2, subject])]
## ## data <- data[!(condition==3 & new_subject %in% exc_subs[condition==3, subject])]
## ## data <- data[!(condition==4 & new_subject %in% exc_subs[condition==4, subject])]
## ## data <- data[!(condition==5 & new_subject %in% exc_subs[condition==5, subject])]

## subs_counts <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

## subs_counts_model_1 <- subs_counts

# ====================================================================================================================
# ====================================================================================================================

## # do exclusions based on model fit

## x[, subject := gsub("^.*? ","",subject)]
## x[, subject := gsub("a|c","",subject)]

## data[, new_subject := gsub("^.*?b","",filename)]
## data[, new_subject := gsub("^.*?c","",new_subject)]
## data[, new_subject := gsub(".txt","",new_subject)]

## # exclude participants that were not best fit by a procedural model at end of acquisition
## exc_subs <- x[block %in% c('V4','V9'), winning_model != 'Procedural', .(condition,subject)]
## exc_subs[is.na(exc_subs)] <- TRUE
## exc_subs <- exc_subs[exc_subs$V1]

## # perform the exclusions
## data <- data[!(condition==1 & new_subject %in% exc_subs[condition==1, subject])]
## data <- data[!(condition==2 & new_subject %in% exc_subs[condition==2, subject])]
## data <- data[!(condition==3 & new_subject %in% exc_subs[condition==3, subject])]
## data <- data[!(condition==4 & new_subject %in% exc_subs[condition==4, subject])]
## data <- data[!(condition==5 & new_subject %in% exc_subs[condition==5, subject])]

## subs_counts <- setnames(data[, unique(subject), .(condition)], 'V1', 'subject')[, .N, condition]

## subs_counts_model_2 <- subs_counts

# ====================================================================================================================
# ====================================================================================================================

## pt <- prop.test(subs_counts_model_2$N, subs_counts_pre$N)
## es <- ES.h(pt$estimate[1], pt$estimate[2])
## paste(sep='', 'Chi(',
## 	round(pt$parameter), ') = ',
## 	format(round(pt$statistic, 2), nsmall=2), ', p = ',
## 	format(round(pt$p.value, 2), nsmall=2), ', h = ',
## 	format(round(es, 2), nsmall=2)
## 	)


# ====================================================================================================================
# ====================================================================================================================


## # based on RT
## exc_subs <- data[, mean(rt) < 1, .(condition, subject)][V1==TRUE, .(condition, subject)]

## # perform the exclusions
## data <- data[!(condition==1 & subject %in% exc_subs[condition==1, subject])]
## data <- data[!(condition==2 & subject %in% exc_subs[condition==2, subject])]
## data <- data[!(condition==3 & subject %in% exc_subs[condition==3, subject])]
## data <- data[!(condition==4 & subject %in% exc_subs[condition==4, subject])]
## data <- data[!(condition==5 & subject %in% exc_subs[condition==5, subject])]
