VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "RelationCollDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' SH 08-20-02 Removed MTS and ObjectContext.
Option Explicit

Private objBuffer As Buffer

Public Sub Fetch(aTableID As Long)
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    Dim udtProps As RelationProps
    Dim udtData As RelationData
    
    On Error GoTo errhandler
    
    sSQL = "select * from metalookup where (nummasterTable_id = " & aTableID
    sSQL = sSQL & " ) OR (numLkupTable_id = " & aTableID & " )"
    
    Set objBuffer = New Buffer
    objBuffer.Initialize Len(udtData), 10
    
    
    Set rs = cn.Execute(sSQL)
    If Not rs.BOF And Not rs.EOF Then
        Do While Not rs.EOF
            With udtProps
                .masterTableID = rs("nummasterTable_id")
                .masterFieldID = rs("numMasterField_ID")
                .lookupTableID = rs("numLkupTable_id")
                .lookupFieldID = rs("numLkupField_id")
                .currentTableID = aTableID
            End With
            LSet udtData = udtProps
            objBuffer.Add udtData.Buffer
            rs.MoveNext
        Loop
    End If
    rs.Close
    Set rs = Nothing
    
    Exit Sub

errhandler:
    App.LogEvent "Relation Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
                 
    If Not rs Is Nothing Then
        If rs.State = adStateOpen Then rs.Close
        Set rs = Nothing
    End If
    
    Err.Raise vbObjectError
End Sub

Public Function GetState() As String
    GetState = objBuffer.GetState
End Function
