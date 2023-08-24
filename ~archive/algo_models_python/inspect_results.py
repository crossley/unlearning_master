from experiment_imports import *
import csv

results = load_obj('1_stage_context_gate_4_cat')

contingency = results['contingency']
context = results['context']
delta = results['delta']
w_gate = results['w_gate']
w_sr = results['w_sr']
accuracy = results['accuracy']

np.savetxt('contingency.txt', contingency)
np.savetxt('accuracy.txt', accuracy)
np.savetxt('delta_context.txt', delta)



results = load_obj('1_stage_simple_gate_4_cat')

contingency = results['contingency']
context = results['context']
delta = results['delta']
w_gate = results['w_gate']
w_sr = results['w_sr']
accuracy = results['accuracy']

np.savetxt('contingency2.txt', contingency)
np.savetxt('accuracy2.txt', accuracy)
np.savetxt('delta.txt', delta)



results = load_obj('1_stage_4_cat')

contingency = results['contingency']
context = results['context']
delta = results['delta']
w_gate = results['w_gate']
w_sr = results['w_sr']
accuracy = results['accuracy']

np.savetxt('contingency2_classic.txt', contingency)
np.savetxt('accuracy2_classic.txt', accuracy)
np.savetxt('delta_classic.txt', delta)


# accuracy = movingaverage(accuracy, 25)

# # diagnostic plot
# fig = plt.figure()

# ax = fig.add_subplot(2, 3, 1)
# ax.plot(accuracy, linewidth=2.0)
# ax.axvline(x=300, color='r')
# ax.axvline(x=600, color='r')
# ax.axvline(x=900, color='r')
# ax.axvline(x=1200, color='r')
# ax.set_ylim([-.01, 1])
# ax.set_title('Accuracy')

# ax = fig.add_subplot(2, 3, 2)
# ax.plot(contingency, linewidth=2.0, color='red')
# # ax.set_ylim([-1, 1])
# ax.set_title('Contingency')

# ax = fig.add_subplot(2, 3, 3)
# ax.plot(context, linewidth=2.0)
# ax.set_title('Context')
# ax.set_ylim([-.01, 1.01])

# ax = fig.add_subplot(2, 3, 4)
# ax.plot(delta, linewidth=2.0)
# # ax.set_ylim([-1, 1])
# ax.set_title('Prediction Error')

# ax = fig.add_subplot(2, 3, 5)
# ax.plot(w_gate, linewidth=2.0)
# ax.set_ylim([0, 1])
# ax.set_title('w_gate')

# ax = fig.add_subplot(2, 3, 6)
# ax.plot(w_sr, linewidth=2.0)
# # ax.set_ylim([0, 1])
# ax.set_title('w_sr')

# plt.show()


num_stim = 300

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

d = {'cat': np.concatenate((cat_A, cat_B, cat_A, cat_B)),
           'x': np.concatenate((x_A, x_B, x_A, x_B)),
           'y': np.concatenate((y_A, y_B, y_A, y_B))}

with open("stimuli.csv", "wb") as outfile:
   writer = csv.writer(outfile)
   writer.writerow(d.keys())
   writer.writerows(zip(*d.values()))
