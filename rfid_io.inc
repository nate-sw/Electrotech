;
; rfid_io.inc
; 2024-02-11
; Author : nsw
;

;R17 - Used for address
;R18 - Used for command
;R19 - Used for command (fifo only)

init_rfid: ;Currently configured for ISO 14443
    SBI     PORTB,0

    LDI     R17,$00
    LDI     R18,$00
    RCALL   spi_cmd_addr
    RCALL dly50usi
    LDI     R17,$02
    LDI     R18,$B0
    RCALL   spi_cmd_addr
    RCALL dly50usi
    LDI     R17,$05
    LDI     R18,$00
    LDI     R19,$00
    RCALL   spi_cmd_fifo
    RCALL dly50usi
    LDI     R17,$00
    LDI     R18,$0D
    RCALL   spi_cmd_addr
    RCALL dly50usi
    LDI     R17,$02
    LDI     R18,$B0
    RCALL   spi_cmd_addr
    RCALL dly50usi
    LDI     R17,$28
    LDI     R18,$8E
    RCALL   spi_cmd_addr
    RCALL dly50usi
    LDI     R17,$06
    LDI     R18,$7F
    RCALL   spi_cmd_addr
    RCALL dly50usi
    LDI     R17,$2C
    LDI     R18,$18
    RCALL   spi_cmd_addr
    RCALL dly50usi
    LDI     R17,$2D
    LDI     R18,$18
    RCALL   spi_cmd_addr
    RCALL dly50usi
    LDI     R17,$2E
    LDI     R18,$0F
    RCALL   spi_cmd_addr
    
    RET

spi_rfid_ping: ;Template.
    LDI     R17,$05
    LDI     R18,$26
    RCALL   spi_cmd_addr

    LDI     R17,$00
    LDI     R18,$07
    RCALL   spi_cmd_addr


spi_rfid_read: ;Response.
    SBIS    SPSR,SPIF
    RJMP    spi_rfid_read
    in      R16,SPDR
    STS     temp_buf,R16
    LDI     R17,$05
    LDI     R18,$05
    RCALL   spi_cmd_fifo
    RET

spi_cmd_addr:
    ;Set NSS to Low
    CBI     PORTB,0
    RCALL dly50usi
    ;Send address and command
    OUT     SPDR,R17
    OUT     SPDR,R18
    ;Set NSS to High
    RCALL dly50usi
    SBI     PORTB,0
    RET

spi_wait:
    SBIS    SPSR,SPIF
    RJMP    spi_wait
    RET


spi_cmd_fifo:
    ;Set NSS to Low
    CBI     PORTB,0
    RCALL dly50usi
    ;Send address and command
    OUT     SPDR,R17
    OUT     SPDR,R18
    OUT     SPDR,R19
    ;Set NSS to High
    RCALL dly50usi
    SBI     PORTB,0
    RET