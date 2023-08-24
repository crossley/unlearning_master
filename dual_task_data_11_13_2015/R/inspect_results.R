## library(lme4)
## library(lmerTest)
library(scales)
library(data.table)
library(scatterplot3d)
library(RColorBrewer)
library(grt)
library(pwr)
library(ggplot2)

rm( list = ls() )

plot_err_bars <- function(x,y,err,col) {
	segments(x, y+err, x, y-err, col=col, lwd=2, lty=1)
}

options(contrasts=c("contr.sum", "contr.poly"))

source('import_raw_data.R')
source('import_model_fits.R')
source('inspect_exclusions.R')
source('inspect_model_fits.R')
source('inspect_flc.R')
## source('inspect_flc_rt.R')
## source('inspect_blc.R')
source('inspect_savings.R')
source('inspect_stats.R')
## source('inspect_exponential_fits.R')
