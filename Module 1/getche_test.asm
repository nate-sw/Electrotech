;
; getche_test
; 2024-03-05
; Author : nsw
;

.include "m8515def.inc"

.dseg


buf_in:   .byte 17 ;One byte spare
;buf_out:  .byte 13 ;One byte spare


.cseg




;The code below was originally written by Nick Markou in file termio.inc
.equ FCPU_L  = 1000000 ;used by termio rtn 
.equ BAUD  = 4800    ;desired baud rate

.equ  UBRR  = (FCPU_L /(16 * BAUD)) -1   ;see p.138 (important)	
.equ  FRAME = $86      ;8N1 standard frame
.equ  TXE = $18        ;Transmit & receive enable     
.equ  LF = $0A		   ;ASCII line feed
.equ  CR = $0D		   ;ASCII carriage return
.equ  SOTE = $02	       ;ASCII start of text
.equ  EOTE = $03	   ;ASCII end of text
.equ  EOTX = $04	   ;ASCII end of transmission
.equ  EOTB = $17	   ;ASCII end of transmission block

.equ        ADRR1 = $2000 ; Memory address for LCD's control
.equ        ADRR2 = $2100 ; Memory address for LCD's data

init0:
    LDI     R16, LOW(RAMEND)
    OUT     SPL, R16
    LDI     R16, HIGH(RAMEND)
    OUT     SPH, R16


init_uart:                 
	ldi R16, 0	       ;always zero (mostly)
	out UBRRH, R16    
	ldi R16, UBRR	 
	out UBRRL, R16     ;config. the rate of data tx 
	ldi R16, TXE      
	out UCSRB, R16     ;enable port tx (see p.158)
	ldi R16, FRAME     ;defined in calling     
	out UCSRC, R16     ;config. frame elements 
	;ret

;Code below was written by nsw

tag_read_init:
    LDI     R27,HIGH(buf_in)
    LDI     R26,LOW(buf_in)
    ;LDI     R29,HIGH(buf_out)
    ;LDI     R28,LOW(buf_out)


avr_getch:
    IN      R16, UCSRA
    ANDI    R16, $80
    BREQ    avr_getch
    IN      R16, UDR
    ;ST      X+,R16
    ;CPI     R16,EOTX
    ;BREQ    init_avr_outch
    ;BREQ    init_in_to_out
    RJMP    avr_outch
    
    RJMP    avr_getch

init_avr_outch:
    LDI     R27,HIGH(buf_in)
    LDI     R26,LOW(buf_in)
    ;LDI     R29,HIGH(buf_out)
    ;LDI     R28,LOW(buf_out)

avr_outch_start:
    LD      R16,X+
    
avr_outch:	
    OUT     UDR, R16		;txmt char. out the TxD 
    ;IN      R17, UCSRA 	
    ;ANDI    R17, $20   	
    ;BREQ    avr_outch

    rjmp    avr_getch

    ;CPI     R16,EOTB ;end of text, go to end_of_tx
    ;BREQ    tag_read_init
    ;RJMP    avr_outch_start

fini:
    RJMP    fini

.include "delays.inc"
.include "lcdio.inc"

msg0:    .db "OK", $00