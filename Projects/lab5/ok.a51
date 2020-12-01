; tablica cykliczna:
pierwszy DATA 60h
za_ostatnim DATA 70h

CSEG AT 0
AJMP reset 

CSEG AT 23h
AJMP read

CSEG AT 30h
reset:
SETB ES	; odblokowanie przerwan z poru szeregowego
SETB EA ; odblokowanie przerwan
MOV SCON,#50h ; uart w trybie 1 (8 bit), REN=1
MOV TMOD,#20h ; licznik 1 w trybie 2
MOV TH1,#0FDh ; 9600 Bds at 11.0592MHz
SETB TR1 ; uruchomienie timera
CLR TI ; wyzerowanie flagi wyslania
MOV R0, #pierwszy ; do R0 zapisujemy pierwsze miejsce w pamieci bufora cyklicznego

loop:
NOP
NOP ; tutaj program moglby robic cos innego w czasie czekania na nowy znak
AJMP loop

read:
MOV A, SBUF ; odczytanie znaku
CLR RI ; zerowanie flagi odbioru
MOV @R0, A ;zapisz do obecnego miejsca w buforze
INC R0 ; przenies wskaznik na nastepne miejsce
CJNE R0, #za_ostatnim, return ;jesli R0 nie przekroczyl ostatniego miejsca w buforze to zakoncz przerwanie
	;jesli R0 jest za ostatnim elementem -> resetuj R0
	MOV R0, #pierwszy
return:
RETI

END
