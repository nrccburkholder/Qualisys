VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CReadMethods"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Collection" ,"CReadMethod"
Attribute VB_Ext_KEY = "Member0" ,"CReadMethod"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      CReadMethods.cls
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    This file contains the object definition that is
'\\                 used to collect the entries from the ReadMethods
'\\                 table for use in lookups.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    'local variable to hold collection
    Private moReadMethods As Collection
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Clear
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
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
'\\         Date:   03-07-2002
'\\
'\\ Description:    This routine is used to add new codes to
'\\                 the collection.
'\\
'\\ Parameters:
'\\     Name            Type    Description
'\\     lReadMethodID   Long    The ID from the database for this code.
'\\     bMultiResponce  Boolean The bit flag from the database for this
'\\                             code.
'\\
'\\ Return Value:
'\\     Type            Description
'\\     CReadMethod     A reference to the newly added code.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function Add(ByVal lReadMethodID As Long, _
                    ByVal bMultiResponce As Boolean) As CReadMethod
    
    Dim sKey        As String
    Dim oReadMethod As CReadMethod
    
    'create a new object
    Set oReadMethod = New CReadMethod
    
    'set the properties passed into the method
    sKey = "K" & lReadMethodID
    With oReadMethod
        .ReadMethodID = lReadMethodID
        .MultiResponce = bMultiResponce
        .Key = sKey
    End With
    
    'Add this object to the collection
    moReadMethods.Add oReadMethod, sKey
    
    'return the object created
    Set Add = oReadMethod
    Set oReadMethod = Nothing
    
End Function

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Item
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    Returns a reference to the requested Code.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Item(ByVal vIndexKey As Variant) As CReadMethod
Attribute Item.VB_UserMemId = 0
    
    On Error Resume Next
    Set Item = moReadMethods(vIndexKey)
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
'\\         Date:   03-07-2002
'\\
'\\ Description:    Returns the total quantity of Codes in this
'\\                 collection.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Count() As Long
    
    Count = moReadMethods.Count
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Remove
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    Removes the specified code from the collection.
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
    
    moReadMethods.Remove vIndexKey
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  NewEnum
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
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
    
    Set NewEnum = moReadMethods.[_NewEnum]
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Class_Initialize
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
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
    Set moReadMethods = New Collection
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Class_Terminate
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
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
    Set moReadMethods = Nothing
    
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   PopulateFromDB
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    This routine populates the collection with the
'\\                 read methods.
'\\
'\\ Parameters:
'\\     Name        Type                Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub PopulateFromDB()
    
    Dim sSql    As String
    Dim oTempRs As ADODB.Recordset
    
    'Build the SQL query
    sSql = "SELECT ReadMethod_id, bitMultiResp " & _
           "FROM ReadMethod"
    
    'Open the recordset
    Set oTempRs = goConn.Execute(sSql)
    
    'Populate the collection
    With oTempRs
        Do Until .EOF
            'Add this code
            Add lReadMethodID:=!ReadMethod_id, bMultiResponce:=!bitMultiResp
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With
    
    'Cleanup
    oTempRs.Close: Set oTempRs = Nothing
    
End Sub




