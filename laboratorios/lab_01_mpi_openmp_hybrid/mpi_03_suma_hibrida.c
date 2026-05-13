#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <omp.h>

#define N 1000000

int main(int argc, char *argv[]) {

    int rank, size;

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int *vector = NULL;

    // Cantidad de elementos por proceso
    int elementos = N / size;

    int *local = (int*) malloc(elementos * sizeof(int));

    // Solo el maestro crea el vector
    if(rank == 0){

        vector = (int*) malloc(N * sizeof(int));

        for(int i = 0; i < N; i++){
            vector[i] = i;
        }
    }

    // Distribuye partes del vector
    MPI_Scatter(vector,
                elementos,
                MPI_INT,
                local,
                elementos,
                MPI_INT,
                0,
                MPI_COMM_WORLD);

    long long suma_local = 0;

    // Suma paralela con OpenMP
    #pragma omp parallel for reduction(+:suma_local)
    for(int i = 0; i < elementos; i++){
        suma_local += local[i];
    }

    long long suma_total = 0;

    // Une todas las sumas
    MPI_Reduce(&suma_local,
               &suma_total,
               1,
               MPI_LONG_LONG,
               MPI_SUM,
               0,
               MPI_COMM_WORLD);

    // Maestro imprime resultado
    if(rank == 0){

        printf("Suma total = %lld\n", suma_total);

        printf("Esperado   = 499999500000\n");
    }

    free(local);

    if(rank == 0){
        free(vector);
    }

    MPI_Finalize();

    return 0;
}