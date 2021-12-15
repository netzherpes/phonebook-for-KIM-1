; Target assembler: cc65 v2.18.0 [--target none -C telefonbuch.bin_cc65.cfg]
;*****************************
;* Telefonbuch               *
;* (c) 1978                  *
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

         .org    $0000
start:   lda     #$00
         sta     $fa
         lda     #$02       ;Page for Databasestart
         sta     $fb        ;save pointer start
         ldx     #$17
         lda     #$00
Buffer:  sta     $df,x
         dex
         bne     Buffer
read:    jsr     getch
         cmp     #$1b
         bne     chkend
         iny
chkfre:  jsr     INCPT
         lda     ($fa),y
         bne     chkfre
input:   jsr     getch
         iny
         cmp     #esc
         beq     start
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
         cmp     #$0d
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

