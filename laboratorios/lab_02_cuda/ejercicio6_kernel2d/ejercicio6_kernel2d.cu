// Archivo: ejercicio6_kernel2d.cu
// Objetivo: Usar indexacion 2D de hilos en un kernel
#include <stdio.h>
#include <cuda_runtime.h>

#define FILAS 4
#define COLS  5

// Kernel 2D original: mat[i][j] = indice lineal
__global__ void inicializarMatriz(int *d_mat, int filas, int cols) {
    int col  = blockIdx.x * blockDim.x + threadIdx.x;
    int fila = blockIdx.y * blockDim.y + threadIdx.y;
    if (fila < filas && col < cols) {
        int idx = fila * cols + col;
        d_mat[idx] = idx;
    }
}

// TAREA: Kernel modificado: mat[i][j] = i + j
__global__ void inicializarMatrizSuma(int *d_mat, int filas, int cols) {
    int col  = blockIdx.x * blockDim.x + threadIdx.x;
    int fila = blockIdx.y * blockDim.y + threadIdx.y;
    if (fila < filas && col < cols) {
        d_mat[fila * cols + col] = fila + col;
    }
}

void imprimirMatriz(int *m, int filas, int cols, const char *titulo) {
    printf("%s\n", titulo);
    for (int i = 0; i < filas; i++) {
        for (int j = 0; j < cols; j++)
            printf("%3d ", m[i * cols + j]);
        printf("\n");
    }
    printf("\n");
}

int main() {
    int h_mat[FILAS * COLS];
    int *d_mat;
    cudaMalloc((void**)&d_mat, FILAS * COLS * sizeof(int));

    dim3 hilosPorBloque(COLS, FILAS);
    dim3 numBloques(1, 1);

    // Version original: mat[i][j] = indice lineal
    inicializarMatriz<<<numBloques, hilosPorBloque>>>(d_mat, FILAS, COLS);
    cudaDeviceSynchronize();
    cudaMemcpy(h_mat, d_mat, FILAS * COLS * sizeof(int), cudaMemcpyDeviceToHost);
    imprimirMatriz(h_mat, FILAS, COLS, "Matriz con indice lineal (mat[i][j] = i*COLS+j):");

    // TAREA: Version modificada: mat[i][j] = i + j
    inicializarMatrizSuma<<<numBloques, hilosPorBloque>>>(d_mat, FILAS, COLS);
    cudaDeviceSynchronize();
    cudaMemcpy(h_mat, d_mat, FILAS * COLS * sizeof(int), cudaMemcpyDeviceToHost);
    imprimirMatriz(h_mat, FILAS, COLS, "Matriz con suma (mat[i][j] = i + j):");

    cudaFree(d_mat);
    return 0;
}
// Compilar: nvcc ejercicio6_kernel2d.cu -o ejercicio6
