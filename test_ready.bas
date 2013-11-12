'QUESTIONS: INTERRUPTS ON COM PORT AND ADC INTERVAL

Define ADC_CLOCK = 3
Define ADC_SAMPLEUS = 50

Dim temp As Byte
Dim sign As Byte
Dim update_statistics_interval As Byte
Dim storage_days As Byte
Dim total_values As Byte
Dim start_memory_for_voltage As Byte
Dim end_memory_for_voltage As Byte
Dim start_memory_for_temperature As Byte
Dim end_memory_for_temperature As Byte
Dim adc_capacity As Byte
Dim aref As Byte  'analog reference in volt
Dim division_coeff As Byte
Dim i1 As Byte
Dim i2 As Byte
Dim i3 As Byte
Dim a As Byte
Dim b As Byte
Dim instant_max_voltage_value As Byte

Dim adc_count As Word  'samples for om
Dim a0 As Word
Dim inter_freq As Word  'interrupts frequency, Hz
Dim hz As Word
Dim voltage_update As Word
Dim j As Word  'TIMER in seconds

Dim i As Long
Dim k As Byte  'seconds counter

Hseropen 9600
TRISA = %111111  'set PORTA pins as inputs
ADCON0 = 0xc0  'set A/D conversion clock to internal source
ADCON1 = 0  'set PORTA pins as analog inputs
High ADCON0.ADON
adc_count = 25000
OPTION_REG.2 = 1
OPTION_REG.1 = 1
OPTION_REG.0 = 0  'prescaler 128. 4 000 000 / 128 = 31 250. i.e.

hz = 50
inter_freq = 31250  'interrupts occurs 31 250 times in second
voltage_update = inter_freq / hz  '31 250 / 50 = 625 times in second
update_statistics_interval = 30  'in minutes
storage_days = 1
total_values = storage_days * (60 * 24 / 30)

start_memory_for_voltage = 4
end_memory_for_voltage = 4 + total_values
start_memory_for_temperature = end_memory_for_voltage + 1
end_memory_for_temperature = start_memory_for_temperature + total_values  'must not be > than 255 for PIC16F877

adc_capacity = 5
instant_max_voltage_value = 0
a0 = 0

aref = 5
division_coeff = 32 / 5

INTCON.T0IE = 1
INTCON.GIE = True
OPTION_REG.T0CS = False  'Timer mode is selected by clearing this byte. TMR0 is prescaler
j = 0
End                                               

On Interrupt
i = i + 1  'can realize by case operator

i1 = i Mod voltage_update
	If i1 = 0 Then
		While j = adc_count
			Adcin 0, a0
				If instant_max_voltage_value > a0 Then instant_max_voltage_value = a0
		j = 0
		Wend
	Endif

i2 = i Mod inter_freq
	If i = 3 Then
		instant_max_voltage_value = instant_max_voltage_value * division_coeff
		Write 1, instant_max_voltage_value
		DS18S20Start
		DS18S20ReadT temp, sign
		Write 2, sign
		Write 3, temp
		Hserout "seconds: ", #k, CrLf
		k = k + 1
	Endif

i3 = inter_freq * 60 * update_statistics_interval
	If i = i3 Then
		For a = start_memory_for_voltage To end_memory_for_voltage
		Write a, instant_max_voltage_value
		Next a
		For b = start_memory_for_temperature To end_memory_for_temperature
		Write b, instant_max_voltage_value
		Next b
		INTCON.T0IF = 0  'timer overflow bit
		i = 0
	Endif
Resume                                            