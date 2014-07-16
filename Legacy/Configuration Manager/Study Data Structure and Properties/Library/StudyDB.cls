VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StudyDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
' SH 08-20-02 Removed MTS and ObjectContext.
Option Explicit

Private udtProps As StudyProps

'--------------------------------------------------------------------------------------------------------------
'- the following 3 elements are of type TEXT in the database
'--------------------------------------------------------------------------------------------------------------
Private strReportLevels As String
Private strObjectiveDeliverables As String
Private strObjectivesText As String

Private Const CHUNKSIZE = 1000

Private Function SQLString(sSQL As String) As String
    SQLString = ""
    While InStr(sSQL, "'") > 0
        SQLString = SQLString + Left(sSQL, InStr(sSQL, "'")) + "'"
        sSQL = Mid(sSQL, InStr(sSQL, "'") + 1)
    Wend
    SQLString = SQLString + sSQL
End Function

Public Sub Save()
    Dim sSQL As String
    Dim strStudy As String
    Dim rs As New ADODB.Recordset
    Dim objAdminDB As New AdminDB
  
    On Error GoTo errhandler
    
    ' 09-09-1999 DV
    ' Added new value for Phone Number checking
    If udtProps.IsNew Then
        sSQL = "INSERT INTO Study "
        sSQL = sSQL & "(strStudy_nm, strStudy_dsc, Client_id, intPopulationTableID, intEncounterTableID, intProviderTableID, bitCleanAddr, bitstudyongoing, datcreate_dt, datClose_dt)"
        sSQL = sSQL & " values ('"
        sSQL = sSQL & Trim(SQLString(udtProps.name)) & "','"
        sSQL = sSQL & Trim(SQLString(udtProps.Description)) & "',"
        sSQL = sSQL & VB2DB_Long(udtProps.ClientID) & ","
        sSQL = sSQL & "-1,-1,-1,1,1,getdate(),'12:00 AM')" & vbCr
        cn.Execute sSQL
        sSQL = "Select @@IDENTITY as NewStudy_id"
        rs.Open sSQL, cn, adOpenForwardOnly
        udtProps.ID = rs("NewStudy_id")
        rs.Close
        strStudy = udtProps.ID
        'sSQL = "exec dbo.sp_CFG_FullAccessEmp " & rsID("NewStudy_id")
        sSQL = "INSERT INTO Study_Employee (Employee_id, Study_id) " & _
        "SELECT Employee_id, " & strStudy & _
        " From Employee " & _
        "Where FullAccess = 1 " & _
        "AND Employee_id NOT IN ( " & _
        "SELECT Employee_id FROM Study_Employee " & _
        "WHERE Study_id = " & strStudy & ")"
        cn.Execute sSQL
    Else
        strStudy = udtProps.ID
    End If
    
    sSQL = "SELECT * from Study WHERE Study_id=" & strStudy
    rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
    
    'added code to fix issue 469, DW
    rs("strStudy_nm") = udtProps.name
    rs("strStudy_dsc") = udtProps.Description
    rs("Client_id") = VB2DB_Long(udtProps.ClientID)
    rs("datCreate_dt") = VB2DB_Date(udtProps.CreationDate)
    rs("datClose_dt") = udtProps.CloseDate
    rs("datContractStart") = udtProps.ContractStartDate
    rs("datContractEnd") = udtProps.ContractEndDate
    'rs("strCutOffResponse_Cd") = udtProps.CutOffResponseCode
    rs("strAccounting_cd") = udtProps.AccountingCode
    rs("strBBS_username") = udtProps.BBSUserName
    rs("strBBS_password") = udtProps.BBSPassword
    rs("intArchive_months") = VB2DB_Long(udtProps.ArchiveMonths)
    'rs("bitDynamic") = udtProps.IsDynamic
    rs("bitStudyOngoing") = udtProps.IsStudyOnGoing
    rs("intAP_NumReports") = VB2DB_Long(udtProps.NumberOfReports)
    rs("intAP_ConfInterval") = VB2DB_Long(udtProps.ConfidenceInterval)
    rs("intAP_ErrorMargin") = VB2DB_Long(udtProps.ErrorMargin)
    rs("intAP_CutoffTarget") = VB2DB_Long(udtProps.CutOffTarget)
    rs("datObjectiveSignOff_dt") = VB2DB_Date(udtProps.ObjectiveSignOffDate)
    rs("curBudgetAmt") = VB2DB_Amount(udtProps.BudgetAmount)
    rs("curTotalSpent") = VB2DB_Amount(udtProps.TotalSpent)
    rs("strAP_BelowQuota") = udtProps.ActionPlanBelowQuata
    rs("bitCleanAddr") = udtProps.UseAddressCleaning
    rs("bitCheckPhon") = udtProps.UsePhoneChecking
    rs("bitProperCase") = udtProps.UseProperCase
    rs("Country_id") = udtProps.CountryID
      
    SaveStudyChunkData rs, "strReportLevels", ReportLevels
    SaveStudyChunkData rs, "strObjectiveDeliverables", ObjectiveDeliverables
    SaveStudyChunkData rs, "strObjectives_txt", ObjectivesText
        
    If udtProps.AccountDirectorEmployeeID < 1 Then
        rs("ADEmployee_id") = Null
    Else
        rs("ADEmployee_id") = udtProps.AccountDirectorEmployeeID
    End If
    
    rs.Update
             
    rs.Close
    Set rs = Nothing

    Exit Sub
    
errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "Study Save - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub DeleteObject(ByVal StudyID As Long)
    Dim sSQL As String
    Dim objAdminDB As New AdminDB
    
    On Error GoTo errhandler
   
    sSQL = "DELETE FROM Study WHERE Study_ID=" & StudyID
    cn.Execute sSQL
       
    'TODO make the following line work
    'NOTE:  cannot delete a user if tables have already
    ' beed created for that user.
    ' objAdminDB.DeleteStudyAsUser StudyID
    
    Exit Sub

errhandler:
    App.LogEvent "Study DeleteObject - " & _
    Err.Description & "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub Fetch(ByVal StudyID As Long)
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    
    On Error GoTo errhandler
    
    ' 09-09-1999 - Added query to get the phone number check bit.
    sSQL = "SELECT strStudy_nm, strStudy_dsc, Client_id, datCreate_dt, datClose_dt, datContractStart, datContractEnd, strAccounting_cd, strBBS_username, strBBS_password, intArchive_months, bitStudyOngoing, intAP_NumReports, intAP_ConfInterval, intAP_ErrorMargin, intAP_CutoffTarget, datObjectiveSignOff_dt, curBudgetAmt, curTotalSpent, strAP_BelowQuota, ADEmployee_id, bitCleanAddr, bitCheckPhon, bitProperCase, isnull(country_id,1) as country_id "
    sSQL = sSQL & " FROM Study WHERE Study_id = " & StudyID
    Set rs = cn.Execute(sSQL)
    
    With rs
        If .BOF And .EOF Then
            ' nothing
        Else
            udtProps.ID = StudyID
            udtProps.name = rs.Fields("strStudy_nm").Value & ""
            udtProps.Description = rs("strStudy_dsc") & ""
            udtProps.ClientID = DB2VB_Long(rs, "Client_id")
            udtProps.CreationDate = DB2VB_Date(rs, "datCreate_dt")
            udtProps.CloseDate = DB2VB_Date(rs, "datClose_dt")
            udtProps.ContractStartDate = DB2VB_Date(rs, "datContractStart")
            udtProps.ContractEndDate = DB2VB_Date(rs, "datContractEnd")
            udtProps.AccountingCode = rs("strAccounting_cd") & ""
            udtProps.BBSUserName = rs("strBBS_username") & ""
            udtProps.BBSPassword = rs("strBBS_password") & ""
            udtProps.ArchiveMonths = DB2VB_Long(rs, "intArchive_months")
            udtProps.IsStudyOnGoing = DB2VB_Boolean(rs, "bitStudyOngoing")
            udtProps.NumberOfReports = DB2VB_Long(rs, "intAP_NumReports")
            udtProps.ConfidenceInterval = DB2VB_Long(rs, "intAP_ConfInterval")
            udtProps.ErrorMargin = DB2VB_Long(rs, "intAP_ErrorMargin")
            udtProps.CutOffTarget = DB2VB_Long(rs, "intAP_CutoffTarget")
            udtProps.ObjectiveSignOffDate = DB2VB_Date(rs, "datObjectiveSignOff_dt")
            udtProps.BudgetAmount = DB2VB_Amount(rs, "curBudgetAmt")
            udtProps.TotalSpent = DB2VB_Amount(rs, "curTotalSpent")
            udtProps.ActionPlanBelowQuata = rs("strAP_BelowQuota") & ""
            udtProps.AccountDirectorEmployeeID = DB2VB_Long(rs, "ADEmployee_id")
            udtProps.UseAddressCleaning = rs("bitCleanAddr")
            udtProps.UsePhoneChecking = rs("bitCheckPhon")
            udtProps.UseProperCase = rs("bitProperCase")
            udtProps.CountryID = rs("Country_id")
        End If
        .Close
    End With
    
    Set rs = Nothing
    
    strReportLevels = FetchStudyChunkData(StudyID, "strReportLevels")
    strObjectiveDeliverables = FetchStudyChunkData(StudyID, "strObjectiveDeliverables")
    strObjectivesText = FetchStudyChunkData(StudyID, "strObjectives_txt")
    
    Exit Sub

errhandler:
    If Not rs Is Nothing Then
        If rs.State = adStateOpen Then
            rs.Close
        End If
        Set rs = Nothing
    End If
    App.LogEvent "Study Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub SetState(ByVal Buffer As String)
    Dim udtData As StudyData
  
    udtData.Buffer = Buffer
    LSet udtProps = udtData
End Sub

Public Function GetState() As String
    Dim udtData As StudyData
    
    LSet udtData = udtProps
    GetState = udtData.Buffer
End Function

Public Sub ExecuteDDL(aDDLColl As Variant)
    ExecuteDDLprivate aDDLColl
    
    Exit Sub
    
errhandler:
    App.LogEvent "ExecuteDDL - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Sub ExecuteIndexes(anIndexColl As Variant)
    Dim sSQL As String
    Dim lngIndex As Long
    
    On Error Resume Next
    
    For lngIndex = 1 To UBound(anIndexColl)
        sSQL = anIndexColl(lngIndex)
        cn.Execute sSQL
    Next
End Sub

Private Function getUser(aStudyID As Long) As String
    getUser = "S" & CStr(aStudyID)
End Function

Public Sub SavePredefinedTables(StudyID As Long, population_id As Long, encounter_id As Long, provider_id As Long)
    'this Sub executes when creating a new study
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    
    On Error GoTo errhandler
    
    sSQL = "SELECT * from Study WHERE Study_id=" & StudyID
    
    rs.Open sSQL, cn, adOpenKeyset, adLockPessimistic
      
    rs("intPopulationTableID") = population_id
    rs("intEncounterTableID") = encounter_id
    rs("intProviderTableID") = provider_id
    rs.Update
    
    rs.Close
    Set rs = Nothing
    
    Exit Sub
    
errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "SavePredefinedTables  - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Function FetchPopulationID(ByVal StudyID As Long) As Long
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    
    On Error GoTo errhandler
    
    sSQL = "select intPopulationTableID from study where study_id = " & StudyID
    
    Set rs = cn.Execute(sSQL)
    
    With rs
        If .BOF And .EOF Then
            FetchPopulationID = -1
        Else
            FetchPopulationID = rs("intPopulationTableID")
        End If
        .Close
    End With
    
    Set rs = Nothing
        
    Exit Function

errhandler:
    If Not rs Is Nothing Then
        'rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "Population ID Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Function

Private Function FetchStudyChunkData(StudyID As Long, chunkFieldName As String) As String
    Dim strChunk As String
    Dim offset As Long
    Dim totalSize As Long
    
    Dim sSQL As String
    Dim rs As New ADODB.Recordset
    
    On Error GoTo errhandler
    
    sSQL = "SELECT " & chunkFieldName & " FROM Study WHERE Study_id=" & StudyID
    
    Set rs = cn.Execute(sSQL)
    
    'sSQL = rs(chunkFieldName)
    'sSQL = rs("strObjectives_txt")
    'sSQL = rs("strObjectiveDeliverables")
    totalSize = rs(chunkFieldName).ActualSize
    Do While offset < totalSize
        strChunk = rs(chunkFieldName).GetChunk(CHUNKSIZE)
        offset = offset + CHUNKSIZE
        FetchStudyChunkData = FetchStudyChunkData + strChunk
    Loop
    
    rs.Close
    Set rs = Nothing

    Exit Function

errhandler:
    If Not rs Is Nothing Then
        rs.Close
        Set rs = Nothing
    End If
    App.LogEvent "Study Chunk data Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Function

Private Sub SaveStudyChunkData(rs As ADODB.Recordset, chunkFieldName As String, chunkFieldData As String)
    Dim strChunk As String
    Dim Chunks As Long
    Dim Fragments As Long
    Dim offset As Long
    Dim I As Long
        
    On Error GoTo errhandler
    
    'The DB does not take empty strings for TEXT datatypes
    '  so put a space instead.
    
    If chunkFieldData = "" Then _
        chunkFieldData = " "
        
    Chunks = Len(chunkFieldData) \ CHUNKSIZE
    Fragments = Len(chunkFieldData) Mod CHUNKSIZE
    
    If Chunks > 0 Then
        strChunk = Left(chunkFieldData, CHUNKSIZE)
        rs(chunkFieldName).AppendChunk Null
        rs(chunkFieldName).AppendChunk strChunk
    End If
    
    If Chunks > 1 Then
        For I = 1 To Chunks - 1
            offset = CHUNKSIZE * I
            strChunk = Mid(chunkFieldData, offset + 1, CHUNKSIZE)
            rs(chunkFieldName).AppendChunk strChunk
        Next I
    End If
    
    If Fragments > 0 Then
        strChunk = Right(chunkFieldData, Fragments)
        rs(chunkFieldName).AppendChunk strChunk
    End If
    
    Exit Sub

errhandler:
    App.LogEvent "Study Chunk data Fetch - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub

Public Property Get ObjectiveDeliverables() As String
    ObjectiveDeliverables = strObjectiveDeliverables
End Property

Public Property Get ReportLevels() As String
    ReportLevels = strReportLevels
End Property

Public Property Get ObjectivesText() As String
    ObjectivesText = strObjectivesText
End Property

Public Property Let ObjectiveDeliverables(Value As String)
    strObjectiveDeliverables = Value
End Property

Public Property Let ReportLevels(Value As String)
    strReportLevels = Value
End Property

Public Property Let ObjectivesText(Value As String)
    strObjectivesText = Value
End Property

Public Sub CreateStandardStudyTables(StudyID As Long)
    '------------------------------------------------------------------------------------------------------------------------
    '- Greg Bogard Quick Strike Initiative.
    '- 04261999
    '- Modify the data type of the Key Fields so they mirror all foreign keys
    '- and primary keys for like fields in related tables
    '- All _id fields should be created as SQL integers not numeric
    '-
    '------------------------------------------------------------------------------------------------------------------------
    Dim aDDLColl As Collection
    Dim sSQL As String
    Dim indexVariant As Long
    Dim varArray As Variant
    
    Set aDDLColl = New Collection
    
    sSQL = "create table " & getUser(StudyID) & ".Universe" & vbCrLf
    sSQL = sSQL & "(" & vbCrLf
    sSQL = sSQL & "Pop_id         integer               not null," & vbCrLf
    sSQL = sSQL & "DQRule_id      integer               not null," & vbCrLf
    sSQL = sSQL & "numRandom      numeric               null    ," & vbCrLf
    sSQL = sSQL & "constraint PK_UNIVERSE primary key (Pop_id)" & vbCrLf
    sSQL = sSQL & ")" & vbCrLf
    aDDLColl.Add Item:=sSQL

    sSQL = "create table " & getUser(StudyID) & ".PopFlags" & vbCrLf
    sSQL = sSQL & "(" & vbCrLf
    sSQL = sSQL & "Pop_id         integer               not null," & vbCrLf
    sSQL = sSQL & "Adult          char(1)               not null," & vbCrLf
    sSQL = sSQL & "Sex            char(1)               not null," & vbCrLf
    sSQL = sSQL & "Doc            char(1)               not null," & vbCrLf
    sSQL = sSQL & "constraint PK_POPFLAGS primary key (Pop_id)" & vbCrLf
    sSQL = sSQL & ")" & vbCrLf
    aDDLColl.Add Item:=sSQL
    
    sSQL = "create table " & getUser(StudyID) & ".UnitMembership" & vbCrLf
    sSQL = sSQL & "(" & vbCrLf
    sSQL = sSQL & "Pop_id         integer               not null," & vbCrLf
    sSQL = sSQL & "SampleUnit_id  integer               not null," & vbCrLf
    sSQL = sSQL & "SelectType_cd  character(1)          null    ," & vbCrLf
    sSQL = sSQL & "constraint PK_UNITMEMBERSHIP primary key (Pop_id, SampleUnit_id)" & vbCrLf
    sSQL = sSQL & ")" & vbCrLf
    aDDLColl.Add Item:=sSQL
    
    sSQL = "create table " & getUser(StudyID) & ".UniKeys" & vbCrLf
    sSQL = sSQL & "(" & vbCrLf
    sSQL = sSQL & "SampleSet_id   integer               not null," & vbCrLf
    sSQL = sSQL & "SampleUnit_id  integer               not null," & vbCrLf
    sSQL = sSQL & "Pop_id         integer               not null," & vbCrLf
    sSQL = sSQL & "Table_id       integer               not null," & vbCrLf
    
    '*SQL 7.0*
    'I DV 8/31/1999 - Should be creating these tables with INT not Numeric
    'D    sSQL = sSQL & "KeyValue       numeric               not null," & vbCrLf
    sSQL = sSQL & "KeyValue       integer               not null," & vbCrLf
    sSQL = sSQL & "constraint PK_UNIKEYS primary key (SampleSet_id, SampleUnit_id, Pop_id, Table_id)" & vbCrLf
    sSQL = sSQL & ")" & vbCrLf
    aDDLColl.Add Item:=sSQL
    
    'D DV 8/25/1999 - SETUSER and GRANT is not needed.
    'D    sSQL = "SETUSER" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    'D
    'D    sSQL = "SETUSER '" & getUser(StudyID) & "'" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    'D
    'D    sSQL = "GRANT ALL ON " & getUser(StudyID) & ".Universe  TO dbo" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    'D
    'D    sSQL = "SETUSER" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    'D
    'D    sSQL = "SETUSER '" & getUser(StudyID) & "'" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    'D
    'D    sSQL = "GRANT ALL ON " & getUser(StudyID) & ".PopFlags TO dbo" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    'D
    'D    sSQL = "SETUSER" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    'D
    'D    sSQL = "SETUSER '" & getUser(StudyID) & "'" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    'D
    'D    sSQL = "GRANT ALL ON " & getUser(StudyID) & ".UnitMembership TO dbo" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    'D
    'D    sSQL = "SETUSER" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    'D
    'D    sSQL = "SETUSER '" & getUser(StudyID) & "'" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    'D
    'D    sSQL = "GRANT ALL ON " & getUser(StudyID) & ".UniKeys  TO dbo" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    'D
    'D    sSQL = "SETUSER" & vbCrLf
    'D    aDDLColl.Add Item:=sSQL
    
    '------------------------------------------------------------------------------------------------------------------------------------
    '- Quick Strike Initiative
    '- 05121999 Greg Bogard CGA ITSA
    '- create these indexes to be used in sampling
    '------------------------------------------------------------------------------------------------------------------------------------
    
    sSQL = "CREATE INDEX IDX_Unikeys_SampleSet_Table ON " & getUser(StudyID) & "." & "UNIKEYS(SAMPLESET_ID, TABLE_ID)" & vbCrLf
    aDDLColl.Add Item:=sSQL
    
    sSQL = "CREATE INDEX IDX_Unikeys_KeyValue ON " & getUser(StudyID) & "." & "UNIKEYS(KEYVALUE)" & vbCrLf
    aDDLColl.Add Item:=sSQL
    
    '------------------------------------------------------------------------------------------------------------------------------------
    '- Find out if DAN ARCHULETA still needs this last index
    '- Greg Does not think so.
    '-
    '------------------------------------------------------------------------------------------------------------------------------------
    '''''''''''''    sSQL = "CREATE INDEX idx_population_matchfield ON " & getUser(StudyID) & "." & "all study tables?????(all match fields)" & vbCrLf
    '''''''''''''    aDDLColl.Add Item:=sSQL
    '''''''''''''
    '------------------------------------------------------------------------------------------------------------------------------------
    '- Quick Strike Initiative
    '- End Modifications
    '- 05121999 Greg Bogard CGA ITSA
    '------------------------------------------------------------------------------------------------------------------------------------
    
    ReDim varArray(1 To aDDLColl.Count)
    For indexVariant = 1 To aDDLColl.Count
        varArray(indexVariant) = aDDLColl.Item(indexVariant)
    Next
        
    ExecuteDDLprivate varArray
    
    Set aDDLColl = Nothing
End Sub

Private Sub ExecuteDDLprivate(aDDLColl As Variant)
    Dim sSQL As String
    Dim cmd As ADODB.Command
    Dim lngIndex As Long
  
    On Error GoTo errhandler
  
    '-----------------------------------------------------------------------------------------------------------------
    '- create the index here?
    '-----------------------------------------------------------------------------------------------------------------
    Set cmd = New ADODB.Command
    Set cmd.ActiveConnection = cn
    
    For lngIndex = 1 To UBound(aDDLColl)
        sSQL = aDDLColl(lngIndex)
        'cn.Execute sSQL
        cmd.CommandText = sSQL
        Debug.Print sSQL
        cmd.CommandType = adCmdText
        cmd.Execute
    Next
    Set cmd = Nothing
    
    Exit Sub

errhandler:
    App.LogEvent "ExecuteDDLPrivate - " & Err.Description & _
                 "(" & Err.Number & ")", vbLogEventTypeError
    Err.Raise vbObjectError
End Sub


