.include "m8515def.inc"

init0:
    LDI     R16,LOW(RAMEND)
    OUT     SPL,R16
    LDI     R16,HIGH(RAMEND)
    OUT     SPH,R16
    LDI     R16,$FF
    OUT     DDRA,R16

init_spi:
    SEI ;Enables interrupt
    ;Set ~SS, MOSI & SCK to output, all others input
    LDI     R16,$B3 ;(1<<DDB0)|(1<<DDB1)|(1<<DDB4)|(1<<DDB5)|(1<<DDB7)
    OUT     DDRB,R16
    ;Enable SPI, Master, set clock rate fck/128
    LDI     R16,$00
    OUT     SPSR,R16
    LDI     R16,$57 ;(1<<SPE)|(1<<MSTR)|(1<<CPHA)|(1<<SPR1)|(1<<SPR0)
    OUT     SPCR,R16
    CBI     PORTB,0
    SBI     PORTB,1

init_temp_sens:
    SBI     PORTB,0
    NOP
    LDI     R16,$80 ;Control register's Write address
    LDI     R17,$04 ;Control register configuration
    OUT     SPDR,R16

wait_temp_init1:
    SBIS    SPSR,SPIF
    RJMP    wait_temp_init1

    OUT     SPDR,R17

wait_temp_init2:
    SBIS    SPSR,SPIF
    RJMP    wait_temp_init2

    CBI     PORTB,0
    RCALL   dly200ms
    ;rjmp    init_temp_sens



get_temp1:
    SBI     PORTB,0
    NOP
    LDI     R16,$02 ;MSB Temp's Read address
    ;LDI     R16,$03 ;test
    OUT     SPDR,R16

wait_temp1:
    SBIS    SPSR,SPIF
    RJMP    wait_temp1

get_temp2:
    LDI     R16,$FF ;junk data to continue spi
    OUT     SPDR,R16

wait_temp2:
    SBIS    SPSR,SPIF
    RJMP    wait_temp2
    IN      R16,SPDR
    NOP
    CBI     PORTB,0
    OUT     PORTA,R16
    RCALL   dly1s
    RJMP    get_temp1

fini:
    RJMP    fini




;Below is for testing only
loop1:
    LDI     R16,0x5A
    OUT     SPDR,R16

wait1:
    SBIS    SPSR,SPIF
    RJMP    wait1

loop2:
    LDI     R16,0x00
    OUT     SPDR,R16

wait2:
    SBIS    SPSR,SPIF
    RJMP    wait2
    RJMP    loop1


.include "delays.inc"