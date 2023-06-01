        MOV R0, 0x0000
 ciclo: CMP [0xFFF0], 0xFFFF
        JNE ciclo   ; si no se presiona vuelvo
        ADD R0, 0x0001
        MOV [0xFFF1], R0
ciclo2: CMP [0xFFF0], 0xFFFF
        JNE ciclo   ; si se dejo de presionar, vuelvo
        JMP ciclo2  ; si no, me cuelgo aca