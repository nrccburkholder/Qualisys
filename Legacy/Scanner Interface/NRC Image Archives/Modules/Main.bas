Attribute VB_Name = "modMain"
Option Explicit
    
    Public goConn As ADODB.Connection
    
    Public gbStartCatalog As Boolean
    
    Public Enum eSearchModeConstants
        smcSimpleSearch = 0
        smcAdvancedSearch = 1
        smcSpecificLithoCode = 2
    End Enum
    
    Public Enum eRightClickConstants
        rccNone = 0
        rccTemplateProperties = 1
        rccBatchProperties = 2
        rccImageProperties = 3
    End Enum
    
    Public Enum eBatchTypeConstants
        btcSelectedImages = 0
        btcSelectedArchives = 1
    End Enum
    
    
Public Function Replace(ByVal sString As String, _
                        ByVal sReplace As String, _
                        ByVal sWith As String) As String
    
    Dim lLoc As Long
    Dim sTemp As String
    
    lLoc = InStr(sString, sReplace)
    Do Until lLoc = 0
        sString = Left(sString, lLoc - 1) & sWith & Mid(sString, lLoc + Len(sReplace))
        lLoc = InStr(lLoc + Len(sWith), sString, sReplace)
    Loop
    
    Replace = sString
    
End Function

Public Sub ShowTemplateProperties(ByVal sArchiveLabel As String, _
                                  oParentForm As Form)
    
    Dim oLocalForm As frmTemplateStats
    
    'Load the form
    Set oLocalForm = New frmTemplateStats
    Load oLocalForm
    
    'Display the form
    With oLocalForm
        'Set properties
        .ArchiveLabel = sArchiveLabel
        
        'Show form
        .Show vbModal, oParentForm
    End With
    
    'Cleanup
    Unload oLocalForm
    Set oLocalForm = Nothing
    
End Sub

Public Sub ShowBatchProperties(ByVal sArchiveLabel As String, _
                               ByVal sTemplateLabel As String, _
                               oParentForm As Form)
    
    Dim oLocalForm As frmBatchStats
    
    'Load the form
    Set oLocalForm = New frmBatchStats
    Load oLocalForm
    
    'Display the form
    With oLocalForm
        'Set properties
        .ArchiveLabel = sArchiveLabel
        .TemplateLabel = sTemplateLabel
        
        'Show form
        .Show vbModal, oParentForm
    End With
    
    'Cleanup
    Unload oLocalForm
    Set oLocalForm = Nothing
    
End Sub

Public Sub ShowImageProperties(ByVal sArchiveLabel As String, _
                               ByVal sTemplateLabel As String, _
                               ByVal sBatchLabel As String, _
                               oParentForm As Form)
    
    Dim oLocalForm As frmImageStats
    
    'Load the form
    Set oLocalForm = New frmImageStats
    Load oLocalForm
    
    'Display the form
    With oLocalForm
        'Set properties
        .ArchiveLabel = sArchiveLabel
        .TemplateLabel = sTemplateLabel
        .BatchLabel = sBatchLabel
        
        'Show form
        .Show vbModal, oParentForm
    End With
    
    'Cleanup
    Unload oLocalForm
    Set oLocalForm = Nothing
    
End Sub

Public Function UCaseKeyPress(ByVal nKeyAscii As Integer) As Integer
    
    UCaseKeyPress = Asc(UCase(Chr(nKeyAscii)))
    
End Function


    
Public Sub SelectAllText(ctrControl As Control)

    ctrControl.SelStart = 0
    ctrControl.SelLength = Len(ctrControl.Text)
    
End Sub




'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetAppVersion
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   08-31-2000
'\\
'\\ Description:    This routine will a formated string for the
'\\                 application version number.
'\\
'\\ Parameters:
'\\     Name                Type        Description
'\\     bIncludeBuildNo     Boolean     Specifies whether or not to
'\\                                     include the build number in
'\\                                     the version string.
'\\                                     Defaults to TRUE.
'\\
'\\ Required References:
'\\     None
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function GetAppVersion(Optional ByVal bIncludeBuildNo As Boolean = True) As String
    
    GetAppVersion = "v" & App.Major & "." & Format(App.Minor, "00") & IIf(bIncludeBuildNo, "." & Format(App.Revision, "0000"), "")
    
End Function


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   GetCommandLineParameter
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine will parse out the command line and
'\\                 return the value of the specified command line
'\\                 parameter.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\     sParamID    String      The parameter to be returned.
'\\     sParanVal   String      The variable to return the specified
'\\                             parameter's value in.
'\\
'\\ Return Value:
'\\     Type        Description
'\\     Boolean     TRUE  - If specified parameter is found.
'\\                 FALSE - If specified parameter is not found.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Function GetCommandLineParameter(ByVal sParamID As String, _
                                        sParamVal As String) As Boolean
    
    Dim sCommand As String
    Dim nLoc1 As Integer
    Dim nLoc2 As Integer
    
    'Get the command line
    sCommand = UCase(Trim(Command$))
    sParamID = UCase(sParamID)
    
    'Find this parameter
    nLoc1 = InStr(sCommand, sParamID)
    If nLoc1 = 0 Then
        GetCommandLineParameter = False
        sParamVal = ""
        Exit Function
    End If
    
    'Determine where the end of this parameter is
    nLoc1 = nLoc1 + Len(sParamID)
    nLoc2 = InStr(nLoc1, sCommand, " ")
    If nLoc2 = 0 Then
        nLoc2 = Len(sCommand) + 1
    End If
    
    'Extract the parameter value
    sParamVal = Mid(sCommand, nLoc1, nLoc2 - nLoc1)
    GetCommandLineParameter = True
    
End Function



Public Sub Main()
    
    Dim sTemp As String
    
    'Initialize the registry settings
    InitRegistry
    
    'Connect to the database
    Set goConn = New ADODB.Connection
    '** Modified 03-07-02 JJF
    'goConn.ConnectionString = goRegDatabaseConnect.Value
    goConn.ConnectionString = goRegMainDBConnString.Value
    '** End of modification 03-07-02 JJF
    
    goConn.CommandTimeout = 0
    goConn.Open
    
    'Show the main form
    frmMain.Show
    
End Sub


