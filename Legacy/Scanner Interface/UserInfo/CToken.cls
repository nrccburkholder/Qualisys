VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CToken"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

    Private msParseString As String
    Private msDelimiter As String
    Private mnNextStartPosition As Integer
    Private mnQtyTokensParsed As Integer
    
    Private Const mknMaxSignedInt As Integer = 32767

Public Property Get Delimiter() As String
    
    Delimiter = msDelimiter

End Property


Public Property Let Delimiter(ByVal sData As String)
    
    msDelimiter = sData

End Property


Public Function GetNextToken(Optional nStartPos As Integer) As String

    Dim nNextDelimPos As Integer
    
    If nStartPos > 0 Then
        mnNextStartPosition = nStartPos
    ElseIf mnNextStartPosition = mknMaxSignedInt Then
        'There can be no more tokens to parse in this string
        GetNextToken = ""
    Else
        'Move past the delim
        mnNextStartPosition = mnNextStartPosition + 1
    End If
    
    If mnNextStartPosition > Len(msParseString) Then
        'Start position points beyond end of string
         GetNextToken = ""
        Exit Function
    End If
    
    'Starting at mnNextStartPosition look ahead to see the next delimiter
    mnQtyTokensParsed = mnQtyTokensParsed + 1
    nNextDelimPos = InStr(mnNextStartPosition, msParseString, msDelimiter, 1)
    If nNextDelimPos > mnNextStartPosition Then
        GetNextToken = Mid(msParseString, mnNextStartPosition, (nNextDelimPos - mnNextStartPosition))
        mnNextStartPosition = nNextDelimPos
    ElseIf nNextDelimPos = mnNextStartPosition Then
        GetNextToken = ""
    Else
        'We are now getting the last token in the string
        GetNextToken = Mid(msParseString, mnNextStartPosition)
        'Set to max int as there is no further delimiters
        mnNextStartPosition = mknMaxSignedInt
    End If
        
End Function


Public Property Let ParseString(ByVal sData As String)
   
    msParseString = sData
    mnNextStartPosition = 0
    mnQtyTokensParsed = 0

End Property


Public Property Get ParseString() As String
    
    ParseString = msParseString

End Property



Private Sub Class_Initialize()
   
   mnNextStartPosition = 0
   msDelimiter = ","

End Sub


Public Sub EmptyParseString()
    
    msParseString = ""
    mnNextStartPosition = 0

End Sub

Public Function IsParseStringSet() As Boolean
    
    IsParseStringSet = (Len(msParseString) = 0)

End Function

Public Function IsFinished() As Boolean
    
    IsFinished = mnNextStartPosition = mknMaxSignedInt

End Function
