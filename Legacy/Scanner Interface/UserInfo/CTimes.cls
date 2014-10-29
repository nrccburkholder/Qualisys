VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CTimes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"CTime"
Attribute VB_Ext_KEY = "Member0" ,"CTime"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable to hold collection
    Private moTimes As Collection
Public Property Get HoursOfOperation() As String
    
    Dim oTime As CTime
    Dim sMsg As String
    
    'Place the header in the string
    sMsg = "Start Time" & vbTab & "Finish Time" & vbTab & "Quantity"
    
    'Loop through all the times and build the string
    For Each oTime In moTimes
        sMsg = sMsg & vbCrLf & Format(oTime.StartTime, "hh:nn:ss am/pm") & vbTab & Format(oTime.EndTime, "hh:nn:ss am/pm") & vbTab & oTime.QtyAllowed
    Next oTime
    
    'Set the return value
    HoursOfOperation = sMsg
    
End Property

Public Sub Populate(ByVal sParamString As String)
    
    Dim oTimesToken As New CToken
    Dim oTimeToken As CToken
    Dim dtStart As Date
    Dim dtEnd As Date
    Dim nQuantity As Integer
    
    'Add the param string to the token parser
    oTimesToken.ParseString = sParamString
    oTimesToken.Delimiter = ";"
    
    'Loop through all of the time periods and add them to the collection
    Do Until oTimesToken.IsFinished
        'Setup this time period token
        Set oTimeToken = New CToken
        oTimeToken.ParseString = oTimesToken.GetNextToken
        oTimeToken.Delimiter = ","
        
        'Format the values to be added
        dtStart = CDate(Date & " " & oTimeToken.GetNextToken)
        dtEnd = CDate(Date & " " & oTimeToken.GetNextToken)
        nQuantity = Val(oTimeToken.GetNextToken)
        
        'Add this time period to the collection
        Add dtStartTime:=dtStart, dtEndTime:=dtEnd, nQtyAllowed:=nQuantity
    Loop
    
End Sub

Public Function IsQtyValid(ByVal dtTime As Date, ByVal nQtyRunning As Integer) As Boolean

    Dim bReturn As Boolean
    Dim oTime   As CTime
    
    'Pesimistic initialization
    bReturn = False
    
    'Determine if we are in a valid time frame
    For Each oTime In moTimes
        If oTime.StartTime <= dtTime And oTime.EndTime >= dtTime Then
            If nQtyRunning > oTime.QtyAllowed Then
                bReturn = False
            Else
                bReturn = True
            End If
            Exit For
        End If
    Next oTime
    
    'Cleanup
    Set oTime = Nothing
    
    'Set return value
    IsQtyValid = bReturn
    
End Function

Public Function IsTimeValid(ByVal dtTime As Date) As Boolean

    Dim bReturn As Boolean
    Dim oTime   As CTime
    
    'Pesimistic initialization
    bReturn = False
    
    'Determine if we are in a valid time frame
    For Each oTime In moTimes
        If oTime.StartTime <= dtTime And oTime.EndTime >= dtTime Then
            bReturn = True
            Exit For
        End If
    Next oTime
    
    'Cleanup
    Set oTime = Nothing
    
    'Set return value
    IsTimeValid = bReturn
    
End Function

Public Sub Clear()
    
    Dim nCnt As Long
    
    For nCnt = 1 To Count
        Remove 1
    Next nCnt
    
End Sub


Public Function Add(ByVal dtStartTime As Date, ByVal dtEndTime As Date, ByVal nQtyAllowed As Integer) As CTime
    
    Dim oTime As CTime
    
    'create a new object
    Set oTime = New CTime
    
    'Set the properties passed into the method
    With oTime
        .StartTime = dtStartTime
        .EndTime = dtEndTime
        .QtyAllowed = nQtyAllowed
    End With
    
    'Add this item to the collection
    moTimes.Add oTime
    
    'Return the object created
    Set Add = oTime
    Set oTime = Nothing
    
End Function

Public Property Get Item(ByVal vIndexKey As Variant) As CTime
Attribute Item.VB_UserMemId = 0
    
    On Error Resume Next
    Set Item = moTimes(vIndexKey)
    If Err.Number <> 0 Then
        Err.Clear
        Set Item = Nothing
    End If
    
End Property



Public Property Get Count() As Long
    
    Count = moTimes.Count
    
End Property


Public Sub Remove(ByVal vIndexKey As Variant)
    
    moTimes.Remove vIndexKey
    
End Sub


Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = moTimes.[_NewEnum]
    
End Property


Private Sub Class_Initialize()
    
    'creates the collection when this class is created
    Set moTimes = New Collection
    
End Sub


Private Sub Class_Terminate()
    
    'destroys collection when this class is terminated
    Set moTimes = Nothing
    
End Sub

