Attribute VB_Name = "modVisData"
'-----------------------------------------------------------------
' Copyright © National Research Corporation
'
' Required References:
'       Microsoft ActiveX Data Objects 2.5 Library
'       Microsoft DAO 3.5 Object Library
'       Microsoft Visual Basic Extensibility
'       QualiSysFunctions
'       Getempid.dll
'       StudySelector
'
' Revisions:
'   Date        By  Description
'   10-01-2002  FG  Renamed QualProFunctions to QualiSysFunctions.
'   10-04-2002  SH  Recompiled with VB6.0
'   12-23-2002  FG  Added code to SET IDENTITY_INSERT to ON in
'                   frmDataGrid when adding new row.
'   01-12-2003  SH  Added QualiSysSecurity.
'   05-12-2005  SH  Added code to disallow dialed in users from
'                   seeing study tables.
'                   Added code to call the stored procedure
'                   DTM_SyncSystemTables to syncronize the system tables
'                   (esp metafields) when exit the application.
'-----------------------------------------------------------------

'------------------------------------------------------------
' VISDATA.BAS
' support functions for the Visual Data sample application
'
' General Information: This app is intended to demonstrate
'   and exercise all of the functionality available in the
'   DAO (Data Access Objects) in Visual Basic 5.0.
'
'------------------------------------------------------------
Option Explicit

Const MSG1 = "Execute Commit or Rollback First."
Const MSG2 = "Closing Recordsets"
Const MSG3 = "Table already exists, delete it?"
Const MSG4 = "Enter New Table Name:"
Const MSG5 = "Ready"
Const MSG6 = ", please wait..."
Const MSG7 = "Refreshing Table List"
Const MSG8 = "Number: "
Const MSG9 = "Display the Data Access Errors Collection?"
Const MSG10 = "Can't Open a Table Object on an Attached Table, Use Dynaset?"
Const MSG11 = "Opening Attached Table as Dynaset"
Const MSG12 = "Opening Attached Table as Snapshot"
Const MSG13 = "Opening Full Table"
Const MSG14 = "Opening Single Table Dynaset"
Const MSG15 = "Opening Single Table Snapshot"
Const MSG16 = "Opening PassThru Snapshot"
Const MSG17 = "Is this a SQLPassThrough Query?"
Const MSG18 = "Enter Connect property value:"
Const MSG19 = "Can't Open a Table Object from a QueryDef, Use Dynaset?"
Const MSG20 = "Opening Query Snapshot"
Const MSG21 = "Opening Query Dynaset"
Const MSG22 = "SQL Statement"
Const MSG23 = "Execute "
Const MSG24 = " Query?"
Const MSG25 = "Executing Query"
Const MSG26 = "  [Not Updatable]"
Const MSG27 = "Table already exists, Delete it?"
Const MSG28 = "QueryDef already exists, Delete it?"
Const MSG29 = "Enter Value for Parameter:"
Const MSG30 = "There are no current data access errors!"
Const MSG31 = "Can't show Errors at this time!"
Const MSG32 = "Data has been changed, Commit it?"
Const MSG33 = "RollBack All changes?"
Const MSG34 = "Can't Close with Transactions Pending!"
Const MSG35 = "You must Close First!"
Const MSG36 = "Open Microsoft Access Database"
Const MSG37 = "Open Dbase Database"
Const MSG38 = "Open FoxPro Database"
Const MSG39 = "Open Paradox Database"
Const MSG40 = "Open Excel File"
Const MSG41 = "Open Btrieve Database"
Const MSG42 = "Open Text Database"
Const MSG43 = "Opening Database"
Const MSG44 = ""
Const MSG45 = "Repairing "
Const MSG46 = "Attempt to Repair it?"
Const MSG47 = "Enter Directory Name for New ISAM Database:"
Const MSG48 = "Select Microsoft Access Database to Compact"
Const MSG49 = "Microsoft Access MDBs (*.mdb)|*.mdb"
Const MSG50 = "|All Files (*.*)|*.*"
Const MSG51 = "Select Microsoft Access Database to Compact to"
Const MSG52 = "Encrypt Compacted Database?"
Const MSG53 = "Compacting "
Const MSG54 = "Open Newly Compacted Database?"
Const MSG55 = "Select Microsoft Access Database to Create"
Const MSG56 = "Exporting Table: "
Const MSG57 = "Export "
Const MSG58 = "in "
Const MSG59 = "Creating Indexes:"
Const MSG60 = "Successfully Exported:"
Const MSG61 = "Successfully Exported SQL Statement."
Const MSG62 = "Table already exists - overwrite?"
Const MSG63 = "Importing Table: "
Const MSG64 = "Successfully Imported:"
Const MSG65 = "Invalid Directory Name!"

'api declarations
Declare Function OSGetPrivateProfileString% Lib "Kernel32" Alias "GetPrivateProfileStringA" (ByVal AppName$, ByVal KeyName$, ByVal keydefault$, ByVal ReturnString$, ByVal NumBytes As Integer, ByVal FileName$)
Declare Function OSWritePrivateProfileString% Lib "Kernel32" Alias "WritePrivateProfileStringA" (ByVal AppName$, ByVal KeyName$, ByVal keydefault$, ByVal FileName$)
Declare Function OSWinHelp% Lib "user32" Alias "WinHelpA" (ByVal hwnd&, ByVal HelpFile$, ByVal wCommand%, dwData As Any)
Declare Function SQLAllocEnv% Lib "ODBC32.DLL" (env&)
Declare Function SQLDataSources% Lib "ODBC32.DLL" (ByVal henv&, ByVal fdir%, ByVal szDSN$, ByVal cbDSNMax%, pcbDSN%, ByVal szDesc$, ByVal cbDescMax%, pcbDesc%)
Declare Function SetWindowLong& Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long)
Declare Function GetDesktopWindow Lib "user32" () As Long

'global object variables
Global gVDClass      As New VisDataClass
Global gnodDBNode    As Node        'current database node in treeview
Global gnodDBNode2   As Node        'backup of current database node in treeview
Global gwsMainWS     As Workspace   'main workspace object
Global gdbMainDB     As Database    'main database/connection object
Global gcnMainCN     As Connection  'main connection/database object
'Public gwsCurrentWS  As Workspace   'Added for QualPRO
' DV 8/17/99 - We will use the Workspace databases collection instead.
'Global gdbCurrentDB  As Database    'main database object
Global gbDBOpenFlag  As Integer     'flag to know if a db is open
Global gPropObject   As Object      'object to show properties on
Global gDataCtlObj   As Object      'global data control object
Global gtdfTableDef  As TableDef    'global tabledef used by frmTblStruct
Global gnFormType    As Integer     'form type chosen on main form
                                    '0 = data control
                                    '1 = no data control
                                    '2 = grid control
Global gnRSType      As Integer     'recordset type chosen on main form
                                    '0 = table
                                    '1 = dynaset
                                    '2 = snapshot

'global database variables
Global gsDataType       As String   'data backend = connect string
                                    'for everything accept Access
Global gsDBName         As String   'current database name
Global gsODBCDatasource As String   'global odbc values
Global gsODBCDatabase   As String   '       "
Global gsODBCUserName   As String   '       "
Global gsODBCPassword   As String   '       "
Global gsODBCDriver     As String   '       "
Global gsODBCServer     As String   '       "
Global gsTblName        As String   '
Global glQueryTimeout   As Long     '
Global glLoginTimeout   As Long     '
Global gsTableDynaFilter As String  '
Global gnReadOnly       As Integer  'database readonly flag

'other global vars
Global gsZoomData       As String   'pass info to the zoom form

'multi user variables
Global gnMURetryCnt     As Integer
Global gnMUDelay        As Integer
Global gnMULocking      As Integer  'flag for pessimistic or optimistic locking

'global find values used to pass info between
'the dynaset form and find dialog
Global gbFindFailed     As Boolean
Global gsFindExpr       As String
Global gsFindOp         As String
Global gsFindField      As String
Global gnFindType       As Integer
Global gbFromTableView  As Boolean

'global seek values used to pass info between
'the table form and find dialog
Global gsSeekOperator   As String
Global gsSeekValue      As String

'global flags
Global gbDBChanged      As Boolean   '
Global gbTransPending   As Boolean   'used for transaction management
Global gbFromSQL        As Boolean   'source of sql statement was SQL form
Global gbAddTableFlag   As Boolean   'new or design designator
Global gbSettingDataCtl As Boolean   'used to reset data control props

'global vars used in the Import Export Code
Global gnDataType As Integer
Global gImpDB As Database
Global gExpDB As Database
Global gExpTable As String

'data backend types used as the connect string
Global Const gsMSACCESS = "Microsoft Access"
Global Const gsDBASEIII = "Dbase III;"
Global Const gsDBASEIV = "Dbase IV;"
Global Const gsDBASE5 = "Dbase 5.0;"
Global Const gsFOXPRO20 = "FoxPro 2.0;"
Global Const gsFOXPRO25 = "FoxPro 2.5;"
Global Const gsFOXPRO26 = "FoxPro 2.6;"
Global Const gsFOXPRO30 = "FoxPro 3.0;"
Global Const gsPARADOX3X = "Paradox 3.X;"
Global Const gsPARADOX4X = "Paradox 4.X;"
Global Const gsPARADOX5X = "Paradox 5.X;"
Global Const gsBTRIEVE = "Btrieve;"
Global Const gsEXCEL30 = "Excel 3.0;"
Global Const gsEXCEL40 = "Excel 4.0;"
Global Const gsEXCEL50 = "Excel 5.0;"
Global Const gsTEXTFILES = "Text;"
Global Const gsSQLDB = "ODBC;"

'import/export data types
Global Const gnDT_NONE = -1
Global Const gnDT_MSACCESS = 0
Global Const gnDT_DBASEIV = 1
Global Const gnDT_DBASEIII = 2
Global Const gnDT_FOXPRO26 = 3
Global Const gnDT_FOXPRO25 = 4
Global Const gnDT_FOXPRO20 = 5
Global Const gnDT_PARADOX4X = 6
Global Const gnDT_PARADOX3X = 7
Global Const gnDT_BTRIEVE = 8
Global Const gnDT_EXCEL50 = 9
Global Const gnDT_EXCEL40 = 10
Global Const gnDT_EXCEL30 = 11
Global Const gnDT_TEXTFILE = 12
Global Const gnDT_SQLDB = 13

'global constants
Global Const gsDEFAULT_DRIVER = "SQL Server"  'used for registerdatabase
Global Const gnEOF_ERR = 626                  '
Global Const gnFTBLS = 0                      '
Global Const gnFFLDS = 1                      '
Global Const gnFINDX = 2                      '
Global Const gnMAX_GRID_ROWS = 31999          '
Global Const gnMAX_MEMO_SIZE = 20000          '
Global Const gnGETCHUNK_CUTOFF = 50           '

Global Const gnFORM_DATACTL = 0               '
Global Const gnFORM_NODATACTL = 1             '
Global Const gnFORM_DATAGRID = 2              '

Global Const gnRS_TABLE = vbRSTypeTable
Global Const gnRS_DYNASET = vbRSTypeDynaset
Global Const gnRS_SNAPSHOT = vbRSTypeSnapShot
Global Const gnRS_PASSTHRU = 8

Global Const gnCTLARRAYHEIGHT = 340&          '
Global Const gnSCREEN = 0                     'used to center forms on screen
Global Const gnMDIFORM = 1                    'used to center forms on frmMDI

Global Const TABLE_STR = "Table"
Global Const ATTACHED_STR = "Attached"
Global Const QUERY_STR = "Query"
Global Const FIELD_STR = "Field"
Global Const FIELDS_STR = "Fields"
Global Const INDEX_STR = "Index"
Global Const INDEXES_STR = "Indexes"
Global Const PROPERTY_STR = "Property"
Global Const PROPERTIES_STR = "Properties"

Global Const APP_CATEGORY = "Microsoft Visual Basic AddIns"

Public glngStudy_Id         As Long
Public glngTypeTables       As Long
Public employeeID As Integer ' 05-12-2005 SH Added

' Table Types to Edit
Public Const SYSTEM_TABLES = 1
Public Const STUDY_TABLES = 2

Public gCN      As New ADODB.Connection ' 05-12-2005 SH Modified
Public gRS      As ADODB.Recordset
Public gCmd     As New ADODB.Command ' 05-12-2005 SH Modified

'Public Const MAX_WS_OBJECTS = 30
' 8/16/99 DV
' Only will have one Jet-based Workspace available.
Public Const MAX_WS_OBJECTS = 1

' Changed to use an array of workspace objects instead
' of 30 variables.
Public gwsStudyWS_X(MAX_WS_OBJECTS + 1) As Workspace
Public gdbStudyDB_X(MAX_WS_OBJECTS + 1) As Database
Public gcnStudyCN_X(MAX_WS_OBJECTS + 1) As Connection
' Changed to use the workspace's database collection.
'Public gdbCurrentDB_X(MAX_WS_OBJECTS + 1) As Database

Public gwsActiveWS        As Workspace
Public gdbActiveDB        As Database
Public gcnActiveCN        As Connection

Public frmActiveFrm         As Form
Public glngNumOpens         As Long

' Server and Database Variables
' to be read in from DSN on MTS
Public gstrServer               As String
Public gstrDatabase             As String
Public gstrSAUser               As String
Public gstrSAPWD                As String
Public gstrDSNDRVName           As String

Function SetWSDB(xlngNumOpens As Long, xstrUID As String, xstrPWD As String)
    ' Select Unique Workspace and database for this STUDY
    ' This module is very redundant, however, many problems
    ' were experienced when the ojbect indirection increased
    ' SO GOOD LUCK IF YOU DECIDE TO TRY TO PASS MORE
    ' DATABASE OBJECT PARMS AROUND
    
    Dim frmTmp                  As Form
    
    SetWSDB = False
    
    If xlngNumOpens > MAX_WS_OBJECTS Then Exit Function

    ' Currently password is zero length string
    ' this is set in the Configuration Manager
    ' when the study tables are created.
    'pstrQualProPWD = ""
    '
    ' 1 - Manipulate the MDI Form menu and toolbar
    ' 2 - Spawn a new database form
    ' 3 - Set the Study ID and the Type Data object to
    '     create.
    ShowDBTools
    
    Set frmTmp = New frmDatabase
    
    frmTmp.Study_ID = glngStudy_Id
    frmTmp.TypeTables = glngTypeTables
    
    ' 8/16/99 DV
    ' Use an array to hold the global stuff instead of
    ' using 30 individual variables.
    If xlngNumOpens <= MAX_WS_OBJECTS Then
        SetTempWS gwsStudyWS_X(xlngNumOpens), gdbStudyDB_X(xlngNumOpens), gcnStudyCN_X(xlngNumOpens), xstrUID, xstrPWD, False, gstrServer, gstrDatabase
        'SetTempDB gwsStudyWS_X(xlngNumOpens), gwsStudyWS_X(xlngNumOpens).Databases(0), xstrUID, xstrPWD, gstrServer, gstrDatabase
        Set gwsActiveWS = gwsStudyWS_X(xlngNumOpens)
        If Not RefreshTables(Nothing, frmTmp) Then Exit Function
    End If
    
    ' Manipulate the Edit and System Menu Selections
    If gwsActiveWS.Databases(0) Is Nothing Then
        Unload frmTmp
        frmMDI.mnuEditStudy.Enabled = True
        frmMDI.mnuEditSystem.Enabled = True
        frmMDI.mnuDBClose.Enabled = False
    Else
        SetWSDB = True
        frmMDI.mnuEditStudy.Enabled = False
        frmMDI.mnuEditSystem.Enabled = False
        frmMDI.mnuDBClose.Enabled = True
    End If
End Function

Public Sub SetTempDB(xWSP As Workspace, xDB As Database, xCN As Connection, xstrUID As String, xstrPWD As String, xstrServer As String, xstrDatabase As String)
    Dim pstrQualProConnect    As String
    Dim pstrMsg               As String
    Dim objdatabase As Database
    Dim objconnection As Connection
    
    On Error GoTo SetTempDBError
    
    If xWSP Is Nothing Then Exit Sub
        
    ' The hardcoded values will be replaced
    ' with variables which will be populated
    ' by reading values from the DSNs on
    ' the MTS machine.
    pstrQualProConnect = "ODBC;Driver=" & gstrDSNDRVName & ";"
    pstrQualProConnect = pstrQualProConnect & "Server=" & xstrServer & ";"
    
    'pstrQualProConnect = pstrQualProConnect & "UID=" & xstrUID & ";"
    'pstrQualProConnect = pstrQualProConnect & "PWD=" & xstrPWD & ";"
    pstrQualProConnect = pstrQualProConnect & "UID=qpsa;"   '01-26-2010 JJF - SQL 2008 Fix
    pstrQualProConnect = pstrQualProConnect & "PWD=qpsa;"   '01-26-2010 JJF - SQL 2008 Fix
    
    pstrQualProConnect = pstrQualProConnect & "Database=" & xstrDatabase & ";"
    
    ' 8/18/99 DV
    ' We will open two types of connections.
    If xWSP.Type = dbUseODBC Then
        xWSP.DefaultCursorDriver = dbUseClientBatchCursor
        Set xCN = xWSP.OpenConnection("", dbDriverComplete + dbDriverNoPrompt, False, pstrQualProConnect)
    End If
    
    Set xDB = xWSP.OpenDatabase("", dbDriverComplete + dbDriverNoPrompt, False, pstrQualProConnect)
        
    GoTo SetTempDBExit
    
SetTempDBError:
    pstrMsg = "Error:" & Errors(0).Number & vbCrLf
    pstrMsg = pstrMsg & "Error Text: " & Errors(0).Description & vbCrLf
    pstrMsg = pstrMsg & "Error Opening Database to retrieve Table Membership." & vbCrLf & vbCrLf
    pstrMsg = pstrMsg & "Error Module: SetTempDB" & vbCrLf
    MsgBox pstrMsg
    Resume SetTempDBExit
    
SetTempDBExit:
End Sub

Public Sub SetTempADODB(xDB As Database, xstrUID As String, xstrPWD As String, xstrServer As String, xstrDatabase As String)
    Dim pstrQualProConnect    As String
    Dim pstrMsg               As String
    
    On Error GoTo SetTempADODBError
    
    'If xDB Is Nothing Then Exit Sub
    
    ' The hardcoded values will be replaced
    ' with variables which will be populated
    ' by reading values from the DSNs on
    ' the MTS machine.
    pstrQualProConnect = "ODBC;Driver=" & gstrDSNDRVName & ";"
    pstrQualProConnect = pstrQualProConnect & "Server=" & xstrServer & ";"
    
    pstrQualProConnect = pstrQualProConnect & "UID=" & xstrUID & ";"
    pstrQualProConnect = pstrQualProConnect & "PWD=" & xstrPWD & ";"
    
    pstrQualProConnect = pstrQualProConnect & "Database=" & xstrDatabase & ";"
    
    gCN.Open pstrQualProConnect

    GoTo SetTempADODBExit

SetTempADODBError:
    pstrMsg = "Error:" & Errors(0).Number & vbCrLf
    pstrMsg = pstrMsg & "Error Text: " & Errors(0).Description & vbCrLf
    pstrMsg = pstrMsg & "Error Opening Database to retrieve Table Membership." & vbCrLf & vbCrLf
    pstrMsg = pstrMsg & "Error Module: SetTempADODB" & vbCrLf
    MsgBox pstrMsg
    Resume SetTempADODBExit

SetTempADODBExit:
End Sub

Public Sub SetTempWS(xWSP As Workspace, xDB As Database, xCN As Connection, xstrUID As String, xstrPWD As String, xbolUseODBC As Boolean, xstrServer As String, xstrDatabase As String)
    'DDim pstrQualProConnect    As String
    Dim pstrMsg               As String
    
    On Error GoTo SetTempWSError

    ' DV 8/17/99
    ' We do not need the connection string here.
    'D' ----------------------------------
    'D' The hardcoded values will be replaced
    'D' with variables which will be populated
    'D' by reading values from the DSNs on
    'D' the MTS machine.
    'D' ----------------------------------
    'D  pstrQualProConnect = "ODBC;Driver=" & gstrDSNDRVName & ";"
    'D  pstrQualProConnect = pstrQualProConnect & "Server=" & xstrServer & ";"
    'D
    'D  pstrQualProConnect = pstrQualProConnect & "UID=" & xstrUID & ";"
    'D pstrQualProConnect = pstrQualProConnect & "PWD=" & xstrPWD & ";"
    'D
    'D  pstrQualProConnect = pstrQualProConnect & "Database=" & xstrDatabase & ";"
    
    ' Changed the FALSE of xbolUseODBC to use ODBC, but to use the
    ' the study_id as the workspace name.  This will cause problems
    ' with pulling the database info.  We will change the appropriate
    ' functions to handle the change.
  
    If xbolUseODBC Then
        Set xWSP = DBEngine.CreateWorkspace("QualProWS", xstrUID, xstrPWD, dbUseODBC)
    Else
        Set xWSP = DBEngine.CreateWorkspace(glngStudy_Id, xstrUID, xstrPWD, dbUseODBC)
        'Set xWSP = DBEngine.CreateWorkspace(xstrUID, xstrPWD, vbNullString)
    End If

    ' Call to create the database/connection objects
    SetTempDB xWSP, xDB, xCN, xstrUID, xstrPWD, xstrServer, xstrDatabase
  
    GoTo SetTempWSExit

SetTempWSError:
    pstrMsg = "Error:" & Errors(0).Number & vbCrLf
    pstrMsg = pstrMsg & "Error Text: " & Errors(0).Description & vbCrLf
    pstrMsg = pstrMsg & "Error Setting up workspace." & vbCrLf & vbCrLf
    pstrMsg = pstrMsg & "Error Module: SetTempWS" & vbCrLf
    MsgBox pstrMsg
    Resume SetTempWSExit

SetTempWSExit:
End Sub

Sub Main()
    Dim blnOkForSystem As Boolean
    Dim blnOkForStudy As Boolean
    Dim objQualProFunctions As QualiSysFunctions.Library
    Dim strDSN As String
    Dim OKForCountry As Boolean ' 05-12-2005 SH Added
    
    OKForCountry = False ' 05-12-2005 SH Added
    
    'D DV 8/13/99 - We do not hard-code user ids and password anymore!
    'D'Dim objQualProDSNInfo As GetDSNInfoDLL.GetDSNInfo
    'D'
    'D'Set objQualProDSNInfo = CreateObject("GetDSNInfoDLL.GetDSNInfo")
    'D'
    'D'If objQualProDSNInfo.GetDSNInfo(gstrSAUser, gstrSAPWD, gstrDSNDRVName, gstrDatabase, gstrServer) Then
    'D'Else
    'D'    MsgBox "Could not Retrieve Database Location Information" & vbCrLf
    'D'    Exit Sub
    'D'End If
    'D'
    'D'Set objQualProDSNInfo = Nothing
    'D
    'D'-------------------------------------------------------------------------------------------------------------------------------
    'D'- Greg Bogard this is where the DSN Info is Hard Coded
    'D'- 05171999
    'D'-------------------------------------------------------------------------------------------------------------------------------
    'D'gstrSAUser = "sa"
    'D'gstrSAPWD = "newsapwd"
    'D'gstrDSNDRVName = "SQL Server"
    'D'gstrDatabase = "qp_dev"
    'D'gstrServer = "capsql"
    'D'-------------------------------------------------------------------------------------------------------------------------------
    'DgstrSAUser = "sa"
    'DgstrSAPWD = ""
    'DgstrDSNDRVName = "SQL Server"
    'DgstrDatabase = "qp_conv"
    'DgstrServer = "nrc10"
    'D'-------------------------------------------------------------------------------------------------------------------------------
    'D'gstrSAUser = "qualpro"
    'D'gstrSAPWD = "newqppwd"
    'D'gstrDSNDRVName = "SQL Server"
    'D'gstrDatabase = "qp_TEST"
    'D'gstrServer = "CAPSQL"
    'D'gstrSAUser = "qualpro"
    'D'gstrSAPWD = "qualpro"
    'D'gstrDSNDRVName = "SQL Server"
    'D'gstrDatabase = "qp_test1"
    'D'gstrServer = "nrc10"
    'D'-------------------------------------------------------------------------------------------------------------------------------
    'I DV 8/13/99 - Added call to MTS component to get database login info.
    
    Set objQualProFunctions = CreateObject("QualiSysFunctions.Library")
    strDSN = objQualProFunctions.GetDBString(False)
    GetODBCConnectParts (strDSN)
    gstrSAUser = gsODBCUserName
    gstrSAPWD = gsODBCPassword
    gstrDSNDRVName = gsODBCDriver
    gstrDatabase = gsODBCDatabase
    gstrServer = gsODBCServer
    
    ' *** 05-12-2005 SH Added
    With gCN
        .ConnectionTimeout = 0
        .Open strDSN
        .CommandTimeout = 0
    End With
    ' *** End of addition
    
    ' 12-20-2002 SH
    ' Check if the user has access to the System Table.
    Dim pGetEmpObj As New getEmpId.GetEmpIdDll
    'Dim intEmployeeId As Integer ' 05-12-2005 SH Deleted
    
    ' *** 05-12-2005 Added
    With pGetEmpObj
        If .RetrieveUserEmployeeID Then
            employeeID = .UserEmployeeID
            If .EnvCountryID = .UserCountryID Then OKForCountry = True
            
            Dim anObject As New QualiSysFunctions.checkAccess
                            
            ' Add OKForCountry so Canada can't see the study
            ' table if they try to dial in from Canada to US
            ' and vice versa.
            If anObject.IsUserInModules(employeeID, "Study_Table_Mgr") _
                And OKForCountry Then
                blnOkForStudy = True
            End If
        
            If anObject.IsUserInModules(employeeID, "System_Table_Mgr") Then
                blnOkForSystem = True
            End If
        
            Set anObject = Nothing
        End If
    End With
    ' *** End of addition
    
' *** 05-12-2005 Deleted
'    If pGetEmpObj.RetrieveUserEmployeeID() Then
'        intEmployeeId = pGetEmpObj.UserEmployeeID
'
'        Dim anObject As New QualiSysFunctions.checkAccess
'
'        If anObject.IsUserInModules(intEmployeeId, "Study_Table_Mgr") Then
'            blnOkForStudy = True
'        End If
'
'        If anObject.IsUserInModules(intEmployeeId, "System_Table_Mgr") Then
'            blnOkForSystem = True
'        End If
'
'        Set anObject = Nothing
'    End If
' *** End of deletion

    Set pGetEmpObj = Nothing
    
    If blnOkForStudy And blnOkForSystem Then
        frmMDI.mnuEditSystem.Enabled = True
        frmMDI.mnuEditSystem.Visible = True
        frmMDI.mnuEditStudy.Enabled = True
        frmMDI.mnuEditStudy.Visible = True
        frmMDI.Show
    End If

    If blnOkForStudy And Not blnOkForSystem Then
        frmMDI.mnuEditSystem.Enabled = False
        frmMDI.mnuEditSystem.Visible = False
        frmMDI.mnuEditStudy.Enabled = True
        frmMDI.mnuEditStudy.Visible = True
        frmMDI.Show
    End If

    If Not blnOkForStudy And blnOkForSystem Then
        frmMDI.mnuEditSystem.Enabled = True
        frmMDI.mnuEditSystem.Visible = True
        frmMDI.mnuEditStudy.Enabled = False
        frmMDI.mnuEditStudy.Visible = False
        frmMDI.Show
    End If
    
    If Not blnOkForStudy And Not blnOkForSystem Then
        MsgBox "Security violation.  Please see QualiSys System Administrator for access to this module (Data Table Manager).", vbInformation, "Access Denied"
        End
    End If
    
    glngNumOpens = 0
End Sub

Function ActionQueryType(qdf As QueryDef) As String
    '------------------------------------------------------------
    'this function returns the type of querydef
    'for the item selected in the querydefs
    'list on the frmTables form
    '------------------------------------------------------------
  
    'check to see if it is an action query
    If (qdf.Type And dbQAction) = 0 Then
        ActionQueryType = vbNullString
        Exit Function
    End If
    
    'must be an action query type
    Select Case qdf.Type
        Case dbQCrosstab
            ActionQueryType = "Cross Tab"
        Case dbQDelete
            ActionQueryType = "Delete"
        Case dbQUpdate
            ActionQueryType = "Update"
        Case dbQAppend
            ActionQueryType = "Append"
        Case dbQMakeTable
            ActionQueryType = "Make Table"
        Case dbQDDL
            ActionQueryType = "DDL"
        Case dbQSQLPassThrough
            ActionQueryType = "SQLPassThrough"
        Case dbQSetOperation
            ActionQueryType = "Set Operation"
        Case dbQSPTBulk
            ActionQueryType = "SPT Bulk"
        Case Else
            ActionQueryType = vbNullString
    End Select

End Function

Function AddBrackets(rObjName As String) As String
    
    '------------------------------------------------------------
    'this functions adds [] to object names that might need
    'them because they have spaces in them
    '------------------------------------------------------------
    
    'add brackets to object names w/ spaces in them
    If InStr(rObjName, " ") > 0 And Mid(rObjName, 1, 1) <> "[" Then
        AddBrackets = "[" & rObjName & "]"
    Else
        AddBrackets = rObjName
    End If

End Function

Function CheckTransPending(MSG As String) As Integer

    '------------------------------------------------------------
    'this function checks to see if a transaction is pending
    'and displays a message is one is
    '------------------------------------------------------------

    If gbTransPending Then
        MsgBox MSG & vbCrLf & MSG1, 48
        CheckTransPending = True
    Else
        CheckTransPending = False
    End If

End Function

Sub ClearDataFields(frm As Form, nCnt As Integer)
  
    '------------------------------------------------------------
    'clear out the data fields on the table and dynasnap forms
    '------------------------------------------------------------
  
    Dim i As Integer
    
    'clear out the fields on the main form
    For i = 0 To nCnt - 1
        frm.txtFieldData(i).Text = vbNullString
    Next

End Sub

Sub CloseAllRecordsets()

    '------------------------------------------------------------
    'this sub closes all frmDynaSnap, frmTableObj and frmDataGrid
    'forms by looking for forms with a Tag set to "Recordset"
    '------------------------------------------------------------

    Dim i As Integer
    
    MsgBar MSG2, True
    While i < Forms.Count
        If Forms(i).Tag = "Recordset" Then
            Unload Forms(i)
        Else
            i = i + 1
        End If
    Wend
    MsgBar vbNullString, False

End Sub

Function CopyData(rFromWS As Workspace, rToWS As Workspace, rFromName As String, rToName As String) As Integer
  
    '------------------------------------------------------------
    'this function copies data from one table to another
    'from the frmCopyStruct form
    'It demonstrates the use of transactions to speed up this
    'type of operation
    '------------------------------------------------------------
  
    On Error GoTo CopyErr
    
    Dim recRecordset1 As Recordset, recRecordset2 As Recordset
    Dim i As Integer
    Dim nRC As Integer
    Dim fld As Field
    
    'open both recordsets
    If rFromWS.Type = dbUseODBC Then
        Set recRecordset1 = rFromWS.Connections(0).OpenRecordset(rFromName)
    Else
        Set recRecordset1 = rFromWS.Databases(0).OpenRecordset(rFromName)
    End If
    If rToWS.Type = dbUseODBC Then
        Set recRecordset2 = rToWS.Connections(0).OpenRecordset(rToName)
    Else
        Set recRecordset2 = rToWS.Databases(0).OpenRecordset(rToName)
    End If
    
    gwsMainWS.BeginTrans
    While recRecordset1.EOF = False
        recRecordset2.AddNew
        ' this loop copies the data from each field to
        ' the new table
        'For Each fld In recRecordset1.Fields
        For i = 0 To recRecordset1.Fields.Count - 1
            Set fld = recRecordset1.Fields(i)
            recRecordset2(fld.Name).Value = fld.Value
        Next
        recRecordset2.Update
        recRecordset1.MoveNext
        nRC = nRC + 1
        'this test will commit transactions every 1000 records
        If nRC = 1000 Then
            gwsMainWS.CommitTrans
            gwsMainWS.BeginTrans
            nRC = 0
        End If
    Wend
    gwsMainWS.CommitTrans
    
    CopyData = True
    
    Exit Function

CopyErr:
    gwsMainWS.Rollback
    ShowError
    CopyData = False

End Function

Function CopyStruct(vFromDB As Database, vToDB As Database, vFromName As String, vToName As String, bCreateIndex As Integer) As Integer
  
    '------------------------------------------------------------
    'this function copies the structure of one table to
    'a new table in the same or different database
    '------------------------------------------------------------
  
    On Error GoTo CSErr
    
    Dim i As Integer
    Dim tblTableDefObj As TableDef
    Dim fldFieldObj As Field
    Dim indIndexObj As Index
    Dim tdf As TableDef
    Dim fld As Field
    Dim idx As Index
  
    'search to see if table exists
NameSearch:
    '  For Each tdf In vToDB.Tabledefs
    For i = 0 To vToDB.TableDefs.Count - 1
        Set tdf = vToDB.TableDefs(i)
        If UCase(tdf.Name) = UCase(vToName) Then
            If MsgBox(MSG3, 4) = vbYes Then
                vToDB.TableDefs.Delete tdf.Name
            Else
                vToName = InputBox(MSG4)
                If Len(vToName) = 0 Then
                    Exit Function
                Else
                    GoTo NameSearch
                End If
            End If
          Exit For
        End If
    Next
  
    Set tblTableDefObj = gwsMainWS.Databases(0).CreateTableDef()
    
    ' strip off owner if needed
    tblTableDefObj.Name = StripOwner(vToName)

    ' create the fields
    'For Each fld In vFromDB.Tabledefs(vFromName).Fields
    For i = 0 To vFromDB.TableDefs(vFromName).Fields.Count - 1
        Set fld = vFromDB.TableDefs(vFromName).Fields(i)
        Set fldFieldObj = vFromDB.TableDefs(vFromName).CreateField(fld.Name, fld.Type, fld.Size)
        tblTableDefObj.Fields.Append fldFieldObj
    Next

    ' create the indexes
    If bCreateIndex <> False Then
        'For Each idx In vFromDB.Tabledefs(vFromName).Indexes
        For i = 0 To vFromDB.TableDefs(vFromName).Indexes.Count - 1
            Set idx = vFromDB.TableDefs(vFromName).Indexes(i)
            Set indIndexObj = vFromDB.TableDefs(vFromName).CreateIndex(idx.Name)
            With indIndexObj
                indIndexObj.Fields = idx.Fields
                indIndexObj.Unique = idx.Unique
                If gsDataType <> gsSQLDB Then
                    indIndexObj.Primary = idx.Primary
                End If
            End With
            tblTableDefObj.Indexes.Append indIndexObj
        Next
    End If

    'append the new table
    vToDB.TableDefs.Append tblTableDefObj
    
    CopyStruct = True
    Exit Function

CSErr:
    ShowError
    CopyStruct = False

End Function

Sub GetTableList(rctl As Control, rbIncludeQDFs As Integer, rbIncludeSys As Integer, rbStripConnect As Integer)
  
    '------------------------------------------------------------
    'this function fills a list or combo box with the
    'tables (and querydefs) from the Tables form
    'ItemData is set to 0 for a tabledef and 1 for a querydef
    '------------------------------------------------------------
  
    On Error GoTo FTLErr
    
    Dim i As Integer
    Dim sTmp As String
    Dim tbl As TableDef
    Dim qdf As QueryDef
    
    ' add the tabledefs
    For Each tbl In gwsMainWS.Databases(0).TableDefs
        sTmp = tbl.Name
        If rbIncludeSys Then
            rctl.AddItem sTmp
            rctl.ItemData(rctl.NewIndex) = 0
        Else
            If (gwsMainWS.Databases(0).TableDefs(sTmp).Attributes And dbSystemObject) = 0 Then
                rctl.AddItem sTmp
                rctl.ItemData(rctl.NewIndex) = 0
            End If
        End If
    Next
  
    ' add the querydefs
    If rbIncludeQDFs Then
        If gwsMainWS.Type = dbUseODBC Then
            For Each qdf In gwsMainWS.Connections(0).QueryDefs
                rctl.AddItem qdf.Name
                rctl.ItemData(rctl.NewIndex) = 1
            Next
        Else
            For Each qdf In gwsMainWS.Databases(0).QueryDefs
                rctl.AddItem qdf.Name
                rctl.ItemData(rctl.NewIndex) = 1
            Next
        End If
    End If
  
    Exit Sub
  
FTLErr:
    ShowError
    
End Sub

Function GetFieldType(rFldType As String) As Integer
  
    '------------------------------------------------------------
    'this function returns the numeric field type
    'for the passed in string
    '------------------------------------------------------------
  
    ' return field length
    If rFldType = "Text" Then
        GetFieldType = dbText
    Else
        Select Case rFldType
            Case "Counter"
                GetFieldType = dbLong
            Case "Boolean"
                GetFieldType = dbBoolean
            Case "Byte"
                GetFieldType = dbByte
            Case "Integer"
                GetFieldType = dbInteger
            Case "Long"
                GetFieldType = dbLong
            Case "Currency"
                GetFieldType = dbCurrency
            Case "Single"
                GetFieldType = dbSingle
            Case "Double"
                GetFieldType = dbDouble
            Case "Date/Time"
                GetFieldType = dbDate
            Case "Binary"
                GetFieldType = dbLongBinary
            Case "Memo"
                GetFieldType = dbMemo
        End Select
    End If

End Function

Function GetFieldWidth(rType As Integer)
  
    '------------------------------------------------------------
    'this function returns an appropriate field width for the
    'field type passed in to be used for the control width on
    'frmDynaSnap and frmTableObj forms
    '------------------------------------------------------------
  
    Select Case rType
        Case dbBoolean
            GetFieldWidth = 850
        Case dbByte
            GetFieldWidth = 650
        Case dbInteger
            GetFieldWidth = 900
        Case dbLong
            GetFieldWidth = 1100
        Case dbCurrency
            GetFieldWidth = 1800
        Case dbSingle
            GetFieldWidth = 1800
        Case dbDouble
            GetFieldWidth = 2200
        Case dbDate
            GetFieldWidth = 2000
        Case dbText
            GetFieldWidth = 3250
        Case dbLongBinary
            GetFieldWidth = 3250
        Case dbMemo
            GetFieldWidth = 3250
        Case Else
            GetFieldWidth = 3250
    End Select

End Function

Function GetINIString(ByVal vsItem As String, ByVal vsDefault As String) As String
  
    '------------------------------------------------------------
    'this function returns the INI file setting for the
    'passed in item and section
    '------------------------------------------------------------
  
    GetINIString = GetSetting(APP_CATEGORY, App.Title, vsItem, vsDefault)

End Function

Sub HideDBTools()
  
    '------------------------------------------------------------
    'this sub hides the menus and toolbar that only apply
    'when a database is open
    '------------------------------------------------------------
  
    frmMDI.mnuDBClose.Enabled = False
    'frmMDI.mnuDBImpExp.Enabled = False
    frmMDI.mnuUtil.Enabled = False
    frmMDI.mnuUBar1.Visible = False
    'frmMDI.mnuUAttachments.Visible = False
    'frmMDI.mnuUGroupsUsers.Visible = False
    'frmMDI.mnuUSystemDB.Visible = False
    frmMDI.tlbToolBar.Buttons("BeginTrans").Enabled = False
    frmMDI.tlbToolBar.Buttons("Commit").Enabled = False
    frmMDI.tlbToolBar.Buttons("Rollback").Enabled = False

End Sub

Sub MsgBar(rsMsg As String, rPauseFlag As Integer)
  
    '------------------------------------------------------------
    'this sub displays the passed in message in the status
    'bar on the bottom of the MDI form
    '------------------------------------------------------------
  
    If Len(rsMsg) = 0 Then
        Screen.MousePointer = vbDefault
        frmMDI.stsStatusBar.Panels(1).Text = MSG5
    Else
        If rPauseFlag Then
            frmMDI.stsStatusBar.Panels(1).Text = rsMsg & MSG6
        Else
            frmMDI.stsStatusBar.Panels(1).Text = rsMsg
        End If
    End If
    
    frmMDI.stsStatusBar.Refresh

End Sub

Function ObjectExists(pColl As Object, sMemName As String) As Boolean

    '==================================================
    ' Routine: ObjectExists
    '
    ' Purpose: Determine whether or not a member exists
    '          same as MemberExists except that the 1st arg is declared
    '          as an object to allow passing in collections such as
    '          VBComponents, VBProjects, etc.
    ' Arguments:
    '   pColl: Name of Collection to check in
    '   sMemName: Name(key) of member to check for
    ' Outputs:
    '   True: member exists in collection
    '   False: member does not exist in the collection
    ' Maintenance: J$
    '==================================================

    Dim pObj As Object
  
    On Error Resume Next
    Err = 0
    Set pObj = pColl(sMemName)
    ObjectExists = (Err = 0)

End Function

Function RefreshTables(rListObject As Object, xFrm As Form) As Boolean

    '------------------------------------------------------------
    'this sub refreshs any table list passed in as an object
    '------------------------------------------------------------

    ',xCurrentDB As Database, xCurrentWS As Workspace
  
    On Error GoTo TRefErr
    
    Dim tdf As TableDef
    Dim qdf As QueryDef
    Dim sTmp As String
    Dim i As Integer
      
    MsgBar MSG7, True
    Screen.MousePointer = vbHourglass
    
    RefreshTables = False
    
    'if this is called to refresh the database
    'window, bypass the old method of
    'filling a listbox with the table names
    'D  If rListObject Is Nothing Then GoTo LoadTreeView
    'D
    'D  rListObject.Clear
    'D'  If frmMDI.mnuPAllowSys.Checked Then
    'D'    'list all tables
    'D'    For Each tdf In gwsmainws.databases(0).TableDefs
    'D'      If (tdf.Attributes And dbAttachedTable) = dbAttachedTable Then
    'D'        If Left(tdf.Connect, 1) = ";" Then
    'D'          'must be a Microsoft Access attached table
    'D'          rListObject.AddItem tdf.Name & " -> Microsoft Access"
    'D'        Else
    'D'          'must be an ISAM attached table
    'D'          rListObject.AddItem tdf.Name & " -> " & Left(tdf.Connect, InStr(tdf.Connect, ";") - 1)
    'D'        End If
    'D'      ElseIf (tdf.Attributes And dbAttachedODBC) = dbAttachedODBC Then
    'D'        rListObject.AddItem tdf.Name & " -> ODBC"
    'D'      Else
    'D'        rListObject.AddItem tdf.Name
    'D'      End If
    'D'    Next
    'D'  Else
    'D    'don't list system tables
    'D'    For Each tdf In gwsmainws.databases(0).TableDefs
    'D    For Each tdf In gwsActiveWS.Databases(0).TableDefs
    'D      If (tdf.Attributes And dbSystemObject) = 0 Then
    'D        If (tdf.Attributes And dbAttachedTable) = dbAttachedTable Then
    'D          If Left(tdf.Connect, 1) = ";" Then
    'D            'must be a Microsoft Access attached table
    'D            rListObject.AddItem tdf.Name & " -> Microsoft Access"
    'D          Else
    'D            'must be an ISAM attached table
    'D            rListObject.AddItem tdf.Name & " -> " & Left(tdf.Connect, InStr(tdf.Connect, ";") - 1)
    'D          End If
    'D        ElseIf (tdf.Attributes And dbAttachedODBC) = dbAttachedODBC Then
    'D          rListObject.AddItem tdf.Name & " -> ODBC"
    'D        Else
    'D          rListObject.AddItem tdf.Name
    'D        End If
    'D      End If
    'D    Next
    'D'  End If
    'D  'select the 1st item if there is any
    'D  If rListObject.ListCount > 0 Then
    'D    rListObject.ListIndex = 0
    'D  End If
    'D
    'DLoadTreeView:
    xFrm.LoadDatabase         'xCurrentWS, xCurrentDB
    xFrm.Refresh
    
    RefreshTables = True
    
    Screen.MousePointer = vbDefault
    MsgBar vbNullString, False
    
    Set frmActiveFrm = xFrm
    
    Exit Function

TRefErr:
    ShowError
    
End Function

Function SetFldProperties(rnType As Integer) As Integer
    
    '------------------------------------------------------------
    'this function returns the size of the field type
    'passed in for use on the frmAddField form
    '------------------------------------------------------------
    
    ' return field length
    Select Case rnType
        Case dbBoolean
            SetFldProperties = 1
        Case dbByte
            SetFldProperties = 1
        Case dbInteger
            SetFldProperties = 2
        Case dbLong
            SetFldProperties = 4
        Case dbCurrency
            SetFldProperties = 8
        Case dbSingle
            SetFldProperties = 4
        Case dbDouble
            SetFldProperties = 8
        Case dbDate
            SetFldProperties = 8
        Case dbText
            SetFldProperties = 50
        Case dbLongBinary
            SetFldProperties = 0
        Case dbMemo
            SetFldProperties = 0
    End Select
    
End Function

Sub ShowDBTools()
  
    '------------------------------------------------------------
    'this sub shows the menus and toolbar that only apply
    'when a database is open
    '------------------------------------------------------------
  
    Dim sTmp As String
    
    frmMDI.mnuDBClose.Enabled = True
    frmMDI.mnuUtil.Enabled = False
    frmMDI.tlbToolBar.Buttons("BeginTrans").Enabled = True
    frmMDI.tlbToolBar.Buttons("Commit").Enabled = False
    frmMDI.tlbToolBar.Buttons("Rollback").Enabled = False
    frmMDI.tlbToolBar.Refresh
    
    'set general items that apply/don't apply to MDBs
    If gsDataType = gsMSACCESS Then
        frmMDI.mnuUBar1.Visible = True
        'frmMDI.mnuUAttachments.Visible = True
        'frmMDI.mnuUGroupsUsers.Visible = True
        'frmMDI.mnuUSystemDB.Visible = True
        'frmSQL.cmdSaveQueryDef.Visible = True
        frmMDI.mnuDBPURename.Visible = True
    Else
        'frmSQL.cmdSaveQueryDef.Visible = False
        frmMDI.mnuDBPURename.Visible = False
    End If
    
    'set ODBC specific items
    If gsDataType = gsSQLDB Then
        If gnRSType = gnRS_TABLE Then
            frmMDI.tlbToolBar.Buttons("Dynaset").Value = tbrPressed
            gnRSType = gnRS_DYNASET
        End If
        'frmMDI.tlbToolBar.Buttons("PassThrough").Visible = True
        'frmMDI.tlbToolBar.Buttons("Table").Visible = False
    Else
        If gnRSType = gnRS_PASSTHRU Then
            frmMDI.tlbToolBar.Buttons("Dynaset").Value = tbrPressed
            gnRSType = gnRS_DYNASET
        End If
        'frmMDI.tlbToolBar.Buttons("PassThrough").Visible = False
        frmMDI.tlbToolBar.Buttons("Table").Visible = False
    End If
    
    frmMDI.tlbToolBar.Refresh
    
    ' show the 2 main child forms
    'frmDatabase.Show
    'frmSQL.Show

End Sub

Sub ShowError()
  
    '------------------------------------------------------------
    'this sub displays the error message with it's Err code
    'and prompts to show the Errors collection if it
    'is a data access type error
    '------------------------------------------------------------
  
    Dim sTmp As String
    
    Screen.MousePointer = vbDefault
    MsgBar vbNullString, False
    
    sTmp = "The following Error occurred:" & vbCrLf & vbCrLf
    
    'add the error string
    sTmp = sTmp & Err.Description & vbCrLf
    
    'add the error number
    sTmp = sTmp & MSG8 & Err
    sTmp = sTmp & vbCrLf & vbCrLf
    sTmp = sTmp & "Data Access Error Collection Error:" & vbCrLf
    
    If Not Errors Is Nothing Then
        sTmp = sTmp & Errors(0).Number & vbCrLf
        sTmp = sTmp & Errors(0).Description & vbCrLf
    End If
    
    Beep
    
    'check to see if the error is from the db errors collection
    If DBEngine.Errors.Count > 0 Then
        If DBEngine.Errors(0).Number = Err Then
            'add the prompt to display the errors collection
            sTmp = sTmp & vbCrLf & vbCrLf & MSG9
            'beep and show the error
            If MsgBox(sTmp, vbYesNo + vbQuestion) = vbYes Then
                RefreshErrors
            End If
        Else
            MsgBox sTmp
        End If
    Else
        MsgBox sTmp
    End If

End Sub

Function StripConnect(rsTblName As String) As String

    '------------------------------------------------------------
    'this function strips the attached table connect string off
    '------------------------------------------------------------

    If InStr(rsTblName, "->") > 0 Then
        StripConnect = UCase(Trim(Left(rsTblName, InStr(rsTblName, "->") - 2)))
    Else
        StripConnect = UCase(Trim(rsTblName))
    End If

End Function

Function StripBrackets(rsObjName As String) As String

    '------------------------------------------------------------
    'this function strips the [ ] off of data objects
    '------------------------------------------------------------

    'add brackets to object names w/ spaces in them
    If Mid(rsObjName, 1, 1) = "[" Then
        StripBrackets = Mid(rsObjName, 2, Len(rsObjName) - 2)
    Else
        StripBrackets = rsObjName
    End If

End Function

Function StripFileName(rsFileName As String) As String

    '------------------------------------------------------------
    'this function strips the file name from a path\file string
    '------------------------------------------------------------

    On Error Resume Next
    
    Dim i As Integer
    
    For i = Len(rsFileName) To 1 Step -1
        If Mid(rsFileName, i, 1) = "\" Then
            Exit For
        End If
    Next
    
    StripFileName = Mid(rsFileName, 1, i - 1)

End Function

Function StripNonAscii(rvntVal As Variant) As String
  
    '------------------------------------------------------------
    'this function strips the non ACSII chars off memo field
    'data before displaying it (not sure this is always needed)
    '------------------------------------------------------------
  
    Dim i As Integer
    Dim sTmp As String
    
    'stubbed out to enable DBCS chars
    StripNonAscii = rvntVal
    Exit Function
    
    For i = 1 To Len(rvntVal)
        If Asc(Mid(rvntVal, i, 1)) < 32 Or Asc(Mid(rvntVal, i, 1)) > 126 Then
            sTmp = sTmp & " "
        Else
            sTmp = sTmp & Mid(rvntVal, i, 1)
        End If
    Next
    
    StripNonAscii = sTmp

End Function

Function StripOwner(rsTblName As String) As String

    '------------------------------------------------------------
    'strips the owner off of ODBC table names
    '------------------------------------------------------------

    If InStr(rsTblName, ".") > 0 Then
        rsTblName = Mid(rsTblName, InStr(rsTblName, ".") + 1, Len(rsTblName))
    End If
    
    StripOwner = rsTblName

End Function

Function stTrueFalse(rvntTF As Variant) As String

    '------------------------------------------------------------
    'returns the true or false string
    '------------------------------------------------------------

    If rvntTF Then
        stTrueFalse = "True"
    Else
        stTrueFalse = "False"
    End If

End Function

Function vFieldVal(rvntFieldVal As Variant) As Variant

    '------------------------------------------------------------
    'returns "" if a field is Null
    '------------------------------------------------------------

    If IsNull(rvntFieldVal) Then
        vFieldVal = vbNullString
    Else
        vFieldVal = CStr(rvntFieldVal)
    End If

End Function

Sub LoadINISettings()

    '------------------------------------------------------------
    'loads all saved INI settings for VisData
    '------------------------------------------------------------

    On Error Resume Next
    
    Dim sTmp As String
    Dim x As Integer
    
    glQueryTimeout = Val(GetINIString("QueryTimeout", "5"))
    glLoginTimeout = Val(GetINIString("LoginTimeout", "20"))
    
    frmMDI.mnuPOpenOnStartup.Checked = Val(GetINIString("OpenOnStartup", "0"))
    'frmMDI.mnuPAllowSys.Checked = Val(GetINIString("AllowSys", "0"))
    
    'get the most recently used databases
    For x = 1 To 8
        sTmp = GetINIString("MRUDatabase" & x, "")
        If Len(sTmp) > 0 Then
            frmMDI.mnuBarMRU.Visible = True
            frmMDI.mnuDBMRU(x).Caption = "&" & x & " " & sTmp
            frmMDI.mnuDBMRU(x).Visible = True
            sTmp = GetINIString("MRUConnect" & x, "")
            frmMDI.mnuDBMRU(x).Tag = sTmp
        End If
    Next
    
    'get the last used database out of the INI file
    gsDataType = GetINIString("DataType", vbNullString)
    gsDBName = GetINIString("DatabaseName", vbNullString)
    gsODBCDatasource = GetINIString("ODBCDatasource", vbNullString)
    gsODBCDatabase = GetINIString("ODBCDatabase", vbNullString)
    gsODBCUserName = GetINIString("ODBCUserName", vbNullString)

    'D  'gsODBCUserName = ""
    'D  'gsODBCPassword = GetINIString("ODBCPassword", vbNullString)
    'D  'gsODBCPassword = ""
    gsODBCDriver = GetINIString("ODBCDriver", vbNullString)
    gsODBCServer = GetINIString("ODBCServer", vbNullString)
    
    sTmp = GetINIString("ViewMode", CStr(gnFORM_NODATACTL))
    Select Case Val(sTmp)
        Case gnFORM_NODATACTL
            gnFormType = gnFORM_NODATACTL
        Case gnFORM_DATACTL
            gnFormType = gnFORM_DATACTL
        Case gnFORM_DATAGRID
            gnFormType = gnFORM_DATAGRID
    End Select
    
    'D DV 8/18/99 - All our resultsets will by Dynamic/DynaSet types.
    'D  sTmp = GetINIString("RecordsetType", CStr(vbRSTypeDynaset))
    'D  Select Case Val(sTmp)
    'D    Case vbRSTypeTable
    'D      gnRSType = gnRS_TABLE
    'D    Case vbRSTypeDynaset
            gnRSType = gnRS_DYNASET
    'D    Case vbRSTypeSnapShot
    'D      gnRSType = gnRS_SNAPSHOT
    'D    Case gnRS_PASSTHRU
    'D      gnRSType = gnRS_PASSTHRU
    'D  End Select
  
    DoEvents
    Select Case gnFormType
        Case gnFORM_NODATACTL
            frmMDI.tlbToolBar.Buttons("NoDataControl").Value = tbrPressed
        Case gnFORM_DATACTL
            frmMDI.tlbToolBar.Buttons("DataControl").Value = tbrPressed
        Case gnFORM_DATAGRID
            'frmMDI.tlbToolBar.Buttons("DBGrid").Value = tbrPressed
    End Select
    
    Select Case gnRSType
        Case vbRSTypeDynaset
            frmMDI.tlbToolBar.Buttons("Dynaset").Value = tbrPressed
        Case vbRSTypeSnapShot
            frmMDI.tlbToolBar.Buttons("Snapshot").Value = tbrPressed
        Case vbRSTypeTable
            frmMDI.tlbToolBar.Buttons("Table").Value = tbrPressed
        Case gnRS_PASSTHRU
            frmMDI.tlbToolBar.Buttons("PassThrough").Value = tbrPressed
    End Select
  
End Sub

Sub SaveINISettings()
    '------------------------------------------------------------
    'saves current VisData values in VISDATA.INI
    '------------------------------------------------------------

    On Error Resume Next
    
    Dim i As Integer
    
    SaveSetting APP_CATEGORY, App.Title, "DataType", gsDataType
    SaveSetting APP_CATEGORY, App.Title, "DatabaseName", gsDBName
    SaveSetting APP_CATEGORY, App.Title, "ODBCDatasource", gsODBCDatasource
    SaveSetting APP_CATEGORY, App.Title, "ODBCDatabase", gsODBCDatabase
    SaveSetting APP_CATEGORY, App.Title, "ODBCUserName", gsODBCUserName
    'SaveSetting APP_CATEGORY, App.Title, "ODBCPassword", gsODBCPassword
    SaveSetting APP_CATEGORY, App.Title, "ODBCDriver", gsODBCDriver
    SaveSetting APP_CATEGORY, App.Title, "ODBCServer", gsODBCServer
    SaveSetting APP_CATEGORY, App.Title, "QueryTimeout", glQueryTimeout
    SaveSetting APP_CATEGORY, App.Title, "LoginTimeout", glLoginTimeout
    DBEngine.LoginTimeout = glLoginTimeout
    SaveSetting APP_CATEGORY, App.Title, "ViewMode", gnFormType
    SaveSetting APP_CATEGORY, App.Title, "RecordsetType", gnRSType
    
    SaveSetting APP_CATEGORY, App.Title, "OpenOnStartup", IIf(frmMDI.mnuPOpenOnStartup.Checked, "-1", "0")
    'SaveSetting APP_CATEGORY, App.Title, "AllowSys", IIf(frmMDI.mnuPAllowSys.Checked, "-1", "0")
    
    For i = 1 To 8
        If frmMDI.mnuDBMRU(i).Visible Then
            SaveSetting APP_CATEGORY, App.Title, "MRUDatabase" & i, Mid(frmMDI.mnuDBMRU(i).Caption, 4, Len(frmMDI.mnuDBMRU(i).Caption))
            SaveSetting APP_CATEGORY, App.Title, "MRUConnect" & i, frmMDI.mnuDBMRU(i).Tag
        Else
            SaveSetting APP_CATEGORY, App.Title, "MRUDatabase" & i, ""
            SaveSetting APP_CATEGORY, App.Title, "MRUConnect" & i, ""
        End If
    Next
    
    SaveSetting APP_CATEGORY, App.Title, "WindowState", frmMDI.WindowState
    
    If frmMDI.WindowState = vbNormal Then
        SaveSetting APP_CATEGORY, App.Title, "WindowTop", frmMDI.Top
        SaveSetting APP_CATEGORY, App.Title, "WindowLeft", frmMDI.Left
        SaveSetting APP_CATEGORY, App.Title, "WindowWidth", frmMDI.Width
        SaveSetting APP_CATEGORY, App.Title, "WindowHeight", frmMDI.Height
    End If
    
    SaveSetting APP_CATEGORY, App.Title, "ViewMode", gnFormType
    SaveSetting APP_CATEGORY, App.Title, "RecordsetType", gnRSType
End Sub

Sub OpenTable(rName As String, rWhere As String, rOrderBy As String)
    '------------------------------------------------------------
    'this sub will open the appropriate data type form and
    'display the appropriate msg in the status bar based on
    'user selected options on the main MDI form
    '------------------------------------------------------------

    On Error GoTo OpenTableErr
    'Dim rsTmp As Recordset
    Dim sTmp As String
    Dim nAttach As Integer
    Dim frmTmp As Form
    
    If nAttach > 0 Then
        If gnRSType = gnRS_DYNASET Then
            sTmp = MSG11
        ElseIf gnRSType = gnRS_SNAPSHOT Then
            sTmp = MSG12
        End If
    Else
        If gnRSType = gnRS_TABLE Then
            sTmp = MSG13
        ElseIf gnRSType = gnRS_DYNASET Then
            sTmp = MSG14
        ElseIf gnRSType = gnRS_SNAPSHOT Then
            sTmp = MSG15
        ElseIf gnRSType = gnRS_PASSTHRU Then
            sTmp = MSG16
        End If
    End If
    
    MsgBar sTmp, True
    
    Screen.MousePointer = vbHourglass
    
'    If gwsActiveWS.Type = dbUseODBC Then
'        Set rsTmp = gwsActiveWS.Connections(0).OpenRecordset(rName, dbOpenDynamic, 0, dbOptimisticBatch)
'    Else
'        Set rsTmp = gwsActiveWS.Databases(0).OpenRecordset(rName, dbOpenDynaset, dbSeeChanges)
'    End If
'    If Not rsTmp.EOF And Not rsTmp.BOF Then
'        rsTmp.MoveLast
'    End If
    
    sTmp = "Table:"
    Screen.MousePointer = vbDefault
    
    Set frmTmp = New frmDataGrid
    'frmTmp.Hide
    
    'Set frmTmp.mrsFormRecordset = rsTmp
    frmTmp.Caption = sTmp & rName
    frmTmp.AfterLoad rName
    frmTmp.Show
  
    MsgBar vbNullString, False
  
    Exit Sub
    
OpenTableErr:
    ShowError
    'temp try this for now
    Screen.MousePointer = vbHourglass
  
'    If gnRSType = gnRS_TABLE Then
'        If gwsActiveWS.Type = dbUseODBC Then
'            Set rsTmp = gwsActiveWS.Databases(0).OpenRecordset(rName, dbOpenTable, dbSeeChanges)
'        Else
'            Set rsTmp = gwsActiveWS.Databases(0).OpenRecordset(rName, dbOpenTable, dbSeeChanges)
'        End If
'        sTmp = "Table:"
'    ElseIf gnRSType = gnRS_DYNASET Then
'        If gwsActiveWS.Type = dbUseODBC Then
'            Set rsTmp = gwsActiveWS.Databases(0).OpenRecordset(rName, dbOpenDynaset, dbSeeChanges)
'        Else
'            Set rsTmp = gwsActiveWS.Databases(0).OpenRecordset(rName, dbOpenDynaset, dbSeeChanges)
'        End If
'        sTmp = "Dynaset:"
'    ElseIf gnRSType = gnRS_SNAPSHOT Then
'        If gwsActiveWS.Type = dbUseODBC Then
'            Set rsTmp = gwsActiveWS.Databases(0).OpenRecordset(rName, dbOpenSnapshot, dbSeeChanges)
'        Else
'            Set rsTmp = gwsActiveWS.Databases(0).OpenRecordset(rName, dbOpenSnapshot, dbSeeChanges)
'        End If
'        sTmp = "Snapshot:"
'    End If
  
    Screen.MousePointer = vbDefault

End Sub

Sub OpenQuery(rName As String, bTemp As Boolean)

    '------------------------------------------------------------
    'opens a QueryDef with the user selected form type
    '------------------------------------------------------------

    On Error GoTo OpenQueryErr
    
    Dim sTmp As String
    Dim rsTmp As Recordset
    Dim qdfTmp As QueryDef
    Dim sQueryType As String
    Dim frmTmp As Form
    Dim nDoIt As Integer
    Dim bReturnsRows As Boolean
    
    If bTemp Then
        If gwsMainWS.Type = dbUseODBC Then
            Set qdfTmp = gwsMainWS.Connections(0).CreateQueryDef("", rName)
        Else
            Set qdfTmp = gwsMainWS.Databases(0).CreateQueryDef("", rName)
        End If
        If MsgBox(MSG17, vbYesNo + vbQuestion + vbDefaultButton2) = vbYes Then
            sTmp = InputBox(MSG18)
            If Len(sTmp) > 0 Then
                qdfTmp.Connect = sTmp
            End If
        End If
        'assume it is non row returning to begin with
        bReturnsRows = False
    Else
        If gwsMainWS.Type = dbUseODBC Then
            Set qdfTmp = gwsMainWS.Connections(0).QueryDefs(rName)
        Else
            Set qdfTmp = gwsMainWS.Databases(0).QueryDefs(rName)
        End If
        sQueryType = ActionQueryType(qdfTmp)
        If qdfTmp.Type <> dbQSQLPassThrough Then
            'not a sql pass through so we need to set ReturnsRecords
            If qdfTmp.Type = 0 Or qdfTmp.Type = dbQCrosstab Then
                bReturnsRows = True
            Else
                bReturnsRows = False
            End If
        Else
            'get it from the qdf if it is passthrough
            bReturnsRows = qdfTmp.ReturnsRecords
        End If
    End If
    
    If bReturnsRows And (gnRSType = gnRS_TABLE) Then
        Beep
        If MsgBox(MSG19, vbYesNo + vbQuestion) = vbYes Then
            frmMDI.tlbToolBar.Buttons("Dynaset").Value = tbrPressed         'reset to recordset
        Else
            Exit Sub
        End If
    End If
    
    If bReturnsRows Then
        SetQDFParams qdfTmp
        
MakeDynaset:
        Screen.MousePointer = vbHourglass
        If qdfTmp.Type = dbQSQLPassThrough Then
            MsgBar MSG16, True
            Set rsTmp = qdfTmp.OpenRecordset(dbOpenSnapshot, dbSQLPassThrough)
        ElseIf gnRSType = gnRS_SNAPSHOT Then
            MsgBar MSG20, True
            Set rsTmp = qdfTmp.OpenRecordset(dbOpenSnapshot)
        Else
            MsgBar MSG21, True
            Set rsTmp = qdfTmp.OpenRecordset(dbOpenDynaset)
        End If
        Screen.MousePointer = vbDefault
        
        If gnFormType = gnFORM_NODATACTL Then
            Set frmTmp = New frmDynaSnap
        ElseIf gnFormType = gnFORM_DATACTL Then
            Set frmTmp = New frmDataControl
            If qdfTmp.Parameters.Count > 0 Then
                frmTmp.mbIsParameterized = True
            End If
        ElseIf gnFormType = gnFORM_DATAGRID Then
            Set frmTmp = New frmDataGrid
        End If
        
        Set frmTmp.mrsFormRecordset = rsTmp
        If Len(qdfTmp.SQL) > 50 Then
            frmTmp.Caption = MSG22
        Else
            frmTmp.Caption = qdfTmp.SQL
        End If
        frmTmp.Show
    Else
        Screen.MousePointer = vbDefault
        If Len(sQueryType) > 0 Then
            nDoIt = MsgBox(MSG23 & sQueryType & MSG24, vbYesNo + vbQuestion)
        Else
            'no name so just try to execute it
            nDoIt = vbYes
        End If
        If nDoIt = vbYes Then
            SetQDFParams qdfTmp
            Screen.MousePointer = vbHourglass
            MsgBar MSG25, True
            qdfTmp.Execute
            If gwsMainWS.Databases(0).RecordsAffected > 0 Then
                If gbTransPending Then gbDBChanged = True
            End If
        End If
    End If
    
    MsgBar vbNullString, False
    
    Exit Sub

OpenQueryErr:
    If Err = 3065 Or Err = 3078 Then
        'row returning so try to create recordset
        Resume MakeDynaset
    End If
    ShowError

End Sub

Sub DisplayCurrentRecord(frm As Object, rec As Recordset, lCnt As Long, bNew As Integer)
  
    '------------------------------------------------------------
    'this sub display all field data in the current row
    'on the table and dynasnap forms
    '------------------------------------------------------------
  
    Dim i As Integer
    Dim sCurrStat As String
    Dim lCurrRec As Long
    Dim bNoInd As Integer
    
    On Error GoTo DCRErr
    
    Screen.MousePointer = vbHourglass
    
    sCurrStat = "Row "
     
    'check to see if a table w/ 0 indexes is in use
    If rec.Type = dbOpenTable Then
        If gwsMainWS.Databases(0)(rec.Name).Indexes.Count = 0 Then
            bNoInd = True
        End If
    End If
     
    ' check for an empty recordset
    If rec.RecordCount > 0 Then
        lCurrRec = (lCnt * (rec.PercentPosition * 0.01)) + 1
    End If
       
    ' check BOF/EOF flag so we know if we
    ' are sitting on a valid record
    If bNew Then
        If bNoInd Then
            sCurrStat = lCnt & " Rows"
        Else
            sCurrStat = lCurrRec & "/" & lCnt
        End If
    Else
        If rec.BOF Then
            sCurrStat = "(BOF)/" & lCnt
            ClearDataFields frm, rec.Fields.Count
        ElseIf rec.EOF Then
            sCurrStat = "(EOF)/" & lCnt
            ClearDataFields frm, rec.Fields.Count
        Else
            If bNoInd Then
                sCurrStat = lCnt & " Rows"
            Else
                sCurrStat = lCurrRec & "/" & lCnt
            End If
            'place the data in the form fields
            For i = 0 To rec.Fields.Count - 1
                If rec(i).Type = dbMemo Then
                    If rec(i).FieldSize() < gnGETCHUNK_CUTOFF Then
                        frm.txtFieldData(i).Text = StripNonAscii(vFieldVal(rec(i)))
                    Else
                        frm.txtFieldData(i).Text = StripNonAscii(vFieldVal(rec(i).GetChunk(0, gnGETCHUNK_CUTOFF)))
                    End If
                ElseIf rec(i).Type = dbText Then
                    frm.txtFieldData(i).Text = vFieldVal(rec(i))
                Else
                    frm.txtFieldData(i).Text = vFieldVal(rec(i))
                End If
            Next
        End If
    End If
    
    If rec.Updatable = False Then sCurrStat = sCurrStat & MSG26
    frm.lblStatus.Caption = sCurrStat
    Screen.MousePointer = vbDefault
    
    Exit Sub
    
DCRErr:
    ShowError
    Resume Next    'so we can try and display as much data as possible

End Sub

Function DupeTableName(rName As String) As Integer

    '------------------------------------------------------------
    'this function checks to see if the passed in name exists
    'in either the Tabledefs or Querydefs collection
    'it found, it prompts to delete it and returns false
    'if the user selects to delete it or true if not
    'if not found, it returns false
    '------------------------------------------------------------

    On Error GoTo DTNErr
    
    Dim tdf As TableDef
    Dim qdf As QueryDef
    Dim i As Integer
    
    For Each tdf In gwsMainWS.Databases(0).TableDefs
        If UCase(tdf.Name) = UCase(rName) Then
            If MsgBox(MSG27, vbYesNo + vbQuestion) = vbYes Then
                gwsMainWS.Databases(0).TableDefs.Delete rName
                DupeTableName = False
            Else
                DupeTableName = True
            End If
            Exit Function
        End If
    Next

    If gsDataType = gsMSACCESS Then
        If gwsMainWS.Type = dbUseODBC Then
            For Each qdf In gwsMainWS.Connections(0).QueryDefs
                If UCase(qdf.Name) = UCase(rName) Then
                    If MsgBox(MSG28, vbYesNo + vbQuestion) = vbYes Then
                        gwsMainWS.Connections(0).QueryDefs.Delete rName
                        DupeTableName = False
                    Else
                        DupeTableName = True
                    End If
                    Exit Function
                End If
            Next
        Else
            For Each qdf In gwsMainWS.Databases(0).QueryDefs
                If UCase(qdf.Name) = UCase(rName) Then
                    If MsgBox(MSG28, vbYesNo + vbQuestion) = vbYes Then
                        gwsMainWS.Databases(0).QueryDefs.Delete rName
                        DupeTableName = False
                    Else
                        DupeTableName = True
                    End If
                    Exit Function
                End If
            Next
        End If
    End If

    DupeTableName = False
    
    Exit Function

DTNErr:
    ShowError
    DupeTableName = False

End Function

Sub UnloadAllForms()
  
    '------------------------------------------------------------
    'this sub unloads all forms except for the
    'SQL, Tables and MDI form
    '------------------------------------------------------------
  
    On Error Resume Next
    
    Dim i As Integer
  
    ' close all forms - NO EXCEPTIONS
    'For i = Forms.Count To 1 Step -1
    '    Unload Forms(i)
    'Next
  
    ' close all forms except for the Tables and SQL forms
    For i = Forms.Count - 1 To 1 Step -1
        Unload Forms(i)
    Next

End Sub

Sub SetQDFParams(rqdf As QueryDef)

    '------------------------------------------------------------
    'this sub walks the parameters collection in a parameterized
    'query and prompts the user for a value for each parameter
    '------------------------------------------------------------

    On Error GoTo SPErr
    
    Dim prm As Parameter
    Dim sTmp As String
    
    For Each prm In rqdf.Parameters
        'get the value from the user
        sTmp = InputBox(MSG29, "'" & prm.Name & "':")
        'store the value
        prm.Value = CVar(sTmp)
    Next
    
    Exit Sub
    
SPErr:
    ShowError
    
End Sub

Sub RefreshErrors()

    '------------------------------------------------------------
    'this sub refreshs the Error form with the latest Errors
    '------------------------------------------------------------

    On Error GoTo RErr
    
    Dim errObj As Error
    Dim i As Integer
    
    If DBEngine.Errors.Count = 0 Then
        MsgBox MSG30, 48
        Unload frmErrors
        Exit Sub
    End If

    frmErrors.Show
    frmErrors.lstErrors.Clear
    
    For i = 0 To DBEngine.Errors.Count - 1
        Set errObj = DBEngine.Errors(i)
        frmErrors.lstErrors.AddItem errObj.Number & vbTab & errObj.Source & vbTab & errObj.Description
    Next
    
    frmErrors.SetFocus
    
    Exit Sub
  
RErr:
    MsgBox MSG31, 48
    Unload frmErrors
    Exit Sub

End Sub

Sub AddMRU()

    '------------------------------------------------------------
    'this sub adds the just opened database to the most recently
    'used list in the File menu
    '------------------------------------------------------------

    On Error GoTo AMErr
    
    Dim i As Integer, j As Integer
    
    '1st look to see if it alread exists and swap it if it does
    For i = 1 To 8
        If UCase(Mid(frmMDI.mnuDBMRU(i).Caption, 4, Len(frmMDI.mnuDBMRU(i).Caption))) = UCase(gsDBName) Then
            For j = i To 2 Step -1
                frmMDI.mnuDBMRU(j).Caption = "&" & j & " " & Mid(frmMDI.mnuDBMRU(j - 1).Caption, 4, Len(frmMDI.mnuDBMRU(j - 1).Caption))
                frmMDI.mnuDBMRU(j).Tag = frmMDI.mnuDBMRU(j - 1).Tag
            Next
            GoTo Finish
        End If
    Next

    'wasn't there so move everything down one
    For i = 7 To 1 Step -1
        frmMDI.mnuDBMRU(i + 1).Caption = "&" & i + 1 & " " & Mid(frmMDI.mnuDBMRU(i).Caption, 4, Len(frmMDI.mnuDBMRU(i).Caption))
        frmMDI.mnuDBMRU(i + 1).Tag = frmMDI.mnuDBMRU(i).Tag
    Next

Finish:
    frmMDI.mnuDBMRU(1).Caption = "&1 " & gsDBName
    If Len(gwsMainWS.Databases(0).Connect) = 0 Then
        'handle the Access case where there is no connect string
        frmMDI.mnuDBMRU(1).Tag = gsMSACCESS
    Else
        frmMDI.mnuDBMRU(1).Tag = gwsMainWS.Databases(0).Connect
    End If
    frmMDI.mnuBarMRU.Visible = True
    For i = 1 To 8
        If Len(Mid(frmMDI.mnuDBMRU(i).Caption, 4, Len(frmMDI.mnuDBMRU(i).Caption))) > 0 Then
            frmMDI.mnuDBMRU(i).Visible = True
        End If
    Next

    Exit Sub

AMErr:
    ShowError

End Sub

Sub GetODBCConnectParts(rsConnect As String)

    '------------------------------------------------------------
    'this sub breaks out the parts of a ODBC connect string
    'and assigns them to the global ODBC variables
    '------------------------------------------------------------

    On Error Resume Next
    
    Dim i As Integer
    Dim sTmp As String
    
    'process the connect string just in case the
    'values came from the ODBC dialogs
    If InStr(rsConnect, "=") Then
        i = 1
        While i <= Len(rsConnect) + 1
            If Mid(rsConnect, i, 1) = ";" Or i = Len(rsConnect) + 1 Then
                If Len(sTmp) > 0 And InStr(sTmp, "=") > 0 Then
                    Select Case UCase(Mid(sTmp, 1, InStr(1, sTmp, "=") - 1))
                        Case "DSN"
                            gsODBCDatasource = Mid(sTmp, InStr(1, sTmp, "=") + 1, Len(sTmp))
                        Case "DATABASE"
                            gsODBCDatabase = Mid(sTmp, InStr(1, sTmp, "=") + 1, Len(sTmp))
                        Case "DBQ"
                            gsODBCDatabase = Mid(sTmp, InStr(1, sTmp, "=") + 1, Len(sTmp))
                        Case "UID"
                            gsODBCUserName = Mid(sTmp, InStr(1, sTmp, "=") + 1, Len(sTmp))
                        Case "PWD"
                            gsODBCPassword = Mid(sTmp, InStr(1, sTmp, "=") + 1, Len(sTmp))
                        Case "DRIVER"
                            gsODBCDriver = Mid(sTmp, InStr(1, sTmp, "=") + 1, Len(sTmp))
                        Case "SERVER"
                            gsODBCServer = Mid(sTmp, InStr(1, sTmp, "=") + 1, Len(sTmp))
                         Case Else
                            'nothing
                    End Select
                End If
                sTmp = vbNullString
            Else
                sTmp = sTmp + Mid(rsConnect, i, 1)
            End If
            i = i + 1
        Wend
    End If

End Sub

Sub ListItemNames(rcCollection As Object, rnCtl As Control, bClearList As Integer)
  
    '------------------------------------------------------------
    'this is a generic sub that adds the name of each item
    'in a collection to the passed in control
    '------------------------------------------------------------
  
    On Error GoTo LINErr
    
    Dim objTmp As Object
    Dim i As Integer
    
    If bClearList Then
        rnCtl.Clear
    End If
    
    For Each objTmp In rcCollection
        rnCtl.AddItem objTmp.Name
    Next
    
    Exit Sub
    
LINErr:
    ShowError
    
End Sub

Sub CloseCurrentDB(xWS As Workspace, xDB As Database)
    '------------------------------------------------------------
    'this sub closes the current DB and performs any cleanup
    'and resetting of controls, menus, etc.
    '------------------------------------------------------------

    On Error GoTo DBCloseErr
    
    If xDB Is Nothing Then Exit Sub
      
    If gbDBChanged Then
        If MsgBox(MSG32, vbYesNo + vbQuestion) = vbYes Then
            'gwsMainWS.CommitTrans
            xWS.CommitTrans
            gbDBChanged = False
        Else
            If MsgBox(MSG33, vbYesNo + vbQuestion) = vbYes Then
                'gwsMainWS.Rollback
                xWS.Rollback
                gbDBChanged = False
            Else
                Beep
                MsgBox MSG34, 48
                Exit Sub
            End If
        End If
    End If
    
    frmMDI.Caption = "QualiSys - Data Table Manager"
    
    HideDBTools
    
    gbDBOpenFlag = False
    gbTransPending = False
    gsDBName = vbNullString
    gnReadOnly = False
    
    xDB.Close
    Set xDB = Nothing
    CloseCurrentWS xWS
    UnloadAllForms
    
    Exit Sub

DBCloseErr:
    ShowError
End Sub

Sub CloseCurrentWS(xWS As Workspace)
    '------------------------------------------------------------
    'this sub closes the current WS and performs cleanup
    'and resetting of controls, menus, etc.
    '------------------------------------------------------------
  
    Dim cnt As Integer
    On Error GoTo WSCloseErr
    
    'If gwsMainWS Is Nothing Then Exit Sub
    If xWS Is Nothing Then Exit Sub
    
    '  xWS.Connections(0).Close
    'gwsMainWS.Close
    xWS.Close
    
    'Set gwsMainWS = Nothing
    Set xWS = Nothing
    
    Exit Sub
    
WSCloseErr:
    ShowError
End Sub

Sub OpenLocalDB(bSilent As Boolean)
    On Error GoTo OpenError
    
    Dim sConnect As String
    Dim sDatabaseName As String
    Dim dbTemp As Database
    Dim sTmp As String
    
    sDatabaseName = gsDBName
    
    If Not bSilent Then
        Select Case gsDataType
            Case gsMSACCESS
                frmMDI.dlgCMD1.Filter = MSG49 & MSG50
                frmMDI.dlgCMD1.DialogTitle = MSG36
            Case gsDBASEIII, gsDBASEIV, gsDBASE5
                frmMDI.dlgCMD1.Filter = "Dbase DBs (*.dbf)|*.dbf" & MSG50
                frmMDI.dlgCMD1.DialogTitle = MSG37
            Case gsFOXPRO20, gsFOXPRO25, gsFOXPRO26, gsFOXPRO30
                frmMDI.dlgCMD1.Filter = "FoxPro DBs (*.dbf)|*.dbf" & MSG50
                frmMDI.dlgCMD1.DialogTitle = MSG38
            Case gsPARADOX3X, gsPARADOX4X, gsPARADOX5X
                frmMDI.dlgCMD1.Filter = "Paradox DBs (*.db)|*.db" & MSG50
                frmMDI.dlgCMD1.DialogTitle = MSG39
            Case gsEXCEL50
                frmMDI.dlgCMD1.Filter = "Excel Files (*.xls)|*.xls" & MSG50
                frmMDI.dlgCMD1.DialogTitle = MSG40
            Case gsBTRIEVE
                frmMDI.dlgCMD1.Filter = "Btrieve DBs (FILE.DDF)|FILE.DDF" & MSG50
                frmMDI.dlgCMD1.DialogTitle = MSG41
            Case gsTEXTFILES
                frmMDI.dlgCMD1.Filter = "Text Files (*.txt)|*.txt" & MSG50
                frmMDI.dlgCMD1.DialogTitle = MSG42
        End Select
    
        frmMDI.dlgCMD1.FilterIndex = 1
        frmMDI.dlgCMD1.FileName = gsDBName  '""
        frmMDI.dlgCMD1.CancelError = True
        frmMDI.dlgCMD1.Flags = FileOpenConstants.cdlOFNFileMustExist
        frmMDI.dlgCMD1.ShowOpen
        
        If Len(frmMDI.dlgCMD1.FileName) > 0 Then
          gsDBName = frmMDI.dlgCMD1.FileName
        Else
          Exit Sub
        End If
    Else
        gsDBName = sDatabaseName
    End If
    
    If Len(gsDBName) = 0 Then
        MsgBar vbNullString, False
        Exit Sub
    End If
    
    MsgBar MSG43, True
    Screen.MousePointer = vbHourglass
    
    'set the connect string
    If gsDataType = gsMSACCESS Then
        sConnect = vbNullString
    Else
        sConnect = gsDataType
    End If
    
    'set the database name for non Microsoft Access and Btrieve dbs that
    'came from the Common Dialog
    If gsDataType <> gsMSACCESS And gsDataType <> gsBTRIEVE And _
        gsDataType <> gsEXCEL50 And (Not bSilent) Then
        'need to strip off filename for these dbs
        sDatabaseName = StripFileName(gsDBName)
        gsDBName = sDatabaseName
    Else
        sDatabaseName = gsDBName
    End If
    
    GoTo OneMoreTry
    
GetPWD:
    Dim frmPWD As New frmDBPWD
    
    frmPWD.Show vbModal
    
    If Len(frmPWD.PWD) > 0 Then
        sConnect = ";pwd=" & frmPWD.PWD
        Unload frmPWD
        Set frmPWD = Nothing
        MsgBar MSG43, True
        Screen.MousePointer = vbHourglass
    Else
        'they cancelled the pwd dialog so we need to exit
        Unload frmPWD
        Set frmPWD = Nothing
        Exit Sub
    End If
    
OneMoreTry:
    If (frmMDI.dlgCMD1.Flags And FileOpenConstants.cdlOFNReadOnly) = FileOpenConstants.cdlOFNReadOnly Then
        gnReadOnly = True
    Else
        gnReadOnly = False
    End If
    Set dbTemp = gwsMainWS.OpenDatabase(sDatabaseName, False, gnReadOnly, sConnect)
    If gbDBOpenFlag Then
        'save the db name
        sTmp = gsDBName
        'restore it
        'CloseCurrentDB
        gsDBName = sTmp
        If gbDBOpenFlag Then
            Beep
            MsgBox MSG35, 48
            Exit Sub
        End If
    End If
    
    'success
    frmMDI.Caption = "QualiSys - Data Table Manager:" & sDatabaseName
    
    gbDBOpenFlag = True
    ShowDBTools
    Set gwsActiveWS = gwsMainWS
    
    If Not RefreshTables(Nothing, frmDatabase) Then Exit Sub
    gwsMainWS.Databases(0).QueryTimeout = glQueryTimeout
    
    AddMRU
    If gsDataType <> gsMSACCESS Then
        MsgBar MSG44, False
    End If
    Screen.MousePointer = vbDefault
    
    Exit Sub
    
AttemptRepair:
    Screen.MousePointer = vbHourglass
    MsgBar MSG45 & gsDBName, True
    DBEngine.RepairDatabase gsDBName
    Screen.MousePointer = vbDefault
    GoTo OneMoreTry
    
OpenError:
    Screen.MousePointer = vbDefault
    If Err = 3049 Then
        If MsgBox(Err.Description & vbCrLf & vbCrLf & MSG46, 4 + 48) = vbYes Then
            Resume AttemptRepair
        End If
    ElseIf Err = 3031 Then
        'password protected database
        Resume GetPWD
    End If
    gbDBOpenFlag = False
    gsDBName = vbNullString
    gsDataType = vbNullString
    gsODBCDatabase = vbNullString
    gsODBCUserName = vbNullString
    gsODBCPassword = vbNullString
    gsODBCDriver = vbNullString
    gsODBCServer = vbNullString
    If Err <> 32755 And Err <> 3049 Then   'check for common dialog cancelled
        ShowError
    End If
End Sub

Sub NewLocalISAM()

    '------------------------------------------------------------
    'this sub is used to create a new directory for one
    'of the local ISAM data types
    '------------------------------------------------------------

     On Error GoTo NewISAMErr
    
     Dim sNewName As String
     Dim d As Database
    
GetNewDirName:
     sNewName = InputBox(MSG47, , sNewName)
     If Len(sNewName) = 0 Then Exit Sub
    
     If Mid(sNewName, Len(sNewName), 1) <> "\" Then sNewName = sNewName & "\"
    
     MkDir Mid(sNewName, 1, Len(sNewName) - 1)
    
     gsDBName = sNewName
     OpenLocalDB True
    
     If gbDBOpenFlag Then
        ShowDBTools
        If Not RefreshTables(Nothing, frmDatabase) Then Exit Sub
     End If
    
    Exit Sub
    
NewISAMErr:
    If Err = 75 Then Resume Next  'catch the case where dir exists
    If Err = 76 Then
        MsgBox MSG65, vbExclamation
        'now try again
        Resume GetNewDirName
    End If
    
    ShowError
End Sub

Sub CompactDB(rnCompactVersion As Integer)
    '------------------------------------------------------------
    'this sub is called from the compact menu options
    'on the main MDI form
    '------------------------------------------------------------
  
    On Error GoTo CompactAccErr
    
    Dim sOldName As String
    Dim sNewName As String
    Dim sNewName2 As String
    Dim nEncrypt As Integer
    
    'get file name to compact
    frmMDI.dlgCMD1.Filter = MSG49
    frmMDI.dlgCMD1.DialogTitle = MSG48
    frmMDI.dlgCMD1.FilterIndex = 1
    frmMDI.dlgCMD1.Flags = FileOpenConstants.cdlOFNHideReadOnly
    frmMDI.dlgCMD1.ShowOpen
    If Len(frmMDI.dlgCMD1.FileName) > 0 Then
        sOldName = frmMDI.dlgCMD1.FileName
    Else
        Exit Sub
    End If
    
    'get file name to compact to
    frmMDI.dlgCMD1.DialogTitle = MSG51
    frmMDI.dlgCMD1.FilterIndex = 1
    frmMDI.dlgCMD1.FileName = vbNullString
    frmMDI.dlgCMD1.CancelError = True
    frmMDI.dlgCMD1.Flags = FileOpenConstants.cdlOFNOverwritePrompt + FileOpenConstants.cdlOFNHideReadOnly
    frmMDI.dlgCMD1.ShowSave
    If Len(frmMDI.dlgCMD1.FileName) > 0 Then
        sNewName = frmMDI.dlgCMD1.FileName
        If Dir(sNewName) <> vbNullString And sOldName <> sNewName Then
            Kill sNewName
        End If
    Else
        Exit Sub
    End If
    
    If MsgBox(MSG52, vbYesNo + vbQuestion) = vbYes Then
        nEncrypt = dbEncrypt
    Else
        nEncrypt = dbDecrypt
    End If
    
    Screen.MousePointer = vbHourglass
    MsgBar MSG53 & sOldName & " -> " & sNewName, True
    'if they want to overwrite the same file, we need to create a new MDB
    'and rename after the compact is successful
    If sOldName = sNewName Then
        sNewName2 = sNewName 'save the new name
        sNewName = Left(sNewName, Len(sNewName) - 1) & "N"
    End If
    
    DBEngine.CompactDatabase sOldName, sNewName, dbLangGeneral, rnCompactVersion + nEncrypt
    
    'check for an overwrite of the original mdb
    If VBA.Right(sNewName, 1) = "N" Then
        Kill sNewName2             'nuke the old one
        Name sNewName As sNewName2 'rename the new one to the original name
        sNewName = sNewName2       'reset to the correct name
    End If
    
    MsgBar vbNullString, False
    Screen.MousePointer = vbDefault
    
    If MsgBox(MSG54, vbYesNo + vbQuestion) = vbYes Then
        If gbDBOpenFlag Then
            ' CloseCurrentDB
        End If
        gsDataType = gsMSACCESS
        gsDBName = sNewName
        OpenLocalDB True
    End If
    
    If gbDBOpenFlag Then
        ShowDBTools
        Set gwsActiveWS = gwsMainWS
        RefreshTables Nothing, frmDatabase
    End If
    
    Exit Sub
    
CompactAccErr:
    If Err <> 32755 Then         'user cancelled
        ShowError
    End If

End Sub

Sub ShutDownVisData()
    '------------------------------------------------------------
    'this sub does some cleanup and shuts down VisData
    '------------------------------------------------------------
  
    On Error Resume Next
    
    Dim nRet As Integer
    
    'save all the current INI file settings
    SaveINISettings
    
    '  If gbDBChanged Then
    '    If MsgBox(MSG32, vbYesNo + vbQuestion) = vbYes Then
    '      gwsMainWS.CommitTrans
    '    End If
    '  End If

    ' *** 05-12-2005 SH Added
    ' Call the stored procedure to syncronize the system tables
    ' (Canada and US) before closing.
            
    ' Set up a Command Structure
    With gCmd
        .CommandType = adCmdStoredProc
        .CommandText = "dbo.DTM_SyncSystemTables"
    End With

    ' Set the following as input parameter:
    '   Employee_id INT
    gCmd.Parameters.Append gCmd.CreateParameter("Employee_id", adInteger, _
    adParamInput, , employeeID)

    'gCmd.Parameters.Append gCmd.CreateParameter("ResultMSG", adVarChar, _
    'adParamOutput, 100)
           
    gCmd.ActiveConnection = gCN
    gCmd.Execute

    'MsgBox gCmd.Parameters("ResultMSG").Value

    UnloadAllForms
    '  gwsmainws.databases(0).Close
    'close the help file
    nRet = OSWinHelp(frmMDI.hwnd, App.HelpFile, HelpConstants.cdlHelpQuit, 0)
    
    End
End Sub

Sub NewMDB(rnVersion As Integer)
    On Error GoTo NewAccErr
    
    Dim sNewName As String
    Dim db As Database
    
    'get file name to compact to
    frmMDI.dlgCMD1.DialogTitle = MSG55
    frmMDI.dlgCMD1.FilterIndex = 1
    frmMDI.dlgCMD1.Filter = MSG49
    frmMDI.dlgCMD1.FileName = vbNullString
    frmMDI.dlgCMD1.CancelError = True
    frmMDI.dlgCMD1.Flags = FileOpenConstants.cdlOFNOverwritePrompt + FileOpenConstants.cdlOFNHideReadOnly
    frmMDI.dlgCMD1.ShowSave
    
    If Len(frmMDI.dlgCMD1.FileName) > 0 Then
        sNewName = frmMDI.dlgCMD1.FileName
        If InStr(sNewName, ".") = 0 Then
            'add an extension if the user didn't supply one
            sNewName = sNewName & ".MDB"
        End If
        If Dir(sNewName) <> vbNullString Then
            Kill sNewName
        End If
    Else
        Exit Sub
    End If
    
    If Len(sNewName) = 0 Then Exit Sub
    
    Set db = CreateDatabase(sNewName, dbLangGeneral, rnVersion)
    db.Close
    
    gsDataType = gsMSACCESS
    gsDBName = sNewName
    OpenLocalDB True
    Exit Sub

NewAccErr:
    If Err <> 32755 Then         'user cancelled
        ShowError
    End If
End Sub

Sub Export(rsFromTbl As String, rsToDB As String)
    On Error GoTo ExpErr
    
    Dim sConnect As String
    Dim sNewTblName As String
    Dim sDBName As String
    Dim nErrState As Integer
    Dim idxFrom As Index
    Dim idxTo As Index
    Dim sSQL As String              'local copy of sql string
    Dim sField As String
    Dim sFrom As String
    Dim sTmp As String
    Dim i As Integer
    
    If gnDataType = gnDT_SQLDB Then
       Set gExpDB = gwsMainWS.OpenDatabase(vbNullString, 0, 0, "odbc;")
       If gExpDB Is Nothing Then Exit Sub
    End If
    
    MsgBar MSG56 & "'" & rsFromTbl & "'", True
    
    nErrState = 1
    
    Select Case gnDataType
        Case gnDT_MSACCESS
            sConnect = "[;database=" & rsToDB & "]."
            Set gExpDB = gwsMainWS.OpenDatabase(rsToDB)
        Case gnDT_PARADOX3X
            sDBName = StripFileName(rsToDB)
            sConnect = "[Paradox 3.X;database=" & StripFileName(rsToDB) & "]."
            Set gExpDB = gwsMainWS.OpenDatabase(sDBName, 0, 0, gsPARADOX3X)
        Case gnDT_PARADOX4X
            sDBName = StripFileName(rsToDB)
            sConnect = "[Paradox 4.X;database=" & StripFileName(rsToDB) & "]."
            Set gExpDB = gwsMainWS.OpenDatabase(sDBName, 0, 0, gsPARADOX4X)
        Case gnDT_FOXPRO26
            sDBName = StripFileName(rsToDB)
            sConnect = "[FoxPro 2.6;database=" & StripFileName(rsToDB) & "]."
            Set gExpDB = gwsMainWS.OpenDatabase(sDBName, 0, 0, gsFOXPRO26)
        Case gnDT_FOXPRO25
            sDBName = StripFileName(rsToDB)
            sConnect = "[FoxPro 2.5;database=" & StripFileName(rsToDB) & "]."
            Set gExpDB = gwsMainWS.OpenDatabase(sDBName, 0, 0, gsFOXPRO25)
        Case gnDT_FOXPRO20
            sDBName = StripFileName(rsToDB)
            sConnect = "[FoxPro 2.0;database=" & StripFileName(rsToDB) & "]."
            Set gExpDB = gwsMainWS.OpenDatabase(sDBName, 0, 0, gsFOXPRO20)
        Case gnDT_DBASEIV
            sDBName = StripFileName(rsToDB)
            sConnect = "[dBase IV;database=" & StripFileName(rsToDB) & "]."
            Set gExpDB = gwsMainWS.OpenDatabase(sDBName, 0, 0, gsDBASEIV)
        Case gnDT_DBASEIII
            sDBName = StripFileName(rsToDB)
            sConnect = "[dBase III;database=" & StripFileName(rsToDB) & "]."
            Set gExpDB = gwsMainWS.OpenDatabase(sDBName, 0, 0, gsDBASEIII)
        Case gnDT_BTRIEVE
            sConnect = "[Btrieve;database=" & rsToDB & "]."
            Set gExpDB = gwsMainWS.OpenDatabase(rsToDB, 0, 0, gsBTRIEVE)
        Case gnDT_EXCEL50, gnDT_EXCEL40, gnDT_EXCEL30
            sConnect = "[Excel 5.0;database=" & rsToDB & "]."
            Set gExpDB = gwsMainWS.OpenDatabase(rsToDB, 0, 0, gsEXCEL50)
        Case gnDT_SQLDB
            sConnect = "[" & gExpDB.Connect & "]."
        Case gnDT_TEXTFILE
            sDBName = StripFileName(rsToDB)
            sConnect = "[Text;database=" & StripFileName(rsToDB) & "]."
            Set gExpDB = gwsMainWS.OpenDatabase(sDBName, 0, 0, gsTEXTFILES)
    End Select
     
    If gnDataType = gnDT_MSACCESS Or gnDataType = gnDT_BTRIEVE Or _
        gnDataType = gnDT_SQLDB Or gnDataType = gnDT_EXCEL50 Or _
        gnDataType = gnDT_EXCEL40 Or gnDataType = gnDT_EXCEL30 Then
        With frmExpName
            .Label1.Caption = MSG57 & rsFromTbl & " ->"
            .Label2.Caption = MSG58 & rsToDB
            .txtTable.Text = rsFromTbl
        End With
        frmExpName.Show vbModal
         
        If Len(gExpTable) = 0 Then
            MsgBar vbNullString, False
            Exit Sub
        Else
            sNewTblName = gExpTable
        End If
    Else
        'get the table part of the file name
        'strip off the path
        For i = Len(rsToDB) To 1 Step -1
            If Mid(rsToDB, i, 1) = "\" Then
                Exit For
            End If
        Next
        sTmp = Mid(rsToDB, i + 1, Len(rsToDB))
        'strip off the extension
        For i = 1 To Len(sTmp)
            If Mid(sTmp, i, 1) = "." Then
                Exit For
            End If
        Next
        sNewTblName = Left(sTmp, i - 1)
    End If
    
    Screen.MousePointer = vbHourglass
    
    If Len(rsFromTbl) > 0 Then
        gwsMainWS.Databases(0).Execute "select * into " & sConnect & StripOwner(sNewTblName) & " from " & StripOwner(rsFromTbl)
        
        If gnDataType <> gnDT_TEXTFILE Then
            nErrState = 2
            MsgBar MSG59 & " '" & sNewTblName & "'", True
            gExpDB.TableDefs.Refresh
            For Each idxFrom In gwsMainWS.Databases(0).TableDefs(rsFromTbl).Indexes
                Set idxTo = gExpDB.TableDefs(sNewTblName).CreateIndex(idxFrom.Name)
                With idxTo
                    .Fields = idxFrom.Fields
                    .Unique = idxFrom.Unique
                    If gnDataType <> gnDT_SQLDB And gsDataType <> "ODBC" Then
                        .Primary = idxFrom.Primary
                    End If
                End With
                gExpDB.TableDefs(sNewTblName).Indexes.Append idxTo
            Next
        End If
        MsgBar vbNullString, False
        Screen.MousePointer = vbDefault
        MsgBox MSG60 & " '" & rsFromTbl & "'", 64
    Else
        sSQL = frmSQL.txtSQLStatement.Text
        sField = Mid(sSQL, 8, InStr(8, UCase(sSQL), "FROM") - 9)
        sFrom = " " & Mid(sSQL, InStr(UCase(sSQL), "FROM"), Len(sSQL))
        gwsMainWS.Databases(0).Execute "select " & sField & " into " & sConnect & sNewTblName & sFrom
        
        Screen.MousePointer = vbDefault
        MsgBar vbNullString, False
        MsgBox MSG61, 64
    End If
    
    Exit Sub
    
ExpErr:
    If Err = 3010 Then      'table exists
        If MsgBox(MSG62, 32 + 1 + 256) = 1 Then
            gExpDB.TableDefs.Delete sNewTblName
            Resume
        Else
            Screen.MousePointer = vbDefault
            MsgBar vbNullString, False
            Exit Sub
        End If
    End If
    
    'nuke the new table if the indexes couldn't be created
    If nErrState = 2 Then
      gExpDB.TableDefs.Delete sNewTblName
    End If
    ShowError

End Sub

Sub Import(rsImpTblName As String)
    On Error GoTo ImpErr
    
    Dim sOldTblName As String, sNewTblName As String, sConnect As String
    Dim idxFrom As Index
    Dim idxTo As Index
    Dim nErrState As Integer
    Dim i As Integer
    
    sOldTblName = MakeTableName(rsImpTblName, False)
    sNewTblName = MakeTableName(rsImpTblName, True)
    
    Screen.MousePointer = vbHourglass
    MsgBar MSG63 & "'" & sNewTblName & "'", True
    
    nErrState = 1
    Select Case gnDataType
        Case gnDT_MSACCESS
            sConnect = "[;database=" & gImpDB.Name & "]."
        Case gnDT_PARADOX3X
            sConnect = "[Paradox 3.X;database=" & StripFileName(rsImpTblName) & "]."
            Set gImpDB = gwsMainWS.OpenDatabase(StripFileName(rsImpTblName), 0, 0, gsPARADOX3X)
        Case gnDT_PARADOX4X
            sConnect = "[Paradox 4.X;database=" & StripFileName(rsImpTblName) & "]."
            Set gImpDB = gwsMainWS.OpenDatabase(StripFileName(rsImpTblName), 0, 0, gsPARADOX4X)
        Case gnDT_FOXPRO26
            sConnect = "[FoxPro 2.6;database=" & StripFileName(rsImpTblName) & "]."
            Set gImpDB = gwsMainWS.OpenDatabase(StripFileName(rsImpTblName), 0, 0, gsFOXPRO26)
        Case gnDT_FOXPRO25
            sConnect = "[FoxPro 2.5;database=" & StripFileName(rsImpTblName) & "]."
            Set gImpDB = gwsMainWS.OpenDatabase(StripFileName(rsImpTblName), 0, 0, gsFOXPRO25)
        Case gnDT_FOXPRO20
            sConnect = "[FoxPro 2.0;database=" & StripFileName(rsImpTblName) & "]."
            Set gImpDB = gwsMainWS.OpenDatabase(StripFileName(rsImpTblName), 0, 0, gsFOXPRO20)
        Case gnDT_DBASEIV
            sConnect = "[dBase IV;database=" & StripFileName(rsImpTblName) & "]."
            Set gImpDB = gwsMainWS.OpenDatabase(StripFileName(rsImpTblName), 0, 0, gsDBASEIV)
        Case gnDT_DBASEIII
            sConnect = "[dBase III;database=" & StripFileName(rsImpTblName) & "]."
            Set gImpDB = gwsMainWS.OpenDatabase(StripFileName(rsImpTblName), 0, 0, gsDBASEIII)
        Case gnDT_BTRIEVE
            sConnect = "[Btrieve;database=" & gImpDB.Name & "]."
        Case gnDT_EXCEL50, gnDT_EXCEL40, gnDT_EXCEL30
            sConnect = "[Excel 5.0;database=" & gImpDB.Name & "]."
        Case gnDT_SQLDB
            sConnect = "[" & gImpDB.Connect & "]."
        Case gnDT_TEXTFILE
            sConnect = "[Text;database=" & StripFileName(rsImpTblName) & "]."
            Set gImpDB = gwsMainWS.OpenDatabase(StripFileName(rsImpTblName), 0, 0, gsTEXTFILES)
    End Select
    
    gwsMainWS.Databases(0).Execute "select * into " & sNewTblName & " from " & sConnect & sOldTblName
    
    If gnDataType <> gnDT_TEXTFILE And gnDataType <> gnDT_EXCEL50 And _
        gnDataType <> gnDT_EXCEL40 And gnDataType <> gnDT_EXCEL30 Then
        nErrState = 2
        MsgBar gwsMainWS.Databases(0).RecordsAffected & " Rows Imported, Creating Indexes for '" & sNewTblName & "'", True
        gwsMainWS.Databases(0).TableDefs.Refresh
        For Each idxFrom In gImpDB.TableDefs(sOldTblName).Indexes
            Set idxTo = gwsMainWS.Databases(0).TableDefs(sNewTblName).CreateIndex(idxFrom.Name)
            With idxTo
                .Fields = idxFrom.Fields
                .Unique = idxFrom.Unique
                If gnDataType <> gnDT_SQLDB And gsDataType <> gsSQLDB Then
                    .Primary = idxFrom.Primary
                End If
            End With
            gwsMainWS.Databases(0).TableDefs(sNewTblName).Indexes.Append idxTo
        Next
    End If
      
    frmImpExp.lstTables.AddItem sNewTblName
    '  frmTables.lstTables.AddItem sNewTblName
    Screen.MousePointer = vbDefault
    MsgBar vbNullString, False
    MsgBox MSG64 & "'" & sNewTblName & "'.", 64
    
    Exit Sub
    
NukeNewTbl:
    On Error Resume Next  'just in case it fails
    gwsMainWS.Databases(0).TableDefs.Delete sNewTblName
    ShowError
    Exit Sub
    
ImpErr:
    'nuke the new table if the indexes couldn't be created
    If nErrState = 2 Then
      Resume NukeNewTbl
    End If
    ShowError
End Sub

Function MakeTableName(fname As String, newname As Integer) As String
    On Error Resume Next
    
    Dim i As Integer, t As Integer
    Dim tmp As String
    
    If gnDataType = gnDT_SQLDB And newname Then
        i = InStr(1, fname, ".")
        If i > 0 Then
            tmp = Mid(fname, 1, i - 1) & "_" & Mid(fname, i + 1, Len(fname))
        End If
    ElseIf InStr(fname, "\") > 0 Then
        'strip off path
        For i = Len(fname) To 1 Step -1
            If Mid(fname, i, 1) = "\" Then
                Exit For
            End If
        Next
        tmp = Mid(fname, i + 1, Len(fname))
        i = InStr(1, tmp, ".")
        If i > 0 Then
            tmp = Mid(tmp, 1, i - 1)
        End If
    Else
        tmp = fname
    End If
    
    If newname Then
        If DupeTableName(tmp) Then
            t = 1
            While DupeTableName(tmp + CStr(t))
                t = t + 1
            Wend
            tmp = tmp + CStr(t)
        End If
    End If
    
    MakeTableName = tmp
End Function
