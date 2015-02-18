Attribute VB_Name = "FreqTool"
'-----------------------------------------------------------------
' Copyright © National Research Corporation
'
' Required References:
'       Microsoft ActiveX Data Objects 2.5 Library
'       OLE Automation
'       Microsoft DAO 3.5 Object Library
'       Microsoft Excel 8.0 Object Library
'       DynamiCube Property Page Library
'       DynamiCube Version 2.0
'       getEmpId
'       StudySelector
'       SurveySelector
'       ImportFunctionsPROC
'       QualiSysFunctions
'
' Revisions:
'   Date        By  Description
'   9-17-2002   SH  Modified the path so it works on any platform.
'                   Removed QualProSecurity
'   09-18-2002  SH  Added global Log in name to create the
'                   directory on a local drive.
'   9-28-2002   SH  Renamed QualProFunctions to
'                   QualiSysFunctions.
'   10-04-2002  SH  Recompiled with VB6.0 and move EXE to
'                   \components\QualiSysEXEs\.
'   12/02/2002  FG  Removed "Respondanst" option from Main Form.
'                   Changed value of RAW_DATA from 3 to 2,
'                   and value RESPONDENTS from 2 to 3.
'-----------------------------------------------------------------

Option Explicit

Public Const UNIVERSE = 0
Public Const SAMPLE_SET = 1
Public Const RAW_DATA = 2
Public Const RESPONDENTS = 3
Public Const INVALID_DATA = -1

Public Type udtTableFields
    TableName As String
    Table_id As Long
    FieldName As String
    Key_Field As Long
    Field_id As Long
    Field_Type As String
End Type

Public aTableFields() As udtTableFields
Public oLib As QualiSysFunctions.Library
Public mvarTables As Variant
Public gstrS_StudyNum As String
Public gstrSQL1 As String
Public gstrSQL2 As String
Public gstrCommandLine As String
Private strDSN_Info As String
Private strCommandTimeout As String
Private strConnectionTimeout As String
Private strDatabase As String
Public gstrSampleSets As String

Public glngSampleSet_id As Long
Public lngEmployeeId As Long
Public glngStudy_id As Long
Public glngSurvey_id As Long
Public glngEmployeeId As Long
' *** Added 09-18-2002 SH
Public gstrLoginName As String

Public cnOne As New ADODB.Connection
Public cnTwo As New ADODB.Connection
Public cn As New ADODB.Connection

Private Sub Main()

    GetEmpIdCheckSecurity
    
    gstrCommandLine = Command()
    
    If fnbol_ConnectToDb = True Then
        frmMain.Show
    Else
        MsgBox "Unable to connect to Database", vbOKOnly + vbCritical, _
        "Frequency Tool - Database Connection "
        Exit Sub
    End If

End Sub

'-----------------------------------------------------------------
' Copyright © National Research Corporation
'
' Routine Name:     GetEmpIdCheckSecurity
'
' Created By:       ?????
'         Date:     00-00-0000
'
' Description:
'
' Parameters:
'     Name        Type        Description
'
' Revisions:
'     Date        By      Description
'     09-17-2002  SH      Removed QualProSecurity
'     09-18-2002  SH      Added global Log in name to create the
'                         directory on a local drive.
'     01-13-2003  SH      Added Security.
'-----------------------------------------------------------------

Public Sub GetEmpIdCheckSecurity()

    Dim pGetEmpObj As GetEmpIdDll

    Set pGetEmpObj = CreateObject("getempid.getempiddll")
    
    If pGetEmpObj.RetrieveUserEmployeeID() Then
         lngEmployeeId = pGetEmpObj.UserEmployeeID
         gstrLoginName = pGetEmpObj.UserLoginName ' Added 09-18-2002 SH
         
         Dim anObject As New QualiSysFunctions.checkAccess
         
         If Not anObject.IsUserInModules(CInt(lngEmployeeId), "Frequency_Tool") Then
            MsgBox "Security violation.  You have not been assigned permission to run this application(Frequency Tool).  Please see QualiSys-Security Administrator."
            End
         End If
         Set anObject = Nothing
    Else
        MsgBox "Access Denied.  Login name not found in QualiSys Associates table."
        End
    End If
    
    Set pGetEmpObj = Nothing
    
End Sub

' *** Removed 09-17-2002 SH
'Public Sub GetEmpIdCheckSecurity()
'
'    Dim pGetEmpObj As GetEmpIdDll
'    Dim objQualProSecurity As QualProSecurity.checkSecurity
'
'    Set objQualProSecurity = CreateObject("QualProSecurity.checkSecurity")
'
'    If objQualProSecurity.IsUserInNtGroupModule("Frequency_Tool") Then
'        Set objQualProSecurity = Nothing
'
'        Set pGetEmpObj = CreateObject("getempid.getempiddll")
'
'        If pGetEmpObj.RetrieveUserEmployeeID() Then
'             lngEmployeeId = pGetEmpObj.UserEmployeeID
'        Else
'            MsgBox "Access Denied.  See QualPro System Administrator(add user to employee table)"
'            End
'        End If
'
'        Set pGetEmpObj = Nothing
'    Else
'        Set objQualProSecurity = Nothing
'        MsgBox "Access Denied.(User not authorized to execute this module)  See QualPro System Administrator(add NT user to NT group, if authorized.)"
'        End
'    End If
'
'End Sub

Private Function fnbol_ConnectToDb() As Long

    On Error GoTo ErrorHandler
    
    Dim strErrMsg As String
    
    fnbol_ConnectToDb = False
    
    Set oLib = CreateObject("QualiSysFunctions.Library")
    
    strDSN_Info = oLib.GetDBString(True)
    
    ' 08/18/99 Dan Wagner - CGA
    ' Added to code to read to connection timeout and command timeout for the requency tool.
    strCommandTimeout = oLib.GetCommandTimeout("FrequencyTool")
    strConnectionTimeout = oLib.GetConnectionTimeout("FrequencyTool")
    Set oLib = Nothing
    cnOne.ConnectionTimeout = strConnectionTimeout
    cnOne.CommandTimeout = strCommandTimeout
    
    cnOne.Open strDSN_Info

    fnbol_ConnectToDb = True

    Exit Function

ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: FreqTool.fnbol_ConnectToDb, Error Description: " & Err.Description
    End

End Function

Public Sub GetAvailableFields(mvarTables As Variant, glngStudy_id As Long)
         
    Dim X, iField, iTable_id As Long
    Dim i As Long
    Dim strTableField As String
    Dim iRedim As Long
    Dim aField, aSelected As Variant
    'Dim objwiz As mtsImportFunctions.mts_Import_Wizard ' Removed 09-17-2002 SH
    Dim objwiz As ImportFunctionsPROC.Import_Wizard_PROC
    Dim bSelected As Boolean
    
    bSelected = False
    iRedim = 0
    iField = 0
    
    'Set objwiz = CreateObject("mtsImportFunctions.mts_import_wizard") ' Removed 09-17-2002 SH
    Set objwiz = CreateObject("ImportFunctionsPROC.Import_Wizard_PROC")
    
    aSelected = objwiz.mts_fnvnt_Get_Selected_Fields(glngStudy_id)
    
    For i = 0 To UBound(mvarTables, 2)
        If mvarTables(2, i) = "True" Then
            iTable_id = mvarTables(0, i)
            
            aField = objwiz.mts_fnvnt_Get_FieldNames(iTable_id)
            
            iRedim = iRedim + (UBound(aField, 2) + 1)
            
            ReDim Preserve aTableFields(iRedim)
            
            For X = 0 To UBound(aField, 2)
                strTableField = Trim(mvarTables(1, i)) & "." & Trim(aField(0, X))
                
                If Not IsEmpty(aSelected) Then
                    bSelected = CheckSelectedFields(aSelected, iTable_id, aField(2, X))
                Else
                    bSelected = False
                End If
                
                If bSelected Then
                    frmFrequency!lstSelectedFields.AddItem strTableField
                Else
                    frmFrequency!lstAvailableFields.AddItem strTableField
                End If
                
                aTableFields(iField).TableName = Trim(mvarTables(1, i))
                aTableFields(iField).Table_id = iTable_id
                aTableFields(iField).FieldName = Trim(aField(0, X))
                aTableFields(iField).Key_Field = aField(1, X)
                aTableFields(iField).Field_id = aField(2, X)
                aTableFields(iField).Field_Type = IIf(IsNull(aField(3, X)), "NF", aField(3, X))
                iField = iField + 1
            Next X
        End If
    Next i
    
    Set objwiz = Nothing
    
End Sub

Public Function CheckSelectedFields(aSelected As Variant, ByVal intTable_id As Long, ByVal intFields_id As Long) As Boolean

    Dim lngCounter As Long
    
    For lngCounter = 0 To UBound(aSelected, 2)
        If intTable_id = aSelected(0, lngCounter) And intFields_id = aSelected(1, lngCounter) Then
            CheckSelectedFields = True
            Exit For
        Else
            CheckSelectedFields = False
        End If
    Next lngCounter

End Function

Public Function mts_Get_Popid_Tables(ByVal plngStudy_id As Long) As Variant

    On Error GoTo ErrorHandler
    
    Dim rs As New ADODB.Recordset
    Dim strSql As String
    
    strSql = "SELECT * " & _
             "FROM metatable " & _
             "WHERE metatable.Study_id = " & plngStudy_id & _
             "      AND table_id in " & _
             "(SELECT DISTINCT table_id " & _
             " FROM metadata_view " & _
             " WHERE study_id = " & plngStudy_id & _
             "       AND strField_nm = 'pop_id')" & _
             "ORDER BY strTable_nm "

    Set rs = cn.Execute(strSql, adOpenKeyset)
        
    If Not rs.EOF And Not rs.BOF Then
        mts_Get_Popid_Tables = rs.GetRows
        rs.Close
    End If
    
    Set rs = Nothing
    
    Exit Function

ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: FreqTool.mts_Get_Popid_Tables, Error Description: " & Err.Description
    End

End Function

Public Function mtsRetrieveDSN_INFO()

    Dim o As QualiSysFunctions.Library
    Dim strDSN_Info As String
    
    Set o = CreateObject("QualiSysFunctions.Library")
    
    strDSN_Info = o.GetDBString
    
    cn.Open strDSN_Info
    
    Set o = Nothing
    
End Function

Public Function mts_fnlng_Get_KeyField(ByVal plngStudy_id As Long, ByVal plngSampleSet_id As Long, ByVal strTable As String, ByVal strField As String) As Variant

    Dim rs As New ADODB.Recordset
    Dim strSql As String
    
    strSql = "SELECT strField_nm, Table_id from metadata_view " & _
             "WHERE Study_id = " & plngStudy_id & _
             "      AND strTable_nm = '" & strTable & "'" & _
             "      AND bitkeyfield_flg = 1 "
             
    Set rs = cnOne.Execute(strSql, adOpenKeyset)
    
    If Not rs.EOF And Not rs.BOF Then
        mts_fnlng_Get_KeyField = rs.GetRows()
    Else
        mts_fnlng_Get_KeyField = Empty
    End If
    
    rs.Close
    
End Function

Public Function mts_fnvnt_Get_KeyField(ByVal glngStudy_id As Long, ByVal strTable As String) As Variant
    
    Dim rs As New ADODB.Recordset
    Dim strSql As String
    
    strSql = "SELECT strField_nm, Table_id from metadata_view " & _
             "WHERE Study_id = " & glngStudy_id & _
             "      AND strTable_nm = '" & strTable & "'" & _
             "      AND bitkeyfield_flg = 1 "
             
    Set rs = cnOne.Execute(strSql, adOpenKeyset)
    
    If Not rs.EOF And Not rs.BOF Then
        mts_fnvnt_Get_KeyField = rs.GetRows()
    Else
        mts_fnvnt_Get_KeyField = Empty
    End If
    
    rs.Close
    
End Function

Public Function mts_fnlng_Get_FieldCount_Popid(ByVal plngStudy_id As Long, ByVal intSampleSet_id As Long, ByVal strTable As String, ByVal strField As String) As Long
    
    On Error GoTo ErrorHandler
        
    Dim rs As New ADODB.Recordset
    Dim strKeyField As Variant
    Dim varKeyField As Variant
    Dim strSql As String

    varKeyField = mts_fnlng_Get_KeyField(plngStudy_id, intSampleSet_id, strTable, strField)
    
    strSql = "SELECT COUNT (T." & strField & ") " & _
             "FROM S" & plngStudy_id & "." & strTable & " T, " & _
             "(SELECT DISTINCT U.keyValue " & _
             " FROM S" & plngStudy_id & ".unikeys U, samplepop S " & _
             " WHERE U.sampleset_id = " & intSampleSet_id & _
             "       AND U.Table_id = " & varKeyField(1, 0) & _
             "       AND U.SampleSet_id = S.sampleSet_id " & _
             "       AND U.pop_id = S.pop_id ) US " & _
             "WHERE T." & varKeyField(0, 0) & " = US.keyValue "

    'strSql = "SELECT Count ( " & strField & ") " & _
    '        " FROM S" & plngStudy_id & "." & strTable & Chr(32) & " T " & _
    '        " WHERE exists " & _
    '        " ( SELECT * from S" & plngStudy_id & ".unikeys U, samplepop S " & _
    '        " WHERE U.sampleset_id = " & intSampleSet_id & _
    '        " AND T." & varKeyField(0, 0) & " = U.keyValue " & _
    '        " AND U.Table_id = " & varKeyField(1, 0) & _
    '        " AND U.SampleSet_id = S.sampleSet_id " & _
    '        " AND U.pop_id = S.pop_id ) "

    Set rs = cn.Execute(strSql, adOpenKeyset)
        
    If rs.EOF And rs.BOF Then
        mts_fnlng_Get_FieldCount_Popid = 0
    Else
        rs.MoveFirst
        mts_fnlng_Get_FieldCount_Popid = rs.Fields(0)
        rs.Close
    End If
    
    Set rs = Nothing

    Exit Function
    
ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: FreqTool.mts_fnlng_Get_FieldCount_Popid, Error Description: " & Err.Description
    End

End Function

Public Function mts_fnvnt_Get_FreqData_Popid(ByVal plngStudy_id As Long, ByVal intSampleSet_id As Long, ByVal strTable As String, ByVal strField As String, ByVal iTotal As Long) As Variant
    
    On Error GoTo ErrorHandler
    
    Dim rs As New ADODB.Recordset
    Dim varKeyField As Variant
    Dim i As Long
    Dim strSql As String
        
    varKeyField = mts_fnlng_Get_KeyField(plngStudy_id, intSampleSet_id, strTable, strField)
    
    strSql = "SELECT T." & strField & ", COUNT ( " & strField & " ), " & _
             "(CONVERT(real,(COUNT(" & strField & " )))/" & iTotal & ") " & _
             "FROM S" & plngStudy_id & "." & strTable & " T, " & _
             "(SELECT DISTINCT U.keyValue " & _
             " FROM S" & plngStudy_id & ".unikeys U, samplepop S " & _
             " WHERE U.sampleset_id = " & intSampleSet_id & _
             "       AND U.table_id = " & varKeyField(1, 0) & _
             "       AND U.SampleSet_id = S.sampleSet_id " & _
             "       AND U.pop_id = S.pop_id) US " & _
             "WHERE T." & strField & " IS NOT NULL " & _
             "      AND T." & strField & " <> '' " & _
             "      AND T." & varKeyField(0, 0) & " = US.keyValue " & _
             "GROUP BY T." & strField & " " & _
             "ORDER BY T." & strField

    'strSql = "SELECT " & strField & ", count ( " & strField & " ), " & _
    '         "(convert(real,(count(" & strField & " )))/" & iTotal & ") " & _
    '         "FROM S" & plngStudy_id & "." & strTable & " T " & _
    '         "WHERE isnull(convert(char, " & strField & "),'') <> '' " & _
    '         "AND EXISTS " & _
    '        " ( SELECT * from S" & plngStudy_id & ".unikeys U, samplepop S " & _
    '        " WHERE U.sampleset_id = " & intSampleSet_id & _
    '        " AND T." & varKeyField(0, 0) & " = U.keyValue " & _
    '        " AND U.table_id = " & varKeyField(1, 0) & _
    '        " AND U.SampleSet_id = S.sampleSet_id " & _
    '        " AND U.pop_id = S.pop_id ) " & _
    '        " GROUP BY " & strField
            
    Set rs = cn.Execute(strSql, adOpenKeyset)

    If rs.EOF And rs.BOF Then
        mts_fnvnt_Get_FreqData_Popid = 0
        rs.Close
        Set rs = Nothing
        Exit Function
    Else
        mts_fnvnt_Get_FreqData_Popid = rs.GetRows
        rs.Close
    End If
    
    Set rs = Nothing
    
    Exit Function
    
ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: FreqTool.mts_fnvnt_Get_FreqData_Popid, Error Description: " & Err.Description
    End

End Function

Public Function mts_fnlng_Get_FieldCountForTool(strSql As String) As Long
    
    On Error GoTo ErrorHandler
        
    Dim rs As New ADODB.Recordset
    Set rs = cnOne.Execute(strSql, adOpenKeyset)
        
    If rs.EOF And rs.BOF Then
        mts_fnlng_Get_FieldCountForTool = 0
    Else
        rs.MoveFirst
        mts_fnlng_Get_FieldCountForTool = rs!TotalCount
        rs.Close
    End If
    
    Set rs = Nothing
    
    Exit Function
    
ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: FreqTool.mts_fnlng_Get_FieldCountForTool, Error Description: " & Err.Description
    End

End Function

Public Function mts_fnstr_GetCrossTabFields(lngStudy_id As Long, strTableName As String)

    On Error GoTo ErrorHandler
        
    Dim rs As New ADODB.Recordset
    Dim strSql As String

    strSql = "SELECT DISTINCT metaTable.strTable_nm, metaField.strField_nm " & _
             "FROM (metaStructure " & _
             "INNER JOIN metaTable ON metaStructure.Table_id = metaTable.Table_id) " & _
             "INNER JOIN metaField ON metaStructure.Field_id = metaField.Field_id " & _
             "WHERE Study_id = " & glngStudy_id & " and metaTable.strTable_nm = '" & strTableName & "'"

    Set rs = cnOne.Execute(strSql, adOpenKeyset)
        
    If rs.EOF And rs.BOF Then
        mts_fnstr_GetCrossTabFields = 0
    Else
        rs.MoveFirst
        mts_fnstr_GetCrossTabFields = rs.GetRows
        rs.Close
    End If
    
    Set rs = Nothing

    Exit Function
    
ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: FreqTool.mts_fnstr_GetCrossTabFields, Error Description: " & Err.Description
    End
    
End Function

Public Function mts_fnvnt_Get_FreqDataForTool(strSql As String) As Variant

    Dim rs As New ADODB.Recordset
    Dim i As Long
        
    Set rs = cnOne.Execute(strSql, adOpenKeyset)

    If rs.EOF And rs.BOF Then
        mts_fnvnt_Get_FreqDataForTool = 0
        Set rs = Nothing
        Exit Function
    Else
        mts_fnvnt_Get_FreqDataForTool = rs.GetRows
        rs.Close
    End If
    
    Exit Function
    
ErrorHandler:
    MsgBox "The following Error occurred: " & vbCr & _
           "Error Number: " & Err.Number & _
           ", Error Source: FreqTool.mts_fnvnt_Get_FreqDataForTool, Error Description: " & Err.Description
    End
    
End Function
