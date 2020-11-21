Cel DATA 2Fh
Begin DATA 25h
IleStalych EQU 10
Maska DATA 03h


CSEG AT 0
JMP start

CSEG AT 50h
stale: db 4, 5, 3, 3, 3, 4, 6, 2, 6, 5 ; umieszczamy stale w pamieci kodu zaczynajac od adresu 50h

CSEG AT 100h
start:
	; ladowanie danych do RAM, takie samo jak w poprzednim zadaniu
	MOV R0, #Cel			;zaladuj wartosc Cel do R1 (wskaznik na dane w RAM(koniec tablicy))
	MOV R2, #IleStalych		;zaladuj wartosc IleStalych, ktora bedzie liczyc ile stalych w pamieci kodu zostalo do skopiowania
	MOV DPTR, #stale		;do wskaznika danych odczytujacego z pamieci kodu DPTR zaladuj adres stalych
	loop:
		MOV A, R2 			;zaladuj ilosc pozostalych stalych do A
		DEC A				;adres wzgledny musi miec wartosc od 0-7 a nie 1-8. Dlatego dekrementuejmy wartosc A
		;teraz w A jest adres (wzgledem DPTR) ostatniej nieskopiowanej stalej
		MOVC A, @A+DPTR		;zapisz do A wartosc pod adresem A+DPTR (A+stale) w pamieci kodu
		MOV @R0, A			;przenies dane do pamieci RAM
		DEC R0				;przenies wskaznik R1 na poprzedni adres w pamieci RAM
	  DJNZ R2, loop	 		;zmniejsz wartosc R2 (ilosc danych). Jesli wyniesie zero to zakoncz pentle. Jesli nie skocz do etykiety loop
	
	
	MOV R0, #Begin					;R0 wskazuje tuz przed poczatek tablicy
	MOV R1, #Begin		
	INC R1
	INC R1	
	INC R1							;R1 wskazuje na 3 element tablicy
	loop2:
		INC R0						;W pierwszym wykonaniu petli R0 wskazuje na poczatek tablicy
		INC R1						;W pierwszym wykonaniu petli R1 wskazuje na 4 element tablicy
		MOV A, @R0			
		ADD A, @R1					;Dodajemy odpowiednie poprzednie wyrazy opoznionego ciagu Fibbonaciego
		ANL A, #Maska				;Maska izoluje 2 ostatnie bity ktore sa rowne A mod 4
		NOP 						;W tym miejscu odczytujemy liczbe pseudolosowa z A
		MOV @R0, A					;Tego wyrazu juz nie bedziemy uzywac wiec zastepujemy go nowo wyliczonym(*)
		
									; (*)Reszta z sumy dwoch wyrazow jest rowna sumie reszt tych wyrazow,
									; zatem mozemy dla uproszczenia i zeby nie przepelnic pamieci operowac na samych resztach
		
									; Warunek sprawdzajacy czy nie przekroczylismy zakresu tablicy i 
									;ustawiajacy wskazniki spowrotem na poczatek jesli trzeba
		CJNE R1, #Cel, warunek2  	;	if(R1==Cel){
			MOV R1, #Begin			;		R1 = Begin;
		JMP loop2 					;	
		warunek2:					;	}
		CJNE R0, #Cel, loop2		;   else if(R0==Cel) {
			MOV R0, #Begin			;		R0 = Begin;
		JMP loop2					;	}
	
END
	

	
