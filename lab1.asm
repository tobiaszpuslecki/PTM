; Laboratorium 1
; Temat: Podstawowe działania arytmetyczne. Operacje na rejestrach i pamięci.
; Paweł Parczyk -
; Tobiasz Puślecki - 241354

LJMP START ; Long jump -> START
ORG 0100H ; Początek programu w pamięci

START:
	; czyszczenie rejestrow
	MOV R0, #0H
	MOV R1, #0H
	MOV R2, #0H
	MOV R3, #0H
	MOV R4, #0H
	MOV R5, #0H
	MOV R6, #0H
	MOV R7, #0H

	MOV A, #10H
	ADD A, #0F1H ; dodawanie

	MOV A, #10H
	ADDC A, #01H ; dodawanie z przeniesieniem


	SETB C       ; CY set 1

	MOV A, #10H
	SUBB A, #01H ; odejmowanie z pożyczką

	MOV A, #0FAH
	MOV B, #025H
	MUL AB ; mnożenie

	MOV A, #0FFH
	MOV B, #015H
	DIV AB ;dzielenie

	; dodawnie A = 0xABCD B = 0x1234

	CLR C         ; clear C flag

	MOV R4, #0ABH  ;	hi A
	MOV R5, #0CDH  ;	lo A

	MOV R6, #012H  ;	hi B
	MOV R7, #034H  ;	lo B

	MOV A, R5     ; lo A
	ADD A, R7     ; lo B

	MOV R0, A

	MOV A, R4     ; hi A
	ADDC A, R6    ; hi B

	MOV R1, A

	; suma w R1 R0

	; czyszczenie rejestrow
	MOV R0, #0H
	MOV R1, #0H
	MOV R2, #0H
	MOV R3, #0H
	MOV R4, #0H
	MOV R5, #0H
	MOV R6, #0H
	MOV R7, #0H

	MOV R0, #10011001b
	MOV A, #0FFH

	; or
	ORL A, R0
	MOV R1, A

	MOV R2, #10011001b
	MOV A, #0FFH

	; and
	ANL A, R2
	MOV R3, A

	MOV R4, #10011001b
	MOV A, #0FFH

	; xor
	XRL A, R4
	MOV R5, A

	; negacja
	CPL A
	MOV R6, A


	; odczyt i zapis pamieci

	MOV DPTR, #8000H		; ustawienie odresu zmiennej
	MOVX A, @DPTR           ; pobranie zmiennej

	ADD A, #02H             ; dodanie do zmiennej z pmieci

	MOVX @DPTR, A           ; zapisanie w pamieci

	; odczyt i zapis internal ram

	MOV R0, #20H     		; ustawienie odresu zmiennej
	MOV A, @R0              ; pobranie zmiennej

	ADD A, #02H             ; dodanie do zmiennej z pmieci

	MOV @R0, A              ; zapisanie w pamieci

	NOP
	NOP
	NOP
	JMP $

END START
