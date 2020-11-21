PROG SEGMENT CODE

CSEG AT 0
JMP start

RSEG PROG
start:
MOV R2, P2                    ;wpisanie do R2 stanu poczatkowego diod
MOV R3, P3                    ;poczatkowy stan nacisniecia przyciskow

 czekaj:                      ;petla oczekujaca na nowy sygnal niski z przycisku
    MOV A, P3                 ;do A przenies biezacy stan przyciskow
    XRL A, R3                 ;ktore przyciski zmienily swoj stan (porownujemy biezace P2 z R3, czyli poprzednim stane przyciskow)
	
 JZ czekaj                    ;jesli stan pzryciskow sie zmienil przejdz dalej
   
    ANL A, R3                 ;w A zostaja tylko te ktore zmienily sie z 1 na 0 (przycisk zostal nacisniety a nie puszczony)
    MOV R3, P3                ;ustaw nowy poprzedni stan przyciskow
	
 JZ czekaj                    ;jesli A=0 to kontynuuj petle (puszczono przycisk a nie nacisnieto)     
   
    XRL A, R2                 ;A nie rowne 0 zatem niezerowe bity A reprezentuja diody ktore maja zmienic stan na przeciwny,
    MOV P2, A                 ;zmiana stanu diod na nowy
    MOV R2, A                 ;do R2 wpisujemy nowy stan diod
	
 JMP czekaj                   ;restart
END 