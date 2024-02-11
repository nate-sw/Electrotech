;
; Filename: lcdstartup.inc
; Description: Contains all code pertaining to the pgm startup
;
; Author: nsw
;
; Changelog:
; 2023-12-15: File created

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
        CLR   R16
        RCALL lcd_msg_dsp
        RCALL dly4s
        RET