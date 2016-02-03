Imports System.Math

Public Class BaseConverter    
    Private Const BIN_CHARS As String = "01"
    Private Const OCT_CHARS As String = "01234567"
    Private Const HEX_CHARS As String = "0123456789ABCDEF"
    Private Const B36_CHARS As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    Private Const CHK_CHARS As String = "&123456789ABCDEFGH*JKLMN+PQRSTUVWXYZ!@#$%"

    Public Enum Base As Integer
        Binary = 2
        Octal = 8
        Hexadecimal = 16
        Base36 = 36
        CheckDigit = 41
    End Enum

    Private Shared Function GetBaseAlphabet(ByVal base As Base) As Char()
        Select Case base
            Case base.Binary
                Return BIN_CHARS.ToCharArray
            Case base.Octal
                Return OCT_CHARS.ToCharArray
            Case base.Hexadecimal
                Return HEX_CHARS.ToCharArray
            Case base.Base36
                Return B36_CHARS.ToCharArray
            Case base.CheckDigit
                Return CHK_CHARS.ToCharArray
            Case Else
                Throw New ApplicationException("Undefined Base")
        End Select
    End Function

    Public Shared Function DecToBin(ByVal num As Double) As String        
        Return DecToBase(num, Base.Binary)
    End Function
    Public Shared Function BinToDec(ByVal binString As String) As Double
        Return BaseToDec(binString, Base.Binary)
    End Function
    Public Shared Function DecToHex(ByVal num As Double) As String
        Return DecToBase(num, Base.Hexadecimal)
    End Function
    Public Shared Function HexToDec(ByVal hexString As String) As Double
        Return BaseToDec(hexString, Base.Hexadecimal)
    End Function
    Public Shared Function DecToB36(ByVal num As Double) As String
        Return DecToBase(num, Base.Base36)
    End Function
    Public Shared Function B36ToDec(ByVal bString As String) As Double
        Return BaseToDec(bString, Base.Base36)
    End Function

    Public Shared Function GetAlphabet(ByVal base As Base) As String
        Return GetBaseAlphabet(base)
    End Function

    Public Shared Function DecToBase(ByVal num As Double, ByVal base As Base) As String
        Dim digits() As Integer = DecToDigits(num, base)
        Return DigitsToCharString(digits, base)
    End Function

    Public Shared Function BaseToDec(ByVal baseString As String, ByVal base As Base) As Double
        Dim digits() As Integer = CharStringToDigits(baseString, base)
        Return DigitsToDec(digits, base)
    End Function

    Private Shared Function DecToDigits(ByVal num As Double, ByVal base As Base) As Integer()
        Dim digits As New ArrayList
        Dim remainder As Integer

        While num > 0
            remainder = CType(num Mod base, Integer)
            num = Floor(num / base)
            digits.Insert(0, remainder)
        End While

        Return CType(digits.ToArray(GetType(Integer)), Integer())

    End Function

    Private Shared Function DigitsToDec(ByVal digits() As Integer, ByVal base As Base) As Double
        Dim index As Integer
        Dim sum As Double = 0
        For exp As Integer = 0 To digits.Length - 1
            index = digits.Length - 1 - exp
            sum += digits(index) * (base ^ exp)
        Next

        Return sum
    End Function

    Private Shared Function DigitsToCharString(ByVal digits() As Integer, ByVal base As Base) As String
        Dim chars() As Char = GetBaseAlphabet(base)
        Dim charString As New System.Text.StringBuilder
        For Each d As Integer In digits
            charString.Append(chars(d))
        Next

        Return charString.ToString
    End Function

    Private Shared Function CharStringToDigits(ByVal charString As String, ByVal base As Base) As Integer()
        Dim chars() As Char = GetBaseAlphabet(base)
        Dim charList As New ArrayList(chars)
        Dim digits As New ArrayList

        For Each c As Char In charString.ToCharArray
            digits.Add(charList.IndexOf(c))
        Next

        Return CType(digits.ToArray(GetType(Integer)), Integer())
    End Function

    Private Shared Function IsValidCheckDigit(ByVal charString As String, ByVal checkDigit As String) As Boolean
        Return (checkDigit = ComputeCheckDigit(charString))
    End Function

    Public Shared Function ComputeCheckDigit(ByVal charString As String) As String
        Dim tempCheckDigit As String
        Dim checkCode As String
        Dim checkCnt As Integer
        Dim position As Integer

        Const kBarcodeDigits As String = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-.!$/+%"

        'Divide the string into it's component parts
        checkCode = charString.ToUpper

        'Accumulate the checksum of all of the digits
        checkCnt = 0
        For position = 1 To checkCode.Length
            'Get the current digit to be checksummed
            tempCheckDigit = checkCode.Substring(position - 1, 1)

            'If this digit is a space then set it to an exclamation point
            If tempCheckDigit = " " Then tempCheckDigit = "!"

            'Add the checksum value                        
            checkCnt += kBarcodeDigits.IndexOf(tempCheckDigit) + 1            
        Next position

        'Determine the check digit
        If (checkCnt Mod (kBarcodeDigits.Length + 1)) = 0 Then
            tempCheckDigit = "0"
        Else
            tempCheckDigit = kBarcodeDigits.Substring((checkCnt Mod (kBarcodeDigits.Length + 1)) - 1, 1)
        End If

        'Determine the return value
        'Bar Code 39 d font does not allow space or exclamation point.
        If tempCheckDigit = "!" Then
            Return "~"
        Else
            Return tempCheckDigit
        End If
    End Function

End Class
