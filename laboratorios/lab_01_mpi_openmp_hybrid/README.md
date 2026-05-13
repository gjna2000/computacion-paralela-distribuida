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