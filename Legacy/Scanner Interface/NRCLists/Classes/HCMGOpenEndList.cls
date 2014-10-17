VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "HCMGOpenEndList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    Private mstrTemplateID      As String
    
    Private mobjHospitalCodes   As Codes
    Private mobjSystemCodes     As Codes
    Private mobjPlanCodes       As Codes
    Private mobjListTypes       As ListTypes
Public Function GetList(ByVal intColNum As Integer, ByVal strBarcode As String) As Codes
    
    Dim objListType As ListType
    Dim objCodes    As Codes
    
    'Determine the ListType for this column number
    Set objListType = mobjListTypes.Item("LT" & intColNum)
    
    'See if we got one
    If objListType Is Nothing Then
        'No list type exists for this column number so return a blank list
        Set objCodes = New Codes
    Else
        'Get the appropriate list type
        Select Case objListType.ListType
            Case enuListTypeConstants.enuLTCHospital
                'Return the Hospital list
                Set objCodes = mobjHospitalCodes
                
            Case enuListTypeConstants.enuLTCSystem
                'Return the System list
                Set objCodes = mobjSystemCodes
                
            Case enuListTypeConstants.enuLTCPlan
                'Return the Plan list
                Set objCodes = mobjPlanCodes
                
            Case Else
                'Invalid list type was specified so return a blank list
                Set objCodes = New Codes
                
        End Select
    End If
    
    'Return the list
    Set GetList = objCodes
    
End Function


Public Sub Initialize(ByVal strTemplateID As String)
    
    Dim lngTemplate     As Long
    Dim lngCnt          As Long
    Dim intQtyCnt       As Integer
    Dim intAdjCnt       As Integer
    Dim intLowValue     As Integer
    Dim intHighValue    As Integer
    Dim intLength       As Integer
    Dim aintSmartChar() As Integer
    Dim strSmartCode    As String
    Dim objConn         As ADODB.Connection
    Dim objHospitalCm   As ADODB.Command
    Dim objSystemCm     As ADODB.Command
    Dim objPlanCm       As ADODB.Command
    Dim objListTypeCm   As ADODB.Command
    Dim objSmartCodesCm As ADODB.Command
    Dim objTempRs       As ADODB.Recordset
    
    'If the new template id is the same as the old template id then we are already
    '  loaded for this template.  Head out of Dodge.
    If mstrTemplateID = strTemplateID Then Exit Sub
    
    'Save the new template id
    mstrTemplateID = strTemplateID
    lngTemplate = Val(Trim(Mid(strTemplateID, 2)))
    
    'Open the database connection
    ReadRegistry
    OpenDBConnection objConn:=objConn, strConnString:=gobjRegHCMGDBConnString.Value
    
    'Setup the Hospital select command
    Set objHospitalCm = New ADODB.Command
    With objHospitalCm
        .CommandText = "sp_NRCList_GetHospitalList"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 60
        .ActiveConnection = objConn
        .Parameters.Append .CreateParameter("intGroup", adInteger, adParamInput)
    End With 'objHospitalCm
    
    'Setup the System select command
    Set objSystemCm = New ADODB.Command
    With objSystemCm
        .CommandText = "sp_NRCList_GetSystemList"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 60
        .ActiveConnection = objConn
    End With 'objSystemCm
    
    'Setup the Plan select command
    Set objPlanCm = New ADODB.Command
    With objPlanCm
        .CommandText = "sp_NRCList_GetPlanList"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 60
        .ActiveConnection = objConn
        .Parameters.Append .CreateParameter("intGroup", adInteger, adParamInput)
    End With 'objPlanCm
    
    'Setup the List Type select command
    Set objListTypeCm = New ADODB.Command
    With objListTypeCm
        .CommandText = "sp_NRCList_ListTypeByColumn"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 60
        .ActiveConnection = objConn
    End With 'objListTypeCm
    
    'Setup the Smart Codes select command
    Set objSmartCodesCm = New ADODB.Command
    With objSmartCodesCm
        .CommandText = "sp_NRCList_GetSmartCodes"
        .CommandType = adCmdStoredProc
        .CommandTimeout = 60
        .ActiveConnection = objConn
    End With 'objSmartCodesCm
    
    'Clear the existing Hospital collection
    Set mobjHospitalCodes = Nothing
    Set mobjHospitalCodes = New Codes
    
    'Get the appropriate Hospital data from the database
    objHospitalCm.Parameters("intGroup") = lngTemplate
    Set objTempRs = objHospitalCm.Execute
    
    'Populate the Hospital data collection
    With objTempRs
        Do Until .EOF
            mobjHospitalCodes.Add strCodeID:=Format(!intCodeID, "00000"), _
                                  strCodeName:="" & !strCodeName, _
                                  bolIsLocal:=!bitLocal
            
            'Prep for next pass
            .MoveNext
        Loop
    End With 'objTempRs
    objTempRs.Close: Set objTempRs = Nothing
    
    'Clear the existing System collection
    Set mobjSystemCodes = Nothing
    Set mobjSystemCodes = New Codes
    
    'Get the appropriate System data from the database
    Set objTempRs = objSystemCm.Execute
    
    'Populate the System data collection
    With objTempRs
        Do Until .EOF
            mobjSystemCodes.Add strCodeID:=Format(!intCodeID, "000000"), _
                                strCodeName:="" & !strCodeName, _
                                bolIsLocal:=!bitLocal
            
            'Prep for next pass
            .MoveNext
        Loop
    End With 'objTempRs
    objTempRs.Close: Set objTempRs = Nothing
    
    'Clear the existing Plan collection
    Set mobjPlanCodes = Nothing
    Set mobjPlanCodes = New Codes
    
    'Get the appropriate Plan data from the database
    objPlanCm.Parameters("intGroup") = lngTemplate
    Set objTempRs = objPlanCm.Execute
    
    'Populate the Plan data collection
    With objTempRs
        Do Until .EOF
            mobjPlanCodes.Add strCodeID:=Format(!intCodeID, "0000"), _
                              strCodeName:="" & !strCodeName, _
                              bolIsLocal:=!bitLocal
            
            'Prep for next pass
            .MoveNext
        Loop
    End With 'objTempRs
    objTempRs.Close: Set objTempRs = Nothing
    
    'Get the smart code information form the database
    Set objTempRs = objSmartCodesCm.Execute
    
    'Add the smart codes to the plan list
    intLowValue = Asc("A")
    intHighValue = Asc("Z")
    
    With objTempRs
        Do Until .EOF
            'Initialize the smart code string
            intLength = !intLength
            ReDim aintSmartChar(1 To intLength) As Integer
            aintSmartChar(1) = Asc(!strBeginLetter)
            For lngCnt = 2 To intLength
                If lngCnt = intLength Then
                    aintSmartChar(lngCnt) = intLowValue - 1
                Else
                    aintSmartChar(lngCnt) = intLowValue
                End If
            Next lngCnt
            
            'Loop the specified number of times
            For intQtyCnt = 1 To !intQuantity
                'Increment the letters
                For intAdjCnt = intLength To 2 Step -1
                    If aintSmartChar(intAdjCnt) + 1 <= intHighValue Then
                        aintSmartChar(intAdjCnt) = aintSmartChar(intAdjCnt) + 1
                        Exit For
                    Else
                        aintSmartChar(intAdjCnt) = intLowValue
                    End If
                Next intAdjCnt
                
                'Build the string
                strSmartCode = ""
                For lngCnt = 1 To intLength
                    strSmartCode = strSmartCode & Chr(aintSmartChar(lngCnt))
                Next lngCnt
                
                'Add this smart code to the plan list
                mobjPlanCodes.Add strCodeID:=strSmartCode, _
                                  strCodeName:="", _
                                  bolIsLocal:=True
            Next intQtyCnt
            
            'Prep for next pass
            .MoveNext
        Loop
    End With 'objTempRs
    objTempRs.Close: Set objTempRs = Nothing
    
    'Clear the existing ListType collection
    Set mobjListTypes = Nothing
    Set mobjListTypes = New ListTypes
    
    'Get the appropriate ListType data from the database
    Set objTempRs = objListTypeCm.Execute
    
    'Populate the ListType data collection
    With objTempRs
        Do Until .EOF
            mobjListTypes.Add lngStartColumn:=!intStartColumn, _
                              enuListType:=!intListType
            
            'Prep for next pass
            .MoveNext
        Loop
    End With 'objTempRs
    objTempRs.Close: Set objTempRs = Nothing
    
    'Cleanup
    Set objHospitalCm = Nothing
    Set objSystemCm = Nothing
    Set objPlanCm = Nothing
    Set objListTypeCm = Nothing
    CloseDBConnection objConn:=objConn
    CloseRegistry
    
End Sub

Private Sub Class_Terminate()
    
    Set mobjHospitalCodes = Nothing
    Set mobjSystemCodes = Nothing
    Set mobjPlanCodes = Nothing
    Set mobjListTypes = Nothing
    
End Sub


