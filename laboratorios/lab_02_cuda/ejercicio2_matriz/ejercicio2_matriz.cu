// Archivo: ejercicio2_matriz.cu
// Objetivo: Transferir una matriz 2D (plana) entre CPU y GPU
#include <stdio.h>
#include <math.h>
#include <cuda_runtime.h>

#define FILAS 3
#define COLS  4
#define N (FILAS * COLS)

void imprimirMatriz(float *m, int filas, int cols) {
    for (int i = 0; i < filas; i++) {
        for (int j = 0; j < cols; j++)
            printf("%6.1f ", m[i * cols + j]);
        printf("\n");
    }
}

int main() {
    // Matrices en CPU
    float h_original[N], h_recuperada[N];
    for (int i = 0; i < N; i++) h_original[i] = (float)(i + 1) * 1.5f;

    printf("Matriz original (CPU):\n");
    imprimirMatriz(h_original, FILAS, COLS);

    // Reservar en GPU
    float *d_matriz;
    cudaMalloc((void**)&d_matriz, N * sizeof(float));

    // Copiar CPU → GPU
    cudaMemcpy(d_matriz, h_original, N * sizeof(float), cudaMemcpyHostToDevice);
    printf("\n[OK] Datos enviados a la GPU\n");

    // Copiar GPU → CPU
    cudaMemcpy(h_recuperada, d_matriz, N * sizeof(float), cudaMemcpyDeviceToHost);

    printf("\nMatriz recuperada desde GPU:\n");
    imprimirMatriz(h_recuperada, FILAS, COLS);

    // TAREA: Verificacion automatica elemento por elemento
    printf("\nVerificacion automatica:\n");
    int ok = 1;
    for (int i = 0; i < FILAS; i++) {
        for (int j = 0; j < COLS; j++) {
            float orig = h_original[i * COLS + j];
            float rec  = h_recuperada[i * COLS + j];
            if (fabsf(orig - rec) >= 1e-5f) {
                printf("  ERROR en [%d][%d]: original=%.1f recuperado=%.1f\n",
                       i, j, orig, rec);
                ok = 0;
            }
        }
    }
    printf(ok ? "[OK] Todos los elementos coinciden!\n"
              : "[FALLO] Hay diferencias en los datos.\n");

    cudaFree(d_matriz);
    return 0;
}
