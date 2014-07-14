VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StudyReportDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' SH 08-20-02 Removed MTS and ObjectContext.

Private udtProps As StudyReportProps

Public Sub SaveChild(StudyID As Long)
    
    With udtProps
        If .IsDeleted Then
            DeleteObject .ID
        ElseIf .IsDirty Or .IsNew Then
            .StudyID = StudyID
            Save
        End If
    End With

End Sub

Public Sub Save()
    
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    
    On Error GoTo errhandler
    
    If udtProps.IsNew Then
        sSQL = "SELECT * from StudyReportType"
        rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
        rs.AddNew
    Else
        sSQL = "SELECT * from StudyReportType WHERE StudyReportType_id=" & udtProps.ID
        rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
    End If
    
    rs("Study_id") = udtProps.StudyID
    rs("ReportType_id") = VB2DB_Long(udtProps.ReportType)
    rs("strReportNote") = udtProps.Description
    rs.Update
    
    If udtProps.IsNew Then
      udtProps.ID = rs("StudyReportType_id")
    End If
    
    rs.Close
    Set rs = Nothing
           
    Exit Sub

errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "StudyReport Save - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError

End Sub

Public Sub DeleteObject(StudyReportTypeID As Long)

    Dim sSQL As String
    
    On Error GoTo errhandler
    
    sSQL = "DELETE FROM StudyReportType WHERE StudyReportType_id=" & StudyReportTypeID
    cn.Execute sSQL
    
    Exit Sub
    
errhandler:
    App.LogEvent "StudyReport DeleteObject - " & _
                 Err.Description & "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError

End Sub

Public Sub Fetch(ByVal StudyReportTypeID As Long)
    
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
        
    On Error GoTo errhandler
    
    sSQL = "SELECT * FROM StudyReportType WHERE StudyReportType_id =" & StudyReportTypeID
    
    Set rs = cn.Execute(sSQL)
    
    With rs
        If .BOF And .EOF Then
            ' nothing
            udtProps.ID = -1
            udtProps.StudyID = -1
            udtProps.ReportType = -1
            udtProps.Description = ""
        Else
            udtProps.ID = StudyReportTypeID
            udtProps.StudyID = rs("Study_id")
            udtProps.ReportType = DB2VB_Long(rs, "ReportType_id")
            udtProps.Description = rs("strReportNote") & ""
        End If
        .Close
    End With
    
    Set rs = Nothing
    
    Exit Sub

errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "StudyReport Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError

End Sub

Public Property Get IsDeleted() As Boolean

    IsDeleted = udtProps.IsDeleted
    
End Property

Public Sub SetState(Buffer As String)
    
    Dim udtData As StudyReportData
  
    udtData.Buffer = Buffer
    LSet udtProps = udtData

End Sub

Public Function GetState() As String

    Dim udtData As StudyReportData
  
    LSet udtData = udtProps
    GetState = udtData.Buffer
        
End Function
