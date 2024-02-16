;------------------------------------------------------------------------------
; Chronos 1-bit music code (C) 1987 Tim Follin / Mastertronic
;
; Disassembled by ZoomTen, June 2020
; Revised: January 2022
;
; https://github.com/ZoomTen/chronos-zxbeeper
;
;------------------------------------------------------------------------------

; whether or not to enable AY noise drums
	ENABLE_AY EQU 0
	SONGSPEED equ 4
;INCLUDE "notes.asm"

; rough note data equivalency

B_2 EQU 254
C_3 EQU 240
Cs3 EQU 226
D_3 EQU 216
Ds3 EQU 202
E_3 EQU 190
F_3 EQU 181
Fs3 EQU 170
G_3 EQU 159 ; new value
Gs3 EQU 151
A_3 EQU 143
As3 EQU 135
B_3 EQU 127

C_4 EQU 120
Cs4 EQU 113
D_4 EQU 107
Ds4 EQU 101
E_4 EQU 95
F_4 EQU 90
Fs4 EQU 85
G_4 EQU 79 ; new value
Gs4 EQU 76
A_4 EQU 71
As4 EQU 65 ; new value
B_4 EQU 64

; new values
C_5 EQU 58
Cs5 EQU 55
D_5 EQU 50
Ds5 EQU 48
E_5 EQU 45
F_5 EQU 43
Fs5 EQU 40
G_5 EQU 38
Gs5 EQU 36
A_5 EQU 34
As5 EQU 32
B_5 EQU 30

C_6 EQU 28
Cs6 EQU 26
D_6 EQU 24
Ds6 EQU 23
E_6 EQU 22
F_6 EQU 20
Fs6 EQU 19
G_6 EQU 18
Gs6 EQU 17
A_6 EQU 16
As6 EQU 15
B_6 EQU 14


; ------------------- music code start -----------------------------------------

	ORG $100


; music init
Music_Init:
	di                      ; Disable interrupts, since perfect timing is needed

IF ENABLE_AY
	ld hl, AY_Snare
feature_ay_loop:
;	ld bc, $fffd             ; + Select AY registers
	ld a, (hl)
	inc hl
	out (129), a               ; + Execute AY part
	ld bc, $bffd             ; + Write to AY registers
	ld a, (hl)
	inc hl
	out (128), a               ; + Execute AY part
	ld a,(hl)
	and a
	jp nz, feature_ay_loop
ENDIF

	ld ix,Music_Chords       ; IX = chords
	ld (Chord_RepeatPoint), ix

	ld iy,Music_Bass        ; IY = bass

; initialize all variables
	xor a
	ld (Music_Init_42+1), a
	inc a
	ld (Music_Init_30+1), a
	ld (Music_Init_36+1), a
	ld (Music_Init_2+1), a
	ld (Music_Init_28+1), a
	ld (Music_Init_40+1), a

	ld (Bass_RepeatPoint), iy

	ld a,(Variables_4)
	ld (Variables_3), a

	ld a,(Variables_5)
	ld (Music_Init_12+1), a

	ld a,(Variables_6)
	ld (Music_Init_14+1), a

	exx

	ld de,Music_Melody      ; DE = melody
	ld (Melody_RepeatPoint),DE

	ld a,1
	ld (Music_Init_34+1), a

	exx

IX_CommandProcessor:
	ld a,(IX+0)             ; Read current byte for 3-tone portion
	cp 2
	jp nz,Music_Init_1
; 02 xx = set repeat
	INC IX
	ld a,(IX+0)             ; Get repeat count
	inc a
	ld (Music_Init_2+1), a   ; Set the repeat counter
	INC IX
	ld (Chord_RepeatPoint), ix     ; Store repeat point address
	ld a,(IX+0)
	jp Music_Init_4         ; Read the next byte
Music_Init_1:
	cp 1
	jp nz,Music_Init_4
; 01 = go back to repeat point
Music_Init_2:
	ld a,2                  ; This is modified by the subroutine above
	DEC A                   ; A is the repeat counter
	jp nz,Music_Init_3      ; If the counter hasn't ran out, go back to loop
	                        ; point
	INC IX
	jp IX_CommandProcessor  ; Read the next byte
Music_Init_3:
	ld (Music_Init_2+1), a   ; Save repeat counter
	ld ix,(Chord_RepeatPoint)     ; Load saved repeat point
	ld a,(IX+0)
Music_Init_4:
	AND A
	jp z,StopMusic          ; If current byte = 0, stop the music entirely
	cp 255
	jp nz,Music_Init_5      ; If current byte != 255, process some notes
; FF xx aa bb .. = special command for setting effects and envelopes
	INC IX                  ; Begin processing effects
	INC IX                  ; IX now points to the first argument
	ld a,(IX-1)             ; Check command byte
	cp 1
	jp z, IX_FFCommand01     ; 1 set envelope
	cp 2
	jp z, IX_FFCommand02
	cp 3
	jp z, IX_FFCommand03
	cp 4
	jp z, IX_FFCommand04     ; 4 play drum pattern?
	cp 5
	jp z, IX_FFCommand05     ; 5 play drum pattern?
	cp 8
	jp z, IX_FFCommand08
	cp 9
	jp z, IX_FFCommand09     ; 9 set 2 note chord mode?
	cp 10
	jp z, IX_FFCommand0a     ; 10 set 3 note chord mode?
	jp IX_CommandProcessor
IX_FFCommand09:
	ld a,1
	ld (Music_Init_42+1), a  ; Use 2 channels
	jp IX_CommandProcessor
IX_FFCommand0a:
	xor a
	ld (Music_Init_42+1), a  ; Use 3 channels
	jp IX_CommandProcessor
IX_FFCommand08:
	ld a,(IX+0)
	INC IX
	ld (Music_Init_24+1), a
	jp IX_CommandProcessor
IX_FFCommand04:
	ld HL,DrumPatternA
	ld (Music_Init_22+1),HL
	jp IX_FFCommand02
IX_FFCommand05:
	ld HL,DrumPatternB
	ld (Music_Init_22+1),HL
	jp IX_FFCommand02
IX_FFCommand02:
	xor a
	ld (Music_Init_23+1), a
	ld a,1
	ld (Music_Init_21+1), a
	jp IX_CommandProcessor
IX_FFCommand03:
	xor a
	ld (Music_Init_23+1), a
	xor a
	ld (Music_Init_21+1), a
	jp IX_CommandProcessor
IX_FFCommand01:
	ld a,(IX+0)             ; Attack?
	ld (Variables_0), a
	ld (Variables), a
	ld a,(IX+1)             ; Decay target?
	ld (Variables_1), a
	ld a,(IX+2)             ; Decay rate?
	ld (Variables_2), a
	ld a,(IX+3)             ; ???
	ld (L62747_2+1), a
	INC IX                  ; Move IX to next music data
	INC IX
	INC IX
	INC IX
	jp IX_CommandProcessor  ; Read next byte
Music_Init_5:
	ld a,(Variables_0)
	ld (Variables), a
	ld a,(Variables_1)
	ld (Music_Init_47+1), a
	ld a,(Variables_2)
	ld (L62747+1), a
	ld D,(IX+2)             ; E,H contains the notes
	ld E,(IX+0)             ; D contains the length / note
	ld H,(IX+1)
	INC IX
	INC IX
	ld a,(Music_Init_42+1)
	DEC A                   ; A = 0 if using 2 channels
	jp z,Music_Init_6
	INC IX
Music_Init_6:
	ld a,(Variables)
	AND A
	jp z,L62682
	ld a,D
	ld (L63022_7+1), a
	SRL A
	SRL A
	SRL A
	ld B, a
	SRL A
	add a,B
	ld (L63022_10+1), a
	ld (Music_Init_48+1), a
	ld a,E
	ld (L63022_13+1), a
	SRL A
	SRL A
	SRL A
	ld B, a
	SRL A
	add a,B
	ld (L63022_16+1), a
	ld (Music_Init_50+1), a
	ld a,H
	ld (L63022_19+1), a
	SRL A
	SRL A
	SRL A
	ld B, a
	SRL A
	add a,B
	ld (L63022_22+1), a
	ld (Music_Init_52+1), a
	ld a,1
	ld (L63022_8+1), a
	ld (L63022_14+1), a
	ld (L63022_20+1), a
; This entry point is used by the routine at L62682.
Music_Init_7:
	ld a,0
	ld (Music_Init_53+1), a
	ld a,(IX+0)
	INC IX
Music_Init_8:
	EX AF, aF'
	xor a


Music_Init_9:
	ld a, 0
	inc a
	ld (Music_Init_9+1), a
Music_Init_10:
	cp 1
	jp nz,Music_Init_11
	xor a
	ld (Music_Init_9+1), a
	ld a,(L63022_28+1)
	DEC A
	jp z,Music_Init_11
	ld (L63022_28+1), a
	ld a,(L63022_30+1)
	inc a
	ld (L63022_30+1), a
Music_Init_11:
	ld a,(Variables_3)
	AND A
	jp z,Music_Init_14
Music_Init_12:
	ld a, 1
	DEC A
	ld (Music_Init_12+1), a
	jp nz,Music_Init_15
	ld a,(Variables_5)
	ld (Music_Init_12+1), a
	ld a,(L63022_2+1)
	inc a
Music_Init_13:
	cp 42
	jp z,L62675
	ld (L63022_2+1), a
	ld a,(L63022_4+1)
	DEC A
	ld (L63022_4+1), a
	jp Music_Init_15
Music_Init_14:
	ld a,2
	DEC A
	ld (Music_Init_14+1), a
	jp nz,Music_Init_15
	ld a,(Variables_6)
	ld (Music_Init_14+1), a
	ld a,(L63022_2+1)
	DEC A
	jp z,Music_Init_15
	ld (L63022_2+1), a
	ld a,(L63022_4+1)
	inc a
	ld (L63022_4+1), a
; This entry point is used by the routine at L62675.
Music_Init_15:
	ld a,(Music_Init_17+1)
	ld B, a
	ld a,(Music_Init_18+1)
	cp B
	jp z,Music_Init_21
Music_Init_16:
	ld B, 1
Music_Init_17:
	ld a, 113
Music_Init_18:
	cp 113                  ; Current note
	jp z,Music_Init_20
	jp c,Music_Init_19
	DEC A
	DEC A
Music_Init_19:
	inc a
	ld (Music_Init_17+1), a
	djnz Music_Init_17
Music_Init_20:
	ld B, a
	call L62613
Music_Init_21:
	ld a, 0
	DEC A
	cp 255
	jp z,Music_Init_28
	ld (Music_Init_21+1), a
	AND A
	jp nz,Music_Init_28
	push hl
	push de
	push bc
Music_Init_22:
	ld HL, DrumPatternA
	ld D,0
Music_Init_23:
	ld E,2
	add HL,DE
	ld a,E
	add a,2
	ld (Music_Init_23+1), a
	ld a,(HL)
	ld C, a
Music_Init_24:
	ld B, 128
	DEC B
	jp z,Music_Init_26
Music_Init_25:
	add a,C
	djnz Music_Init_25
Music_Init_26:
	ld (Music_Init_21+1), a
	inc hl
	push hl
	ld a,(HL)               ; Drums processor?
	cp 0
	call Z,L62826
	cp 1
	call Z,L62926
	cp 2
	call Z,L62845
	cp 3
	call Z,L62876
	cp 4
	call Z,L62959
	cp 5
	call Z,L62994
	POP HL
	inc hl
	ld a,(HL)
	cp 255
	jp nz,Music_Init_27
	xor a
	ld (Music_Init_23+1), a
Music_Init_27:
	POP BC
	POP DE
	POP HL
Music_Init_28:
	ld a, 9
	DEC A
	ld (Music_Init_28+1), a
	jp nz,Music_Init_34
IY_CommandProcessor:
	ld a,(IY+0)
	cp 2
	jp nz,Music_Init_29
	INC IY                  ; 02 xx Set repeat
	ld a,(IY+0)
	inc a
	ld (Music_Init_30+1), a
	INC IY
	ld (Bass_RepeatPoint), iy
	jp IY_CommandProcessor
Music_Init_29:
	cp 1
	jp nz,Music_Init_32
Music_Init_30:
	ld a,3                  ; 01 Go back to repeat point
	DEC A
	jp z,Music_Init_31
	ld (Music_Init_30+1), a
	ld iy,(Bass_RepeatPoint)
	jp IY_CommandProcessor
Music_Init_31:
	INC IY
	jp IY_CommandProcessor
Music_Init_32:
	cp 3
	jp nz,Music_Init_33
	INC IY                  ; 03 xx unknown
	ld a,(IY+0)
	ld (Music_Init_10+1), a
	DEC A
	ld (Music_Init_9+1), a
	INC IY
	jp IY_CommandProcessor
Music_Init_33:
	ld (L63022_27+1), a      ; Process note
	SRL A
	SRL A
	ld L, a
	SRL A
	SRL L
	add a,L
	ld (L63022_28+1), a
	ld L, a
	ld a,1
	ld (L63022_30+1), a
	ld a,(IY+1)
	ld (Music_Init_28+1), a
	INC IY
	INC IY
Music_Init_34:
	ld a,1                  ; Note length
	DEC A
	ld (Music_Init_34+1), a
	jp nz,Music_Init_42
	ld a,1
	ld (Music_Init_12+1), a
	ld (Music_Init_14+1), a
	ld a,(Variables_4)
	ld (Variables_3), a
	exx
DE_CommandProcessor:
	ld a,(DE)
	cp 2
	jp nz,Music_Init_35
	INC DE
	ld a,(DE)
	inc a
	ld (Music_Init_36+1), a
	INC DE
	ld (Melody_RepeatPoint),DE
	jp DE_CommandProcessor
Music_Init_35:
	cp 1
	jp nz,Music_Init_38
Music_Init_36:
	ld a,1
	DEC A
	jp z,Music_Init_37
	ld (Music_Init_36+1), a
	ld de,(Melody_RepeatPoint)
	jp DE_CommandProcessor
Music_Init_37:
	INC DE
	jp DE_CommandProcessor
Music_Init_38:
	ld a,(DE)
	cp 3
	jp nz,Music_Init_39
	INC DE
	ld a,(DE)
	INC DE
	cp 1
	jp z,DE_03Command01
	cp 2
	jp z,DE_03Command02
	cp 3
	jp z,DE_03Command03
	cp 4
	jp z,DE_03Command04
	cp 5
	jp z,DE_03Command05
	cp 6
	jp z,DE_03Command06
	cp 7
	jp z,DE_03Command07
	jp DE_CommandProcessor
DE_03Command06:
	ld a,60                 ; inc a, enables echo
	ld (Music_Init_45), a
	jp DE_CommandProcessor
DE_03Command07:
	xor a                   ; NOP, disables echo
	ld (Music_Init_45), a
	jp DE_CommandProcessor
DE_03Command05:
	ld a,(DE)
	INC DE
	ld (Music_Init_44+1), a
	jp DE_CommandProcessor
DE_03Command03:
	ld a,(DE)
	ld (Music_Init_16+1), a
	INC DE
	jp DE_CommandProcessor
DE_03Command01:
	ld a,1                  ; enable glide
	ld (Music_Init_40+1), a
	jp DE_CommandProcessor
DE_03Command02:
	xor a                   ; disable glide
	ld (Music_Init_40+1), a
	jp DE_CommandProcessor
DE_03Command04:
	ld a,(DE)
	ld (Variables_4), a
	ld (Variables_3), a
	INC DE
	ld a,(DE)
	ld (Variables_5), a
	INC DE
	ld a,(DE)
	ld (Variables_6), a
	INC DE
	ld a,1
	ld (Music_Init_12+1), a
	ld (Music_Init_14+1), a
	jp DE_CommandProcessor
Music_Init_39:
	INC DE
	ld (Music_Init_18+1), a
	ld B, a
Music_Init_40:
	ld a,0
	AND A
	jp nz,Music_Init_41
	call L62613
	ld a,(L63022_1+1)
	ld (Music_Init_17+1), a
Music_Init_41:
	ld a,(DE)
	ld (Music_Init_34+1), a
	INC DE
	exx
Music_Init_42:
	ld a,1
	DEC A
	jp nz,Music_Init_46
	push hl
	push bc
Music_Init_43:
	ld a,8
	inc a
	AND 64
	ld (Music_Init_43+1), a
	ld HL,Variables_10
	ld C, a
	add a, a
	add a,C
	ld C, a
	ld B,0
	add HL,BC
	ld a,(L63022_1+1)
	ld (HL), a
	inc hl
	ld a,(L63022_2+1)
	ld (HL), a
	inc hl
	ld a,(L63022_4+1)
	ld (HL), a
	ld a,(Music_Init_43+1)
Music_Init_44:
	SUB 3
	AND 64
	ld HL,Variables_10
	ld C, a
	add a, a
	add a,C
	ld C, a
	add HL,BC
	ld a,(HL)
Music_Init_45:
	inc a
	ld (L63022_7+1), a
	inc hl
	ld a,(HL)
	SRL A
	ld B, a
	SRL A
	SRL A
	add a,B
	OR 1
	ld (L63022_8+1), a
	inc hl
	ld a,(HL)
	SRL A
	ld B, a
	SRL A
	SRL A
	add a,B
	OR 1
	ld (L63022_10+1), a
	POP BC
	POP HL
Music_Init_46:
	call L63022
	ld a,(Variables)
	cp 0
	jp z,L62747
	cp 2
	jp z,Music_Init_53
Music_Init_47:
	ld a,0
	DEC A
	ld (Music_Init_47+1), a
	jp nz,Music_Init_53
	ld a,(Variables_1)
	ld (Music_Init_47+1), a
	ld a,(L63022_8+1)
	inc a
Music_Init_48:
	cp 0
	jp z,Music_Init_49
	ld (L63022_8+1), a
	ld a,(L63022_10+1)
	DEC A
	ld (L63022_10+1), a
Music_Init_49:
	ld a,(L63022_14+1)
	inc a
Music_Init_50:
	cp 0
	jp z,Music_Init_51
	ld (L63022_14+1), a
	ld a,(L63022_16+1)
	DEC A
	ld (L63022_16+1), a
Music_Init_51:
	ld a,(L63022_20+1)
	inc a
Music_Init_52:
	cp 0
	jp z,L62668
	ld (L63022_20+1), a
	ld a,(L63022_22+1)
	DEC A
	ld (L63022_22+1), a
; This entry point is used by the routines at L62668 and L62747.
Music_Init_53:
	ld a,0
	XOR 1
	ld (Music_Init_53+1), a
	jp z,Music_Init_54
	EX AF, aF'
	jp Music_Init_8
Music_Init_54:
	EX AF, aF'
	DEC A
	jp nz,Music_Init_8
	ld a,127


	jp IX_CommandProcessor
StopMusic:
	ld iy,23610
	ld a,(Music_Init_36+1)
	ld C, a
	ld B,0
	EI
	RET

; Routine at 62613
;
; Used by the routine at Music_Init.
L62613:
	ld a,(Variables_3)
	AND A
	jp z,L62613_0
	ld a,B
	ld (L63022_1+1), a
	SRL A
	SRL A
	ld B, a
	SRL A
	add a,B
	ld (L63022_4+1), a
	ld (Music_Init_13+1), a
	ld a,1
	ld (L63022_2+1), a
	RET
L62613_0:
	ld a,B
	ld (L63022_1+1), a
	SRL A
	SRL A
	ld B, a
	SRL A
	add a,B
	ld (L63022_2+1), a
	ld (Music_Init_13+1), a
	ld a,1
	ld (L63022_4+1), a
	RET

; Routine at 62668
;
; Used by the routine at Music_Init.
L62668:
	xor a
	ld (Variables), a
	jp Music_Init_53

; Routine at 62675
;
; Used by the routine at Music_Init.
L62675:
	xor a
	ld (Variables_3), a
	jp Music_Init_15

; Routine at 62682
;
; Used by the routine at Music_Init.
L62682:
	ld a,D
	ld (L63022_7+1), a
	SRL A
	SRL A
	SRL A
	ld B, a
	SRL A
	add a,B
	ld (L63022_8+1), a
	ld a,E
	ld (L63022_13+1), a
	SRL A
	SRL A
	SRL A
	ld B, a
	SRL A
	add a,B
	ld (L63022_14+1), a
	ld a,H
	ld (L63022_19+1), a
	SRL A
	SRL A
	SRL A
	ld B, a
	SRL A
	add a,B
	ld (L63022_20+1), a
	ld a,1
	ld (L63022_10+1), a
	ld (L63022_16+1), a
	ld (L63022_22+1), a
	jp Music_Init_7

; Routine at 62747
;
; Used by the routine at Music_Init.
L62747:
	ld a,2
	DEC A
	ld (L62747+1), a
	jp nz,Music_Init_53
	ld a,(Variables_2)
	ld (L62747+1), a
	ld a,(L63022_8+1)
	DEC A
	jp z,L62747_0
	ld (L63022_8+1), a
	ld a,(L63022_10+1)
	inc a
	ld (L63022_10+1), a
L62747_0:
	ld a,(L63022_14+1)
	DEC A
	jp z,L62747_1
	ld (L63022_14+1), a
	ld a,(L63022_16+1)
	inc a
	ld (L63022_16+1), a
L62747_1:
	ld a,(L63022_20+1)
	DEC A
L62747_2:
	cp 1
	jp z,L62747_3
	ld (L63022_20+1), a
	ld a, (L63022_22+1)
	inc a
	ld (L63022_22+1), a
	jp Music_Init_53
L62747_3:
	ld a,2
	ld (Variables), a
	jp Music_Init_53

; Routine at 62826
;
; Used by the routine at Music_Init.
L62826:
	ld bc,700
L62826_0:
	DEC BC
	ld a,B
	OR C
	jp nz,L62826_0
	xor a                   ; Zero
	OUT (2), a             ; Set beeper low
	ld a,0
L62826_1:
	DEC A
	jp nz,L62826_1
	RET

; Routine at 62845
;
; Used by the routine at Music_Init.
L62845:
	ld HL,0
	ld B,10
L62845_0:
	xor a
	OUT (2), a
	ld a,(HL)
	inc hl
	AND 128
	add a,16
L62845_1:
	DEC A
	jp nz,L62845_1
	ld a,64                 ; High
	OUT (2), a             ; Set beeper high

	ld a,20
L62845_2:
	DEC A
	jp nz,L62845_2
	djnz L62845_0
	RET

; Routine at 62876
;
; Used by the routine at Music_Init.
L62876:
	ld bc,0002
	ld a,64
	out (c), a

	ld bc,0002
	ld a,0
	out (c), a

	ld C,5
	ld HL,10
L62876_0:
	xor a
	OUT (2), a             ; Set beeper low
	ld B,(HL)
	inc hl
L62876_1:
	djnz L62876_1
	ld	a, 64

	OUT (2), a             ; Set beeper high
	ld B,(HL)
	inc hl
L62876_2:
	djnz L62876_2
	push bc
	ld bc,C_4
L62876_3:
	DEC BC
	ld a,B
	OR C
	jp nz,L62876_3
	POP BC
	DEC C
	jp nz,L62876_0
	RET

; Routine at 62926
;
; Used by the routine at Music_Init.
L62926:
	ld C,30
	ld HL,1000
L62926_0:
	xor a
	OUT (2), a             ; Set beeper low

	ld B,C
L62926_1:
	djnz L62926_1
	ld a,64
	OUT (2), a             ; Set beeper high

	ld a,31
	SUB C
	ld B, a
L62926_2:
	djnz L62926_2
	ld a,(HL)
	and	64				; djm
	ld B, a
	inc hl
L62926_3:
	djnz L62926_3
	DEC C
	jp nz,L62926_0
	RET

; Routine at 62959
;
; Used by the routine at Music_Init.
L62959:
	ld C,26
	ld HL,1000
L62959_0:
	xor a
	OUT (2), a             ; Set beeper low

	ld a,C
	ld B, a
L62959_1:
	djnz L62959_1
	ld a,64
	OUT (2), a             ; Set beeper high

	ld a,27
	SUB C
	ld B, a
L62959_2:
	djnz L62959_2
	ld a,(HL)
	and	64						; djm
	ld B, a
	inc hl
L62959_3:
	djnz L62959_3
	DEC C
	DEC C
	jp nz,L62959_0
	RET

; Routine at 62994
;
; Used by the routine at Music_Init.
L62994:
	ld HL,2000
	ld C,25
L62994_0:
	xor a
	OUT (2), a             ; Beeper low

	ld B,30
L62994_1:
	djnz L62994_1
	ld a,64
	OUT (2), a             ; Beeper high

	ld a,(HL)
	inc hl
	AND 128
	ld B, a
L62994_2:
	djnz L62994_2
	DEC C
	jp nz,L62994_0
	RET

; Routine at 63022
;
; Used by the routine at Music_Init.
L63022:
	ld B,0
	call L63022_0           ; This routine is executed 4 times
	call L63022_0
	call L63022_0
L63022_0:
	DEC C                   ; counter for something?
	jp nz,L63022_6          ; ?
	xor a
	OUT (2), a             ; Beeper low

L63022_1:
	ld C,113
L63022_2:
	ld a,38
L63022_3:
	DEC A
	jp nz,L63022_3
	ld a,64
	OUT (2), a             ; Beeper high

L63022_4:
	ld a,5
L63022_5:
	DEC A
	jp nz,L63022_5
L63022_6:
	DEC D
	jp nz,L63022_12         ; First note?
	xor a
	OUT (2), a             ; Beeper low

L63022_7:
	ld D,114
L63022_8:
	ld a,24
L63022_9:
	DEC A
	jp nz,L63022_9
	ld a,64
	OUT (2), a             ; Beeper high

L63022_10:
	ld a,2
L63022_11:
	DEC A
	jp nz,L63022_11
L63022_12:
	DEC E
	jp nz,L63022_18         ; Second note?
	xor a
	OUT (2), a             ; Beeper low

L63022_13:
	ld E,101
L63022_14:
	ld a,14
L63022_15:
	DEC A
	jp nz,L63022_15
	ld a,64
	OUT (2), a             ; Beeper high

L63022_16:
	ld a,5
L63022_17:
	DEC A
	jp nz,L63022_17
L63022_18:
	DEC H
	jp nz,L63022_24         ; Third note?
	xor a
	OUT (2), a             ; Beeper low

L63022_19:
	ld H,170
L63022_20:
	ld a,27
L63022_21:
	DEC A
	jp nz,L63022_21
	ld a,64
	OUT (2), a             ; Beeper high

L63022_22:
	ld a,5
L63022_23:
	DEC A
	jp nz,L63022_23
L63022_24:
	ld a,B
	AND 1
	jp nz,L63022_26
L63022_25:
	djnz L63022_0
	RET
L63022_26:
	DEC L
	jp nz,L63022_25
	xor a
	OUT (2), a             ; Beeper low

L63022_27:
	ld L,151
L63022_28:
	ld a,29
L63022_29:
	DEC A
	jp nz,L63022_29
	ld a,64
	OUT (2), a             ; Beeper high

L63022_30:
	ld a,8
L63022_31:
	DEC A
	jp nz,L63022_31
	jp L63022_25

; Data block at 63170 variables
Variables:
	defb 0
Variables_0:
	defb 0
Variables_1:
	defb 0
Variables_2:
	defb 2
Variables_3:
	defb 0
Variables_4:
	defb 0
Variables_5:
	defb 1
Variables_6:
	defb 2
	defb 0
Melody_RepeatPoint:
	defw 0 ; insert pointer here
	defb 0
Bass_RepeatPoint:
	defw 0 ; insert pointer here
	defb 0
Chord_RepeatPoint:
	defw 0 ; insert pointer here
	defb 0,255


; drum pattern 1
; format: <length> <note>
; 0 = kick
; 1 = stick
; 2 = kick2?
; 3 = SNARE
; 4 = hihat
; 5 = pedal hat?
DrumPatternA:
	defb 8,0
	defb 8,2
	defb 4,3
	defb 2,0
	defb 4,3
	defb 2,0
	defb 2,3
	defb 2,0
	defb $ff, $ff

; drum pattern 2
; format: <length> <note>
DrumPatternB:
	defb 8,0
	defb 8,3
	defb 6,0
	defb 2,0
	defb 2,3
	defb 4,0
	defb 2,4
	defb 8,0
	defb 4,3
	defb 4,0
	defb 8,0
	defb 4,3
	defb 2,0
	defb 2,0
	defb 8,0
	defb 8,3
	defb 6,0
	defb 2,0
	defb 2,3
	defb 6,0
	defb 8,0
	defb 4,3
	defb 4,0
	defb 8,0
	defb 2,1
	defb 2,3
	defb 4,3
	defb $ff, $ff

AY_Snare:
	defb 7,55,11
	defb 0

	defb 12,8,13,1,8,17,6
	defb 5,8,16,0,0

Variables_10:
	defb 101,33,5
	defb 113,42,1,113,41,2,113,41
	defb 2,113,40,3,113,40,3,113
	defb 39,4,113,39,4,113,38,5
	defb 101,37,1,101,36,2,101,36
	defb 2,101,35,3,101,35,3,101
	defb 34,4

; Message at 63324
L63324:
	DEFM "e\"",10,"ng to say but what a day, how's your boy been    Nothing to d"



;INCLUDE "macros.asm"

; predef commands
	predefCommand1 equ $FF
	predefCommand2 equ $03


; to mute use parameters: 1, 0, 1, 1
MACRO chord_envelope, ?attack, ?sustain, ?decay, ?release
	defb predefCommand1
	defb $01, ?attack, ?sustain, ?decay, ?release
ENDM

MACRO fx_02
	defb predefCommand1
	defb $02
ENDM

MACRO fx_03
	defb predefCommand1
	defb $03
ENDM

MACRO drumA ; play drum pattern A
	defb predefCommand1
	defb $04
ENDM

MACRO drumB ; play drum pattern B
	defb predefCommand1
	defb $05
ENDM

MACRO drum_speed, ?speed ; speeding up drums may slow down entire song
	defb predefCommand1
	defb $08, ?speed
ENDM

MACRO two_note_chord ; beware: this will also ENABLE echo
	defb predefCommand1
	defb $09
ENDM

MACRO three_note_chord ; beware: this will also DISABLE echo
	defb predefCommand1
	defb $0A
ENDM

MACRO enable_glide
	defb predefCommand2
	defb $01
ENDM

MACRO disable_glide
	defb predefCommand2
	defb $02
ENDM

MACRO glide_speed, ?speed
	defb predefCommand2
	defb $03, ?speed
ENDM

; to mute use parameters: 1, 0, 1
MACRO melody_envelope, ?is_attack, ?attack, ?decay ; set envelope?
	defb predefCommand2
	defb $04, ?is_attack, ?attack, ?decay
ENDM

MACRO echo_volume, ?volume
	defb predefCommand2
	defb $05, ?volume
ENDM

MACRO enable_echo ; only works in 2-note chord mode. This also detunes the melody.
	defb predefCommand2
	defb $06
ENDM

MACRO disable_echo
	defb predefCommand2
	defb $07
ENDM

MACRO return
	defb $01
ENDM

MACRO repeat, ?times ; minimum of 2x
	defb $02, ?times-1
ENDM

MACRO end_song
	defb $00
ENDM

MACRO note, ?note, ?length
	defb ?note
	defb ?length * SONGSPEED
ENDM

MACRO chord2, ?note1, ?note2, ?length ; two notes pressed
	defb ?note1, ?note2
	defb ?length * SONGSPEED
ENDM

MACRO chord3, ?note1, ?note2, ?note3, ?length ; two notes pressed
	defb ?note1, ?note2, ?note3
	defb ?length * SONGSPEED
ENDM

MACRO song_speed, ?speed ; compile-time parameter
; higher speed parameter = slower song
; this is usually the length of a 16th note
	_SPEED defl ?speed
ENDM

; the engine supports only one song, but you can make your own and replace
; the file name here.
;
; must contain the following labels:
; Music_Data, Music_Chords, Music_Bass, Music_Melody
; INCLUDE "chronos_title.asm"


Music_Data:
	song_speed 4

Music_Chords:
; assuming a "16th note" means a note in the melody layer with length 1
; then a length 1 on this layer is a 8th note
	drum_speed 1
	fx_03
	three_note_chord
	chord_envelope 1, 2, 3, 1
	chord_envelope 0, 0, 3, 1

	song_speed 1
; the drum pattern is repeated for the first few beats
	drumB
	chord3 Cs4, As3, Fs3, 6
	drumB
	chord3 Ds4, C_4, Gs3, 6
	drumB
	chord3 E_4, Cs4, A_3, 6
	drumB
	chord3 Fs4, Ds4, B_3, 6
	drum_speed 128
	drumA

	chord3 Cs4, Gs3, F_3, 64

; begin first part
	two_note_chord
	repeat 2
		chord_envelope 0, 0, 2, 1
		chord2 Ds4, Fs3, 32         ; 1st chord note, 2nd chord note, length
		chord2 Ds4, Fs3, 18
		chord_envelope 1, 1, 0, 1
		chord2 Gs3, F_3-1, 14
	return
	drum_speed 2
	drumB
	repeat 16
		chord_envelope 0, 0, 2, 1
		chord2 A_3, D_4, 32
		chord2 A_3, D_4, 18
		chord_envelope 1,1,0,1
		chord2 Gs3, E_4, 14
	return
	repeat 8
		chord_envelope 0,0,2,1
		chord2 Ds4, Fs3, 32
		chord2 A_3, D_4, 18
		chord_envelope 1,1,0,1
		chord2 Gs3, E_4, 14
	return
	drum_speed 2
	drumA
	three_note_chord
	chord_envelope 0,0,1,1
	repeat 24
		chord3 Ds4, B_3, Fs3, 8
		chord3 Cs4, As3, Fs3, 8
		chord3 Cs4, A_3, E_3, 6
		chord3 B_3, Gs3, E_3, 6
		chord3 Cs4, A_3, E_3, 4
	return
; last few bars
	chord_envelope 0, 0, 0, 1
	drum_speed 64
	drumB
	chord3 Ds4, B_3, Fs3, 12
	drumB
	chord3 Cs4, As3, Fs3, 16
	drumB
	chord3 Cs4, A_3, E_3, 24
	drumB
	chord3 B_3, Gs3, E_3, 64
	drum_speed 2
	drumA
	chord3 Ds4, B_3, Fs3, 32
	chord3 B_4-1, B_3, B_2, 4
	end_song

Music_Bass:
	song_speed 4
	enable_glide
	note Cs3, 3
	note C_3, 3
	note D_3, 3
	note Cs3, 3
	note Ds3, 32
	enable_glide
	repeat 4
		note Gs3, 4
		note Gs3, 4
		note Gs3, 4
		note Gs3, 2
		note Gs3, 2
	return
	repeat 24
		note B_2, 4
		note B_3, 4
		note E_3, 1
		note Fs3, 1
		note A_3, 1
		note Fs3, 1
		note A_3, 1
		note B_3, 1
		note B_2, 4
		note B_3, 4
		note B_3, 1
		note A_3, 1
		note E_3, 1
		note Fs3, 1
		note E_3, 1
		note Fs3, 1
		note A_3, 1
		note B_3, 1
		note Fs3, 1
		note Cs3, 1
	return
	repeat 24
		note B_2, 2
		note B_2, 2
		note A_3, 1
		note B_3, 2
		note A_3, 1
		note Fs3, 2
		note E_3, 1
		note Fs3, 2
		note E_3, 1
		note Fs3, 1
		note Cs3, 1
	return
	note B_3, 6
	note As3, 8
	note A_3, 12
	note Gs3, 32
	note B_2, 16
	note B_3, 2
	end_song

Music_Melody:
	glide_speed 1
	disable_glide
	melody_envelope 0,1,2 ; set priority? Attack, sustain, decay?
	disable_glide
; melody begin
	note Cs4, 1
	note As3, 1
	note Fs3, 1
	note Ds4, 1
	note C_4, 1
	note Gs3, 1
	note E_4, 1
	note Cs4, 1
	note A_3, 1
	note Fs4, 1
	note Ds4, 1
	note B_3, 1
	note F_4, 32

; key seems to shift up here to compensate for echo?
	echo_volume 3
	enable_echo
	note B_3, 6
	note As3, 1
	note B_3, 6
	note Cs4, 1
	note Ds4, 2
	note Cs4, 2
	note B_3, 2
	note As3, 2
	note Fs3, 2
	note Gs3, 8

	note B_3, 6
	note As3, 1
	note B_3, 5
	note Cs4, 1
	song_speed 6	; triplet
	note D_4, 1
	note Ds4, 1
	song_speed 4	; whole
	note Fs4, 2
	song_speed 2
	repeat 4
		note D_4,1
		note B_3,1
	return

	song_speed 4
	enable_glide
	note Fs4,10

; normal key?
	disable_glide
	disable_echo
	echo_volume 10
	repeat 2
		note Fs4, 1
		note E_4, 1
		note Fs4, 8
		note Gs4, 1
		note A_4, 1
		note B_4, 1
		note Gs4, 1
		note E_4, 1
		note Gs4, 1
		note Fs4, 1
		note A_4, 1
		note Fs4, 14
	return

	note Fs4, 1
	note E_4, 1
	note D_4, 1
	note Cs4, 1
	note D_4, 1
	note Cs4, 1
	note B_3, 1
	note A_3, 1
	note B_3, 1
	note A_3, 1
	note Fs3, 1
	note E_3, 1
	note Fs3, 20

	note Fs3, 1
	note E_3, 1
	note Fs3, 1
	note A_3, 1
	note B_3, 1
	note A_3, 1
	note B_3, 1
	note Cs4, 1
	note D_4, 1
	note Cs4, 1
	note D_4, 1
	note E_4, 1
	note Fs4, 20

	song_speed 2 ; really fast notes
	repeat 2
		note B_2, 1
		note E_3, 1
		note Fs3, 1
		note B_3, 1
		note E_4, 1
		note Fs4, 1
		note B_4, 1
		note Fs4, 1
		note E_4, 1
		note B_3, 1
		note Fs3, 1
		note E_3, 1
	return
	note B_2, 1
	note E_3, 1

	song_speed 1	; precise
	note Fs3, 38
	melody_envelope 1,1,0
	note E_3, 38
	melody_envelope 0,0,3
	enable_glide
	note A_4, 115
	disable_glide

	song_speed 4
	repeat 4
		note Gs4, 1
		note E_4, 1
		note Cs4, 1
		note E_4, 1
		note Fs4, 12
	return

	note Gs4, 1
	note E_4, 1
	note Cs4, 1
	note Fs4, 8

	repeat 4	; ?
	repeat 2
		song_speed 2 ; really fast notes
		note Fs3, 1
		note B_3, 1
		note Cs4, 1
		note B_4, 1
		note Cs4, 1
		note B_3, 1
		note Fs3, 1
		note Cs3, 1
	return

	song_speed 4
	note Fs3, 16
	glide_speed 2
	note Fs4, 4
	enable_glide
	note E_4, 4
	note Fs4, 4
	note A_4, 4
	note Fs4, 4
	note E_4, 4
	note D_4, 4
	note Cs4, 4
	note B_3, 8
	note A_3, 4
	note As3, 4
	note B_3, 8
	note A_3, 4
	note F_3-1, 4
	disable_glide
	note Fs4, 4
	enable_glide
	note E_4, 4
	note Fs4, 4
	note A_4, 4
	note Fs4, 4
	note E_4, 4
	note D_4, 4
	note Cs4, 4
	echo_volume 0
	disable_glide
	repeat 4
		note D_4, 1
		note B_3, 1
		note Fs3, 1
		note Cs4, 1
		note A_3, 1
		note Fs3, 1
		note D_4, 1
		note B_3, 1
		note Fs3, 1
		note Cs4, 1
		note A_3, 1
		note Fs3, 1
		note D_4, 1
		note B_3, 1
		note Cs4, 1
		note A_3, 1
	return
	echo_volume 9
	repeat 4	; same as previous section
		note D_4, 1
		note B_3, 1
		note Fs3, 1
		note Cs4, 1
		note A_3, 1
		note Fs3, 1
		note D_4, 1
		note B_3, 1
		note Fs3, 1
		note Cs4, 1
		note A_3, 1
		note Fs3, 1
		note D_4, 1
		note B_3, 1
		note Cs4, 1
		note A_3, 1
	return
	repeat 4
		note Ds4, 1
		note B_3, 1
		note Fs3, 1
		note Cs4, 1
		note As3, 1
		note Fs3, 1
		note Ds4, 1
		note B_3, 1
		note Fs3, 1
		note Cs4, 1
		note As3, 1
		note Fs3, 1
		note Ds4, 1
		note B_3, 1
		note Cs4, 1
		note As3, 1
		note D_4, 1
		note B_3, 1
		note Fs3, 1
		note Cs4, 1
		note A_3, 1
		note Fs3, 1
		note D_4, 1
		note B_3, 1
		note Fs3, 1
		note Cs4, 1
		note A_3, 1
		note Fs3, 1
		note D_4, 1
		note B_3, 1
		note Cs4, 1
		note A_3, 1
	return

; Deadmau5 - Edit Your Friends :p
	melody_envelope 0, 0, 1
	repeat 4
		note Ds4, 15
		note E_4, 1
		note D_4, 8
		note Fs4, 1
		note E_4, 6
		note Fs4, 1
	return

	disable_glide
	melody_envelope 1, 8, 0
	note B_4, 0	; length 256

	melody_envelope 0,0,2
	repeat 2
		note B_4, 2
		note 56, 2
		note B_4+3, 1
		note Gs4, 1
		note Fs4, 2
		note A_4, 2
		note B_4, 2
		note Gs4, 1
		note Fs4, 1
		note E_4, 2
		note Fs4, 16
	return
	repeat 4
		note B_4, 4
		note 67, 4
		note A_4, 3
		note Gs4, 3
		note A_4, 2
	return
	repeat 2
		note B_4, 2
		note 56, 2
		note B_4+3, 1
		note Gs4, 1
		note Fs4, 1
		note Gs4, 1
		note A_4, 1
		note Gs4, 1
		note Fs4, 1
		note E_4, 1
		note Gs4, 1
		note Fs4, 1
		note E_4, 1
		note Fs4, 1
		note Ds4, 16
		glide_speed 9
		enable_glide
	return
	repeat 2
		note Ds4, 1
		note Cs4, 1
		note Ds4, 1
		note E_4, 1
		note Fs4, 1
		note Gs4, 1
		note A_4, 1
		note Gs4, 1
		note A_4, 1
		note Gs4, 1
		note Fs4, 1
		note E_4, 1
		note Gs4, 1
		note Fs4, 1
		note E_4, 1
		note Fs4, 1
		note Ds4, 16
	return
	disable_glide
	repeat 4
		note Ds4, 1
		note B_3, 1
		note Fs3, 1
		note B_3, 1
		note Cs4, 1
		note As3, 1
		note Fs3, 1
		note As3, 1
		note Cs4, 1
		note A_3, 1
		note E_3, 1
		note B_3, 1
		note Gs3, 1
		note E_3, 1
		note Cs4, 1
		note A_3, 1
	return

; final few bars
	note B_3, 6
	enable_glide
	note As3, 8
	note A_3, 12
	note Gs3, 32

	note B_2, 16
	disable_glide
	defb B_3	; length doesn't matter at this point, song is cut off

