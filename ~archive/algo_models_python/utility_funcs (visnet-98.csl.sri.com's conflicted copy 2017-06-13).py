from experiment_imports import *

# Utility function
def cap(val):
    val = 0.0 if val < 0.0 else val
    val = 1.0 if val > 1.0 else val
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
