# LAB-01-MPI-OPENMP-HYBRID | Gonzalo Javier Niño Amaris

> **Asignatura:** Fundamentos de Programación Concurrente y Distribuida  
> **Docente:** Prf. Alejandro Jaimes  
> **Fecha:** 13/05/2026  
> **Repositorio:** https://github.com/gjna2000/computacion-paralela-distribuida

---

# Ejercicio 1 — Hola Mundo MPI

## Descripción

Cada proceso MPI imprime su rank y el total de procesos.  
El proceso maestro (rank 0) imprime un mensaje adicional.

---

## Compilación

```bash
gcc mpi_01_hola.c -o mpi_01_hola.exe -I"C:\MPI\msmpisdk.10.1.12498.52\Include" -L"C:\MPI\msmpisdk.10.1.12498.52\Lib\x64" -lmsmpi


Respuestas
1. ¿Por qué el orden de salida varía entre ejecuciones?

Porque los procesos MPI se ejecutan concurrentemente y el sistema operativo decide el orden de ejecución.

2. ¿Qué pasaría si ejecutas con -n 1?

Solo existiría un proceso MPI con rank 0 y actuaría como maestro.

3. ¿Para qué sirve MPI_COMM_WORLD?

Es el comunicador principal de MPI que contiene todos los procesos activos.


_________________________________________________________________________________________

---

# Ejercicio 2 — OpenMP dentro de MPI

## Descripción

Dentro de cada proceso MPI se lanza una región paralela OpenMP con 4 hilos.

Cada hilo imprime su identificador junto con el rank del proceso MPI que lo contiene.

---

## Compilación

```bash
gcc mpi_02_hibrido.c -o mpi_02_hibrido.exe -fopenmp -I"C:\MPI\msmpisdk.10.1.12498.52\Include" -L"C:\MPI\msmpisdk.10.1.12498.52\Lib\x64" -lmsmpi
Ejecucion 
mpiexec -n 2 mpi_02_hibrido.exe
mpiexec -n 4 mpi_02_hibrido.exe


1. Con 2 procesos MPI y 4 hilos OMP, ¿cuántas unidades de cómputo hay?

Existen 8 unidades de cómputo porque cada proceso MPI crea 4 hilos OpenMP.

2. ¿Diferencia entre -n 4 y -n 1?

Con -n 4 existen varios procesos independientes.

Con -n 1 existe un único proceso usando múltiples hilos compartiendo memoria.

3. ¿Por qué MPI_Init_thread en lugar de MPI_Init?

Porque el programa utiliza MPI junto con OpenMP y necesita soporte para múltiples hilos.
_________________________________________________________________________________________

---

# Ejercicio 3 — Suma Híbrida de Vector

## Descripción

El proceso maestro inicializa un vector de un millón de elementos.

MPI distribuye partes del vector entre los procesos y OpenMP realiza la suma paralela de cada bloque.

Finalmente MPI combina las sumas parciales.

---

## Compilación

```bash
gcc mpi_03_suma_hibrida.c -o mpi_03.exe -fopenmp -I"C:\MPI\msmpisdk.10.1.12498.52\Include" -L"C:\MPI\msmpisdk.10.1.12498.52\Lib\x64" -lmsmpi

Ejecución
mpiexec -n 4 mpi_03.exe
1. ¿Qué hace exactamente MPI_Scatter?

Divide y distribuye partes de un arreglo entre todos los procesos MPI.

2. ¿Por qué reduction(+:suma_local) y no una variable compartida?

Porque evita conflictos entre hilos al realizar sumas simultáneas.

3. ¿Qué pasaría si olvidaras MPI_Reduce?

Solo se imprimiría la suma parcial del proceso 0 y no la suma total global.
_________________________________________________________________________________________

---

# Ejercicio 4 — Speedup Híbrido

## Descripción

Se añade medición de tiempos usando `MPI_Wtime()` para analizar el rendimiento del modelo híbrido MPI + OpenMP.

---

## Compilación

```bash
gcc mpi_04_speedup.c -o mpi_04.exe -fopenmp -I"C:\MPI\msmpisdk.10.1.12498.52\Include" -L"C:\MPI\msmpisdk.10.1.12498.52\Lib\x64" -lmsmpi

mpiexec -n 1 mpi_04.exe
mpiexec -n 2 mpi_04.exe
mpiexec -n 4 mpi_04.exe

| Configuración | Procesos MPI | Tiempo |
| ------------- | ------------ | ------ |
| Secuencial    | 1            | Medido |
| MPI           | 2            | Medido |
| MPI           | 4            | Medido |


1. ¿Coincide con la Ley de Amdahl?

Sí. El speedup mejora hasta cierto límite debido a la parte secuencial del programa.

2. ¿Por qué más procesos/hilos no siempre aumentan el speedup?

Porque existe overhead de sincronización y comunicación.

3. ¿Qué overhead introduce MPI?

MPI introduce costos de comunicación y transferencia de datos entre procesos.


# Conclusiones

1. MPI permite distribuir trabajo entre múltiples procesos.

2. OpenMP facilita el paralelismo mediante hilos compartiendo memoria.

3. El modelo híbrido MPI + OpenMP mejora el rendimiento en cálculos grandes.

4. La sincronización correcta evita errores en cálculos paralelos.

5. El speedup no es infinito debido al overhead y partes secuenciales.