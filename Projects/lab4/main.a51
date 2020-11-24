CSEG AT 0
AJMP reset

CSEG AT 03h
AJMP INT0service ; skok do procedury obslugi przerwania
				 ; zewnetrznego INT0
				 
	TimerHB DATA 76
	TimerLB DATA 01

CSEG AT 30h
reset:
	MOV R0,#0FFh
	MOV R1,#20
	
	SETB EX0 ; wlaczenie przerwania INT0
	SETB EA ; odblokowanie wszystkich przerwan
	SETB IT1 	;ustawia czy aktowowane zobczem czy stanem niskim 0 - zbocze 1 - stan niski
	
	CLR TF0
	MOV TMOD,#01
	MOV TH0,#TimerHB
	MOV TL0,#TimerLB
	SETB TR0
	MOV A,R1
	SJMP waitForSec
	
INT0service: ; procedura obslugi przerwania INT0
	MOV P2,R0
	RETI ; powrót z przerwania


timerR:
	DEC R0
	MOV A,R1
	
waitForSec:
	JNB TF0,$		
	CLR TF0		
	DEC A	
	MOV TH0,#TimerHB
	MOV TL0,#TimerLB
	JNZ waitForSec
	
	SJMP timerR

END
	