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