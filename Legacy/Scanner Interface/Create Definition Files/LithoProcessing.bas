Attribute VB_Name = "modLithoProcessing"
Option Explicit

    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   LithoToBarcode
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This function converts a lithocode into a barcode.
'\\
'\\ Parameters:
'\\     Name                Type    Description
'\\     lLithoCode          Long    The lithocode to be converted.
'\\     bIncludeCheckDigit  Boolean Indicates whether or not to include
'\\                                 a check digit in the returned
'\\                                 barcode.  If TRUE the nPageNumber
'\\                                 must also be supplied.
'\\     nPageNumber         Integer The page number to be included if
'\\                                 the bIncludeCheckDigit option is
'\\                                 used.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     String      The barcode based on the supplied LithoCode.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function LithoToBarcode(ByVal lLithoCode As Long, _
                               Optional ByVal bIncludeCheckDigit As Boolean = False, _
                               Optional ByVal nPageNumber As Integer = 1) As String
    
    Dim sTemp           As String
    Dim lOrigLithoCode  As Long
    Dim lCnt            As Long
    Dim lTemp           As Long
    Dim sBarCode        As String
    
    Const knDigits      As Integer = 6
    Const ksLookUpTable As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    If lLithoCode < 0 Then
        LithoToBarcode = -1
        Exit Function
    End If
    
    lOrigLithoCode = lLithoCode
    
    For lCnt = knDigits To 0 Step -1
        lTemp = Int(lLithoCode / (Len(ksLookUpTable) ^ lCnt))
        sTemp = sTemp & Mid(ksLookUpTable, lTemp + 1, 1)
        lLithoCode = lLithoCode - (lTemp * (Len(ksLookUpTable) ^ lCnt))
    Next lCnt
    
    If lOrigLithoCode <> BarcodeToLitho(sBarCode:=sTemp) Then
        sBarCode = -1
    Else
        sBarCode = Right("000000" & sTemp, 6)
        If bIncludeCheckDigit Then
            sBarCode = sBarCode & nPageNumber
            sBarCode = sBarCode & GetCheckDigit(sBarCode:=sBarCode)
        End If
    End If
    
    LithoToBarcode = sBarCode
    
End Function


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetCheckDigit
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This function calculates the barcode check digit.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     sBarcode    String      The barcode to calculate the checkdigit
'\\                             for.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     String      The check digit for the supplied barcode
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function GetCheckDigit(ByVal sBarCode As String) As String
    
    Dim sTempCheckDigit As String
    Dim sCheckCode      As String
    Dim nCheckCnt       As Integer
    Dim nStrPos         As Integer
    
    Const ksBarcodeDigits = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-.!$/+%"
    
    'Divide the string into it's component parts
    sCheckCode = UCase(sBarCode)
    
    'Accumulate the checksum of all of the digits
    nCheckCnt = 0
    For nStrPos = 1 To Len(sCheckCode)
        'Get the current digit to be checksummed
        sTempCheckDigit = Mid(sCheckCode, nStrPos, 1)
        
        'If this digit is a space then set it to an exclamation point
        If sTempCheckDigit = " " Then sTempCheckDigit = "!"
        
        'Add the checksum value
        nCheckCnt = nCheckCnt + InStr(ksBarcodeDigits, sTempCheckDigit)
    Next nStrPos
    
    'Determine the check digit
    If (nCheckCnt Mod (Len(ksBarcodeDigits) + 1)) = 0 Then
        sTempCheckDigit = "0"
    Else
        sTempCheckDigit = Mid(ksBarcodeDigits, (nCheckCnt Mod (Len(ksBarcodeDigits) + 1)), 1)
    End If
    
    'Determine the return value
    GetCheckDigit = sTempCheckDigit
    
End Function


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   IsCheckDigitValid
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This function validates the barcode check digit.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     sBarcode    String      The original barcode to be checked.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  - If the check digit is valid.
'\\                 FALSE - If the check digit is not valid.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function IsCheckDigitValid(ByVal sBarCode As String) As Boolean
    
    Dim sOrigCheckDigit As String
    Dim sCheckCode      As String
    
    'Divide the string into it's component parts
    sBarCode = UCase(sBarCode)
    sOrigCheckDigit = Right(sBarCode, 1)
    sCheckCode = Left(sBarCode, Len(sBarCode) - 1)
    
    'If the original check digit is a space then set it to an exclamation point
    If sOrigCheckDigit = " " Then sOrigCheckDigit = "!"
    
    'Determine the return value
    IsCheckDigitValid = ((GetCheckDigit(sBarCode:=sCheckCode)) = sOrigCheckDigit)
    
End Function


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   BarcodeToLitho
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This function converts a barcode into a lithocode.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     sBarcode    String      The original barcode to be converted.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     String      The LithoCode for the supplied BarCode.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function BarcodeToLitho(ByVal sBarCode As String) As String

    Dim sCurrentDigit   As String * 1
    Dim lTemp           As Long
    Dim lConvertedDigit As Long
    Dim lCurrentDecimal As Long
    Dim lBase10         As Long
    Dim lCnt            As Long
    
    Const ksLookUpTable As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    lCurrentDecimal = Len(sBarCode) - 2
    For lCnt = 1 To Len(sBarCode)
        sCurrentDigit = Mid(sBarCode, lCnt, 1)
        lBase10 = InStr(ksLookUpTable, sCurrentDigit) - 1
        lConvertedDigit = lBase10 * Len(ksLookUpTable)
        lTemp = lTemp + lConvertedDigit * (Len(ksLookUpTable) ^ lCurrentDecimal)
        lCurrentDecimal = lCurrentDecimal - 1
    Next lCnt
    BarcodeToLitho = Trim(Str(lTemp))
    
End Function

