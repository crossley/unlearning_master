#================================================================================
#================================================================================

# TODO:
# clean stimuli generation
# parallel process simulations
# define cost functions for optimization (to begin pull from unlearning 63)
# brute force our way to a goodness of fit per point of parameter space
# make it all run on node2

#================================================================================
#================================================================================

from experiment_imports import *

num_simulations = 1
num_stim = 300

def gen_stim(means, covs, cat_labs, num_stims):

    x = []
    y = []
    cat = []

    for i in xrange(means):
        mean = means[i]
        cov = covs[i]

        xy = np.random.multivariate_normal(mean, cov, num_stim[i])
        lab = [cat_labs[i]] * num_stims[i]

        np.append(x, xy[:,0])
        np.append(y, xy[:,1])
        np.append(cat, lab)

    return {'cat' : cat, 'x' : x, 'y' : y}

# Crossley et al. (2013) categories
mean_x = [72, 100, 100, 128]
mean_y = [100, 128, 72, 100]
cov = [[100, 0], [0, 100]]

mean_x = [x / 2.0 for x in mean_x]
mean_y = [x / 2.0 for x in mean_y]
cov = [[x[0] / 2.0, x[1] / 2.0] for x in cov]

xy1 = np.random.multivariate_normal([mean_x[0], mean_y[0]], cov, num_stim / 4)
cat1 = [1] * (num_stim / 4)

xy2 = np.random.multivariate_normal([mean_x[1], mean_y[1]], cov, num_stim / 4)
cat2 = [2] * (num_stim / 4)

xy3 = np.random.multivariate_normal([mean_x[2], mean_y[2]], cov, num_stim / 4)
cat3 = [3] * (num_stim / 4)

xy4 = np.random.multivariate_normal([mean_x[3], mean_y[3]], cov, num_stim / 4)
cat4 = [4] * (num_stim / 4)

x = np.concatenate(([xy1[:, 0], xy2[:, 0], xy3[:, 0], xy4[:, 0]]))
y = np.concatenate(([xy1[:, 1], xy2[:, 1], xy3[:, 1], xy4[:, 1]]))
cat = np.concatenate((cat1, cat2, cat3, cat4))

rand_ind = random.sample(range(num_stim), num_stim)

x_A = copy.deepcopy(x[rand_ind])
y_A = copy.deepcopy(y[rand_ind])
cat_A = copy.deepcopy(cat[rand_ind])

stimuli_A = {'cat': cat, 'x': x, 'y': y}

xy1 = np.random.multivariate_normal([mean_x[0], mean_y[0]], cov, num_stim / 4)
cat1 = [4] * (num_stim / 4)

xy2 = np.random.multivariate_normal([mean_x[1], mean_y[1]], cov, num_stim / 4)
cat2 = [1] * (num_stim / 4)

xy3 = np.random.multivariate_normal([mean_x[2], mean_y[2]], cov, num_stim / 4)
cat3 = [2] * (num_stim / 4)

xy4 = np.random.multivariate_normal([mean_x[3], mean_y[3]], cov, num_stim / 4)
cat4 = [3] * (num_stim / 4)

x = np.concatenate(([xy1[:, 0], xy2[:, 0], xy3[:, 0], xy4[:, 0]]))
y = np.concatenate(([xy1[:, 1], xy2[:, 1], xy3[:, 1], xy4[:, 1]]))
cat = np.concatenate((cat1, cat2, cat3, cat4))

rand_ind = random.sample(range(num_stim), num_stim)

x_B = copy.deepcopy(x[rand_ind])
y_B = copy.deepcopy(y[rand_ind])
cat_B = copy.deepcopy(cat[rand_ind])

stimuli = {'cat': np.concatenate((cat_A, cat_B, cat_A, cat_B)),
    'x': np.concatenate((x_A, x_B, x_A, x_B)),
    'y': np.concatenate((y_A, y_B, y_A, y_B))}

# plot stimuli
# fig = plt.figure()

# ax = fig.add_subplot(1, 1, 1)
# ax.plot(x[cat==1],y[cat==1],'.r')
# ax.plot(x[cat==2],y[cat==2],'.b')
# ax.plot(x[cat==3],y[cat==3],'.g')
# ax.plot(x[cat==4],y[cat==4],'.k')
# ax.set_xlim([0, 100])
# ax.set_ylim([0, 100])

# plt.show()

#================================================================================
#================================================================================

vis_width = 25
alpha_critic = .01
alpha_actor_1 = .01
alpha_gate = 0.02

params = [0] * 4
params[0] = vis_width
params[1] = alpha_critic
params[2] = alpha_actor_1
params[3] = alpha_gate

# results = simulate_1_stage_4_cat.simulate(params, stimuli, num_simulations)
# save_obj(results,'../output/1_stage_4_cat')

results = simulate_1_stage_simple_gate_4_cat.simulate(params, stimuli, num_simulations)
save_obj(results,'../output/1_stage_simple_gate_4_cat')

# results = simulate_1_stage_context_gate_4_cat.simulate(params, stimuli, num_simulations)
# save_obj(results, '../output/1_stage_context_gate_4_cat')

contingency = results['contingency']
context = results['context']
delta = results['delta']
w_gate = results['w_gate']
w_sr = results['w_sr']
accuracy = results['accuracy']
accuracy = movingaverage(accuracy, 25)

# diagnostic plot
fig = plt.figure()

ax = fig.add_subplot(2, 3, 1)
ax.plot(accuracy, linewidth=2.0)
ax.axvline(x=300, color='r')
ax.axvline(x=600, color='r')
ax.axvline(x=900, color='r')
ax.axvline(x=1200, color='r')
ax.set_ylim([-.01, 1])
ax.set_title('Accuracy')

ax = fig.add_subplot(2, 3, 2)
ax.plot(contingency, linewidth=2.0, color='red')
# ax.set_ylim([-1, 1])
ax.set_title('Contingency')

ax = fig.add_subplot(2, 3, 3)
ax.plot(context, linewidth=2.0)
ax.set_title('Context')
ax.set_ylim([-.01, 1.01])

ax = fig.add_subplot(2, 3, 4)
ax.plot(delta, linewidth=2.0)
# ax.set_ylim([-1, 1])
ax.set_title('Prediction Error')

ax = fig.add_subplot(2, 3, 5)
ax.plot(w_gate, linewidth=2.0)
ax.set_ylim([0, 1])
ax.set_title('w_gate')

ax = fig.add_subplot(2, 3, 6)
ax.plot(w_sr, linewidth=2.0)
# ax.set_ylim([0, 1])
ax.set_title('w_sr')

plt.show()
