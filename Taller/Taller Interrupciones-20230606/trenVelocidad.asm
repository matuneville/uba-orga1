	 SET R0, 0x02 ; bocina
	 SET R1, 0X20 ; curvas
	 SET R3, 0x0F
	 SET R5, 0x0C
	 SET R6, 0x0F
	 SET R7, 0x00
	 STR [0xF1], R0
	 SET R4, rai
	 STR [0x00], R4
	 STI


loop:    STR [0xF0], R3
	 JMP loop


rai:      CMP R3, R5
	  JZ velMax
	  CMP R3, R6
	  JZ velCurva

velMax:   STR [0xF0], R6
	  SET R3, 0x0F
	  IRET

velCurva: STR [0xF0], R5
	  SET R3, 0x0C
	  DEC R1
	  CMP R1, R7
	  JZ incBocina	  
	  IRET
	  

incBocina: INC R0
	   STR [0xF1], R0
	   SET R1, 0x20
	   IRET	  
