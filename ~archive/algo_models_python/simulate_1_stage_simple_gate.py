from experiment_imports import *
from utility_funcs import *


def simulate(params, stimuli, num_simulations):

    vis_width = params[0]
    alpha_critic = params[1]
    alpha_actor_1 = params[2]
    alpha_gate = params[3]
    stim = stimuli

    data_record = {'cat': [],
                   'x': [],
                   'y': [],
                   'resp': [],
                   'accuracy': [],
                   'contingency': [],
                   'context': [],
                   'delta' : [],
                   'w_gate' : [],
                   'w_sr' : []}

    plot_every = 900

    # static params:
    dim = 100
    w_base = 0.5
    w_noise = 0.25
    vis_amp = 1.0
    w_gate = 1.0
    w_vis_act = 0.5

    # init buffers
    vis_act = np.zeros(dim**2)
    cumulative_weight_change = np.zeros(dim**2)
    mean_weight_change = 0.0
    w_A_1 = np.random.normal(w_base, w_noise, dim**2)
    w_B_1 = np.random.normal(w_base, w_noise, dim**2)

    # lists to store info for different contexts
    # NOTE: Context as a list of lists may seems a
    # bit strange for the simple gate model
    # The reason is that it shares the same base as the context model
    context = [[w_A_1, w_B_1]]
    current_context = 0

    act_A_1_pure = [0]
    act_B_1_pure = [0]
    act_A_1 = [0]
    act_B_1 = [0]
    conf_pos = [[0]]
    conf_neg = [[0]]
    conf_pos_mean = [0]
    conf_neg_mean = [0]
    discrim = [0]
    discrim_pure = [0]
    discrim_rb = [0]
    resp = [0]
    r = [0]
    contingency = [0]
    contingency_previous = [0]
    contingency_max = [0]

    contingency_window = 25
    new_context_thresh = 0.01

    # kalman filter approach
    measurement_noise = [5.0e-2]
    process_variance = [1.0e-4]
    kalman_gain = [0.0]

    x_obs_pos = [0.0]
    x_prior_pos = [0.0]
    x_posterior_pos = [0.0]
    err_prior_pos = [0.0]
    err_posterior_pos = [0.0]
    kalman_gain_pos = [0.0]

    x_obs_neg = [0.0]
    x_prior_neg = [0.0]
    x_posterior_neg = [0.0]
    err_prior_neg = [0.0]
    err_posterior_neg = [0.0]
    kalman_gain_neg = [0.0]

    x_obs_diff = [0.0]
    x_prior_diff = [0.0]
    x_posterior_diff = [0.0]
    err_prior_diff = [0.0]
    err_posterior_diff = [0.0]
    kalman_gain_diff = [0.0]

    k_gate = 20.0
    x_mid_gate = 1.5

    k_weight = -30.0
    x_mid_weight = 0.1

    k_novelty = -.05
    x_mid_novelty = 400.0

    # init
    v = 0.0
    num_trials = len(stim['cat'])
    for simulation in xrange(num_simulations):
        for trial in xrange(num_trials):

            cat = stim['cat'][trial]
            x = stim['x'][trial]
            y = stim['y'][trial]

            # compute input activation via radial basis functions
            # also implement presynaptic inhibition --- gate the input
            vis_dist_x = 0.0
            vis_dist_y = 0.0
            for i in xrange(0, dim):
                for j in xrange(0, dim):
                    vis_dist_x = x - i
                    vis_dist_y = y - j

                    vis_act[j + i * dim] = vis_amp * math.exp(-(
                        vis_dist_x**2 + vis_dist_y**2) / vis_width)

                    # vis_act[j + i * dim] *= w_vis_act * logistic(w_gate, k_gate, x_mid_gate)

            # Each context is evolved in parallel and independently
            for x in xrange(len(context)):

                # Compute A and B unit activations via dot product --- stage 1
                act_A_1_pure[x] = np.inner(vis_act, context[x][0])
                act_B_1_pure[x] = np.inner(vis_act, context[x][1])

                act_A_1[x] = np.inner(vis_act * w_vis_act * logistic(w_gate, k_gate, x_mid_gate), context[x][0])
                act_B_1[x] = np.inner(vis_act * w_vis_act * logistic(w_gate, k_gate, x_mid_gate), context[x][1])

                # add noise to output units
                act_A_1_pure[x] += np.random.normal(w_base, w_noise, 1)
                act_B_1_pure[x] += np.random.normal(w_base, w_noise, 1)

                act_A_1[x] += np.random.normal(w_base, w_noise, 1)
                act_B_1[x] += np.random.normal(w_base, w_noise, 1)

                # Compute resp via max
                discrim[x] = (act_A_1[x] - act_B_1[x]) / np.max(
                    [act_A_1[x], act_B_1[x]])

                discrim_pure[x] = (act_A_1_pure[x] - act_B_1_pure[x]) / np.max(
                    [act_A_1_pure[x], act_B_1_pure[x]])

                resp[x] = 1 if discrim[x] > 0 else 2

                # Implement strong lateral inhibition --- stage 1
                act_A_1[x] = act_A_1[x] if act_A_1[x] > act_B_1[x] else 0.0
                act_B_1[x] = act_B_1[x] if act_B_1[x] > act_A_1[x] else 0.0

                # compute outcome
                r[x] = 1.0 if cat == resp[x] else -1.0

                if trial > 300 and trial <= 600:
                    r[x] = 1.0 if np.random.uniform(0.0, 1.0) > 0.5 else -1.0

                # kalman filter contingency tracking:
                x_pre = copy.deepcopy(contingency[x])

                # use kalman filter to track pos and neg confidence
                if r[x] == 1.0:
                    x_obs_pos[x] = np.abs(discrim_pure[x])
                    x_obs_neg[x] = 0.0
                else:
                    x_obs_pos[x] = 0.0
                    x_obs_neg[x] = np.abs(discrim_pure[x])

                # prediction update
                x_prior_pos[x] = x_posterior_pos[x]
                err_prior_pos[x] = err_posterior_pos[x] + process_variance[x]

                # measurement update
                kalman_gain_pos[x] = err_prior_pos[x] / (err_prior_pos[x] + measurement_noise[x])
                x_posterior_pos[x] = x_prior_pos[x] + kalman_gain_pos[x] * (x_obs_pos[x] - x_prior_pos[x])
                err_posterior_pos[x] = (1.0 - kalman_gain[x]) * err_prior_pos[x]

                # prediction update
                x_prior_neg[x] = x_posterior_neg[x]
                err_prior_neg[x] = err_posterior_neg[x] + process_variance[x]

                # measurement update
                kalman_gain_neg[x] = err_prior_neg[x] / (err_prior_neg[x] + measurement_noise[x])
                x_posterior_neg[x] = x_prior_neg[x] + kalman_gain_neg[x] * (x_obs_neg[x] - x_prior_neg[x])
                err_posterior_neg[x] = (1.0 - kalman_gain_neg[x]) * err_prior_neg[x]

                contingency[x] = x_posterior_pos[x] - x_posterior_neg[x]

                # Track the maximum observed contingency for this context
                contingency_max[x] = contingency[x] if contingency[
                    x] > contingency_max[x] else contingency_max[x]

                # x_obs_diff = contingency[x] - x_pre
                # if r[x] == 1.0:
                #     # prediction update
                #     x_prior_diff[x] = x_posterior_diff[x]
                #     err_prior_diff[x] = err_posterior_diff[x] + process_variance[x]

                #     # measurement update
                #     kalman_gain_diff[x] = err_prior_diff[x] / (err_prior_diff[x] + measurement_noise[x])
                #     x_posterior_diff[x] = x_prior_diff[x] + kalman_gain_diff[x] * (x_obs[x] - x_prior_diff[x])
                #     err_posterior_diff[x] = (1.0 - kalman_gain[x]) * err_prior_diff[x]

                # print 'observed contingency ' + str( contingency_obs[x] )
                # print 'contingency prior ' + str( contingency_prior[x] )
                # print 'contingency posterior ' + str( contingency_posterior[x] )
                # print 'error prior ' + str( error_prior[x] )
                # print 'error posterior ' + str( error_posterior[x] )
                # print 'kalman gain ' + str( kalman_gain[x] )
                # print 'measurement noise ' + str( measurement_noise[x] )
                # print 'process variance ' + str( process_variance[x] )

            # Compute resp via max
            resp_obs = resp[current_context]

            # compute outcome
            r_obs = r[current_context]

            # compute prediction error
            delta = (r_obs - v)

            # scale delta by contingency and novelty
            novelty = logistic(trial, k_novelty, x_mid_novelty)
            delta *=  contingency[current_context] + novelty
            delta -= .25*(contingency_max[current_context] - contingency[current_context])

            # update critic
            v += alpha_critic * delta

            # update gate
            if delta < 0:
                w_gate += alpha_gate * delta * w_gate
            else:
                w_gate += alpha_gate * delta * (1 - w_gate)
            w_gate = cap(w_gate)

            # update actor --- stage 1
            for i in xrange(0, dim**2):
                if delta < 0:
                    weight_change_A = alpha_actor_1 * vis_act[
                        i] * act_A_1[current_context] * delta * context[
                            current_context][0][i]

                    context[current_context][0][i] += weight_change_A

                    weight_change_B = alpha_actor_1 * vis_act[
                        i] * act_B_1[current_context] * delta * context[
                            current_context][1][i]

                    context[current_context][1][i] += weight_change_B
                else:
                    weight_change_A = alpha_actor_1 * vis_act[
                        i] * act_A_1[current_context] * delta * (
                            1 - context[current_context][0][i])

                    context[current_context][0][i] += weight_change_A

                    weight_change_B = alpha_actor_1 * vis_act[
                        i] * act_B_1[current_context] * delta * (
                            1 - context[current_context][1][i])

                    context[current_context][1][i] += weight_change_B

                cumulative_weight_change[i] += (weight_change_A + weight_change_B)

                context[current_context][0][i] = cap(context[current_context][0][i])
                context[current_context][1][i] = cap(context[current_context][1][i])

            mean_weight_change = np.mean(cumulative_weight_change)

            # diagnostic plot
            if trial % plot_every == 0:
                print trial

                fig = plt.figure(figsize=(20, 10))

                ax = fig.add_subplot(2, 3, 1)
                grid_vis = vis_act * w_vis_act * logistic(w_gate, k_gate, x_mid_gate)
                grid_vis = grid_vis.reshape((dim, dim))
                ax.imshow(grid_vis, vmin=0.0, vmax=1.0)
                plt.imshow(grid_vis, vmin=0.0, vmax=1.0)
                plt.colorbar()
                ax.set_xlim([0, 100])
                ax.set_ylim([0, 100])
                ax.set_xlabel('Spatial Frequency')
                ax.set_ylabel('Orientation')
                ax.set_title('Visual Input')

                ax = fig.add_subplot(2, 3, 2)
                grid_A = context[current_context][0].reshape((dim, dim))
                ax.imshow(grid_A, vmin=0.0, vmax=1.0)
                plt.imshow(grid_A, vmin=0.0, vmax=1.0)
                plt.colorbar()
                ax.set_xlim([0, 100])
                ax.set_ylim([0, 100])
                ax.set_xlabel('Spatial Frequency')
                ax.set_ylabel('Orientation')
                ax.set_title('Connection Weights A')

                ax = fig.add_subplot(2, 3, 3)
                grid_B = context[current_context][1].reshape((dim, dim))
                ax.imshow(grid_B, vmin=0.0, vmax=1.0)
                plt.imshow(grid_B, vmin=0.0, vmax=1.0)
                plt.colorbar()
                ax.set_xlim([0, 100])
                ax.set_ylim([0, 100])
                ax.set_xlabel('Spatial Frequency')
                ax.set_ylabel('Orientation')
                ax.set_title('Connection Weights B')

                ax = fig.add_subplot(2, 3, 4)
                ax.plot(np.linspace(0, 1, num=100), logistic(np.linspace(0, 1, num=100), k_gate, x_mid_gate))
                ax.axvline(x=w_gate, color='r')
                ax.set_xlabel('w gate')
                ax.set_ylabel('gate act')
                ax.set_xlim([-.1, 1.1])
                ax.set_ylim([-.1, 1.1])

                # ax = fig.add_subplot(2, 3, 5)
                # ax.plot(np.linspace(0, 2, num=100), logistic(np.linspace(0, 2, num=100), k_weight, x_mid_weight))
                # ax.axvline(x=mean_weight_change, color='r')
                # ax.set_xlabel('mean cumulative weight change')
                # ax.set_ylabel('weight factor')
                # ax.set_xlim([-.1, 2.1])
                # ax.set_ylim([-.1, 1.1])

                ax = fig.add_subplot(2, 3, 5)
                ax.plot(np.linspace(0, 900, num=900), logistic(np.linspace(0, 900, num=900), k_novelty, x_mid_novelty))
                ax.axvline(x=trial, color='r')
                ax.set_xlabel('Trial')
                ax.set_ylabel('Novelty')
                ax.set_xlim([-.1, 900.1])
                ax.set_ylim([-.1, 1.1])

                # ax = fig.add_subplot(2, 3, 6)
                # ax.bar((1, 2, 3),
                #        (act_A_1[current_context], act_B_1[current_context],
                #         np.abs(discrim[x])),
                #        align='center',
                #        width=0.5)
                # ax.set_xticks([1, 2, 3])
                # ax.set_ylim(0)
                # ax.set_xticklabels(['MSN A', 'MSN B', 'Discrim'])
                # ax.set_xlabel('MSN')
                # ax.set_ylabel('Activation')
                # ax.set_title('MSN Activation')

                ax = fig.add_subplot(2, 3, 6)
                ax.plot([x[0] for x in data_record['contingency']])
                ax.set_xlim([-.1, 900.1])
                ax.set_xlabel('Trial')
                ax.set_ylabel('Contingency')
                ax.set_title('Contingency')

                # ax = fig.add_subplot(2, 3, 6)
                # ax.bar((1, 2),
                #        (np.abs(x_posterior_pos[x]),
                #         np.abs(x_posterior_neg[x])),
                #        align='center',
                #        width=0.5)
                # ax.set_xticks([1, 2, 3])
                # ax.set_ylim(0)
                # ax.set_xticklabels(['Pos', 'Neg'])
                # ax.set_xlabel('MSN')
                # ax.set_ylabel('Activation')
                # ax.set_title('MSN Activation')

                # ax = fig.add_subplot(2, 3, 6)
                # ax.bar((1), (r_obs), align='center', width=0.5)
                # ax.set_xlabel('')
                # ax.set_ylabel('')
                # ax.set_ylim([-1, 1])
                # ax.set_title('Obtained Reward')

                plt.show()

            # record keeping
            data_record['cat'].append(cat)
            data_record['x'].append(x)
            data_record['y'].append(0.0)
            data_record['resp'].append(resp_obs)
            data_record['accuracy'].append(cat == resp_obs)
            data_record['contingency'].append(copy.deepcopy(contingency))
            # data_record['context'].append(current_context)
            # data_record['context'].append(weight_change_factor)
            data_record['context'].append(copy.deepcopy(novelty))
            data_record['delta'].append(delta)
            data_record['w_gate'].append(logistic(w_gate, k_gate, x_mid_gate))
            data_record['w_sr'].append(mean_weight_change)

            trial += 1

    # compute average over simulations
    data_record_mean = {'accuracy': [0] * num_trials,
                        'contingency': [0] * num_trials,
                        'context': [0] * num_trials,
                        'delta': [0] * num_trials,
                        'w_gate': [0] * num_trials,
                        'w_sr': [0] * num_trials}

    data_record['contingency'] = [x[0] for x in data_record['contingency']]

    for t in xrange(num_trials):
        for s in xrange(num_simulations):
            for key in data_record_mean.keys():
                data_record_mean[key][t] = data_record_mean[key][
                    t] + data_record[key][t + s * num_trials]

    for key in data_record_mean.keys():
        data_record_mean[key] = [x / num_simulations
                                 for x in data_record_mean[key]]

    return (data_record_mean)
