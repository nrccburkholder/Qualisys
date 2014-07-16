VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Study"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Event Valid(IsValid As Boolean)

Private udtProps As StudyProps
Private udtSave As StudyProps

'the following 3 elements are of type TEXT in the database
Private strReportLevels As String
Private strObjectiveDeliverables As String
Private strObjectivesText As String

Private objMetaTableColl As MetaTableColl
Private objStudyComparisonColl As StudyComparisonColl
Private objStudyDeliveryColl As StudyDeliveryColl
Private objStudyReportColl As StudyReportColl
Private objStudyEmployeeColl As StudyEmployeeColl

Private objClientList As TextList
Private objEmployeeList As TextList
Private objEmployeeExtList As TextList 'DPA - 9/27/99
Private objEmployeeEmailList As TextList 'DPA - 9/27/99
Private objComparisonTypeList As TextList
Private objMSAList As TextList
Private objMGPTList As TextList
Private objStateList As TextList
Private objReportTypeList As TextList
Private objContactList As TextList

Private objMetaFieldItems As MetaFieldListColl
Private objRelationColl As RelationColl
Private objRelationTableColl As RelationTableColl

'Flags
Private flgLoadedMetaFieldItems As Boolean
Private flgLoadedMetaTables As Boolean
Private flgLoadedClients As Boolean
Private flgLoadedEmployees As Boolean
Private flgLoadedEmployeesExt As Boolean
Private flgLoadedEmployeesEmail As Boolean
Private flgLoadedComparisonType As Boolean
Private flgLoadedMSA As Boolean
Private flgLoadedMGPT As Boolean
Private flgLoadedState As Boolean
Private flgLoadedReportType As Boolean
Private flgLoadedContacts As Boolean
Private flgRollback As Boolean

Private flgNew As Boolean
Private flgDeleted As Boolean
Private flgDirty As Boolean
Private flgEditing As Boolean
Private WithEvents objValid As BrokenRules
Attribute objValid.VB_VarHelpID = -1

'----------------------------------------------------------------------------------------------------
'- Quick Strike
'- 05051999 Greg Bogard CGA ITSA Consultant
'- adding code to create indexes
'- Creating new methodology of connecting to database for these
'- Functions.
'- Do not alter existing functionality of module.
'----------------------------------------------------------------------------------------------------
Public Sub BeginEdit()
    If flgEditing Then Err.Raise 445
    
    ' save object state
    LSet udtSave = udtProps
    objStudyComparisonColl.ChildBeginEdit
    objStudyDeliveryColl.ChildBeginEdit
    objStudyReportColl.ChildBeginEdit
    objStudyEmployeeColl.ChildBeginEdit
    flgEditing = True
End Sub

Public Sub CancelEdit()
    If Not flgEditing Then Err.Raise 445
    
    flgEditing = False
    flgDeleted = False
    ' restore object state
    LSet udtProps = udtSave
    objStudyComparisonColl.ChildCancelEdit
    objStudyDeliveryColl.ChildCancelEdit
    objStudyReportColl.ChildCancelEdit
    objStudyEmployeeColl.ChildCancelEdit
End Sub

Public Sub ApplyEdit()
    Dim objDB As StudyDB  'StudyDataMTS
    Dim objAdminDB As AdminDB
    
    If Not flgEditing Then Err.Raise 445
    
    Set objDB = New StudyDB
    If flgDeleted Then
        ' code to delete the object's data goes here
        objDB.DeleteObject udtProps.ID
        flgNew = True
        flgDeleted = False
    Else 'If flgDirty Or flgNew Then
        If Not IsValid Then Err.Raise 445
        ' save object to database if appropriate
        With objDB
            .SetState GetState
            .ObjectiveDeliverables = ObjectiveDeliverables
            .ObjectivesText = ObjectivesText
            .ReportLevels = ReportLevels
            .Save
        End With
        If flgNew Then
            SetState objDB.GetState
            Set objDB = Nothing
            
            Set objAdminDB = New AdminDB
            objAdminDB.CreateStudyAsUser ID
            Set objAdminDB = Nothing
            Set objDB = New StudyDB
            objDB.CreateStandardStudyTables ID
            Set objDB = Nothing
        Else
            objDB.GetState 'to call setComplete
            Set objDB = Nothing
        End If
        
        ' save object state
        LSet udtSave = udtProps
        flgNew = False
    End If
    
     objStudyComparisonColl.ChildApplyEdit udtProps.ID
     objStudyDeliveryColl.ChildApplyEdit udtProps.ID
     objStudyReportColl.ChildApplyEdit udtProps.ID
     objStudyEmployeeColl.ChildApplyEdit udtProps.ID
    
    ' If Not flgDeleted Then _
    '   SetState objDB.GetState
     
     flgDirty = False
     flgEditing = False
End Sub

Public Sub Load(StudyID As Long)
    Dim objDB As StudyDB
    
    If flgEditing Then Err.Raise 445
    If Not flgNew Then Err.Raise 445
    
    ' code to load the object goes here
    Set objDB = New StudyDB
    With objDB
        .Fetch StudyID
        strObjectiveDeliverables = .ObjectiveDeliverables
        strObjectivesText = .ObjectivesText
        strReportLevels = .ReportLevels
        SetState .GetState
    End With
    
    Set objDB = Nothing
      
    flgNew = False
End Sub

Public Sub Delete()
    If Not flgEditing Then Err.Raise 445
    
    flgDeleted = True
    objMetaTableColl.Delete
    objStudyComparisonColl.Delete
    objStudyDeliveryColl.Delete
    objStudyReportColl.Delete
    objStudyEmployeeColl.Delete
End Sub

Public Property Get IsValid() As Boolean
    IsValid = (objValid.Count = 0)
End Property

Public Sub PostToQPDataLoad()

    Dim varArray As Variant
    Dim objDB As StudyDB
    
    ReDim varArray(1)
    varArray(1) = "EXEC LD_StudyTables " & CStr(ID) & ", 0"
    
    Set objDB = New StudyDB
    objDB.ExecuteDDL varArray
    Set objDB = Nothing

End Sub

Private Sub Class_Initialize()
    flgNew = True
    Set objValid = New BrokenRules
     
    Set objMetaTableColl = New MetaTableColl
    Set objStudyComparisonColl = New StudyComparisonColl
    Set objStudyDeliveryColl = New StudyDeliveryColl
    Set objStudyReportColl = New StudyReportColl
    Set objStudyEmployeeColl = New StudyEmployeeColl
    
    Set objMetaFieldItems = New MetaFieldListColl
    Set objClientList = New TextList
    Set objEmployeeList = New TextList
    Set objEmployeeExtList = New TextList
    Set objEmployeeEmailList = New TextList
    Set objComparisonTypeList = New TextList
    Set objMGPTList = New TextList
    Set objMSAList = New TextList
    Set objStateList = New TextList
    Set objReportTypeList = New TextList
    Set objContactList = New TextList
  
    Set objRelationColl = New RelationColl
    Set objRelationTableColl = New RelationTableColl
    
    flgLoadedMetaFieldItems = False
    flgLoadedMetaTables = False
    flgLoadedClients = False
    flgLoadedEmployees = False
    flgLoadedComparisonType = False
    flgLoadedMSA = False
    flgLoadedState = False
    flgLoadedReportType = False
    flgLoadedContacts = False
  
    udtProps.ArchiveMonths = -1
    udtProps.NumberOfReports = -1
    udtProps.ConfidenceInterval = -1
    udtProps.ErrorMargin = -1
    udtProps.CutOffTarget = -1
    
    udtProps.BudgetAmount = -1
    udtProps.TotalSpent = -1
End Sub

Public Property Get IsNew() As Boolean
    IsNew = flgNew
End Property

Public Property Get IsDirty() As Boolean
    IsDirty = flgDirty
End Property

Public Property Get IsDeleted() As Boolean
    IsDeleted = flgDeleted
End Property

Private Sub objValid_BrokenRule()
    RaiseEvent Valid(False)
End Sub

Private Sub objValid_NoBrokenRules()
    RaiseEvent Valid(True)
End Sub

Private Sub SetState(Buffer As String)
    Dim udtData As StudyData
    
    udtData.Buffer = Buffer
    LSet udtProps = udtData
    flgNew = False
End Sub

Private Function GetState() As String
    Dim udtData As StudyData
    
    With udtProps
        .IsDeleted = flgDeleted
        .IsNew = flgNew
        .IsDirty = flgDirty
    End With
    LSet udtData = udtProps
    GetState = udtData.Buffer
End Function

'***************
'
'   Accessor functions
'
'
'***************
Public Property Get ID() As Long
    ID = udtProps.ID
End Property

Public Property Get name() As String
    name = Trim$(udtProps.name)
End Property

Public Property Let name(Value As String)
    If Not flgEditing Then Err.Raise 383
    
    If Len(Value) > Len(udtProps.name) Then
        Value = Left(Value, 10)
        'Err.Raise vbObjectError + 1001, "String Value too long"
    End If
        
    udtProps.name = Value
    flgDirty = True
End Property

Public Property Get Description() As String
    Description = Trim$(udtProps.Description)
End Property

Public Property Let Description(Value As String)
    If Not flgEditing Then Err.Raise 383
    
    If Len(Value) > Len(udtProps.Description) Then
        Err.Raise vbObjectError + 1001, "String Value too long"
    End If
        
    udtProps.Description = Value
    flgDirty = True
End Property
    
Public Property Let CreationDate(Value As Variant)
    If Not flgEditing Then Err.Raise 383
    
    If IsDate(Value) Then
        udtProps.CreationDate = CVDate(Value)
    Else
        udtProps.CreationDate = Format$(Now, "d/m/yy")
    End If
    
    flgDirty = True
End Property

Public Property Get CreationDate() As Variant
    If udtProps.CreationDate = 0 Then _
        udtProps.CreationDate = Format$(Now, "m/d/yy")
      
    CreationDate = udtProps.CreationDate
End Property

Public Property Let CloseDate(Value As Variant)
    If Not flgEditing Then Err.Raise 383
    
    If IsDate(Value) Then
        udtProps.CloseDate = CVDate(Value)
    Else
        udtProps.CloseDate = 0
    End If
    
    flgDirty = True
End Property

Public Property Get CloseDate() As Variant
    If udtProps.CloseDate = 0 Then _
        udtProps.CloseDate = Format$(Now, "m/d/yy")
      
    CloseDate = udtProps.CloseDate
End Property
    
Public Property Let ContractStartDate(Value As Variant)
    If Not flgEditing Then Err.Raise 383
    
    If IsDate(Value) Then
        udtProps.ContractStartDate = CVDate(Value)
    Else
        udtProps.ContractStartDate = 0
    End If
    
    flgDirty = True
End Property

Public Property Get ContractStartDate() As Variant
    If udtProps.ContractStartDate = 0 Then _
        udtProps.ContractStartDate = Format$(Now, "m/d/yy")
    
    ContractStartDate = udtProps.ContractStartDate
End Property
    
Public Property Let ContractEndDate(Value As Variant)
    If Not flgEditing Then Err.Raise 383
    
    If IsDate(Value) Then
        udtProps.ContractEndDate = CVDate(Value)
    Else
        udtProps.ContractEndDate = 0
    End If
    
    flgDirty = True
End Property

Public Property Get ContractEndDate() As Variant
    If udtProps.ContractEndDate = 0 Then _
        udtProps.ContractEndDate = Format$(Now, "m/d/yy")
      
    ContractEndDate = udtProps.ContractEndDate
End Property
    
Public Property Let Client(Value As String)
    If Not flgEditing Then Err.Raise 383
    
    udtProps.ClientID = val(objClientList.Key(Value))
    flgDirty = True
End Property

Public Property Get Client() As String
    Client = objClientList.Item(Format$(udtProps.ClientID))
End Property

' 03-12-2006 SH Added
Public Property Let ClientID(Value As Integer)
    If Not flgEditing Then Err.Raise 383
    
    udtProps.ClientID = Value
    flgDirty = True
End Property

Public Property Get ClientID() As Integer
    ClientID = udtProps.ClientID
End Property
' End of addition

Public Property Get AccountingCode() As String
    AccountingCode = Trim$(udtProps.AccountingCode)
End Property

Public Property Let AccountingCode(Value As String)
    If Not flgEditing Then Err.Raise 383
    
    If Len(Value) > Len(udtProps.AccountingCode) Then
        Err.Raise vbObjectError + 1001, "String Value too long"
    End If
        
    udtProps.AccountingCode = Value
    flgDirty = True
End Property

Public Property Get BBSUserName() As String
    BBSUserName = Trim$(udtProps.BBSUserName)
End Property

Public Property Let BBSUserName(Value As String)
    If Not flgEditing Then Err.Raise 383
    
    If Len(Value) > Len(udtProps.BBSUserName) Then
        Err.Raise vbObjectError + 1001, "String Value too long"
    End If
        
    udtProps.BBSUserName = Value
    flgDirty = True
End Property

Public Property Get BBSPassword() As String
    BBSPassword = Trim$(udtProps.BBSPassword)
End Property

Public Property Let BBSPassword(Value As String)
    If Not flgEditing Then Err.Raise 383
    
    If Len(Value) > Len(udtProps.BBSPassword) Then
        Err.Raise vbObjectError + 1001, "String Value too long"
    End If
    
    udtProps.BBSPassword = Value
    flgDirty = True
End Property

Public Property Get ArchiveMonths() As Long
    ArchiveMonths = udtProps.ArchiveMonths
End Property

Public Property Let ArchiveMonths(Value As Long)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.ArchiveMonths = Value
    flgDirty = True
End Property

Public Property Get IsStudyOnGoing() As Boolean
    IsStudyOnGoing = udtProps.IsStudyOnGoing
End Property

Public Property Let IsStudyOnGoing(Value As Boolean)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.IsStudyOnGoing = Value
    flgDirty = True
End Property

Public Property Get NumberOfReports() As Long
    NumberOfReports = udtProps.NumberOfReports
End Property

Public Property Let NumberOfReports(Value As Long)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.NumberOfReports = Value
    flgDirty = True
End Property

Public Property Get ConfidenceInterval() As Long
    
    ConfidenceInterval = udtProps.ConfidenceInterval

End Property

Public Property Let ConfidenceInterval(Value As Long)
    
    If Not flgEditing Then Err.Raise 383
        
    udtProps.ConfidenceInterval = Value
    flgDirty = True

End Property

Public Property Get CountryID() As Long
  
    CountryID = udtProps.CountryID
    
End Property

Public Property Let CountryID(Value As Long)
   
    udtProps.CountryID = Value

End Property

Public Property Get ErrorMargin() As Long
    
    ErrorMargin = udtProps.ErrorMargin

End Property

Public Property Let ErrorMargin(Value As Long)
    
    If Not flgEditing Then Err.Raise 383
        
    udtProps.ErrorMargin = Value
    flgDirty = True

End Property

Public Property Get CutOffTarget() As Long
    
    CutOffTarget = udtProps.CutOffTarget

End Property

Public Property Let CutOffTarget(Value As Long)
    
    If Not flgEditing Then Err.Raise 383
        
    udtProps.CutOffTarget = Value
    flgDirty = True

End Property

Public Property Let ObjectiveSignOffDate(Value As Variant)
  
    If Not flgEditing Then Err.Raise 383
    
    If IsDate(Value) Then
        udtProps.ObjectiveSignOffDate = CVDate(Value)
    Else
        udtProps.ObjectiveSignOffDate = 0
    End If
    
    flgDirty = True

End Property

Public Property Get ObjectiveSignOffDate() As Variant
  
    If udtProps.ObjectiveSignOffDate = 0 Then
        ObjectiveSignOffDate = ""
    Else
        ObjectiveSignOffDate = udtProps.ObjectiveSignOffDate
    End If

End Property

Public Property Get BudgetAmount() As Currency
    
    BudgetAmount = udtProps.BudgetAmount

End Property

Public Property Let BudgetAmount(Value As Currency)
    
    If Not flgEditing Then Err.Raise 383
        
    udtProps.BudgetAmount = Value
    flgDirty = True

End Property

Public Property Get TotalSpent() As Currency
    
    TotalSpent = udtProps.TotalSpent

End Property

Public Property Let TotalSpent(Value As Currency)
    
    If Not flgEditing Then Err.Raise 383
        
    udtProps.TotalSpent = Value
    flgDirty = True

End Property

Public Property Get ActionPlanBelowQuata() As String
    
    ActionPlanBelowQuata = Trim$(udtProps.ActionPlanBelowQuata)

End Property

Public Property Let ActionPlanBelowQuata(Value As String)
    
    If Not flgEditing Then Err.Raise 383
    
    If Len(Value) > Len(udtProps.ActionPlanBelowQuata) Then
        Err.Raise vbObjectError + 1001, "String Value too long"
    End If
        
    udtProps.ActionPlanBelowQuata = Value
    flgDirty = True

End Property

Public Property Get AccountDirector() As String
    
    If udtProps.AccountDirectorEmployeeID > 0 Then
        AccountDirector = objEmployeeList.Item(Format$(udtProps.AccountDirectorEmployeeID))
    Else
        AccountDirector = ""
    End If

End Property

Public Property Let AccountDirector(Value As String)
    
    If Not flgEditing Then Err.Raise 383
    udtProps.AccountDirectorEmployeeID = val(objEmployeeList.Key(Value))
    flgDirty = True

End Property

Public Property Get ObjectiveDeliverables() As String
    
    ObjectiveDeliverables = strObjectiveDeliverables

End Property

Public Property Let ObjectiveDeliverables(Value As String)
    
    If Not flgEditing Then Err.Raise 383
    
    strObjectiveDeliverables = Value
    flgDirty = True

End Property

Public Property Get ObjectivesText() As String
    
    ObjectivesText = strObjectivesText

End Property

Public Property Let ObjectivesText(Value As String)
    
    If Not flgEditing Then Err.Raise 383
    
    strObjectivesText = Value
    flgDirty = True

End Property

Public Property Get ReportLevels() As String
    
    ReportLevels = strReportLevels

End Property

Public Property Let ReportLevels(Value As String)
    
    If Not flgEditing Then Err.Raise 383
    
    strReportLevels = Value
    flgDirty = True

End Property

Public Property Get UseAddressCleaning() As Boolean
    
    UseAddressCleaning = udtProps.UseAddressCleaning

End Property

Public Property Let UseAddressCleaning(Value As Boolean)
    
    If Not flgEditing Then Err.Raise 383
        
    udtProps.UseAddressCleaning = Value
    flgDirty = True

End Property

Public Property Get UseProperCase() As Boolean
    
    UseProperCase = udtProps.UseProperCase

End Property

Public Property Let UseProperCase(Value As Boolean)
    
    If Not flgEditing Then Err.Raise 383
        
    udtProps.UseProperCase = Value
    flgDirty = True

End Property

'Public Property Get UseNCOA() As Boolean
'
'    UseNCOA = udtProps.UseNCOA
'
'End Property
'
'Public Property Let UseNCOA(value As Boolean)
'
'    If Not flgEditing Then Err.Raise 383
'
'    udtProps.UseNCOA = value
'    flgDirty = True
'
'End Property

Public Property Get UsePhoneChecking() As Boolean
    ' 09-09-1999 Daniel Vansteenburg
    ' This allows us to know if the study will use phone number checking
    ' or not.
    UsePhoneChecking = udtProps.UsePhoneChecking
End Property

Public Property Let UsePhoneChecking(Value As Boolean)
    ' 09-09-1999 Daniel Vansteenburg
    ' This allows us to set the fact that the study will use phone
    ' number checking.  If we are not editing, then raise an error.
    ' Also, tell the object that something has changed.
    If Not flgEditing Then Err.Raise 383
    
    udtProps.UsePhoneChecking = Value
    flgDirty = True
End Property

Public Property Get StudyComparisonColl() As StudyComparisonColl
    If flgEditing = False Then objStudyComparisonColl.Load ID
    Set StudyComparisonColl = objStudyComparisonColl
End Property

Public Property Get StudyDeliveryColl() As StudyDeliveryColl
    If flgEditing = False Then objStudyDeliveryColl.Load ID
    Set StudyDeliveryColl = objStudyDeliveryColl
End Property

Public Property Get StudyReportColl() As StudyReportColl
    If flgEditing = False Then objStudyReportColl.Load ID
    Set StudyReportColl = objStudyReportColl
End Property

Public Property Get StudyEmployeeColl() As StudyEmployeeColl
    If flgEditing = False Then objStudyEmployeeColl.Load ID
    Set StudyEmployeeColl = objStudyEmployeeColl
End Property

Public Property Get MetaTableColl() As MetaTableColl
    '  If flgEditing = False Then objMetaTableColl.Load ID
    If Not flgLoadedMetaTables Then
        objMetaTableColl.Load ID
        flgLoadedMetaTables = True
    End If
    Set MetaTableColl = objMetaTableColl
End Property

Public Sub MetaTableBeginEdit()
    objMetaTableColl.ChildBeginEdit
End Sub

Public Sub MetaTableCancelEdit()
    objMetaTableColl.ChildCancelEdit
End Sub

Public Sub MetaTableApplyEdit()
    objMetaTableColl.ChildApplyEdit udtProps.ID
    
    ' force reloading of the metaitems because adding
    ' a new table adds a key field that needs to be
    ' displayed in this list also.
    
    flgLoadedMetaFieldItems = False
End Sub

Public Property Get ClientList() As TextList
    If Not flgLoadedClients Then
        objClientList.Load "ClientList"
        flgLoadedClients = True
    End If
    Set ClientList = objClientList
End Property

Public Property Get EmployeeList() As TextList
    If Not flgLoadedEmployees Then
        objEmployeeList.Load "EmployeeList"
        flgLoadedEmployees = True
    End If
    Set EmployeeList = objEmployeeList
End Property

Public Property Get EmployeeExtList() As TextList
    
    If Not flgLoadedEmployeesExt Then
        objEmployeeExtList.Load "EmployeeExtList"
        flgLoadedEmployeesExt = True
    End If
    
    Set EmployeeExtList = objEmployeeExtList

End Property

Public Property Get EmployeeEmailList() As TextList
    
    If Not flgLoadedEmployeesEmail Then
        objEmployeeEmailList.Load "EmployeeEmailList"
        flgLoadedEmployeesEmail = True
    End If
    Set EmployeeEmailList = objEmployeeEmailList

End Property

Public Property Get ComparisonTypeList() As TextList
    
    If Not flgLoadedComparisonType Then
        objComparisonTypeList.Load "ComparisonTypeList"
        flgLoadedComparisonType = True
    End If
    Set ComparisonTypeList = objComparisonTypeList

End Property

Public Property Get MGPTList() As TextList
    
    If Not flgLoadedMGPT Then
        objMGPTList.Load "MGPT"
        flgLoadedMGPT = True
    End If
    
    Set MGPTList = objMGPTList

End Property

Public Property Get MSAList() As TextList
    
    If Not flgLoadedMSA Then
        objMSAList.Load "MSAList"
        flgLoadedMSA = True
    End If
    Set MSAList = objMSAList

End Property

Public Property Get StateList() As TextList
    
    If Not flgLoadedState Then
        objStateList.Load "StateList"
        flgLoadedState = True
    End If
    Set StateList = objStateList

End Property

Public Property Get ReportTypeList() As TextList
    
    If Not flgLoadedReportType Then
        objReportTypeList.Load "ReportTypeList"
        flgLoadedReportType = True
    End If
    Set ReportTypeList = objReportTypeList
    
End Property

Public Function MetaFieldItems() As MetaFieldListColl
    If Not flgLoadedMetaFieldItems Then
        Set objMetaFieldItems = Nothing
        Set objMetaFieldItems = New MetaFieldListColl
        objMetaFieldItems.Load ID
        flgLoadedMetaFieldItems = True
    End If
    Set MetaFieldItems = objMetaFieldItems
End Function
    
Public Function IsTableReferenced(aMetaTableId As Long) As Boolean
    Dim aTable As MetaTable
    Dim aFld As MetaField
    Dim found As Boolean
    
    found = False
    
    If aMetaTableId < 1 Then
        IsTableReferenced = False
        Exit Function
    End If
    
    For Each aTable In MetaTableColl
        For Each aFld In aTable.MetaFieldColl
            If (aFld.lookupTableID = aMetaTableId) Then
                found = True
                Exit For
            End If
        Next
        If found = True Then
            Exit For
        End If
    Next
    
    IsTableReferenced = found
End Function

Public Function IsFieldReferenced(aMetaTableId As Long, aMetaFieldId As Long) As Boolean
    Dim aTable As MetaTable
    Dim aFld As MetaField
    Dim found As Boolean
    
    found = False
    
    For Each aTable In MetaTableColl
        For Each aFld In aTable.MetaFieldColl
            If (aFld.lookupTableID = aMetaTableId) _
                And (aFld.lookupFieldID = aMetaFieldId) Then
                    found = True
                    Exit For
            End If
        Next
        
        If found = True Then
            Exit For
        End If
    Next
    
    IsFieldReferenced = found

End Function

Public Function FieldReferenceInfo(aMetaTableId As Long, aMetaFieldId As Long) As String
    
    Dim aTable As MetaTable
    Dim aFld As MetaField
    Dim strRef As String
    Dim aFldList As MetaFieldList
    
    strRef = ""
    For Each aTable In MetaTableColl
        For Each aFld In aTable.MetaFieldColl
            If (aFld.lookupTableID = aMetaTableId) _
              And (aFld.lookupFieldID = aMetaFieldId) Then
                Set aFldList = MetaFieldItems.ListItem(aMetaFieldId)
                strRef = strRef + Trim(aTable.name) + "." + Trim(aFldList.name) + vbCrLf
            End If
        Next
    Next
    
    FieldReferenceInfo = strRef

End Function

Public Function Post() As String
    
    Dim aStr As String
    
    aStr = PostDDL
    aStr = aStr & vbCrLf & PostIndexes
    aStr = aStr & vbCrLf & PostBigView
    aStr = aStr & vbCrLf & PostBigViewLoad
    
    PostTables
        
    Post = aStr
  
End Function

' 11-14-2002 FG Added
Function TableExists(tn As String) As Boolean
    Dim rs As New ADODB.Recordset
    rs.Open "select name from sysobjects where [id] = object_id('" & tn & "')", cn
    TableExists = Not ((rs.EOF) And (rs.BOF))
    
    rs.Close
    Set rs = Nothing
End Function

' 11-14-2002 FG Added
Function FieldExists(fn As String, tn As String) As Boolean
    Dim rs As New ADODB.Recordset
    
    rs.Open "select * from syscolumns sc where sc.name = '" & fn & "' and sc.id = object_id('" & tn & "')", cn
    FieldExists = Not ((rs.EOF) And (rs.BOF))
    
    rs.Close
    Set rs = Nothing
End Function

Public Function generateDDLScripts() As Collection
    Dim aTable As MetaTable
    Dim aFld As MetaField
    Dim aFldList As MetaFieldList
    Dim sDDL As String
    Dim sAlterString As String
    Dim sInsertString As String
    Dim sAlterLoadString As String
    Dim sInsertLoadString As String
    Dim sAlterIndexString As String
    Dim sInsertIndexString As String
'D    Dim sGrantString As String
    Dim bAltered As Boolean
    Dim colDDL As Collection
    
    Set colDDL = New Collection
    
'D    sDDL = ""
'D    sDDL = "SETUSER" & vbCrLf & "SETUSER '" & getOwner & "'" & vbCrLf '& "GO" & vbCrLf
'    colDDL.Add Item:="SETUSER"
'    sDDL = "SETUSER '" & getOwner & "'"
'    colDDL.Add Item:=sDDL
        
    bAltered = False
    
    ' 11-14-2002 FG Added
    Dim tn As String
    Dim strOwner As String
    
    strOwner = getOwner
    
    For Each aTable In MetaTableColl
        tn = strOwner & "." & Trim(aTable.name)
        sAlterString = ""
        sAlterLoadString = ""
        If aTable.IsPosted Or TableExists(tn) Then  'table exists
            'call alter table with added columns
            For Each aFld In aTable.MetaFieldColl
                Set aFldList = MetaFieldItems.ListItem(aFld.ID)
                'if a field is posted, then it exists in the database
                If (Not aFld.IsPosted) And (Not FieldExists(Trim(aFldList.name), tn)) Then
                    If bAltered = False Then
                        ' the following statement has to be added only once in this loop
                        sAlterString = "ALTER Table " & tn & vbCrLf & "ADD" & vbCrLf
                        sAlterLoadString = "ALTER Table " & tn & "_load" & vbCrLf & "ADD" & vbCrLf
                        bAltered = True
                    End If
                    sAlterString = sAlterString & Trim(aFldList.name) & " "
                    sAlterString = sAlterString & getDBDataType(Trim(aFldList.DataType)) & " "
                    sAlterLoadString = sAlterLoadString & Trim(aFldList.name) & " "
                    sAlterLoadString = sAlterLoadString & getDBDataType(Trim(aFldList.DataType)) & " "
                    If aFldList.hasDBFieldLength Then
                        sAlterString = sAlterString & "( " & aFldList.fieldLength & " ) "
                        sAlterLoadString = sAlterLoadString & "( " & aFldList.fieldLength & " ) "
                    End If
                    sAlterString = sAlterString & "NULL," & vbCrLf
                    sAlterLoadString = sAlterLoadString & "NULL," & vbCrLf
                End If
            Next
            'remove the trailing comma, CR and LF characters
            If Len(sAlterString) > 0 Then
                sAlterString = Left(sAlterString, Len(sAlterString) - 3)
                sAlterString = sAlterString & vbCrLf & vbCrLf ' & "GO"
'                sDDL = sDDL & vbCrLf & vbCrLf & sAlterString
'D                colDDL.Add Item:=sDDL
                colDDL.Add Item:=sAlterString
            
                sAlterLoadString = Left(sAlterLoadString, Len(sAlterLoadString) - 3)
                sAlterLoadString = sAlterLoadString & vbCrLf & vbCrLf ' & "GO"
'                sDDL = sDDL & vbCrLf & vbCrLf & sAlterLoadString
'D                colDDL.Add Item:=sDDL
                colDDL.Add Item:=sAlterLoadString
            End If
            bAltered = False
         Else 'table does not exist
            'call insert statement with all columns
            sInsertString = "CREATE Table " & getOwner & "." & Trim(aTable.name) & "( " & vbCrLf
            sInsertLoadString = "CREATE Table " & getOwner & "." & Trim(aTable.name) & "_load" & "( " & vbCrLf
            For Each aFld In aTable.MetaFieldColl
                Set aFldList = MetaFieldItems.ListItem(aFld.ID)
                sInsertString = sInsertString & Trim(aFldList.name) & " "
                sInsertString = sInsertString & getDBDataType(Trim(aFldList.DataType)) & " "
                
                sInsertLoadString = sInsertLoadString & Trim(aFldList.name) & " "
                sInsertLoadString = sInsertLoadString & getDBDataType(Trim(aFldList.DataType)) & " "
                If aFldList.hasDBFieldLength Then
                    sInsertString = sInsertString & "(" & aFldList.fieldLength & " )" & " "
                    sInsertLoadString = sInsertLoadString & "(" & aFldList.fieldLength & " )" & " "
                End If
                If aFld.IsKeyField Then
                    sInsertString = sInsertString & " NOT NULL " & vbCrLf
                    sInsertString = sInsertString & "CONSTRAINT PK_" & getOwner & aTable.name
                    sInsertString = sInsertString & " PRIMARY KEY NONCLUSTERED," & vbCrLf
                    
                    sInsertLoadString = sInsertLoadString & "IDENTITY (1,1) NOT NULL " & vbCrLf
                    sInsertLoadString = sInsertLoadString & "CONSTRAINT PK_" & getOwner & aTable.name & "_load"
                    sInsertLoadString = sInsertLoadString & " PRIMARY KEY NONCLUSTERED," & vbCrLf
                Else
                    sInsertString = sInsertString & "NULL," & vbCrLf
                    sInsertLoadString = sInsertLoadString & "NULL," & vbCrLf
                End If
            Next
            'remove the trailing comma, CR and LF characters
            If Len(sInsertString) > 0 Then
                sInsertString = Left(sInsertString, Len(sInsertString) - 3)
                sInsertString = sInsertString & ")"
                sInsertString = sInsertString & vbCrLf & vbCrLf ' & "GO" & vbCrLf & vbCrLf
                'grant permissions
'D                sGrantString = "GRANT ALL ON " & getOwner & "." & aTable.name & " TO dbo" & vbCrLf & vbCrLf ' & "GO"
'                sDDL = sDDL & vbCrLf & vbCrLf & sInsertString
'D                colDDL.Add Item:=sDDL
                colDDL.Add Item:=sInsertString
'D                colDDL.Add Item:=sGrantString
                
                sInsertLoadString = Left(sInsertLoadString, Len(sInsertLoadString) - 3)
                sInsertLoadString = sInsertLoadString & ")"
                sInsertLoadString = sInsertLoadString & vbCrLf & vbCrLf ' & "GO" & vbCrLf & vbCrLf
                'grant permissions
'D                sGrantString = "GRANT ALL ON " & getOwner & "." & aTable.name & "_load TO dbo" & vbCrLf & vbCrLf ' & "GO"
'                sDDL = sDDL & vbCrLf & vbCrLf & sInsertLoadString
'D                colDDL.Add Item:=sDDL
                colDDL.Add Item:=sInsertLoadString
'D                colDDL.Add Item:=sGrantString
            End If
        End If
    Next
    
    Set generateDDLScripts = colDDL
    Set colDDL = Nothing
End Function

Private Function getDBDataType(aDataType As String) As String
    Select Case aDataType
'    Case "B"
'        getDBDataType = "bit"
    Case "R"
        getDBDataType = "numeric"
    Case "I"
        getDBDataType = "Integer"
    Case "S"
        getDBDataType = "varchar"
    Case "D"
        getDBDataType = "datetime"
    Case Else
        getDBDataType = "unknown"
    End Select
End Function

Public Function DisplayProperties() As String
    Dim strDisplay As String
       
    strDisplay = "ID:" & vbTab & vbTab & vbTab & CStr(ID) & vbCrLf
    strDisplay = strDisplay & "Name:" & vbTab & vbTab & vbTab & name & vbCrLf
    strDisplay = strDisplay & "Description:" & vbTab & vbTab & Description & vbCrLf
    strDisplay = strDisplay & "Creation Date:" & vbTab & vbTab & CreationDate & vbCrLf
    strDisplay = strDisplay & "Close Date:" & vbTab & vbTab & CloseDate & vbCrLf
    strDisplay = strDisplay & "Archive Months:" & vbTab & vbTab & IIf((ArchiveMonths = -1), "", CStr(ArchiveMonths)) & vbCrLf
    strDisplay = strDisplay & "Number of Reports:" & vbTab & vbTab & IIf((NumberOfReports = -1), "", CStr(NumberOfReports)) & vbCrLf
    strDisplay = strDisplay & "Confidence Interval:" & vbTab & vbTab & IIf((ConfidenceInterval = -1), "", CStr(ConfidenceInterval)) & vbCrLf
    strDisplay = strDisplay & "Error Margin:" & vbTab & vbTab & IIf((ErrorMargin = -1), "", CStr(ErrorMargin)) & vbCrLf
    strDisplay = strDisplay & "Cutoff Target:" & vbTab & vbTab & IIf((CutOffTarget = -1), "", CStr(CutOffTarget)) & vbCrLf
    strDisplay = strDisplay & "Budgeted Amount:" & vbTab & vbTab & IIf((BudgetAmount = -1), "", CStr(BudgetAmount)) & vbCrLf
    strDisplay = strDisplay & "Total Spent:" & vbTab & vbTab & IIf((TotalSpent = -1), "", CStr(TotalSpent)) & vbCrLf
'    strDisplay = strDisplay & "Account Director:" & vbTab & vbTab & AccountDirector & vbCrLf
    
    DisplayProperties = strDisplay
End Function

Private Function UpdateIndexes() As Collection
    Dim aString As String
    Dim aloadString As String
    Dim aTable As MetaTable
    Dim aFld As MetaField
    Dim aFldList As MetaFieldList
    Dim anIndexColl As Collection
    
    Set anIndexColl = New Collection
    
    aString = ""
    aloadString = ""
    For Each aTable In MetaTableColl
        For Each aFld In aTable.MetaFieldColl
            If (aFld.lookupTableID > 0) And (aFld.lookupFieldID > 0) Then
                Set aFldList = MetaFieldItems.ListItem(aFld.ID)
                aString = "CREATE INDEX " & aTable.name & aFldList.name & "I ON " & getOwner & "." & aTable.name & "(" & aFldList.name & ")" & vbCrLf ' & "GO" & vbCrLf
                aloadString = "CREATE INDEX " & aTable.name & aFldList.name & "I ON " & "S" & ID & "." & aTable.name & "_load" & "(" & aFldList.name & ")" & vbCrLf ' & "GO" & vbCrLf
                anIndexColl.Add Item:=aString
                anIndexColl.Add Item:=aloadString
            End If
        Next
    Next

    If fctIndexOnMatchFields(ID) Then
        'Good!
    Else
        'Bad!
    End If
    
    'DO IT FOR THE _LOAD tables.
    If fctIndexOn_LoadMatchFields(ID) Then
        'Good!
    Else
        'Bad!
    End If
    
    Set UpdateIndexes = anIndexColl
    Set anIndexColl = Nothing
End Function

Private Function getOwner() As String
    
    getOwner = "S" & CStr(ID)

End Function

Public Function IsFullyPosted() As Boolean
    
    Dim aTable As MetaTable
    Dim aFld As MetaField
    
    For Each aTable In MetaTableColl
        For Each aFld In aTable.MetaFieldColl
            If Not aFld.IsPosted Then
                IsFullyPosted = False
                Exit Function
            End If
        Next
    Next
                
    IsFullyPosted = True
        
End Function

Public Function IsPosted() As Boolean
    
    Dim aTable As MetaTable
    
    IsPosted = False
    
    For Each aTable In MetaTableColl
        If aTable.IsPosted Then
            IsPosted = True
            Exit For
        End If
    Next
                        
End Function

Public Function GenerateBigViewLoad() As String
    
    Dim aTable As MetaTable
    Dim aField As MetaField
    Dim aFldList As MetaFieldList
    Dim strSELECT As String
    Dim strFROM As String
    Dim strWHERE As String
    Dim aRelation As Relation
    Dim masterTableName As String
    Dim masterFieldName As String
    Dim lookupTableName As String
    Dim lookupFieldName As String
    Dim strView As String

    getAllNodes

    For Each aTable In MetaTableColl
        If objRelationTableColl.exist(aTable.ID) Then
            If Len(strFROM) > 0 Then _
                strFROM = strFROM & ", "

            strFROM = strFROM & getOwner & "." & aTable.name & "_LOAD"
            
            For Each aField In aTable.MetaFieldColl
                Set aFldList = MetaFieldItems.ListItem(aField.ID)
                If Len(strSELECT) > 0 Then _
                    strSELECT = strSELECT & ", "

                strSELECT = strSELECT & aTable.name & aFldList.name & "=" & getOwner & "." & aTable.name & "_LOAD." & aFldList.name

            Next
        End If
    Next

    For Each aRelation In objRelationColl
        masterTableName = MetaTableColl.ListItem(aRelation.masterTableID).name
        masterFieldName = MetaFieldItems.ListItem(aRelation.masterFieldID).name
        lookupTableName = MetaTableColl.ListItem(aRelation.lookupTableID).name
        lookupFieldName = MetaFieldItems.ListItem(aRelation.lookupFieldID).name
        If Len(strWHERE) > 0 Then _
            strWHERE = strWHERE & " AND "

        strWHERE = strWHERE & getOwner & "." & masterTableName & "_LOAD." & masterFieldName
        strWHERE = strWHERE & " = " & getOwner & "." & lookupTableName & "_LOAD." & lookupFieldName
    Next
            
    strView = strView & vbCrLf & "CREATE VIEW " & getOwner & ".BIG_VIEW_LOAD AS "
    strView = strView & vbCrLf & "SELECT " & strSELECT
    strView = strView & vbCrLf & "FROM " & strFROM
    
    If Len(strWHERE) > 0 Then _
        strView = strView & vbCrLf & "WHERE " & strWHERE
    
    GenerateBigViewLoad = strView
    
End Function

Public Function GenerateBigView() As String
    
    Dim aTable As MetaTable
    Dim aField As MetaField
    Dim aFldList As MetaFieldList
    Dim strSELECT As String
    Dim strFROM As String
    Dim strWHERE As String
    Dim aRelation As Relation
    Dim masterTableName As String
    Dim masterFieldName As String
    Dim lookupTableName As String
    Dim lookupFieldName As String
    Dim strView As String

    getAllNodes

    For Each aTable In MetaTableColl
        If objRelationTableColl.exist(aTable.ID) Then
            If Len(strFROM) > 0 Then _
                strFROM = strFROM & ", "

            strFROM = strFROM & getOwner & "." & aTable.name
            
            For Each aField In aTable.MetaFieldColl
                Set aFldList = MetaFieldItems.ListItem(aField.ID)
                If Len(strSELECT) > 0 Then _
                    strSELECT = strSELECT & ", "

                strSELECT = strSELECT & aTable.name & aFldList.name & "=" & getOwner & "." & aTable.name & "." & aFldList.name

            Next
        End If
    Next

    For Each aRelation In objRelationColl
        masterTableName = MetaTableColl.ListItem(aRelation.masterTableID).name
        masterFieldName = MetaFieldItems.ListItem(aRelation.masterFieldID).name
        lookupTableName = MetaTableColl.ListItem(aRelation.lookupTableID).name
        lookupFieldName = MetaFieldItems.ListItem(aRelation.lookupFieldID).name
        If Len(strWHERE) > 0 Then _
            strWHERE = strWHERE & " AND "

        strWHERE = strWHERE & getOwner & "." & masterTableName & "." & masterFieldName
        strWHERE = strWHERE & " = " & getOwner & "." & lookupTableName & "." & lookupFieldName
    Next
            
    strView = strView & vbCrLf & "CREATE VIEW " & getOwner & ".BIG_VIEW AS "
    strView = strView & vbCrLf & "SELECT " & strSELECT
    strView = strView & vbCrLf & "FROM " & strFROM
    If Len(strWHERE) > 0 Then _
        strView = strView & vbCrLf & "WHERE " & strWHERE
    
    GenerateBigView = strView
    
'    MsgBox strView

End Function

Private Sub getAllNodes()
    
    Dim objDB As StudyDB
    Dim TableID As Long
    Dim iter As Relation
    Dim lngIndex As Long
    
    Set objDB = New StudyDB
    TableID = objDB.FetchPopulationID(ID)
    
    objRelationTableColl.Add TableID
    
    objRelationColl.Load TableID
    
    If objRelationColl.Count > 0 Then
'        For Each iter In objRelationColl
'            If iter.masterTableID = iter.currentTableID Then
'                TableID = iter.lookupTableID
'            Else
'                TableID = iter.masterTableID
'            End If
'
'            If Not objRelationTableColl.exist(TableID) Then
'                objRelationTableColl.Add TableID
'                objRelationColl.Load TableID
'            End If
'        Next
        
        lngIndex = 1
        Do
            Set iter = objRelationColl.Item(lngIndex)
            If iter.masterTableID = iter.currentTableID Then
                TableID = iter.lookupTableID
            Else
                TableID = iter.masterTableID
            End If
            
            If Not objRelationTableColl.exist(TableID) Then
                objRelationTableColl.Add TableID
                objRelationColl.Load TableID
            End If
            lngIndex = lngIndex + 1
        Loop Until lngIndex > objRelationColl.Count
    End If
    
    Exit Sub

End Sub

Private Function PostDDL() As String
    
    Dim sDDL As String
    Dim aStr As Variant
    Dim strBigView As String
    Dim colDDL As Collection
    Dim objDB As StudyDB
    Dim indexVariant As Long
    Dim varArray As Variant
    
    Set colDDL = generateDDLScripts
    If colDDL.Count > 0 Then
        'convert the collections to arrays since
        ' MTS does not handle collection parameters
        
        ReDim varArray(1 To colDDL.Count)
        For indexVariant = 1 To colDDL.Count
            varArray(indexVariant) = colDDL.Item(indexVariant)
        Next
        
        Set objDB = New StudyDB
        objDB.ExecuteDDL varArray
        Set objDB = Nothing
    End If

    For Each aStr In colDDL
        sDDL = sDDL & aStr & vbCrLf & vbCrLf
    Next
    
    PostDDL = sDDL

End Function

Public Function PostBigViewLoad() As String
    
    Dim sDDL As String
    Dim aStr As Variant
    Dim strBigView As String
    Dim colDDL As Collection
'    Dim objDB As StudyDataMTS.StudyDB
    Dim objDB As StudyDB
    Dim indexVariant As Long
    Dim varArray As Variant
    
    On Error GoTo ErrorHandler
    
    Set colDDL = New Collection
'*SQL7.0*
    strBigView = "if exists (select * from sysobjects where ID = object_id('" & getOwner & ".BIG_VIEW_LOAD') and sysstat & 0xf = 2)"
    strBigView = strBigView & " DROP VIEW " & getOwner & ".BIG_VIEW_LOAD"
    colDDL.Add Item:=strBigView
   
    strBigView = GenerateBigViewLoad
    colDDL.Add Item:=strBigView

    If colDDL.Count > 0 Then
        'convert the collections to arrays since
        ' MTS does not handle collection parameters
  
        ReDim varArray(1 To colDDL.Count)
        For indexVariant = 1 To colDDL.Count
            varArray(indexVariant) = colDDL.Item(indexVariant)
            cn.Execute colDDL.Item(indexVariant)
        Next
    End If

    For Each aStr In colDDL
        sDDL = sDDL & aStr & vbCrLf & vbCrLf
    Next

    PostBigViewLoad = sDDL
    
    Exit Function
    
ErrorHandler:
    Err.Raise Err.Number, Err.Source, Err.Description
    flgRollback = True

End Function

Public Function PostBigView() As String
    
    Dim sDDL As String
    Dim aStr As Variant
    Dim strBigView As String
    Dim colDDL As Collection
'    Dim objDB As StudyDataMTS.StudyDB
    Dim objDB As StudyDB
    Dim indexVariant As Long
    Dim varArray As Variant
    
    On Error GoTo ErrorHandler
    
    Set colDDL = New Collection
'*SQL7.0*
    strBigView = "if exists (select * from sysobjects where ID = object_id('" & getOwner & ".BIG_VIEW') and sysstat & 0xf = 2)"
    strBigView = strBigView & " DROP VIEW " & getOwner & ".BIG_VIEW"
    colDDL.Add Item:=strBigView
   
    strBigView = GenerateBigView
    colDDL.Add Item:=strBigView

    If colDDL.Count > 0 Then
        'convert the collections to arrays since
        ' MTS does not handle collection parameters
  
        ReDim varArray(1 To colDDL.Count)
        For indexVariant = 1 To colDDL.Count
            varArray(indexVariant) = colDDL.Item(indexVariant)
            cn.Execute colDDL.Item(indexVariant)
        Next
    End If

    For Each aStr In colDDL
        sDDL = sDDL & aStr & vbCrLf & vbCrLf
    Next

    PostBigView = sDDL
    
    Exit Function
    
ErrorHandler:
    Err.Raise Err.Number, Err.Source, Err.Description
    flgRollback = True

End Function

Private Function PostIndexes() As String
    
    Dim aStr As Variant
    Dim sIndexes As String
    Dim colIndex As Collection
    Dim objDB As StudyDB
    Dim indexVariant As Long
    Dim varArray As Variant
    
    Set colIndex = UpdateIndexes
    
    If colIndex.Count > 0 Then
        'convert the collections to arrays since
        ' MTS does not handle collection parameters
 
        ReDim varArray(1 To colIndex.Count)
        On Error Resume Next
        For indexVariant = 1 To colIndex.Count
            varArray(indexVariant) = colIndex.Item(indexVariant)
            cn.Execute colIndex.Item(indexVariant)
        Next
        
    End If
    
    For Each aStr In colIndex
        sIndexes = sIndexes & aStr & vbCrLf & vbCrLf
    Next
    
    PostIndexes = sIndexes

End Function

Public Sub PostTables()
    
    Dim aTable As MetaTable
    Dim aFld As MetaField

'    MetaTableBeginEdit
    For Each aTable In MetaTableColl
        For Each aFld In aTable.MetaFieldColl
            If Not aFld.IsPosted Then
                aFld.BeginEdit
                aFld.IsPosted = True
                aFld.ApplyEdit
            End If
        Next
    Next
'    MetaTableApplyEdit
    
End Sub

Public Property Get ContactList() As TextList
    
    If Not flgLoadedContacts Then
        objContactList.LoadClientContacts udtProps.ClientID
        flgLoadedContacts = True
    End If
    Set ContactList = objContactList
    
End Property

Private Sub Class_Terminate()
    
    Set objValid = Nothing
     
    Set objMetaTableColl = Nothing
    Set objStudyComparisonColl = Nothing
    Set objStudyDeliveryColl = Nothing
    Set objStudyReportColl = Nothing
    Set objStudyEmployeeColl = Nothing
    
    Set objMetaFieldItems = Nothing
    Set objClientList = Nothing
    Set objEmployeeList = Nothing
    Set objComparisonTypeList = Nothing
    Set objMGPTList = Nothing
    Set objMSAList = Nothing
    Set objStateList = Nothing
    Set objReportTypeList = Nothing
    Set objContactList = Nothing
    Set objRelationColl = Nothing
    Set objRelationTableColl = Nothing
End Sub

Private Function fctIndexOnMatchFields(plngStudy_Id As Long) As Boolean
   
    Dim strSQL As String
    Dim strStudy_Id As String
    Dim strAlternateIndexName As String
    Dim strApplyMatchTableIndexName As String
    Dim StrCommaSeparatedFieldList As String
    
    Dim rsTablesWithMatchFields As ADODB.Recordset
    Dim rsMatchFields As ADODB.Recordset
    Dim rs As ADODB.Recordset
    
    strStudy_Id = Trim(Str(plngStudy_Id))
    
    '-----------------------------------------------------------------------------------------------------------------------
    strSQL = _
    "SELECT  metaTable.Table_id," _
        & " metaTable.strTable_nm," _
        & " metaField.Field_id," _
        & " MetaField.strField_nm" _
    & " FROM MetaTable, metaStructure, MetaField" _
    & " WHERE MetaTable.study_id = " & plngStudy_Id _
        & " AND metaStructure.Table_id = metaTable.Table_id" _
        & " AND metaStructure.Field_id = metaField.Field_id" _
        & " AND metaStructure.bitMatchField_Flg = 1"

    Set rsMatchFields = New ADODB.Recordset
    rsMatchFields.CursorLocation = adUseClient
    rsMatchFields.Open strSQL, cn, adOpenKeyset, adLockBatchOptimistic
    Set rsMatchFields.ActiveConnection = Nothing

    If Not rsMatchFields.BOF And Not rsMatchFields.EOF Then
        rsMatchFields.MoveFirst
        Do While Not rsMatchFields.EOF
            '-----------------------------------------------------------------------------------------------------------------------
            '- look in sysindexes for index.
            '- OWNERFIELDTABLEALTERNATEINDEX
            '-----------------------------------------------------------------------------------------------------------------------
            strAlternateIndexName = _
                "S" _
                & strStudy_Id _
                & UCase(Trim(rsMatchFields!strField_nm)) _
                & UCase(Trim(rsMatchFields!strTable_nm))
            '-----------------------------------------------------------------------------------------------------------------------
            '- max length of index name = 30 chars
            '-----------------------------------------------------------------------------------------------------------------------
            If Len(strAlternateIndexName) > 30 Then
                strAlternateIndexName = Left(strAlternateIndexName, 30)
            End If
            'MsgBox strAlternateIndexName
            '-----------------------------------------------------------------------------------------------------------------------
            '- look in sysindexes for index.
            '- if you find it, leave it there.
            '- if you don't find it, create it.
            '-----------------------------------------------------------------------------------------------------------------------
            '*SQL7.0*
            strSQL = _
                "IF NOT EXISTS" _
                    & " (SELECT * FROM sysindexes WHERE name = " _
                    & "'" _
                    & strAlternateIndexName _
                    & "'" _
                    & ")" _
                    & "CREATE INDEX " _
                    & strAlternateIndexName _
                    & " ON S" _
                    & strStudy_Id _
                    & "." _
                    & rsMatchFields!strTable_nm _
                    & "(" _
                    & rsMatchFields!strField_nm _
                    & ")"
            cn.Execute strSQL
            rsMatchFields.MoveNext
        Loop
    Else
        Exit Function
    End If
    
    '''''
    'do it again! for the compound indexes
    '''''

    strSQL = _
    "SELECT  DISTINCT" _
        & " metaTable.Table_id," _
        & " metaTable.strTable_nm," _
        & " metaTable.study_id" _
    & " FROM MetaTable, metaStructure, MetaField" _
    & " WHERE MetaTable.study_id = " & plngStudy_Id _
        & " AND metaStructure.Table_id = metaTable.Table_id" _
        & " AND metaStructure.Field_id = metaField.Field_id" _
        & " AND metaStructure.bitMatchField_Flg = 1"

    Set rsTablesWithMatchFields = New ADODB.Recordset
    rsTablesWithMatchFields.CursorLocation = adUseClient
    rsTablesWithMatchFields.Open strSQL, cn, adOpenKeyset, adLockBatchOptimistic
    Set rsTablesWithMatchFields.ActiveConnection = Nothing
    rsMatchFields.MoveFirst
    If Not rsTablesWithMatchFields.BOF And Not rsTablesWithMatchFields.EOF Then
        rsTablesWithMatchFields.MoveFirst
        Do While Not rsTablesWithMatchFields.BOF And Not rsTablesWithMatchFields.EOF
        StrCommaSeparatedFieldList = ""
            rsMatchFields.MoveFirst
            Do While Not rsMatchFields.EOF ' And rsMatchFields!strtable_nm = rsTablesWithMatchFields!strtable_nm
                If rsMatchFields!strTable_nm = rsTablesWithMatchFields!strTable_nm Then
                    StrCommaSeparatedFieldList = _
                         StrCommaSeparatedFieldList _
                        & rsMatchFields!strField_nm _
                        & ","
                End If
                rsMatchFields.MoveNext
            Loop
            StrCommaSeparatedFieldList = Left(StrCommaSeparatedFieldList, Len(StrCommaSeparatedFieldList) - 1)
            strApplyMatchTableIndexName = _
                "S" _
                & strStudy_Id _
                & "CDX" _
                & UCase(Trim(rsTablesWithMatchFields!strTable_nm))
            If Len(strApplyMatchTableIndexName) > 30 Then
                strApplyMatchTableIndexName = Left(strApplyMatchTableIndexName, 30)
            End If
            '*SQL7.0*
            strSQL = _
                "SELECT * FROM sysindexes WHERE name = " _
                    & "'" _
                    & strApplyMatchTableIndexName _
                    & "'"
            Set rs = New ADODB.Recordset
            rs.CursorLocation = adUseClient
            rs.Open strSQL, cn, adOpenKeyset, adLockBatchOptimistic
            Set rs.ActiveConnection = Nothing
            If Not rs.BOF And Not rs.EOF Then
                strSQL = _
                     "DROP INDEX " _
                        & "S" _
                        & strStudy_Id _
                        & "." _
                        & rsTablesWithMatchFields!strTable_nm _
                        & "." _
                        & strApplyMatchTableIndexName
                cn.Execute strSQL
            End If
            strSQL = _
                "CREATE INDEX " _
                    & strApplyMatchTableIndexName _
                    & " ON S" _
                    & strStudy_Id _
                    & "." _
                    & rsTablesWithMatchFields!strTable_nm _
                    & "(" _
                    & StrCommaSeparatedFieldList _
                    & ")"
            cn.Execute strSQL
            rsTablesWithMatchFields.MoveNext
        Loop
    Else
        'do nothin
    End If

    '-----------------------------------------------------------------------------------------------------------------------
    '- THAT SHOULD DO IT
    '- KEEP THE BELOW CODE FOR FUTURE ENHANCEMENTS
    '- GOOD IDEA TO CHECK META MATCH FIELDS AGAINST SYSINDEXES
    '- AND GET RID OF INDEXES WHERE A USER TURNED OFF THE MATCH BIT
    '- THE INDEX WILL STILL BE OUT THERE
    '- AND WE DO NOT NEED IT ANYMORE
    '- DEEMED OUT OF SCOPE FOR THE QUICKSTRIKE INITIATIVE BY
    '- Richard Peasley and Greg Bogard CGA
    '- 05111999
    '-----------------------------------------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------------------------------------


'if exists(select * from sysindexes where name = 'PK_S1010CLINIC')
'drop index s1010.clinic.PK_S1010CLINIC

End Function


Private Function fctIndexOn_LoadMatchFields(plngStudy_Id As Long) As Boolean
    
    Dim strSQL As String
    Dim strStudy_Id As String
    Dim strAlternateIndexName As String
    Dim strApplyMatchTableIndexName As String
    Dim StrCommaSeparatedFieldList As String
    
    Dim rsTablesWithMatchFields As ADODB.Recordset
    Dim rsMatchFields As ADODB.Recordset
    Dim rs As ADODB.Recordset
    Dim strTable_nm As String
    Dim strField_nm As String
    
    strStudy_Id = Trim(Str(plngStudy_Id))
    
    '-----------------------------------------------------------------------------------------------------------------------
    strSQL = _
    "SELECT  metaTable.Table_id," _
        & " metaTable.strTable_nm," _
        & " metaField.Field_id," _
        & " MetaField.strField_nm" _
    & " FROM MetaTable, metaStructure, MetaField" _
    & " WHERE MetaTable.study_id = " & plngStudy_Id _
        & " AND metaStructure.Table_id = metaTable.Table_id" _
        & " AND metaStructure.Field_id = metaField.Field_id" _
        & " AND metaStructure.bitMatchField_Flg = 1"

    Set rsMatchFields = New ADODB.Recordset
    rsMatchFields.CursorLocation = adUseClient
    rsMatchFields.Open strSQL, cn, adOpenKeyset, adLockBatchOptimistic
    Set rsMatchFields.ActiveConnection = Nothing

    If Not rsMatchFields.BOF And Not rsMatchFields.EOF Then
        rsMatchFields.MoveFirst
        Do While Not rsMatchFields.EOF
            '-----------------------------------------------------------------------------------------------------------------------
            '- look in sysindexes for index.
            '- OWNERFIELDTABLEALTERNATEINDEX
            '-----------------------------------------------------------------------------------------------------------------------
            strField_nm = Trim(rsMatchFields.Fields("strField_nm").Value)
            strTable_nm = Trim(rsMatchFields.Fields("strtable_nm").Value)
            strAlternateIndexName = _
                "S" _
                & strStudy_Id _
                & "_LOAD" & UCase(Trim(strField_nm)) _
                & "_LOAD" & UCase(Trim(strTable_nm))
            '-----------------------------------------------------------------------------------------------------------------------
            '- max length of index name = 30 chars
            '-----------------------------------------------------------------------------------------------------------------------
            If Len(strAlternateIndexName) > 30 Then
                strAlternateIndexName = Left(strAlternateIndexName, 30)
            End If
            'MsgBox strAlternateIndexName
            '-----------------------------------------------------------------------------------------------------------------------
            '- look in sysindexes for index.
            '- if you find it, leave it there.
            '- if you don't find it, create it.
            '-----------------------------------------------------------------------------------------------------------------------
            '*SQL7.0*
            strSQL = _
                "IF NOT EXISTS" _
                    & " (SELECT * FROM sysindexes WHERE name = " _
                    & "'" _
                    & strAlternateIndexName _
                    & "'" _
                    & ") " _
                    & "CREATE INDEX " _
                    & strAlternateIndexName _
                    & " ON S" _
                    & strStudy_Id _
                    & "." _
                    & strTable_nm & "_LOAD" _
                    & "(" _
                    & strField_nm _
                    & ")"
            cn.Execute strSQL
            rsMatchFields.MoveNext
        Loop
    Else
        Exit Function
    End If
    
    '''''
    'do it again! for the compound indexes
    '''''

    strSQL = _
    "SELECT  DISTINCT" _
        & " metaTable.Table_id," _
        & " metaTable.strTable_nm," _
        & " metaTable.study_id" _
    & " FROM MetaTable, metaStructure, MetaField" _
    & " WHERE MetaTable.study_id = " & plngStudy_Id _
        & " AND metaStructure.Table_id = metaTable.Table_id" _
        & " AND metaStructure.Field_id = metaField.Field_id" _
        & " AND metaStructure.bitMatchField_Flg = 1"

    Set rsTablesWithMatchFields = New ADODB.Recordset
    rsTablesWithMatchFields.CursorLocation = adUseClient
    rsTablesWithMatchFields.Open strSQL, cn, adOpenKeyset, adLockBatchOptimistic
    Set rsTablesWithMatchFields.ActiveConnection = Nothing
    rsMatchFields.MoveFirst
    If Not rsTablesWithMatchFields.BOF And Not rsTablesWithMatchFields.EOF Then
        rsTablesWithMatchFields.MoveFirst
        Dim strTable_nm1 As String
        Do While Not rsTablesWithMatchFields.BOF And Not rsTablesWithMatchFields.EOF
            strTable_nm1 = Trim(rsTablesWithMatchFields.Fields("strtable_nm").Value)
            StrCommaSeparatedFieldList = ""
            rsMatchFields.MoveFirst
            Do While Not rsMatchFields.EOF ' And rsMatchFields!strtable_nm = rsTablesWithMatchFields!strtable_nm
                strTable_nm = Trim(rsMatchFields.Fields("strtable_nm").Value)
                strField_nm = Trim(rsMatchFields.Fields("strField_nm").Value)
                If strTable_nm & "_LOAD" = strTable_nm1 & "_LOAD" Then
                    StrCommaSeparatedFieldList = _
                         StrCommaSeparatedFieldList _
                        & strField_nm _
                        & ","
                End If
                rsMatchFields.MoveNext
            Loop
            StrCommaSeparatedFieldList = Left(StrCommaSeparatedFieldList, Len(StrCommaSeparatedFieldList) - 1)
            strApplyMatchTableIndexName = _
                "S" _
                & strStudy_Id _
                & "_LOADCDX" _
                & UCase(strTable_nm1)
            If Len(strApplyMatchTableIndexName) > 30 Then
                strApplyMatchTableIndexName = Left(strApplyMatchTableIndexName, 30)
            End If
            '*SQL7.0*
            strSQL = _
                "SELECT * FROM sysindexes WHERE name = " _
                    & "'" _
                    & strApplyMatchTableIndexName _
                    & "'"
            Set rs = New ADODB.Recordset
            rs.CursorLocation = adUseClient
            rs.Open strSQL, cn, adOpenKeyset, adLockBatchOptimistic
            Set rs.ActiveConnection = Nothing
            If Not rs.BOF And Not rs.EOF Then
                strSQL = _
                     "DROP INDEX " _
                        & "S" _
                        & strStudy_Id _
                        & "." _
                        & strTable_nm1 & "_LOAD" _
                        & "." _
                        & strApplyMatchTableIndexName
                cn.Execute strSQL
            End If
            strSQL = _
                "CREATE INDEX " _
                    & strApplyMatchTableIndexName _
                    & " ON S" _
                    & strStudy_Id _
                    & "." _
                    & strTable_nm1 & "_LOAD" _
                    & "(" _
                    & StrCommaSeparatedFieldList _
                    & ")"
            cn.Execute strSQL
            rsTablesWithMatchFields.MoveNext
        Loop
    Else
        'do nothin
    End If

End Function
