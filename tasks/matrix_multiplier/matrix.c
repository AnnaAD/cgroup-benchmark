#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void generate_random_matrix(int rows, int cols, int **matrix) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            matrix[i][j] = rand() % 256;  // Generate a random number between 0 and 9
        }
    }
}

void multiply_matrices(int rows1, int cols1, int **matrix1,
                       int rows2, int cols2, int **matrix2,
                       int **result) {
    for (int i = 0; i < rows1; i++) {
        for (int j = 0; j < cols2; j++) {
            result[i][j] = 0;  // Initialize result matrix cell to 0

            for (int k = 0; k < cols1; k++) {
                result[i][j] += matrix1[i][k] * matrix2[k][j];
            }
        }
    }
}

void display_matrix(int rows, int cols, int **matrix) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%d\t", matrix[i][j]);
        }
        printf("\n");
    }
}

int main(int argc, char *argv[]) {
    if (argc != 5) {
        printf("Usage: %s <rows1> <cols1> <cols2> <run forever? 0/1>\n", argv[0]);
        return 1;
    }

    int rows1 = atoi(argv[1]);
    int cols1 = atoi(argv[2]);
    int cols2 = atoi(argv[3]);

    int run_ = atoi(argv[1]);


    // Check if dimensions are valid for matrix multiplication
    if (rows1 <= 0 || cols1 <= 0 || cols2 <= 0) {
        printf("Dimensions must be positive integers.\n");
        return 1;
    }

    srand(time(NULL));  // Seed the random number generator

    // Allocate memory for matrices
    int **matrix1 = (int **)malloc(rows1 * sizeof(int *));
    int **matrix2 = (int **)malloc(cols1 * sizeof(int *));
    int **result = (int **)malloc(rows1 * sizeof(int *));

    for (int i = 0; i < rows1; i++) {
        matrix1[i] = (int *)malloc(cols1 * sizeof(int));
        result[i] = (int *)malloc(cols2 * sizeof(int));
    }

    for (int i = 0; i < cols1; i++) {
        matrix2[i] = (int *)malloc(cols2 * sizeof(int));
    }

    do {
        struct timespec t0, t1;

        // Get starting time
    
        printf("Generating Matrices...");
        generate_random_matrix(rows1, cols1, matrix1);
        printf("Matrix 1 done.\n");
        generate_random_matrix(cols1, cols2, matrix2);
        printf("Matrix 2 done.\n");

        timespec_get(&t0, TIME_UTC);  // C11 feature

        multiply_matrices(rows1, cols1, matrix1, cols1, cols2, matrix2, result);

        timespec_get(&t1, TIME_UTC);
        
        // Compute difference in seconds
        float dns = (float)(t1.tv_usec - t0.tv_usec) / 1000000;
        time_t ltime;
        time(&ltime);
        printf("%s - Time to multiply : %f s ",ctime(&ltime),  dns);

    } while(run_);

    // Free allocated memory
    for (int i = 0; i < rows1; i++) {
        free(matrix1[i]);
        free(result[i]);
    }
    for (int i = 0; i < cols1; i++) {
        free(matrix2[i]);
    }

    free(matrix1);
    free(matrix2);
    free(result);

    return 0;
}
