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
;	ld 	hl,musicData3
	ld 	hl,musicData4
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







; -------------------------------
; SONG : DOOM LEVEL. By Utz.
; -------------------------------
musicData4
	db $06
	dw doomorder0
	dw doomorder1
	dw doomorder2
	dw doomorder3

doomorder0
	dw $dc00
	dw doompattern0
	dw doompattern1
	dw doompattern2
	dw doompattern3
	dw doompattern4
	dw doompattern5
	dw doompattern6
	dw doompattern1
	dw doompattern2
	dw doompattern7
	dw doompattern4
	dw doompattern5
	dw doompattern8
	dw doompattern9
	dw doompattern10
	dw doompattern11
	dw doompattern1
	dw doompattern2
	dw doompattern7
	dw doompattern4
	dw doompattern5
	dw doompattern8
	dw doompattern9
	dw doompattern10
	dw doompattern12
	dw doompattern13
	dw doompattern10
	dw doompattern14
	dw doompattern15
	dw doompattern16
	dw doompattern12
	dw doompattern13
	dw doompattern10
	dw doompattern14
	dw doompattern15
	dw doompattern16
	dw doompattern12
	dw doompattern13
	dw doompattern10
	dw doompattern17
	dw doompattern18
	dw doompattern19
	dw doompattern17
	dw doompattern20
	dw doompattern21
	dw doompattern22
	dw doompattern23
	dw doompattern24
	dw doompattern25
	dw doompattern26
	dw doompattern27
	dw doompattern28
	dw doompattern29
	dw doompattern30
	dw doompattern31
	dw doompattern32
	dw doompattern33
	dw doompattern34
	dw doompattern35
	dw doompattern36
	dw doompattern25
	dw doompattern26
	dw doompattern27
	dw doompattern28
	dw doompattern29
	dw doompattern30
	dw doompattern31
	dw doompattern32
	dw doompattern33
	dw doompattern34
	dw doompattern35
	dw doompattern36
	dw doompattern37
	dw doompattern26
	dw doompattern27
	dw doompattern28
	dw doompattern29
	dw doompattern30
	dw doompattern38
	dw doompattern39
	dw doompattern40
	dw doompattern28
	dw doompattern41
	dw doompattern42
	dw doompattern37
	dw doompattern26
	dw doompattern27
	dw doompattern28
	dw doompattern29
	dw doompattern30
	dw doompattern38
	dw doompattern39
	dw doompattern40
	dw doompattern28
	dw doompattern41
	dw doompattern42
	dw doompattern43
	dw doompattern44
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern46
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern47
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern48
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern49
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern50
	dw doompattern51
	dw doompattern45
	dw doompattern45
	dw doompattern47
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern48
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern52
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern50
	dw doompattern51
	dw doompattern45
	dw doompattern45
	dw doompattern47
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern48
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern53
	dw doompattern54
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern9
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern55
	dw doompattern45
	dw doompattern56
	dw doompattern45
	dw doompattern57
	dw doompattern45
	dw doompattern57
	dw doompattern45
	dw doompattern58
	dw doompattern45
	dw doompattern9
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern55
	dw doompattern45
	dw doompattern59
	dw doompattern45
	dw doompattern60
	dw doompattern45
	dw doompattern61
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern59
	dw doompattern45
	dw doompattern62
	dw doompattern45
	dw doompattern63
	dw doompattern64
	dw doompattern65
	dw doompattern66
	dw doompattern59
	dw doompattern45
	dw doompattern60
	dw doompattern45
	dw doompattern61
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern59
	dw doompattern45
	dw doompattern62
	dw doompattern45
	dw doompattern63
	dw doompattern64
	dw doompattern65
	dw doompattern67
	dw doompattern68
	dw doompattern45
	dw doompattern69
	dw doompattern45
	dw doompattern45
	dw doompattern70
	dw doompattern71
	dw doompattern45
	dw doompattern72
	dw doompattern8
doomorder1
	dw $dc00
	dw doompattern54
	dw doompattern73
	dw doompattern74
	dw doompattern54
	dw doompattern73
	dw doompattern74
	dw doompattern75
	dw doompattern73
	dw doompattern74
	dw doompattern54
	dw doompattern73
	dw doompattern74
	dw doompattern8
	dw doompattern76
	dw doompattern77
	dw doompattern78
	dw doompattern73
	dw doompattern74
	dw doompattern54
	dw doompattern79
	dw doompattern74
	dw doompattern8
	dw doompattern76
	dw doompattern77
	dw doompattern80
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern80
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern81
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern82
	dw doompattern45
	dw doompattern45
	dw doompattern83
	dw doompattern84
	dw doompattern85
	dw doompattern86
	dw doompattern45
	dw doompattern87
	dw doompattern88
	dw doompattern45
	dw doompattern89
	dw doompattern6
	dw doompattern45
	dw doompattern90
	dw doompattern88
	dw doompattern91
	dw doompattern92
	dw doompattern86
	dw doompattern45
	dw doompattern87
	dw doompattern88
	dw doompattern45
	dw doompattern93
	dw doompattern6
	dw doompattern45
	dw doompattern94
	dw doompattern95
	dw doompattern96
	dw doompattern97
	dw doompattern98
	dw doompattern99
	dw doompattern100
	dw doompattern88
	dw doompattern45
	dw doompattern101
	dw doompattern6
	dw doompattern45
	dw doompattern102
	dw doompattern88
	dw doompattern91
	dw doompattern92
	dw doompattern98
	dw doompattern99
	dw doompattern100
	dw doompattern88
	dw doompattern45
	dw doompattern101
	dw doompattern6
	dw doompattern45
	dw doompattern94
	dw doompattern95
	dw doompattern45
	dw doompattern45
	dw doompattern103
	dw doompattern104
	dw doompattern105
	dw doompattern106
	dw doompattern107
	dw doompattern108
	dw doompattern105
	dw doompattern106
	dw doompattern107
	dw doompattern108
	dw doompattern105
	dw doompattern106
	dw doompattern107
	dw doompattern108
	dw doompattern105
	dw doompattern106
	dw doompattern107
	dw doompattern108
	dw doompattern105
	dw doompattern106
	dw doompattern107
	dw doompattern108
	dw doompattern105
	dw doompattern106
	dw doompattern107
	dw doompattern108
	dw doompattern105
	dw doompattern106
	dw doompattern107
	dw doompattern108
	dw doompattern105
	dw doompattern106
	dw doompattern107
	dw doompattern108
	dw doompattern105
	dw doompattern106
	dw doompattern107
	dw doompattern109
	dw doompattern110
	dw doompattern111
	dw doompattern112
	dw doompattern113
	dw doompattern105
	dw doompattern106
	dw doompattern107
	dw doompattern109
	dw doompattern110
	dw doompattern111
	dw doompattern112
	dw doompattern114
	dw doompattern115
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern76
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern69
	dw doompattern116
	dw doompattern117
	dw doompattern45
	dw doompattern9
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern9
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern118
	dw doompattern45
	dw doompattern119
	dw doompattern120
	dw doompattern121
	dw doompattern122
	dw doompattern123
	dw doompattern124
	dw doompattern125
	dw doompattern126
	dw doompattern127
	dw doompattern128
	dw doompattern129
	dw doompattern130
	dw doompattern131
	dw doompattern132
	dw doompattern132
	dw doompattern132
	dw doompattern133
	dw doompattern120
	dw doompattern121
	dw doompattern122
	dw doompattern123
	dw doompattern124
	dw doompattern125
	dw doompattern126
	dw doompattern134
	dw doompattern135
	dw doompattern136
	dw doompattern137
	dw doompattern138
	dw doompattern139
	dw doompattern139
	dw doompattern139
	dw doompattern140
	dw doompattern141
	dw doompattern142
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern8
	dw doompattern45
	dw doompattern45
	dw doompattern8
doomorder2
	dw $dc00
	dw doompattern143
	dw doompattern144
	dw doompattern47
	dw doompattern3
	dw doompattern145
	dw doompattern47
	dw doompattern146
	dw doompattern144
	dw doompattern147
	dw doompattern148
	dw doompattern145
	dw doompattern149
	dw doompattern150
	dw doompattern151
	dw doompattern152
	dw doompattern153
	dw doompattern144
	dw doompattern147
	dw doompattern154
	dw doompattern155
	dw doompattern156
	dw doompattern150
	dw doompattern151
	dw doompattern152
	dw doompattern7
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern157
	dw doompattern158
	dw doompattern6
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern7
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern159
	dw doompattern45
	dw doompattern45
	dw doompattern160
	dw doompattern161
	dw doompattern162
	dw doompattern3
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern163
	dw doompattern163
	dw doompattern163
	dw doompattern163
	dw doompattern163
	dw doompattern164
	dw doompattern165
	dw doompattern165
	dw doompattern165
	dw doompattern166
	dw doompattern167
	dw doompattern167
	dw doompattern7
	dw doompattern45
	dw doompattern45
	dw doompattern160
	dw doompattern45
	dw doompattern45
	dw doompattern159
	dw doompattern45
	dw doompattern60
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern7
	dw doompattern45
	dw doompattern45
	dw doompattern160
	dw doompattern45
	dw doompattern45
	dw doompattern159
	dw doompattern45
	dw doompattern60
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern168
	dw doompattern169
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern170
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern2
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern5
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern170
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern170
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern2
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern5
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern69
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern170
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern54
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern171
	dw doompattern45
	dw doompattern45
	dw doompattern46
	dw doompattern45
	dw doompattern172
	dw doompattern173
	dw doompattern174
	dw doompattern175
	dw doompattern176
	dw doompattern177
	dw doompattern178
	dw doompattern179
	dw doompattern180
	dw doompattern173
	dw doompattern174
	dw doompattern175
	dw doompattern181
	dw doompattern179
	dw doompattern179
	dw doompattern179
	dw doompattern180
	dw doompattern173
	dw doompattern174
	dw doompattern175
	dw doompattern176
	dw doompattern177
	dw doompattern178
	dw doompattern179
	dw doompattern180
	dw doompattern173
	dw doompattern174
	dw doompattern175
	dw doompattern181
	dw doompattern179
	dw doompattern179
	dw doompattern179
	dw doompattern182
	dw doompattern183
	dw doompattern184
	dw doompattern185
	dw doompattern186
	dw doompattern187
	dw doompattern188
	dw doompattern189
	dw doompattern190
	dw doompattern183
	dw doompattern184
	dw doompattern185
	dw doompattern191
	dw doompattern189
	dw doompattern189
	dw doompattern189
	dw doompattern192
	dw doompattern173
	dw doompattern174
	dw doompattern175
	dw doompattern176
	dw doompattern177
	dw doompattern178
	dw doompattern179
	dw doompattern180
	dw doompattern173
	dw doompattern174
	dw doompattern175
	dw doompattern181
	dw doompattern179
	dw doompattern179
	dw doompattern179
	dw doompattern193
	dw doompattern194
	dw doompattern45
	dw doompattern195
	dw doompattern45
	dw doompattern59
	dw doompattern45
	dw doompattern3
	dw doompattern45
	dw doompattern8
doomorder3
	dw $dc00
	dw doompattern56
	dw doompattern196
	dw doompattern197
	dw doompattern56
	dw doompattern196
	dw doompattern197
	dw doompattern198
	dw doompattern199
	dw doompattern197
	dw doompattern56
	dw doompattern196
	dw doompattern197
	dw doompattern8
	dw doompattern200
	dw doompattern201
	dw doompattern202
	dw doompattern199
	dw doompattern197
	dw doompattern203
	dw doompattern204
	dw doompattern205
	dw doompattern8
	dw doompattern200
	dw doompattern201
	dw doompattern8
	dw doompattern56
	dw doompattern206
	dw doompattern8
	dw doompattern45
	dw doompattern45
	dw doompattern8
	dw doompattern56
	dw doompattern206
	dw doompattern8
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern207
	dw doompattern45
	dw doompattern45
	dw doompattern207
	dw doompattern208
	dw doompattern209
	dw doompattern210
	dw doompattern211
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern210
	dw doompattern211
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern212
	dw doompattern45
	dw doompattern45
	dw doompattern213
	dw doompattern45
	dw doompattern53
	dw doompattern214
	dw doompattern45
	dw doompattern118
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern212
	dw doompattern45
	dw doompattern45
	dw doompattern213
	dw doompattern45
	dw doompattern53
	dw doompattern214
	dw doompattern45
	dw doompattern118
	dw doompattern8
	dw doompattern45
	dw doompattern45
	dw doompattern215
	dw doompattern5
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern216
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern216
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern46
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern217
	dw doompattern218
	dw doompattern218
	dw doompattern218
	dw doompattern219
	dw doompattern220
	dw doompattern220
	dw doompattern220
	dw doompattern221
	dw doompattern222
	dw doompattern222
	dw doompattern222
	dw doompattern223
	dw doompattern224
	dw doompattern224
	dw doompattern224
	dw doompattern225
	dw doompattern226
	dw doompattern226
	dw doompattern226
	dw doompattern227
	dw doompattern228
	dw doompattern229
	dw doompattern230
	dw doompattern231
	dw doompattern232
	dw doompattern233
	dw doompattern234
	dw doompattern235
	dw doompattern236
	dw doompattern237
	dw doompattern238
	dw doompattern239
	dw doompattern240
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern60
	dw doompattern45
	dw doompattern61
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern60
	dw doompattern45
	dw doompattern61
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern63
	dw doompattern64
	dw doompattern241
	dw doompattern45
	dw doompattern61
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern45
	dw doompattern60
	dw doompattern45
	dw doompattern242
	dw doompattern243
	dw doompattern244
	dw doompattern245
	dw doompattern246
	dw doompattern247
	dw doompattern248
	dw doompattern249
	dw doompattern250
	dw doompattern243
	dw doompattern244
	dw doompattern245
	dw doompattern251
	dw doompattern249
	dw doompattern249
	dw doompattern249
	dw doompattern250
	dw doompattern243
	dw doompattern244
	dw doompattern245
	dw doompattern246
	dw doompattern247
	dw doompattern248
	dw doompattern249
	dw doompattern250
	dw doompattern243
	dw doompattern244
	dw doompattern245
	dw doompattern251
	dw doompattern249
	dw doompattern249
	dw doompattern249
	dw doompattern252
	dw doompattern253
	dw doompattern45
	dw doompattern55
	dw doompattern45
	dw doompattern70
	dw doompattern68
	dw doompattern45
	dw doompattern45
	dw doompattern8

doompattern0
	db $07,$00,$00,$00,$00,$00,$00,$33,$e0
doompattern1
	db $5f,$00,$00,$00,$27,$00,$00,$00,$e0
doompattern2
	db $00,$00,$00,$00,$5d,$00,$00,$00,$e0
doompattern3
	db $27,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern4
	db $5a,$00,$00,$00,$27,$00,$00,$00,$e0
doompattern5
	db $00,$00,$00,$00,$5b,$00,$00,$00,$e0
doompattern6
	db $13,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern7
	db $07,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern8
	db $01,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern9
	db $00,$00,$00,$00,$3a,$00,$00,$00,$e0
doompattern10
	db $38,$00,$00,$00,$3b,$00,$00,$00,$e0
doompattern11
	db $01,$00,$00,$00,$13,$00,$00,$00,$e0
doompattern12
	db $3a,$00,$38,$00,$36,$00,$35,$00,$e0
doompattern13
	db $33,$00,$00,$00,$3a,$00,$00,$00,$e0
doompattern14
	db $3a,$00,$38,$00,$36,$00,$38,$00,$e0
doompattern15
	db $35,$00,$36,$00,$33,$00,$31,$00,$e0
doompattern16
	db $33,$00,$35,$00,$36,$00,$38,$00,$e0
doompattern17
	db $3a,$00,$38,$00,$3a,$00,$38,$00,$e0
doompattern18
	db $36,$00,$35,$00,$33,$00,$00,$00,$e0
doompattern19
	db $3a,$00,$00,$00,$3b,$00,$00,$00,$e0
doompattern20
	db $3a,$00,$00,$00,$3d,$00,$3a,$00,$e0
doompattern21
	db $3d,$00,$3a,$00,$3d,$00,$3a,$00,$e0
doompattern22
	db $15,$13,$11,$10,$0e,$00,$00,$00,$e0
doompattern23
	db $00,$00,$01,$00,$35,$00,$00,$00,$e0
doompattern24
	db $33,$00,$00,$00,$36,$00,$00,$00,$e0
doompattern25
	db $1f,$5f,$1a,$5a,$13,$53,$1f,$5f,$e0
doompattern26
	db $5a,$5a,$53,$53,$5f,$5f,$5a,$5a,$e0
doompattern27
	db $53,$53,$5f,$5f,$5a,$5a,$53,$53,$e0
doompattern28
	db $5d,$5d,$5a,$5a,$53,$53,$5d,$5d,$e0
doompattern29
	db $5a,$5a,$53,$53,$5d,$5d,$5a,$5a,$e0
doompattern30
	db $53,$53,$5d,$5d,$5a,$5a,$53,$53,$e0
doompattern31
	db $5b,$5b,$58,$58,$4f,$4f,$5b,$5b,$e0
doompattern32
	db $58,$58,$4f,$4f,$5b,$5b,$58,$58,$e0
doompattern33
	db $4f,$4f,$5b,$5b,$58,$58,$4f,$4f,$e0
doompattern34
	db $5a,$5a,$56,$56,$4e,$4e,$5a,$5a,$e0
doompattern35
	db $56,$56,$4e,$4e,$5d,$5d,$56,$56,$e0
doompattern36
	db $4e,$4e,$5d,$5d,$56,$56,$4e,$4e,$e0
doompattern37
	db $5f,$5f,$5a,$5a,$53,$53,$5f,$5f,$e0
doompattern38
	db $5b,$5b,$58,$58,$53,$53,$5b,$5b,$e0
doompattern39
	db $58,$58,$53,$53,$5b,$5b,$58,$58,$e0
doompattern40
	db $53,$53,$5b,$5b,$58,$58,$53,$53,$e0
doompattern41
	db $5a,$5a,$55,$55,$5d,$5d,$5a,$5a,$e0
doompattern42
	db $55,$55,$5d,$5d,$5a,$5a,$55,$55,$e0
doompattern43
	db $01,$00,$00,$36,$37,$38,$39,$3a,$e0
doompattern44
	db $3b,$3c,$3d,$3e,$58,$00,$00,$00,$e0
doompattern45
	db $00,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern46
	db $00,$00,$00,$00,$58,$00,$00,$00,$e0
doompattern47
	db $00,$00,$00,$00,$56,$00,$00,$00,$e0
doompattern48
	db $00,$00,$00,$00,$54,$00,$00,$00,$e0
doompattern49
	db $00,$00,$00,$00,$0c,$4c,$0c,$4c,$e0
doompattern50
	db $0f,$4f,$0f,$4f,$0e,$4e,$0e,$4e,$e0
doompattern51
	db $00,$00,$00,$00,$4a,$00,$00,$00,$e0
doompattern52
	db $00,$00,$00,$00,$07,$47,$07,$47,$e0
doompattern53
	db $00,$00,$00,$00,$00,$00,$01,$00,$e0
doompattern54
	db $00,$00,$00,$00,$36,$00,$00,$00,$e0
doompattern55
	db $00,$00,$00,$00,$3d,$00,$00,$00,$e0
doompattern56
	db $00,$00,$00,$00,$2a,$00,$00,$00,$e0
doompattern57
	db $00,$00,$00,$00,$2c,$00,$00,$00,$e0
doompattern58
	db $36,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern59
	db $00,$00,$00,$00,$07,$00,$00,$00,$e0
doompattern60
	db $00,$00,$00,$00,$05,$00,$00,$00,$e0
doompattern61
	db $00,$00,$00,$00,$03,$00,$00,$00,$e0
doompattern62
	db $00,$00,$00,$00,$09,$00,$00,$00,$e0
doompattern63
	db $00,$00,$00,$00,$0f,$00,$00,$00,$e0
doompattern64
	db $00,$00,$03,$00,$00,$00,$00,$00,$e0
doompattern65
	db $00,$00,$0f,$00,$00,$00,$00,$00,$e0
doompattern66
	db $03,$00,$00,$00,$05,$00,$00,$00,$e0
doompattern67
	db $03,$00,$00,$00,$00,$00,$05,$00,$e0
doompattern68
	db $00,$00,$00,$00,$01,$00,$00,$00,$e0
doompattern69
	db $00,$00,$00,$00,$33,$00,$00,$00,$e0
doompattern70
	db $00,$00,$00,$00,$3f,$00,$00,$00,$e0
doompattern71
	db $3d,$3a,$38,$36,$33,$00,$00,$00,$e0
doompattern72
	db $27,$00,$00,$00,$07,$00,$00,$00,$e0
doompattern73
	db $5a,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern74
	db $36,$00,$00,$00,$5a,$00,$00,$00,$e0
doompattern75
	db $47,$00,$00,$00,$56,$00,$00,$00,$e0
doompattern76
	db $00,$00,$00,$00,$2e,$00,$00,$00,$e0
doompattern77
	db $2c,$00,$00,$00,$2c,$00,$00,$00,$e0
doompattern78
	db $01,$00,$00,$00,$36,$00,$00,$00,$e0
doompattern79
	db $3a,$00,$00,$00,$38,$00,$00,$00,$e0
doompattern80
	db $2e,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern81
	db $2c,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern82
	db $2f,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern83
	db $31,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern84
	db $00,$00,$01,$00,$31,$00,$00,$00,$e0
doompattern85
	db $35,$00,$00,$00,$38,$00,$00,$00,$e0
doompattern86
	db $07,$00,$13,$00,$11,$00,$13,$00,$e0
doompattern87
	db $00,$00,$00,$00,$00,$33,$0e,$00,$e0
doompattern88
	db $11,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern89
	db $00,$00,$00,$00,$00,$00,$00,$31,$e0
doompattern90
	db $00,$00,$00,$00,$0f,$00,$0c,$00,$e0
doompattern91
	db $00,$00,$00,$00,$15,$00,$00,$00,$e0
doompattern92
	db $00,$00,$00,$00,$16,$00,$15,$00,$e0
doompattern93
	db $00,$00,$00,$00,$00,$31,$00,$51,$e0
doompattern94
	db $00,$00,$00,$00,$15,$00,$16,$00,$e0
doompattern95
	db $15,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern96
	db $00,$00,$00,$00,$00,$35,$00,$15,$e0
doompattern97
	db $0e,$11,$15,$18,$15,$11,$0e,$0a,$e0
doompattern98
	db $13,$00,$15,$00,$16,$00,$13,$00,$e0
doompattern99
	db $15,$00,$16,$00,$15,$00,$00,$00,$e0
doompattern100
	db $13,$00,$00,$00,$0e,$00,$00,$00,$e0
doompattern101
	db $00,$00,$00,$00,$00,$00,$00,$01,$e0
doompattern102
	db $00,$00,$00,$00,$0f,$00,$0a,$00,$e0
doompattern103
	db $00,$00,$00,$55,$00,$00,$00,$01,$e0
doompattern104
	db $00,$00,$00,$00,$5f,$00,$5d,$00,$e0
doompattern105
	db $5b,$00,$5a,$00,$5b,$00,$5a,$00,$e0
doompattern106
	db $5b,$00,$5a,$00,$58,$00,$5a,$00,$e0
doompattern107
	db $58,$00,$5a,$00,$5b,$00,$5a,$00,$e0
doompattern108
	db $5b,$00,$5d,$00,$5f,$00,$5d,$00,$e0
doompattern109
	db $5b,$00,$5d,$00,$3f,$00,$3d,$00,$e0
doompattern110
	db $3b,$00,$3a,$00,$3b,$00,$3a,$00,$e0
doompattern111
	db $3b,$00,$3a,$00,$38,$00,$3a,$00,$e0
doompattern112
	db $38,$00,$3a,$00,$3b,$00,$3a,$00,$e0
doompattern113
	db $3b,$00,$3d,$00,$5f,$00,$5d,$00,$e0
doompattern114
	db $3b,$00,$3d,$00,$01,$00,$00,$00,$e0
doompattern115
	db $35,$00,$55,$00,$3a,$00,$00,$00,$e0
doompattern116
	db $00,$00,$2f,$00,$00,$00,$00,$00,$e0
doompattern117
	db $31,$00,$00,$00,$35,$00,$00,$00,$e0
doompattern118
	db $00,$00,$00,$00,$35,$00,$00,$00,$e0
doompattern119
	db $00,$00,$00,$00,$00,$00,$56,$5f,$e0
doompattern120
	db $5a,$56,$53,$5f,$5a,$56,$53,$5f,$e0
doompattern121
	db $5a,$56,$53,$5f,$5a,$56,$53,$5d,$e0
doompattern122
	db $5a,$56,$55,$5d,$5a,$56,$55,$5d,$e0
doompattern123
	db $5a,$56,$55,$5d,$5a,$56,$55,$5b,$e0
doompattern124
	db $56,$53,$56,$5a,$56,$53,$56,$5a,$e0
doompattern125
	db $56,$53,$56,$5b,$56,$53,$56,$5b,$e0
doompattern126
	db $56,$53,$56,$5d,$56,$53,$56,$5b,$e0
doompattern127
	db $56,$53,$56,$5a,$56,$53,$56,$3f,$e0
doompattern128
	db $3a,$36,$33,$3f,$3a,$36,$33,$3f,$e0
doompattern129
	db $3a,$36,$33,$3f,$3a,$36,$33,$3d,$e0
doompattern130
	db $3a,$36,$35,$3d,$3a,$36,$35,$3d,$e0
doompattern131
	db $3a,$36,$35,$3d,$3a,$36,$35,$3f,$e0
doompattern132
	db $36,$33,$36,$3d,$36,$33,$36,$3b,$e0
doompattern133
	db $36,$33,$36,$3a,$33,$36,$3a,$5f,$e0
doompattern134
	db $56,$53,$56,$5a,$56,$53,$56,$1f,$e0
doompattern135
	db $1a,$16,$13,$1f,$1a,$16,$13,$1f,$e0
doompattern136
	db $1a,$16,$13,$1f,$1a,$16,$13,$1d,$e0
doompattern137
	db $1a,$16,$15,$1d,$1a,$16,$15,$1d,$e0
doompattern138
	db $1a,$16,$15,$1d,$1a,$16,$15,$1f,$e0
doompattern139
	db $16,$13,$16,$1d,$16,$13,$16,$1b,$e0
doompattern140
	db $16,$13,$16,$1a,$00,$00,$00,$5a,$e0
doompattern141
	db $00,$00,$00,$01,$00,$00,$00,$00,$e0
doompattern142
	db $00,$00,$00,$00,$00,$00,$36,$00,$e0
doompattern143
	db $07,$00,$00,$00,$00,$01,$01,$00,$e0
doompattern144
	db $56,$00,$00,$00,$27,$00,$00,$00,$e0
doompattern145
	db $56,$00,$00,$00,$07,$00,$00,$00,$e0
doompattern146
	db $13,$00,$00,$00,$00,$5f,$01,$5a,$e0
doompattern147
	db $36,$00,$38,$00,$55,$00,$56,$00,$e0
doompattern148
	db $07,$00,$00,$00,$13,$15,$16,$18,$e0
doompattern149
	db $18,$00,$00,$00,$5b,$00,$00,$00,$e0
doompattern150
	db $5a,$00,$58,$00,$56,$00,$55,$00,$e0
doompattern151
	db $53,$00,$00,$00,$22,$00,$00,$00,$e0
doompattern152
	db $25,$00,$00,$00,$31,$00,$00,$00,$e0
doompattern153
	db $07,$0a,$0e,$11,$0e,$11,$15,$18,$e0
doompattern154
	db $07,$00,$00,$00,$56,$55,$56,$00,$e0
doompattern155
	db $56,$00,$00,$00,$31,$00,$00,$00,$e0
doompattern156
	db $3b,$00,$00,$00,$5b,$00,$00,$00,$e0
doompattern157
	db $00,$00,$00,$00,$00,$08,$09,$0a,$e0
doompattern158
	db $0b,$0c,$0d,$0e,$0f,$10,$11,$12,$e0
doompattern159
	db $03,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern160
	db $02,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern161
	db $00,$00,$00,$00,$02,$00,$00,$00,$e0
doompattern162
	db $0c,$00,$00,$00,$0f,$00,$00,$00,$e0
doompattern163
	db $02,$00,$22,$01,$02,$00,$22,$01,$e0
doompattern164
	db $02,$00,$42,$42,$02,$00,$42,$42,$e0
doompattern165
	db $03,$00,$43,$43,$03,$00,$43,$43,$e0
doompattern166
	db $05,$00,$45,$45,$05,$00,$45,$45,$e0
doompattern167
	db $05,$00,$25,$45,$05,$00,$25,$45,$e0
doompattern168
	db $00,$00,$00,$00,$45,$00,$00,$00,$e0
doompattern169
	db $00,$00,$01,$00,$5f,$00,$00,$00,$e0
doompattern170
	db $00,$00,$00,$00,$5f,$00,$00,$00,$e0
doompattern171
	db $38,$00,$36,$00,$38,$00,$00,$00,$e0
doompattern172
	db $01,$00,$00,$01,$1f,$1a,$16,$13,$e0
doompattern173
	db $1f,$1a,$16,$13,$1f,$1a,$16,$13,$e0
doompattern174
	db $1f,$1a,$16,$13,$1d,$1a,$16,$15,$e0
doompattern175
	db $1d,$1a,$16,$15,$1d,$1a,$16,$15,$e0
doompattern176
	db $1d,$1a,$16,$15,$1b,$16,$13,$16,$e0
doompattern177
	db $1a,$16,$13,$16,$1a,$16,$13,$16,$e0
doompattern178
	db $1b,$16,$13,$16,$1b,$16,$13,$16,$e0
doompattern179
	db $1d,$16,$13,$16,$1b,$16,$13,$16,$e0
doompattern180
	db $1a,$16,$13,$16,$1f,$1a,$16,$13,$e0
doompattern181
	db $1d,$1a,$16,$15,$1f,$16,$13,$16,$e0
doompattern182
	db $1a,$16,$13,$16,$3f,$3a,$36,$33,$e0
doompattern183
	db $3f,$3a,$36,$33,$3f,$3a,$36,$33,$e0
doompattern184
	db $3f,$3a,$36,$33,$3d,$3a,$36,$35,$e0
doompattern185
	db $3d,$3a,$36,$35,$3d,$3a,$36,$35,$e0
doompattern186
	db $3d,$3a,$36,$35,$3b,$36,$33,$36,$e0
doompattern187
	db $3a,$36,$33,$36,$3a,$36,$33,$36,$e0
doompattern188
	db $3b,$36,$33,$36,$3b,$36,$33,$36,$e0
doompattern189
	db $3d,$36,$33,$36,$3b,$36,$33,$36,$e0
doompattern190
	db $3a,$36,$33,$36,$3f,$3a,$36,$33,$e0
doompattern191
	db $3d,$3a,$36,$35,$3f,$36,$33,$36,$e0
doompattern192
	db $3a,$36,$33,$36,$1f,$1a,$16,$13,$e0
doompattern193
	db $1a,$16,$13,$16,$00,$00,$00,$00,$e0
doompattern194
	db $56,$00,$00,$00,$00,$00,$01,$00,$e0
doompattern195
	db $00,$38,$00,$00,$00,$00,$00,$00,$e0
doompattern196
	db $53,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern197
	db $2a,$00,$00,$00,$53,$00,$00,$00,$e0
doompattern198
	db $5f,$00,$00,$00,$5a,$00,$58,$00,$e0
doompattern199
	db $5b,$00,$00,$00,$3a,$00,$00,$00,$e0
doompattern200
	db $00,$00,$00,$00,$22,$00,$00,$00,$e0
doompattern201
	db $25,$00,$00,$00,$35,$00,$00,$00,$e0
doompattern202
	db $3f,$00,$00,$00,$3a,$00,$38,$00,$e0
doompattern203
	db $5a,$58,$5a,$00,$5a,$58,$5a,$00,$e0
doompattern204
	db $33,$00,$00,$00,$5d,$00,$00,$00,$e0
doompattern205
	db $4a,$00,$00,$00,$53,$00,$00,$00,$e0
doompattern206
	db $29,$00,$00,$00,$2c,$00,$00,$00,$e0
doompattern207
	db $2a,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern208
	db $00,$00,$00,$01,$2a,$00,$00,$00,$e0
doompattern209
	db $2c,$00,$00,$00,$2f,$00,$00,$00,$e0
doompattern210
	db $00,$00,$00,$00,$42,$00,$4e,$01,$e0
doompattern211
	db $4e,$01,$4e,$01,$00,$00,$00,$00,$e0
doompattern212
	db $22,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern213
	db $25,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern214
	db $33,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern215
	db $35,$00,$00,$00,$00,$55,$00,$00,$e0
doompattern216
	db $00,$00,$00,$00,$5a,$00,$00,$00,$e0
doompattern217
	db $00,$00,$00,$00,$2c,$4c,$2c,$4c,$e0
doompattern218
	db $2c,$4c,$2c,$4c,$2c,$4c,$2c,$4c,$e0
doompattern219
	db $2c,$4c,$2c,$4c,$2e,$2e,$2e,$2e,$e0
doompattern220
	db $2e,$2e,$2e,$2e,$2e,$2e,$2e,$2e,$e0
doompattern221
	db $2e,$2e,$2e,$2e,$2f,$2f,$2f,$2f,$e0
doompattern222
	db $2f,$2f,$2f,$2f,$2f,$2f,$2f,$2f,$e0
doompattern223
	db $2f,$2f,$2f,$2f,$31,$31,$31,$31,$e0
doompattern224
	db $31,$31,$31,$31,$31,$31,$31,$31,$e0
doompattern225
	db $31,$31,$31,$31,$0c,$4c,$0c,$4c,$e0
doompattern226
	db $0c,$4c,$0c,$4c,$0c,$4c,$0c,$4c,$e0
doompattern227
	db $0c,$4c,$0c,$4c,$02,$22,$02,$22,$e0
doompattern228
	db $02,$22,$02,$22,$0e,$2e,$02,$22,$e0
doompattern229
	db $02,$22,$0e,$2e,$02,$22,$02,$22,$e0
doompattern230
	db $02,$22,$02,$22,$02,$22,$0e,$2e,$e0
doompattern231
	db $02,$22,$02,$22,$03,$23,$03,$23,$e0
doompattern232
	db $03,$23,$03,$23,$0f,$2f,$03,$23,$e0
doompattern233
	db $03,$23,$0f,$2f,$03,$23,$03,$23,$e0
doompattern234
	db $03,$23,$03,$23,$03,$23,$0f,$2f,$e0
doompattern235
	db $03,$23,$03,$23,$05,$25,$05,$25,$e0
doompattern236
	db $05,$25,$05,$25,$11,$31,$05,$25,$e0
doompattern237
	db $05,$25,$11,$31,$05,$25,$05,$25,$e0
doompattern238
	db $05,$25,$05,$25,$05,$25,$11,$25,$e0
doompattern239
	db $05,$25,$05,$25,$00,$00,$2e,$00,$e0
doompattern240
	db $4e,$00,$01,$00,$03,$00,$00,$00,$e0
doompattern241
	db $05,$00,$00,$00,$00,$00,$00,$00,$e0
doompattern242
	db $00,$00,$06,$00,$01,$36,$3f,$3a,$e0
doompattern243
	db $36,$33,$3f,$3a,$36,$33,$3f,$3a,$e0
doompattern244
	db $36,$33,$3f,$3a,$36,$33,$3d,$3a,$e0
doompattern245
	db $36,$35,$3d,$3a,$36,$35,$3d,$3a,$e0
doompattern246
	db $36,$35,$3d,$3a,$36,$35,$3b,$36,$e0
doompattern247
	db $33,$36,$3a,$36,$33,$36,$3a,$36,$e0
doompattern248
	db $33,$36,$3b,$36,$33,$36,$3b,$36,$e0
doompattern249
	db $33,$36,$3d,$36,$33,$36,$3b,$36,$e0
doompattern250
	db $33,$36,$3a,$36,$33,$36,$3f,$3a,$e0
doompattern251
	db $36,$35,$3d,$3a,$36,$35,$3f,$36,$e0
doompattern252
	db $33,$36,$3a,$36,$33,$00,$00,$00,$e0
doompattern253
	db $00,$53,$00,$00,$00,$00,$00,$00,$e0




end

