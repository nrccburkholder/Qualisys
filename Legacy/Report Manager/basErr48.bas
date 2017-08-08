Attribute VB_Name = "basErr48"
'-----------------------------------------------------------------
' Copyright © National Research Corporation
'
' Required References:
'       Microsoft ActiveX Data Objects 2.5 Library
'       QualiSysFunctions
'       OLE Automation
'       getEmpId
'       StudySelector
'       SurveySelector
'
' Revisions:
'       Date        By  Description
'       09-12-2002  SH  Remove QualProSecurity
'       09-28-2002  SH  Renamed QualProFunctions to
'                       QualiSysFunctions.
'       10-04-2002  SH  Recompiled with VB6.0 and moved EXE to
'                       \components\QualiSysEXEs\.
'-----------------------------------------------------------------

' Keep a global object on the thread to
' keep the project from unloading when
' the last reference to it goes away
' It has to be public to trick VB into
' thinking that the thread is not done

Public gt_objDummy As New IDummy
Global lngEmployeeID As Long

Public Sub Main()

    ' First line of code should be to instantiate
    ' the dummy class. Be sure to set the Sun Main
    ' as the Startup Object in the project properties.
    Set gt_objDummy = New IDummy
    
    Dim pGetEmpObj As GetEmpIdDll
    
    ' Create an object to get the user id
    Set pGetEmpObj = CreateObject("getempid.getempiddll")
    
    ' If the user has a valid QualPro Employee entry
    If pGetEmpObj.RetrieveUserEmployeeID() Then
        lngEmployeeID = pGetEmpObj.UserEmployeeID
    Else
        MsgBox "Access Denied.  See QualiSys Systems Administrator"
        End
    End If
    
    Set pGetEmpObj = Nothing

    frmMain.Show

End Sub

' *** Removed 09-12-2002 SH
' Sample Sub main function
'Public Sub main()
'
'    ' First line of code should be to instantiate
'    ' the dummy class. Be sure to set the Sun Main
'    ' as the Startup Object in the project properties.
'    Set gt_objDummy = New IDummy
'
'    ' Do rest of work if any
'    'Dim objQualProSecurity As QualProSecurity.checkSecurity
'
'Set objQualProSecurity = CreateObject("QualProSecurity.checkSecurity")
'
' If objQualProSecurity.IsUserInNtGroupModule("Report_Mgr") Then
'         Dim pGetEmpObj As GetEmpIdDll
'        '   Create an object to get the user id
'        Set pGetEmpObj = CreateObject("getempid.getempiddll")
'        '   If the user has a valid QualPro Employee entry
'        If pGetEmpObj.RetrieveUserEmployeeID() Then
'            lngEmployeeID = pGetEmpObj.UserEmployeeID
'        Else
'            MsgBox "Access Denied.  See QualPro Systems Administrator"
'            End
'        End If
'        Set pGetEmpObj = Nothing
'
'    frmMain.Show
'Else
'    MsgBox "Access to this module is denied.  See the administrator"
'    End
'End If

'Set objQualProSecurity = Nothing
'
'End Sub
