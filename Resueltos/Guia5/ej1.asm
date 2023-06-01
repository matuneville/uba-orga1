sensar: CMP [0xFFF0], MAX_TEMP ; alcanzo temperatura maxima?
        JG alarma
        CMP [0xFFF1], MAX_ATM  ;alcanzo presion atmosferica maxima?
        JG alarma
        CMP [0xFFF2], MAX_WIND_SPEED ; alcanzo velocidad maxima?
        JG alarma
        JMP sensar
alarma: CALL sonarAlarma ; invoca rutina de alarma
        JMP sensar