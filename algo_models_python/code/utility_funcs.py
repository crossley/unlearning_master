from experiment_imports import *

# Converts np.array to TEXT when inserting
def adapt_array(arr):
    """
    http://stackoverflow.com/a/31312102/190597 (SoulNibbler)
    """
    out = io.BytesIO()
    np.save(out, arr)
    out.seek(0)
    return sql.Binary(out.read())

# Converts TEXT to np.array when selecting
def convert_array(text):
    out = io.BytesIO(text)
    out.seek(0)
    return np.load(out)

# Utility function
def cap(val):
    val = 0.0 if val < 0.0 else val
    val = 1.0 if val > 1.0 else val
    return val

def pos(val):
    val = 0.0 if val < 0.0 else val
    return val

def movingaverage(interval, window_size):
    window = np.ones(int(window_size))/float(window_size)
    return np.convolve(interval, window, 'same')

# def logistic(x):
#     k = 6.0
#     x_mid = 1.0
#     return 1.0 / ( 1.0 + np.exp(-k*(2*x-x_mid)))

def logistic(x, k, x_mid):
    # k = 10.0
    # x_mid = 1.0
    return 1.0 / ( 1.0 + np.exp(-k*(2*x-x_mid)))

def exponential(x, amp, rate):
    return(amp * np.exp(rate*x))

def save_obj(obj, name):
    with open(name + '.pkl', 'wb') as f:
        pickle.dump(obj, f, pickle.HIGHEST_PROTOCOL)

def load_obj(name):
    with open(name + '.pkl', 'rb') as f:
        return pickle.load(f)

def gen_stim(mean, cov, cat_lab, num_stim):

    x =  []
    y = []
    cat = []

    for i in xrange(len(mean)):
        m = mean[i]
        c = cov[i]

        xy = np.random.multivariate_normal(m, c, num_stim[i])
        lab = [cat_lab[i]] * num_stim[i]

        x = np.append(x, xy[:,0])
        y = np.append(y, xy[:,1])
        cat = np.append(cat, lab)

    return {'cat' : cat, 'x' : x, 'y' : y}
