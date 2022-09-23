

	org	$100

start:
	

	ld	hl,musicData1
	di
	call	play
	ei
	ret


	;engine code

;Two channel beeper music engine from Earth Shaker game
;original code by Michael Batty, 1990
;reversed by Oleg Origin, 2012
;1tracker version by Shiru, 2013
; most of the code and song format has been changed
; sound generation loop and sound features are kept intact

play:


playLoop:

	xor a				;poll keyboard to exit

	ld a,(hl)			;row length, $ff is end of the song
	cp $ff
	jr z,playStop

	inc hl
	ld e,(hl)			;ch1 note, bit 7 is drum 1
	inc hl
	ld c,(hl)			;ch2 note, bit 7 is drum 2
	inc hl
	push hl 			;remember song pointer
	ld h,a
	xor a
	ld l,a
	ld d,a
	ld b,a
	push hl 			;remember row length
	sla c
	rla
	sla e
	rla
	push de
	push bc

	or a
	jr z,noDrum
	ld de,3
	ld hl,523
	dec a
	jr z,playDrum
	ld de,5
	ld hl,262
	
playDrum:

	call L03B5		;drums are simply ROM beep calls
;        di
	
noDrum:

	pop bc
	pop de

	ld hl,noteTable 	;get first channel freq
	add hl,de
	ld   e,(hl)
	inc  hl
	ld   d,(hl)
	push de
	pop  ix
	dec  ix

	ld hl,noteTable 	;get second channel freq
	add hl,bc
	ld   c,(hl)
	inc  hl
	ld   b,(hl)
	push bc
	pop  iy

	pop hl			;restore row length

playTone:

	dec  de
	ld   a,d
	or   e
	jr   nz,playTone1
	xor  a
	sla	a
	sla	a
       out  (2),a

	ld   a,64
       out  (2),a


	push ix
	pop  de
	
playTone1:

	dec  bc
	ld   a,b
	or   c
	jr   nz,playTone2
	ld   a,64
       out  (2),a


	xor  a
       out  (2),a


	push iy
	pop  bc
	
playTone2:

	dec  hl
	ld   a,h
	or   l
	jr	nz,playTone

	pop hl			 ;restore song pointer
	jr playLoop

playStop:

	ld iy,$4000
;        ei
	ret


;; Copy of ZX Spectrum BEEPER routine
L03B5:	DI			; Disable Interrupts so they don't disturb timing
	LD	A,L		;
	SRL	L		;
	SRL	L		; L = medium part of tone period
	CPL			;
	AND	$03		; A = 3 - fine part of tone period
	LD	C,A		;
	LD	B,$00		;
	LD	IX,L03D1	; Address: BE-IX+3
	ADD	IX,BC		;   IX holds address of entry into the loop
				;   the loop will contain 0-3 NOPs, implementing
				;   the fine part of the tone period.
;        LD      A,($5C48)       ; BORDCR
;        AND     $38             ; bits 5..3 contain border colour
;        RRCA                    ; border colour bits moved to 2..0
;        RRCA                    ;   to match border bits on port #FE
;        RRCA                    ;
;        OR       $08            ; bit 3 set (tape output bit on port #FE)
;                                ;   for loud sound output
	xor	a

;; BE-IX+3
L03D1:	NOP		 ;(4)	; optionally executed NOPs for small
				;   adjustments to tone period
;; BE-IX+2
L03D2:	NOP		 ;(4)	;

;; BE-IX+1
L03D3:	NOP		 ;(4)	;

;; BE-IX+0
L03D4:	INC	B	 ;(4)	;
	INC	C	 ;(4)	;

;; BE-H&L-LP
L03D6:	DEC	C	 ;(4)	; timing loop for duration of
	JR	NZ,L03D6 ;(12/7);   high or low pulse of waveform

	LD	C,$3F	 ;(7)	;
	DEC	B	 ;(4)	;
	JP	NZ,L03D6 ;(10)	; to BE-H&L-LP


	sla	a
	sla	a

	XOR	64	 ;(7)	; toggle output beep bit
        OUT     (2),A  ;(11)  ; output pulse

	jp nz,.HP	;[10]


	jp .LP		;[10]

.HP:	

	sla	a
	sla	a
	out (2),a	;[11]	Cassette Output becomes High

	jp .LP		;[10]
.LP:

.lodc:	LD	B,H	 ;(4)	; B = coarse part of tone period
	LD	C,A	 ;(4)	; save port #FE output byte
	BIT	6,A	 ;(8)	; if new output bit is high, go
	JR	NZ,L03F2 ;(12/7);   to BE-AGAIN

	LD	A,D	 ;(4)	; one cycle of waveform has completed
	OR	E	 ;(4)	;   (low->low). if cycle countdown = 0
	JR	Z,L03F6  ;(12/7);   go to BE-END

	LD	A,C	 ;(4)	; restore output byte for port #FE
	LD	C,L	 ;(4)	; C = medium part of tone period
	DEC	DE	 ;(6)	; decrement cycle count
	JP	(IX)	 ;(8)	; do another cycle

;; BE-AGAIN                     ; halfway through cycle
L03F2:	LD	C,L	 ;(4)	; C = medium part of tone period
	INC	C	 ;(4)	; adds 16 cycles to make duration of high = duration of low
	JP	(IX)	 ;(8)	; do high pulse of tone

;; BE-END
L03F6:	;EI			 ; Enable Interrupts
	RET			;

noteTable:

	dw $0400,$03C7,$0390,$035D,$032D,$02FF,$02D4,$02AB
	dw $0285,$0261,$023F,$021E,$0200,$01E3,$01C8,$01AF
	dw $0196,$0180,$016A,$0156,$0143,$0130,$011F,$010F
	dw $0100,$00F2,$00E4,$00D7,$00CB,$00C0,$00B5,$00AB
	dw $00A1,$0098,$0090,$0088,$0080,$0079,$0072,$006C
	dw $0066,$0060,$005B,$0055,$0051,$004C,$0048,$0044
	dw $0040,$003C,$0039,$0036,$0033,$0030,$002D,$002B
	dw $0028,$0026,$0024,$0022,$0020,$001E,$001D,$001B
	dw $0019,$0018,$0017,$0015,$0014,$0013,$0012,$0011
	dw $0010


;compiled music data

musicData1:
	db $37,$18,$18
	db $25,$18,$1d
	db $12,$18,$1c
	db $25,$18,$1d
	db $12,$18,$21
	db $25,$16,$1f
	db $12,$16,$1d
	db $37,$18,$1f
	db $25,$1d,$1d
	db $12,$18,$1c
	db $25,$18,$29
	db $12,$18,$21
	db $25,$16,$1f
	db $12,$16,$1d
	db $37,$18,$18
	db $25,$18,$1d
	db $12,$18,$1c
	db $25,$18,$1d
	db $12,$18,$21
	db $25,$16,$1f
	db $12,$16,$1d
	db $df,$18,$1f
	db $37,$18,$18
	db $25,$18,$1d
	db $12,$18,$1c
	db $25,$18,$1d
	db $12,$18,$21
	db $25,$16,$1f
	db $12,$16,$1d
	db $37,$18,$1f
	db $25,$1d,$1d
	db $12,$18,$1c
	db $25,$18,$29
	db $12,$18,$21
	db $25,$16,$1f
	db $12,$16,$1d
	db $37,$18,$18
	db $25,$18,$1d
	db $12,$18,$1c
	db $25,$18,$1d
	db $12,$18,$21
	db $25,$16,$1f
	db $12,$16,$1d
	db $df,$18,$1f
	db $25,$8c,$0c
	db $12,$18,$98
	db $25,$1a,$1a
	db $37,$98,$1c
	db $12,$9a,$1f
	db $25,$18,$9f
	db $12,$17,$9c
	db $25,$95,$18
	db $12,$17,$9c
	db $25,$18,$18
	db $37,$9a,$1f
	db $12,$97,$17
	db $25,$13,$93
	db $12,$13,$93
	db $25,$91,$18
	db $12,$18,$a1
	db $25,$18,$21
	db $37,$9d,$21
	db $12,$98,$21
	db $25,$18,$98
	db $12,$18,$98
	db $25,$13,$9a
	db $12,$1a,$a3
	db $25,$1f,$a3
	db $12,$23,$a3
	db $25,$1f,$9f
	db $12,$1a,$a3
	db $25,$17,$97
	db $12,$1a,$a3
	db $25,$98,$1f
	db $12,$18,$9c
	db $25,$1a,$1f
	db $37,$9c,$1c
	db $12,$9a,$1f
	db $25,$18,$9f
	db $12,$17,$9c
	db $25,$95,$18
	db $12,$17,$9c
	db $25,$18,$18
	db $37,$9f,$1f
	db $12,$97,$17
	db $25,$13,$93
	db $12,$13,$93
	db $25,$91,$18
	db $12,$18,$a1
	db $25,$18,$21
	db $37,$a1,$21
	db $12,$98,$21
	db $25,$18,$98
	db $12,$18,$98
	db $25,$93,$18
	db $12,$93,$17
	db $25,$13,$93
	db $12,$93,$17
	db $25,$9f,$1f
	db $12,$9a,$23
	db $25,$23,$a3
	db $12,$9a,$23
	db $25,$a4,$24
	db $12,$90,$10
	db $25,$1d,$98
	db $37,$a4,$24
	db $12,$98,$1f
	db $25,$1a,$9f
	db $12,$1a,$9a
	db $25,$9f,$1f
	db $12,$9a,$1f
	db $25,$1d,$9d
	db $12,$91,$11
	db $25,$1d,$a1
	db $12,$21,$a1
	db $25,$1f,$a3
	db $12,$13,$93
	db $25,$a4,$2b
	db $12,$90,$10
	db $25,$18,$9d
	db $37,$a4,$2b
	db $12,$9c,$1c
	db $25,$1a,$9f
	db $12,$a1,$21
	db $25,$9f,$1f
	db $12,$9a,$1f
	db $12,$1d,$9d
	db $12,$1c,$1c
	db $12,$9a,$1a
	db $6f,$93,$18
	db $25,$9f,$24
	db $12,$90,$10
	db $25,$18,$9d
	db $37,$9f,$24
	db $12,$98,$1f
	db $25,$1a,$9f
	db $12,$9a,$1a
	db $25,$9f,$1f
	db $12,$1a,$9f
	db $25,$1d,$9d
	db $12,$11,$91
	db $25,$1d,$a1
	db $12,$21,$a1
	db $25,$1f,$a3
	db $12,$13,$93
	db $25,$9f,$24
	db $12,$90,$10
	db $25,$18,$9d
	db $37,$9f,$24
	db $12,$9c,$1c
	db $25,$1a,$9f
	db $12,$a1,$21
	db $25,$9f,$1f
	db $12,$9a,$1f
	db $12,$1d,$9d
	db $12,$1c,$1c
	db $12,$9a,$1a
	db $12,$1f,$98
	db $12,$1f,$98
	db $12,$1f,$98
	db $12,$1f,$98
	db $12,$1f,$98
	db $12,$1f,$98
	db $25,$8c,$0c
	db $12,$18,$98
	db $25,$1a,$1a
	db $37,$98,$1c
	db $12,$9a,$1f
	db $25,$18,$9f
	db $12,$17,$9c
	db $25,$95,$18
	db $12,$17,$9c
	db $25,$18,$18
	db $37,$9a,$1f
	db $12,$97,$17
	db $25,$13,$93
	db $12,$13,$93
	db $25,$91,$18
	db $12,$18,$a1
	db $25,$18,$21
	db $37,$9d,$21
	db $12,$98,$21
	db $25,$18,$98
	db $12,$18,$98
	db $25,$13,$9a
	db $12,$1a,$a3
	db $25,$1f,$a3
	db $12,$23,$a3
	db $25,$1f,$9f
	db $12,$1a,$a3
	db $25,$17,$97
	db $12,$1a,$a3
	db $25,$98,$1f
	db $12,$18,$9c
	db $25,$1a,$1f
	db $37,$9c,$1c
	db $12,$9a,$1f
	db $25,$18,$9f
	db $12,$17,$9c
	db $25,$95,$18
	db $12,$17,$9c
	db $25,$18,$18
	db $37,$9f,$1f
	db $12,$97,$17
	db $25,$13,$93
	db $12,$13,$93
	db $25,$91,$18
	db $12,$18,$a1
	db $25,$18,$21
	db $37,$a1,$21
	db $12,$98,$21
	db $25,$18,$98
	db $12,$18,$98
	db $25,$93,$18
	db $12,$93,$17
	db $25,$13,$93
	db $12,$93,$17
	db $25,$9f,$1f
	db $12,$9a,$23
	db $25,$23,$a3
	db $12,$9a,$23
	db $37,$98,$18
	db $25,$18,$9d
	db $12,$98,$1c
	db $25,$98,$1d
	db $12,$18,$21
	db $25,$16,$9f
	db $12,$96,$1d
	db $37,$98,$1f
	db $25,$1d,$9d
	db $12,$98,$1c
	db $25,$18,$a9
	db $12,$18,$a1
	db $25,$16,$9f
	db $12,$16,$9d
	db $37,$98,$18
	db $25,$18,$9d
	db $12,$98,$1c
	db $25,$98,$1d
	db $12,$18,$a1
	db $25,$16,$9f
	db $12,$16,$9d
	db $df,$18,$9f
	db $37,$24,$a4
	db $25,$a4,$1d
	db $12,$1d,$a1
	db $25,$1f,$a4
	db $12,$24,$2b
	db $25,$a2,$1f
	db $12,$22,$9f
	db $37,$24,$a4
	db $25,$98,$1d
	db $12,$1d,$a1
	db $25,$18,$98
	db $12,$1d,$24
	db $25,$22,$9f
	db $12,$22,$9d
	db $37,$24,$a4
	db $25,$9d,$21
	db $12,$22,$a6
	db $25,$22,$a6
	db $12,$21,$a1
	db $25,$22,$9f
	db $12,$22,$9d
	db $df,$24,$ab
	db $25,$8c,$0c
	db $12,$18,$98
	db $25,$1a,$1a
	db $37,$98,$1c
	db $12,$9a,$1f
	db $25,$18,$9f
	db $12,$17,$9c
	db $25,$95,$18
	db $12,$17,$9c
	db $25,$18,$18
	db $37,$9a,$1f
	db $12,$97,$17
	db $25,$13,$93
	db $12,$13,$93
	db $25,$91,$18
	db $12,$18,$a1
	db $25,$18,$21
	db $37,$9d,$21
	db $12,$98,$21
	db $25,$18,$98
	db $12,$18,$98
	db $25,$13,$9a
	db $12,$1a,$a3
	db $25,$1f,$a3
	db $12,$23,$a3
	db $25,$1f,$9f
	db $12,$1a,$a3
	db $25,$17,$97
	db $12,$1a,$a3
	db $25,$98,$1f
	db $12,$18,$9c
	db $25,$1a,$1f
	db $37,$9c,$1c
	db $12,$9a,$1f
	db $25,$18,$9f
	db $12,$17,$9c
	db $25,$95,$18
	db $12,$17,$9c
	db $25,$18,$18
	db $37,$9f,$1f
	db $12,$97,$17
	db $25,$13,$93
	db $12,$13,$93
	db $25,$91,$18
	db $12,$18,$a1
	db $25,$18,$21
	db $37,$a1,$21
	db $12,$98,$21
	db $25,$18,$98
	db $12,$18,$98
	db $25,$93,$18
	db $12,$93,$17
	db $25,$13,$93
	db $12,$93,$17
	db $25,$9f,$1f
	db $12,$9a,$23
	db $25,$23,$a3
	db $12,$9a,$23
	db $25,$a4,$24
	db $12,$18,$98
	db $25,$26,$26
	db $37,$a4,$2b
	db $12,$9f,$1f
	db $25,$18,$9f
	db $12,$1c,$9c
	db $25,$a1,$21
	db $12,$17,$97
	db $25,$1c,$1c
	db $82,$15,$1c
	db $25,$9d,$1d
	db $12,$18,$a1
	db $25,$1d,$1d
	db $37,$a1,$21
	db $12,$98,$21
	db $37,$98,$18
	db $25,$93,$1a
	db $12,$1a,$9a
	db $25,$1f,$a3
	db $12,$23,$a3
	db $6f,$1a,$a3
	db $df,$98,$1f
	db $ff

musicData2:
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1f,$1a
	db $12,$1f,$1a
	db $12,$1e,$19
	db $12,$1e,$19
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1e,$12
	db $12,$12,$12
	db $12,$1f,$13
	db $12,$13,$13
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1f,$1a
	db $12,$1f,$1a
	db $12,$1e,$19
	db $12,$1e,$19
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$12,$12
	db $12,$12,$12
	db $12,$12,$12
	db $12,$12,$12
	db $12,$9c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$9c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$9c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$9f,$1a
	db $12,$1f,$1a
	db $12,$1e,$19
	db $12,$1e,$19
	db $12,$9c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$9c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$9c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1e,$92
	db $12,$92,$12
	db $12,$1f,$93
	db $12,$93,$13
	db $12,$9c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$9c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$9c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$9f,$1a
	db $12,$1f,$1a
	db $12,$1e,$19
	db $12,$1e,$19
	db $12,$9c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$9c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1a,$15
	db $12,$9c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$1c,$17
	db $12,$15,$92
	db $12,$15,$12
	db $12,$15,$12
	db $12,$15,$12
	db $12,$9c,$10
	db $12,$1c,$10
	db $12,$1c,$1c
	db $12,$9a,$10
	db $12,$1c,$90
	db $12,$1c,$10
	db $12,$9c,$1f
	db $12,$1a,$1e
	db $12,$9c,$10
	db $12,$1c,$10
	db $12,$1c,$1c
	db $12,$9a,$10
	db $12,$1c,$90
	db $12,$1c,$10
	db $12,$9c,$17
	db $12,$1a,$15
	db $12,$98,$0c
	db $12,$18,$0c
	db $12,$18,$0c
	db $12,$98,$0c
	db $12,$18,$9f
	db $12,$18,$1e
	db $12,$97,$1c
	db $12,$18,$1a
	db $12,$9a,$1e
	db $12,$1a,$1e
	db $12,$1a,$1f
	db $12,$9a,$1f
	db $12,$1a,$9e
	db $12,$1a,$1e
	db $12,$18,$98
	db $12,$1a,$9a
	db $12,$9c,$10
	db $12,$1c,$10
	db $12,$1c,$1c
	db $12,$9a,$10
	db $12,$1c,$90
	db $12,$1c,$10
	db $12,$9c,$1f
	db $12,$1a,$1e
	db $12,$9c,$10
	db $12,$1c,$10
	db $12,$1c,$1c
	db $12,$9a,$10
	db $12,$1c,$90
	db $12,$1c,$10
	db $12,$9c,$17
	db $12,$1a,$15
	db $12,$98,$0c
	db $12,$18,$0c
	db $12,$18,$0c
	db $12,$98,$0c
	db $12,$18,$9f
	db $12,$18,$1e
	db $12,$97,$1c
	db $12,$18,$1a
	db $12,$9a,$1e
	db $12,$1a,$1e
	db $12,$1a,$1f
	db $12,$9a,$1f
	db $12,$1a,$9e
	db $12,$1a,$1e
	db $12,$18,$98
	db $12,$1a,$9a
	db $12,$98,$0c
	db $12,$98,$0c
	db $12,$18,$9f
	db $12,$98,$1f
	db $12,$18,$0c
	db $12,$98,$0c
	db $12,$18,$9f
	db $12,$18,$1f
	db $12,$9a,$1e
	db $12,$9a,$0e
	db $12,$1a,$9e
	db $12,$9a,$1e
	db $12,$1a,$0e
	db $12,$9a,$0e
	db $12,$1a,$9c
	db $12,$1a,$1c
	db $12,$9c,$1f
	db $12,$9c,$1e
	db $12,$1c,$9a
	db $12,$9c,$1f
	db $12,$1c,$1e
	db $12,$9c,$1a
	db $12,$1a,$9f
	db $12,$1a,$1e
	db $12,$9c,$1f
	db $12,$9c,$1e
	db $12,$1c,$9a
	db $12,$9c,$1f
	db $12,$1c,$1e
	db $12,$9c,$1a
	db $12,$1a,$9f
	db $12,$1a,$9e
	db $12,$98,$0c
	db $12,$98,$0c
	db $12,$18,$9f
	db $12,$98,$1f
	db $12,$18,$0c
	db $12,$98,$0c
	db $12,$18,$9f
	db $12,$18,$1f
	db $12,$9a,$1e
	db $12,$9a,$0e
	db $12,$1a,$9f
	db $12,$9a,$1f
	db $12,$1a,$0e
	db $12,$9a,$0e
	db $12,$1a,$9e
	db $12,$1a,$1e
	db $12,$9c,$1f
	db $12,$9c,$1e
	db $12,$1c,$9a
	db $12,$9c,$1f
	db $12,$1c,$1e
	db $12,$9c,$1a
	db $12,$1a,$9f
	db $12,$1a,$1e
	db $12,$9c,$1a
	db $12,$9c,$1f
	db $12,$1c,$9e
	db $12,$9c,$1a
	db $25,$1c,$9f
	db $25,$1c,$1f
	db $25,$1c,$1f
	db $25,$1c,$1f
	db $12,$90,$17
	db $12,$10,$17
	db $12,$1c,$17
	db $12,$10,$17
	db $12,$10,$23
	db $12,$10,$23
	db $12,$1c,$17
	db $12,$10,$17
	db $12,$10,$21
	db $12,$10,$21
	db $12,$1c,$23
	db $12,$10,$23
	db $12,$10,$17
	db $12,$10,$17
	db $12,$1c,$17
	db $12,$10,$17
	db $12,$8e,$1e
	db $12,$0e,$1e
	db $12,$1a,$1e
	db $12,$0e,$1e
	db $12,$0e,$2a
	db $12,$0e,$2a
	db $12,$1a,$1e
	db $12,$0e,$1e
	db $12,$0e,$28
	db $12,$0e,$28
	db $12,$1a,$2a
	db $12,$0e,$2a
	db $12,$0e,$1e
	db $12,$0e,$1e
	db $12,$9a,$1e
	db $12,$0e,$1e
	db $12,$8c,$1c
	db $12,$0c,$1c
	db $12,$18,$1c
	db $12,$0c,$1c
	db $12,$0c,$28
	db $12,$0c,$28
	db $12,$18,$1c
	db $12,$0c,$1c
	db $12,$0c,$2b
	db $12,$0c,$2b
	db $12,$18,$28
	db $12,$0c,$28
	db $12,$0c,$1c
	db $12,$0c,$1c
	db $12,$18,$1c
	db $12,$0c,$1c
	db $12,$92,$17
	db $12,$12,$17
	db $12,$1e,$17
	db $12,$12,$17
	db $12,$12,$23
	db $12,$12,$23
	db $12,$1e,$17
	db $12,$12,$17
	db $12,$92,$21
	db $12,$12,$21
	db $12,$9e,$23
	db $12,$12,$23
	db $12,$12,$ad
	db $12,$12,$2d
	db $12,$9e,$2f
	db $12,$12,$2f
	db $12,$90,$17
	db $12,$10,$17
	db $12,$1c,$97
	db $12,$9c,$17
	db $12,$10,$23
	db $12,$90,$23
	db $12,$1c,$97
	db $12,$10,$17
	db $12,$90,$21
	db $12,$10,$21
	db $12,$1c,$a3
	db $12,$9c,$23
	db $12,$10,$17
	db $12,$90,$17
	db $12,$1c,$97
	db $12,$9c,$17
	db $12,$8e,$1e
	db $12,$0e,$1e
	db $12,$1a,$9e
	db $12,$9a,$1e
	db $12,$0e,$2a
	db $12,$8e,$2a
	db $12,$1a,$9e
	db $12,$0e,$9e
	db $12,$8e,$28
	db $12,$0e,$28
	db $12,$1a,$aa
	db $12,$9a,$2a
	db $12,$0e,$9e
	db $12,$0e,$9e
	db $12,$1a,$9e
	db $12,$1a,$9e
	db $12,$8c,$1c
	db $12,$0c,$1c
	db $12,$18,$9c
	db $12,$98,$1c
	db $12,$0c,$28
	db $12,$8c,$28
	db $12,$18,$9c
	db $12,$0c,$1c
	db $12,$8c,$2b
	db $12,$0c,$2b
	db $12,$18,$a8
	db $12,$98,$28
	db $12,$0c,$1c
	db $12,$8c,$1c
	db $12,$18,$9c
	db $12,$98,$1c
	db $12,$92,$17
	db $12,$12,$17
	db $12,$1e,$97
	db $12,$9e,$17
	db $12,$12,$23
	db $12,$92,$23
	db $12,$1e,$97
	db $12,$12,$17
	db $12,$92,$21
	db $12,$12,$21
	db $12,$1e,$23
	db $12,$1e,$23
	db $12,$12,$2d
	db $12,$12,$2d
	db $12,$1e,$2f
	db $12,$1e,$2f
	db $12,$98,$0c
	db $12,$98,$0c
	db $12,$18,$9f
	db $12,$98,$1f
	db $12,$18,$0c
	db $12,$98,$0c
	db $12,$18,$9f
	db $12,$18,$1f
	db $12,$9a,$1e
	db $12,$9a,$0e
	db $12,$1a,$9e
	db $12,$9a,$1e
	db $12,$1a,$0e
	db $12,$9a,$0e
	db $12,$1a,$9c
	db $12,$1a,$1c
	db $12,$9c,$1f
	db $12,$9c,$1e
	db $12,$1c,$9a
	db $12,$9c,$1f
	db $12,$1c,$1e
	db $12,$9c,$1a
	db $12,$1a,$9f
	db $12,$1a,$1e
	db $12,$9c,$1f
	db $12,$9c,$1e
	db $12,$1c,$9a
	db $12,$9c,$1f
	db $12,$1c,$1e
	db $12,$9c,$1a
	db $12,$1a,$9f
	db $12,$1a,$9e
	db $12,$98,$0c
	db $12,$98,$0c
	db $12,$18,$9f
	db $12,$98,$1f
	db $12,$18,$0c
	db $12,$98,$0c
	db $12,$18,$9f
	db $12,$18,$1f
	db $12,$9a,$1e
	db $12,$9a,$0e
	db $12,$1a,$9e
	db $12,$9a,$1e
	db $12,$1a,$0e
	db $12,$9a,$0e
	db $12,$1a,$9c
	db $12,$1a,$1c
	db $12,$a8,$1f
	db $12,$a8,$1e
	db $12,$26,$9a
	db $12,$a8,$1f
	db $12,$a8,$1e
	db $12,$a6,$1a
	db $12,$28,$9f
	db $12,$a8,$1e
	db $12,$2b,$9f
	db $12,$aa,$1e
	db $12,$26,$9a
	db $12,$ab,$1f
	db $12,$2a,$9e
	db $12,$26,$9a
	db $12,$2b,$9f
	db $12,$2a,$9e
	db $12,$a4,$0c
	db $12,$a4,$0c
	db $12,$24,$9f
	db $12,$a4,$1f
	db $12,$24,$0c
	db $12,$a4,$0c
	db $12,$24,$9f
	db $12,$24,$1f
	db $12,$a6,$1e
	db $12,$a6,$0e
	db $12,$26,$9e
	db $12,$a6,$1e
	db $12,$1a,$0e
	db $12,$9a,$0e
	db $12,$26,$9c
	db $12,$26,$1c
	db $12,$1f,$9f
	db $12,$1c,$9e
	db $12,$9a,$1a
	db $12,$9c,$1f
	db $12,$1e,$9e
	db $12,$1c,$9a
	db $12,$9f,$1f
	db $12,$9a,$1e
	db $12,$1f,$9f
	db $12,$9c,$1e
	db $12,$1a,$9a
	db $12,$9c,$1f
	db $12,$1e,$9e
	db $12,$1c,$9a
	db $12,$9f,$1f
	db $12,$9a,$1e
	db $12,$a4,$0c
	db $12,$a4,$0c
	db $12,$24,$9f
	db $12,$a4,$1f
	db $12,$24,$0c
	db $12,$a4,$0c
	db $12,$24,$9f
	db $12,$24,$1f
	db $12,$a6,$1e
	db $12,$a6,$0e
	db $12,$26,$9f
	db $12,$a6,$1f
	db $12,$1a,$0e
	db $12,$9a,$0e
	db $12,$26,$9e
	db $12,$26,$1e
	db $12,$2b,$9f
	db $12,$9e,$1e
	db $12,$26,$9a
	db $12,$9f,$2b
	db $12,$1e,$b6
	db $12,$9a,$32
	db $12,$2b,$9f
	db $12,$9e,$1e
	db $12,$26,$9a
	db $12,$1f,$ab
	db $12,$9e,$36
	db $12,$9a,$32
	db $04,$1c,$9f
	db $04,$1c,$9f
	db $04,$1c,$9f
	db $04,$1c,$9f
	db $09,$1c,$1f
	db $09,$1c,$1f
	db $09,$1c,$1f
	db $09,$1c,$1f
	db $12,$1c,$1f
	db $12,$1c,$1f
	db $12,$1c,$1f
	db $12,$1c,$1f
	db $25,$1c,$1f
	db $25,$1c,$1f
	db $25,$1c,$1f
	db $ff

