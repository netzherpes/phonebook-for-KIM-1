; Target assembler: cc65 v2.18.0 [--target none -C telefonbuch.bin_cc65.cfg]
;*****************************
;* Telefonbuch               *
;* (c) 1979                  *
;* Herwig Feichtinger        *
;*****************************
         .setcpu "6502"
ret      =       $0d
esc      =       $1b

CR       =       $1e2f
getch    =       $1e5a
space    =       $1e9e
OUTCH    =       $1ea0
INCPT    =       $1f63

         .org    $0200
		 jmp     istruct
start:   lda     #$00
         sta     $fa
         lda     #$20       ;Page for Databasestart
         sta     $fb        ;save pointer start
         ldx     #$17
         lda     #$00
Buffer:  sta     $df,x
         dex
         bne     Buffer
read:    jsr     getch
         cmp     #esc
         bne     chkend
         iny
		 
chkfre:  jsr     INCPT
         lda     ($fa),y
         bne     chkfre
		 jsr     CR
input:   jsr     getch
         iny
         cmp     #esc
         beq     writezero
         sta     ($fa),y
         jsr     INCPT
		 jmp     input

chkend:  cmp     #ret
         beq     zzz
         sta     $e0,x
         inx
         cpx     #$15
         bne     read
zzz:     nop
         nop
newline: jsr     INCPT
         ldy     #$00
         lda     ($fa),y
         beq     printQuest
         cmp     #ret
         bne     newline
found:   ldx     #$00
compbuf: iny
         lda     $e0,x
         beq     printline
         lda     ($fa),y
         cmp     #ret
         beq     zzz
         cmp     $e0,x
         bne     found
         inx
         bne     compbuf
         nop
         nop
printline:
         jsr     CR
         ldy     #$01
loadchar:
         lda     ($fa),y
         beq     printQuest
         cmp     #ret
         beq     zzz
         sty     $f9
         jsr     OUTCH
         ldy     $f9
         iny
         bne     loadchar
printQuest:
         jsr     CR
         lda     #$3f
         jsr     OUTCH
         jsr     space
         jmp     start
writezero:
		 lda     #$00
		 sta     ($fa),y
		 jmp     start
istruct:
		lda  	 text,x
        cmp  	 #$0
		bne  	 printmes
		ldx 	 #$0
		jmp 	 printQuest
printmes:
	    jsr      OUTCH    
        inx
        jmp      istruct
text: 	.byte $0a,$0d
	    .byte  "Phonebook by Herwig Feichtinger"
		.byte $0a,$0d,$0a,$0d
		.byte "Data is stored in $2000. Toggle enter / search with (ESC)"
		.byte $0a,$0d
		.byte "Search: enter a search term after the ?"
		.byte $0a,$0d
		.byte "Enter: Type in your entry with and end with (RETURN). Begin your very first entry also with an (RETURN)"
		.byte $0  ;stop now
