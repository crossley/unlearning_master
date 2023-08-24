#================================================================================
#================================================================================

from experiment_imports import *

num_simulations = 10
num_stim = 300

# Crossley et al. (2013) categories
mean_x = [72, 100, 100, 128]
mean_y = [100, 128, 72, 100]
cov = [[100, 0], [0, 100]]

mean_x = [x / 2.0 for x in mean_x]
mean_y = [x / 2.0 for x in mean_y]
cov = [[x[0] / 2.0, x[1] / 2.0] for x in cov]

n = 75
mean = [(mean_x[i], mean_y[i]) for i in xrange(len(mean_x))]

stimuli_A = gen_stim(mean, [cov, cov, cov, cov], [1, 2, 3, 4], [n, n, n, n])
stimuli_B = gen_stim(mean, [cov, cov, cov, cov], [2, 3, 4, 1], [n, n, n, n])
stimuli_A2 = gen_stim(mean, [cov, cov, cov, cov], [1, 2, 3, 4], [n, n, n, n])

stimuli = {'cat' : np.append(stimuli_A['cat'], [stimuli_B['cat'], stimuli_A2['cat']]),
           'x' : np.append(stimuli_A['x'], [stimuli_B['x'], stimuli_A2['x']]),
           'y' : np.append(stimuli_A['y'], [stimuli_B['y'], stimuli_A2['y']])}

# plot stimuli
# x = stimuli_A['x']
# y = stimuli_A['y']
# cat = stimuli_A['cat']

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

simulate_1_stage_4_cat.psp(10, stimuli, num_simulations)
# simulate_1_stage_4_cat.psp_plot()

# def classify_psp_pattern(results):
#     pattern = np.zeros((len(results),1))
#     for i in xrange(len(results)):
#         acc = results[i]['accuracy']
#         mean_1 = np.mean(acc[200:399])
#         mean_2 = np.mean(acc[500:599])
#         mean_3 = np.mean(acc[600:699])

#         if mean_1 > 0.5 and mean_2 < 0.5 and mean_3 > 0.5:
#             pattern[i] = 1
#         else:
#             pattern[i] = 2

#     return pattern

# pattern = classify_psp_pattern(results)

# print pattern

# vis_width = 25
# alpha_critic = .01
# alpha_actor_1 = .01
# alpha_gate = 0.02

# params = [0] * 4
# params[0] = vis_width
# params[1] = alpha_critic
# params[2] = alpha_actor_1
# params[3] = alpha_gate

# results_1 = simulate_1_stage_4_cat.simulate([params, stimuli, num_simulations])
# save_obj(results,'../output/1_stage_4_cat')

# results_2 = simulate_1_stage_simple_gate_4_cat.simulate([params, stimuli, num_simulations])
# save_obj(results,'../output/1_stage_simple_gate_4_cat')

# results_3 = simulate_1_stage_context_gate_4_cat.simulate([params, stimuli, num_simulations])
# save_obj(results, '../output/1_stage_context_gate_4_cat')

# contingency = results['contingency']
# context = results['context']
# delta = results['delta']
# w_gate = results['w_gate']
# w_sr = results['w_sr']
# accuracy = results['accuracy']
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
