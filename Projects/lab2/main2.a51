;PROG SEGMENT CODE
;
;CSEG AT 0
;JMP start
;
;RSEG PROG
;start:
;MOV R2, P2                   ;w R2 teraz bedzie obecny stan diod
; czekaj:                     ;petla oczekujaca na sygnal niski z przycisku
;    MOV A, P3                ;gdy nie wcisnieto niczego, A=P3=FFh
;    CPL A                    ;(CLP - neguje) gdy nie wcisnieto niczego, A=0
;    JZ czekaj                ;jesli A=0 to kontynuuj petle
;XRL A, R2                    ;koniec petli, (*)                                            
;MOV #R3, A
;MOV P2, A                    ;zmien stan diod na nowy
; wciska:                     ;petla oczekujaca na sygnal wysoki z przycisku (az przestanie naciskac)
;    MOV A, P3
;    CPL A
;    JNZ wciska               ;jesli A=0 (przestanie wszystko wciskac)
;JMP start
;
;END 

;   	  (*) Teraz w A jest bit 1 odpowiadajacy nacisnietemu przyciskowi
;         Polecenie zamieni ten bit w R2 na przeciwny, ktory w Akumulatorze mial 1,
;         a zerowe bity z Akumulatora oznaczaja zeby nie zmieniac bitu w R2.

; Zakladam ze uzytkownik na krotki czas wciska pojedynczo przyciski.
; Gdy uzytkownik naciska kilka przyciskow na raz, zadziala tylko nacisniety jako pierwszy.
; Ciagle trzymanie wcisnietego klawisza tez spowoduje brak reakcji z ukladu do poki sie nie pusci wszystkich klawiszy