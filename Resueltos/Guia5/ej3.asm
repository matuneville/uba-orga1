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