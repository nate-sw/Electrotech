;
; Filename: lcdio.asm
; Description: Subroutine containing the LCD initialization and IO code.
;
; Author: nsw
;
; Changelog:
; 2023-12-04: Created
; 2024-02-09: Code imported from PBL, 

.global init_lcd
.global lcd_clr
.global lcd_line_up
.global lcd_line_dw
.global lcd_msg_dsp
.include "delays.inc"
.equ     ADRR1 = $2000 ; Memory address for LCD's control
.equ     ADRR2 = $2100 ; Memory address for LCD's data

init_lcd:
        RCALL dly50msi
;fctn_set:               
        LDI   R16, $38 ;function set
        STS   ADRR1, R16
        RCALL dly50usi
        LDI   R16, $38 ;function set
        STS   ADRR1, R16
        RCALL dly50usi
;lcd_on:
        LDI   R16, $0C ;Turn display on, cursor and position on
        STS   ADRR1, R16
        RCALL dly50usi
; clear lcd
        RCALL lcd_clr
        RCALL dly2ms
;lcd_ent_md:
        LDI   R16, $06 ;entry mode
        STS   ADRR1, R16
        RCALL dly50usi

;init_msg0:
        LDI   R31, HIGH(msg0<<1)
        LDI   R30, LOW(msg0<<1)
        RCALL dly2ms
        CLR   R16

;startup:
        RCALL lcd_line_up
        RCALL lcd_line_dw
        LDI   R31, HIGH(msg1<<1)
        LDI   R30, LOW(msg1<<1)
        RCALL dly50usi
        RCALL lcd_msg_dsp
        RCALL dly4s
        RET

lcd_clr:
    LDI   R16, $01 ;clear display
    RJMP  lcdio_ret

lcd_line_up:
    LDI   R16, $80
    RJMP  lcdio_ret

lcd_line_dw:
    LDI   R16, $C0
    RJMP  lcdio_ret


lcd_puts:
    STS   ADRR2, R16
    RET


lcdio_ret:
    STS   ADRR1, R16
    RET

lcd_msg_call:
    MOV   R30,R24
    MOV   R31,R25

lcd_msg_dsp:
    LPM   R16, Z+
    CPI   R16, $00
    BREQ  lcd_msg_ret
    RCALL lcd_puts
    RCALL dly10ms
    RCALL dly50msi
    RJMP  lcd_msg_dsp

lcd_msg_ret:
    RET

