;CSEG AT 0
;AJMP reset
;
;CSEG AT 03h
;AJMP INT0service ; skok do procedury obslugi przerwania
; ; zewnetrznego INT0
; 
;CSEG AT 30h
;	
;reset:
;	SETB EX0 ; wlaczenie przerwania INT0
;	SETB EA ; odblokowanie wszystkich przerwan
;loop:
;	ACALL delay ; przykladowy program glówny
;	CPL P2.7
;	SJMP loop
;INT0service: ; procedura obslugi przerwania INT0
;	;PUSH ACC ; zapamietanie akumulatora
;	;PUSH PSW ; i rejestru stanu
;	CPL P2.0
;	;POP PSW
;	;POP ACC
;	RETI ; powrót z przerwania
;delay:
;	MOV R0,#100
;del2:
;	MOV R1,#255
;del1:
;	NOP
;	NOP
;	DJNZ R1,del1
;	DJNZ R0,del2
;	RET
;END