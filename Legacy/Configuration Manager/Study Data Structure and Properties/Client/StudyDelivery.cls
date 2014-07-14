VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StudyDelivery"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Event Valid(IsValid As Boolean)

Private udtProps As StudyDeliveryProps
Private udtSave As StudyDeliveryProps
Private udtChild As StudyDeliveryProps

Private objParent As StudyDeliveryColl

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
    
    Dim objDB As StudyDeliveryDB
    
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

Public Sub Load(StudyDeliveryID As Long)
  
    Dim objDB As StudyDeliveryDB
    
    If flgChild Then Err.Raise 445
    If flgEditing Then Err.Raise 445
    If Not flgNew Then Err.Raise 445
    
    If Not flgChild Then
        ' code to load the object goes here
        Set objDB = New StudyDeliveryDB
        With objDB
            .Fetch StudyDeliveryID
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

Friend Property Set Parent(Value As StudyDeliveryColl)
  
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
    udtProps.HoursWorked = -1
  
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
  
    Dim udtData As StudyDeliveryData
    
    udtData.Buffer = Buffer
    LSet udtProps = udtData
    flgNew = False

End Sub

Friend Function GetState() As String
  
    Dim udtData As StudyDeliveryData
      
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

Public Property Get ID() As Long
    
    ID = udtProps.ID

End Property

Public Property Let DeliveryDate(Value As Variant)
  
    If Not flgEditing Then Err.Raise 383
    
    If IsDate(Value) Then
      udtProps.DeliveryDate = CVDate(Value)
    Else
      udtProps.DeliveryDate = 0
    End If
    
    flgDirty = True

End Property

Public Property Get DeliveryDate() As Variant
  
    If udtProps.DeliveryDate = 0 Then
      DeliveryDate = ""
    Else
      DeliveryDate = udtProps.DeliveryDate
    End If

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

Public Property Let DateWorked(Value As Variant)
  
    If Not flgEditing Then Err.Raise 383
    
    If IsDate(Value) Then
        udtProps.DateWorked = CVDate(Value)
    Else
        udtProps.DateWorked = 0
    End If
    
    flgDirty = True

End Property

Public Property Get DateWorked() As Variant
  
    If udtProps.DateWorked = 0 Then
        DateWorked = ""
    Else
        DateWorked = udtProps.DateWorked
    End If

End Property

Public Property Get IsBillable() As Boolean
    
    IsBillable = udtProps.IsBillable

End Property

Public Property Let IsBillable(Value As Boolean)
    
    If Not flgEditing Then Err.Raise 383
        
    udtProps.IsBillable = Value
    flgDirty = True

End Property

Public Property Get IsClientRequest() As Boolean
    
    IsClientRequest = udtProps.IsClientRequest

End Property

Public Property Let IsClientRequest(Value As Boolean)
    
    If Not flgEditing Then Err.Raise 383
        
    udtProps.IsClientRequest = Value
    flgDirty = True

End Property

Public Property Get IsCorrection() As Boolean
    
    IsCorrection = udtProps.IsCorrection

End Property

Public Property Let IsCorrection(Value As Boolean)
    
    If Not flgEditing Then Err.Raise 383
        
    udtProps.IsCorrection = Value
    flgDirty = True

End Property

Public Property Get HoursWorked() As Long
    
    HoursWorked = udtProps.HoursWorked

End Property

Public Property Let HoursWorked(Value As Long)
    
    If Not flgEditing Then Err.Raise 383
        
    udtProps.HoursWorked = Value
    flgDirty = True

End Property

Public Property Get ContactID() As Long
    
    ContactID = udtProps.ContactID
    
End Property

Public Property Let ContactID(Value As Long)
    
    If Not flgEditing Then Err.Raise 383
    udtProps.ContactID = Value
    flgDirty = True

End Property
