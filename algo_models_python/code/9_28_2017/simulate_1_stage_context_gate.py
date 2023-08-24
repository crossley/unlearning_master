from experiment_imports import *
from utility_funcs import *

def simulate(params, stimuli):

    vis_width = params[0]
    alpha_critic = params[1]
    alpha_actor_1 = params[2]
    stim = stimuli

    data_record = {'cat' : [], 'x' : [], 'y' : [], 'resp' : [], 'accuracy' : [],
                   'contingency' : [], 'context' : [], 'delta' : []}

    num_consecutive_correct = 0

    # static params:
    dim = 25
    w_base =  0.5
    w_noise = 0.01
    vis_amp = 1.0
    w_gate = 1.0
    w_vis_act = 0.5

    # init buffers
    vis_act = np.zeros(dim)
    w_A_1 = np.random.normal(w_base, w_noise, dim)
    w_B_1 = np.random.normal(w_base, w_noise, dim)

    # lists to store info for different contexts
    context = [[w_A_1, w_B_1]]
    current_context = 0

    act_A_1 = [0]
    act_B_1 = [0]
    conf_pos = [[0]]
    conf_neg = [[0]]
    conf_pos_mean = [0]
    conf_neg_mean = [0]
    discrim = [0]
    resp = [0]
    r = [0]
    contingency = [0]
    contingency_previous = [0]
    contingency_max = [0]

    contingency_window = 25
    new_context_thresh = 0.01

    # init
    v = 0.5

    num_trials = len(stim['cat'])
    for trial in xrange(num_trials):

        cat = stim['cat'][trial]
        x = stim['x'][trial]
        y = stim['y'][trial]

        # compute input activation via radial basis functions
        # also implement presynaptic inhibition --- gate the input
        vis_dist_x = 0.0
        for i in xrange(0,dim):
            vis_dist_x = x - i
            vis_act[i] = vis_amp*math.exp(-(vis_dist_x**2)/vis_width)
            vis_act[i] *= w_vis_act * w_gate

        # Each context is evolved in parallel and independently
        for x in xrange(len(context)):

            # Compute A and B unit activations via dot product --- stage 1
            act_A_1[x] = np.inner(vis_act, context[x][0])
            act_B_1[x] = np.inner(vis_act, context[x][1])

            # add noise to output units
            act_A_1[x] += np.random.normal(w_base, w_noise, 1)
            act_B_1[x] += np.random.normal(w_base, w_noise, 1)

            # Compute resp via max
            discrim[x] = (act_A_1[x] - act_B_1[x]) / np.max([act_A_1[x], act_B_1[x]])
            resp[x] = 1 if discrim[x] > 0 else 2

            # Implement strong lateral inhibition --- stage 1
            act_A_1[x] = act_A_1[x] if act_A_1[x] > act_B_1[x] else 0.0
            act_B_1[x] = act_B_1[x] if act_B_1[x] > act_A_1[x] else 0.0

            # compute outcome
            if trial < 100 or trial > 200:
                r[x] = 1.0 if cat == resp[x] else 0.0

            # track confidence as a function of feedback
            if r[x] == 1.0:
                conf_pos[x].append(np.abs(discrim[x]))
            else:
                conf_neg[x].append(np.abs(discrim[x]))

            # always use the last contingency_window trials
            if len(conf_pos[x]) > contingency_window:
                conf_pos[x].pop(0)

            if len(conf_neg[x]) > contingency_window:
                conf_neg[x].pop(0)

            # compute feedback randomness
            if conf_pos[x]:
                conf_pos_mean[x] = np.mean(conf_pos[x])
            else:
                conf_pos_mean[x] = 0.0

            if conf_neg[x]:
                conf_neg_mean[x] = np.mean(conf_neg[x])
            else:
                conf_neg_mean[x] = 0.0

            contingency_previous[x] = contingency[x]
            contingency[x] = conf_pos_mean[x] - conf_neg_mean[x]

            # Track the maximum observed contingency for this context
            contingency_max[x] = contingency[x] if contingency[x] > contingency_max[x] else contingency_max[x]

        # Compute resp via max
        resp_obs = resp[current_context]

        # compute outcome
        if trial < 100 or trial >= 200:
            r_obs = r[current_context]
        else:
            r_obs = 1.0 if np.random.uniform(0,1,1) < 0.5 else 0.0

        # compute prediction error
        delta = (r_obs-v)

        # update critic
        v += alpha_critic * delta

        # update actor --- stage 1
        for i in xrange(0,dim):
            if delta < 0:
                context[current_context][0][i] += alpha_actor_1 * vis_act[i] * act_A_1[current_context] * delta * context[current_context][0][i]
                context[current_context][1][i] += alpha_actor_1 * vis_act[i] * act_B_1[current_context] * delta * context[current_context][1][i]
            else:
                context[current_context][0][i] += alpha_actor_1 * vis_act[i] * act_A_1[current_context] * delta * (1 - context[current_context][0][i])
                context[current_context][1][i] += alpha_actor_1 * vis_act[i] * act_B_1[current_context] * delta * (1 - context[current_context][1][i])

            context[current_context][0][i] = cap(context[current_context][0][i])
            context[current_context][1][i] = cap(context[current_context][1][i])

        # allocate a new context when...
        if np.max(contingency_max[current_context] - contingency[current_context]) > new_context_thresh:
            w_A_1 = np.random.normal(w_base, w_noise, dim)
            w_B_1 = np.random.normal(w_base, w_noise, dim)
            context.append([w_A_1, w_B_1])
            current_context += 1

            act_A_1.append(0)
            act_B_1.append(0)
            conf_pos.append([0])
            conf_neg.append([0])
            conf_pos_mean.append(0)
            conf_neg_mean.append(0)
            discrim.append(0)
            resp.append(0)
            r.append(0)
            contingency.append(0)
            contingency_previous.append(0)
            contingency_max.append(0)

        # switch context when...



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
        data_record['resp'].append(resp_obs)
        data_record['accuracy'].append(cat == resp_obs)
        data_record['contingency'].append(copy.deepcopy(contingency))
        data_record['context'].append(current_context)
        data_record['delta'].append(delta)

        trial += 1

    return(data_record)
