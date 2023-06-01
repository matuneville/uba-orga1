# Guia 5: Entrada / Salida

## Ejercicio 1

a) Mapeo:  
- TEMP_STATUS -> 0xFFF0
- ATM_STATUS -> 0xFFF1
- WIND_STATUS -> 0xFFF2

```asm
sensar: CMP [0xFFF0], MAX_TEMP ; alcanzo temperatura maxima?
        JG alarma
        CMP [0xFFF1], MAX_ATM  ;alcanzo presion atmosferica maxima?
        JG alarma
        CMP [0xFFF2], MAX_WIND_SPEED ; alcanzo velocidad maxima?
        JG alarma
        JMP sensar
alarma: CALL sonarAlarma ; invoca rutina de alarma
        JMP sensar
```

b) Los registros de I/O se leen cada vez que se realiza una iteracion sobre el ciclo. Teniendo en cuenta que el ciclo consta de 7 instrucciones, y cada instruccion tarda `t` segundos en ejecutarse, paso a Hz como `1/s`. Por lo tanto, la frecuencia de muestreo (lectura) de los registros de I/O es de `1/7t Hz`

c) Ahora se solicita la interrupción para el sensor de temperatura.

```asm
// INTERRUPCION
rutinaInt: CMP [0xFFF0], MAX_TEMP ; alcanzo temperatura maxima?
           JG alarma
           STI
           IRET
```

## Ejercicio 3

```c
while (true) {
    Fetch() // fetch
    Decode() // decodificacion
    Execute() // ejecucion
    if I==1 AND INTR==1 {
        PUSH() PSW  // guardado de flags
        PUSH() PC   // guardado de PC
        CLI()       // reseteo flag de interrupción
        PC = [0x0000]   // llamo a la rutina de atención a interrupción
        INTA()
    }
}
```

## Ejercicio 4

Mapeo:
- STATUS -> [0xFFF0]
- R0 -> cantidad de veces a leer los datos
- R1 -> donde se escriben de forma contigua en la direccion indicada en R1. Se guardan en la parte 7-0 (baja) de cada direccion.  

Cuando el bit 15 de STATUS es 0, esta listo para leer los bits 7-0.  
Pseudocódigo:
```c
while(R0 > 0){
    if (Status[15] == 0){
        [R1] = Status[7-0];
        R1++;
    }
}
```
Código en Assembler
```asm
; R0 -> veces a leer
; [R1] -> adress de result
; R2 -> guardo el input y luego el dato

condicion: CMP R0, 0x0000   ; si es 0 termina
           JE fin
           MOV R2, [0xFFF0]

; veo si el bit 15 es un 1.  1000 0000 0000 0000 = 0x8000
checkRead: AND R2, 0x8000
           JNE condicion    ; si no es 0, vuelvo a condicion

           MOV R2, [0xFFF0] ; releo el numero
; guardo bits 7-0.  0000 0000 1111 1111 = 0x00FF
           AND R2, 0x00FF
           
           MOV [R1], R2
           ADD R1, 0x0001   ; pasa a sgte adress
           SUB R0, 0x0001
           JMP condicion

      fin: RET
```


## Ejercicio 5
Mapeo:
- in: BUTTON_STATUS -> 0xFFF0
- out: DISPLAY-DATA -> 0xFFF1
- R0 -> guardo el conteo de presiones

```c
presionado = false;
while(true){
    if (Button_Status == 0xFFFF){
        R0++;
        while(Button_Status == 0xFFFF){
            ; // en loop hasta que cambie
        }
    }
}
```

```asm
        MOV R0, 0x0000
 ciclo: CMP [0xFFF0], 0xFFFF
        JNE ciclo   ; si no se presiona vuelvo
        ADD R0, 0x0001
        MOV [0xFFF1], R0
ciclo2: CMP [0xFFF0], 0xFFFF
        JNE ciclo   ; si se dejo de presionar, vuelvo
        JMP ciclo2  ; si no, me cuelgo aca
```

## Ejercicio 6 - e)

```asm
RAI_MONITOR_ALTURA:
    ; Guardar la mascara
    PUSH AX     ; apilar el registro AX
    IN AX, IMR  ; copiar el contenido del reg. de E/S IMR en AX
    PUSH AX     ; apilar la mascara actual
    ; Setear la máscara inhibiendo interrupciones de menor prioridad
    MOV AX, 0xFCFF  ; Máscara para inhibir las interrupciones de prioridad 3 y 4
    OUT IMR, AX    ; Copiar el contenido de AX en el registro de E/S INTMASK

    ; Habilitar interrupciones
    STI  ; Habilitar interrupciones

    ; Salvar el estado de lo que reste
    ; Aquí se incluiría el código para guardar el estado de los registros y datos adicionales si es necesario

    ; Obtener la altura nueva
    IN AX, 43h              ; Copiar el contenido del registro 43h de E/S en AX
    LEA SI, MONITOR_ALTURA  ; Cargar la dirección de la constante MONITOR_ALTURA en SI
    MOV [SI], AX            ; Copiar el contenido del registro AX en la dirección apuntada por SI

    ; La altura ya fue actualizada, completar lo que falta para terminar
    ; Aquí se incluiría el código para manejar y procesar la información de la altura

    ; Restaurar el estado anterior
    POP AX      ; Desapilar la máscara anterior
    OUT IMR, AX ; Restaurar la máscara original

    ; Finalizar la rutina de atención de interrupción
    IRET        ; Retornar de la interrupción y restaurar el estado anterior

```

## Ejercicio 8

Las explicaciones son dadas por ChatGPT jeje

1. **Clock del sistema**: Las interrupciones generadas por el reloj del sistema suelen tener una alta prioridad, ya que permiten realizar tareas esenciales como la planificación del procesador y la gestión de eventos temporales.
2. **Teclado**: Las interrupciones generadas por el teclado suelen tener una prioridad alta, ya que la interacción del usuario a través del teclado puede requerir respuestas rápidas del sistema, como la captura de pulsaciones de teclas para procesar comandos o manejar eventos de entrada.
3. **Puerto serial**: Las interrupciones generadas por los puertos seriales generalmente tienen una prioridad moderada, ya que la comunicación serial puede ser esencial para la transferencia de datos, pero no suele requerir una respuesta inmediata como las interrupciones del reloj o del teclado.
4. **Disco rígido**: Las interrupciones generadas por el disco rígido suelen tener una prioridad baja, ya que las operaciones de lectura y escritura en disco tienden a ser más lentas en comparación con otras operaciones del sistema. Estas interrupciones pueden esperar a que se completen las operaciones en curso antes de ser atendidas.
5. **Disco flexible**: Las interrupciones generadas por el disco flexible generalmente tienen una prioridad baja, ya que su uso es menos común y las operaciones en disco suelen ser más lentas que otros dispositivos de almacenamiento más modernos.
6. **Impresora**: Las interrupciones generadas por las impresoras suelen tener la prioridad más baja, ya que las operaciones de impresión suelen ser relativamente lentas y pueden esperar hasta que se completen otras tareas más críticas en el sistema.