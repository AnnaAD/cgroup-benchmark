import numpy as np
import time
import sys

if len(sys.argv) != 2:
    print("Usage: python matrix_multiply.py N")
    sys.exit(1)

try:
    N = int(sys.argv[1])
except ValueError:
    print("N must be an integer.")
    sys.exit(1)

while True:
    # Generate random NxN matrices
    matrix1 = np.random.rand(N, N)
    matrix2 = np.random.rand(N, N)

    # Measure the time taken for matrix multiplication
    start_time = time.time()
    result = np.dot(matrix1, matrix2)
    end_time = time.time()

    # Print the time taken
    print(f"{time.strftime("%b %d %Y %H:%M:%S", time.time())} {N}x{N} matrices: {end_time - start_time} seconds")