;
; Filename: numio.inc
; 
; The following code supplied to the Fall 2018 243-513-DW students for educational/study
; purposes. The use of these routines, in whole or in part, without proper reference to 
; origin is a violation of ISEP regarding Academic Integrity and Plagerism.
;
;Description: Subroutine framework for use in the project (do not modify) 
;
;Author: Mr. Markou
;
;Changelog:
;1v0 11/10/17 - finalized and commented version 
;2v0 11/11/18 - forked into this version with extra routine
;2.1 11/12/19 - added hex2bcd8
;
;----------------
;*hex2asc - converts an 8 bit hex value into a valid ASCII characters by
;*	    masking and shifting ASCII character into a valid binary form
; Entry: R16 should contain the hex number to convert
; Usage: R15,R17,R18 **save before calling rtn if used 
; Exit:  R17:R16 contain msd:lsd respectively
hex2asc:
     clr   R17
     mov   R15,R16      ;make copy of hex number
     lsr   R16          ;shift ms nyble to ls
     lsr   R16     
     lsr   R16
     lsr   R16
h2a:
     andi  R16,$0F     ;mask off upper nyble
     ldi   R18,$30   
     add   R16,R18     ;add $30 to adjust to ascii 0 - 9
     cpi   R16,$3A     ;check if valid bcd range
     brlo  h2b
     ldi   R18,7       ;adjust to hex char into 'A' - 'F'
     add   R16,R18
h2b:
     push  R16		   ;save msd ascii
     mov   R16,R15
     inc   R17
     cpi   R17,1
     breq  h2a
	 pop  R17           ;R17:R16 contain msd:lsd ascii numbers
     pop  R16
     ret
;---------------
;* hex2BCD8 - 8-bit Binary to BCD rtn which converts a hex number 
;             from $00 - $63 to $00 - $99 in bcd 
; Entry: R16 should contain the hex number to convert
; Exit: R16 contains converted number
hex2bcd8:
	push    R17	   ;save on stack in case of zombies 
	clr	R17	   ;clear R16 reg
msd:
	subi	R16,10	   ;input = input - 10
	brcs	lsd	   ;abort if carry set
	subi	R17,-$10   ;R17 = R17 + 10
	rjmp	msd	   ;loop again
lsd:
	subi	R16,-10	   ;compensate extra subtraction
	add	R16,R17		
	pop     R17	   ;restore it back
	ret

;
;//insert following two directives to main program a line before .exit
;.nolist
;.include "numio.inc"   ;append library subroutines from same folder
