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

	ld 	hl,musicData1
;	ld 	hl,musicData2
;	ld 	hl,musicData3
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
	set  	4,(ix+3)
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
	set  	4,(ix+2)
	jr 	nextRow3
nextRow2:
	res  	4,(ix+2)
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
	bit 	4,a
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
	bit 	4,a
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





; ===========================
;    ZX-10 THEME MUSIC DATA
; ===========================

musicData1
	db $0a
	dw md1order0
	dw md1order1
	dw md1order2
	dw md1order3

md1order0
	dw $2c00
	dw md1pattern0
	dw md1pattern1
	dw md1pattern2
	dw md1pattern3
	dw md1pattern4
	dw md1pattern5
	dw md1pattern6
	dw md1pattern7
	dw md1pattern8
	dw md1pattern9
	dw md1pattern10
	dw md1pattern11
	dw md1pattern12
	dw md1pattern13
	dw md1pattern14
	dw md1pattern15
	dw md1pattern16
	dw md1pattern17
	dw md1pattern18
	dw md1pattern19
	dw md1pattern20
	dw md1pattern21
	dw md1pattern22
	dw md1pattern23
	dw md1pattern24
	dw md1pattern25
	dw md1pattern26
	dw md1pattern27
	dw md1pattern28
	dw md1pattern29
	dw md1pattern30
	dw md1pattern31
	dw md1pattern32
	dw md1pattern33
	dw md1pattern34
	dw md1pattern35
	dw md1pattern36
	dw md1pattern37
	dw md1pattern38
	dw md1pattern39
	dw md1pattern40
	dw md1pattern41
	dw md1pattern42
	dw md1pattern43
md1order1
	dw $2c00
	dw md1pattern44
	dw md1pattern45
	dw md1pattern46
	dw md1pattern47
	dw md1pattern48
	dw md1pattern49
	dw md1pattern50
	dw md1pattern51
	dw md1pattern52
	dw md1pattern53
	dw md1pattern54
	dw md1pattern55
	dw md1pattern56
	dw md1pattern57
	dw md1pattern58
	dw md1pattern59
	dw md1pattern60
	dw md1pattern61
	dw md1pattern62
	dw md1pattern63
	dw md1pattern64
	dw md1pattern65
	dw md1pattern66
	dw md1pattern67
	dw md1pattern68
	dw md1pattern69
	dw md1pattern70
	dw md1pattern71
	dw md1pattern72
	dw md1pattern73
	dw md1pattern74
	dw md1pattern75
	dw md1pattern76
	dw md1pattern77
	dw md1pattern54
	dw md1pattern78
	dw md1pattern79
	dw md1pattern80
	dw md1pattern81
	dw md1pattern82
	dw md1pattern83
	dw md1pattern84
	dw md1pattern85
	dw md1pattern86
md1order2
	dw $2c00
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
md1order3
	dw $2c00
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87
	dw md1pattern87

md1pattern0	db $8f,$8f,$8f,$8f,$8f,$8d,$8d,$8f,$e0
md1pattern1	db $94,$8f,$8f,$8f,$8d,$8d,$8f,$8f,$e0
md1pattern2	db $8f,$8f,$8f,$8d,$8d,$8f,$8f,$8f,$e0
md1pattern3	db $8f,$8f,$8f,$8d,$8d,$8f,$94,$8f,$e0
md1pattern4	db $8f,$8f,$8d,$8d,$8f,$8f,$8f,$8f,$e0
md1pattern5	db $8f,$8d,$8d,$8f,$83,$8f,$91,$8f,$e0
md1pattern6	db $91,$8f,$8e,$8c,$8e,$8f,$91,$8e,$e0
md1pattern7	db $8a,$8a,$88,$8f,$8f,$94,$8f,$8f,$e0
md1pattern8	db $8f,$8a,$91,$96,$9a,$96,$91,$8e,$e0
md1pattern9	db $91,$8f,$8f,$91,$93,$91,$8f,$8e,$e0
md1pattern10	db $8c,$8e,$8f,$96,$8e,$8a,$8a,$88,$e0
md1pattern11	db $8f,$8f,$98,$8f,$8f,$8f,$8a,$8a,$e0
md1pattern12	db $8a,$8a,$96,$91,$9a,$91,$9b,$87,$e0
md1pattern13	db $94,$9b,$8f,$91,$91,$96,$91,$94,$e0
md1pattern14	db $88,$94,$98,$96,$8a,$9b,$87,$8f,$e0
md1pattern15	db $9b,$93,$91,$98,$96,$91,$94,$93,$e0
md1pattern16	db $91,$8a,$96,$87,$8f,$96,$8f,$91,$e0
md1pattern17	db $91,$96,$91,$94,$88,$94,$98,$96,$e0
md1pattern18	db $8a,$96,$87,$8f,$96,$93,$91,$98,$e0
md1pattern19	db $96,$91,$94,$93,$91,$96,$96,$96,$e0
md1pattern20	db $96,$96,$96,$83,$8f,$91,$8f,$91,$e0
md1pattern21	db $8f,$8e,$8c,$8e,$8f,$91,$8e,$8a,$e0
md1pattern22	db $8a,$88,$8f,$8f,$94,$8f,$8f,$8f,$e0
md1pattern23	db $8a,$91,$96,$9a,$96,$91,$8e,$91,$e0
md1pattern24	db $8f,$8f,$91,$93,$91,$8f,$8e,$8c,$e0
md1pattern25	db $8e,$8f,$96,$8e,$8a,$8a,$88,$8f,$e0
md1pattern26	db $8f,$98,$8f,$8f,$8f,$8a,$8a,$8a,$e0
md1pattern27	db $8a,$96,$91,$9a,$91,$8f,$8f,$8f,$e0
md1pattern28	db $8f,$8f,$8d,$8d,$8f,$94,$8f,$8f,$e0
md1pattern29	db $8f,$8d,$8d,$8f,$8f,$8f,$8f,$8f,$e0
md1pattern30	db $8d,$8d,$8f,$9b,$9b,$94,$96,$9b,$e0
md1pattern31	db $99,$99,$9b,$8f,$94,$8f,$94,$99,$e0
md1pattern32	db $99,$9b,$94,$99,$99,$98,$99,$99,$e0
md1pattern33	db $9b,$83,$8f,$91,$8f,$91,$8f,$8e,$e0
md1pattern34	db $8c,$8e,$8f,$91,$8e,$8a,$8a,$88,$e0
md1pattern35	db $8f,$8f,$94,$8f,$8f,$8f,$8a,$91,$e0
md1pattern36	db $96,$9a,$96,$91,$8e,$91,$8f,$8f,$e0
md1pattern37	db $91,$93,$91,$8f,$8e,$8c,$8e,$8f,$e0
md1pattern38	db $96,$8e,$8a,$8a,$88,$8f,$8f,$98,$e0
md1pattern39	db $8f,$8f,$8f,$8a,$8a,$8a,$8a,$96,$e0
md1pattern40	db $91,$9a,$91,$9b,$8f,$9d,$9b,$96,$e0
md1pattern41	db $8f,$93,$98,$8e,$93,$8c,$94,$8f,$e0
md1pattern42	db $94,$98,$8f,$8f,$8a,$91,$96,$9a,$e0
md1pattern43	db $91,$8f,$00,$00,$00,$00,$00,$00,$e0
md1pattern44	db $2f,$34,$33,$34,$38,$36,$34,$36,$e0
md1pattern45	db $34,$33,$3f,$38,$36,$34,$2f,$34,$e0
md1pattern46	db $33,$34,$38,$36,$34,$36,$2f,$34,$e0
md1pattern47	db $33,$34,$38,$36,$34,$36,$34,$33,$e0
md1pattern48	db $3f,$38,$36,$34,$2f,$34,$33,$34,$e0
md1pattern49	db $38,$36,$34,$36,$23,$2f,$31,$33,$e0
md1pattern50	db $36,$36,$33,$2f,$33,$2f,$36,$2e,$e0
md1pattern51	db $2a,$2a,$2f,$38,$38,$38,$38,$2f,$e0
md1pattern52	db $2f,$31,$3a,$3a,$3a,$36,$3a,$2e,$e0
md1pattern53	db $3a,$36,$33,$36,$33,$36,$36,$33,$e0
md1pattern54	db $2f,$33,$2f,$36,$2e,$2a,$2a,$2f,$e0
md1pattern55	db $38,$38,$38,$38,$2f,$2f,$2f,$2e,$e0
md1pattern56	db $2a,$2e,$36,$3a,$3a,$3a,$3b,$27,$e0
md1pattern57	db $2f,$3b,$36,$36,$31,$36,$36,$34,$e0
md1pattern58	db $28,$38,$38,$3a,$2a,$3f,$27,$34,$e0
md1pattern59	db $3f,$33,$36,$38,$36,$36,$34,$33,$e0
md1pattern60	db $31,$2f,$3b,$27,$34,$3b,$36,$36,$e0
md1pattern61	db $31,$36,$36,$34,$28,$38,$38,$3a,$e0
md1pattern62	db $2a,$3b,$27,$34,$3b,$33,$36,$38,$e0
md1pattern63	db $36,$36,$34,$33,$31,$2f,$2f,$2f,$e0
md1pattern64	db $2f,$2f,$2f,$23,$2f,$31,$33,$36,$e0
md1pattern65	db $36,$33,$2f,$33,$2f,$36,$2e,$2a,$e0
md1pattern66	db $2a,$2f,$38,$38,$38,$38,$2f,$2f,$e0
md1pattern67	db $31,$3a,$3a,$3a,$36,$3a,$2e,$3a,$e0
md1pattern68	db $36,$33,$36,$33,$36,$36,$33,$2f,$e0
md1pattern69	db $33,$2f,$36,$2e,$2a,$2a,$2f,$38,$e0
md1pattern70	db $38,$38,$38,$2f,$2f,$2f,$2e,$2a,$e0
md1pattern71	db $2e,$36,$3a,$3a,$3a,$2f,$34,$33,$e0
md1pattern72	db $34,$38,$36,$34,$36,$34,$33,$3f,$e0
md1pattern73	db $38,$36,$34,$2f,$34,$33,$34,$38,$e0
md1pattern74	db $36,$34,$36,$3b,$34,$38,$3b,$3f,$e0
md1pattern75	db $36,$36,$3b,$34,$38,$2f,$3b,$36,$e0
md1pattern76	db $34,$3b,$38,$3d,$3d,$38,$36,$34,$e0
md1pattern77	db $3f,$23,$2f,$31,$33,$36,$36,$33,$e0
md1pattern78	db $38,$38,$38,$38,$2f,$2f,$31,$3a,$e0
md1pattern79	db $3a,$3a,$36,$3a,$2e,$3a,$36,$33,$e0
md1pattern80	db $36,$33,$36,$36,$33,$2f,$33,$2f,$e0
md1pattern81	db $36,$2e,$2a,$2a,$2f,$38,$38,$38,$e0
md1pattern82	db $38,$2f,$2f,$2f,$2e,$2a,$2e,$36,$e0
md1pattern83	db $3a,$3a,$3a,$3b,$2f,$3d,$3f,$36,$e0
md1pattern84	db $36,$33,$38,$2e,$33,$33,$34,$38,$e0
md1pattern85	db $34,$38,$38,$2f,$31,$31,$3a,$3a,$e0
md1pattern86	db $3a,$36,$00,$00,$00,$00,$00,$00,$e0
md1pattern87	db $00,$00,$00,$00,$00,$00,$00,$00,$e0





end

