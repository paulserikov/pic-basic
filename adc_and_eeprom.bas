Define ADC_CLOCK = 3
Define ADC_SAMPLEUS = 50
Hseropen 9600

Dim a As Byte
Dim a0 As Byte
a = 1  'start address

loop:
Adcin 0, a0
Hserout "ADC value: ", #a0, CrLf
Write a, a0
a = a + 1
WaitMs 100
Goto loop
