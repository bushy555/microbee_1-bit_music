
	ORG	$100

port1	equ 64
port2	equ 0



;Octode beeper music engine by Shiru (shiru@mail.ru) 02'11
;Eight channels of tone
;One channel of interrupting drums, no ROM data required
;Feel free to do whatever you want with the code, it is PD
;Modified for Z80 TI calculators by utz


begin



	di	
	ld hl,musicData
	call play
	ei

	ret

OPxNOP	EQU $00
OPxRRA	EQU $1f
OPxSCF	EQU $37
OPxORC	EQU $b1



play
	di
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld (xspeed),de

	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld (xptr),de

	ld e,(hl)
	inc hl
	ld d,(hl)
	ld (xloop),de

readNotes
xptr equ $+1
	ld hl,0
	ld a,(hl)
	inc hl
	cp 240
	jr c,xnoLoop
	cp 255
	jr nz,xdrum
xloop equ $+1
	ld hl,0
	ld (xptr),hl
	jp xcheckKey

xdrum
	ld (xptr),hl
	ld b,8
	ld hl,xdrum2
	ld (hl),OPxNOP
	inc hl
	djnz $-3
	sub 240
	jr z,xdrum0
	ld b,a
	ld hl,xdrum2
	ld (hl),OPxRRA
	inc hl
	djnz $-3
xdrum0
	ld bc,100*256
xdrum1
	ld a,c
xdrum2 equ $
	rra
	rra
	rra
	rra
	rra
	rra
	rra
	rra
	xor b
	and port1
	
	push af		;+11
	bit 6,a		;+8
	jr nz, $+6	;+7/12
	ld a,$fc	;+7
	jr $+6		;+12 
	nop			;+4
	nop			;+4
	ld a,port2	;f
;	and 33
	out	(2), a
;	ld        (26624),a	;11
;	ld        (26624),a	;+11
;	ld        (26624),a	;+11
	push hl		;+11
	nop			;+4
	nop			;+4
	pop hl		;+11
	pop af		;+10	+55/56 +41

	bit 0,(ix)
	inc c
	inc c
	xor a
			
	push af		;+11
	bit 6,a		;+8
	jr nz, $+6	;+7/12
	ld a,$fc	;+7
	jr $+6		;+12 
	nop			;+4
	nop			;+4
	ld a, port2
;	and 33
	out	(2), a
;	ld        (26624),a	;11
;	ld        (26624),a	;+11
;	ld        (26624),a	;+11
	push hl		;+11
	nop			;+4
	nop			;+4
	pop hl		;+11
	pop af		;+10	+55/56 +41

	djnz xdrum1

	ld hl,(xptr)

xnoLoop
	ld b,(hl)
	inc hl

	ld c,OPxSCF

	xor a
	rr b
	jr nc,xch1
	ld a,(hl)
	inc hl
	ld (xfrq0),a
	ld a,c
xch1
	ld (xoff0),a

	xor a
	rr b
	jr nc,xch2
	ld a,(hl)
	inc hl
	ld (xfrq1),a
	ld a,c
xch2
	ld (xoff1),a

	xor a
	rr b
	jr nc,xch3
	ld a,(hl)
	inc hl
	ld (xfrq2),a
	ld a,c
xch3
	ld (xoff2),a

	xor a
	rr b
	jr nc,xch4
	ld a,(hl)
	inc hl
	ld (xfrq3),a
	ld a,c
xch4
	ld (xoff3),a

	xor a
	rr b
	jr nc,xch5
	ld a,(hl)
	inc hl
	ld (xfrq4),a
	ld a,c
xch5
	ld (xoff4),a

	xor a
	rr b
	jr nc,xch6
	ld a,(hl)
	inc hl
	ld (xfrq5),a
	ld a,c
xch6
	ld (xoff5),a

	xor a
	rr b
	jr nc,xch7
	ld a,(hl)
	inc hl
	ld (xfrq6),a
	ld a,c
xch7
	ld (xoff6),a

	xor a
	rr b
	jr nc,xchDone
	ld a,(hl)
	inc hl
	ld (xfrq7),a
	ld a,c
xchDone
	ld (xoff7),a

	ld (xptr),hl

xprevBC equ $+1
	ld bc,0
xspeed equ $+1
	ld hl,0
	and a

soundLoop
	xor a		;4

	dec b		;4
	jr z,xla0	;7/12
	nop			;4
	jr xlb0		;12
xla0
xfrq0 equ $+1
	ld b,0		;7
xoff0 equ $
	scf			;4
xlb0
	dec c		;4
	jr z,xla1	;7/12
	nop			;4
	jr xlb1		;12
xla1
xfrq1 equ $+1
	ld c,0		;7
xoff1 equ $
	scf			;4
xlb1
	dec d		;4
	jr z,xla2	;7/12
	nop			;4
	jr xlb2		;12
xla2
xfrq2 equ $+1
	ld d,0		;7
xoff2 equ $
	scf			;4
xlb2
	dec e		;4
	jr z,xla3	;7/12
	nop			;4
	jr xlb3		;12
xla3
xfrq3 equ $+1
	ld e,0		;7
xoff3 equ $
	scf			;4
xlb3
	exx			;4
	
	push af		;+11
	bit 6,a		;+8
	jr nz, $+6	;+7/12
	ld a,$fc	;+7
	jr $+6		;+12 
	nop			;+4
	nop			;+4
	ld a, port2
;	and 33
	out	(2), a
;	ld        (26624),a	;11
;	ld        (26624),a	;+11
;	ld        (26624),a	;+11
	push hl		;+11
	nop			;+4
	nop			;+4
	pop hl		;+11
	pop af		;+10	+55/56 +41
	
	dec b		;4
	jr z,xla4	;7/12
	nop			;4
	jr xlb4		;12
xla4
xfrq4 equ $+1
	ld b,0		;7
xoff4 equ $
	scf			;4
xlb4
	dec c		;4
	jr z,xla5	;7/12
	nop			;4
	jr xlb5		;12
xla5
xfrq5 equ $+1
	ld c,0		;7
xoff5 equ $
	scf			;4
xlb5
	dec d		;4
	jr z,xla6	;7/12
	nop			;4
	jr xlb6		;12
xla6
xfrq6 equ $+1
	ld d,0		;7
xoff6 equ $
	scf			;4
xlb6
	dec e		;4
	jr z,xla7	;7/12
	nop			;4
	jr xlb7		;12
xla7
xfrq7 equ $+1
	ld e,0		;7
xoff7 equ $
	scf			;4
xlb7
	exx			;4
	sbc a,a		;4
	and port1		;7
	
	push af		;+11
	bit 6,a		;+8
	jr nz, $+6	;+7/12
	ld a,$fc	;+7
	jr $+6		;+12 
	nop			;+4
	nop			;+4
	ld a, port2
;	and 33
	out	(2), a
;	ld        (26624),a	;11
;	ld        (26624),a	;+11
;	ld        (26624),a	;+11
	push hl		;+11
	nop			;+4
	nop			;+4
	pop hl		;+11
	pop af		;+10	+55/56 +41
	
	dec l		;4
	jp nz,soundLoop	;10 = 275t
	dec h		;4
	jp nz,soundLoop	;10

	ld (xprevBC),bc

	xor a
	
	push af		;+11
	bit 6,a		;+8
	jr nz, $+6	;+7/12
	ld a,$fc	;+7
	jr $+6		;+12 
	nop			;+4
	nop			;+4
	ld a, port2
;	and 33
	out	(2), a
;	ld        (26624),a	;11
;	ld        (26624),a	;+11
;	ld        (26624),a	;+11
	push hl		;+11
	nop			;+4
	nop			;+4
	pop hl		;+11
	pop af		;+10	+55/56 +41


xcheckKey
	xor a
	ld c,a
;	ld a,%10111111				;+ new keyhandler
;	out (1),a
;	in a,(1)				;read keyboard
;	cpl
;	bit 6,a
;	jp z,readNotes

	jp readNotes

stopPlayer
	exx
	ei
	ret






musicData
	dw $0700
	dw .start
	dw .loop
.start
	db $f3,$05,$1c    ,$26                    
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f3,$05,$40    ,$81                    
	db $f3,$05,$36    ,$6d                    
	db $f3,$05,$33    ,$67                    
	db $f3,$05,$30    ,$61                    
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$01,$30                            
	db $f3,$04        ,$61                    
	db $f2,$00                                
	db $f2,$01,$30                            
	db $f3,$00                                
	db $f3,$04        ,$61                    
	db $f3,$01,$30                            
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$04        ,$61                    
	db $f3,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$01,$61                            
	db $00,$00                                
	db $00,$01,$61                            
	db $00,$01,$51                            
	db $00,$01,$61                            
	db $00,$01,$51                            
	db $00,$01,$48                            
	db $00,$01,$51                            
	db $00,$01,$48                            
	db $00,$01,$40                            
	db $00,$0b,$48,$ad    ,$56                
	db $00,$01,$40                            
	db $00,$00                                
	db $00,$01,$40                            
	db $f3,$03,$36,$81                        
	db $f3,$00                                
	db $f2,$06    ,$81,$91                    
	db $00,$01,$36                            
	db $f2,$06    ,$81,$81                    
	db $00,$00                                
	db $f2,$07,$36,$81,$61                    
	db $f3,$00                                
	db $f3,$06    ,$81,$61                    
	db $f3,$01,$36                            
	db $f2,$06    ,$81,$61                    
	db $00,$00                                
	db $f2,$06    ,$81,$61                    
	db $f2,$00                                
	db $f2,$06    ,$6d,$61                    
	db $00,$00                                
	db $f3,$06    ,$6d,$61                    
	db $f3,$00                                
	db $f2,$06    ,$6d,$91                    
	db $00,$00                                
	db $f2,$06    ,$6d,$81                    
	db $00,$00                                
	db $f2,$06    ,$6d,$61                    
	db $f3,$00                                
	db $f3,$06    ,$6d,$6d                    
	db $f3,$00                                
	db $f2,$06    ,$6d,$61                    
	db $00,$00                                
	db $f2,$06    ,$6d,$6d                    
	db $f2,$00                                
	db $f3,$06    ,$6d,$61                    
	db $00,$00                                
	db $f3,$06    ,$61,$6d                    
	db $f3,$00                                
	db $f2,$06    ,$6d,$91                    
	db $00,$00                                
	db $f2,$06    ,$61,$81                    
	db $00,$00                                
	db $f2,$06    ,$61,$61                    
	db $f3,$00                                
	db $f3,$06    ,$61,$61                    
	db $f3,$00                                
	db $f2,$06    ,$61,$61                    
	db $00,$00                                
	db $f2,$06    ,$61,$61                    
	db $f2,$00                                
	db $f2,$06    ,$51,$61                    
	db $00,$00                                
	db $f3,$06    ,$51,$61                    
	db $f3,$00                                
	db $f2,$06    ,$51,$91                    
	db $00,$00                                
	db $f2,$06    ,$51,$81                    
	db $00,$00                                
	db $f2,$06    ,$6d,$61                    
	db $f3,$00                                
	db $f3,$06    ,$6d,$6d                    
	db $f3,$00                                
	db $f2,$06    ,$6d,$61                    
	db $00,$00                                
	db $f2,$07,$40,$6d,$6d                    
	db $f2,$00                                
	db $f3,$06    ,$6d,$61                    
	db $00,$00                                
	db $f3,$02    ,$81                        
	db $f3,$00                                
	db $f2,$06    ,$81,$91                    
	db $00,$01,$81                            
	db $f2,$06    ,$81,$81                    
	db $00,$01,$91                            
	db $f2,$06    ,$81,$61                    
	db $f3,$01,$ad                            
	db $f3,$06    ,$81,$61                    
	db $f3,$01,$c2                            
	db $f2,$06    ,$81,$61                    
	db $00,$01,$ad                            
	db $f2,$07,$91,$81,$61                    
	db $f2,$01,$c2                            
	db $f2,$07,$ad,$6d,$61                    
	db $00,$00                                
	db $f3,$06    ,$6d,$61                    
	db $f3,$00                                
	db $f2,$06    ,$6d,$91                    
	db $00,$01,$81                            
	db $f2,$06    ,$6d,$81                    
	db $00,$01,$91                            
	db $f2,$06    ,$6d,$61                    
	db $f3,$01,$ad                            
	db $f3,$06    ,$6d,$6d                    
	db $f3,$01,$c2                            
	db $f2,$06    ,$6d,$61                    
	db $00,$01,$ad                            
	db $f2,$07,$91,$6d,$6d                    
	db $f2,$01,$81                            
	db $f3,$07,$6d,$6d,$61                    
	db $00,$00                                
	db $f3,$07,$c2,$61,$6d                    
	db $f3,$00                                
	db $f2,$07,$c2,$6d,$91                    
	db $00,$01,$61                            
	db $f2,$06    ,$61,$81                    
	db $00,$01,$6d                            
	db $f2,$06    ,$61,$61                    
	db $f3,$01,$81                            
	db $f3,$06    ,$61,$61                    
	db $f3,$01,$91                            
	db $f2,$06    ,$61,$61                    
	db $00,$01,$81                            
	db $f2,$07,$6d,$61,$61                    
	db $f2,$01,$91                            
	db $f2,$07,$81,$51,$61                    
	db $00,$00                                
	db $f3,$07,$a3,$51,$61                    
	db $f3,$00                                
	db $f2,$07,$a3,$51,$91                    
	db $00,$01,$51                            
	db $f2,$06    ,$51,$81                    
	db $00,$01,$a3                            
	db $f2,$06    ,$6d,$61                    
	db $f3,$01,$c2                            
	db $f3,$06    ,$6d,$6d                    
	db $f3,$00                                
	db $f2,$06    ,$6d,$61                    
	db $f2,$00                                
	db $f2,$0a    ,$ad    ,$56                
	db $f2,$00                                
	db $f2,$00                                
	db $f2,$00                                
	db $f3,$07,$61,$81,$20                    
	db $f3,$06    ,$40,$24                    
	db $f2,$07,$81,$81,$2b                    
	db $00,$06    ,$81,$30                    
	db $f2,$07,$61,$40,$40                    
	db $00,$02    ,$81                        
	db $f2,$01,$81                            
	db $f3,$02    ,$81                        
	db $f3,$01,$6d                            
	db $f3,$03,$61,$40                        
	db $f2,$07,$81,$81,$48                    
	db $00,$03,$6d,$81                        
	db $f2,$07,$61,$40,$40                    
	db $f2,$03,$6d,$81                        
	db $f2,$07,$81,$40,$30                    
	db $00,$02    ,$81                        
	db $f3,$03,$91,$81                        
	db $f3,$02    ,$40                        
	db $f2,$07,$c2,$81,$36                    
	db $00,$02    ,$81                        
	db $f2,$07,$89,$40,$48                    
	db $00,$02    ,$81                        
	db $f2,$05,$81    ,$40                    
	db $f3,$02    ,$81                        
	db $f3,$03,$ad,$81                        
	db $f3,$02    ,$40                        
	db $f2,$07,$81,$81,$56                    
	db $00,$02    ,$81                        
	db $f2,$07,$6d,$40,$48                    
	db $f2,$07,$61,$81,$40                    
	db $f3,$03,$51,$81                        
	db $00,$03,$48,$81                        
	db $f3,$07,$61,$91,$48                    
	db $f3,$02    ,$48                        
	db $f2,$03,$81,$91                        
	db $00,$02    ,$91                        
	db $f2,$07,$61,$48,$39                    
	db $00,$02    ,$91                        
	db $f2,$01,$81                            
	db $f3,$03,$81,$91                        
	db $f3,$07,$6d,$91,$30                    
	db $f3,$03,$61,$48                        
	db $f2,$03,$81,$91                        
	db $00,$02    ,$91                        
	db $f2,$07,$61,$48,$24                    
	db $f2,$03,$6d,$91                        
	db $f2,$03,$81,$91                        
	db $00,$02    ,$91                        
	db $f3,$07,$91,$a3,$28                    
	db $f3,$04        ,$36                    
	db $f2,$07,$c2,$51,$40                    
	db $00,$06    ,$a3,$51                    
	db $f2,$03,$89,$a3                        
	db $00,$06    ,$a3,$40                    
	db $f2,$07,$da,$91,$36                    
	db $f3,$06    ,$91,$28                    
	db $f3,$05,$81    ,$24                    
	db $f3,$04        ,$30                    
	db $f2,$07,$e7,$91,$39                    
	db $00,$06    ,$91,$48                    
	db $00,$0b,$6d,$48    ,$56                
	db $00,$06    ,$91,$39                    
	db $00,$07,$f5,$48,$30                    
	db $00,$04        ,$24                    
	db $f3,$07,$61,$81,$20                    
	db $f3,$06    ,$40,$24                    
	db $f2,$07,$81,$81,$2b                    
	db $00,$06    ,$81,$30                    
	db $f2,$07,$61,$40,$40                    
	db $00,$02    ,$81                        
	db $f2,$01,$81                            
	db $f3,$02    ,$81                        
	db $f3,$01,$6d                            
	db $f3,$03,$61,$40                        
	db $f2,$07,$81,$81,$48                    
	db $00,$03,$6d,$81                        
	db $f2,$07,$61,$40,$40                    
	db $f2,$03,$6d,$81                        
	db $f2,$07,$81,$40,$30                    
	db $00,$02    ,$81                        
	db $f3,$03,$91,$81                        
	db $f3,$02    ,$40                        
	db $f2,$07,$c2,$81,$36                    
	db $00,$02    ,$81                        
	db $f2,$07,$89,$40,$48                    
	db $00,$02    ,$81                        
	db $f2,$05,$81    ,$40                    
	db $f3,$02    ,$81                        
	db $f3,$03,$ad,$81                        
	db $f3,$02    ,$40                        
	db $f2,$07,$81,$81,$56                    
	db $00,$02    ,$81                        
	db $f2,$07,$6d,$40,$48                    
	db $f2,$07,$61,$81,$40                    
	db $f3,$03,$51,$81                        
	db $00,$03,$48,$81                        
	db $f3,$07,$61,$91,$48                    
	db $f3,$02    ,$48                        
	db $f2,$03,$81,$91                        
	db $00,$02    ,$91                        
	db $f2,$07,$61,$48,$39                    
	db $00,$02    ,$91                        
	db $f2,$01,$81                            
	db $f3,$03,$81,$91                        
	db $f3,$07,$6d,$91,$30                    
	db $f3,$03,$61,$48                        
	db $f2,$03,$81,$91                        
	db $00,$02    ,$91                        
	db $f2,$07,$61,$48,$24                    
	db $f2,$03,$6d,$91                        
	db $f2,$03,$81,$91                        
	db $00,$02    ,$91                        
	db $f3,$07,$91,$a3,$28                    
	db $f3,$04        ,$36                    
	db $f2,$07,$c2,$51,$40                    
	db $00,$06    ,$a3,$51                    
	db $f2,$03,$89,$a3                        
	db $00,$06    ,$a3,$40                    
	db $f2,$07,$da,$91,$36                    
	db $f3,$06    ,$91,$28                    
	db $f3,$05,$81    ,$24                    
	db $f3,$04        ,$30                    
	db $f2,$07,$e7,$91,$39                    
	db $00,$06    ,$91,$48                    
	db $00,$0b,$6d,$48    ,$56                
	db $00,$06    ,$91,$39                    
	db $00,$07,$f5,$48,$30                    
	db $00,$04        ,$24                    
	db $f3,$04        ,$20                    
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$01,$81                            
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$01,$91                            
	db $00,$00                                
	db $00,$00                                
	db $f3,$01,$91                            
	db $00,$00                                
	db $00,$00                                
	db $00,$01,$89                            
	db $f3,$02    ,$51                        
	db $00,$02    ,$61                        
	db $00,$02    ,$6d                        
	db $00,$02    ,$61                        
	db $f3,$03,$81,$61                        
	db $00,$02    ,$6d                        
	db $00,$02    ,$61                        
	db $00,$02    ,$61                        
	db $f3,$02    ,$6d                        
	db $00,$03,$91,$61                        
	db $00,$02    ,$61                        
	db $00,$02    ,$6d                        
	db $f3,$03,$91,$ad                        
	db $00,$00                                
	db $00,$00                                
	db $00,$01,$89                            
	db $f3,$00                                
	db $f2,$00                                
	db $f2,$00                                
	db $f2,$00                                
	db $f3,$01,$81                            
	db $00,$00                                
	db $f2,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f2,$01,$91                            
	db $f2,$00                                
	db $00,$00                                
	db $f3,$01,$91                            
	db $00,$00                                
	db $00,$00                                
	db $00,$01,$89                            
	db $f3,$00                                
	db $00,$00                                
	db $f2,$03,$81,$91                        
	db $00,$00                                
	db $f3,$03,$da,$7a                        
	db $f2,$02    ,$6d                        
	db $00,$01,$c2                            
	db $00,$02    ,$7a                        
	db $f3,$03,$b7,$6d                        
	db $f2,$01,$c2                            
	db $f2,$03,$da,$7a                        
	db $f2,$03,$c2,$6d                        
	db $f3,$00                                
	db $f2,$00                                
	db $f2,$01,$da                            
	db $f2,$01,$c2                            
	db $f3,$07,$da,$61,$30                    
	db $f3,$00                                
	db $f2,$03,$c2,$61                        
	db $00,$00                                
	db $f2,$03,$61,$61                        
	db $00,$00                                
	db $f2,$03,$81,$61                        
	db $f3,$01,$6d                            
	db $f3,$00                                
	db $f3,$01,$81                            
	db $f2,$06    ,$61,$2b                    
	db $00,$01,$91                            
	db $f2,$07,$89,$61,$26                    
	db $f2,$01,$81                            
	db $f2,$07,$6d,$6d,$24                    
	db $00,$00                                
	db $f3,$03,$c2,$6d                        
	db $f3,$00                                
	db $f2,$01,$c2                            
	db $00,$00                                
	db $f2,$01,$61                            
	db $00,$00                                
	db $f2,$03,$81,$6d                        
	db $f3,$01,$6d                            
	db $f3,$02    ,$6d                        
	db $f3,$01,$61                            
	db $f2,$06    ,$6d,$26                    
	db $00,$01,$51                            
	db $f2,$06    ,$6d,$2b                    
	db $f2,$01,$48                            
	db $f3,$03,$44,$6d                        
	db $00,$01,$40                            
	db $f3,$07,$91,$7a,$28                    
	db $f3,$00                                
	db $f2,$07,$91,$7a,$2b                    
	db $00,$00                                
	db $f2,$07,$a3,$7a,$30                    
	db $00,$01,$91                            
	db $f2,$06    ,$7a,$3d                    
	db $f3,$01,$a3                            
	db $f3,$01,$91                            
	db $f3,$00                                
	db $f2,$03,$c2,$7a                        
	db $00,$01,$a3                            
	db $f2,$02    ,$7a                        
	db $f2,$01,$91                            
	db $f2,$03,$7a,$6d                        
	db $00,$01,$6d                            
	db $f3,$03,$61,$6d                        
	db $f3,$00                                
	db $f2,$05,$81    ,$48                    
	db $00,$00                                
	db $f2,$05,$6d    ,$40                    
	db $00,$01,$61                            
	db $f2,$06    ,$6d,$36                    
	db $f3,$01,$51                            
	db $f3,$06    ,$6d,$30                    
	db $f3,$01,$61                            
	db $f2,$06    ,$6d,$28                    
	db $00,$01,$6d                            
	db $f2,$06    ,$6d,$24                    
	db $f2,$01,$91                            
	db $f3,$07,$89,$6d,$20                    
	db $00,$01,$81                            
	db $f3,$06    ,$7a,$1e                    
	db $f3,$00                                
	db $f2,$03,$f5,$7a                        
	db $00,$00                                
	db $f2,$03,$7a,$7a                        
	db $00,$00                                
	db $f2,$03,$a3,$7a                        
	db $f3,$01,$89                            
	db $f3,$04        ,$3d                    
	db $f3,$01,$a3                            
	db $f2,$06    ,$7a,$36                    
	db $00,$01,$b7                            
	db $f2,$07,$ad,$7a,$30                    
	db $f2,$01,$a3                            
	db $f2,$07,$89,$89,$2d                    
	db $00,$00                                
	db $f3,$03,$f5,$89                        
	db $f3,$00                                
	db $f2,$01,$f5                            
	db $00,$00                                
	db $f2,$01,$7a                            
	db $00,$00                                
	db $f2,$03,$a3,$89                        
	db $f3,$01,$89                            
	db $f3,$02    ,$89                        
	db $f3,$01,$7a                            
	db $f2,$06    ,$89,$30                    
	db $00,$01,$67                            
	db $f2,$06    ,$89,$36                    
	db $f2,$01,$5b                            
	db $f3,$03,$56,$89                        
	db $00,$01,$51                            
	db $f3,$07,$b7,$9a,$33                    
	db $f3,$00                                
	db $f2,$07,$b7,$9a,$36                    
	db $00,$00                                
	db $f2,$07,$ce,$9a,$3d                    
	db $00,$01,$b7                            
	db $f2,$06    ,$9a,$4d                    
	db $f3,$01,$ce                            
	db $f3,$01,$b7                            
	db $f3,$00                                
	db $f2,$03,$f5,$9a                        
	db $00,$01,$ce                            
	db $f2,$02    ,$9a                        
	db $f2,$01,$b7                            
	db $f2,$03,$9a,$89                        
	db $00,$01,$89                            
	db $f3,$03,$7a,$89                        
	db $f3,$00                                
	db $f2,$05,$a3    ,$5b                    
	db $00,$00                                
	db $f2,$05,$89    ,$51                    
	db $00,$01,$7a                            
	db $f2,$06    ,$89,$44                    
	db $f3,$01,$67                            
	db $f3,$06    ,$89,$3d                    
	db $f3,$01,$7a                            
	db $f2,$06    ,$89,$33                    
	db $00,$01,$89                            
	db $f2,$06    ,$89,$2d                    
	db $f2,$01,$b7                            
	db $f3,$07,$ad,$89,$28                    
	db $00,$01,$a3                            
	db $f3,$07,$da,$6d,$24                    
	db $f3,$04        ,$28                    
	db $f2,$07,$51,$6d,$2b                    
	db $00,$04        ,$36                    
	db $f2,$01,$f5                            
	db $00,$01,$da                            
	db $f2,$00                                
	db $f3,$01,$da                            
	db $f3,$00                                
	db $f3,$00                                
	db $f2,$01,$51                            
	db $f2,$01,$6d                            
	db $f2,$00                                
	db $f2,$03,$da,$6d                        
	db $f2,$01,$f5                            
	db $00,$01,$e7                            
	db $f3,$03,$da,$5b                        
	db $f3,$00                                
	db $f2,$03,$51,$5b                        
	db $00,$00                                
	db $f2,$01,$f5                            
	db $00,$01,$da                            
	db $f2,$00                                
	db $f3,$01,$da                            
	db $f3,$00                                
	db $f3,$00                                
	db $f2,$01,$51                            
	db $f2,$01,$6d                            
	db $f2,$00                                
	db $f2,$03,$f5,$5b                        
	db $f3,$01,$da                            
	db $00,$01,$b7                            
	db $f3,$07,$a3,$51,$51                    
	db $f3,$00                                
	db $f2,$03,$3d,$51                        
	db $00,$00                                
	db $f2,$01,$b7                            
	db $00,$01,$a3                            
	db $f2,$00                                
	db $f3,$01,$a3                            
	db $f3,$04        ,$44                    
	db $f3,$00                                
	db $f2,$01,$3d                            
	db $f2,$01,$a3                            
	db $f2,$04        ,$3d                    
	db $f2,$03,$b7,$51                        
	db $f2,$01,$da                            
	db $00,$00                                
	db $f3,$07,$f5,$7a,$2d                    
	db $f3,$00                                
	db $f2,$03,$5b,$7a                        
	db $00,$00                                
	db $f2,$00                                
	db $00,$01,$f5                            
	db $f2,$00                                
	db $f3,$01,$f5                            
	db $f3,$04        ,$30                    
	db $f3,$04        ,$2d                    
	db $f2,$05,$5b    ,$30                    
	db $f2,$05,$7a    ,$3d                    
	db $f2,$00                                
	db $f2,$07,$f5,$7a,$36                    
	db $f3,$05,$e7    ,$2d                    
	db $00,$01,$73                            
	db $f3,$07,$da,$6d,$2b                    
	db $f3,$00                                
	db $f2,$03,$51,$6d                        
	db $00,$00                                
	db $f2,$01,$f5                            
	db $00,$01,$da                            
	db $f2,$00                                
	db $f3,$01,$da                            
	db $f3,$00                                
	db $f3,$00                                
	db $f2,$01,$51                            
	db $f2,$01,$6d                            
	db $f2,$00                                
	db $f2,$03,$da,$6d                        
	db $f2,$01,$f5                            
	db $00,$01,$e7                            
	db $f3,$07,$da,$5b,$24                    
	db $f3,$00                                
	db $f2,$03,$51,$5b                        
	db $00,$00                                
	db $f2,$01,$f5                            
	db $00,$01,$da                            
	db $f2,$00                                
	db $f3,$01,$da                            
	db $f3,$00                                
	db $f3,$00                                
	db $f2,$01,$51                            
	db $f2,$01,$6d                            
	db $f2,$00                                
	db $f2,$03,$f5,$5b                        
	db $f3,$01,$da                            
	db $00,$01,$b7                            
	db $f3,$07,$a3,$51,$28                    
	db $f3,$00                                
	db $f2,$03,$3d,$51                        
	db $00,$00                                
	db $f2,$01,$b7                            
	db $00,$01,$a3                            
	db $f2,$00                                
	db $f3,$01,$a3                            
	db $f3,$00                                
	db $f3,$00                                
	db $f2,$01,$3d                            
	db $f2,$01,$a3                            
	db $f2,$00                                
	db $f2,$03,$b7,$51                        
	db $f2,$01,$da                            
	db $00,$00                                
	db $f3,$07,$f5,$7a,$30                    
	db $f3,$00                                
	db $f2,$03,$5b,$7a                        
	db $00,$00                                
	db $f2,$00                                
	db $00,$01,$f5                            
	db $f2,$00                                
	db $f3,$01,$f5                            
	db $f3,$00                                
	db $f3,$00                                
	db $f2,$01,$5b                            
	db $f2,$01,$7a                            
	db $f2,$00                                
	db $f2,$03,$f5,$7a                        
	db $f3,$01,$e7                            
	db $00,$01,$73                            
.loop
 db 0,0
 db $ff
