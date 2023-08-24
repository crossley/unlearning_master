from experiment_imports import *
from utility_funcs import *

def simulate(stimuli, num_simulations, params):

    vis_width = params[0]
    alpha_critic = params[1]
    alpha_actor = params[2]
    alpha_gate = params[3]
    stim = stimuli

    data_record = {'cat': [],
                   'x': [],
                   'y': [],
                   'resp': [], 'accuracy': [],
                   'contingency': [],
                   'context': [],
                   'delta' : [],
                   'w_gate' : [],
                   'w_sr' : []}

    plot_every = 300

    # static params:
    dim = 100
    w_base = 0.5
    w_noise = 0.25
    vis_amp = 1.0
    w_gate = 1.0
    w_vis_act = 0.15

    # init buffers
    vis_act = np.zeros(dim**2)
    cumulative_weight_change = np.zeros(dim**2)
    mean_weight_change = 0.0
    w_A = np.random.normal(w_base, w_noise, dim**2)
    w_B = np.random.normal(w_base, w_noise, dim**2)
    w_C = np.random.normal(w_base, w_noise, dim**2)
    w_D = np.random.normal(w_base, w_noise, dim**2)

    # lists to store info for different contexts
    # NOTE: Context as a list of lists may seems a
    # bit strange for the simple models
    # The reason is that it shares the same base as the context model
    context = [[w_A, w_B, w_C, w_D]]
    current_context = 0

    act_A_pure = [0]
    act_B_pure = [0]
    act_C_pure = [0]
    act_D_pure = [0]
    act_A = [0]
    act_B = [0]
    act_C = [0]
    act_D = [0]
    conf_pos = [[0]]
    conf_neg = [[0]]
    conf_pos_mean = [0]
    conf_neg_mean = [0]
    discrim = [0]
    discrim_pure = [0]
    discrim_rb = [0]
    resp = [0]
    resp_pure = [0]
    r = [0]
    contingency = [0]
    contingency_previous = [0]
    contingency_max = [0]

    contingency_window = 25
    new_context_thresh = 0.01

    # kalman filter approach
    measurement_noise = [5.0e-1]
    process_variance = [5.0e-5]
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

    k_gate = 30.0
    x_mid_gate = 1.0

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
            # NOTE: just one context for the simple models
            for x in xrange(len(context)):

                # Compute A and B unit activations via dot product --- stage 1
                act_A_pure[x] = np.inner(vis_act, context[x][0])
                act_B_pure[x] = np.inner(vis_act, context[x][1])
                act_C_pure[x] = np.inner(vis_act, context[x][2])
                act_D_pure[x] = np.inner(vis_act, context[x][3])

                act_A[x] = np.inner(vis_act * w_vis_act * logistic(w_gate, k_gate, x_mid_gate), context[x][0])
                act_B[x] = np.inner(vis_act * w_vis_act * logistic(w_gate, k_gate, x_mid_gate), context[x][1])
                act_C[x] = np.inner(vis_act * w_vis_act * logistic(w_gate, k_gate, x_mid_gate), context[x][2])
                act_D[x] = np.inner(vis_act * w_vis_act * logistic(w_gate, k_gate, x_mid_gate), context[x][3])

                # add noise to output units
                act_A_pure[x] += np.random.normal(w_base, w_noise, 1)
                act_B_pure[x] += np.random.normal(w_base, w_noise, 1)
                act_C_pure[x] += np.random.normal(w_base, w_noise, 1)
                act_D_pure[x] += np.random.normal(w_base, w_noise, 1)

                act_A[x] += np.random.normal(w_base, w_noise, 1)
                act_B[x] += np.random.normal(w_base, w_noise, 1)
                act_C[x] += np.random.normal(w_base, w_noise, 1)
                act_D[x] += np.random.normal(w_base, w_noise, 1)

                # Compute resp via max
                act_array = np.array([act_A[x][0], act_B[x][0], act_C[x][0], act_D[x]])
                act_sort_ind = np.argsort(act_array)

                act_array_pure = np.array([act_A_pure[x][0], act_B_pure[x][0], act_C_pure[x][0], act_D_pure[x]])
                act_sort_ind_pure = np.argsort(act_array_pure)

                # resp is ind + 1 because python indices are zero based
                resp[x] = act_sort_ind[3] + 1
                resp_pure[x] = act_sort_ind_pure[3] + 1

                # discrim is difference between the 2 most active units
                discrim[x] = (act_array[3] - act_array[2]) / act_array[3]
                discrim_pure[x] = (act_array_pure[3] - act_array_pure[2]) / act_array_pure[3]

                # Implement strong lateral inhibition --- stage 1
                act_A[x] = act_A[x] if resp[x] == 1 else 0.0
                act_B[x] = act_B[x] if resp[x] == 2 else 0.0
                act_C[x] = act_C[x] if resp[x] == 3 else 0.0
                act_D[x] = act_D[x] if resp[x] == 4 else 0.0

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

            # Compute resp via max
            resp_obs = resp[current_context]

            # compute outcome
            r_obs = r[current_context]

            # compute prediction error
            delta = (r_obs - v)

            # scale delta by contingency and novelty
            novelty = logistic(trial, k_novelty, x_mid_novelty)
            # delta *=  contingency[current_context] + novelty
            # delta -= .5*(contingency_max[current_context] - contingency[current_context])

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
                    weight_change_A = alpha_actor * vis_act[i] * act_A[current_context] * delta * context[current_context][0][i]
                    context[current_context][0][i] += weight_change_A

                    weight_change_B = alpha_actor * vis_act[i] * act_B[current_context] * delta * context[current_context][1][i]
                    context[current_context][1][i] += weight_change_B

                    weight_change_C = alpha_actor * vis_act[i] * act_C[current_context] * delta * context[current_context][2][i]
                    context[current_context][2][i] += weight_change_C

                    weight_change_D = alpha_actor * vis_act[i] * act_D[current_context] * delta * context[current_context][3][i]
                    context[current_context][3][i] += weight_change_D
                else:
                    weight_change_A = alpha_actor * vis_act[i] * act_A[current_context] * delta * (1 - context[current_context][0][i])
                    context[current_context][0][i] += weight_change_A

                    weight_change_B = alpha_actor * vis_act[i] * act_B[current_context] * delta * (1 - context[current_context][1][i])
                    context[current_context][1][i] += weight_change_B

                    weight_change_C = alpha_actor * vis_act[i] * act_C[current_context] * delta * (1 - context[current_context][2][i])
                    context[current_context][2][i] += weight_change_C

                    weight_change_D = alpha_actor * vis_act[i] * act_D[current_context] * delta * (1 - context[current_context][3][i])
                    context[current_context][3][i] += weight_change_D

                cumulative_weight_change[i] += (weight_change_A + weight_change_B + weight_change_C + weight_change_D)

                context[current_context][0][i] = cap(context[current_context][0][i])
                context[current_context][1][i] = cap(context[current_context][1][i])
                context[current_context][2][i] = cap(context[current_context][2][i])
                context[current_context][3][i] = cap(context[current_context][3][i])

            mean_weight_change = np.mean(cumulative_weight_change)

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
        data_record_mean[key] = [x / float(num_simulations)
                                 for x in data_record_mean[key]]

    return (data_record_mean)

def plot_diagnostics():
    fig = plt.figure(figsize=(20, 10))

    ax = fig.add_subplot(2, 5, 1)
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

    ax = fig.add_subplot(2, 5, 2)
    grid_A = context[current_context][0].reshape((dim, dim))
    ax.imshow(grid_A, vmin=0.0, vmax=1.0)
    plt.imshow(grid_A, vmin=0.0, vmax=1.0)
    plt.colorbar()
    ax.set_xlim([0, 100])
    ax.set_ylim([0, 100])
    ax.set_xlabel('Spatial Frequency')
    ax.set_ylabel('Orientation')
    ax.set_title('Connection Weights A')

    ax = fig.add_subplot(2, 5, 3)
    grid_B = context[current_context][1].reshape((dim, dim))
    ax.imshow(grid_B, vmin=0.0, vmax=1.0)
    plt.imshow(grid_B, vmin=0.0, vmax=1.0)
    plt.colorbar()
    ax.set_xlim([0, 100])
    ax.set_ylim([0, 100])
    ax.set_xlabel('Spatial Frequency')
    ax.set_ylabel('Orientation')
    ax.set_title('Connection Weights B')

    ax = fig.add_subplot(2, 5, 4)
    grid_C = context[current_context][2].reshape((dim, dim))
    ax.imshow(grid_C, vmin=0.0, vmax=1.0)
    plt.imshow(grid_C, vmin=0.0, vmax=1.0)
    plt.colorbar()
    ax.set_xlim([0, 100])
    ax.set_ylim([0, 100])
    ax.set_xlabel('Spatial Frequency')
    ax.set_ylabel('Orientation')
    ax.set_title('Connection Weights B')

    ax = fig.add_subplot(2, 5, 5)
    grid_D = context[current_context][3].reshape((dim, dim))
    ax.imshow(grid_D, vmin=0.0, vmax=1.0)
    plt.imshow(grid_D, vmin=0.0, vmax=1.0)
    plt.colorbar()
    ax.set_xlim([0, 100])
    ax.set_ylim([0, 100])
    ax.set_xlabel('Spatial Frequency')
    ax.set_ylabel('Orientation')
    ax.set_title('Connection Weights B')

    ax = fig.add_subplot(2, 5, 6)
    ax.plot(np.linspace(0, 1, num=100), logistic(np.linspace(0, 1, num=100), k_gate, x_mid_gate))
    ax.axvline(x=w_gate, color='r')
    ax.set_xlabel('w gate')
    ax.set_ylabel('gate act')
    ax.set_xlim([-.1, 1.1])
    ax.set_ylim([-.1, 1.1])

    # ax = fig.add_subplot(2, 5, 5)
    # ax.plot(np.linspace(0, 2, num=100), logistic(np.linspace(0, 2, num=100), k_weight, x_mid_weight))
    # ax.axvline(x=mean_weight_change, color='r')
    # ax.set_xlabel('mean cumulative weight change')
    # ax.set_ylabel('weight factor')
    # ax.set_xlim([-.1, 2.1])
    # ax.set_ylim([-.1, 1.1])

    ax = fig.add_subplot(2, 5, 7)
    ax.plot(np.linspace(0, 900, num=900), logistic(np.linspace(0, 900, num=900), k_novelty, x_mid_novelty))
    ax.axvline(x=trial, color='r')
    ax.set_xlabel('Trial')
    ax.set_ylabel('Novelty')
    ax.set_xlim([-.1, 900.1])
    ax.set_ylim([-.1, 1.1])

    # ax = fig.add_subplot(2, 5, 6)
    # ax.bar((1, 2, 3),
    #        (act_A[current_context], act_B[current_context],
    #         np.abs(discrim[x])),
    #        align='center',
    #        width=0.5)
    # ax.set_xticks([1, 2, 3])
    # ax.set_ylim(0)
    # ax.set_xticklabels(['MSN A', 'MSN B', 'Discrim'])
    # ax.set_xlabel('MSN')
    # ax.set_ylabel('Activation')
    # ax.set_title('MSN Activation')

    ax = fig.add_subplot(2, 5, 8)
    ax.plot([x[0] for x in data_record['contingency']])
    ax.set_xlim([-.1, 900.1])
    ax.set_xlabel('Trial')
    ax.set_ylabel('Contingency')
    ax.set_title('Contingency')

    # ax = fig.add_subplot(2, 5, 6)
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

    # ax = fig.add_subplot(2, 5, 6)
    # ax.bar((1), (r_obs), align='center', width=0.5)
    # ax.set_xlabel('')
    # ax.set_ylabel('')
    # ax.set_ylim([-1, 1])
    # ax.set_title('Obtained Reward')

    plt.show()

def psp_func(stimuli, num_simulations, params):
    results = simulate(stimuli, num_simulations, params)
    p = [[x]*len(results['accuracy']) for x in params]
    p.append(results['accuracy'])
    p = map(list, zip(*p))

    p = np.asarray(p)

    table_name = "sim_" + str(params).replace(" ",
    "_").replace("(","").replace(")","").replace(",","").replace("0.","")

    # register sqlite I/O utility functions
    sql.register_adapter(np.ndarray, adapt_array)
    sql.register_converter('array', convert_array)

    db_name = '../output/psp_results_1_stage_4_cat_db'
    con = sql.connect(db_name, detect_types=sql.PARSE_DECLTYPES)
    cur = con.cursor()
    cur.execute('CREATE TABLE IF NOT EXISTS ' + table_name + ' (arr array)')
    cur.execute('INSERT INTO ' + table_name + ' (arr) VALUES (?)', (p, ))
    con.commit()
    con.close()

def psp(n_pool, stimuli, num_simulations):

    vis_width = np.arange(10,25,5)
    alpha_critic = np.arange(.01,.05,.01)
    alpha_actor_1 = np.arange(.01,.05,.01)
    alpha_gate = np.arange(0.01,.05,.01)

    # vis_width = np.arange(20,25,5)
    # alpha_critic = np.arange(.01,.02,.01)
    # alpha_actor_1 = np.arange(.01,.02,.01)
    # alpha_gate = np.arange(0.01,.03,.01)

    # generate every possible combination of parameters
    params = list(itertools.product(*[vis_width,alpha_critic,alpha_actor_1,alpha_gate]))
    print params

    pool = Pool(n_pool)
    func = partial(psp_func, stimuli, num_simulations)
    results = pool.map(func, params)
    pool.close()
    pool.join()

    return results

def psp_plot():

    fs_title = 18
    fs_axis = 18
    fs_tick = 18

    # database I/O
    db_name = '../output/psp_results_1_stage_4_cat_db'
    con = sql.connect(db_name, detect_types=sql.PARSE_DECLTYPES)
    cur = con.cursor()
    cur.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cur.fetchall()
    tables = [x[0] for x in tables]

    # register sqlite I/O utility functions to convert from and to numpy arrays
    sql.register_adapter(np.ndarray, adapt_array)
    sql.register_converter('array', convert_array)

    data = []
    for t in tables:
        cur.execute('SELECT arr FROM ' + t)
        data.append(pd.DataFrame(cur.fetchone()[0]))

    con.close()
    d = pd.concat(data)

    d.columns = ['vis_width', 'alpha_critic', 'alpha_actor', 'alpha_gate', 'accuracy']
    d.info(memory_usage='deep')

    dd = d.groupby(['vis_width', 'alpha_critic', 'alpha_actor', 'alpha_gate'])

    def get_pattern(group):
        p1 = group['accuracy'][201:300].mean()
        p2 = group['accuracy'][501:600].mean()
        p3 = group['accuracy'][601:700].mean()

        pattern = 0

        epsilon = .1
        # fast
        if p1 > .4 and p2 < p1 + epsilon and p3 > p1 + epsilon:
            pattern = 1
        # slow
        elif p1 > .4 and p2 < p1 + epsilon and p3 > p1 + epsilon:
            pattern = 2
        # same
        elif p1 > .4 and p2 < p1 + epsilon and np.abs(p1 - p3) < epsilon:
            pattern = 3
        # non_learner
        elif p1 < .4:
            pattern = 4
        # non_extinguisher
        elif p2 >= p1 + epsilon:
            pattern = 5

        return [p1, p2, p3, pattern]

    ddd = pd.DataFrame(dd.apply(get_pattern))
    ddd.reset_index(inplace=True)
    ddd.columns = ['vis_width', 'alpha_critic', 'alpha_actor', 'alpha_gate', 'pattern']

    pattern_results = ddd['pattern'].values
    p1 = [x[0] for x in pattern_results]
    p2 = [x[1] for x in pattern_results]
    p3 = [x[2] for x in pattern_results]
    pattern = [x[3] for x in pattern_results]

    # plot 3d scatter plot
    pp = PdfPages('../figures/results_1_stage_4_cat.pdf')

    fig = plt.figure(figsize=(18,12))
    ax = fig.add_subplot(1, 1, 1, projection='3d')

    xs = p1
    ys = p2
    zs = p3
    # xs = [xs[i] for i in xrange(0,len(xs), 100)]
    # ys = [ys[i] for i in xrange(0,len(ys), 100)]
    # zs = [zs[i] for i in xrange(0,len(zs), 100)]
    ax.scatter(xs, ys, zs, c=(1,0,0), marker='o', alpha = .7)

    ax.set_xlim3d(0,1)
    ax.set_ylim3d(0,1)
    ax.set_zlim3d(0,1)
    ax.set_xlabel('Acquisition Accuracy')
    ax.set_ylabel('Intervention Accuracy')
    ax.set_zlabel('Reacquisition Accuracy')

    # tweak the axis labels
    xlab = ax.xaxis.get_label()
    ylab = ax.yaxis.get_label()
    zlab = ax.zaxis.get_label()
    xlab.set_size(fs_axis)
    ylab.set_size(fs_axis)
    zlab.set_size(fs_axis)
    xlab.set_weight('bold')
    ylab.set_weight('bold')
    zlab.set_weight('bold')

    # ax.set_title('Simulated Trials to Criterion in Each Condition')
    ttl = ax.title
    ttl.set_weight('bold')
    ttl.set_size(fs_title)

    ax.view_init(elev=15, azim=-135)
    # ax.view_init(elev=15, azim=-100)

    ax.annotate('B', xy=(10, -10),
                xycoords='axes points',
                horizontalalignment='left', verticalalignment='top',
                fontsize=20)

    fig.tight_layout()
    plt.show()
    pp.savefig(fig)
    pp.close()
