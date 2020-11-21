Stala EQU 1000
DanaL DATA 20h
DanaH DATA 21h
WynikL DATA 30h
WynikH DATA 31h 

CSEG AT 0  						;co to jest?
JMP start  
CSEG AT 100h
	start:       
		
			MOV R3,10h
			MOV R4,0Ah
			
			MOV A,R3
			DIV A,R4
			
			
		
	END*