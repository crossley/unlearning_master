import numpy as np
import matplotlib.pyplot as plt
import sys


def read_result_file(file_path):
    return np.loadtxt(file_path)


def plot_generic(size):
    plt.legend(loc=0)
    plt.axvline(size / 3, color='k', alpha=0.5)
    plt.axvline(size * 2 / 3, color='k', alpha=0.5)
    plt.show()


def plot_results_1(result, result_label):
    plt.plot(result, label=result_label)
    plot_generic(result.size)


def plot_results_2(result_0, result_label_0, result_1, result_label_1):
    plt.plot(result_0, 'k--', label=result_label_0)
    plt.plot(result_1, 'k-', label=result_label_1)
    plot_generic(result_0.size)


def plot_results_3(result_0, result_label_0, result_1, result_label_1, result_2, result_label_2):
    plt.plot(result_0, 'k--', label=result_label_0)
    plt.plot(result_1, 'k-', label=result_label_1)
    plt.plot(result_2, 'k-.', label=result_label_2)
    plot_generic(result_0.size)


def main():
    num_args = len(sys.argv) - 1
    args = sys.argv
    if num_args == 0:
        print("Please enter a command.")
    elif num_args == 2:
        result = read_result_file(args[1])
        plot_results_1(result, args[2])
    elif num_args == 4:
        result_0 = read_result_file(args[1])
        result_1 = read_result_file(args[3])
        plot_results_2(result_0, args[2], result_1, args[4])
    elif num_args == 6:
        result_0 = read_result_file(args[1])
        result_1 = read_result_file(args[3])
        result_2 = read_result_file(args[5])
        plot_results_3(result_0, args[2], result_1, args[4], result_2, args[6])
    else:
        print("Incorrect arguments")


if __name__ == "__main__":
    main()
