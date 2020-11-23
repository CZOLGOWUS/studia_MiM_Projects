CSEG AT 0
AJMP start ;po resecie wykonujemy skok do poczatku programu

CSEG AT 13h ;pod adresem 13h z pamieci programu umieszczamy
AJMP Obsluga_int1 ;instrukcje skoku do procedury obslugi przerwania
CSEG AT 30h
	
howManyOverflowsForoneSecond Data = #20
	
start: 								;program glówny zaczyna sie od adresu 30h
									;(za tablica wektorów przerwan)

waitForSec:											;liczymy czas do zaswiecenia nastepnej diody
	JNB TF0,$										;mija 0.05s (timer ustawil flage przepelnienia)
	CLR TF0											;zerujemy flage przepelnienia
	
	DEC A											;teraz w Acc znaduje sie liczba przepelnien z trzymania przycisku czyli (ilosc przepelnien * 0.05sec)= czas wlaczania sie diód
												;dekrementujemy A - czyli ten loop zadziala tyle razy ile zadzialal loop na trzymanie przycisku
	MOV TH0,#TimerHB  									;1.	na dwoch linijkach resetujemy timer zeby liczyl do 0.05sec
	MOV TL0,#TimerLB									;2.		
	JNZ waitForSec

;Konfiguracja ukladu przerwan:
	SETB IT1 							;przerwanie INT1 aktywowane zboczem
	SETB EX1 							;zezwolenie na zewnetrzne przerwanie INT1
	SETB EA 							;globalne odblokowanie przerwan

loop:
 ;glówna petla programu
	AJMP loop
	
Obsluga_int1: ;procedura obslugi przerwania
;
;
	RETI
	
END