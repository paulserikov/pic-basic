TRISB = 0xff  'inputs
PORTB = 0x00  'make all PORTA pins low

TRISD = 0x00  'outputs (diodes)
PORTD = 0x00  'PORTD pins low

Hseropen 9600

Dim a As Word
Dim i As Byte
a = 50
Hserout "I am ready", CrLf

loop:
	Hserget i
	If i > 0 Then
	Hserout "Code: ", i, CrLf
		Select Case i
		Case "i"
			PORTD = %11111111
		Case "b"
			PORTD.0 = 1
			loop1:
				PORTD = ShiftLeft(PORTD, 1)
				WaitMs a
				If PORTD = %10000000 Then Goto loop2
			Goto loop1

			loop2:
				PORTD = ShiftRight(PORTD, 1)
				WaitMs a
				If PORTD = %00000001 Then Goto loop1
			Goto loop1

		Case "a"
		Hserout "Anton debil", CrLf

		EndSelect
	Else
		Hserout "Waiting...", CrLf
		WaitMs a
	Endif
Goto loop