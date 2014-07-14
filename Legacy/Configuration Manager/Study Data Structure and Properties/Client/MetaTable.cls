VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MetaTable"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Event Valid(IsValid As Boolean)

Private udtProps As MetaTableProps
Private udtSave As MetaTableProps
Private udtChild As MetaTableProps

Private objParent As MetaTableColl

Private objMetaFieldColl As MetaFieldColl

Private flgNew As Boolean
Private flgDeleted As Boolean
Private flgDirty As Boolean
Private flgEditing As Boolean
Private flgLoadedMetaFields As Boolean

Private WithEvents objValid As BrokenRules
Attribute objValid.VB_VarHelpID = -1

Private flgChild As Boolean
Private flgChildEditing As Boolean

Public Sub BeginEdit()
    If flgChild Then If Not flgChildEditing Then Err.Raise 445
    If flgEditing Then Err.Raise 445
    
    ' save object state
    LSet udtSave = udtProps
    flgEditing = True
End Sub

Public Sub CancelEdit()
    If flgChild Then If Not flgChildEditing Then Err.Raise 445
    If Not flgEditing Then Err.Raise 445
    
    flgEditing = False
    flgDeleted = False
    ' restore object state
    LSet udtProps = udtSave
End Sub

Public Sub ApplyEdit()
    Dim objDB As MetaTableDB
    
    If flgChild Then If Not flgChildEditing Then Err.Raise 445
    If Not flgChild And flgNew Then Err.Raise 445
    If Not flgEditing Then Err.Raise 445
    If Not flgChild Then Err.Raise 445
      
    If Not objParent Is Nothing Then
        objParent.AddChild Me
        Set objParent = Nothing
    End If
  
    flgEditing = False
End Sub

Public Sub Load(MetaTableID As Long)
    Dim objDB As MetaTableDB
    
    If flgChild Then Err.Raise 445
    If flgEditing Then Err.Raise 445
    If Not flgNew Then Err.Raise 445
    
    If Not flgChild Then
        ' code to load the object goes here
        Set objDB = New MetaTableDB
        With objDB
            .Fetch MetaTableID
            '        objMetaFieldColl.Load ID
            SetState .GetState
        End With
        Set objDB = Nothing
    End If
    
    flgNew = False
End Sub

Public Sub Delete()
    If Not flgChildEditing Then Err.Raise 445
    
    flgDeleted = True
    objMetaFieldColl.Delete
End Sub

' ****************************
' **** START OF CHILD CODE ***

Friend Sub ChildBeginEdit()
    If flgChildEditing Then Err.Raise 445
    
    ' save object state
    LSet udtChild = udtProps
    objMetaFieldColl.ChildBeginEdit
    flgChildEditing = True
End Sub

Friend Sub ChildCancelEdit()
    If Not flgChildEditing Then Err.Raise 445
    
    flgChildEditing = False
    flgDeleted = False
    ' restore object state
    LSet udtProps = udtChild
    objMetaFieldColl.ChildCancelEdit
End Sub

Friend Sub SetAsChild()
    flgChild = True
End Sub

Friend Property Set Parent(Value As MetaTableColl)
    Set objParent = Value
End Property

' **** END OF CHILD CODE ***
' ****************************

Public Property Get IsValid() As Boolean
    IsValid = (objValid.Count = 0)
End Property

Private Sub Class_Initialize()
    flgNew = True
    Set objValid = New BrokenRules
    
    Set objMetaFieldColl = New MetaFieldColl
    flgLoadedMetaFields = False
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

Friend Sub SetState(Buffer As String)
    Dim udtData As MetaTableData
    
    udtData.Buffer = Buffer
    LSet udtProps = udtData
    flgNew = False
End Sub

Friend Function GetState() As String
    Dim udtData As MetaTableData
      
    With udtProps
        .IsDeleted = flgDeleted
        .IsNew = flgNew
        .IsDirty = flgDirty
    End With
    
    LSet udtData = udtProps
    GetState = udtData.Buffer
End Function

Public Sub ResetValues()
    flgNew = False
    flgDeleted = False
    flgDirty = False
    flgEditing = False
    flgChildEditing = False
End Sub

'***************
'
'   Accessor functions
'
'
'***************
Public Property Get StudyID() As Long
    StudyID = udtProps.StudyID
End Property

Public Property Get ID() As Long
    ID = udtProps.ID
End Property

Public Property Get name() As String
    name = Trim$(udtProps.name)
End Property

Public Property Let name(Value As String)
    If Not flgEditing Then Err.Raise 383
    
    If Len(Value) > Len(udtProps.name) Then
        Err.Raise vbObjectError + 1001, "String Value too long"
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

Public Property Get UsesAddress() As Boolean
    UsesAddress = udtProps.UsesAddress
End Property

Public Property Let UsesAddress(Value As Boolean)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.UsesAddress = Value
    flgDirty = True
End Property

Public Property Get MetaFieldColl() As MetaFieldColl
'    If Not flgChildEditing Then
'        objMetaFieldColl.Load ID
'    End If
'    Set MetaFieldColl = objMetaFieldColl
        
    If Not flgLoadedMetaFields Then
        objMetaFieldColl.Load ID
        flgLoadedMetaFields = True
    End If
    Set MetaFieldColl = objMetaFieldColl
End Property

Public Function IsPosted() As Boolean
    Dim aFld As MetaField
    
    IsPosted = False
    For Each aFld In MetaFieldColl
        If aFld.IsPosted Then
            IsPosted = True
            Exit For
        End If
    Next
End Function

' *** 05-09-2005 SH Added
Public Function IsPII() As Boolean
    Dim aFld As MetaField
    
    IsPII = False
    For Each aFld In MetaFieldColl
        If aFld.IsPII Then
            IsPII = True
            Exit For
        End If
    Next
End Function

Public Function IsAllowUS() As Boolean
    Dim aFld As MetaField
    
    IsAllowUS = False
    For Each aFld In MetaFieldColl
        If aFld.IsAllowUS Then
            IsAllowUS = True
            Exit For
        End If
    Next
End Function
' *** End of addition

Public Function IsPreDefinedTable() As Boolean
    If IsPopulationTable _
        Or IsEncounterTable _
        Or IsProviderTable Then
            IsPreDefinedTable = True
    Else
        IsPreDefinedTable = False
    End If
End Function

Public Function IsPopulationTable() As Boolean
    IsPopulationTable = IIf((name = POPULATION_TABLE), True, False)
End Function

Public Function IsEncounterTable() As Boolean
    IsEncounterTable = IIf((name = ENCOUNTER_TABLE), True, False)
End Function

Public Function IsProviderTable() As Boolean
    IsProviderTable = IIf((name = PROVIDER_TABLE), True, False)
End Function

Public Function DisplayProperties() As String
    Dim strDisplay As String

    strDisplay = "ID:" & vbTab & vbTab & CStr(ID) & vbCrLf
    strDisplay = strDisplay & "Name:" & vbTab & vbTab & Trim(name) & vbCrLf
    strDisplay = strDisplay & "UsesAddress:" & vbTab & BooleanToString(UsesAddress) & vbCrLf
    strDisplay = strDisplay & "Posted:" & vbTab & vbTab & BooleanToString(IsPosted) & vbCrLf
    strDisplay = strDisplay & "Description:" & vbCrLf
    strDisplay = strDisplay & vbTab & Trim(Description) & vbCrLf
    
    DisplayProperties = strDisplay
End Function

Public Sub AddKeyField()
    Dim aFld As MetaField
    
    Set aFld = MetaFieldColl.Add
    ' *** 05-09-2005 SH Modified
'    aFld.BeginEdit
''    aFld.TableID = ID
'    aFld.IsKeyField = True
'    aFld.IsPosted = False
'    aFld.IsMatchField = False
'    aFld.IsUserField = False
'    aFld.lookupTableID = -1
'    aFld.lookupFieldID = -1
'    aFld.ApplyEdit
    With aFld
        .BeginEdit
        .IsKeyField = True
        .IsPosted = False
        .IsMatchField = False
        .IsUserField = False
        '.IsAllowUS = False
        .IsAllowUS = True ' 08-09-2005 SH
        .IsPII = False
        .lookupTableID = -1
        .lookupFieldID = -1
        .ApplyEdit
    End With
    ' *** End of Modification
End Sub

Public Sub AddNewRecordDateField()
    Dim aFld As MetaField
    Dim fldID As Long
    Dim objDB As MetaFieldListDB
    
    Set objDB = New MetaFieldListDB
    Set aFld = MetaFieldColl.Add
    ' *** 05-09-2005 SH Modified
'    aFld.BeginEdit
''    aFld.TableID = ID
'    aFld.ID = objDB.FetchNewRecordDateID
'    aFld.IsKeyField = False
'    aFld.IsPosted = False
'    aFld.IsMatchField = False
'    aFld.IsUserField = False
'    aFld.lookupTableID = -1
'    aFld.lookupFieldID = -1
'    aFld.ApplyEdit
    With aFld
        .BeginEdit
        .ID = objDB.FetchNewRecordDateID
        .IsKeyField = False
        .IsPosted = False
        .IsMatchField = False
        .IsUserField = False
        .IsPII = objDB.IsPII(.ID)
        '.IsAllowUS = False
        .IsAllowUS = Not objDB.IsPII(.ID) ' 08-09-2005 SH Modified
        .lookupTableID = -1
        .lookupFieldID = -1
        .ApplyEdit
    End With
    ' *** End of modification
End Sub

Public Sub AddLanguageCode()
    Dim aFld As MetaField
    Dim fldID As Long
    Dim objDB As MetaFieldListDB
    
    Set objDB = New MetaFieldListDB
    Set aFld = MetaFieldColl.Add
    ' *** 05-09-2005 SH Modified
'    aFld.BeginEdit
''    aFld.TableID = ID
'    aFld.ID = objDB.FetchLanguageID
'    aFld.IsKeyField = False
'    aFld.IsPosted = False
'    aFld.IsMatchField = False
'    aFld.IsUserField = False
'    aFld.lookupTableID = -1
'    aFld.lookupFieldID = -1
'    aFld.ApplyEdit
    With aFld
        .BeginEdit
        .ID = objDB.FetchLanguageID
        .IsKeyField = False
        .IsPosted = False
        .IsMatchField = False
        .IsUserField = False
        .IsPII = objDB.IsPII(.ID)
        '.IsAllowUS = False
        .IsAllowUS = Not objDB.IsPII(.ID) ' 08-09-2005 SH Modified
        .lookupTableID = -1
        .lookupFieldID = -1
        .ApplyEdit
    End With
    ' *** End of modification
End Sub

Public Sub AddAgeField()
    Dim aFld As MetaField
    Dim fldID As Long
    Dim objDB As MetaFieldListDB
    
    Set objDB = New MetaFieldListDB
    Set aFld = MetaFieldColl.Add
    ' *** 05-09-2005 SH Modified
'    aFld.BeginEdit
'    aFld.ID = objDB.FetchAgeField
'    aFld.IsKeyField = False
'    aFld.IsPosted = False
'    aFld.IsMatchField = False
'    aFld.IsUserField = False
'    aFld.lookupTableID = -1
'    aFld.lookupFieldID = -1
'    aFld.ApplyEdit
    With aFld
        .BeginEdit
        .ID = objDB.FetchAgeField
        .IsKeyField = False
        .IsPosted = False
        .IsMatchField = False
        .IsUserField = False
        .IsPII = objDB.IsPII(.ID)
        '.IsAllowUS = False
        .IsAllowUS = Not objDB.IsPII(.ID) ' 08-09-2005 SH Modified
        .lookupTableID = -1
        .lookupFieldID = -1
        .ApplyEdit
    End With
    ' *** End of modification
End Sub

Public Sub AddGenderField()
    Dim aFld As MetaField
    Dim fldID As Long
    Dim objDB As MetaFieldListDB
    
    Set objDB = New MetaFieldListDB
    Set aFld = MetaFieldColl.Add
    ' *** 05-09-2005 SH Modified
'    aFld.BeginEdit
'    aFld.ID = objDB.FetchGenderField
'    aFld.IsKeyField = False
'    aFld.IsPosted = False
'    aFld.IsMatchField = False
'    aFld.IsUserField = False
'    aFld.lookupTableID = -1
'    aFld.lookupFieldID = -1
'    aFld.ApplyEdit
    With aFld
        .BeginEdit
        .ID = objDB.FetchGenderField
        .IsKeyField = False
        .IsPosted = False
        .IsMatchField = False
        .IsUserField = False
        .IsPII = objDB.IsPII(.ID)
        '.IsAllowUS = False
        .IsAllowUS = Not objDB.IsPII(.ID) ' 08-09-2005 SH modified
        .lookupTableID = -1
        .lookupFieldID = -1
        .ApplyEdit
    End With
    ' *** End of modification
End Sub

Public Sub AddPopIDField()
    Dim aFld As MetaField
    Dim fldID As Long
    Dim objDB As MetaFieldListDB
    
    Set objDB = New MetaFieldListDB
    Set aFld = MetaFieldColl.Add
    ' *** 05-09-2005 SH Modified
'    aFld.BeginEdit
'    aFld.ID = objDB.FetchPopID
'    aFld.IsKeyField = False
'    aFld.IsPosted = False
'    aFld.IsMatchField = False
'    aFld.IsUserField = False
'    aFld.lookupTableID = -1
'    aFld.lookupFieldID = -1
'    aFld.ApplyEdit
    With aFld
        .BeginEdit
        .ID = objDB.FetchPopID
        .IsKeyField = False
        .IsPosted = False
        .IsMatchField = False
        .IsUserField = False
        .IsPII = objDB.IsPII(.ID)
        '.IsAllowUS = False
        .IsAllowUS = Not objDB.IsPII(.ID) ' 08-09-2005 SH Modified
        .lookupTableID = -1
        .lookupFieldID = -1
        .ApplyEdit
    End With
    ' *** End of modification
End Sub
