VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CCommentCode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      CCommentCode
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    This file contains the definition of the comment
'\\                 code class.
'\\
'\\ Required References:
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     10-31-05    JJF     Added DispositionID property
'\\     11-29-05    JJF     Added ActionID property
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private msKey           As String   'local copy
    Private mlID            As Long     'local copy
    Private msDescription   As String   'local copy
    Private mlDispositionID As Long
    Private mlActionID      As Long
    
    Public Enum eDispositionActionConstants
        eDACTakeOffCallList = 1
        eDACChangeRespondentAddress = 2
        eDACReGenerateMailingInNewLanguage = 3
        eDACReGenerateMailing = 4
        eDACDeleteFutureMailings = 5
        eDACLogContactRequest = 6
    End Enum
    
    Public Enum eGetActionSQLReturnValues
        eGASInvalid = -1
        eGASUnsupported = 0
        eGASSuccess = 1
    End Enum
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Description
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    Sets/Returns the description string associated with
'\\                 with this code object.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let Description(ByVal sData As String)
    
    msDescription = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Description
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    Sets/Returns the description string associated with
'\\                 with this code object.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Description() As String
    
    Description = msDescription
    
End Property




Public Function GetActionSQL(ByRef oComment As CComment, ByRef sSql As String) As eGetActionSQLReturnValues
    
    Dim eReturn     As eGetActionSQLReturnValues
    Dim oUserInfo   As New CUserInfo
    
    'Start the error trap
    On Error GoTo ErrorHandler
    
    'Determine what action to take based on this code's action ID
    Select Case mlActionID
        Case eDispositionActionConstants.eDACTakeOffCallList
            'Take this respondent off the call list
            sSql = "QCL_TakeOffCallList '" & oComment.LithoCode & "', " & _
                   Me.DispositionID & ", " & goRegReceiptTypeComment.Value & ", '" & _
                   oUserInfo.UserName & "'"
            eReturn = eGASSuccess
            
        Case eDispositionActionConstants.eDACChangeRespondentAddress
            'Change the respondants address
            'This feature is not supported at this time so just log the disposition
            sSql = "QCL_LogDisposition " & oComment.SentMailID & ", " & _
                   oComment.SamplePopID & ", " & Me.DispositionID & ", " & _
                   goRegReceiptTypeComment.Value & ", '" & oUserInfo.UserName & "'"
            eReturn = eGASUnsupported
            
        Case eDispositionActionConstants.eDACReGenerateMailingInNewLanguage
            'Regenerate this mailing in a different language
            'This feature is not supported at this time so just log the disposition
            sSql = "QCL_LogDisposition " & oComment.SentMailID & ", " & _
                   oComment.SamplePopID & ", " & Me.DispositionID & ", " & _
                   goRegReceiptTypeComment.Value & ", '" & oUserInfo.UserName & "'"
            eReturn = eGASUnsupported
            
        Case eDispositionActionConstants.eDACReGenerateMailing
            'Regenerate this mailing in the original language
            'This feature is not supported at this time so just log the disposition
            sSql = "QCL_LogDisposition " & oComment.SentMailID & ", " & _
                   oComment.SamplePopID & ", " & Me.DispositionID & ", " & _
                   goRegReceiptTypeComment.Value & ", '" & oUserInfo.UserName & "'"
            eReturn = eGASUnsupported
            
        Case eDispositionActionConstants.eDACDeleteFutureMailings
            'Delete all future mailings of this survey to this respondant
            sSql = "QCL_DeleteFutureMailings '" & oComment.LithoCode & "', " & _
                   Me.DispositionID & ", " & goRegReceiptTypeComment.Value & ", '" & _
                   oUserInfo.UserName & "'"
            eReturn = eGASSuccess
            
        Case eDispositionActionConstants.eDACLogContactRequest
            'Log a contact request to this respondant
            'This feature is not supported at this time so just log the disposition
            sSql = "QCL_LogDisposition " & oComment.SentMailID & ", " & _
                   oComment.SamplePopID & ", " & Me.DispositionID & ", " & _
                   goRegReceiptTypeComment.Value & ", '" & oUserInfo.UserName & "'"
            eReturn = eGASUnsupported
            
        Case Else
            'This would be an unknown disposition action so just log the disposition
            sSql = ""
            eReturn = eGASInvalid
            
    End Select
    
    'Set the return value
    GetActionSQL = eReturn
    
    'Cleanup
    Set oUserInfo = Nothing
    
Exit Function


ErrorHandler:
    sSql = ""
    GetActionSQL = eGASInvalid
    Exit Function
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    Sets/Returns the ID associated with this code
'\\                 object.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ID(ByVal lData As Long)
    
    mlID = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  DispositionID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-31-2005
'\\
'\\ Description:    Sets/Returns the disposition ID associated with
'\\                 this comment code.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let DispositionID(ByVal lData As Long)
    
    mlDispositionID = lData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ActionID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   11-29-2005
'\\
'\\ Description:    Sets/Returns the action ID associated with
'\\                 this comment code.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ActionID(ByVal lData As Long)
    
    mlActionID = lData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    Sets/Returns the ID associated with this code
'\\                 object.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ID() As Long
    
    ID = mlID
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  DispositionID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-31-2005
'\\
'\\ Description:    Sets/Returns the disposition ID associated with
'\\                 this comment code.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get DispositionID() As Long
    
    DispositionID = mlDispositionID
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ActionID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   11-29-2005
'\\
'\\ Description:    Sets/Returns the action ID associated with
'\\                 this comment code.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ActionID() As Long
    
    ActionID = mlActionID
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Key
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    Sets/Returns the Key associated with this code
'\\                 object.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let Key(ByVal sData As String)
    
    msKey = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Key
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    Sets/Returns the Key associated with this code
'\\                 object.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Key() As String
    
    Key = msKey
    
End Property



