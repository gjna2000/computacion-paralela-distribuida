#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {

    int rank, size;

    // Inicializa MPI
    MPI_Init(&argc, &argv);

    // Obtiene el identificador del proceso
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // Obtiene cantidad total de procesos
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    printf("Hola desde el proceso %d de %d procesos\n", rank, size);

    // Proceso maestro
    if(rank == 0){
        printf("Soy el proceso maestro\n");
    }

    // Finaliza MPI
    MPI_Finalize();

    return 0;
}