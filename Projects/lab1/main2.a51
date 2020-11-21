/*MY_KILLING_COPY SEGMENT CODE
Zrodlo DATA 20h
Cel DATA 30h
IleDanych EQU 16
	
	
CSEG AT 0
JMP start
RSEG MY_KILLING_COPY
	
start:
	MOV R0,#Zrodlo
	MOV R1,#Cel
	MOV R3,#IleDanych
	
	Petla:
		MOV A,@R0
		MOV @R1,A
		INC R0
		INC R1
	DJNZ R3,Petla
END*/