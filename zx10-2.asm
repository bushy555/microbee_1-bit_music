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
	ld 	hl,musicData2
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








; =======================
;    EARTHSHAKER MUSIC
; =======================

musicData2:						
	db $06
	dw dooforder0
	dw dooforder1
	dw dooforder2
	dw dooforder3

dooforder0:
	dw $e100
	dw doofpattern0
	dw doofpattern1
	dw doofpattern0
	dw doofpattern2
	dw doofpattern3
	dw doofpattern1
	dw doofpattern1
	dw doofpattern4
	dw doofpattern0
	dw doofpattern1
	dw doofpattern0
	dw doofpattern2
	dw doofpattern3
	dw doofpattern1
	dw doofpattern1
	dw doofpattern5
	dw doofpattern6
	dw doofpattern1
	dw doofpattern6
	dw doofpattern7
	dw doofpattern8
	dw doofpattern1
	dw doofpattern1
	dw doofpattern9
	dw doofpattern6
	dw doofpattern1
	dw doofpattern6
	dw doofpattern7
	dw doofpattern8
	dw doofpattern1
	dw doofpattern1
	dw doofpattern10
	dw doofpattern2
	dw doofpattern1
	dw doofpattern2
	dw doofpattern11
	dw doofpattern12
	dw doofpattern1
	dw doofpattern1
	dw doofpattern13
	dw doofpattern2
	dw doofpattern1
	dw doofpattern2
	dw doofpattern11
	dw doofpattern14
	dw doofpattern1
	dw doofpattern1
	dw doofpattern15
	dw doofpattern7
	dw doofpattern1
	dw doofpattern7
	dw doofpattern16
	dw doofpattern17
	dw doofpattern1
	dw doofpattern1
	dw doofpattern18
	dw doofpattern7
	dw doofpattern1
	dw doofpattern7
	dw doofpattern16
	dw doofpattern19
	dw doofpattern1
	dw doofpattern1
	dw doofpattern20
	dw doofpattern21
	dw doofpattern1
	dw doofpattern21
	dw doofpattern22
	dw doofpattern12
	dw doofpattern1
	dw doofpattern1
	dw doofpattern23
	dw doofpattern21
	dw doofpattern1
	dw doofpattern21
	dw doofpattern22
	dw doofpattern24
	dw doofpattern1
	dw doofpattern1
	dw doofpattern25
	dw doofpattern21
	dw doofpattern1
	dw doofpattern21
	dw doofpattern22
	dw doofpattern12
	dw doofpattern1
	dw doofpattern1
	dw doofpattern23
	dw doofpattern0
	dw doofpattern1
	dw doofpattern0
	dw doofpattern26
	dw doofpattern27
	dw doofpattern1
	dw doofpattern1
	dw doofpattern28
	dw doofpattern29
	dw doofpattern30
	dw doofpattern31
	dw doofpattern1
	dw doofpattern32
	dw doofpattern33
	dw doofpattern34
	dw doofpattern35
	dw doofpattern36
	dw doofpattern37
	dw doofpattern1
	dw doofpattern38
	dw doofpattern39
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern40
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern41
	dw doofpattern1
	dw doofpattern1
	dw doofpattern42
	dw doofpattern39
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern43
	dw doofpattern44
	dw doofpattern45
	dw doofpattern46
	dw doofpattern47
	dw doofpattern48
	dw doofpattern33
	dw doofpattern8
	dw doofpattern49
	dw doofpattern50
	dw doofpattern51
	dw doofpattern52
	dw doofpattern53
	dw doofpattern54
	dw doofpattern55
	dw doofpattern56
	dw doofpattern43
	dw doofpattern44
	dw doofpattern45
	dw doofpattern46
	dw doofpattern57
	dw doofpattern58
	dw doofpattern33
	dw doofpattern8
	dw doofpattern49
	dw doofpattern50
	dw doofpattern51
	dw doofpattern52
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern12
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern17
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern60
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern61
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern60
	dw doofpattern17
	dw doofpattern12
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern62
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern17
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern63
	dw doofpattern64
	dw doofpattern65
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern66
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern61
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern60
	dw doofpattern17
	dw doofpattern59
dooforder1:
	dw $e100
	dw doofpattern67
	dw doofpattern68
	dw doofpattern69
	dw doofpattern70
	dw doofpattern71
	dw doofpattern1
	dw doofpattern1
	dw doofpattern72
	dw doofpattern67
	dw doofpattern68
	dw doofpattern69
	dw doofpattern70
	dw doofpattern71
	dw doofpattern1
	dw doofpattern1
	dw doofpattern73
	dw doofpattern74
	dw doofpattern3
	dw doofpattern75
	dw doofpattern76
	dw doofpattern77
	dw doofpattern1
	dw doofpattern1
	dw doofpattern78
	dw doofpattern74
	dw doofpattern3
	dw doofpattern75
	dw doofpattern76
	dw doofpattern77
	dw doofpattern1
	dw doofpattern1
	dw doofpattern79
	dw doofpattern80
	dw doofpattern81
	dw doofpattern82
	dw doofpattern83
	dw doofpattern84
	dw doofpattern1
	dw doofpattern1
	dw doofpattern85
	dw doofpattern86
	dw doofpattern48
	dw doofpattern87
	dw doofpattern83
	dw doofpattern84
	dw doofpattern1
	dw doofpattern1
	dw doofpattern88
	dw doofpattern89
	dw doofpattern90
	dw doofpattern91
	dw doofpattern92
	dw doofpattern93
	dw doofpattern1
	dw doofpattern1
	dw doofpattern94
	dw doofpattern95
	dw doofpattern96
	dw doofpattern97
	dw doofpattern92
	dw doofpattern93
	dw doofpattern1
	dw doofpattern1
	dw doofpattern98
	dw doofpattern99
	dw doofpattern100
	dw doofpattern101
	dw doofpattern102
	dw doofpattern103
	dw doofpattern1
	dw doofpattern1
	dw doofpattern104
	dw doofpattern105
	dw doofpattern93
	dw doofpattern106
	dw doofpattern102
	dw doofpattern103
	dw doofpattern1
	dw doofpattern1
	dw doofpattern107
	dw doofpattern99
	dw doofpattern100
	dw doofpattern101
	dw doofpattern102
	dw doofpattern103
	dw doofpattern1
	dw doofpattern1
	dw doofpattern104
	dw doofpattern67
	dw doofpattern68
	dw doofpattern69
	dw doofpattern70
	dw doofpattern71
	dw doofpattern1
	dw doofpattern1
	dw doofpattern108
	dw doofpattern109
	dw doofpattern109
	dw doofpattern109
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern110
	dw doofpattern111
	dw doofpattern111
	dw doofpattern1
	dw doofpattern17
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern112
	dw doofpattern109
	dw doofpattern109
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern110
	dw doofpattern111
	dw doofpattern111
	dw doofpattern1
	dw doofpattern17
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern113
	dw doofpattern114
	dw doofpattern115
	dw doofpattern116
	dw doofpattern117
	dw doofpattern118
	dw doofpattern119
	dw doofpattern117
	dw doofpattern120
	dw doofpattern61
	dw doofpattern60
	dw doofpattern121
	dw doofpattern122
	dw doofpattern63
	dw doofpattern123
	dw doofpattern124
	dw doofpattern113
	dw doofpattern114
	dw doofpattern115
	dw doofpattern116
	dw doofpattern125
	dw doofpattern126
	dw doofpattern127
	dw doofpattern63
	dw doofpattern120
	dw doofpattern61
	dw doofpattern60
	dw doofpattern121
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern128
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern128
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern128
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern129
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern128
	dw doofpattern130
	dw doofpattern131
	dw doofpattern132
	dw doofpattern133
	dw doofpattern1
	dw doofpattern134
	dw doofpattern1
	dw doofpattern135
	dw doofpattern1
	dw doofpattern136
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern137
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern138
	dw doofpattern138
	dw doofpattern138
	dw doofpattern138
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern129
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern128
	dw doofpattern130
	dw doofpattern59
dooforder2:
	dw $e100
	dw doofpattern140
	dw doofpattern141
	dw doofpattern31
	dw doofpattern1
	dw doofpattern142
	dw doofpattern143
	dw doofpattern144
	dw doofpattern145
	dw doofpattern146
	dw doofpattern141
	dw doofpattern31
	dw doofpattern1
	dw doofpattern147
	dw doofpattern143
	dw doofpattern144
	dw doofpattern148
	dw doofpattern149
	dw doofpattern150
	dw doofpattern151
	dw doofpattern1
	dw doofpattern152
	dw doofpattern153
	dw doofpattern154
	dw doofpattern155
	dw doofpattern156
	dw doofpattern150
	dw doofpattern151
	dw doofpattern1
	dw doofpattern157
	dw doofpattern153
	dw doofpattern154
	dw doofpattern158
	dw doofpattern159
	dw doofpattern160
	dw doofpattern161
	dw doofpattern12
	dw doofpattern162
	dw doofpattern163
	dw doofpattern164
	dw doofpattern165
	dw doofpattern166
	dw doofpattern160
	dw doofpattern161
	dw doofpattern1
	dw doofpattern162
	dw doofpattern163
	dw doofpattern164
	dw doofpattern167
	dw doofpattern168
	dw doofpattern169
	dw doofpattern170
	dw doofpattern17
	dw doofpattern171
	dw doofpattern163
	dw doofpattern172
	dw doofpattern173
	dw doofpattern174
	dw doofpattern169
	dw doofpattern170
	dw doofpattern1
	dw doofpattern171
	dw doofpattern163
	dw doofpattern172
	dw doofpattern175
	dw doofpattern176
	dw doofpattern177
	dw doofpattern178
	dw doofpattern12
	dw doofpattern179
	dw doofpattern130
	dw doofpattern128
	dw doofpattern180
	dw doofpattern181
	dw doofpattern177
	dw doofpattern178
	dw doofpattern1
	dw doofpattern179
	dw doofpattern130
	dw doofpattern128
	dw doofpattern182
	dw doofpattern183
	dw doofpattern177
	dw doofpattern178
	dw doofpattern12
	dw doofpattern179
	dw doofpattern130
	dw doofpattern128
	dw doofpattern180
	dw doofpattern184
	dw doofpattern185
	dw doofpattern186
	dw doofpattern1
	dw doofpattern187
	dw doofpattern188
	dw doofpattern144
	dw doofpattern189
	dw doofpattern190
	dw doofpattern191
	dw doofpattern191
	dw doofpattern192
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern193
	dw doofpattern194
	dw doofpattern194
	dw doofpattern195
	dw doofpattern1
	dw doofpattern1
	dw doofpattern196
	dw doofpattern1
	dw doofpattern190
	dw doofpattern191
	dw doofpattern191
	dw doofpattern192
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern193
	dw doofpattern194
	dw doofpattern194
	dw doofpattern195
	dw doofpattern1
	dw doofpattern1
	dw doofpattern196
	dw doofpattern1
	dw doofpattern197
	dw doofpattern198
	dw doofpattern199
	dw doofpattern200
	dw doofpattern200
	dw doofpattern198
	dw doofpattern199
	dw doofpattern200
	dw doofpattern201
	dw doofpattern202
	dw doofpattern203
	dw doofpattern201
	dw doofpattern201
	dw doofpattern202
	dw doofpattern203
	dw doofpattern201
	dw doofpattern197
	dw doofpattern198
	dw doofpattern199
	dw doofpattern200
	dw doofpattern200
	dw doofpattern198
	dw doofpattern199
	dw doofpattern200
	dw doofpattern201
	dw doofpattern202
	dw doofpattern203
	dw doofpattern201
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern129
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern204
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern164
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern172
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern164
	dw doofpattern204
	dw doofpattern205
	dw doofpattern206
	dw doofpattern206
	dw doofpattern207
	dw doofpattern208
	dw doofpattern209
	dw doofpattern209
	dw doofpattern209
	dw doofpattern210
	dw doofpattern211
	dw doofpattern212
	dw doofpattern212
	dw doofpattern213
	dw doofpattern213
	dw doofpattern213
	dw doofpattern213
	dw doofpattern214
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern77
	dw doofpattern1
	dw doofpattern1
	dw doofpattern1
	dw doofpattern172
	dw doofpattern1
	dw doofpattern1
	dw doofpattern59
	dw doofpattern1
	dw doofpattern1
	dw doofpattern164
	dw doofpattern204
	dw doofpattern59
dooforder3:
	dw $e100
	dw doofpattern187
	dw doofpattern143
	dw doofpattern215
	dw doofpattern216
	dw doofpattern153
	dw doofpattern129
	dw doofpattern217
	dw doofpattern218
	dw doofpattern187
	dw doofpattern143
	dw doofpattern215
	dw doofpattern216
	dw doofpattern153
	dw doofpattern129
	dw doofpattern217
	dw doofpattern219
	dw doofpattern220
	dw doofpattern153
	dw doofpattern221
	dw doofpattern222
	dw doofpattern223
	dw doofpattern204
	dw doofpattern224
	dw doofpattern225
	dw doofpattern220
	dw doofpattern153
	dw doofpattern221
	dw doofpattern222
	dw doofpattern223
	dw doofpattern226
	dw doofpattern224
	dw doofpattern227
	dw doofpattern162
	dw doofpattern163
	dw doofpattern228
	dw doofpattern229
	dw doofpattern163
	dw doofpattern130
	dw doofpattern230
	dw doofpattern231
	dw doofpattern162
	dw doofpattern163
	dw doofpattern228
	dw doofpattern229
	dw doofpattern163
	dw doofpattern130
	dw doofpattern230
	dw doofpattern232
	dw doofpattern171
	dw doofpattern163
	dw doofpattern233
	dw doofpattern234
	dw doofpattern163
	dw doofpattern235
	dw doofpattern236
	dw doofpattern237
	dw doofpattern171
	dw doofpattern163
	dw doofpattern233
	dw doofpattern234
	dw doofpattern163
	dw doofpattern235
	dw doofpattern236
	dw doofpattern238
	dw doofpattern179
	dw doofpattern130
	dw doofpattern239
	dw doofpattern240
	dw doofpattern130
	dw doofpattern241
	dw doofpattern242
	dw doofpattern243
	dw doofpattern179
	dw doofpattern130
	dw doofpattern239
	dw doofpattern240
	dw doofpattern130
	dw doofpattern241
	dw doofpattern242
	dw doofpattern244
	dw doofpattern179
	dw doofpattern130
	dw doofpattern239
	dw doofpattern240
	dw doofpattern130
	dw doofpattern241
	dw doofpattern242
	dw doofpattern243
	dw doofpattern245
	dw doofpattern188
	dw doofpattern215
	dw doofpattern246
	dw doofpattern247
	dw doofpattern248
	dw doofpattern249
	dw doofpattern219
	dw doofpattern250
	dw doofpattern251
	dw doofpattern252
	dw doofpattern250
	dw doofpattern250
	dw doofpattern251
	dw doofpattern252
	dw doofpattern250
	dw doofpattern253
	dw doofpattern254
	dw doofpattern255
	dw doofpattern253
	dw doofpattern253
	dw doofpattern254
	dw doofpattern255
	dw doofpattern253
	dw doofpattern250
	dw doofpattern251
	dw doofpattern252
	dw doofpattern250
	dw doofpattern250
	dw doofpattern251
	dw doofpattern252
	dw doofpattern250
	dw doofpattern253
	dw doofpattern254
	dw doofpattern255
	dw doofpattern253
	dw doofpattern253
	dw doofpattern254
	dw doofpattern255
	dw doofpattern253
	dw doofpattern250
	dw doofpattern251
	dw doofpattern252
	dw doofpattern250
	dw doofpattern250
	dw doofpattern251
	dw doofpattern252
	dw doofpattern250
	dw doofpattern253
	dw doofpattern254
	dw doofpattern255
	dw doofpattern253
	dw doofpattern253
	dw doofpattern254
	dw doofpattern255
	dw doofpattern253
	dw doofpattern250
	dw doofpattern251
	dw doofpattern252
	dw doofpattern250
	dw doofpattern250
	dw doofpattern251
	dw doofpattern252
	dw doofpattern250
	dw doofpattern253
	dw doofpattern254
	dw doofpattern255
	dw doofpattern253
	dw doofpattern253
	dw doofpattern254
	dw doofpattern256
	dw doofpattern257
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern258
	dw doofpattern258
	dw doofpattern259
	dw doofpattern259
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern259
	dw doofpattern259
	dw doofpattern258
	dw doofpattern258
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern259
	dw doofpattern259
	dw doofpattern259
	dw doofpattern259
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern260
	dw doofpattern260
	dw doofpattern260
	dw doofpattern260
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern139
	dw doofpattern59

doofpattern0:	db $47,$00,$4a,$00,$4e,$00,$51,$00,$e0
doofpattern1:	db $00,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern2:	db $4e,$00,$51,$00,$55,$00,$58,$00,$e0
doofpattern3:	db $53,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern4:	db $4c,$4e,$4c,$00,$5a,$5b,$5d,$00,$e0
doofpattern5:	db $58,$56,$55,$00,$58,$56,$55,$53,$e0
doofpattern6:	db $49,$00,$4c,$00,$50,$00,$53,$00,$e0
doofpattern7:	db $50,$00,$53,$00,$57,$00,$5a,$00,$e0
doofpattern8:	db $55,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern9:	db $4e,$50,$4e,$00,$5c,$5d,$5f,$00,$e0
doofpattern10:	db $5a,$58,$57,$00,$5a,$58,$57,$55,$e0
doofpattern11:	db $55,$00,$58,$00,$5c,$00,$5f,$00,$e0
doofpattern12:	db $02,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern13:	db $13,$15,$13,$00,$1f,$1f,$1f,$00,$e0
doofpattern14:	db $5a,$00,$02,$00,$00,$00,$00,$00,$e0
doofpattern15:	db $1f,$1d,$1c,$00,$1f,$1d,$1c,$1a,$e0
doofpattern16:	db $57,$00,$5a,$00,$5e,$00,$5f,$00,$e0
doofpattern17:	db $04,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern18:	db $15,$17,$15,$00,$1f,$1f,$1f,$00,$e0
doofpattern19:	db $5c,$00,$04,$00,$00,$00,$00,$00,$e0
doofpattern20:	db $1f,$1f,$1e,$00,$1f,$1f,$1e,$00,$e0
doofpattern21:	db $46,$00,$49,$00,$4d,$00,$50,$00,$e0
doofpattern22:	db $4d,$00,$50,$00,$54,$00,$55,$00,$e0
doofpattern23:	db $0b,$0d,$0b,$00,$15,$15,$15,$00,$e0
doofpattern24:	db $52,$00,$06,$00,$00,$00,$00,$00,$e0
doofpattern25:	db $15,$15,$14,$00,$15,$15,$14,$00,$e0
doofpattern26:	db $4e,$00,$51,$00,$55,$00,$56,$00,$e0
doofpattern27:	db $53,$00,$07,$00,$00,$00,$00,$00,$e0
doofpattern28:	db $16,$16,$15,$00,$16,$16,$15,$00,$e0
doofpattern29:	db $42,$42,$00,$00,$47,$00,$4c,$00,$e0
doofpattern30:	db $55,$00,$56,$00,$00,$00,$56,$56,$e0
doofpattern31:	db $56,$00,$53,$00,$51,$00,$53,$00,$e0
doofpattern32:	db $53,$00,$53,$00,$53,$00,$53,$00,$e0
doofpattern33:	db $56,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern34:	db $4a,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern35:	db $56,$56,$56,$00,$56,$56,$56,$55,$e0
doofpattern36:	db $57,$37,$00,$00,$2e,$2e,$00,$00,$e0
doofpattern37:	db $30,$04,$00,$00,$00,$00,$00,$00,$e0
doofpattern38:	db $03,$04,$05,$06,$07,$08,$09,$0a,$e0
doofpattern39:	db $2b,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern40:	db $42,$42,$00,$00,$00,$00,$00,$00,$e0
doofpattern41:	db $44,$24,$00,$00,$00,$00,$00,$00,$e0
doofpattern42:	db $23,$24,$25,$26,$27,$28,$29,$2a,$e0
doofpattern43:	db $29,$29,$09,$00,$09,$0a,$0b,$0c,$e0
doofpattern44:	db $2c,$2c,$0c,$00,$00,$00,$00,$4c,$e0
doofpattern45:	db $0a,$00,$00,$00,$00,$00,$00,$4a,$e0
doofpattern46:	db $49,$00,$00,$00,$00,$00,$00,$49,$e0
doofpattern47:	db $35,$35,$15,$00,$00,$00,$00,$55,$e0
doofpattern48:	db $58,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern49:	db $00,$2b,$2b,$0b,$00,$00,$0b,$0c,$e0
doofpattern50:	db $0d,$2e,$2e,$0e,$00,$2e,$2e,$00,$e0
doofpattern51:	db $4e,$0c,$00,$00,$00,$00,$00,$00,$e0
doofpattern52:	db $4c,$0b,$00,$00,$00,$00,$00,$4b,$e0
doofpattern53:	db $0b,$00,$00,$00,$00,$00,$00,$4b,$e0
doofpattern54:	db $0e,$00,$00,$00,$00,$00,$00,$4e,$e0
doofpattern55:	db $0c,$00,$00,$00,$00,$00,$00,$4c,$e0
doofpattern56:	db $0b,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern57:	db $35,$33,$15,$00,$00,$00,$00,$55,$e0
doofpattern58:	db $5d,$00,$00,$00,$00,$00,$5f,$5d,$e0
doofpattern59:	db $01,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern60:	db $05,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern61:	db $07,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern62:	db $5d,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern63:	db $15,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern64:	db $00,$00,$00,$00,$11,$10,$0f,$0c,$e0
doofpattern65:	db $0b,$0a,$07,$06,$05,$00,$00,$00,$e0
doofpattern66:	db $10,$00,$00,$00,$01,$00,$00,$00,$e0
doofpattern67:	db $00,$00,$47,$00,$4a,$00,$4e,$00,$e0
doofpattern68:	db $51,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern69:	db $00,$00,$47,$00,$4e,$00,$4f,$00,$e0
doofpattern70:	db $4e,$00,$4c,$00,$4a,$00,$4c,$00,$e0
doofpattern71:	db $47,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern72:	db $51,$53,$55,$00,$53,$55,$56,$00,$e0
doofpattern73:	db $55,$56,$55,$00,$55,$53,$55,$53,$e0
doofpattern74:	db $00,$00,$49,$00,$4c,$00,$50,$00,$e0
doofpattern75:	db $00,$00,$49,$00,$50,$00,$51,$00,$e0
doofpattern76:	db $50,$00,$4e,$00,$4c,$00,$4e,$00,$e0
doofpattern77:	db $49,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern78:	db $53,$55,$57,$00,$55,$57,$58,$00,$e0
doofpattern79:	db $57,$58,$57,$00,$57,$55,$57,$55,$e0
doofpattern80:	db $02,$00,$0e,$00,$11,$00,$15,$00,$e0
doofpattern81:	db $18,$00,$02,$00,$00,$00,$00,$00,$e0
doofpattern82:	db $00,$00,$0e,$00,$15,$00,$16,$00,$e0
doofpattern83:	db $55,$00,$53,$00,$51,$00,$53,$00,$e0
doofpattern84:	db $4e,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern85:	db $58,$5a,$5c,$00,$5a,$5c,$5d,$00,$e0
doofpattern86:	db $00,$00,$4e,$00,$51,$00,$55,$00,$e0
doofpattern87:	db $00,$00,$4e,$00,$55,$00,$56,$00,$e0
doofpattern88:	db $5c,$5d,$5c,$00,$5c,$5a,$5c,$5a,$e0
doofpattern89:	db $04,$00,$10,$00,$13,$00,$17,$00,$e0
doofpattern90:	db $1a,$00,$04,$00,$00,$00,$00,$00,$e0
doofpattern91:	db $00,$00,$10,$00,$17,$00,$18,$00,$e0
doofpattern92:	db $57,$00,$55,$00,$53,$00,$55,$00,$e0
doofpattern93:	db $50,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern94:	db $5a,$5c,$5e,$00,$5c,$5e,$5f,$00,$e0
doofpattern95:	db $00,$00,$50,$00,$53,$00,$57,$00,$e0
doofpattern96:	db $5a,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern97:	db $00,$00,$50,$00,$57,$00,$58,$00,$e0
doofpattern98:	db $5e,$5f,$5e,$00,$5e,$5c,$5e,$00,$e0
doofpattern99:	db $02,$00,$06,$00,$09,$00,$0d,$00,$e0
doofpattern100:	db $10,$00,$02,$00,$00,$00,$00,$00,$e0
doofpattern101:	db $00,$00,$06,$00,$0d,$00,$0e,$00,$e0
doofpattern102:	db $4d,$00,$4b,$00,$49,$00,$4b,$00,$e0
doofpattern103:	db $46,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern104:	db $50,$52,$54,$00,$52,$54,$55,$00,$e0
doofpattern105:	db $00,$00,$46,$00,$49,$00,$4d,$00,$e0
doofpattern106:	db $00,$00,$46,$00,$4d,$00,$4e,$00,$e0
doofpattern107:	db $54,$55,$54,$00,$54,$52,$54,$00,$e0
doofpattern108:	db $55,$56,$55,$00,$55,$53,$55,$00,$e0
doofpattern109:	db $02,$00,$00,$00,$0e,$00,$00,$00,$e0
doofpattern110:	db $04,$00,$00,$00,$0e,$00,$00,$00,$e0
doofpattern111:	db $04,$00,$00,$00,$10,$00,$00,$00,$e0
doofpattern112:	db $13,$00,$11,$00,$0e,$00,$00,$00,$e0
doofpattern113:	db $02,$00,$00,$00,$03,$04,$05,$06,$e0
doofpattern114:	db $05,$00,$00,$00,$00,$00,$00,$01,$e0
doofpattern115:	db $03,$00,$00,$00,$00,$00,$00,$01,$e0
doofpattern116:	db $02,$00,$00,$00,$00,$00,$00,$01,$e0
doofpattern117:	db $0e,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern118:	db $11,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern119:	db $0f,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern120:	db $04,$00,$00,$00,$00,$00,$05,$06,$e0
doofpattern121:	db $04,$00,$00,$00,$00,$00,$15,$16,$e0
doofpattern122:	db $17,$00,$00,$00,$00,$00,$18,$17,$e0
doofpattern123:	db $0f,$11,$00,$00,$00,$00,$13,$11,$e0
doofpattern124:	db $04,$00,$00,$00,$00,$00,$00,$01,$e0
doofpattern125:	db $0e,$0c,$0e,$00,$00,$00,$16,$17,$e0
doofpattern126:	db $18,$00,$00,$00,$00,$00,$1a,$18,$e0
doofpattern127:	db $16,$00,$00,$00,$00,$00,$18,$16,$e0
doofpattern128:	db $29,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern129:	db $2e,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern130:	db $35,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern131:	db $15,$09,$00,$00,$35,$09,$00,$00,$e0
doofpattern132:	db $15,$09,$00,$00,$15,$09,$00,$00,$e0
doofpattern133:	db $00,$09,$00,$00,$15,$09,$00,$00,$e0
doofpattern134:	db $3a,$00,$3c,$00,$00,$00,$00,$00,$e0
doofpattern135:	db $3c,$00,$3d,$00,$00,$00,$00,$00,$e0
doofpattern136:	db $09,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern137:	db $1c,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern138:	db $55,$49,$00,$00,$55,$49,$00,$00,$e0
doofpattern139:	db $15,$13,$10,$11,$15,$13,$10,$11,$e0
doofpattern140:	db $00,$00,$47,$00,$00,$00,$4c,$00,$e0
doofpattern141:	db $55,$00,$58,$00,$00,$00,$5a,$58,$e0
doofpattern142:	db $33,$00,$00,$00,$00,$00,$33,$00,$e0
doofpattern143:	db $38,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern144:	db $2a,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern145:	db $35,$36,$38,$00,$38,$3a,$3b,$00,$e0
doofpattern146:	db $47,$00,$00,$00,$47,$00,$4c,$00,$e0
doofpattern147:	db $33,$00,$00,$00,$33,$00,$33,$33,$e0
doofpattern148:	db $3a,$38,$3a,$00,$3a,$38,$36,$35,$e0
doofpattern149:	db $00,$00,$00,$00,$49,$00,$4e,$00,$e0
doofpattern150:	db $57,$00,$5a,$00,$00,$00,$5c,$5a,$e0
doofpattern151:	db $58,$00,$55,$00,$53,$00,$55,$00,$e0
doofpattern152:	db $35,$00,$35,$00,$00,$00,$35,$00,$e0
doofpattern153:	db $3a,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern154:	db $2c,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern155:	db $37,$38,$3a,$00,$3a,$3c,$3d,$00,$e0
doofpattern156:	db $49,$00,$00,$00,$49,$00,$4e,$00,$e0
doofpattern157:	db $35,$38,$3c,$3f,$33,$37,$3a,$3d,$e0
doofpattern158:	db $3c,$3a,$3c,$00,$3c,$3a,$38,$37,$e0
doofpattern159:	db $00,$00,$00,$00,$4e,$00,$53,$00,$e0
doofpattern160:	db $5c,$00,$5f,$00,$00,$00,$5f,$5f,$e0
doofpattern161:	db $5d,$00,$5a,$00,$58,$00,$5a,$00,$e0
doofpattern162:	db $3a,$00,$3a,$00,$3a,$00,$3a,$00,$e0
doofpattern163:	db $3f,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern164:	db $31,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern165:	db $3c,$3d,$3f,$00,$3f,$3f,$3f,$00,$e0
doofpattern166:	db $4e,$00,$00,$00,$4e,$00,$53,$00,$e0
doofpattern167:	db $3f,$3f,$3f,$00,$3f,$3f,$3d,$3c,$e0
doofpattern168:	db $00,$00,$00,$00,$50,$00,$55,$00,$e0
doofpattern169:	db $5e,$00,$5f,$00,$00,$00,$5f,$5f,$e0
doofpattern170:	db $5f,$00,$5c,$00,$5a,$00,$5c,$00,$e0
doofpattern171:	db $3c,$00,$3c,$00,$3c,$00,$3c,$00,$e0
doofpattern172:	db $33,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern173:	db $3e,$3f,$3f,$00,$3f,$3f,$3f,$00,$e0
doofpattern174:	db $50,$00,$00,$00,$50,$00,$55,$00,$e0
doofpattern175:	db $3f,$3f,$3f,$00,$3f,$3f,$3f,$3e,$e0
doofpattern176:	db $51,$00,$00,$00,$46,$00,$4b,$00,$e0
doofpattern177:	db $54,$00,$55,$00,$00,$00,$55,$55,$e0
doofpattern178:	db $55,$00,$52,$00,$50,$00,$52,$00,$e0
doofpattern179:	db $32,$00,$32,$00,$32,$00,$32,$00,$e0
doofpattern180:	db $34,$35,$35,$00,$35,$35,$35,$00,$e0
doofpattern181:	db $46,$00,$00,$00,$46,$00,$4b,$00,$e0
doofpattern182	db $35,$35,$35,$00,$35,$35,$35,$34,$e0
doofpattern183:	db $00,$00,$00,$00,$46,$00,$4b,$00,$e0
doofpattern184:	db $07,$00,$00,$00,$07,$00,$0c,$00,$e0
doofpattern185:	db $15,$00,$16,$00,$00,$00,$16,$16,$e0
doofpattern186:	db $16,$00,$13,$00,$11,$00,$13,$00,$e0
doofpattern187:	db $33,$00,$33,$00,$33,$00,$33,$00,$e0
doofpattern188:	db $36,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern189:	db $36,$36,$36,$00,$36,$36,$36,$35,$e0
doofpattern190:	db $0e,$01,$0e,$01,$0e,$00,$02,$00,$e0
doofpattern191:	db $0e,$00,$02,$00,$0e,$00,$02,$00,$e0
doofpattern192:	db $02,$00,$0e,$00,$02,$00,$0e,$00,$e0
doofpattern193:	db $10,$01,$10,$01,$10,$00,$04,$00,$e0
doofpattern194:	db $10,$00,$04,$00,$10,$00,$04,$00,$e0
doofpattern195:	db $04,$00,$10,$00,$04,$00,$10,$00,$e0
doofpattern196:	db $00,$00,$00,$00,$3a,$00,$30,$00,$e0
doofpattern197:	db $22,$00,$2e,$00,$22,$2e,$00,$38,$e0
doofpattern198:	db $25,$31,$00,$3d,$25,$31,$00,$3b,$e0
doofpattern199:	db $23,$2f,$00,$3b,$23,$2f,$00,$39,$e0
doofpattern200:	db $22,$2e,$00,$3a,$22,$2e,$00,$38,$e0
doofpattern201:	db $24,$30,$3c,$30,$24,$30,$3a,$30,$e0
doofpattern202:	db $27,$33,$3f,$33,$27,$33,$3d,$33,$e0
doofpattern203:	db $25,$31,$3d,$31,$25,$31,$3b,$31,$e0
doofpattern204:	db $30,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern205:	db $35,$3f,$3c,$3d,$15,$3f,$3c,$3d,$e0
doofpattern206:	db $35,$3f,$3c,$3d,$35,$3f,$3c,$3d,$e0
doofpattern207:	db $00,$00,$00,$00,$00,$39,$38,$37,$e0
doofpattern208:	db $36,$35,$33,$30,$31,$35,$33,$30,$e0
doofpattern209:	db $31,$35,$33,$30,$31,$35,$33,$30,$e0
doofpattern210:	db $15,$1f,$1c,$1d,$15,$1f,$1c,$1d,$e0
doofpattern211:	db $15,$1f,$1c,$00,$1c,$1f,$1c,$1d,$e0
doofpattern212:	db $1c,$1f,$1c,$1d,$1c,$1f,$1c,$1d,$e0
doofpattern213:	db $35,$3f,$3c,$31,$35,$3f,$3c,$31,$e0
doofpattern214:	db $15,$13,$11,$00,$00,$00,$00,$00,$e0
doofpattern215:	db $27,$00,$27,$00,$27,$00,$27,$00,$e0
doofpattern216:	db $3d,$38,$33,$38,$3d,$38,$33,$38,$e0
doofpattern217:	db $2f,$00,$00,$00,$2e,$00,$2c,$00,$e0
doofpattern218:	db $29,$2a,$2c,$00,$2c,$2e,$2f,$00,$e0
doofpattern219:	db $2e,$2c,$2e,$00,$2e,$2c,$2a,$29,$e0
doofpattern220:	db $35,$00,$35,$00,$35,$00,$35,$00,$e0
doofpattern221:	db $29,$00,$29,$00,$29,$00,$29,$00,$e0
doofpattern222:	db $3f,$3a,$35,$3a,$3f,$3a,$35,$3a,$e0
doofpattern223:	db $3c,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern224:	db $31,$00,$00,$00,$30,$00,$2e,$00,$e0
doofpattern225:	db $2b,$2c,$2e,$00,$2e,$30,$31,$00,$e0
doofpattern226:	db $2e,$31,$35,$38,$2e,$31,$35,$38,$e0
doofpattern227:	db $30,$2e,$30,$00,$30,$2e,$2c,$2b,$e0
doofpattern228:	db $2e,$00,$2e,$00,$2e,$00,$2e,$00,$e0
doofpattern229:	db $3f,$3f,$3a,$3f,$3f,$3f,$3a,$3f,$e0
doofpattern230:	db $36,$00,$00,$00,$35,$00,$33,$00,$e0
doofpattern231:	db $30,$31,$33,$00,$33,$35,$36,$00,$e0
doofpattern232:	db $35,$33,$35,$00,$35,$33,$31,$30,$e0
doofpattern233:	db $30,$00,$30,$00,$30,$00,$30,$00,$e0
doofpattern234:	db $3f,$3f,$3c,$3f,$3f,$3f,$3c,$3f,$e0
doofpattern235:	db $37,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern236:	db $38,$00,$00,$00,$37,$00,$35,$00,$e0
doofpattern237:	db $32,$33,$35,$00,$35,$37,$38,$00,$e0
doofpattern238:	db $37,$35,$37,$00,$37,$35,$33,$32,$e0
doofpattern239:	db $26,$00,$26,$00,$26,$00,$26,$00,$e0
doofpattern240:	db $35,$35,$32,$35,$35,$35,$32,$35,$e0
doofpattern241:	db $2d,$00,$00,$00,$00,$00,$00,$00,$e0
doofpattern242:	db $2e,$00,$00,$00,$2d,$00,$2b,$00,$e0
doofpattern243:	db $28,$29,$2b,$00,$2b,$2d,$2e,$00,$e0
doofpattern244:	db $2d,$2b,$2d,$00,$2d,$2b,$29,$28,$e0
doofpattern245:	db $3f,$00,$3a,$00,$36,$00,$33,$00,$e0
doofpattern246:	db $36,$36,$33,$36,$36,$36,$33,$36,$e0
doofpattern247:	db $5f,$00,$5a,$00,$58,$00,$56,$00,$e0
doofpattern248:	db $5d,$00,$5a,$00,$56,$00,$53,$00,$e0
doofpattern249:	db $5a,$00,$56,$00,$53,$00,$4e,$00,$e0
doofpattern250:	db $3a,$00,$35,$00,$31,$00,$35,$00,$e0
doofpattern251:	db $3d,$00,$35,$00,$31,$00,$35,$00,$e0
doofpattern252:	db $3b,$00,$35,$00,$31,$00,$35,$00,$e0
doofpattern253:	db $3c,$00,$37,$00,$33,$00,$37,$00,$e0
doofpattern254:	db $3f,$00,$37,$00,$33,$00,$37,$00,$e0
doofpattern255:	db $3d,$00,$37,$00,$33,$00,$37,$00,$e0
doofpattern256:	db $3d,$01,$37,$01,$33,$01,$37,$01,$e0
doofpattern257:	db $3c,$01,$37,$01,$53,$53,$57,$57,$e0
doofpattern258:	db $55,$53,$50,$51,$55,$53,$50,$51,$e0
doofpattern259:	db $35,$33,$30,$31,$35,$33,$30,$31,$e0
doofpattern260:	db $1a,$18,$15,$16,$1a,$18,$15,$16,$e0



end

