# Taller: Introducción a CUDA — 2026-I

**Universidad de Pamplona | Programación Paralela y Computación Distribuida**  
**Docente:** Prf. Juan Alejandro Carrillo Jaimes  
**Semestre:** 2026-I  
**Integrantes:** Nombre 1 — Nombre 2

---

## Entorno de desarrollo

- Plataforma: Google Colab (GPU NVIDIA T4)
- Compilador: nvcc (CUDA Toolkit)
- Lenguaje: C / CUDA C

---

## Ejercicio 1: Hola GPU — Transferencia CPU ↔ GPU

### ¿Qué hace?
Verifica el flujo básico de transferencia de datos entre CPU y GPU sin ejecutar kernels.
Inicializa 10 enteros en CPU, los copia a GPU con `cudaMemcpy`, los recupera de vuelta
y compara elemento por elemento para verificar integridad.

### Compilar y ejecutar
```bash
nvcc ejercicio1_hola_gpu/ejercicio1_hola_gpu.cu -o ejercicio1
./ejercicio1
```

### Evidencia
![Ejercicio 1](img/evidencia_ejercicio1.png)

### Conclusión
La transferencia CPU↔GPU funciona correctamente. `cudaMalloc` reserva memoria
en VRAM, `cudaMemcpy` transfiere los datos en ambas direcciones y `cudaFree`
libera los recursos. Este flujo es la base de todo programa CUDA.

---

<!-- Los siguientes ejercicios se irán agregando aquí -->
