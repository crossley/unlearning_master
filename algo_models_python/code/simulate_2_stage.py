from experiment_imports import *
from utility_funcs import *

def simulate(params, stimuli):

    vis_width = params[0]
    alpha_critic = params[1]
    alpha_actor_1 = params[2]
    alpha_actor_2 = params[3]
    stim = stimuli

    data_record = {'cat' : [], 'x' : [], 'y' : [], 'resp' : [], 'accuracy' : []}

    num_consecutive_correct = 0
    t2c = 0

    # static params:
    dim = 25
    w_base =  0.5
    w_noise = 0.01
    vis_amp = 1.0

    # buffers
    vis_act = np.zeros(dim)
    w_A_1 = np.zeros(dim)
    w_B_1 = np.zeros(dim)
    w_A_2 = np.zeros(2)
    w_B_2 = np.zeros(2)

    # init
    v = 0.5

    # init weights
    w_A_1 = np.random.normal(w_base, w_noise, dim)
    w_B_1 = np.random.normal(w_base, w_noise, dim)
    w_A_2 = np.random.normal(w_base, w_noise, 2)
    w_B_2 = np.random.normal(w_base, w_noise, 2)

    num_trials = len(stim['cat'])
    for trial in xrange(num_trials):

        cat = item['cat'][trial]
        x = item['x'][trial]
        y = item['y'][trial]

        # compute input activation via radial basis functions
        vis_dist_x = 0.0
        for i in xrange(0,dim):
            vis_dist_x = x - i
            vis_act[i] = vis_amp*math.exp(-(vis_dist_x**2)/vis_width)

        # Compute A and B unit activations via dot product --- stage 1
        act_A_1 = 0.0
        act_B_1 = 0.0
        act_A_1 = np.inner(vis_act, w_A_1)
        act_B_1 = np.inner(vis_act, w_B_1)

        # Implement strong lateral inhibition --- stage 1
        act_A_1 = act_A_1 if act_A_1 > act_B_1 else 0.0
        act_B_1 = act_B_1 if act_B_1 > act_A_1 else 0.0

        # Compute A and B unit activations via dot product --- stage 2
        act_A_2 = 0.0
        act_B_2 = 0.0
        act_A_2 = np.inner([act_A_1, act_B_1], w_A_2)
        act_B_2 = np.inner([act_A_1, act_B_1], w_B_2)

        # Implement strong lateral inhibition --- stage 2
        act_A_2 = act_A_2 if act_A_2 > act_B_2 else 0.0
        act_B_2 = act_B_2 if act_B_2 > act_A_2 else 0.0

        # Compute resp via max
        discrim = act_A_2 - act_B_2
        resp = 1 if discrim > 0 else 2

        # compute outcome
        r = 1.0 if cat == resp else 0.0

        # compute prediction error
        delta = (r-v)

        # update critic
        v += alpha_critic * delta

        # update actor --- stage 1
        for i in xrange(0,dim):
            if delta < 0 :
                w_A_1[i] += alpha_actor_1 * vis_act[i] * act_A_1 * delta * w_A_1[i]
                w_B_1[i] += alpha_actor_1 * vis_act[i] * act_B_1 * delta * w_B_1[i]
            else:
                w_A_1[i] += alpha_actor_1 * vis_act[i] * act_A_1 * delta * (1 - w_A_1[i])
                w_B_1[i] += alpha_actor_1 * vis_act[i] * act_B_1 * delta * (1 - w_B_1[i])

            w_A_1[i] = cap(w_A_1[i])
            w_B_1[i] = cap(w_B_1[i])

        # update actor --- stage 2
        act_1 = [act_A_1, act_B_1]
        for i in xrange(0,2):
            if delta < 0 :
                w_A_2[i] += alpha_actor_2 * act_1[i]  * act_A_2 * delta * w_A_2[i]
                w_B_2[i] += alpha_actor_2 * act_1[i] * act_B_2 * delta * w_B_2[i]
            else:
                w_A_2[i] += alpha_actor_2 * act_1[i] * act_A_2 * delta * (1 - w_A_2[i])
                w_B_2[i] += alpha_actor_2 * act_1[i] * act_B_2 * delta * (1 - w_B_2[i])

            w_A_2[i] = cap(w_A_2[i])
            w_B_2[i] = cap(w_B_2[i])

        # record keeping
        data_record['cat'].append(cat)
        data_record['x'].append(x)
        data_record['y'].append(0.0)
        data_record['resp'].append(resp)
        data_record['accuracy'].append(cat == resp)

        trial += 1

    return(data_record)
