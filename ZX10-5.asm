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
;	ld 	hl,musicData4
	ld 	hl,musicData5



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
; SONG : GALAXY. By Utz.
; -------------------------------
musicData5
	db $06
	dw galorder0
	dw galorder1
	dw galorder2
	dw galorder3

galorder0
	dw $e600
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern1
	dw galpattern2
	dw galpattern0
	dw galpattern3
	dw galpattern4
	dw galpattern0
	dw galpattern0
	dw galpattern5
	dw galpattern1
	dw galpattern2
	dw galpattern0
	dw galpattern0
	dw galpattern6
	dw galpattern7
	dw galpattern0
	dw galpattern5
	dw galpattern1
	dw galpattern2
	dw galpattern0
	dw galpattern3
	dw galpattern4
	dw galpattern0
	dw galpattern0
	dw galpattern5
	dw galpattern1
	dw galpattern2
	dw galpattern0
	dw galpattern0
	dw galpattern6
	dw galpattern7
	dw galpattern0
	dw galpattern3
	dw galpattern6
	dw galpattern6
	dw galpattern6
	dw galpattern6
	dw galpattern6
	dw galpattern6
	dw galpattern6
	dw galpattern6
	dw galpattern8
	dw galpattern8
	dw galpattern8
	dw galpattern8
	dw galpattern8
	dw galpattern8
	dw galpattern8
	dw galpattern9
	dw galpattern6
	dw galpattern6
	dw galpattern6
	dw galpattern6
	dw galpattern6
	dw galpattern6
	dw galpattern6
	dw galpattern6
	dw galpattern10
	dw galpattern10
	dw galpattern10
	dw galpattern10
	dw galpattern10
	dw galpattern10
	dw galpattern11
	dw galpattern12
	dw galpattern13
	dw galpattern14
	dw galpattern15
	dw galpattern16
	dw galpattern16
	dw galpattern17
	dw galpattern18
	dw galpattern19
	dw galpattern20
	dw galpattern21
	dw galpattern22
	dw galpattern15
	dw galpattern13
	dw galpattern23
	dw galpattern23
	dw galpattern24
	dw galpattern19
	dw galpattern17
	dw galpattern25
	dw galpattern26
	dw galpattern27
	dw galpattern13
	dw galpattern14
	dw galpattern15
	dw galpattern16
	dw galpattern16
	dw galpattern17
	dw galpattern18
	dw galpattern19
	dw galpattern20
	dw galpattern21
	dw galpattern22
	dw galpattern15
	dw galpattern13
	dw galpattern23
	dw galpattern23
	dw galpattern24
	dw galpattern19
	dw galpattern17
	dw galpattern25
	dw galpattern26
	dw galpattern27
	dw galpattern13
	dw galpattern14
	dw galpattern15
	dw galpattern16
	dw galpattern13
	dw galpattern14
	dw galpattern15
	dw galpattern16
	dw galpattern16
	dw galpattern17
	dw galpattern18
	dw galpattern19
	dw galpattern20
	dw galpattern21
	dw galpattern22
	dw galpattern15
	dw galpattern13
	dw galpattern23
	dw galpattern23
	dw galpattern24
	dw galpattern19
	dw galpattern17
	dw galpattern25
	dw galpattern26
	dw galpattern27
	dw galpattern28
	dw galpattern29
	dw galpattern30
	dw galpattern31
	dw galpattern28
	dw galpattern29
	dw galpattern30
	dw galpattern31
	dw galpattern32
	dw galpattern0
	dw galpattern33
	dw galpattern34
	dw galpattern35
	dw galpattern36
	dw galpattern36
	dw galpattern37
	dw galpattern38
	dw galpattern39
	dw galpattern40
	dw galpattern40
	dw galpattern41
	dw galpattern42
	dw galpattern43
	dw galpattern44
	dw galpattern44
	dw galpattern37
	dw galpattern38
	dw galpattern39
	dw galpattern40
	dw galpattern40
	dw galpattern45
	dw galpattern46
	dw galpattern47
	dw galpattern48
	dw galpattern48
	dw galpattern49
	dw galpattern38
	dw galpattern39
	dw galpattern40
	dw galpattern40
	dw galpattern41
	dw galpattern42
	dw galpattern43
	dw galpattern44
	dw galpattern44
	dw galpattern37
	dw galpattern38
	dw galpattern39
	dw galpattern40
	dw galpattern40
	dw galpattern45
	dw galpattern46
	dw galpattern47
	dw galpattern48
	dw galpattern48
	dw galpattern49
	dw galpattern38
	dw galpattern39
	dw galpattern40
	dw galpattern40
	dw galpattern41
	dw galpattern42
	dw galpattern43
	dw galpattern44
	dw galpattern44
	dw galpattern37
	dw galpattern38
	dw galpattern39
	dw galpattern40
	dw galpattern40
	dw galpattern50
	dw galpattern34
	dw galpattern35
	dw galpattern36
	dw galpattern36
	dw galpattern37
	dw galpattern38
	dw galpattern39
	dw galpattern40
	dw galpattern40
	dw galpattern41
	dw galpattern42
	dw galpattern43
	dw galpattern44
	dw galpattern44
	dw galpattern37
	dw galpattern38
	dw galpattern39
	dw galpattern40
	dw galpattern40
	dw galpattern51
	dw galpattern52
	dw galpattern53
	dw galpattern54
	dw galpattern0
	dw galpattern2
galorder1
	dw $e600
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern55
	dw galpattern56
	dw galpattern56
	dw galpattern56
	dw galpattern57
	dw galpattern57
	dw galpattern57
	dw galpattern57
	dw galpattern58
	dw galpattern58
	dw galpattern58
	dw galpattern58
	dw galpattern57
	dw galpattern57
	dw galpattern57
	dw galpattern57
	dw galpattern59
	dw galpattern60
	dw galpattern61
	dw galpattern62
	dw galpattern63
	dw galpattern63
	dw galpattern64
	dw galpattern65
	dw galpattern66
	dw galpattern66
	dw galpattern66
	dw galpattern67
	dw galpattern68
	dw galpattern68
	dw galpattern64
	dw galpattern69
	dw galpattern59
	dw galpattern60
	dw galpattern61
	dw galpattern62
	dw galpattern63
	dw galpattern63
	dw galpattern64
	dw galpattern65
	dw galpattern66
	dw galpattern66
	dw galpattern66
	dw galpattern67
	dw galpattern68
	dw galpattern68
	dw galpattern64
	dw galpattern69
	dw galpattern59
	dw galpattern60
	dw galpattern61
	dw galpattern62
	dw galpattern63
	dw galpattern63
	dw galpattern64
	dw galpattern65
	dw galpattern66
	dw galpattern66
	dw galpattern66
	dw galpattern67
	dw galpattern68
	dw galpattern68
	dw galpattern70
	dw galpattern71
	dw galpattern72
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern73
	dw galpattern0
	dw galpattern0
	dw galpattern74
	dw galpattern0
	dw galpattern75
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern76
	dw galpattern0
	dw galpattern0
	dw galpattern77
	dw galpattern0
	dw galpattern0
	dw galpattern72
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern73
	dw galpattern0
	dw galpattern0
	dw galpattern74
	dw galpattern0
	dw galpattern75
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern76
	dw galpattern0
	dw galpattern0
	dw galpattern77
	dw galpattern0
	dw galpattern0
	dw galpattern78
	dw galpattern79
	dw galpattern80
	dw galpattern81
	dw galpattern78
	dw galpattern79
	dw galpattern80
	dw galpattern81
	dw galpattern82
	dw galpattern83
	dw galpattern84
	dw galpattern85
	dw galpattern86
	dw galpattern87
	dw galpattern88
	dw galpattern89
	dw galpattern78
	dw galpattern90
	dw galpattern90
	dw galpattern91
	dw galpattern92
	dw galpattern93
	dw galpattern94
	dw galpattern95
	dw galpattern96
	dw galpattern97
	dw galpattern0
	dw galpattern98
	dw galpattern0
	dw galpattern97
	dw galpattern0
	dw galpattern98
	dw galpattern0
	dw galpattern99
	dw galpattern0
	dw galpattern100
	dw galpattern101
	dw galpattern102
	dw galpattern103
	dw galpattern103
	dw galpattern104
	dw galpattern101
	dw galpattern102
	dw galpattern103
	dw galpattern103
	dw galpattern104
	dw galpattern101
	dw galpattern102
	dw galpattern103
	dw galpattern103
	dw galpattern104
	dw galpattern101
	dw galpattern102
	dw galpattern103
	dw galpattern103
	dw galpattern105
	dw galpattern106
	dw galpattern74
	dw galpattern0
	dw galpattern0
	dw galpattern107
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern108
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern109
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern52
	dw galpattern106
	dw galpattern74
	dw galpattern0
	dw galpattern0
	dw galpattern107
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern108
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern109
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern52
	dw galpattern106
	dw galpattern74
	dw galpattern0
	dw galpattern0
	dw galpattern107
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern108
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern109
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern110
	dw galpattern111
	dw galpattern112
	dw galpattern113
	dw galpattern110
	dw galpattern0
galorder2
	dw $e600
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern114
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern115
	dw galpattern116
	dw galpattern117
	dw galpattern118
	dw galpattern119
	dw galpattern120
	dw galpattern120
	dw galpattern121
	dw galpattern122
	dw galpattern120
	dw galpattern120
	dw galpattern120
	dw galpattern123
	dw galpattern124
	dw galpattern125
	dw galpattern121
	dw galpattern126
	dw galpattern127
	dw galpattern128
	dw galpattern129
	dw galpattern130
	dw galpattern131
	dw galpattern131
	dw galpattern132
	dw galpattern133
	dw galpattern134
	dw galpattern134
	dw galpattern135
	dw galpattern136
	dw galpattern137
	dw galpattern138
	dw galpattern139
	dw galpattern140
	dw galpattern141
	dw galpattern142
	dw galpattern143
	dw galpattern144
	dw galpattern131
	dw galpattern131
	dw galpattern132
	dw galpattern133
	dw galpattern134
	dw galpattern134
	dw galpattern135
	dw galpattern136
	dw galpattern137
	dw galpattern138
	dw galpattern145
	dw galpattern146
	dw galpattern147
	dw galpattern148
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern149
	dw galpattern150
	dw galpattern151
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern152
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern153
	dw galpattern0
	dw galpattern147
	dw galpattern148
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern149
	dw galpattern150
	dw galpattern151
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern154
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern153
	dw galpattern0
	dw galpattern13
	dw galpattern14
	dw galpattern15
	dw galpattern16
	dw galpattern13
	dw galpattern14
	dw galpattern15
	dw galpattern16
	dw galpattern16
	dw galpattern17
	dw galpattern18
	dw galpattern19
	dw galpattern20
	dw galpattern21
	dw galpattern155
	dw galpattern156
	dw galpattern156
	dw galpattern156
	dw galpattern156
	dw galpattern157
	dw galpattern158
	dw galpattern158
	dw galpattern159
	dw galpattern160
	dw galpattern160
	dw galpattern161
	dw galpattern0
	dw galpattern162
	dw galpattern0
	dw galpattern161
	dw galpattern0
	dw galpattern162
	dw galpattern163
	dw galpattern164
	dw galpattern0
	dw galpattern165
	dw galpattern166
	dw galpattern167
	dw galpattern168
	dw galpattern168
	dw galpattern169
	dw galpattern166
	dw galpattern167
	dw galpattern168
	dw galpattern168
	dw galpattern169
	dw galpattern166
	dw galpattern167
	dw galpattern168
	dw galpattern168
	dw galpattern169
	dw galpattern166
	dw galpattern167
	dw galpattern168
	dw galpattern168
	dw galpattern170
	dw galpattern171
	dw galpattern172
	dw galpattern173
	dw galpattern173
	dw galpattern174
	dw galpattern166
	dw galpattern167
	dw galpattern168
	dw galpattern168
	dw galpattern169
	dw galpattern166
	dw galpattern167
	dw galpattern168
	dw galpattern168
	dw galpattern169
	dw galpattern166
	dw galpattern167
	dw galpattern168
	dw galpattern168
	dw galpattern175
	dw galpattern176
	dw galpattern177
	dw galpattern178
	dw galpattern178
	dw galpattern179
	dw galpattern180
	dw galpattern181
	dw galpattern182
	dw galpattern183
	dw galpattern184
	dw galpattern185
	dw galpattern186
	dw galpattern182
	dw galpattern183
	dw galpattern187
	dw galpattern188
	dw galpattern189
	dw galpattern190
	dw galpattern191
	dw galpattern192
	dw galpattern193
	dw galpattern194
	dw galpattern178
	dw galpattern178
	dw galpattern195
	dw galpattern196
	dw galpattern197
	dw galpattern198
	dw galpattern199
	dw galpattern200
	dw galpattern201
	dw galpattern202
	dw galpattern203
	dw galpattern197
	dw galpattern204
	dw galpattern205
	dw galpattern206
	dw galpattern207
	dw galpattern191
	dw galpattern208
	dw galpattern209
	dw galpattern210
	dw galpattern211
	dw galpattern212
	dw galpattern0
galorder3
	dw $e600
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern213
	dw galpattern214
	dw galpattern215
	dw galpattern215
	dw galpattern215
	dw galpattern215
	dw galpattern215
	dw galpattern215
	dw galpattern215
	dw galpattern215
	dw galpattern215
	dw galpattern215
	dw galpattern215
	dw galpattern215
	dw galpattern215
	dw galpattern215
	dw galpattern216
	dw galpattern217
	dw galpattern218
	dw galpattern219
	dw galpattern220
	dw galpattern220
	dw galpattern221
	dw galpattern221
	dw galpattern220
	dw galpattern220
	dw galpattern220
	dw galpattern222
	dw galpattern223
	dw galpattern223
	dw galpattern221
	dw galpattern224
	dw galpattern225
	dw galpattern226
	dw galpattern218
	dw galpattern219
	dw galpattern227
	dw galpattern227
	dw galpattern228
	dw galpattern228
	dw galpattern227
	dw galpattern227
	dw galpattern227
	dw galpattern229
	dw galpattern230
	dw galpattern230
	dw galpattern228
	dw galpattern231
	dw galpattern232
	dw galpattern233
	dw galpattern234
	dw galpattern235
	dw galpattern220
	dw galpattern220
	dw galpattern221
	dw galpattern221
	dw galpattern220
	dw galpattern220
	dw galpattern220
	dw galpattern222
	dw galpattern223
	dw galpattern223
	dw galpattern236
	dw galpattern237
	dw galpattern238
	dw galpattern239
	dw galpattern0
	dw galpattern0
	dw galpattern240
	dw galpattern241
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern242
	dw galpattern243
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern244
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern245
	dw galpattern0
	dw galpattern238
	dw galpattern239
	dw galpattern0
	dw galpattern0
	dw galpattern240
	dw galpattern241
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern242
	dw galpattern243
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern244
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern245
	dw galpattern0
	dw galpattern246
	dw galpattern246
	dw galpattern246
	dw galpattern246
	dw galpattern246
	dw galpattern246
	dw galpattern246
	dw galpattern246
	dw galpattern246
	dw galpattern247
	dw galpattern247
	dw galpattern247
	dw galpattern248
	dw galpattern248
	dw galpattern249
	dw galpattern250
	dw galpattern250
	dw galpattern250
	dw galpattern250
	dw galpattern251
	dw galpattern252
	dw galpattern252
	dw galpattern253
	dw galpattern254
	dw galpattern254
	dw galpattern28
	dw galpattern29
	dw galpattern30
	dw galpattern31
	dw galpattern28
	dw galpattern29
	dw galpattern30
	dw galpattern31
	dw galpattern255
	dw galpattern256
	dw galpattern257
	dw galpattern258
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern259
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern260
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern259
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern52
	dw galpattern106
	dw galpattern74
	dw galpattern0
	dw galpattern0
	dw galpattern261
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern262
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern261
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern52
	dw galpattern106
	dw galpattern74
	dw galpattern0
	dw galpattern0
	dw galpattern261
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern262
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern261
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern263
	dw galpattern106
	dw galpattern74
	dw galpattern0
	dw galpattern0
	dw galpattern261
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern262
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern261
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern0
	dw galpattern110
	dw galpattern264
	dw galpattern265
	dw galpattern266
	dw galpattern267
	dw galpattern2

galpattern0
	db $00,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern1
	db $07,$47,$07,$47,$13,$53,$00,$00,$e0
galpattern2
	db $01,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern3
	db $00,$00,$00,$00,$13,$53,$13,$53,$e0
galpattern4
	db $07,$47,$07,$47,$00,$00,$01,$00,$e0
galpattern5
	db $00,$00,$00,$00,$00,$00,$13,$53,$e0
galpattern6
	db $07,$47,$07,$47,$13,$53,$13,$53,$e0
galpattern7
	db $00,$00,$01,$00,$00,$00,$00,$00,$e0
galpattern8
	db $05,$45,$05,$45,$11,$51,$11,$51,$e0
galpattern9
	db $05,$45,$05,$45,$11,$51,$11,$11,$e0
galpattern10
	db $02,$42,$02,$42,$0e,$4e,$0e,$4e,$e0
galpattern11
	db $02,$42,$02,$42,$45,$00,$00,$01,$e0
galpattern12
	db $44,$00,$00,$01,$43,$00,$00,$01,$e0
galpattern13
	db $02,$00,$00,$00,$0e,$00,$00,$00,$e0
galpattern14
	db $13,$00,$15,$00,$02,$00,$00,$00,$e0
galpattern15
	db $0e,$00,$00,$00,$13,$00,$15,$00,$e0
galpattern16
	db $02,$00,$0e,$00,$13,$00,$15,$00,$e0
galpattern17
	db $05,$00,$00,$00,$11,$00,$00,$00,$e0
galpattern18
	db $15,$00,$16,$00,$05,$00,$00,$00,$e0
galpattern19
	db $11,$00,$00,$00,$15,$00,$16,$00,$e0
galpattern20
	db $03,$00,$00,$00,$0f,$00,$00,$00,$e0
galpattern21
	db $15,$00,$16,$00,$03,$00,$0f,$00,$e0
galpattern22
	db $15,$00,$16,$00,$02,$00,$00,$00,$e0
galpattern23
	db $13,$00,$15,$00,$02,$00,$0e,$00,$e0
galpattern24
	db $13,$00,$15,$00,$05,$00,$00,$00,$e0
galpattern25
	db $15,$00,$16,$00,$03,$00,$00,$00,$e0
galpattern26
	db $0f,$00,$00,$00,$15,$00,$16,$00,$e0
galpattern27
	db $03,$00,$0f,$00,$15,$00,$16,$00,$e0
galpattern28
	db $1f,$1c,$18,$15,$18,$15,$10,$0c,$e0
galpattern29
	db $10,$0c,$09,$05,$04,$00,$00,$00,$e0
galpattern30
	db $03,$07,$0a,$0e,$0a,$0e,$11,$15,$e0
galpattern31
	db $11,$15,$18,$1c,$1d,$00,$00,$00,$e0
galpattern32
	db $3d,$00,$00,$00,$5d,$00,$00,$00,$e0
galpattern33
	db $00,$00,$5c,$5b,$5a,$00,$00,$00,$e0
galpattern34
	db $5a,$00,$00,$00,$5f,$00,$55,$00,$e0
galpattern35
	db $5a,$00,$00,$00,$5a,$00,$00,$00,$e0
galpattern36
	db $5f,$00,$55,$00,$5a,$00,$5a,$00,$e0
galpattern37
	db $5f,$00,$55,$00,$58,$00,$00,$00,$e0
galpattern38
	db $58,$00,$00,$00,$5f,$00,$55,$00,$e0
galpattern39
	db $58,$00,$00,$00,$58,$00,$00,$00,$e0
galpattern40
	db $5f,$00,$55,$00,$58,$00,$58,$00,$e0
galpattern41
	db $5f,$00,$55,$00,$4a,$00,$00,$00,$e0
galpattern42
	db $4a,$00,$00,$00,$5f,$00,$55,$00,$e0
galpattern43
	db $4a,$00,$00,$00,$4a,$00,$00,$00,$e0
galpattern44
	db $5f,$00,$55,$00,$4a,$00,$4a,$00,$e0
galpattern45
	db $5f,$00,$55,$00,$3a,$00,$00,$00,$e0
galpattern46
	db $3a,$00,$00,$00,$3f,$00,$35,$00,$e0
galpattern47
	db $3a,$00,$00,$00,$3a,$00,$00,$00,$e0
galpattern48
	db $3f,$00,$35,$00,$3a,$00,$3a,$00,$e0
galpattern49
	db $3f,$00,$35,$00,$58,$00,$00,$00,$e0
galpattern50
	db $5f,$00,$55,$00,$5a,$00,$00,$00,$e0
galpattern51
	db $5f,$00,$55,$00,$00,$00,$01,$00,$e0
galpattern52
	db $00,$00,$00,$00,$07,$00,$00,$00,$e0
galpattern53
	db $13,$00,$00,$00,$00,$33,$00,$00,$e0
galpattern54
	db $00,$00,$53,$00,$00,$00,$00,$00,$e0
galpattern55
	db $00,$36,$00,$00,$01,$36,$00,$00,$e0
galpattern56
	db $01,$36,$00,$00,$01,$36,$00,$00,$e0
galpattern57
	db $01,$35,$00,$00,$01,$35,$00,$00,$e0
galpattern58
	db $01,$33,$00,$00,$01,$33,$00,$00,$e0
galpattern59
	db $13,$36,$00,$00,$13,$36,$00,$00,$e0
galpattern60
	db $13,$36,$00,$00,$15,$36,$00,$00,$e0
galpattern61
	db $1a,$36,$00,$00,$1a,$36,$00,$00,$e0
galpattern62
	db $1a,$36,$00,$00,$11,$36,$00,$00,$e0
galpattern63
	db $11,$35,$00,$00,$11,$35,$00,$00,$e0
galpattern64
	db $18,$35,$00,$00,$18,$35,$00,$00,$e0
galpattern65
	db $18,$35,$00,$00,$1a,$35,$00,$00,$e0
galpattern66
	db $11,$33,$00,$00,$11,$33,$00,$00,$e0
galpattern67
	db $11,$33,$00,$00,$13,$33,$00,$00,$e0
galpattern68
	db $15,$35,$00,$00,$15,$35,$00,$00,$e0
galpattern69
	db $18,$35,$00,$00,$16,$35,$00,$00,$e0
galpattern70
	db $18,$35,$00,$00,$31,$00,$00,$01,$e0
galpattern71
	db $30,$00,$00,$01,$2f,$00,$00,$01,$e0
galpattern72
	db $2e,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern73
	db $31,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern74
	db $13,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern75
	db $00,$00,$00,$00,$2e,$00,$00,$00,$e0
galpattern76
	db $00,$00,$00,$00,$31,$00,$00,$00,$e0
galpattern77
	db $00,$00,$00,$00,$13,$00,$00,$00,$e0
galpattern78
	db $0e,$00,$00,$00,$1a,$00,$00,$00,$e0
galpattern79
	db $1f,$00,$1f,$00,$2e,$00,$00,$00,$e0
galpattern80
	db $3a,$00,$00,$00,$3f,$00,$3f,$00,$e0
galpattern81
	db $0e,$00,$1a,$00,$1f,$00,$1f,$00,$e0
galpattern82
	db $0e,$00,$1a,$00,$3f,$00,$3f,$00,$e0
galpattern83
	db $31,$00,$00,$00,$3d,$00,$00,$00,$e0
galpattern84
	db $5f,$00,$5f,$00,$51,$00,$00,$00,$e0
galpattern85
	db $5d,$00,$00,$00,$3f,$00,$3f,$00,$e0
galpattern86
	db $2f,$00,$00,$00,$3b,$00,$00,$00,$e0
galpattern87
	db $1f,$00,$1f,$00,$0f,$00,$1b,$00,$e0
galpattern88
	db $1f,$00,$1f,$00,$0e,$00,$00,$00,$e0
galpattern89
	db $1a,$00,$00,$00,$1f,$00,$1f,$00,$e0
galpattern90
	db $1f,$00,$1f,$00,$0e,$00,$1a,$00,$e0
galpattern91
	db $1f,$00,$1f,$00,$11,$00,$00,$00,$e0
galpattern92
	db $1d,$00,$00,$00,$1f,$00,$1f,$00,$e0
galpattern93
	db $11,$00,$00,$00,$1d,$00,$00,$00,$e0
galpattern94
	db $1f,$00,$1f,$00,$0f,$00,$00,$00,$e0
galpattern95
	db $1b,$00,$00,$00,$1f,$00,$1f,$00,$e0
galpattern96
	db $0f,$00,$1b,$00,$1f,$00,$1f,$00,$e0
galpattern97
	db $09,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern98
	db $07,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern99
	db $00,$00,$27,$00,$00,$00,$47,$00,$e0
galpattern100
	db $00,$00,$00,$00,$53,$00,$00,$00,$e0
galpattern101
	db $53,$00,$00,$00,$56,$00,$51,$00,$e0
galpattern102
	db $53,$00,$00,$00,$53,$00,$00,$00,$e0
galpattern103
	db $56,$00,$51,$00,$53,$00,$53,$00,$e0
galpattern104
	db $56,$00,$51,$00,$53,$00,$00,$00,$e0
galpattern105
	db $56,$00,$51,$00,$07,$00,$00,$00,$e0
galpattern106
	db $07,$00,$08,$09,$0c,$10,$11,$12,$e0
galpattern107
	db $00,$00,$00,$00,$15,$00,$00,$00,$e0
galpattern108
	db $00,$00,$00,$00,$16,$00,$00,$00,$e0
galpattern109
	db $00,$00,$00,$00,$0c,$00,$00,$00,$e0
galpattern110
	db $00,$00,$00,$00,$00,$00,$01,$00,$e0
galpattern111
	db $00,$00,$00,$00,$00,$0a,$00,$00,$e0
galpattern112
	db $00,$16,$00,$00,$00,$00,$36,$00,$e0
galpattern113
	db $00,$00,$00,$56,$00,$00,$00,$00,$e0
galpattern114
	db $00,$00,$3a,$00,$3a,$01,$3a,$00,$e0
galpattern115
	db $3a,$01,$3a,$00,$3a,$01,$3a,$00,$e0
galpattern116
	db $00,$13,$3a,$00,$00,$13,$3a,$00,$e0
galpattern117
	db $00,$13,$3a,$00,$00,$16,$3a,$00,$e0
galpattern118
	db $00,$1a,$3a,$00,$00,$1a,$3a,$00,$e0
galpattern119
	db $00,$1a,$3a,$00,$00,$11,$3a,$00,$e0
galpattern120
	db $00,$11,$3a,$00,$00,$11,$3a,$00,$e0
galpattern121
	db $00,$18,$3a,$00,$00,$18,$3a,$00,$e0
galpattern122
	db $00,$18,$3a,$00,$00,$1a,$3a,$00,$e0
galpattern123
	db $00,$11,$3a,$00,$00,$15,$3a,$00,$e0
galpattern124
	db $38,$15,$3a,$00,$00,$15,$3a,$00,$e0
galpattern125
	db $00,$15,$3a,$00,$00,$15,$3a,$00,$e0
galpattern126
	db $00,$18,$3a,$00,$00,$16,$3a,$00,$e0
galpattern127
	db $01,$13,$0e,$00,$00,$13,$0e,$00,$e0
galpattern128
	db $00,$13,$0e,$00,$0f,$11,$12,$00,$e0
galpattern129
	db $13,$1a,$13,$00,$00,$1a,$13,$00,$e0
galpattern130
	db $00,$1a,$13,$00,$00,$11,$13,$00,$e0
galpattern131
	db $00,$11,$15,$00,$00,$11,$15,$00,$e0
galpattern132
	db $00,$18,$11,$00,$00,$18,$11,$00,$e0
galpattern133
	db $00,$18,$11,$00,$00,$1a,$11,$00,$e0
galpattern134
	db $00,$11,$11,$00,$00,$11,$11,$00,$e0
galpattern135
	db $00,$11,$31,$00,$00,$11,$31,$00,$e0
galpattern136
	db $00,$11,$31,$00,$00,$15,$31,$00,$e0
galpattern137
	db $38,$15,$31,$00,$00,$15,$31,$00,$e0
galpattern138
	db $00,$15,$31,$00,$00,$15,$31,$00,$e0
galpattern139
	db $00,$18,$31,$00,$00,$18,$31,$00,$e0
galpattern140
	db $00,$18,$31,$00,$00,$16,$31,$00,$e0
galpattern141
	db $01,$13,$3a,$00,$00,$13,$3a,$00,$e0
galpattern142
	db $00,$13,$3a,$00,$2f,$11,$3a,$00,$e0
galpattern143
	db $33,$1a,$3a,$00,$00,$1a,$3a,$00,$e0
galpattern144
	db $00,$0e,$2e,$2f,$00,$11,$35,$00,$e0
galpattern145
	db $00,$1a,$31,$00,$3d,$00,$00,$01,$e0
galpattern146
	db $3c,$00,$00,$01,$3b,$00,$00,$01,$e0
galpattern147
	db $33,$00,$00,$00,$01,$00,$33,$36,$e0
galpattern148
	db $38,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern149
	db $3a,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern150
	db $00,$00,$00,$00,$33,$00,$00,$00,$e0
galpattern151
	db $01,$00,$33,$36,$38,$00,$00,$00,$e0
galpattern152
	db $36,$00,$35,$00,$33,$35,$33,$00,$e0
galpattern153
	db $00,$00,$00,$00,$3a,$00,$00,$00,$e0
galpattern154
	db $36,$00,$35,$00,$36,$38,$36,$00,$e0
galpattern155
	db $15,$00,$16,$00,$00,$4e,$51,$55,$e0
galpattern156
	db $58,$55,$58,$5c,$5f,$4e,$51,$55,$e0
galpattern157
	db $58,$55,$58,$5c,$5f,$51,$55,$58,$e0
galpattern158
	db $5c,$58,$5c,$5f,$5d,$51,$55,$58,$e0
galpattern159
	db $5c,$58,$5c,$5f,$5d,$4f,$53,$56,$e0
galpattern160
	db $5a,$56,$5a,$5d,$5f,$4f,$53,$56,$e0
galpattern161
	db $04,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern162
	db $0a,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern163
	db $00,$00,$00,$00,$00,$00,$2a,$00,$e0
galpattern164
	db $00,$00,$4a,$00,$00,$00,$00,$00,$e0
galpattern165
	db $00,$00,$00,$00,$56,$00,$00,$00,$e0
galpattern166
	db $56,$00,$00,$00,$5a,$00,$55,$00,$e0
galpattern167
	db $56,$00,$00,$00,$56,$00,$00,$00,$e0
galpattern168
	db $5a,$00,$55,$00,$56,$00,$56,$00,$e0
galpattern169
	db $5a,$00,$55,$00,$56,$00,$00,$00,$e0
galpattern170
	db $5a,$00,$55,$00,$36,$00,$00,$00,$e0
galpattern171
	db $36,$00,$00,$00,$3a,$00,$35,$00,$e0
galpattern172
	db $36,$00,$00,$00,$36,$00,$00,$00,$e0
galpattern173
	db $3a,$00,$35,$00,$36,$00,$36,$00,$e0
galpattern174
	db $3a,$00,$35,$00,$56,$00,$00,$00,$e0
galpattern175
	db $5a,$00,$55,$00,$0e,$00,$00,$00,$e0
galpattern176
	db $0e,$00,$0f,$10,$13,$12,$13,$14,$e0
galpattern177
	db $0e,$00,$00,$00,$16,$00,$00,$00,$e0
galpattern178
	db $1a,$00,$15,$00,$16,$00,$16,$00,$e0
galpattern179
	db $1a,$00,$15,$00,$18,$00,$00,$00,$e0
galpattern180
	db $18,$00,$00,$00,$1a,$00,$15,$00,$e0
galpattern181
	db $18,$00,$00,$00,$18,$00,$00,$00,$e0
galpattern182
	db $1a,$00,$15,$00,$1a,$00,$18,$00,$e0
galpattern183
	db $16,$00,$15,$00,$13,$00,$13,$00,$e0
galpattern184
	db $16,$00,$11,$00,$13,$00,$00,$00,$e0
galpattern185
	db $13,$00,$00,$00,$1a,$00,$15,$00,$e0
galpattern186
	db $16,$00,$00,$00,$16,$00,$00,$00,$e0
galpattern187
	db $1a,$00,$15,$00,$13,$00,$00,$00,$e0
galpattern188
	db $13,$00,$00,$00,$13,$00,$11,$00,$e0
galpattern189
	db $13,$00,$00,$00,$13,$00,$00,$00,$e0
galpattern190
	db $13,$00,$15,$00,$13,$00,$15,$00,$e0
galpattern191
	db $16,$00,$18,$00,$16,$00,$18,$00,$e0
galpattern192
	db $1a,$00,$1d,$00,$1f,$00,$00,$00,$e0
galpattern193
	db $13,$00,$1f,$1d,$1f,$1d,$1a,$18,$e0
galpattern194
	db $1a,$00,$00,$00,$16,$00,$00,$00,$e0
galpattern195
	db $1a,$00,$15,$00,$1a,$00,$00,$00,$e0
galpattern196
	db $18,$00,$00,$00,$1a,$00,$18,$00,$e0
galpattern197
	db $1a,$18,$16,$15,$1a,$18,$16,$15,$e0
galpattern198
	db $1a,$00,$18,$00,$16,$00,$15,$00,$e0
galpattern199
	db $16,$00,$15,$00,$13,$15,$16,$18,$e0
galpattern200
	db $13,$15,$16,$18,$13,$00,$00,$00,$e0
galpattern201
	db $13,$00,$00,$00,$1f,$00,$1d,$00,$e0
galpattern202
	db $1f,$00,$00,$00,$18,$00,$00,$00,$e0
galpattern203
	db $1a,$00,$18,$00,$1a,$00,$18,$00,$e0
galpattern204
	db $1f,$1d,$1b,$1a,$3a,$3d,$3a,$3d,$e0
galpattern205
	db $36,$3d,$36,$3d,$35,$3d,$35,$3d,$e0
galpattern206
	db $31,$3d,$31,$3d,$31,$3d,$31,$3d,$e0
galpattern207
	db $36,$3f,$36,$3f,$38,$3f,$38,$3f,$e0
galpattern208
	db $16,$18,$16,$18,$16,$18,$1a,$5d,$e0
galpattern209
	db $00,$00,$00,$00,$01,$00,$0e,$00,$e0
galpattern210
	db $00,$00,$1a,$00,$00,$00,$00,$00,$e0
galpattern211
	db $3a,$00,$00,$00,$5a,$00,$00,$00,$e0
galpattern212
	db $00,$00,$00,$00,$00,$01,$00,$00,$e0
galpattern213
	db $00,$00,$00,$5d,$00,$00,$00,$5d,$e0
galpattern214
	db $00,$01,$00,$5d,$00,$00,$00,$5d,$e0
galpattern215
	db $01,$00,$00,$5d,$00,$00,$00,$5d,$e0
galpattern216
	db $01,$00,$13,$5d,$01,$00,$13,$5d,$e0
galpattern217
	db $01,$00,$13,$5d,$01,$00,$18,$5d,$e0
galpattern218
	db $01,$00,$1a,$5d,$01,$00,$1a,$5d,$e0
galpattern219
	db $01,$00,$1a,$5d,$01,$00,$11,$5d,$e0
galpattern220
	db $00,$00,$11,$5d,$00,$00,$11,$5d,$e0
galpattern221
	db $00,$00,$18,$5d,$00,$00,$18,$5d,$e0
galpattern222
	db $00,$00,$11,$5d,$00,$00,$16,$5d,$e0
galpattern223
	db $00,$00,$15,$5d,$00,$00,$15,$5d,$e0
galpattern224
	db $00,$00,$18,$5d,$00,$00,$16,$5d,$e0
galpattern225
	db $01,$0e,$13,$5d,$01,$00,$13,$5d,$e0
galpattern226
	db $01,$00,$13,$5d,$01,$4a,$18,$5d,$e0
galpattern227
	db $01,$00,$11,$5d,$01,$00,$11,$5d,$e0
galpattern228
	db $01,$00,$18,$5d,$01,$00,$18,$5d,$e0
galpattern229
	db $01,$00,$11,$5d,$01,$00,$16,$5d,$e0
galpattern230
	db $01,$00,$15,$5d,$01,$00,$15,$5d,$e0
galpattern231
	db $01,$00,$18,$5d,$01,$00,$16,$5d,$e0
galpattern232
	db $00,$00,$13,$5d,$00,$00,$13,$5d,$e0
galpattern233
	db $00,$00,$13,$5d,$00,$00,$18,$5d,$e0
galpattern234
	db $00,$00,$1a,$5d,$00,$00,$1a,$5d,$e0
galpattern235
	db $00,$00,$1a,$5d,$00,$00,$11,$5d,$e0
galpattern236
	db $00,$00,$1c,$5d,$01,$5f,$5e,$5d,$e0
galpattern237
	db $5c,$5b,$5d,$5c,$5b,$5a,$59,$5a,$e0
galpattern238
	db $38,$00,$00,$00,$01,$00,$38,$3d,$e0
galpattern239
	db $3f,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern240
	db $00,$00,$00,$00,$3d,$00,$3c,$00,$e0
galpattern241
	db $3d,$3f,$3d,$00,$00,$00,$00,$00,$e0
galpattern242
	db $00,$00,$00,$00,$38,$00,$00,$00,$e0
galpattern243
	db $01,$00,$38,$3d,$3f,$00,$00,$00,$e0
galpattern244
	db $3d,$00,$3c,$00,$3d,$3f,$3d,$00,$e0
galpattern245
	db $00,$00,$00,$00,$3f,$00,$00,$00,$e0
galpattern246
	db $4e,$51,$55,$58,$55,$58,$5c,$5f,$e0
galpattern247
	db $51,$55,$58,$5c,$58,$5c,$5f,$5d,$e0
galpattern248
	db $4f,$53,$56,$5a,$56,$5a,$5d,$5f,$e0
galpattern249
	db $4f,$53,$56,$5a,$4e,$51,$55,$58,$e0
galpattern250
	db $55,$58,$5c,$5f,$4e,$51,$55,$58,$e0
galpattern251
	db $55,$58,$5c,$5f,$51,$55,$58,$5c,$e0
galpattern252
	db $58,$5c,$5f,$5d,$51,$55,$58,$5c,$e0
galpattern253
	db $58,$5c,$5f,$5d,$4f,$53,$56,$5a,$e0
galpattern254
	db $56,$5a,$5d,$5f,$4f,$53,$56,$5a,$e0
galpattern255
	db $00,$00,$00,$00,$3d,$00,$00,$00,$e0
galpattern256
	db $5d,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern257
	db $00,$00,$5c,$5b,$07,$00,$00,$00,$e0
galpattern258
	db $27,$00,$00,$00,$00,$00,$00,$00,$e0
galpattern259
	db $00,$00,$00,$00,$25,$00,$00,$00,$e0
galpattern260
	db $00,$00,$00,$00,$23,$00,$00,$00,$e0
galpattern261
	db $00,$00,$00,$00,$05,$00,$00,$00,$e0
galpattern262
	db $00,$00,$00,$00,$03,$00,$00,$00,$e0
galpattern263
	db $00,$00,$00,$00,$27,$00,$00,$00,$e0
galpattern264
	db $00,$00,$00,$00,$00,$00,$00,$11,$e0
galpattern265
	db $00,$00,$00,$1f,$00,$00,$00,$00,$e0
galpattern266
	db $00,$3f,$00,$00,$00,$5f,$00,$00,$e0
galpattern267
	db $00,$00,$00,$00,$5a,$56,$53,$00,$e0


end

