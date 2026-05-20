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


---

## Ejercicio 2: Copia de Matriz 2D CPU ↔ GPU

### ¿Qué hace?
Transfiere una matriz de 3×4 floats entre CPU y GPU representada como arreglo 1D.
Para acceder al elemento `[i][j]` se usa la fórmula `arreglo[i * COLS + j]`.
Incluye verificación automática con `fabsf(a - b) < 1e-5f` para confirmar
que cada elemento llegó intacto.

### Compilar y ejecutar
```bash
nvcc ejercicio2_matriz/ejercicio2_matriz.cu -o ejercicio2
./ejercicio2
```

### Evidencia
![Ejercicio 2](img/evidencia_ejercicio2.png)

### Conclusión
Las matrices multidimensionales en CUDA se manejan como arreglos 1D en memoria
contigua. La fórmula `i * COLS + j` convierte índices 2D a posición lineal.
La verificación con tolerancia `1e-5f` es la forma correcta de comparar floats,
ya que la comparación directa con `==` puede fallar por errores de precisión.

---

<!-- Los siguientes ejercicios se irán agregando aquí -->

