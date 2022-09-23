; ZX10 Engine for the VZ.         20/April/2019.  Bushy.
;
;
;4-channel music generator ZX-10
;Original code JDeak (c)1989 Bytepack Bratislava
;Modified 1tracker version by Shiru 04'12
;
; MUSIC BOX - 4 channel, for the VZ.   Bushy. March 2019.
;
;
; ZX10-1	 ZX10 Theme
; ZX10-2	 WARPZONE
; ZX10-3	 ZX-10 Intro.
; ZX10-4	SONG : DOOM LEVEL. By Utz.
; ZX10-5	SONG : GALAXY. By Utz.
;
;
;
;
; Assemble:
	ORG	$100


start:

;	ld 	hl,musicData1
;	ld 	hl,musicData2
	ld 	hl,musicData3
;	ld 	hl,musicData4
;	ld 	hl,musicData5



begin:	call 	play
exit:	ret

play:	di
	ld 	a,(hl)
	inc 	hl
	ld 	(speed+1),a
	dec 	a
	ld 	(speedCnt),a
	xor 	a
	ld 	e,(hl)
	inc 	hl
	ld 	d,(hl)
	inc 	hl
	ld 	(ch1order),de
	ld 	(de),a
	ld 	(sc1+3),a
	ld 	e,(hl)
	inc 	hl
	ld 	d,(hl)
	inc 	hl
	ld 	(ch2order),de
	ld 	(de),a
	ld 	(sc2+3),a
	ld 	e,(hl)
	inc 	hl
	ld 	d,(hl)
	inc 	hl
	ld 	(ch3order),de
	ld 	(de),a
	ld 	(sc3+3),a
	ld 	e,(hl)
	inc 	hl
	ld 	d,(hl)
	ld 	(ch4order),de
	ld 	(de),a
	ld 	(sc4+3),a
	ld 	hl,adst
	ld 	de,sx
	ld 	bc,$0400
init0:	ld 	(hl),c
	inc 	hl
	ld 	(hl),e
	inc 	hl
	ld 	(hl),d
	inc 	hl
	djnz 	init0

playRow:ld   	ix,sc1
	ld   	hl,adst
	ld   	de,8
	ld   	b,4
decay0:	ld   	a,(hl)
	or   	a
	jr   	z,decay1
	dec  	(hl)
	sla  	(ix+3)
	set  	6,(ix+3)
decay1:	add 	ix,de
	inc  	hl
	inc  	hl
	inc  	hl
	djnz 	decay0
	ld 	a,(speedCnt)
	inc 	a
speed:	cp 	0
	jr 	nz,noNextRow4
	ld   	ix,sc1
	ld   	hl,adst
	ld   	b,4
nextRow0:
	push 	hl
	inc  	hl
	ld   	e,(hl)
	inc  	hl
	ld   	d,(hl)
	ld   	a,(de)
	inc  	de
	ld   	(hl),d
	dec  	hl
	ld   	(hl),e
	cp   	$e0
	jp 	nz,noNextOrder
	ld   	de,12
	add  	hl,de
	ld   	c,(hl)
	inc  	hl
	ld   	a,(hl)
	or 	a
	sbc 	hl,de
	push 	hl
	ld 	l,c
	ld 	h,a
	ld   	a,(hl)
	inc  	hl
	cp   	(hl)
	dec  	hl
	jr   	nz,porder1
	xor  	a			;loop channel
	ld   	(hl),a
	jr   	porder2
	pop 	hl			;exit at end of the song
	pop 	hl
	jp 	keyPressed
noNextRow4:
	jp 	noNextRow
porder1:inc  	(hl)
porder2:inc  	a
	ex   	de,hl
	ld   	l,a
	ld   	h,0
	add  	hl,hl
	add  	hl,de
	ld   	e,(hl)
	inc  	hl
	ld   	d,(hl)
	pop  	hl
	ld   	a,(de)
	inc  	de
	ld   	(hl),d
	dec  	hl
	ld   	(hl),e
noNextOrder:
	ld   	c,a
	and  	31
	cp 	2
	jr 	nc,nextRow2
	or 	a
	jr 	nz,nextRow1
	pop 	hl
	jr 	nextRow4
nextRow1:
	set  	6,(ix+2)
	jr 	nextRow3
nextRow2:
	res  	6,(ix+2)
nextRow3:
	ld   	e,a
	ld   	d,0
	ld   	hl,frq			;note
	add  	hl,de
	ld   	a,(hl)
	ld   	(ix+1),a
	ld   	a,c			;duration
	rlca
	rlca
	rlca
	rlca
	and  	14
	inc  	a
	pop  	hl
	ld   	(hl),a
	ld   	(ix+3),$1f
nextRow4:
	ld   	de,8
	add  	ix,de
	inc  	hl
	inc  	hl
	inc  	hl
	djnz 	nextRow0

	xor 	a
noNextRow:
	ld 	(speedCnt),a

	xor 	a
; ----------------------------------	Original code

	
no_key:	ld   	hl,256
sc:	exx
sc0:	dec  	c
	jp   	nz,s1
sc1:	ld   	c,0
	ld   	l,0
l1:	dec  	b
	jp   	nz,s2
sc2:	ld   	b,0
	ld   	l,0
l2:	dec  	e
	jp   	nz,s3
sc3:	ld   	e,0
	ld   	l,0
l3:	dec  	d
	jp   	nz,s4
sc4:	ld   	d,0
	ld   	l,0
l4:	ld   	a,l				;sound loop
	and 	64
	sla  	l
	push 	af
	bit 	6,a
	jr 	z,$+$04
	ld	a, 64
toggle1:
	xor	64
	and 	64
	out	(2), a
	pop 	af
	exx
	dec  	hl
	ld   	a,h
	or   	l
	exx
	jp   	nz,sc0

	push 	af
	bit 	6,a
	jr 	z,$+$04
	ld	a, 32

toggle2:
	xor	64
	and	64
	out	(2), a
	pop 	af

	exx
	jp   playRow

s1:	nop
	jp   l1
s2:	nop
	jp   l2
s3:	nop
	jp   l3
s4:	nop
	jp   l4


keyPressed:
	exx
	ei
	ret


frq:	db   0,255,241,227,214,202,191,180
	db 170,161,152,143,135,127,120,114
	db 107,101, 95, 90, 85, 80, 76, 71
	db  67, 63, 60, 57, 53, 50, 47, 45

sx:	db   $e0

adst:	db   0
	dw   0
	db   0
	dw   0
	db   0
	dw   0
	db   0
	dw   0
	db   0
ch1order:
	dw   0
	db   0
ch2order:
	dw   0
	db   0
ch3order:
	dw   0
	db   0
ch4order:
	dw   0

speedCnt:
	db 	0
toggleg2:
	db	0



; -----------------------------------------
;  ZX-10 Intro.
; -----------------------------------------
musicData3
	db $09
	dw md3order0
	dw md3order1
	dw md3order2
	dw md3order3
	dw md3order2
	dw md3order3
	dw md3order1
	dw md3order2
	dw md3order3

md3order0
	dw $0400
	dw pattern0
	dw pattern0
	dw pattern0
	dw pattern0
md3order1
	dw $0400
	dw pattern1
	dw pattern2
	dw pattern3
	dw pattern2
md3order2
	dw $0400
	dw pattern4
	dw pattern1
	dw pattern4
	dw pattern4
md3order3
	dw $0400
	dw pattern5
	dw pattern6
	dw pattern5
	dw pattern6

pattern0	db $07,$01,$13,$01,$07,$01,$13,$01,$e0
pattern1	db $00,$00,$00,$00,$00,$00,$00,$00,$e0
pattern2	db $00,$00,$56,$56,$01,$56,$56,$01,$e0
pattern3	db $56,$01,$00,$00,$00,$00,$00,$00,$e0
pattern4	db $00,$00,$5a,$5a,$01,$5a,$5a,$01,$e0
pattern5	db $33,$01,$36,$01,$3a,$01,$3d,$01,$e0
pattern6	db $3f,$01,$3d,$01,$3a,$01,$36,$01,$e0


end

