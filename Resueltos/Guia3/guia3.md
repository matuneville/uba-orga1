# Guia 3: Arquitectura del CPU

## Ejercicio 1
1. Pseudocódigo para hacer el left shift
```cpp
while (posiciones > 0) do
    valor = valor + valor
    posiciones = posiciones - 1
endwhile
```

2. Código en Assembler ORGA1

```asm
; R0 = valor a shiftear
; R1 = posiciones a shiftear

main: CMP R1, 0x0000
      JE end

loop: ADD R0, R0
      SUB R1, 0x0001
      JE end
      JMP loop

 end: RET
```

3. No altera otros registros que no sean R0 o R1

## Ejercicio 2
Pseudocódigo para hallar min y max en un vector en memoria
```cpp
// asumo size(vector) > 0
min = vector[0]
max = vector[0]
i = inicio
while (i < size) do
    if (vector[i] > max)
        max = vector[i]
    if (vector[i] < min)
        min = vector[i]
endwhile
// luego guardo los valores en los registros correspondientes
```

Código en Assembler ORGA1

```asm
; R0 = posicion inicio vector
; R1 = size vector
  main: MOV R0, [BEGIN]
        MOV R1, [SIZE]
        MOV R2, [R0] ; max
        MOV R3, [R0] ; min

MinMax: CMP R2, [R0] ; check max
        JL cont1 ; si no es mayor, salto
        MOV R2, [R0] ; asigno mayor

 cont1: CMP R3, [R0] ; check min
        JG cont2 ; si no es menor, salto
        MOV R3, [R0] ; asigno menor

 cont2: ADD R0, 0x0001
        SUB R1, 0x0001
        JE end
        JMP MinMax

   end: RET
```

## Ejercicio 3

La palabra de la arquitectura ORGA1 es de 16 bits, por lo tanto para sumar dos numeros de 64 bits tendremos que hacerlo en 4 sumas. El numero está a lo largo de la memoria, comenzando en la direccion de R0 y R1, y como está en Little Endian voy sumando de izquierda a derecha (en la suma a mano seria como sumar de derecha a izquierda). Lo mismo con el resultado, lo guardo a partir de la dirección de R2

```asm
; R0 = direc inicio numero 1, R1 = direc inicio numero 2
; R2 = direc resultado
main: MOV [R2], [R0]
      ADD [R2], [R1]
; ya sume los primeros 16 bits, sigo con las sgtes 3 direcciones de memoria
      MOV [R2 + 0x0001], [R0 + 0x0001]
      ADD [R2 + 0x0001], [R1 + 0x0001]

      MOV [R2 + 0x0002], [R0 + 0x0002]
      ADD [R2 + 0x0002], [R1 + 0x0002]
      
      MOV [R2 + 0x0003], [R0 + 0x0003]
      ADD [R2 + 0x0003], [R1 + 0x0003]
      
      RET
```
