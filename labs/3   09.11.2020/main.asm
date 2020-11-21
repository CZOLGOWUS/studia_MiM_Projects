PROG SEGMENT CODE
	
	TimerHB DATA 76
	TimerLB DATA 01
	TimerOnStatus Data 7Fh
	TimerOffStatus Data 0FFh
	
CSEG AT 0
JMP start

RSEG PROG
start:
	MOV R3,#0FFh
	MOV R4,#8
	MOV R5,#0FFh
	MOV B,#2
	
	MOV TH0,#TimerHB
	MOV TL0,#TimerLB
	MOV TMOD,#01 	; 16-bitowy timer 0
	
	checkForSwitch0L:
		MOV A,P3
		CJNE A,#TimerOnStatus,checkForSwitch0L
		SETB TR0 		; startujemy timer 0
	
	waitForSwitch0H:
		JBC TF0,DecrementR3
		MOV A,P3
		CJNE A,#TimerOffStatus,waitForSwitch0H
		
		;przygotuj na zapalanie
		CLR TR0
		CLR TF0
		MOV TH0,#TimerHB  						
		MOV TL0,#TimerLB
		SJMP continue
	
	DecrementR3:
		CLR TF0
		MOV TH0,#TimerHB  						;1.	na dwoch linijkach resetujemy timer zeby liczyl do 0.05sec
		MOV TL0,#TimerLB						;2. na dwoch linijkach resetujemy timer zeby liczyl do 0.05sec
		DJNZ R3,waitForSwitch0H					;zliczamy ilosc przepelnien przez Dekrementacje R3
	
	continue:
		MOV A,0FFh
		SUBB A,R3								
		MOV R3,A								;teraz w R3 jest ilosc przepelnien podczas trzymania przycisku czyli (ilosc przepelnien * 0.05sec)= czas wlaczania sie diód
		JMP resetAcc
		
	resetAcc:
		MOV A,R3
		MOV TH0,#TimerHB
		MOV TL0,#TimerLB	
		SETB TR0
		JMP waitForNextLED
		
	waitForNextLED:
		
		
		JNB TF0,$
		CLR TF0
		
		DEC A
		
		MOV TH0,#TimerHB  						;1.	na dwoch linijkach resetujemy timer zeby liczyl do 0.05sec
		MOV TL0,#TimerLB	
		JNZ waitForNextLED
		
		
		JMP nextLedOn
		
		
		
	nextLedOn:
		MOV A,P2
		MOV B,#2
		DIV AB

		
		MOV P2,A
		
		DJNZ R4,resetAcc
		
		
		;wait for the last diode to lith up for a period of time
		MOV A,R3
		MOV TH0,#TimerHB
		MOV TL0,#TimerLB	
		SETB TR0
		
		lastLED:
		JNB TF0,$
		CLR TF0
		DEC A
		MOV TH0,#TimerHB  						;1.	na dwoch linijkach resetujemy timer zeby liczyl do 0.05sec
		MOV TL0,#TimerLB	
		JNZ lastLED
		
		
		MOV A,#0FFh
		MOV P2,A

END

