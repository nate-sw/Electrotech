;
; rfid_test
; 2024-02-09
; Author : nsw
;

.include "m8515def.inc"

.cseg
.equ        BUSON = $82
.equ        ADRR1 = $2000 ; Memory address for LCD's control
.equ        ADRR2 = $2100 ; Memory address for LCD's data



init0:
    LDI     R16,LOW(RAMEND)
    OUT     SPL,R16
    LDI     R16,HIGH(RAMEND)
    OUT     SPL,R16

    LDI     R16,BUSON
    OUT     MCUCR,R16
    RCALL   init_lcd

init_spi:
    ;Set MOSI, SCK and PB0 to output, all others input
    LDI     R16, $B1 
    OUT     DDRB,R16
    ;Enable SPI, Master, set clock rate fck/16
    LDI     R16,(1<<SPE)|(1<<MSTR)|(1<<CPHA)|(1<<SPR0)
    OUT     SPCR,R16

init_RFID_main:
    RCALL   init_rfid

test:
    RCALL   spi_rfid_ping
    MOV     R31,R17
    MOV     R30,R18
    RCALL   lcd_msg_dsp


msg0:    .db   $0D, "RFID Tag", $00

.include "delays.inc"
;.include "startup.inc"
.include "lcdio.inc"
.include "rfid_io.inc"