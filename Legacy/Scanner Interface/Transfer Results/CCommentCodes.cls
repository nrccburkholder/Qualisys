VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CCommentCodes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"CCommentCode"
Attribute VB_Ext_KEY = "Member0" ,"CCommentCode"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      CCommentCodes.cls
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    This file contains the object definition that is
'\\                 used to collect and process comment codes, types
'\\                 and valences.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    'local variable to hold collection
    Private moCommentCodes As Collection
    
    Public Enum eCommentCodeTypes
        eCCTCodes = 1
        eCCTTypes = 2
        eCCTValences = 3
    End Enum
    
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   IsIDValid
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    This function returns a flag indicating whether or
'\\                 not the supplied ID is valid.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     lID         Long        The ID to be validated.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  - ID is valid in the collection.
'\\                 FALSE - ID is not found in the collection.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function IsIDValid(ByVal lID As Long) As Boolean
    
    If Item("K" & lID) Is Nothing Then
        IsIDValid = False
    Else
        IsIDValid = True
    End If
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   IsDisposition
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-31-2005
'\\
'\\ Description:    This function returns a flag indicating whether or
'\\                 not the supplied ID is a disposition.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     lID         Long        The ID to be validated.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  - ID is a disposition.
'\\                 FALSE - ID is not a disposition.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function IsDisposition(ByVal lID As Long) As Boolean
    
    On Error GoTo ErrorHandler
    
    If Item("K" & lID).DispositionID > 0 Then
        IsDisposition = True
    Else
        IsDisposition = False
    End If
    
Exit Function


ErrorHandler:
    IsDisposition = False
    Exit Function
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   PopulateFromDB
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    This routine populates the collection with the
'\\                 specified type of codes.
'\\
'\\ Parameters:
'\\     Name        Type                Description
'\\     eCodeType   eCommentCodeTypes   The type of codes to be populated.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     10-31-05    JJF     Added DispositionID property
'\\     11-29-05    JJF     Added ActionID property
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub PopulateFromDB(ByVal eCodeType As eCommentCodeTypes)
    
    Dim sSql    As String
    Dim oTempRs As ADODB.Recordset
    
    'Build the SQL query
    Select Case eCodeType
        Case eCommentCodeTypes.eCCTCodes
            sSql = "SELECT cc.CmntCode_id AS CodeID, cc.strCmntCode_Nm AS Description, " & _
                   "       IsNull(cc.Disposition_id, 0) AS DispositionID, " & _
                   "       IsNull(ds.Action_id, 0) AS ActionID " & _
                   "FROM CommentCodes cc LEFT JOIN Disposition ds " & _
                   "                            ON cc.Disposition_id = ds.Disposition_id "
            
        Case eCommentCodeTypes.eCCTTypes
            sSql = "SELECT CmntType_id AS CodeID, strCmntType_Nm AS Description, " & _
                   "       0 AS DispositionID, 0 AS ActionID " & _
                   "FROM CommentTypes"
            
        Case eCommentCodeTypes.eCCTValences
            sSql = "SELECT CmntValence_id AS CodeID, strCmntValence_Nm AS Description, " & _
                   "       0 AS DispositionID, 0 AS ActionID " & _
                   "FROM CommentValences"
            
    End Select
    
    'Open the recordset
    Set oTempRs = goConn.Execute(sSql)
    
    'Populate the collection
    With oTempRs
        Do Until .EOF
            'Add this code
            Add lID:=!CodeID, sDescription:="" & !Description, _
                lDispositionID:=!DispositionID, lActionID:=!ActionID
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Clear
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    This routine clears out all members of the collection.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub Clear()
    
    Dim lCnt As Long
    
    For lCnt = 1 To Count
        Remove 1
    Next lCnt
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Add
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    This routine is used to add new codes to
'\\                 the collection.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     lID             String  The ID from the database for this code.
'\\     sDescription    String  The _Nm from the database for this code.
'\\     bIsDisposition  Boolean The bitDisposition from the database for
'\\                             this code.
'\\
'\\ Return Value:
'\\     Type            Description
'\\     CCommentCode    A reference to the newly added code.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     10-31-05    JJF     Added the DispositionID property
'\\     11-29-05    JJF     Added the ActionID property
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function Add(ByVal lID As Long, _
                    ByVal sDescription As String, _
                    ByVal lDispositionID As Long, _
                    ByVal lActionID As Long) As CCommentCode
    
    Dim sKey            As String
    Dim oCommentCode    As CCommentCode
    
    'create a new object
    Set oCommentCode = New CCommentCode
    
    'set the properties passed into the method
    sKey = "K" & lID
    With oCommentCode
        .Key = sKey
        .ID = lID
        .Description = sDescription
        .DispositionID = lDispositionID
        .ActionID = lActionID
    End With
    
    'Add the new object to the collection
    moCommentCodes.Add oCommentCode, sKey
    
    'return the object created
    Set Add = oCommentCode
    Set oCommentCode = Nothing
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Item
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    Returns a reference to the requested Code.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Item(ByVal vIndexKey As Variant) As CCommentCode
Attribute Item.VB_UserMemId = 0
    
    On Error Resume Next
    Set Item = moCommentCodes(vIndexKey)
    If Err.Number <> 0 Then
        Err.Clear
        Set Item = Nothing
    End If
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Count
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    Returns the total quantity of Codes in this
'\\                 collection.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Count() As Long
    
    Count = moCommentCodes.Count
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Remove
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    Removes the specified Comment from the collection.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     vIndexKey   Variant     Either the KEY or INDEX of the Code
'\\                             to be removed from the collection.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub Remove(ByVal vIndexKey As Variant)
    
    moCommentCodes.Remove vIndexKey
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  NewEnum
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    Returns the IUnknown interface of the collection
'\\                 to allow for using the FOR EACH construct.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
    
    Set NewEnum = moCommentCodes.[_NewEnum]
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Class_Initialize
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    This routine is called by the VB runtime upon
'\\                 initialization of an instance of this class.  This
'\\                 is where we create the new collection object.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Class_Initialize()
    
    'creates the collection when this class is created
    Set moCommentCodes = New Collection
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Class_Terminate
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   10-30-2001
'\\
'\\ Description:    This routine is called by the VB runtime upon
'\\                 termination of an instance of this class.  This
'\\                 is where we cleanup the collection object.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Class_Terminate()
    
    'destroys collection when this class is terminated
    Set moCommentCodes = Nothing
    
End Sub

