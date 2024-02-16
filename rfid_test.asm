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
    LDI     R16, $80
    OUT     MCUCR, R16
    LDI     R16, $00
    OUT     SFIOR, R16


    LDI     R16, LOW(RAMEND)
    OUT     SPL, R16
    LDI     R16, HIGH(RAMEND)
    OUT     SPH, R16


    RCALL   dly50usi
    RCALL   init_lcd
    ;rjmp init0 ;for testing only


init_spi:
    SEI ;Enables interrupt
    ;Set MOSI, SCK and PB0 to output, all others input
    LDI     R16, (1<<DDB1)|(1<<DDB4)|(1<<DDB5)|(1<<DDB7)
    OUT     DDRB,R16
    ;Enable SPI, Master, set clock rate fck/16
    LDI     R16,$57 ;(1<<SPE)|(1<<MSTR)|(1<<CPHA)|(1<<SPR1)|(1<<SPR0)
    OUT     SPCR,R16

init_RFID_main:
    RCALL   init_rfid

test:
    CLR     R17
    CLR     R18
    RCALL   spi_rfid_ping
    RCALL   lcd_line_dw
    LDS     R16,temp_buf
    RCALL   lcd_rfid_dsp


fini:
    rjmp    fini

msg0:    .db   $0D, "RFID Tag", $00

.include "delays.inc"
;.include "startup.inc"
.include "lcdio.inc"
.include "rfid_io.inc"
.include "temp.inc"
.include "numio.inc"