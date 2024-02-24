;
; rfid_test
; 2024-02-09
; Author : nsw
;

.include "m8515def.inc"


.dseg

temp_buf:   .byte 1


.cseg
.equ        BUSON = $80
.equ        ADRR1 = $2000 ; Memory address for LCD's control
.equ        ADRR2 = $2100 ; Memory address for LCD's data
.equ        ADRR3 = $1000 ; Memory address for RFID control



init0:
    SEI ;Enables interrupt
    LDI     R16, $80
    OUT     MCUCR, R16
    LDI     R16, $00
    OUT     SFIOR, R16


    LDI     R16, LOW(RAMEND)
    OUT     SPL, R16
    LDI     R16, HIGH(RAMEND)
    OUT     SPH, R16


    ;RCALL   dly50usi
    ;RCALL   init_lcd
    ;rjmp init0 ;for testing only


init_spi:
    SEI ;Enables interrupt
    ;Set ~SS, MOSI & SCK to output, all others input
    LDI     R16,$B3 ;(1<<DDB0)|(1<<DDB1)|(1<<DDB4)|(1<<DDB5)|(1<<DDB7)
    OUT     DDRB,R16
    ;Enable SPI, Master, set clock rate fck/128
    LDI     R16,$00
    OUT     SPSR,R16
    LDI     R16,$53 ;(1<<SPE)|(1<<MSTR)|(1<<SPR1)|(1<<SPR0)
    OUT     SPCR,R16
    CBI     PORTB,0
    SBI     PORTB,1

init_RFID_main:
    RCALL   init_rfid


test:
    CBI     PORTB,1
    LDI     R16,$00
    RCALL   RC663_write_reg
    LDI     R16,$07
    RCALL   RC663_write_reg
    SBI     PORTB,1

    NOP
    NOP
    NOP
    NOP
    NOP

    CBI     PORTB,1
    LDI     R16,$05
    RCALL   RC663_read_reg
    MOV     R19, R17
    LDI     R16,$05
    RCALL   RC663_data
    MOV     R18, R17
    LDI     R16,$00
    RCALL   RC663_data
    SBI     PORTB,1

    OUT     PORTA,R18

    rjmp    test

fini:
    rjmp    fini

spi_wait:
    SBIS    SPSR,SPIF
    RJMP    spi_wait
    RET



msg0:    .db   $0D, "RFID Tag", $00

.include "delays.inc"
;.include "startup.inc"
.include "lcdio.inc"
.include "rfid_io.inc"
.include "temp.inc"
.include "numio.inc"