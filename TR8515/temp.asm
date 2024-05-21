.include "m8515def.inc"

.equ FCPU_L  = 1000000 ;UP frequency
.equ BAUD  = 4800    ;desired baud rate

.equ  UBRR  = (FCPU_L /(16 * BAUD)) -1   ;see p.138 (important)	
.equ  FRAME = $86      ;8N1 standard frame
.equ  TXE = $18        ;Transmit & receive enable     
.equ  LF = $0A		   ;ASCII line feed
.equ  CR = $0D		   ;ASCII carriage return
.equ  SOTE = $02	       ;ASCII start of text
.equ  EOTE = $03	   ;ASCII end of text
.equ  EOTX = $04	   ;ASCII end of transmission


init0:
    LDI     R16,LOW(RAMEND)
    OUT     SPL,R16
    LDI     R16,HIGH(RAMEND)
    OUT     SPH,R16
    ;init bus
    ;LDI     R16,$82
    ;OUT     MCUCR,R16

init_uart:                 
	ldi R16, 0	       
	out UBRRH, R16    
	ldi R16, UBRR	 
	out UBRRL, R16     ;config. the rate of data tx 
	ldi R16, TXE      
	out UCSRB, R16     ;enable port tx (see p.158)
	ldi R16, FRAME     ;defined in calling     
	out UCSRC, R16     ;config. frame elements

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

avr_getch:
    IN      R16,UCSRA
    ANDI    R16,$80
    BREQ    avr_getch
    IN      R16,UDR
    CPI     R16,$74; checks for t character
    BREQ    get_temp1
    RJMP    avr_getch


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
    OUT     UDR,R16		
    RCALL   dly1s

    rjmp    avr_getch

temp_done:
    RET




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