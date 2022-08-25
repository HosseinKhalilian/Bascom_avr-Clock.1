'======================================================================='

' Title: 4-Digit 7Seg LED Clock
' Last Updated :  04.2022
' Author : A.Hossein.Khalilian
' Program code  : BASCOM-AVR 2.0.8.5
' Hardware req. : ATmega8 + 4-Digit 7Segment

'======================================================================='

$regfile = "m8def.dat"
$crystal = 1000000

Config Portb = Output
Config Portc = Output
Config Portd = Input
Config Portd.6 = Output

Config Clock = Soft , Gosub = Sectic
Enable Interrupts
Time$ = "12:10:01"

Dp Alias Portd.6
Comm Alias Portc
Datport Alias Portb
Seet Alias Pind.4
Ad Alias Pind.0
De Alias Pind.7

Dim Dat As Byte
Dim V As Byte
Dim L As Byte
Dim A1 As Bit
Dim A2 As Bit
Dim A3 As Bit
Dim A4 As Bit

Declare Sub A
Declare Sub B
Declare Sub Refresh
Declare Sub F

A1 = 1
A2 = 1
A3 = 1
A4 = 1
V = 0


'-----------------------------------------------------------
Do

Call A
Call B

Loop

End

'-----------------------------------------------------------

Sub A

If Seet = 0 Then
Incr V
If V = 2 Then
 A1 = 0
 Else
 A1 = 1
 End If
If V = 1 Then
A4 = 0
Else
A4 = 1
End If

Call F
If V > 2 Then V = 0
End If

If V = 1 Then
If Ad = 0 Then
Incr _hour
If _hour > 23 Then _hour = 0
Call F
End If


If De = 0 Then
Decr _hour
If _hour < 1 Then _hour = 23
Call F
End If

End If

''''''''''''''''''''''''''''''

If V = 2 Then
If Ad = 0 Then
Incr _min
If _min > 59 Then _min = 0
Call F
End If

If De = 0 Then
Decr _min
If _min < 1 Then _min = 59
Call F
End If

End If
End Sub

''''''''''''''''''''''''''''''

Sub B

Comm = &B1000 : Dp = A1 : Dat = _min Mod 10 : Call Refresh
Comm = &B0100 : Dp = A2 : Dat = _min / 10 : Call Refresh
Comm = &B0010 : Dp = A3 : Dat = _hour Mod 10 : Call Refresh
Comm = &B0001 : Dp = A4 : Dat = _hour / 10 : Call Refresh

End Sub

''''''''''''''''''''''''''''''

Sub F

For L = 0 To 25
Call B
Next L

End Sub

''''''''''''''''''''''''''''''
Sub Refresh

Datport = Lookup(dat , Seg)
Waitms 5

End Sub

''''''''''''''''''''''''''''''
Seg:
Data &B11000000 , &B11111001 , &B10100100 , &B10110000
Data &B10011001 , &B10010010 , &B10000010 , &B11111000
Data &B10000000 , &B10010000

''''''''''''''''''''''''''''''

Sectic:
If V = 0 Then
Toggle A3
End If
Return

'-----------------------------------------------------------
