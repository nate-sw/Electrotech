;
; rfid_io.inc
; 2024-02-11
; Author : nsw
;

;R17 - Used for address
;R18 - Used for command
;R19 - Used for command (fifo only)

init_rfid: ;Currently configured for ISO 14443
    ;
    CBI     PORTB,1
    LDI     R16,$00
    RCALL   RC663_write_reg
    RCALL   RC663_data
    SBI     PORTB,1
    ;     
    CBI     PORTB,1
    LDI     R16,$02
    RCALL   RC663_write_reg
    LDI     R16,$B0
    RCALL   RC663_data
    SBI     PORTB,1
    ;     
    CBI     PORTB,1
    LDI     R16,$05
    RCALL   RC663_write_reg
    LDI     R16,$00
    RCALL   RC663_data
    LDI     R16,$00
    RCALL   RC663_data
    SBI     PORTB,1
    ;     
    CBI     PORTB,1
    LDI     R16,$00
    RCALL   RC663_write_reg
    LDI     R16,$0D
    RCALL   RC663_data
    SBI     PORTB,1
    ;     
    CBI     PORTB,1
    LDI     R16,$28
    RCALL   RC663_write_reg
    LDI     R16,$8E
    RCALL   RC663_data
    SBI     PORTB,1
    ;     
    CBI     PORTB,1
    LDI     R16,$06
    RCALL   RC663_write_reg
    LDI     R16,$7F
    RCALL   RC663_data
    SBI     PORTB,1
    ;     
    CBI     PORTB,1
    LDI     R16,$2C
    RCALL   RC663_write_reg
    LDI     R16,$18
    RCALL   RC663_data
    SBI     PORTB,1
    ;     
    CBI     PORTB,1
    LDI     R16,$2D
    RCALL   RC663_write_reg
    LDI     R16,$18
    RCALL   RC663_data
    SBI     PORTB,1
    ;     
    CBI     PORTB,1
    LDI     R16,$2E
    RCALL   RC663_write_reg
    LDI     R16,$0F
    RCALL   RC663_data
    SBI     PORTB,1
    ;                ;     
    CBI     PORTB,1
    LDI     R16,$05
    RCALL   RC663_write_reg
    LDI     R16,$26
    RCALL   RC663_data
    SBI     PORTB,1

    RET
    ;    

RC663_write_reg:
    LSL     R16
    OUT     SPDR,R16
    RCALL   RC663_wait
    RET

RC663_read_reg:
    ;LDI     R16,$FF ;junk data to continue spi
    LSL     R16
    SBR     R16, $01
    OUT     SPDR,R16
    RCALL   RC663_wait
    IN      R17,SPDR
    RET

RC663_data:
    OUT     SPDR,R16
    RCALL   RC663_wait
    RET

RC663_wait:
    SBIS    SPSR,SPIF
    RJMP    RC663_wait
    RET

RC663_reg_cmd:




    