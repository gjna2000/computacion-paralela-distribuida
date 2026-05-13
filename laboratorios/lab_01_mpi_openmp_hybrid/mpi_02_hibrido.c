#include <stdio.h>
#include <mpi.h>
#include <omp.h>

int main(int argc, char *argv[]) {

    int rank, size;

    // Inicializa MPI con soporte para hilos
    MPI_Init_thread(&argc, &argv, MPI_THREAD_FUNNELED, NULL);

    // Obtiene rank del proceso
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // Obtiene cantidad de procesos
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // Región paralela OpenMP
    #pragma omp parallel num_threads(4)
    {
        int hilo = omp_get_thread_num();

        printf("Proceso MPI %d -> Hilo OpenMP %d\n", rank, hilo);
    }

    // Maestro
    if(rank == 0){
        printf("Total unidades de computo: %d\n", size * 4);
    }

    MPI_Finalize();

    return 0;
}