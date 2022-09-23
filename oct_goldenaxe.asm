
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
	dw $0600
	dw .start
	dw .loop
.start
	db $00,$fe    ,$e7,$4d,$39,$30,$4d,$39,$30
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$90                ,$2b        ,$2b
	db $00,$00                                
	db $00,$6c        ,$2b,$40    ,$2b,$40    
	db $00,$00                                
	db $00,$90                ,$30        ,$30
	db $00,$00                                
	db $00,$24        ,$2b        ,$2b        
	db $00,$00                                
	db $00,$90                ,$26        ,$26
	db $00,$00                                
	db $00,$6e    ,$ad,$39,$48    ,$39,$48    
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$90                ,$33        ,$33
	db $00,$00                                
	db $00,$6c        ,$39,$4d    ,$39,$4d    
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$92    ,$f5        ,$3d        ,$3d
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$fe    ,$e7,$4d,$39,$30,$4d,$39,$30
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$90                ,$2b        ,$2b
	db $00,$00                                
	db $00,$6c        ,$2b,$40    ,$2b,$40    
	db $00,$00                                
	db $00,$90                ,$30        ,$30
	db $00,$00                                
	db $00,$24        ,$2b        ,$2b        
	db $00,$00                                
	db $00,$90                ,$26        ,$26
	db $00,$00                                
	db $00,$6c        ,$1c,$48    ,$1c,$48    
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$90                ,$19        ,$19
	db $00,$00                                
	db $00,$6c        ,$1c,$4d    ,$1c,$4d    
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$90                ,$1e        ,$1e
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$fe    ,$c2,$26,$18,$e7,$26,$18,$e7
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$3f,$39,$e7,$61,$4d,$39,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$30            
	db $00,$1c        ,$4d,$39,$33            
	db $f3,$1e    ,$c2,$4d,$39,$30            
	db $00,$1c        ,$2b,$4d,$39            
	db $f3,$3d,$39    ,$30,$39,$26,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$33    ,$33,$40,$2b,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$30                ,$61        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$02    ,$c2                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$67,$40,$56            
	db $00,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $f3,$3f,$30,$e7,$30,$4d,$39,$61        
	db $00,$1c        ,$39,$33,$4d            
	db $00,$1c        ,$4d,$61,$39            
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$21,$39                ,$73        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$39,$e7,$61,$4d,$39,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$30            
	db $00,$1c        ,$4d,$39,$33            
	db $f3,$1e    ,$c2,$4d,$39,$30            
	db $00,$1c        ,$2b,$4d,$39            
	db $f3,$3d,$39    ,$30,$39,$26,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$33    ,$33,$40,$2b,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$30                ,$61        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$1e    ,$c2,$2b,$33,$20            
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $f3,$3f,$30,$e7,$30,$1c,$26,$61        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$21,$39                ,$73        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$39,$e7,$61,$4d,$39,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$30            
	db $00,$1c        ,$4d,$39,$33            
	db $f3,$1e    ,$c2,$4d,$39,$30            
	db $00,$1c        ,$2b,$4d,$39            
	db $f3,$3d,$39    ,$30,$39,$26,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$33    ,$33,$40,$2b,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$30                ,$61        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$02    ,$c2                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$67,$40,$56            
	db $00,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $f3,$3f,$30,$e7,$30,$4d,$39,$61        
	db $00,$1c        ,$39,$33,$4d            
	db $00,$1c        ,$4d,$61,$39            
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$21,$39                ,$73        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$39,$e7,$61,$4d,$39,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$30            
	db $00,$1c        ,$4d,$39,$33            
	db $f3,$1e    ,$c2,$4d,$39,$30            
	db $00,$1c        ,$2b,$4d,$39            
	db $f3,$3d,$39    ,$30,$39,$26,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$33    ,$33,$40,$2b,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$30                ,$61        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$1e    ,$c2,$2b,$33,$20            
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $f3,$3f,$30,$e7,$30,$1c,$26,$61        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$21,$39                ,$73        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$40    ,$33,$56,$40,$81        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f3,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$3d,$2b    ,$40,$56,$33,$56        
	db $00,$00                                
	db $00,$00                                
	db $f3,$3f,$30,$e7,$67,$40,$56,$61        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$3f,$33,$ce,$61,$4d,$39,$67        
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$23,$26,$c2            ,$4d        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f2,$23,$4d,$39            ,$9a        
	db $00,$00                                
	db $f3,$23,$73,$73            ,$e7        
	db $00,$00                                
	db $f2,$02    ,$9a                        
	db $f2,$00                                
	db $f3,$02    ,$81                        
	db $00,$00                                
	db $f2,$02    ,$ad                        
	db $f3,$00                                
	db $f2,$02    ,$9a                        
	db $f2,$00                                
	db $f3,$27,$39,$e7,$1c        ,$73        
	db $00,$21,$30                ,$61        
	db $00,$3d,$26    ,$30,$39,$4d,$4d        
	db $00,$21,$1c                ,$39        
	db $f2,$1e    ,$73,$4d,$39,$33            
	db $00,$00                                
	db $f3,$3f,$39,$e7,$4d,$2b,$39,$73        
	db $00,$21,$30                ,$61        
	db $f3,$3f,$26,$e7,$30,$4d,$39,$4d        
	db $00,$21,$1c                ,$39        
	db $00,$1c        ,$39,$33,$4d            
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$61            
	db $00,$00                                
	db $f3,$1e    ,$c2,$56,$67,$40            
	db $00,$00                                
	db $f3,$3d,$39    ,$39,$61,$48,$73        
	db $00,$21,$30                ,$61        
	db $00,$3d,$24    ,$61,$33,$48,$48        
	db $00,$21,$1c                ,$39        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$3d,$39    ,$48,$39,$30,$73        
	db $00,$21,$30                ,$61        
	db $f3,$21,$24                ,$48        
	db $00,$21,$1c                ,$39        
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$25,$40    ,$1c        ,$81        
	db $00,$21,$33                ,$67        
	db $00,$3d,$2b    ,$40,$56,$30,$56        
	db $00,$21,$20                ,$40        
	db $f2,$1e    ,$81,$56,$33,$40            
	db $00,$00                                
	db $f3,$3d,$40    ,$2b,$40,$33,$81        
	db $00,$21,$33                ,$67        
	db $f3,$3f,$2b,$c2,$56,$40,$30,$56        
	db $00,$21,$20                ,$40        
	db $00,$1c        ,$40,$56,$33            
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$39,$56,$67            
	db $00,$00                                
	db $f3,$1c        ,$56,$67,$40            
	db $00,$00                                
	db $f3,$3f,$39,$e7,$61,$39,$4d,$73        
	db $00,$21,$30                ,$61        
	db $00,$3d,$26    ,$4d,$33,$61,$4d        
	db $00,$21,$1c                ,$39        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$3d,$39    ,$4d,$61,$39,$73        
	db $00,$21,$30                ,$61        
	db $f3,$23,$26,$e7            ,$4d        
	db $00,$21,$1c                ,$39        
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$40    ,$33,$56,$40,$81        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f3,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$3d,$2b    ,$40,$56,$33,$56        
	db $00,$00                                
	db $00,$00                                
	db $f3,$3f,$30,$e7,$67,$40,$56,$61        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$3f,$33,$ce,$61,$4d,$39,$67        
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$23,$26,$c2            ,$4d        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f2,$23,$4d,$39            ,$9a        
	db $00,$00                                
	db $f3,$23,$73,$73            ,$e7        
	db $00,$00                                
	db $f2,$02    ,$9a                        
	db $f2,$00                                
	db $f3,$02    ,$81                        
	db $00,$00                                
	db $f2,$02    ,$ad                        
	db $f3,$00                                
	db $f2,$02    ,$9a                        
	db $f2,$00                                
	db $f3,$27,$39,$e7,$1c        ,$73        
	db $00,$21,$30                ,$61        
	db $00,$3d,$26    ,$30,$39,$4d,$4d        
	db $00,$21,$1c                ,$39        
	db $f2,$1e    ,$73,$4d,$39,$33            
	db $00,$00                                
	db $f3,$3f,$39,$e7,$4d,$2b,$39,$73        
	db $00,$21,$30                ,$61        
	db $f3,$3f,$26,$e7,$30,$4d,$39,$4d        
	db $00,$21,$1c                ,$39        
	db $00,$1c        ,$39,$33,$4d            
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$61            
	db $00,$00                                
	db $f3,$1e    ,$c2,$56,$67,$40            
	db $00,$00                                
	db $f3,$3d,$39    ,$39,$61,$48,$73        
	db $00,$21,$30                ,$61        
	db $00,$3d,$24    ,$61,$33,$48,$48        
	db $00,$21,$1c                ,$39        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$3d,$39    ,$48,$39,$30,$73        
	db $00,$21,$30                ,$61        
	db $f3,$21,$24                ,$48        
	db $00,$21,$1c                ,$39        
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$25,$40    ,$1c        ,$81        
	db $00,$21,$33                ,$67        
	db $00,$3d,$2b    ,$40,$56,$30,$56        
	db $00,$21,$20                ,$40        
	db $f2,$1e    ,$81,$56,$33,$40            
	db $00,$00                                
	db $f3,$3d,$40    ,$2b,$40,$33,$81        
	db $00,$21,$33                ,$67        
	db $f3,$3f,$2b,$c2,$56,$40,$30,$56        
	db $00,$21,$20                ,$40        
	db $00,$1c        ,$40,$56,$33            
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$39,$56,$67            
	db $00,$00                                
	db $f3,$1c        ,$56,$67,$40            
	db $00,$00                                
	db $f3,$3f,$39,$e7,$61,$39,$4d,$73        
	db $00,$21,$30                ,$61        
	db $00,$3d,$26    ,$4d,$33,$61,$4d        
	db $00,$21,$1c                ,$39        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$3d,$39    ,$4d,$61,$39,$73        
	db $00,$21,$30                ,$61        
	db $f3,$23,$26,$e7            ,$4d        
	db $00,$21,$1c                ,$39        
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$40    ,$33,$56,$40,$81        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f3,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$3d,$2b    ,$40,$56,$33,$56        
	db $00,$00                                
	db $00,$00                                
	db $f3,$3f,$30,$e7,$67,$40,$56,$61        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$3f,$33,$ce,$61,$4d,$39,$67        
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$23,$26,$c2            ,$4d        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f2,$23,$4d,$39            ,$9a        
	db $00,$00                                
	db $f3,$23,$73,$73            ,$e7        
	db $00,$00                                
	db $f2,$02    ,$9a                        
	db $f2,$00                                
	db $f3,$02    ,$81                        
	db $00,$00                                
	db $f2,$02    ,$ad                        
	db $f3,$00                                
	db $f2,$02    ,$9a                        
	db $f2,$00                                
	db $f3,$3f,$39,$e7,$61,$4d,$39,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$30            
	db $00,$1c        ,$4d,$39,$33            
	db $f3,$1e    ,$c2,$4d,$39,$30            
	db $00,$1c        ,$2b,$4d,$39            
	db $f3,$3d,$39    ,$30,$39,$26,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$33    ,$33,$40,$2b,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$30                ,$61        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$1e    ,$c2,$2b,$33,$20            
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $f3,$3f,$30,$e7,$30,$1c,$26,$61        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$21,$39                ,$73        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$39,$e7,$61,$4d,$39,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$30            
	db $00,$1c        ,$4d,$39,$33            
	db $f3,$1e    ,$c2,$4d,$39,$30            
	db $00,$1c        ,$2b,$4d,$39            
	db $f3,$3d,$39    ,$30,$39,$26,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$33    ,$33,$40,$2b,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$30                ,$61        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$02    ,$c2                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$67,$40,$56            
	db $00,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $f3,$3f,$30,$e7,$30,$4d,$39,$61        
	db $00,$1c        ,$39,$33,$4d            
	db $00,$1c        ,$4d,$61,$39            
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$21,$39                ,$73        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$39,$e7,$61,$4d,$39,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$30            
	db $00,$1c        ,$4d,$39,$33            
	db $f3,$1e    ,$c2,$4d,$39,$30            
	db $00,$1c        ,$2b,$4d,$39            
	db $f3,$3d,$39    ,$30,$39,$26,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$33    ,$33,$40,$2b,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$30                ,$61        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$1e    ,$c2,$2b,$33,$20            
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $f3,$3f,$30,$e7,$30,$1c,$26,$61        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$21,$39                ,$73        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $00,$03,$26,$4d                        
	db $00,$00                                
	db $00,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $00,$05,$24    ,$48                    
	db $00,$00                                
	db $00,$03,$20,$40                        
	db $00,$00                                
	db $00,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $00,$05,$2b    ,$56                    
	db $00,$00                                
	db $00,$03,$26,$4d                        
	db $00,$00                                
	db $00,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $00,$05,$24    ,$48                    
	db $00,$00                                
	db $00,$03,$20,$40                        
	db $00,$00                                
	db $00,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $00,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$13,$26,$4d        ,$19            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$13,$26,$4d        ,$1c            
	db $00,$00                                
	db $f3,$15,$2b    ,$56    ,$19            
	db $00,$00                                
	db $f3,$13,$26,$4d        ,$20            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$13,$26,$4d        ,$22            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$15,$24    ,$48    ,$2b            
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$13,$26,$4d        ,$26            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$13,$26,$4d        ,$19            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$13,$26,$4d        ,$15            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$13,$26,$4d        ,$13            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$13,$26,$4d        ,$16            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$15,$24    ,$48    ,$1c            
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$13,$26,$4d        ,$16            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$13,$26,$4d        ,$19            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$1b,$26,$4d    ,$67,$19            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$1b,$26,$4d    ,$73,$1c            
	db $00,$00                                
	db $f3,$1d,$2b    ,$56,$67,$19            
	db $00,$00                                
	db $f3,$1b,$26,$4d    ,$81,$20            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$1b,$26,$4d    ,$89,$22            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$1d,$24    ,$48,$ad,$2b            
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$1b,$26,$4d    ,$9a,$26            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$1b,$26,$4d    ,$67,$19            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$1b,$26,$4d    ,$56,$15            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$1b,$26,$4d    ,$4d,$13            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$1b,$26,$4d    ,$5b,$16            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$1d,$24    ,$48,$73,$1c            
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$1b,$26,$4d    ,$5b,$16            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$1b,$26,$4d    ,$67,$19            
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f3,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$2b    ,$56                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $00,$00                                
	db $f3,$05,$24    ,$48                    
	db $f3,$00                                
	db $f3,$03,$20,$40                        
	db $00,$00                                
	db $f2,$05,$24    ,$48                    
	db $00,$00                                
	db $f2,$03,$26,$4d                        
	db $f2,$00                                
	db $f2,$05,$2b    ,$56                    
	db $f2,$00                                
	db $f3,$3f,$39,$e7,$61,$4d,$39,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$30            
	db $00,$1c        ,$4d,$39,$33            
	db $f3,$1e    ,$c2,$4d,$39,$30            
	db $00,$1c        ,$2b,$4d,$39            
	db $f3,$3d,$39    ,$30,$39,$26,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$33    ,$33,$40,$2b,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$30                ,$61        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$02    ,$c2                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$67,$40,$56            
	db $00,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $f3,$3f,$30,$e7,$30,$4d,$39,$61        
	db $00,$1c        ,$39,$33,$4d            
	db $00,$1c        ,$4d,$61,$39            
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$21,$39                ,$73        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$39,$e7,$61,$4d,$39,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$30            
	db $00,$1c        ,$4d,$39,$33            
	db $f3,$1e    ,$c2,$4d,$39,$30            
	db $00,$1c        ,$2b,$4d,$39            
	db $f3,$3d,$39    ,$30,$39,$26,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$33    ,$33,$40,$2b,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$30                ,$61        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$1e    ,$c2,$2b,$33,$20            
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $f3,$3f,$30,$e7,$30,$1c,$26,$61        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$21,$39                ,$73        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$39,$e7,$61,$4d,$39,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$30            
	db $00,$1c        ,$4d,$39,$33            
	db $f3,$1e    ,$c2,$4d,$39,$30            
	db $00,$1c        ,$2b,$4d,$39            
	db $f3,$3d,$39    ,$30,$39,$26,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$33    ,$33,$40,$2b,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$30                ,$61        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$02    ,$c2                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$67,$40,$56            
	db $00,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $f3,$3f,$30,$e7,$30,$4d,$39,$61        
	db $00,$1c        ,$39,$33,$4d            
	db $00,$1c        ,$4d,$61,$39            
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$21,$39                ,$73        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$39,$e7,$61,$4d,$39,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$30            
	db $00,$1c        ,$4d,$39,$33            
	db $f3,$1e    ,$c2,$4d,$39,$30            
	db $00,$1c        ,$2b,$4d,$39            
	db $f3,$3d,$39    ,$30,$39,$26,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$33    ,$33,$40,$2b,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$30                ,$61        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$1e    ,$c2,$2b,$33,$20            
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $f3,$3f,$30,$e7,$30,$1c,$26,$61        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$21,$39                ,$73        
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$40    ,$33,$56,$40,$81        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f3,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$3d,$2b    ,$40,$56,$33,$56        
	db $00,$00                                
	db $00,$00                                
	db $f3,$3f,$30,$e7,$67,$40,$56,$61        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$3f,$33,$ce,$61,$4d,$39,$67        
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$23,$26,$c2            ,$4d        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f2,$23,$4d,$39            ,$9a        
	db $00,$00                                
	db $f3,$23,$73,$73            ,$e7        
	db $00,$00                                
	db $f2,$02    ,$9a                        
	db $f2,$00                                
	db $f3,$02    ,$81                        
	db $00,$00                                
	db $f2,$02    ,$ad                        
	db $f3,$00                                
	db $f2,$02    ,$9a                        
	db $f2,$00                                
	db $f3,$27,$39,$e7,$1c        ,$73        
	db $00,$21,$30                ,$61        
	db $00,$3d,$26    ,$30,$39,$4d,$4d        
	db $00,$21,$1c                ,$39        
	db $f2,$1e    ,$73,$4d,$39,$33            
	db $00,$00                                
	db $f3,$3f,$39,$e7,$4d,$2b,$39,$73        
	db $00,$21,$30                ,$61        
	db $f3,$3f,$26,$e7,$30,$4d,$39,$4d        
	db $00,$21,$1c                ,$39        
	db $00,$1c        ,$39,$33,$4d            
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$4d,$39,$61            
	db $00,$00                                
	db $f3,$1e    ,$c2,$56,$67,$40            
	db $00,$00                                
	db $f3,$3d,$39    ,$39,$61,$48,$73        
	db $00,$21,$30                ,$61        
	db $00,$3d,$24    ,$61,$33,$48,$48        
	db $00,$21,$1c                ,$39        
	db $f2,$02    ,$91                        
	db $00,$00                                
	db $f3,$3d,$39    ,$48,$39,$30,$73        
	db $00,$21,$30                ,$61        
	db $f3,$21,$24                ,$48        
	db $00,$21,$1c                ,$39        
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$25,$40    ,$1c        ,$81        
	db $00,$21,$33                ,$67        
	db $00,$3d,$2b    ,$40,$56,$30,$56        
	db $00,$21,$20                ,$40        
	db $f2,$1e    ,$81,$56,$33,$40            
	db $00,$00                                
	db $f3,$3d,$40    ,$2b,$40,$33,$81        
	db $00,$21,$33                ,$67        
	db $f3,$3f,$2b,$c2,$56,$40,$30,$56        
	db $00,$21,$20                ,$40        
	db $00,$1c        ,$40,$56,$33            
	db $f3,$02    ,$ce                        
	db $f2,$1c        ,$39,$56,$67            
	db $00,$00                                
	db $f3,$1c        ,$56,$67,$40            
	db $00,$00                                
	db $f3,$3f,$39,$e7,$61,$39,$4d,$73        
	db $00,$21,$30                ,$61        
	db $00,$3d,$26    ,$4d,$33,$61,$4d        
	db $00,$21,$1c                ,$39        
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$3d,$39    ,$4d,$61,$39,$73        
	db $00,$21,$30                ,$61        
	db $f3,$23,$26,$e7            ,$4d        
	db $00,$21,$1c                ,$39        
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3d,$40    ,$33,$56,$40,$81        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$e7                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f3,$00                                
	db $f3,$21,$40                ,$81        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$30                ,$61        
	db $00,$00                                
	db $f3,$3d,$2b    ,$40,$56,$33,$56        
	db $00,$00                                
	db $00,$00                                
	db $f3,$3f,$30,$e7,$67,$40,$56,$61        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$3f,$33,$ce,$61,$4d,$39,$67        
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $00,$21,$33                ,$67        
	db $00,$00                                
	db $f2,$02    ,$e7                        
	db $00,$00                                
	db $f3,$23,$30,$e7            ,$61        
	db $00,$00                                
	db $f3,$23,$26,$c2            ,$4d        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f2,$23,$4d,$39            ,$9a        
	db $00,$00                                
	db $f3,$23,$73,$73            ,$e7        
	db $00,$00                                
	db $f2,$02    ,$9a                        
	db $f2,$00                                
	db $f3,$02    ,$81                        
	db $00,$00                                
	db $f2,$02    ,$ad                        
	db $f3,$00                                
	db $f2,$02    ,$9a                        
	db $f2,$00                                
	db $f3,$3e    ,$26,$18,$1c,$1c,$1c        
	db $00,$00                                
	db $00,$00                                
	db $00,$30                ,$1c,$1c        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$3e    ,$18,$26,$1c,$1c,$1c        
	db $00,$00                                
	db $f3,$3e    ,$2b,$20,$19,$19,$19        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$30                ,$20,$20        
	db $00,$00                                
	db $f3,$0e    ,$19,$20,$2b                
	db $00,$00                                
	db $f3,$31,$e7            ,$19,$19        
	db $00,$00                                
	db $00,$0e    ,$1c,$30,$26                
	db $00,$31,$e7            ,$1c,$1c        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$0f,$ce,$26,$1c,$30                
	db $00,$00                                
	db $f3,$0f,$c2,$1c,$30,$26                
	db $00,$00                                
	db $00,$01,$ce                            
	db $f3,$00                                
	db $f2,$01,$e7                            
	db $00,$00                                
	db $f3,$0e    ,$2b,$20,$19                
	db $00,$00                                
	db $f3,$3e    ,$26,$18,$1c,$1c,$1c        
	db $00,$00                                
	db $00,$00                                
	db $00,$30                ,$1c,$1c        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$3e    ,$18,$1c,$26,$18,$18        
	db $00,$00                                
	db $f3,$3e    ,$2b,$19,$20,$19,$19        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$30                ,$15,$15        
	db $00,$00                                
	db $f3,$0e    ,$19,$2b,$20                
	db $00,$00                                
	db $f3,$31,$e7            ,$13,$13        
	db $00,$00                                
	db $00,$0e    ,$30,$1c,$26                
	db $00,$00                                
	db $f2,$01,$c2                            
	db $00,$00                                
	db $f3,$0e    ,$26,$1c,$30                
	db $00,$00                                
	db $f3,$0f,$ce,$1c,$30,$26                
	db $00,$00                                
	db $00,$01,$e7                            
	db $f3,$00                                
	db $f2,$0e    ,$2b,$20,$19                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3e    ,$26,$18,$1c,$1c,$1c        
	db $00,$00                                
	db $00,$00                                
	db $00,$30                ,$1c,$1c        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$3e    ,$18,$26,$1c,$1c,$1c        
	db $00,$00                                
	db $f3,$3e    ,$2b,$20,$19,$19,$19        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$30                ,$20,$20        
	db $00,$00                                
	db $f3,$0e    ,$19,$20,$2b                
	db $00,$00                                
	db $f3,$31,$e7            ,$19,$19        
	db $00,$00                                
	db $00,$0e    ,$1c,$30,$26                
	db $00,$31,$e7            ,$1c,$1c        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$0f,$ce,$26,$1c,$30                
	db $00,$00                                
	db $f3,$0f,$c2,$1c,$30,$26                
	db $00,$00                                
	db $00,$01,$ce                            
	db $f3,$00                                
	db $f2,$01,$e7                            
	db $00,$00                                
	db $f3,$0e    ,$2b,$20,$19                
	db $00,$00                                
	db $f3,$3e    ,$26,$18,$1c,$1c,$1c        
	db $00,$00                                
	db $00,$00                                
	db $00,$30                ,$1c,$1c        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$3e    ,$18,$1c,$26,$18,$18        
	db $00,$00                                
	db $f3,$3e    ,$2b,$19,$20,$19,$19        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$30                ,$15,$15        
	db $00,$00                                
	db $f3,$0e    ,$19,$2b,$20                
	db $00,$00                                
	db $f3,$31,$e7            ,$13,$13        
	db $00,$00                                
	db $00,$0e    ,$30,$1c,$26                
	db $00,$00                                
	db $f2,$01,$c2                            
	db $00,$00                                
	db $f3,$0e    ,$26,$1c,$30                
	db $00,$00                                
	db $f3,$0f,$ce,$1c,$30,$26                
	db $00,$00                                
	db $00,$01,$e7                            
	db $f3,$00                                
	db $f2,$0e    ,$2b,$20,$19                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$33,$ce,$56,$44,$33,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2d                ,$5b        
	db $f2,$02    ,$67                        
	db $00,$00                                
	db $f3,$23,$2b,$ce            ,$56        
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$b7                        
	db $f2,$1c        ,$44,$33,$2b            
	db $00,$1c        ,$44,$33,$2d            
	db $f3,$1e    ,$ad,$44,$33,$2b            
	db $00,$1c        ,$26,$44,$33            
	db $f3,$3d,$33    ,$2b,$33,$22,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2d                ,$5b        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$2d,$e7,$2d,$39,$26,$5b        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2b                ,$56        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$26,$e7            ,$4d        
	db $00,$00                                
	db $f3,$1e    ,$ad,$26,$2d,$1c            
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$b7                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $f3,$3f,$2b,$ce,$2b,$19,$22,$56        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2d                ,$5b        
	db $f2,$02    ,$ce                        
	db $00,$00                                
	db $f3,$23,$33,$e7            ,$67        
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$33,$ce,$56,$44,$33,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2d                ,$5b        
	db $f2,$02    ,$67                        
	db $00,$00                                
	db $f3,$23,$2b,$ce            ,$56        
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$b7                        
	db $f2,$1c        ,$44,$33,$2b            
	db $00,$1c        ,$44,$33,$2d            
	db $f3,$1e    ,$ad,$44,$33,$2b            
	db $00,$1c        ,$26,$44,$33            
	db $f3,$3d,$33    ,$2b,$33,$22,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2d                ,$5b        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$2d,$e7,$2d,$39,$26,$5b        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2b                ,$56        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$26,$e7            ,$4d        
	db $00,$00                                
	db $f3,$02    ,$ad                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$b7                        
	db $f2,$1c        ,$5b,$39,$4d            
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $f3,$3f,$2b,$ce,$2b,$44,$33,$56        
	db $00,$1c        ,$33,$2d,$44            
	db $00,$1c        ,$44,$56,$33            
	db $00,$21,$2d                ,$5b        
	db $f2,$02    ,$ce                        
	db $00,$00                                
	db $f3,$23,$33,$e7            ,$67        
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$33,$ce,$56,$44,$33,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2d                ,$5b        
	db $f2,$02    ,$67                        
	db $00,$00                                
	db $f3,$23,$2b,$ce            ,$56        
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$b7                        
	db $f2,$1c        ,$44,$33,$2b            
	db $00,$1c        ,$44,$33,$2d            
	db $f3,$1e    ,$ad,$44,$33,$2b            
	db $00,$1c        ,$26,$44,$33            
	db $f3,$3d,$33    ,$2b,$33,$22,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2d                ,$5b        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$2d,$e7,$2d,$39,$26,$5b        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2b                ,$56        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$26,$e7            ,$4d        
	db $00,$00                                
	db $f3,$1e    ,$ad,$26,$2d,$1c            
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$b7                        
	db $f2,$00                                
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $f3,$3f,$2b,$ce,$2b,$19,$22,$56        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2d                ,$5b        
	db $f2,$02    ,$ce                        
	db $00,$00                                
	db $f3,$23,$33,$e7            ,$67        
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$33,$ce,$56,$44,$33,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2d                ,$5b        
	db $f2,$02    ,$67                        
	db $00,$00                                
	db $f3,$23,$2b,$ce            ,$56        
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$b7                        
	db $f2,$1c        ,$44,$33,$2b            
	db $00,$1c        ,$44,$33,$2d            
	db $f3,$1e    ,$ad,$44,$33,$2b            
	db $00,$1c        ,$26,$44,$33            
	db $f3,$3d,$33    ,$2b,$33,$22,$67        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2d                ,$5b        
	db $f2,$02    ,$81                        
	db $00,$00                                
	db $f3,$21,$2b                ,$56        
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $00,$00                                
	db $f3,$3f,$2d,$e7,$2d,$39,$26,$5b        
	db $00,$00                                
	db $00,$00                                
	db $00,$21,$2b                ,$56        
	db $f2,$02    ,$73                        
	db $00,$00                                
	db $f3,$23,$26,$e7            ,$4d        
	db $00,$00                                
	db $f3,$02    ,$ad                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$02    ,$b7                        
	db $f2,$1c        ,$5b,$39,$4d            
	db $00,$00                                
	db $f3,$23,$39,$e7            ,$73        
	db $00,$00                                
	db $f3,$3f,$2b,$ce,$2b,$44,$33,$56        
	db $00,$1c        ,$33,$2d,$44            
	db $00,$1c        ,$44,$56,$33            
	db $00,$21,$2d                ,$5b        
	db $f2,$02    ,$ce                        
	db $00,$00                                
	db $f3,$23,$33,$e7            ,$67        
	db $00,$00                                
	db $f3,$02    ,$ce                        
	db $00,$00                                
	db $00,$00                                
	db $f3,$00                                
	db $f2,$00                                
	db $f3,$00                                
	db $f3,$00                                
.loop
 db 0,0
 db $ff
