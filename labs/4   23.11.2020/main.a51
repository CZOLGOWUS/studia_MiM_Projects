TimerHB DATA 76
TimerLB DATA 01

CSEG AT 0
AJMP reset

				 
CSEG AT 0Bh
AJMP INT0Timer		;oznaczenie gdzie ma skoczyc program przy wystapieniu przerwania na timerze0
				

CSEG AT 30h
reset:
	MOV R0,#0FFh
	MOV R1,#20
	
	SETB EA 	; odblokowanie przerwan
	SETB ET0   	; odblokowanie przerwan na timerze 0
	SETB IT1 	;ustawia czy aktowowane zobczem czy stanem niskim 0 - zbocze 1 - stan niski
	
	;ustawienie Timera 0
	CLR TF0
	MOV TMOD,#01
	MOV TH0,#TimerHB
	MOV TL0,#TimerLB
	SETB TR0
	MOV A,R1
	SJMP waitForSec
	
	
waitForSec:
	DEC A				;obnizamy counter 0.05 sekund
	JNB TF0,$			;zlicza 0.05s
	CLR TF0				;CLR po ustawieniu w przerwaniu zeby wyszedl z JNB TF0 (sztucznie controlujemy TF0)
	MOV TH0,#TimerHB	;reset timera
	MOV TL0,#TimerLB	;
	SJMP waitForSec		;powtarzac waitForSec do niewystapienia przerwania na timerze 0


		
INT0Timer:
	SETB TF0			;setujemy ten bit by wyszedl z JNB TF0
	JNZ return			;jesli petla "waitForSec" przebiegla 20 razy to mozesz przejsc
	
	DEC R0				;zliczanie na diodach
	MOV A,R1			;Reset Acc do 20
	MOV P2,R0			;ustawiamy diody
	
	return:
		RETI 			;powrot z przerwania

END
	