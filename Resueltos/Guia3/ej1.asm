; R0 = valor a shiftear
; R1 = posiciones a shiftear

main: CMP R1, 0x0000
      JE end

loop: ADD R0, R0
      SUB R1, 0x0001
      JE end
      JMP loop

 end: RET

 