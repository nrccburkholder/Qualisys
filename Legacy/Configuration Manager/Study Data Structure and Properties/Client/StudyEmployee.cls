VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StudyEmployee"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Event Valid(IsValid As Boolean)

Private udtProps As StudyEmployeeProps
Private udtSave As StudyEmployeeProps
Private udtChild As StudyEmployeeProps

Private objParent As StudyEmployeeColl

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
    
    Dim objDB As StudyEmployeeDB
    
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

Public Sub Load(StudyID As Long, EmployeeID As Long)
  
    Dim objDB As StudyEmployeeDB
    
    If flgChild Then Err.Raise 445
    If flgEditing Then Err.Raise 445
    If Not flgNew Then Err.Raise 445
    
    If Not flgChild Then
        ' code to load the object goes here
        Set objDB = New StudyEmployeeDB
        With objDB
            .Fetch StudyID, EmployeeID
            SetState .GetState
        End With
        Set objDB = Nothing
    End If
    
    flgNew = False
  
End Sub

Public Sub Delete()
  
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

Friend Property Set Parent(Value As StudyEmployeeColl)
    
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
  
    Dim udtData As StudyEmployeeData
    
    udtData.Buffer = Buffer
    LSet udtProps = udtData
    flgNew = False

End Sub

Friend Function GetState() As String
  
    Dim udtData As StudyEmployeeData
      
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
Public Property Get StudyID() As Long
    
    StudyID = udtProps.StudyID

End Property

Public Property Get EmployeeID() As Long
    
    EmployeeID = udtProps.EmployeeID

End Property

Public Property Let EmployeeID(Value As Long)
    
    If Not flgEditing Then Err.Raise 383
        
    udtProps.EmployeeID = Value
    flgDirty = True

End Property
