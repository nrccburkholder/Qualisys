VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StudyComparisonDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' SH 08-20-02 Removed MTS and ObjectContext.
Option Explicit

Private udtProps As StudyComparisonProps

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
        sSQL = "SELECT * from StudyComparison"
        rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
        rs.AddNew
    Else
        sSQL = "SELECT * from StudyComparison WHERE StudyComparison_id=" & udtProps.ID
        rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
    End If
    
    rs("Study_id") = udtProps.StudyID
    rs("state_id") = VB2DB_Long(udtProps.State)
    rs("ComparisonType_id") = VB2DB_Long(udtProps.ComparisonType)
    rs("MktGuide_MSA_id") = VB2DB_Long(udtProps.MarketGuideMSA)
    rs("mktguideplantype_id") = VB2DB_Long(udtProps.MarketGuidePlanType)
    rs.Update
    
    If udtProps.IsNew Then
        udtProps.ID = rs("StudyComparison_id")
    End If
    
    rs.Close
    Set rs = Nothing
           
    Exit Sub
    
errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "StudyComparison Save - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub DeleteObject(StudyComparisonID As Long)
    Dim sSQL As String
  
    On Error GoTo errhandler
    
    
    sSQL = "DELETE FROM StudyComparison WHERE StudyComparison_id=" & StudyComparisonID
    cn.Execute sSQL
        
    Exit Sub

errhandler:
    App.LogEvent "StudyComparison DeleteObject - " & _
                 Err.Description & "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub Fetch(ByVal StudyComparisonID As Long)
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
        
    On Error GoTo errhandler
    
    sSQL = "SELECT * " & _
           "FROM StudyComparison SC LEFT OUTER JOIN mktguide_plantype MP " & _
                "ON MP.mktguideplantype_id = SC.mktguideplantype_id " & _
           "WHERE StudyComparison_id = " & StudyComparisonID & " "
    
    
    Set rs = cn.Execute(sSQL)
    
    With rs
        If .BOF And .EOF Then
            ' nothing
            udtProps.ID = -1
            udtProps.StudyID = -1
            udtProps.State = -1
            udtProps.ComparisonType = -1
            udtProps.MarketGuideMSA = -1
            udtProps.MarketGuidePlanType = -1
        Else
            udtProps.ID = StudyComparisonID
            udtProps.StudyID = rs("Study_id")
            udtProps.State = DB2VB_Long(rs, "state_id")
            udtProps.ComparisonType = DB2VB_Long(rs, "COMPARISONTYPE_ID")
            udtProps.MarketGuideMSA = DB2VB_Long(rs, "MktGuide_MSA_id")
            udtProps.MarketGuidePlanType = DB2VB_Long(rs, "mktguideplantype_id")
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
    App.LogEvent "StudyComparison Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Property Get IsDeleted() As Boolean
    IsDeleted = udtProps.IsDeleted
End Property

Public Sub SetState(Buffer As String)
    Dim udtData As StudyComparisonData
    
    udtData.Buffer = Buffer
    LSet udtProps = udtData
End Sub

Public Function GetState() As String
    Dim udtData As StudyComparisonData
    
    LSet udtData = udtProps
    GetState = udtData.Buffer
End Function
