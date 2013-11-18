Define SIMULATION_WAITMS_VALUE = 1

Define CONF_WORD = 0x3f71
Define CLOCK_FREQUENCY = 4

Define ADC_CLOCK = 3
Define ADC_SAMPLEUS = 50

Define 1WIRE_REG = PORTD
Define 1WIRE_BIT = 5

Define LCD_BITS = 8
Define LCD_DREG = PORTD
Define LCD_DBIT = 0
Define LCD_RSREG = PORTE
Define LCD_RSBIT = 0
Define LCD_RWREG = PORTE
Define LCD_RWBIT = 1
Define LCD_EREG = PORTE
Define LCD_EBIT = 2
Define LCD_READ_BUSY_FLAG = 1

PIE1.RCIE = True

Dim temp As Byte
Dim temp2 As Bit
Dim sign As Byte
Dim sec As Word
Dim min As Word
Dim hours As Word
Dim days As Word
Dim digit1 As Byte
Dim digit2 As Byte
Dim digit3 As Byte
Dim digit4 As Byte
Dim memory_counter As Byte
Dim packet_counter As Byte
Dim adc_latest As Byte
Dim apointer As Byte
Dim a As Byte
Dim an0 As Byte
Dim an01 As Byte

TRISB = %00000000  'port which is connected to 7 segments"
TRISC.0 = 0  'pins of indicator select
TRISC.1 = 0
TRISC.2 = 0
Symbol select_port = PORTC
Symbol segment_port = PORTB
Lcdinit
Hseropen 9600
Hserout "Device started", CrLf

main:
sec = 0
min = 0
hours = 0
days = 0
If PIR1.RCIF = True Then
        Hserout "Receive interrupt!", CrLf
        Hserout "U sent symbol which ASCII code is ", #RCREG, CrLf
        apointer = packet_counter * 3 + 1
        Read apointer, adc_latest
        Hserout "Latest storage ADC value is ", #adc_latest, CrLf
Else
        Lcdcmdout LcdClear
        Adcin 0, an0
        Hserout "ADC value: ", #an0, CrLf
        Lcdcmdout LcdLine1Home
        Lcdout #an0
        digit1 = an0 / 1000
        an01 = an0 Mod 1000
        digit2 = an01 / 100
        an01 = an01 Mod 100
        digit3 = an01 / 10
        an01 = an0 Mod 10
        digit4 = an01
        Call show_digit(digit1, 1)  'don't forget set pin connected to 7-segment
        WaitMs 10
        Call show_digit(digit2, 2)
        WaitMs 10
        Call show_digit(digit3, 3)
        WaitMs 10
        Call show_digit(digit1, 4)
        WaitMs 10
        Lcdcmdout LcdLine2Home
        Hserout "t,c value: "
        DS18S20Start
        WaitMs 1000
        DS18S20ReadT temp, sign
        If sign > 0 Then
                Hserout "-"
                Lcdout "-"
                temp = 255 - temp
                temp = temp + 1
        Endif
        temp2 = temp.0
        temp = temp / 2
        Lcdout #temp
        Hserout #temp
        If temp2 = 1 Then
        Lcdout ".5"
        Hserout ".5", CrLf
        Else
        Lcdout ".0"
        Hserout ".0", CrLf
        Endif
        memory_counter = 1
        Write memory_counter, an0
        memory_counter = memory_counter + 1
        Write memory_counter, sign
        memory_counter = memory_counter + 1
        Write memory_counter, temp
        memory_counter = memory_counter + 1
        packet_counter = packet_counter + 1
        If memory_counter = 255 Then
        memory_counter = 1
        packet_counter = 0
        Endif
        WaitMs 3960
Endif
Goto main
End                                              

Proc show_digit(digit As Byte, pin As Byte)
select_port = pin_on(pin)  'POS(a) bit mask function
segment_port = get_mask(digit)
select_port = 0
End Proc                                          

Function get_mask(digit As Byte) As Byte
get_mask = LookUp(0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f), digit
End Function                                      

Function pin_on(pin As Byte) As Byte
pin_on = LookUp(1, 2, 4, 8, 16, 32, 64, 128), pin  'tirn on one individual pin
End Function