from experiment_imports import *
from utility_funcs import *

def simulate(params, stimuli):

    vis_width = params[0]
    alpha_critic = params[1]
    alpha_actor_1 = params[2]
    stim = stimuli

    data_record = {'cat': [], 'x': [], 'y': [], 'resp': [], 'accuracy': []}

    num_consecutive_correct = 0
    t2c = 0

    # static params:
    dim = 25
    w_base = 0.5
    w_noise = 0.01
    vis_amp = 1.0

    # buffers
    vis_act = np.zeros(dim)
    w_A_1 = np.zeros(dim)
    w_B_1 = np.zeros(dim)

    # init
    v = 0.5

    # init weights
    w_A_1 = np.random.normal(w_base, w_noise, dim)
    w_B_1 = np.random.normal(w_base, w_noise, dim)

    num_trials = len(stim['cat'])
    for trial in xrange(num_trials):

        cat = item['cat'][trial]
        x = item['x'][trial]
        y = item['y'][trial]

        # compute input activation via radial basis functions
        vis_dist_x = 0.0
        for i in xrange(0, dim):
            vis_dist_x = x - i
            vis_act[i] = vis_amp * math.exp(-(vis_dist_x**2) / vis_width)

        # Compute A and B unit activations via dot product --- stage 1
        act_A_1 = 0.0
        act_B_1 = 0.0
        act_A_1 = np.inner(vis_act, w_A_1)
        act_B_1 = np.inner(vis_act, w_B_1)

        # Implement strong lateral inhibition --- stage 1
        act_A_1 = act_A_1 if act_A_1 > act_B_1 else 0.0
        act_B_1 = act_B_1 if act_B_1 > act_A_1 else 0.0

        # Compute resp via max
        discrim = act_A_1 - act_B_1
        resp = 1 if discrim > 0 else 2

        # compute outcome
        r = 1.0 if cat == resp else 0.0

        # compute prediction error
        delta = (r - v)

        # update critic
        v += alpha_critic * delta

        # update actor --- stage 1
        for i in xrange(0, dim):
            if delta < 0:
                w_A_1[i] += alpha_actor_1 * vis_act[
                    i] * act_A_1 * delta * w_A_1[i]
                w_B_1[i] += alpha_actor_1 * vis_act[
                    i] * act_B_1 * delta * w_B_1[i]
            else:
                w_A_1[i] += alpha_actor_1 * vis_act[i] * act_A_1 * delta * (
                    1 - w_A_1[i])
                w_B_1[i] += alpha_actor_1 * vis_act[i] * act_B_1 * delta * (
                    1 - w_B_1[i])

            w_A_1[i] = cap(w_A_1[i])
            w_B_1[i] = cap(w_B_1[i])

        # diagnostic plot
        # fig = plt.figure()
        # ax = fig.add_subplot(2, 3, 1)
        # ax.plot(vis_act, linewidth=2.0)
        # ax.set_ylim([0, 1])
        # ax = fig.add_subplot(2, 3, 2)
        # ax.plot(w_A_1, linewidth=2.0)
        # ax.set_ylim([0, 1])
        # ax = fig.add_subplot(2, 3, 3)
        # ax.plot(w_B_1, linewidth=2.0)
        # ax.set_ylim([0, 1])
        # ax = fig.add_subplot(2, 3, 5)
        # ax.plot(w_A_2, linewidth=2.0)
        # ax.set_ylim([0, 1])
        # ax = fig.add_subplot(2, 3, 6)
        # ax.plot(w_B_2, linewidth=2.0)
        # ax.set_ylim([0, 1])
        # plt.show()

        # record keeping
        data_record['cat'].append(cat)
        data_record['x'].append(x)
        data_record['y'].append(0.0)
        data_record['resp'].append(resp)
        data_record['accuracy'].append(cat == resp)

        trial += 1

    return (data_record)
