VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MetaField"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Event Valid(IsValid As Boolean)

Private udtProps As MetaFieldProps
Private udtSave As MetaFieldProps
Private udtChild As MetaFieldProps

Private objParent As MetaFieldColl

Private flgNew As Boolean
Private flgDeleted As Boolean
Private flgDirty As Boolean
Private flgEditing As Boolean
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
    Dim objDB As MetaFieldDB
    
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

Public Sub Load(MetaTableID As Long, MetaFieldID As Long)
    Dim objDB As MetaFieldDB
    
    If flgChild Then Err.Raise 445
    If flgEditing Then Err.Raise 445
    If Not flgNew Then Err.Raise 445
    
    If Not flgChild Then
        ' code to load the object goes here
        Set objDB = New MetaFieldDB
        With objDB
            .Fetch MetaTableID, MetaFieldID
            SetState .GetState
        End With
        Set objDB = Nothing
    End If
    flgNew = False
End Sub

Friend Sub Delete()
    If Not flgChildEditing Then Err.Raise 445
    
    flgDeleted = True
End Sub

' ****************************
' **** START OF CHILD CODE ***

Friend Sub ChildBeginEdit()
    If flgChildEditing Then Err.Raise 445
    
    ' save object state
    LSet udtChild = udtProps
    flgChildEditing = True
End Sub

Friend Sub ChildCancelEdit()
    If Not flgChildEditing Then Err.Raise 445
    
    flgChildEditing = False
    flgDeleted = False
    ' restore object state
    LSet udtProps = udtChild
End Sub

Friend Sub SetAsChild()
    flgChild = True
End Sub

Friend Property Set Parent(Value As MetaFieldColl)
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
    Dim udtData As MetaFieldData
    
    udtData.Buffer = Buffer
    LSet udtProps = udtData
    flgNew = False
End Sub

Friend Function GetState() As String
    Dim udtData As MetaFieldData
    
    With udtProps
        .IsNew = flgNew
        .IsDeleted = flgDeleted
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

Public Property Get TableID() As Long
    TableID = udtProps.TableID
End Property

Public Property Let TableID(Value As Long)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.TableID = Value
    flgDirty = True
End Property

Public Property Get ID() As Long
    ID = udtProps.ID
End Property

Public Property Let ID(Value As Long)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.ID = Value
    flgDirty = True
End Property

Public Property Get IsKeyField() As Boolean
    IsKeyField = udtProps.IsKeyField
End Property

Public Property Let IsKeyField(Value As Boolean)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.IsKeyField = Value
    flgDirty = True
End Property

Public Property Get IsUserField() As Boolean
    IsUserField = udtProps.IsUserField
End Property

Public Property Let IsUserField(Value As Boolean)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.IsUserField = Value
    flgDirty = True
End Property

Public Property Get IsMatchField() As Boolean
    IsMatchField = udtProps.IsMatchField
End Property

Public Property Let IsMatchField(Value As Boolean)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.IsMatchField = Value
    flgDirty = True
End Property

Public Property Get lookupTableID() As Long
    lookupTableID = udtProps.lookupTableID
End Property

Public Property Let lookupTableID(Value As Long)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.lookupTableID = Value
    flgDirty = True
End Property

Public Property Get lookupFieldID() As Long
    lookupFieldID = udtProps.lookupFieldID
End Property

Public Property Let lookupFieldID(Value As Long)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.lookupFieldID = Value
    flgDirty = True
End Property

Public Property Get LookupType() As String
    LookupType = Trim$(udtProps.LookupType)
End Property

Public Property Let LookupType(Value As String)
    If Not flgEditing Then Err.Raise 383

    Dim strRelation As String
    If Value = G_FOREIGN Then
        strRelation = G_FOREIGN_CHAR
    ElseIf Value = G_LOOKUP Then
        strRelation = G_LOOKUP_CHAR
    ElseIf Value = G_DETAIL Then
        strRelation = G_DETAIL_CHAR
    ElseIf ((Value = G_FOREIGN_CHAR) _
        Or (Value = G_LOOKUP_CHAR) _
        Or (Value = G_DETAIL_CHAR)) Then
            strRelation = Value
    Else
        Err.Raise vbObjectError + 1002, "Unknown value for Lookup Type"
    End If

    udtProps.LookupType = strRelation
    flgDirty = True
End Property

Public Function LookupTypeAsString() As String
    ' returns the lookup type in the string form
    Dim strRelation As String
    
    If LookupType = G_FOREIGN_CHAR Then
        strRelation = G_FOREIGN
    ElseIf LookupType = G_LOOKUP_CHAR Then
        strRelation = G_LOOKUP
    ElseIf LookupType = G_DETAIL_CHAR Then
        strRelation = G_DETAIL
    End If

    LookupTypeAsString = strRelation
End Function

Public Function LookupTypeAsChar() As String
    ' returns the lookup type in the character form.
    ' useful since the database needs it in this form.
    LookupTypeAsChar = LookupType
End Function

Public Property Get IsPosted() As Boolean
    IsPosted = udtProps.IsPosted
End Property

Public Property Let IsPosted(Value As Boolean)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.IsPosted = Value
    flgDirty = True
End Property

' *** 05-09-2005 SH Added
Public Property Get IsPII() As Boolean
    IsPII = udtProps.IsPII
End Property

Public Property Let IsPII(Value As Boolean)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.IsPII = Value
    flgDirty = True
End Property

Public Property Get IsAllowUS() As Boolean
    IsAllowUS = udtProps.IsAllowUS
End Property

Public Property Let IsAllowUS(Value As Boolean)
    If Not flgEditing Then Err.Raise 383
        
    udtProps.IsAllowUS = Value
    flgDirty = True
End Property
' *** End of addition

Public Function DisplayProperties() As String
    Dim strDisplay As String
    
    strDisplay = strDisplay & "KeyField:" & vbTab & vbTab & BooleanToString(IsKeyField) & vbCrLf
    strDisplay = strDisplay & "UserField:" & vbTab & vbTab & BooleanToString(IsUserField) & vbCrLf
    strDisplay = strDisplay & "MatchField:" & vbTab & BooleanToString(IsMatchField) & vbCrLf
    strDisplay = strDisplay & "Posted:" & vbTab & vbTab & BooleanToString(IsPosted) & vbCrLf
    ' *** 05-09-2005 SH Added
    strDisplay = strDisplay & "PII:" & vbTab & vbTab & BooleanToString(IsPII) & vbCrLf
    strDisplay = strDisplay & "AllowUS:" & vbTab & vbTab & BooleanToString(IsAllowUS) & vbCrLf
    ' *** End of addition
    DisplayProperties = strDisplay
End Function
