

	org $100

	

begin

	ld hl,music_data
	call play
	ret
	
	

;povver
;experimental beeper engine with phase offset volume control
;by utz 11'2016

play

	di
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld (mLoopVar),de
	ld (seqpntr),hl
	exx
	ld b,0			;timer lo
	push hl			;preserve HL' for return to BASIC
	ld (oldSP),sp
	

;*******************************************************************************
rdseq
seqpntr equ $+1
	ld sp,0
	xor a
	pop de			;pattern pointer to DE
	or d
	ld (seqpntr),sp
	jr nz,rdptn0
	
mLoopVar equ $+1
	ld sp,0			;get loop point		;comment out to disable looping
	jr rdseq+3					;comment out to disable looping

;*******************************************************************************
exit
oldSP equ $+1
	ld sp,0
	pop hl
	exx
	ei
	ret

;*******************************************************************************
rdptn0
	ld (ptnpntr),de

readPtn


ptnpntr equ $+1
	ld sp,0	
	
	pop af			;speed + ctrl
	jr z,rdseq
	
	ld c,a			;speed
	
	jr c,noUpd1
	
	ex af,af'
	
	ld hl,0			;reset counter
	
	pop de			;freq+offset ch1+env toggle
	ld a,d
	rlca	
	jr nc,_noEnv0		;if bit 15 is set
	
	ld h,$24		;enable envelope
_noEnv0
	rlca			;bit 14-11 is phase offset
	rlca
	rlca
	rlca
	and $f
	jr z,_skip0		;if phase offset != 0
	
	inc a			;inc phase offset by 1 (so $f -> $10 = full phase inversion)
_skip0
	ld iyh,a		;set phase offset
	
	ld a,d			;mask phase offset from frequency divider
	and $7
	ld d,a
	
	ld a,h			;set envelope
	ld (env1),a
	ld h,0
	
	ex af,af'
	
noUpd1
	jp pe,noUpd2
	
	exx
	ex af,af'
	
	ld hl,0
	
	pop bc
	ld a,b
	rlca
	jr nc,_noEnv1
	
	ld h,$24
_noEnv1
	rlca
	rlca
	rlca
	rlca
	and $f
	jr z,_skip1
	
	inc a
_skip1
	ld ixh,a
	
	ld a,b
	and $7
	ld b,a
	
	ld a,h
	ld (env2),a
	ld h,0
	
	ex af,af'
	exx
	
noUpd2
	jp m,noUpd3
	
	exx
	
	ld iyl,0
	pop de
	ld a,d
	rlca
	jr nc,_noEnv2
	ld iyl,$2c
_noEnv2
	rlca
	rlca
	rlca
	rlca
	and $f
	jr z,_skip2
	
	inc a
_skip2
	ld ixl,a
	
	ld a,d
	and $7
	ld d,a
	ld (div3),de
	
	ld a,iyl
	ld (env3),a
	
	ld de,0
	
	exx
	
noUpd3
	pop af
	jp c,drum1
	jp pe,drum2
	
drumRet
	jr z,enableNoise
	xor a
	ld (pNoise),a
	ld (pNoise+1),a
	jp nDone
	
enableNoise
	ld a,$cb
	ld (pNoise),a
	ld a,4
	ld (pNoise+1),a

nDone
	ld (ptnpntr),sp
div3 equ $+1
	ld sp,0
	
;*******************************************************************************
playNote
	add hl,de		;11		;ch1
	ld a,h			;4
	and $40			;7 		;+3 fix
	out ($2),a		;11__40 (ch3b)

	


pNoise
	ds 2			;8		;noise switch, cb 04 = rlc h

	add a,iyh		;8		;iyh = phase offset
	
	exx			;4
	
	or a			;4		;timing
	ret c			;5		;timing
	
	and $40			;7 		;+3 fix
	out ($2),a		;11__40 (ch1a)

	
	add hl,bc		;11		;ch2
	ld a,h			;4
	
	ds 2			;8		;timing
	inc bc			;6		;timing
	
	and $40			;7 		;+3 fix
	out ($2),a		;11__40 (ch1b)



	add a,ixh		;8		
	
	ex de,hl		;4
	
	or a			;4		;timing
	ret c			;5		;timing

	and $40			;7 		;+3 fix
	out ($2),a		;11__32 (ch2a)

	

	
	dec bc			;6		;timing
	
	add hl,sp		;11		;ch3
	ld a,h			;4
	
	and $40			;7 		;+3 fix
	out ($2),a		;11__32 (ch2b)
	add a,ixl		;8
	ex de,hl		;4
	exx			;4
	or a			;4		;timing
	ret c			;5		;timing
	nop			;4		;timing
	and $40			;7 		;+3 fix
	out ($2),a		;11__40 (ch3a)
	dec b			;4
	jp nz,playNote		;10
				;224
	db $fd	
env1
	nop					;fd 24 = inc iyh
						;fd 25 = dec ixh

	db $dd
env2
	nop					;dd 24 = inc ixh
						;dd 25 = dec ixh
	
	db $dd
env3
	nop					;fd 2c = inc ixl
						;fd 2d = dec ixl
	
	dec c
	jp nz,playNote
	
	jp readPtn

;*******************************************************************************
drum1						;kick

	
	ld (deRest),de
	ld (bcRest),bc
	ld (hlRest),hl

	ld d,a					;A = start_pitch<<1
	ld e,b					;B = 0
	ld h,b
	ld l,b
	
	ex af,af'
	
	srl d					;set start pitch
	rl e
	
	ld c,$3					;length
	
xlllp
	add hl,de
	jr c,_noUpd
	ld a,e
_slideSpeed equ $+1
	sub $10					;speed
	ld e,a
	sbc a,a
	add a,d
	ld d,a
_noUpd
	ld a,h
	and $40					;border
	out ($2),a
	djnz xlllp
	dec c
	jr nz,xlllp

						;45680 (/224 = 203.9)
deRest equ $+1
	ld de,0
	ld a,$34				;correct speed offset

drumEnd
hlRest equ $+1
	ld hl,0
bcRest equ $+1
	ld bc,0
	ld b,a
	ex af,af'
	jp drumRet				
drum2							;noise
	ld (hlRest),hl
	ld (bcRest),bc
	ld b,a
	ex af,af'
	ld a,b
	ld hl,1					;$1 (snare) <- 1011 -> $1237 (hat)
	rrca
	jr c,setVol
	ld hl,$1237
setVol	and $7f
	ld (dvol),a	
	ld bc,$ff03				;length
sloop
	add hl,hl		;11
	sbc a,a			;4
	xor l			;4
	ld l,a			;4

dvol equ $+1	
	cp $80			;7		;volume
	sbc a,a			;4
	
	and $40			;7		;border
	out ($2),a		;11


	djnz sloop		;13/7 : 65 * 256 * B : B=3 -> 49920 (/224 = 222.8)

	dec c			;4
	jr nz,sloop		;12 : (16 - 6) * B : B=3 -> +30
				;			+load/wrap
				;49903 w/ b=$ff (/224 = 222.8)
	ld a,$21				;correct speed offset
	jr drumEnd

	
	
;*******************************************************************************

;compiled music data

music_data
	dw .loop
	dw .pattern1
.loop:
	dw .pattern2
	dw 0
.pattern1
	dw $900,$89,$4000,$801c,$701
	dw $985,0
	dw $984,$112,$2604
	dw $985,0
	dw $904,$ac,$801c,$701
	dw $985,0
	dw $984,$89,$2604
	dw $984,$ac,0
	dw $904,$112,$801c,$701
	dw $985,0
	dw $984,$ac,$2604
	dw $985,0
	dw $904,$89,$801c,$701
	dw $985,0
	dw $984,$112,$2604
	dw $984,$ac,0
	dw $904,$6c,$802b,$701
	dw $985,0
	dw $984,$d9,$2604
	dw $985,0
	dw $904,$81,$802b,$701
	dw $985,0
	dw $984,$6c,$2604
	dw $984,$81,0
	dw $904,$d9,$802b,$701
	dw $985,0
	dw $984,$81,$2604
	dw $985,0
	dw $904,$6c,$802b,$701
	dw $985,0
	dw $984,$d9,$2604
	dw $984,$81,0
	dw $904,$5b,$8026,$701
	dw $985,0
	dw $984,$b7,$2604
	dw $985,0
	dw $904,$73,$8026,$701
	dw $984,$b7,0
	dw $984,$5b,$2604
	dw $984,$73,0
	dw $904,$b7,$8026,$701
	dw $984,$5b,0
	dw $984,$73,$2604
	dw $984,$b7,0
	dw $900,$5b,$4000,$8026,$701
	dw $984,$73,0
	dw $984,$b7,$2604
	dw $984,$73,0
	dw $904,$6c,$802b,$701
	dw $984,$81,0
	dw $984,$99,$2604
	dw $984,$6c,0
	dw $904,$81,$802b,$701
	dw $984,$99,0
	dw $984,$6c,$2604
	dw $984,$81,0
	dw $904,$99,$802b,$701
	dw $984,$6c,0
	dw $984,$81,$2604
	dw $984,$99,0
	dw $904,$6c,$802b,$701
	dw $984,$81,0
	dw $984,$99,$2604
	dw $984,$81,0
	db $40
.pattern2
	dw $900,$89,$4000,$801c,$701
	dw $984,$ac,$2604
	dw $984,$112,$2604
	dw $984,$89,$2604
	dw $904,$ac,$801c,$701
	dw $984,$112,$2604
	dw $984,$89,$2604
	dw $984,$ac,$2604
	dw $904,$112,$801c,$701
	dw $984,$89,$2604
	dw $984,$ac,$2604
	dw $984,$112,$2604
	dw $904,$89,$801c,$701
	dw $984,$ac,$2604
	dw $984,$112,$2604
	dw $984,$ac,$2604
	dw $904,$6c,$802b,$701
	dw $984,$81,$2604
	dw $984,$d9,$2604
	dw $984,$6c,$2604
	dw $904,$81,$802b,$701
	dw $984,$d9,$2604
	dw $984,$6c,$2604
	dw $984,$81,$2604
	dw $904,$d9,$802b,$701
	dw $984,$6c,$2604
	dw $984,$81,$2604
	dw $984,$d9,$2604
	dw $904,$6c,$802b,$701
	dw $984,$81,$2604
	dw $984,$d9,$2604
	dw $984,$81,$2604
	dw $904,$5b,$8026,$701
	dw $984,$73,$2604
	dw $984,$b7,$2604
	dw $984,$5b,$2604
	dw $904,$73,$8026,$701
	dw $984,$b7,$2604
	dw $984,$5b,$2604
	dw $984,$73,$2604
	dw $904,$b7,$8026,$701
	dw $984,$5b,$2604
	dw $984,$73,$2604
	dw $984,$b7,$2604
	dw $900,$5b,$4000,$8026,$701
	dw $984,$73,$2604
	dw $984,$b7,$2604
	dw $984,$73,$2604
	dw $904,$6c,$802b,$701
	dw $984,$81,$2604
	dw $984,$99,$2604
	dw $984,$6c,$2604
	dw $904,$81,$802b,$701
	dw $984,$99,$2604
	dw $984,$6c,$2604
	dw $984,$81,$2604
	dw $904,$99,$802b,$701
	dw $984,$6c,$2604
	dw $984,$81,$2604
	dw $984,$99,$2604
	dw $904,$6c,$802b,$701
	dw $984,$81,$2604
	dw $984,$99,$2604
	dw $984,$81,$2604
	dw $900,$89,$40e6,$801c,$701
	dw $984,$ac,$2604
	dw $980,$112,$40e6,$2604
	dw $984,$89,$2604
	dw $900,$ac,$4102,$801c,$701
	dw $984,$112,$2604
	dw $980,$89,$40e6,$2604
	dw $984,$ac,$2604
	dw $900,$112,$4102,$801c,$701
	dw $984,$89,$2604
	dw $980,$ac,$40ac,$2604
	dw $984,$112,$2604
	dw $900,$89,$4112,$801c,$701
	dw $984,$ac,$2604
	dw $980,$112,$40e6,$2604
	dw $984,$ac,$2604
	dw $900,$6c,$4102,$802b,$701
	dw $984,$81,$2604
	dw $980,$d9,$4102,$2604
	dw $984,$6c,$2604
	dw $900,$81,$4112,$802b,$701
	dw $984,$d9,$2604
	dw $980,$6c,$4102,$2604
	dw $984,$81,$2604
	dw $900,$d9,$4089,$802b,$701
	dw $984,$6c,$2604
	dw $980,$81,$40ac,$2604
	dw $984,$d9,$2604
	dw $900,$6c,$4159,$802b,$701
	dw $984,$81,$2604
	dw $980,$d9,$4102,$2604
	dw $984,$81,$2604
	dw $900,$5b,$40e6,$8026,$701
	dw $984,$73,$2604
	dw $980,$b7,$40b7,$2604
	dw $984,$5b,$2604
	dw $900,$73,$40e6,$8026,$701
	dw $984,$b7,$2604
	dw $980,$5b,$4112,$2604
	dw $984,$73,$2604
	dw $900,$b7,$4099,$8026,$701
	dw $984,$5b,$2604
	dw $980,$73,$40b7,$2604
	dw $984,$b7,$2604
	dw $900,$5b,$4000,$8026,$701
	dw $984,$73,$2604
	dw $980,$b7,$4159,$2604
	dw $984,$73,$2604
	dw $900,$6c,$4133,$802b,$701
	dw $984,$81,$2604
	dw $980,$99,$4159,$2604
	dw $984,$6c,$2604
	dw $900,$81,$4133,$802b,$701
	dw $984,$99,$2604
	dw $980,$6c,$4112,$2604
	dw $984,$81,$2604
	dw $900,$99,$4102,$802b,$701
	dw $984,$6c,$2604
	dw $984,$81,$2604
	dw $984,$99,$2604
	dw $904,$6c,$802b,$701
	dw $984,$81,$2604
	dw $984,$99,$2604
	dw $984,$81,$2604
	db $40
