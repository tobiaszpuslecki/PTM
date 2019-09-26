.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512
KONIEC_LINI = 0xA
MINUS = 0x2D
POCZATEK_LICZB = 0x30
PODSTAWA_WEJSCIA = 10
ILOSC_LITER = 26
przesuniecie: .ascii "-55"
przesuniecie_len = .-przesuniecie

.bss
.comm textin, 512

.text
.globl _start

_start:


mov $SYSREAD, %rax
mov $STDIN, %rdi
mov $textin, %rsi
mov $BUFLEN, %rdx
int 0x80

mov %rax, %r9 # string length
dec %r9






 d_petla2:
mov $0, %rdi           # licznik do pętli
mov $ILOSC_LITER, %rcx # dzielnik

jmp petla2

petla2:
mov $0, %rax # wynik dzielenia (nieistotny)
mov $0, %rdx # reszta z dzielenia
mov textin(, %rdi, 1), %al # odczyt kolejnych znaków do AL

sub $'a', %al


# jeśli pierwszy znak zmiennej przesuniecie to minus:
# skocz do dekoduj - odejmij przesunięcie
mov $0, %r10
mov przesuniecie(, %r10, 1), %bl
sub $MINUS, %bl
jz dekoduj

# w przeciwnym przypadku: koduj - dodaj przesunięcie
add %r8, %rax
jmp powrot_do_petli2







powrot_do_petli2:

# jeśli kod znaku po przesunięciu jest ujemny,
# przeskok do etykiety powrot_do_petli2_2
# i dopisanie ciągu FF..FF do uzupełnienia dzielnej,
# tak aby podczas dzielenia, liczba była faktycznie
# traktowana jako ujemna
cmp $0, %rax
jl uzupelnij_dzielna
jmp powrot_do_petli2_2

uzupelnij_dzielna:
mov $-1, %rdx # -1 w sys. dziesiętnym to w U16 ciąg FF..FF
jmp powrot_do_petli2_2

powrot_do_petli2_2:
idiv %rcx # dzielenie z uwzględnieniem znaku liczby

# jeśli po dzieleniu, reszta z dzielenia jest ujemna,
# przeskok do etykiety dodaj26, gdzie do reszty dodawana
# jest ilość wszystkich liter w alfabecie (modulo 26)
cmp $0, %rdx
jl dodaj26
jmp powrot_do_petli2_3

dodaj26:
add $26, %dl
jmp powrot_do_petli2_3

powrot_do_petli2_3:
# dodanie kodu pierwszej litery alfabetu, odjętego wcześniej
# na potrzeby dzielenia modulo
add $'a', %dl

mov %dl, textout(, %rdi, 1)
# zapisanie kodu litery do bufora wyjściowego





# porót na początek pętli aż do wykonania operacji dla każdego znaku
inc %rdi
cmp %r9, %rdi
jle petla2



# DOPISANIE NA KOŃCU BUFORA ZNAKU NOWEJ LINI
mov $KONIEC_LINI, %al
mov %al, textout(, %r9, 1)
inc %r9

# WYŚWIETLENIE WYNIKU
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $textout, %rsi
mov %r9, %rdx
syscall

# ZWROT WARTOŚCI EXIT_SUCCESS
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
