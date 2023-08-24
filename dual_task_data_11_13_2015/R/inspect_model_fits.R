titles <- c('Condition 1', 'Condition 2', 'Condition 3', 'Condition 4', 'Control')
colors <- brewer.pal(3, "Set1")

pdf("../figures/fig_model_fits.pdf",width=15,height=7)
par(mfrow=c(2,3), cex.lab=1.3, cex.axis=1.3)

for (i in 1:5) {

	barplot(
		xt[,,i]/subs_counts_pre[condition==i,N],
		beside=TRUE,
		ylab='Proportion of Participants',
		ylim=c(0,1),
		col=colors,
		main = titles[i]
		)

	legend(
		'top',
		c('Declarative','Guessing','Procedural'),
		fill=colors
		)
}

dev.off()
