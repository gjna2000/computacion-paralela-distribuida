// Archivo: ejercicio8_tiempo.cu
// Objetivo: Medir rendimiento con CUDA Events y calcular bandwidth
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cuda_runtime.h>

#define N       10000000  // 10 millones de elementos
#define THREADS 256

// Kernel: multiplica cada elemento por un escalar
__global__ void escalarMult(float *d_vec, float escalar, int n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < n) d_vec[idx] *= escalar;
}

int main() {
    float escalar = 2.5f;
    size_t bytes = N * sizeof(float);

    float *h_vec = (float*)malloc(bytes);
    for (int i = 0; i < N; i++) h_vec[i] = 1.0f;

    float *d_vec;
    cudaMalloc((void**)&d_vec, bytes);
    cudaMemcpy(d_vec, h_vec, bytes, cudaMemcpyHostToDevice);

    // === Medicion GPU con CUDA Events ===
    cudaEvent_t inicio, fin;
    cudaEventCreate(&inicio);
    cudaEventCreate(&fin);

    int numBloques = (N + THREADS - 1) / THREADS;

    cudaEventRecord(inicio);
    escalarMult<<<numBloques, THREADS>>>(d_vec, escalar, N);
    cudaEventRecord(fin);
    cudaEventSynchronize(fin);

    float ms_gpu = 0;
    cudaEventElapsedTime(&ms_gpu, inicio, fin);

    float gb = (2.0f * bytes) / (1024.0f * 1024.0f * 1024.0f);
    float bandwidth = gb / (ms_gpu / 1000.0f);

    printf("=== GPU ===\n");
    printf("Tiempo GPU      : %.4f ms\n", ms_gpu);
    printf("Bandwidth efect.: %.2f GB/s\n", bandwidth);

    cudaMemcpy(h_vec, d_vec, sizeof(float), cudaMemcpyDeviceToHost);
    printf("h_vec[0]        : %.1f (esperado %.1f)\n\n", h_vec[0], escalar);

    // TAREA: Comparacion con CPU usando clock()
    float *h_cpu = (float*)malloc(bytes);
    for (int i = 0; i < N; i++) h_cpu[i] = 1.0f;

    clock_t t_inicio = clock();
    for (int i = 0; i < N; i++) h_cpu[i] *= escalar;
    clock_t t_fin = clock();

    float ms_cpu = 1000.0f * (float)(t_fin - t_inicio) / CLOCKS_PER_SEC;
    printf("=== CPU ===\n");
    printf("Tiempo CPU      : %.4f ms\n", ms_cpu);
    printf("h_cpu[0]        : %.1f (esperado %.1f)\n\n", h_cpu[0], escalar);

    printf("Speedup GPU vs CPU: %.2fx\n", ms_cpu / ms_gpu);

    cudaEventDestroy(inicio); cudaEventDestroy(fin);
    cudaFree(d_vec); free(h_vec); free(h_cpu);
    return 0;
}
// Compilar: nvcc ejercicio8_tiempo.cu -o ejercicio8
