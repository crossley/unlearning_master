#
#
#
#

# # generic II categories
# mean_x = [40, 60]
# mean_y = [60, 40]
# cov = [[170, 60], [120, 60]]

# xy1 = np.random.multivariate_normal([mean_x[0], mean_y[0]], cov, num_stim/2)
# cat1 = [1] * (num_stim / 2)

# xy2 = np.random.multivariate_normal([mean_x[1], mean_y[1]], cov, num_stim/2)
# cat2 = [2] * (num_stim / 2)

# x = np.concatenate(([xy1[:,0], xy2[:,0]]))
# y = np.concatenate(([xy1[:,1], xy2[:,1]]))
# cat = np.concatenate((cat1, cat2))

#
#
#
#

# # Crossley et al. (2013) categories
# mean_x = [72, 100, 100, 128]
# mean_y = [100, 128, 72, 100]
# cov = [[100, 0], [0, 100]]

# mean_x = [x/2.0 for x in mean_x]
# mean_y = [x/2.0 for x in mean_y]
# cov = [[x[0]/2.0, x[1]/2.0] for x in cov]

# xy1 = np.random.multivariate_normal([mean_x[0], mean_y[0]], cov, num_stim/4)
# cat1 = [1] * (num_stim / 4)

# xy2 = np.random.multivariate_normal([mean_x[1], mean_y[1]], cov, num_stim/4)
# cat2 = [2] * (num_stim / 4)

# xy3 = np.random.multivariate_normal([mean_x[2], mean_y[2]], cov, num_stim/4)
# cat3 = [3] * (num_stim / 4)

# xy4 = np.random.multivariate_normal([mean_x[3], mean_y[3]], cov, num_stim/4)
# cat4 = [4] * (num_stim / 4)

# x = np.concatenate(([xy1[:,0], xy2[:,0], xy3[:,0], xy4[:,0]]))
# y = np.concatenate(([xy1[:,1], xy2[:,1], xy3[:,1], xy4[:,1]]))
# cat = np.concatenate((cat1, cat2, cat3, cat4))
