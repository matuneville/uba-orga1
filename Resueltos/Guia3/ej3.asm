; R0 = direc inicio numero 1, R1 = direc inicio numero 2
; R2 = direc resultado
main: MOV [R2], [R0]
      ADD [R2], [R1]
; ya sume los primeros 16 bits, sigo con las sgtes 3 direcciones de memoria
      MOV [R2 + 0x0001], [R0 + 0x0001]
      ADDC [R2 + 0x0001], [R1 + 0x0001]

      MOV [R2 + 0x0002], [R0 + 0x0002]
      ADDC [R2 + 0x0002], [R1 + 0x0002]
      
      MOV [R2 + 0x0003], [R0 + 0x0003]
      ADDC [R2 + 0x0003], [R1 + 0x0003]
      
      RET