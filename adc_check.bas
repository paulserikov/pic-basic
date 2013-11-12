Define ADC_CLOCK = 3
Define ADC_SAMPLEUS = 50
Hseropen 9600

Dim a0 As Word

loop:
Adcin 0, a0
Hserout "ADC value: ", #a0, CrLf
WaitMs 100
Goto loop
