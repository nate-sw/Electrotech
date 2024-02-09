;
; rfid_test
; 2024-02-09
; Author : nsw
;

.include "m8515def.inc"

.equ     BUSON = $82
;.equ     ADCADR = $1000 ; Memory address for ADC
;.equ     SVSEGADR = $1800 ; Memory address for 7 segment displays
.equ     ADRR1 = $2000 ; Memory address for LCD's control
.equ     ADRR2 = $2100 ; Memory address for LCD's data

init0:
    LDI     R16,LOW(RAMEND)
    OUT     SPL,R16
    LDI     R16,HIGH(RAMEND)
    OUT     SPL,R16

init_SPI-Master:
    ;Set MOSI and SCK to output, all others input
    LDI     R16,(1<<DD_MOSI)|(1<<DD_SCK)
    OUT     DDR_SPI,R16
    ;Enable SPI, Master, set clock rate fck/16
    LDI     R16,(1<<SPE)|(1<<MSTR)|(1<<CPHA)|(1<<SPR0)
    OUT     SPCR,R16


.include "delays.inc"
.include "lcdio.inc"
.include "startup.inc"