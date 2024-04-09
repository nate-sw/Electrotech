;
; getche_test
; 2024-03-05
; Author : nsw
;

.include "m8515def.inc"

.cseg

;The code below was originally written by Nick Markou in file termio.inc
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

.equ        ADRR1 = $2000 ; Memory address for LCD's control
.equ        ADRR2 = $2100 ; Memory address for LCD's data

init0:
    LDI     R16, LOW(RAMEND)
    OUT     SPL, R16
    LDI     R16, HIGH(RAMEND)
    OUT     SPH, R16
    ;init bus
    LDI     R16,$82
    OUT     MCUCR,R16

    RCALL   init_lcd

    RCALL   lcd_line_dw


init_uart:                 
	ldi R16, 0	       
	out UBRRH, R16    
	ldi R16, UBRR	 
	out UBRRL, R16     ;config. the rate of data tx 
	ldi R16, TXE      
	out UCSRB, R16     ;enable port tx (see p.158)
	ldi R16, FRAME     ;defined in calling     
	out UCSRC, R16     ;config. frame elements 

;Code below was written by nsw

getch_start:
    RCALL   lcd_line_dw

avr_getch:
    IN      R16,UCSRA
    ANDI    R16,$80
    BREQ    avr_getch
    IN      R16,UDR
    RJMP    avr_outch
    
avr_outch:
    OUT     UDR,R16		;txmt char. out the TxD 
    CPI     R16,EOTX ;end of transmission
    BREQ    getch_start
    CPI     R16,$1F 
    BRLO    avr_getch
    RCALL   lcd_puts
    RJMP    avr_getch



fini:
    RJMP    fini

.include "delays.inc"
.include "lcdio.inc"

msg0:    .db " TAG ID:", $00