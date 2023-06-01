# Guia 3: Microarquitectura y Microprogramación

## Ejercicio 6

b) 1. Microoperaciones de LOAD X
```asm
MAR := IR[11:0]
MEM_READ
AC := MDR
```

2. Microoperaciones de ADD X
```asm
ALU_IN1 := AC
MAR := IR[11:0]
MEM_READ
ALU_IN2 := MDR
ALU_ADD
AC := ALU_OUT
```
