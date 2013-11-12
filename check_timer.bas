OPTION_REG.2 = 1
OPTION_REG.1 = 1
OPTION_REG.0 = 1  'prescaler 128. 4 000 000 / 256 = 15625. i.e.
Dim inter_freq As Word
Dim i As Word
i = 0
Hseropen 9600
inter_freq = 15625  'interrupts occurs this times in second
INTCON.T0IE = 1
INTCON.GIE = True
OPTION_REG.T0CS = False  'Timer mode is selected by clearing this byte. TMR0 is prescaler
End                                               
On Interrupt
i = i + 1
If i = inter_freq Then
Hserout #i, "sec", CrLf
Endif
Hserout "Interrupt!", CrLf
INTCON.T0IF = 0
Resume                                            