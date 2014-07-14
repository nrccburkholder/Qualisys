VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MetaFieldList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private udtProps As MetaFieldListProps

Friend Sub SetState(Buffer As String)
    Dim udtData As MetaFieldListData
    
    udtData.Buffer = Buffer
    LSet udtProps = udtData
End Sub

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

Public Property Get ShortName() As String
    ShortName = Trim$(udtProps.ShortName)
End Property

Public Property Get Description() As String
    Description = Trim$(udtProps.Description)
End Property

Public Property Get DataType() As String
    DataType = Trim$(udtProps.DataType)
End Property

Public Property Get fieldLength() As Long
    fieldLength = udtProps.fieldLength
End Property

Public Property Get EditMask() As String
    EditMask = Trim$(udtProps.EditMask)
End Property

Public Property Get SpecialCode() As Long
    SpecialCode = udtProps.SpecialCode
End Property

Public Property Get GroupID() As Long
    GroupID = udtProps.GroupID
End Property

Public Property Get GroupName() As String
    GroupName = Trim$(udtProps.GroupName)
End Property

Public Property Get PII() As Boolean
    PII = udtProps.PII
End Property

Public Function DisplayProperties() As String
    Dim strDisplay As String
    Dim strFieldLength As String
    
    If hasDBFieldLength Then
        strFieldLength = CStr(fieldLength)
    Else
        strFieldLength = ""
    End If
    
    strDisplay = "ID:" & vbTab & vbTab & CStr(ID) & vbCrLf
    strDisplay = strDisplay & "Name:" & vbTab & vbTab & name & vbCrLf
    strDisplay = strDisplay & "Description:" & vbTab & vbTab & Description & vbCrLf
    strDisplay = strDisplay & "ShortName:" & vbTab & vbTab & ShortName & vbCrLf
    strDisplay = strDisplay & "DataType:" & vbTab & DataType & vbCrLf
    strDisplay = strDisplay & "FieldLength:" & vbTab & strFieldLength & vbCrLf
    strDisplay = strDisplay & "EditMask:" & vbTab & vbTab & EditMask & vbCrLf
    strDisplay = strDisplay & "SpecialCode:" & vbTab & CStr(SpecialCode) & vbCrLf
'    strDisplay = strDisplay & "GroupID:" & vbTab & vbTab & CStr(GroupID) & vbCrLf
'    strDisplay = strDisplay & "GroupName:" & vbTab & vbTab & GroupName & vbCrLf
    
    DisplayProperties = strDisplay
End Function

Public Function hasDBFieldLength() As Boolean
    Select Case DataType
    Case "B"
        hasDBFieldLength = False
    Case "R"
        hasDBFieldLength = False
    Case "I"
        hasDBFieldLength = False
    Case "S"
        hasDBFieldLength = True
    Case "D"
        hasDBFieldLength = False
    Case Else
        hasDBFieldLength = False
    End Select
End Function
