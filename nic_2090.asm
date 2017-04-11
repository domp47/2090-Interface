DataL	equ	0x20
DataH	equ	0x21
BufferH	equ 	0x22
BufferL	equ	0x23

;--------------------------------------------------------------------------
;  Reg Let.  Bit No.   into 2090/out of 2090 meaning
;--------------------------------------------------------------------------
;       A       0           -   /  -
;       A       1           -   /  -
;       A       2    scan reset /  -
;       A       3    scan count /  -
;       A       4          AC1  /  -
;       A       5          AC2  /  -
;       A       6           -   /  -
;       A       7           -   /  -
;--------------------------------------------------------------------------
;       B       0          db0  /  db0
;       B       1          db1  /  db1
;       B       2          db2  /  db2
;       B       3          db3  /  db3
;       B       4           -   /  -
;       B       5           -   /  -
;       B       6      I/O Step /  -
;       B       7   i/o R=0/W=1 /  -
;--------------------------------------------------------------------------
;       C       0             - /  I/O Flag
;       C       1             - /  LIVE
;       C       2          norm /  norm
;       C       3       GO LIVE /  -
;       C       4       HLD NXT /  -
;       C       5       HLD LST /  -
;       C       6             - /  -
;       C       7             - /  -
;---------------------------------------------------------------------------
;       D       0          db4  /  db4
;       D       1          db5  /  db5
;       D       2          db6  /  db6
;       D       3          db7  /  db7
;       D       4          db8  /  db8
;       D       5          db9  /  db9
;       D       6          db10 /  db10
;       D       7          db11 /  db11
;--------------------------------------------------------------------------
;       E       0    I/O Active /  -
;       E       1       D - R/W /  -
;       E       2       N - R/W /  -
;       E       3             - /  -
;       E       4             - /  -
;       E       5             - /  -
;       E       6             - /  -
;       E       7             - /  -
;--------------------------------------------------------------------------

	Bank3
	bcf	ANSEL,2		;sets PORTA 2 and 3 to be digital pins
	bcf	ANSEL,3
	bcf	ANSEL,4
	bcf	ANSEL,5
	Bank1
	bcf	PORTA,2		;A2 - Output - Scan Count Reset
	bcf	PORTA,3		;A3 - Output - Scan Count Increment
	bcf	PORTA,4		;A4 - Output - AC1?????
	bcf	PORTA,5		;A5 - Output - AC2?????
	bsf	PORTB,0		;B0 - Input  - Data bit 0
	bsf	PORTB,1		;B1 - Input  - Data bit 1
	bsf	PORTB,2		;B2 - Input  - Data bit 2
	bsf	PORTB,3		;B3 - Input  - Data bit 3
	bcf	PORTB,6		;B6 - Output  - I/O Step
	bcf	PORTB,7		;B7 - Output - Read/Write 0 = Read, 1 = Write
	bsf	PORTC,0		;C0 - Input  - IO Flag
	bsf	PORTC,1		;C1 - Input  - Live Flag
	bsf	PORTC,2		;C2 - Input  - Normalization bit
	bcf	PORTC,3		;C3 - Output - Go Live
	bcf	PORTC,4		;C4 - Output - Hold Next
	bcf	PORTC,5		;C5 - Output - Hold Last
	bsf	PORTD,0		;D0 - Input  - Data bit 4
	bsf	PORTD,1		;D1 - Input  - Data bit 5
	bsf	PORTD,2		;D2 - Input  - Data bit 6
	bsf	PORTD,3		;D3 - Input  - Data bit 7
	bsf	PORTD,4		;D4 - Input  - Data bit 8
	bsf	PORTD,5		;D5 - Input  - Data bit 9
	bsf	PORTD,6		;D6 - Input  - Data bit 10
	bsf	PORTD,7		;D7 - Input  - Data bit 11
	bcf	PORTE,0		;E0 - Output - IO Active
	bcf	PORTE,1		;E1 - Output - Data R/W 0 = Read, 1 = Write
	bcf	PORTE,2		;E2 - Output - Normalization R/W 0 = Read, 1 = Write
	Bank0


	bcf	PORTA,2	;reset counter
	movlw	1
	call	Wait
	bsf	PORTA,2
	bcf	PORTC,5 ;pulse Hold Last
	bsf	PORTC,5

	bsf	PORTE,0; turn I/O Active off
	bsf	PORTB,6; set IO step high


	bcf	PORTA,3	;Reset Scan Counter
	bsf	PORTA,3

	bsf	PORTC,5	;clear Hold Last
	movlw	0xE7	;set Hold Next and Go Live

	andwf	PORTC	;AND with PORTC to clear the bits

	bsf	PORTC,3	;hold Hold Next longer than Go Live

	bsf	PORTC,4 ;finish Hold Next pulse


wait
	movlw	0x02	;mask of all bits but LIVE bit
	andwf	PORTC,W	;get LIVE bit - if result is 1 on hold last

	btfsc	STATUS,Z; if LIVE is 0 then it is active
	goto	wait

	bcf	PORTE,0	;turn on I/O Active

	movlw	1
	call	Wait

	bsf	PORTA,4	;reset address mode
	bsf	PORTA,5

	nop		;wait 200 nanoseconds

	bcf	PORTA,4 ;go to Address Advance mode

	clrf	BufferL
	movlw	0x08
	movwf	BufferH	;the Explorer buffer is 2048 complex numbers


Read
	clrf	DataL
	clrf	DataH	;clear data regs

	bcf	PORTB,6	;pulse IO Step
	nop
	bsf	PORTB,6

	nop
	nop

w4d
	movf	PORTC,W	;put port c into W
	andlw	0x01	;mask off all bits but I/O Flag

	btfsc	STATUS,Z;if I/O flag isn't high wait again
	goto 	w4d	;continue waiting for it to go high

	movf	PORTB,W	;get portb with the first 4 bits of data
	andlw	0x0F	;mask off other bits besides data

	movwf	DataL	;put first four bits into least significant data

	movf	PORTD,W	;put 8 bits of most significant data into W
	movwf	DataH	;into Data high

	swapf	DataH,W	;swap nibbles

	andlw	0xF0	;mask off lower nibble

	iorwf	DataL	;add lower nibble of high to low

	swapf	DataH,W	;swap nibbles

	andlw	0x0F	;mask
	movwf	DataH	;put into high

	movf	PORTC,W	;put norm into w
	andlw	0x04	;mask everything but norm
	rlf	W
	rlf	W
	iorwf	DataH	;put norm into DataH

	movf	DataH,W

	call	Hex2TCL	;send high bits to usb


	movf	DataL,W	; put into W to print
	call	Hex2TCL	;send low bits to usb

	movlw	'\n
	call	TxByte	;new line

	bcf	PORTB,6	;pulse IO Step
	nop
	bsf	PORTB,6	;- skipping second channel


	decf	BufferL,F;decrement buffer
	movlw 0xFF
	subwf	BufferL ;check if buffer rolled over

	btfsc	STATUS,Z
	decf	BufferH	;decrement upper byte because lower byte rolled over

	movf	BufferH	;raise z flag is 0
	btfss	STATUS,Z	;checks if upper byte is 0
	goto 	Read

	movf	BufferL	;raise z flag is 0
	btfss	STATUS,Z;if decremented to 0 don't read again
	goto 	Read

	bsf	PORTE,0 ;turn off I/O Active

	return
