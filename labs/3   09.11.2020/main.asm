PROG SEGMENT CODE
	
	TimerHB DATA 76
	TimerLB DATA 01
	TimerOnStatus Data 7Fh
	TimerOffStatus Data 0FFh
	
CSEG AT 0
JMP start

RSEG PROG
start:
	MOV R3,#0FFh											;ustawiamy counter do dekrementacji
	MOV R4,#8												;ilosc diod
	MOV B,#2												;do dzielenia by uzyskac kolejne diody
	
	MOV TH0,#TimerHB										;ustawiamy wysoki i niski bajt zegara 
	MOV TL0,#TimerLB										;
	MOV TMOD,#01 											;16-bitowy timer 0
	
	checkForSwitch0L:
		MOV A,P3											;do A wpisujemy stana na przyciskach
		CJNE A,#TimerOnStatus,checkForSwitch0L				;sprawdzamy czy pierwszy przycisk zostatal wcisniety
		SETB TR0 											;startujemy timer 0 jesli pierwszy przycisk zostal wcisniety
		SJMP waitForSwitch0H								;niepotrzebna linijka wpisana dla jasnosci dzialania
	
	waitForSwitch0H:
		JBC TF0,DecrementR3									;skocz do dekrementacji licznika R3 jesli timer sie przepelnil i wyzeruj flage odpowiadajaca za przepelnienie
		MOV A,P3											;do A wpisujemy stana na przyciskach
		CJNE A,#TimerOffStatus,waitForSwitch0H				;skocz do "waitForSwitch0H" jesli pierwszy przycisk nie zostal puszczony
		
		;przygotuj na zapalanie
		CLR TR0												;jesli zostal puszczony zatrzymaj timer
		CLR TF0												;wyzeruj falge przepelnienia
		MOV TH0,#TimerHB  									;1.	na dwoch linijkach resetujemy timer zeby liczyl do 0.05sec  									
		MOV TL0,#TimerLB									;2. na dwoch linijkach resetujemy timer zeby liczyl do 0.05sec
		SJMP continue										;skocz do "continiue" - kontynuj program po zliczeniu ile ma trwacprzerwa miedzy diodami
	
	DecrementR3:
		MOV TH0,#TimerHB  									;1.	na dwoch linijkach resetujemy timer zeby liczyl do 0.05sec
		MOV TL0,#TimerLB									;2. na dwoch linijkach resetujemy timer zeby liczyl do 0.05sec
		DJNZ R3,waitForSwitch0H								;zliczamy ilosc przepelnien przez Dekrementacje R3
	
	continue:
		MOV A,0FFh											;1. tutaj na dwoch linijkach sprawdzamy ile razy timer sie przepelnil
		SUBB A,R3											;2.
		MOV R3,A											;teraz w R3 jest ilosc przepelnien podczas trzymania przycisku czyli (ilosc przepelnien * 0.05sec)= czas wlaczania sie diód
		JMP resetAcc										;po przeliczeniu skocz do "resetAcc" - niepotrzebna linijka wpisana dla jasnosci dzialania
		
	resetAcc:												;w tej "petli" resetujemy timer tak by dla kazdej diody mial to samo opoznienie
		MOV A,R3											;resetujemy Acc do ilosci przepelnien wprowadzonego czasu
		MOV TH0,#TimerHB  									;1.	na dwoch linijkach resetujemy timer zeby liczyl do 0.05sec										
		MOV TL0,#TimerLB									;2. na dwoch linijkach resetujemy timer zeby liczyl do 0.05sec	
		SETB TR0											;wlaczamy zresetowany timer - niepotrzebna linijka wpisana dla jasnosci dzialania
		JMP waitForNextLED
		
	waitForNextLED:											;liczymy czas do zaswiecenia nastepnej diody
		JNB TF0,$											;mija 0.05s (timer do przepelnienia)
		CLR TF0												;zerujemy flage przepelnienia
		
		DEC A												;teraz w a znaduje sie liczba przepelnien z trzymania przycisku czyli (ilosc przepelnien * 0.05sec)= czas wlaczania sie diód
															;dekrementujemy A - czyli ten loop zadziala tyle razy ile zadzialal loop na trzymanie przycisku
		MOV TH0,#TimerHB  									;1.	na dwoch linijkach resetujemy timer zeby liczyl do 0.05sec
		MOV TL0,#TimerLB									;2.		
		JNZ waitForNextLED									;sprawdzamy czy A doszedl do zera
		
		JMP nextLedOn										;jesli tak skocz do zapalania nastepnej diody - niepotrzebna linijka wpisana dla jasnosci dzialania
		
		
	nextLedOn:
		MOV A,P2											;do Acc wpisujemy stan diod
		MOV B,#2											;do akumulatora B wpisujemy dwojke
		DIV AB												;dzielimy Acc przez dwa dzieki czemu dostajemy wszystkie diody ktore maja sie zapalic w nastepnym kroku
		MOV P2,A											;zapalamy diody
		DJNZ R4,resetAcc									;dekrepentujemy R4(ilosc diod do zapalenia) i wracamy do czekania na miniecie czasu na zapalenie kolejnej diody
		
		
		;ten kod jest powtorka z gory i jest tutaj zeby wszystkie diody swiecily sie przy zakonczeniu programu
		MOV A,R3
		MOV TH0,#TimerHB
		MOV TL0,#TimerLB	
		SETB TR0
		
		lastLED:
		JNB TF0,$
		CLR TF0
		DEC A
		MOV TH0,#TimerHB  						
		MOV TL0,#TimerLB	
		JNZ lastLED
		;przestajemy liczyc czasu swiecenia sie przy ostatniej diodzie
		
		MOV A,#0FFh											;1. zapalamy wszystkie diody
		MOV P2,A											;2. zapalamy wszystkie diody
		JMP start											;niepotrzebna linijka wpisana dla jasnosci dzialania

END

