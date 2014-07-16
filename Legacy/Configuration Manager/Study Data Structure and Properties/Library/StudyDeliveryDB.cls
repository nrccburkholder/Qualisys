VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StudyDeliveryDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' SH 08-20-02 Removed MTS and ObjectContext.
Option Explicit

Private udtProps As StudyDeliveryProps

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
        sSQL = "SELECT * from StudyDeliveryDate"
        rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
        rs.AddNew
    Else
        sSQL = "SELECT * from StudyDeliveryDate WHERE DeliveryDate_id=" & udtProps.ID
        rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
    End If
    
    rs("Study_id") = udtProps.StudyID
    rs("datDelivery_dt") = udtProps.DeliveryDate
    rs("strDelivery_dsc") = udtProps.Description
    rs("bitBillable") = udtProps.IsBillable
    rs("bitClientRequest") = udtProps.IsClientRequest
    rs("bitCorrection") = udtProps.IsCorrection
    rs("contact_id") = VB2DB_Long(udtProps.ContactID)
    rs("datWorked") = VB2DB_Date(udtProps.DateWorked)
    rs("intHoursWorked") = VB2DB_Long(udtProps.HoursWorked)
            
    rs.Update
    
    If udtProps.IsNew Then
      udtProps.ID = rs("DeliveryDate_id")
    End If
      
    'rs.Close
    Set rs = Nothing
                 
    Exit Sub
    
errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "StudyDelivery Save - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub DeleteObject(DeliveryDateID As Long)
    Dim sSQL As String
   
    On Error GoTo errhandler
      
    
    sSQL = "DELETE FROM StudyDeliveryDate WHERE DeliveryDate_id=" & DeliveryDateID
    cn.Execute sSQL
            
    Exit Sub
    
errhandler:
    App.LogEvent "StudyDelivery DeleteObject - " & _
                 Err.Description & "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub Fetch(ByVal DeliveryDateID As Long)
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    
    On Error GoTo errhandler
    
    sSQL = "SELECT * FROM StudyDeliveryDate WHERE DeliveryDate_id =" & DeliveryDateID
        
    Set rs = cn.Execute(sSQL)
    
    With rs
        If .BOF And .EOF Then
            ' nothing
            udtProps.ID = -1
            udtProps.StudyID = -1
            udtProps.DeliveryDate = 0
            udtProps.Description = ""
            udtProps.ContactID = -1
            udtProps.DateWorked = 0
            udtProps.IsBillable = False
            udtProps.IsClientRequest = False
            udtProps.IsCorrection = False
            udtProps.HoursWorked = -1
        Else
            udtProps.ID = DeliveryDateID
            udtProps.StudyID = rs("Study_id")
            udtProps.DeliveryDate = DB2VB_Date(rs, "datDelivery_dt")
            udtProps.Description = rs("strDelivery_dsc") & ""
            udtProps.ContactID = DB2VB_Long(rs, "contact_id")
            udtProps.DateWorked = DB2VB_Date(rs, "datWorked")
            udtProps.IsBillable = rs("bitBillable")
            udtProps.IsClientRequest = rs("bitClientRequest")
            udtProps.IsCorrection = rs("bitCorrection")
            udtProps.HoursWorked = DB2VB_Long(rs, "intHoursWorked")
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
    App.LogEvent "StudyDelivery Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Property Get IsDeleted() As Boolean
    IsDeleted = udtProps.IsDeleted
End Property

Public Sub SetState(Buffer As String)
    Dim udtData As StudyDeliveryData
  
    udtData.Buffer = Buffer
    LSet udtProps = udtData
End Sub

Public Function GetState() As String
    Dim udtData As StudyDeliveryData
  
    LSet udtData = udtProps
    GetState = udtData.Buffer
End Function
