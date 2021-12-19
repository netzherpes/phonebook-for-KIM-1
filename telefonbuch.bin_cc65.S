; Target assembler: TASM 
;*****************************
;* Telefonbuch               *
;* (c) 1979                  *
;* Herwig Feichtinger        *
;*****************************
; typed in and checked by Nils Andreas
; comments entered from German listing into source
; checked for being binary compatible with original listing in HobbyComputer 1 1979
;
; Note that getch in KIM-1 returns with Y = $FF, used in this program to save two bytes?
; Testcase for the KIM-1 Simulator, which now emulates this getch behaviour
;
; Hans Otten, 15 december 2021
; 
CR     =       $0d             ; carriage return
esc     =       $1b             ; escape
 
crlf    =       $1e2f           ; KIM-1 print cr 
getch   =       $1e5a           ; KIM-1 read char for tty
space   =       $1e9e           ; KIM-1 print space tty
outch   =       $1ea0           ; KIM-1 print car on tty
incpt   =       $1f63           ; increment pointer
;
; zeropage
;
savy    = $f9
tablep  = $fa                   ; pointer into table 
bufferp = $df                   ; buffer
table   = $0200                 ; table starts here
;
         .org    $0000
;
start:   lda     #(table & $ff) ; low byte table address
         sta     tablep
         lda     #(table >> 8)  ; high byte table address 
         sta     tablep + 1     ; 
         ldx     #$17           ; 17 bytes clear
         lda     #$00
buffer:  sta     bufferp,x      ; clear buffer
         dex
         bne     buffer
;         
read:    jsr     getch          ; get ascii character
         cmp     #esc           ; escape? 
         bne     chkend         ; no
         iny                    ; yes, y = 0
chkfre:  jsr     incpt          ; increment table pointer 
         lda     (tablep),y     ; query buffer
         bne     chkfre         ; free space in buffer?
input:   jsr     getch          ; get ascii character
         iny                    ; y=0
         cmp     #esc           ; escape?
         beq     start          ; yes, back to begin
         sta     (tablep),y     ; no, store in table
         jsr     incpt          ; increment table pointer
         jmp     input          ; and again
 
chkend:  cmp     #CR            ; return?
         beq     zzz            ; yes, line ready
         sta     bufferp +1,x   ; no, store char in buffer
         inx                    ; increment buffer index
         cpx     #$15           ; is $15?
         bne     read           ; next character
;
zzz:     nop                    
         nop
;
newline: jsr     incpt          ; table after return
         ldy     #$00           ; search for character
         lda     (tablep),y     ; in table           
         beq     printquest     ; 
         cmp     #CR            ; found?
         bne     newline        ; no, search again
found:   ldx     #$00           ; yes, compare character in table
compbuf: iny                    ; with character in buffer
         lda     bufferp +1,x   ; no, compare table and buffer
         beq     printline      ; show it
         lda     (tablep),y
         cmp     #CR            ; return?
         beq     zzz
         cmp     bufferp +1,x   ; next character
         bne     found
         inx
         bne     compbuf
;         
         nop
         nop
;
printline:
         jsr     crlf           ; new line
         ldy     #$01
loadchar:
         lda     (tablep),y     ; load character from table
         beq     printquest     ; zero is ready
         cmp     #CR            ; return?
         beq     zzz            ; end of table entry
         sty     savy           ; save Y
         jsr     outch          ; and print character
         ldy     savy
         iny                    ; increment Y, next
         bne     loadchar       ; load new character
printquest:
         jsr     crlf           ; print return
         lda     #'?'           ; print ?
         jsr     outch          ; 
         jsr     space          ; print space
         jmp     start          ; return
;
        .end
