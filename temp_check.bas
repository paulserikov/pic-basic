Hseropen 9600
DIM temp AS BYTE 
DIM sign AS BYTE 

loop:
DS18S20START 
DS18S20READT temp, sign
Hserout "t : ", #temp, CrLf
WaitMs 100
Goto loop