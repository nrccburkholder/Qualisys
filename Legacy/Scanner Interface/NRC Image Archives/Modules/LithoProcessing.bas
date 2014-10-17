Attribute VB_Name = "modLithoProcessing"
Option Explicit

    
    
    
Public Function Crunch(ByVal lLithoCode As Long) As String
    
    Dim sTemp          As String
    Dim lOrigLithoCode As Long
    Dim lCnt           As Long
    Dim lTemp          As Long
        
    Const knDigits      As Integer = 6
    Const ksLookUpTable As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
    If lLithoCode < 0 Then
        Crunch = -1
        Exit Function
    End If
    
    lOrigLithoCode = lLithoCode
    
    For lCnt = knDigits To 0 Step -1
        lTemp = Int(lLithoCode / (Len(ksLookUpTable) ^ lCnt))
        sTemp = sTemp & Mid(ksLookUpTable, lTemp + 1, 1)
        lLithoCode = lLithoCode - (lTemp * (Len(ksLookUpTable) ^ lCnt))
    Next lCnt
    
    If lOrigLithoCode <> UnCrunch(sBarCode:=sTemp) Then
        Crunch = -1
    Else
        Crunch = Right("000000" & sTemp, 6)
    End If
    
End Function

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
'\\     Returns TRUE if the check digit is valid and false if it is not.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function IsCheckDigitValid(ByVal sBarCode As String) As Boolean
    
    Dim sOrigCheckDigit As String
    Dim sTempCheckDigit As String
    Dim sCheckCode      As String
    Dim nCheckCnt       As Integer
    Dim nStrPos         As Integer
    
    Const ksBarcodeDigits = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-.!$/+%"
    
    'Divide the string into it's component parts
    sBarCode = UCase(sBarCode)
    sOrigCheckDigit = Right(sBarCode, 1)
    sCheckCode = Left(sBarCode, Len(sBarCode) - 1)
    
    'If the original check digit is a space then set it to an exclamation point
    If sOrigCheckDigit = " " Then sOrigCheckDigit = "!"
    
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
    IsCheckDigitValid = (sTempCheckDigit = sOrigCheckDigit)
    
End Function



Public Function UnCrunch(ByVal sBarCode As String) As String

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
    UnCrunch = Trim(Str(lTemp))
    
End Function

