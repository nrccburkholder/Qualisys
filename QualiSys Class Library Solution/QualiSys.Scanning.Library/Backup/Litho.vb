Public Class Litho
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This function converts a lithocode into a barcode
    ''' </summary>
    ''' <param name="lithoCode">The lithocode to convert</param>
    ''' <returns>The barcode string for this lithocode.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function LithoToBarcode(ByVal lithoCode As Integer) As String

        Return LithoToBarcode(lithoCode, True, 1)

    End Function


    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This function converts a lithocode into a barcode.
    ''' </summary>
    ''' <param name="lithoCode">The lithocode to be converted.</param>
    ''' <param name="includeCheckDigit">Indicates whether or not to include a 
    ''' check digit in the returned barcode.  
    ''' </param>
    ''' <param name="pageNumber">The page number to be included</param>
    ''' <returns>The barcode string for this lithocode.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    '''     [JFleming]  4/5/2000    Created
    ''' 	[JCamp]     7/30/2004	Converted to .NET
    '''     [JFleming]  03/16/2007  Corrected to allow for Option Strict On
    '''     [JFleming]  04/28/2009  Corrected call to BarcodeToLitho by sending only
    '''                             the last 6 characters of the Barcode string.
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function LithoToBarcode(ByVal lithoCode As Integer, _
                                          ByVal includeCheckDigit As Boolean, _
                                          ByVal pageNumber As Integer) As String

        Dim temp As String = String.Empty
        Dim origLithoCode As Integer
        Dim cnt As Integer
        Dim curValue As Integer
        Dim barcode As String = String.Empty

        Const kDigits As Integer = 6
        Const kLookUpTable As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

        'Check to see if the litho code is out of range
        If lithoCode < 0 Then
            Return CStr(-1)
        End If

        'Store off the original litho code
        origLithoCode = lithoCode

        'Build the base barcode value
        For cnt = kDigits To 0 Step -1
            curValue = CType(Int(lithoCode / (kLookUpTable.Length ^ cnt)), Integer)
            temp &= kLookUpTable.Substring(curValue, 1)
            lithoCode -= CType(curValue * (kLookUpTable.Length ^ cnt), Integer)
        Next cnt

        'Validate the barcode
        If origLithoCode <> CType(BarcodeToLitho(temp.Substring(temp.Length - kDigits)), Integer) Then
            'Barcode is invalid
            barcode = CStr(-1)
        Else
            'Barcode is valid
            temp = temp.PadLeft(kDigits + 1, "0"c)
            barcode = temp.Substring(temp.Length - kDigits)

            'If we are to include the check digit then do it now
            If includeCheckDigit Then
                barcode &= pageNumber
                barcode &= GetCheckDigit(barcode)
            End If
        End If

        'Set the return value
        Return barcode

    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This function calculates the barcode check digit.
    ''' </summary>
    ''' <param name="barCode">The barcode to calculate the checkdigit for.</param>
    ''' <returns>The check digit for the supplied barcode.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    '''     [JFleming]  4/5/2000    Created
    ''' 	[JCamp]	    7/30/2004	Converted to .NET
    '''     [JFleming]  8/17/2004   Corrected substring index calculations.
    '''     [JFleming]  03/16/2007  Corrected to allow for Option Strict On
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetCheckDigit(ByVal barCode As String) As String

        Dim tempCheckDigit As String = String.Empty
        Dim checkCode As String = String.Empty
        Dim checkCnt As Integer
        Dim position As Integer

        Const kBarcodeDigits As String = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-.!$/+%"

        'Divide the string into it's component parts
        checkCode = barCode.ToUpper

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
        Return tempCheckDigit

    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This function validates the barcode check digit.
    ''' </summary>
    ''' <param name="barCode">The original barcode to be checked.</param>
    ''' <returns>True if the check digit is valid, otherwise False.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    '''     [JFleming]  4/5/2000    Created
    ''' 	[JCamp]	    7/30/2004	Converted to .NET
    '''     [JFleming]  8/17/2004   Corrected substring index calculations.
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function IsCheckDigitValid(ByVal barCode As String) As Boolean

        Dim origCheckDigit As String = String.Empty
        Dim checkCode As String = String.Empty

        'Divide the string into it's component parts
        barCode = barCode.ToUpper
        origCheckDigit = barCode.Substring(barCode.Length - 1)
        checkCode = barCode.Substring(0, barCode.Length - 1)

        'If the original check digit is a space then set it to an exclamation point
        If origCheckDigit = " " Then origCheckDigit = "!"

        'Determine the return value
        IsCheckDigitValid = ((GetCheckDigit(checkCode)) = origCheckDigit)

    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This function converts a barcode into a lithocode.
    ''' </summary>
    ''' <param name="barCode">The original barcode to be converted.</param>
    ''' <returns>The LithoCode for the supplied BarCode.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    '''     [JFleming]  4/5/2000    Created
    ''' 	[JCamp]	    7/30/2004	Converted to .NET
    '''     [JFleming]  03/16/2007  Corrected to allow for Option Strict On
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function BarcodeToLitho(ByVal barCode As String) As String

        Dim currentDigit As Char
        Dim temp As Integer
        Dim convertedDigit As Integer
        Dim currentDecimal As Integer
        Dim base10 As Integer
        Dim cnt As Integer

        Const kLookUpTable As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

        'We only want the first 6 characters of the barcode for this operation
        If barCode.Length < 6 Then
            'Barcode is too short
            Return ""
        Else
            'Use only first 6 characters
            barCode = barCode.Substring(0, 6)
        End If

        'Build the litho code
        currentDecimal = barCode.Length - 2
        For cnt = 1 To barCode.Length
            currentDigit = CType(barCode.Substring(cnt - 1, 1), Char)
            base10 = kLookUpTable.IndexOf(currentDigit)
            convertedDigit = base10 * kLookUpTable.Length
            temp += CType(convertedDigit * (kLookUpTable.Length ^ currentDecimal), Integer)
            currentDecimal -= 1
        Next cnt

        'Return the lithocode
        Return temp.ToString.Trim

    End Function

End Class
