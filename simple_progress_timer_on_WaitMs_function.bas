Hseropen 9600

Dim sec As Word
Dim min As Word
Dim hours As Word
Dim days As Word

Hserout "Ready to count time", CrLf

main:

	WaitMs 1  '1000 for real timer
	sec = sec + 1

	If sec = 60 Then
	min = min + 1
	sec = 0
	Endif

	If min = 60 Then
	hours = hours + 1
	hours = 0
	Endif

	If hours = 24 Then
	hours = 0
	days = days + 1
	Endif
	
	Hserout #hours, ":", #min, ":", #sec, CrLf
Goto main