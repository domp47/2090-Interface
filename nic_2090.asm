;Data bits 4-11 - PORTD 0-7
;Data bits 0-3	- PORTB 0-3
;Normilization bit - PORTC 2
;ALL ABOVE ARE INPUTS AND OUTPUTS


	Bank1
	bcf	PORTA,2		;A2 - Output - Scan Count Increment
	bcf	PORTA,3		;A3 - Output - Scan Count Reset
	bcf	PORTA,4		;A4 - Output - AC1?????
	bcf	PORTA,5		;A5 - Output - AC2?????
	bsf	PORTB,6		;B6 - Input  - I/O Step
	bcf	PORTB,7		;B7 - Output - Read/Write 0 = Read, 1 = Write
	bsf	PORTC,0		;C0 - Input  - IO Flag
	bsf	PORTC,1		;C1 - Input  - Live Flag
	bcf	PORTC,3		;C3 - Output - Go Live
	bcf	PORTC,4		;C4 - Output - Hold Next
	bcf	PORTC,5		;C5 - Output - Hold Last
	bcf	PORTE,0		;E0 - Output - IO Active
	bcf	PORTE,1		;E1 - Output - Data R/W 0 = Read, 1 = Write
	bcf	PORTE,2		;E2 - Output - Normalization R/W 0 = Read, 1 = Write
	Bank0

	bsf	PORTA,3; pulse Hold Last
	bcf	PORTC,5 
	bcf	PORTA,3; and reset counter
	bsf	PORTC,5

	bsf	PORTE,0; turn I/O Active off


add	
	;somehow get number of points from user
	bsf	PORTA,3	;Reset Scan Counter
	bcf	PORTA,3

	bsf	PORTC,5	;clear Hold Last
	movlw	0xE7	;set Hold Next and Go Live

	andwf	PORTC	;AND with PORTC to clear the bits

	bsf	PORTC,3	;hold Hold Next longer than Go Live
	
	bsf	PORTC,4 ;finish Hold Next pulse

	bcf	PORTE,0	;turn on I/O Active

a_wait
	movlw	0x02	;mask of all bits but LIVE bit
	andwf	PORTC,W	;get LIVE bit - if result is 1 on hold last

	btfsc	STATUS,Z; if LIVE is 0 then it is active
	goto	a_wait

	bsf	PORTE,0 ;turn off I/O Active

	return

