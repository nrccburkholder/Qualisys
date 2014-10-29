VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "QSOpenEndList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    Private mstrTemplateID  As String
    
    Private mobjHeaders     As Headers
    
Public Function GetList(ByVal intQstnCore As Integer) As Headers
    
    Set GetList = mobjHeaders
    
End Function


Public Sub Initialize(ByVal strTemplateID As String)
    
    Dim intCnt          As Integer
    Dim lngSurveyID     As Long
    Dim lngHeaderID     As Long
    Dim lngSubHeaderID  As Long
    Dim objHeader       As Header
    Dim objSubHeader    As SubHeader
    Dim objCodeListCm   As ADODB.Command
    Dim objConn         As ADODB.Connection
    Dim objListRs       As ADODB.Recordset
    
    'Open the database connection
    ReadRegistry
    OpenDBConnection objConn:=objConn, strConnString:=gobjRegMainDBConnString.Value
    
    'Setup the code select command
    Set objCodeListCm = New ADODB.Command
    With objCodeListCm
        .CommandText = "sp_NRCList_GetCodeList"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 30
        .ActiveConnection = objConn
        .Parameters.Append .CreateParameter("SurveyID", adInteger, adParamInput)
    End With 'objCodeListCm

    'Clear the existing collection
    Set mobjHeaders = Nothing
    
    'Create a new collection
    Set mobjHeaders = New Headers
    
    'Save the new template id
    mstrTemplateID = strTemplateID
    
    'Get the survey id
    lngSurveyID = 0
    For intCnt = 1 To Len(strTemplateID)
        'Find the first non-numeric character
        If Not IsNumeric(Mid(strTemplateID, intCnt, 1)) Then
            lngSurveyID = Val(Left(strTemplateID, intCnt - 1))
            Exit For
        End If
    Next intCnt
    
    'Get the appropriate list(s) from the database
    objCodeListCm.Parameters("SurveyID") = lngSurveyID
    Set objListRs = objCodeListCm.Execute
    
    'Check to make sure we got a list
    If objListRs.EOF Then
        'We did not get anything so get the entire list
        Set objListRs = Nothing
        objCodeListCm.Parameters("SurveyID") = 0
        Set objListRs = objCodeListCm.Execute
    End If
    
    'Populate the collection
    lngHeaderID = 0
    lngSubHeaderID = 0
    With objListRs
        Do Until .EOF
            'Determine if we need to add a new Header
            If lngHeaderID <> !CmntHeader_id Then
                'This is a new header so add it
                lngHeaderID = !CmntHeader_id
                Set objHeader = mobjHeaders.Add(strHeaderID:="" & !CmntHeader_id, _
                                                strHeaderName:="" & !strCmntHeader_Nm)
            End If
            
            'Determine if we need to add a new SubHeader
            If lngSubHeaderID <> !CmntSubHeader_id Then
                'This is a new SubHeader so add it
                lngSubHeaderID = !CmntSubHeader_id
                Set objSubHeader = objHeader.SubHeaders.Add(strSubHeaderID:="" & !CmntSubHeader_id, _
                                                            strSubHeaderName:="" & !strCmntSubHeader_Nm)
            End If
            
            'Add this code
            objSubHeader.Codes.Add strCodeID:="" & !CmntCode_id, _
                                   strCodeName:="" & !strCmntCode_Nm, _
                                   bolIsLocal:=True
            
            'Prepare for next pass
            .MoveNext
        Loop
    End With
    
    'Cleanup
    objListRs.Close: Set objListRs = Nothing
    Set objCodeListCm = Nothing
    Set objSubHeader = Nothing
    Set objHeader = Nothing
    CloseDBConnection objConn:=objConn
    CloseRegistry
    
End Sub

Private Sub Class_Terminate()
    
    Set mobjHeaders = Nothing
    
End Sub


