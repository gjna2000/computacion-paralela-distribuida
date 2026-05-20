// Archivo: ejercicio9_producto_punto.cu
// Objetivo: Producto punto combinando multiplicacion en GPU y reduccion
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>

#define N       4096
#define THREADS 256

// Kernel: multiplicacion elemento a elemento + reduccion por bloque
__global__ void productoPunto(float *d_A, float *d_B, float *d_parciales, int n) {
    extern __shared__ float s_datos[];

    int tid = threadIdx.x;
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    s_datos[tid] = (idx < n) ? d_A[idx] * d_B[idx] : 0.0f;
    __syncthreads();

    for (int stride = blockDim.x / 2; stride > 0; stride /= 2) {
        if (tid < stride)
            s_datos[tid] += s_datos[tid + stride];
        __syncthreads();
    }

    if (tid == 0) d_parciales[blockIdx.x] = s_datos[0];
}

int main() {
    // === Prueba 1: vectores de unos (resultado debe ser N) ===
    float *h_A = (float*)malloc(N * sizeof(float));
    float *h_B = (float*)malloc(N * sizeof(float));
    for (int i = 0; i < N; i++) { h_A[i] = 1.0f; h_B[i] = 1.0f; }

    int numBloques = (N + THREADS - 1) / THREADS;
    float *h_parciales = (float*)malloc(numBloques * sizeof(float));

    float *d_A, *d_B, *d_parciales;
    cudaMalloc((void**)&d_A,         N          * sizeof(float));
    cudaMalloc((void**)&d_B,         N          * sizeof(float));
    cudaMalloc((void**)&d_parciales, numBloques * sizeof(float));

    cudaMemcpy(d_A, h_A, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, N * sizeof(float), cudaMemcpyHostToDevice);

    int sharedBytes = THREADS * sizeof(float);
    productoPunto<<<numBloques, THREADS, sharedBytes>>>(d_A, d_B, d_parciales, N);
    cudaDeviceSynchronize();

    cudaMemcpy(h_parciales, d_parciales, numBloques * sizeof(float), cudaMemcpyDeviceToHost);

    float resultado = 0.0f;
    for (int i = 0; i < numBloques; i++) resultado += h_parciales[i];

    printf("=== Prueba 1: vectores de unos ===\n");
    printf("Producto punto GPU = %.2f\n", resultado);
    printf("Resultado esperado = %d\n", N);
    printf("%s\n\n", (resultado == (float)N) ? "[OK]" : "[ERROR]");

    // TAREA: Prueba con vectores aleatorios y verifica contra CPU
    srand(42);
    for (int i = 0; i < N; i++) {
        h_A[i] = (float)rand() / RAND_MAX;
        h_B[i] = (float)rand() / RAND_MAX;
    }

    // Calculo en CPU para verificar
    double suma_cpu = 0.0;
    for (int i = 0; i < N; i++) suma_cpu += (double)h_A[i] * h_B[i];

    cudaMemcpy(d_A, h_A, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, N * sizeof(float), cudaMemcpyHostToDevice);

    productoPunto<<<numBloques, THREADS, sharedBytes>>>(d_A, d_B, d_parciales, N);
    cudaDeviceSynchronize();
    cudaMemcpy(h_parciales, d_parciales, numBloques * sizeof(float), cudaMemcpyDeviceToHost);

    float resultado_rand = 0.0f;
    for (int i = 0; i < numBloques; i++) resultado_rand += h_parciales[i];

    printf("=== Prueba 2: vectores aleatorios ===\n");
    printf("Producto punto GPU = %.4f\n", resultado_rand);
    printf("Producto punto CPU = %.4f\n", (float)suma_cpu);
    float error = fabsf(resultado_rand - (float)suma_cpu) / (float)suma_cpu * 100.0f;
    printf("Error relativo     = %.4f%%\n", error);
    printf("%s\n", (error < 0.01f) ? "[OK] Resultados coinciden!" : "[ADVERTENCIA] Diferencia mayor al 0.01%");

    cudaFree(d_A); cudaFree(d_B); cudaFree(d_parciales);
    free(h_A); free(h_B); free(h_parciales);
    return 0;
}
// Compilar: nvcc ejercicio9_producto_punto.cu -o ejercicio9 -lm
