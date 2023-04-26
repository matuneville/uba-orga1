; R0 = posicion inicio vector
; R1 = size vector

  main: MOV R2, [R0] ; max
        MOV R3, [R0] ; min

MinMax: CMP R2, [R0] ; check max
        JL cont ; si no es mayor, salto
        MOV R2, [R0]

 cont1: CMP R3, [R0]
        JG cont2
        MOV R3, [R0]

 cont2: ADD R0, 0x0001
        CMP R0,R1
        JG end
        JMP MinMax

   end: RET