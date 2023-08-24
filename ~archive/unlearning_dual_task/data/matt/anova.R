rm( list = ls() )
data <- read.table("anova_all", header = TRUE)
condition <- factor(data$condition)
phase <- factor(data$phase)
phase_s <- factor(data$phase_s)
block <- factor(data$block)
subject <- factor(data$subject)
accuracy <- data$accuracy
data <- data.frame(condition, phase_s, phase, block, subject, accuracy)

fm <- lmer( accuracy ~ condition*phase_s + (1|subject) )
anova(fm)
difflsmeans(fm, test.effs="condition:phase_s",adjust="tukey")

