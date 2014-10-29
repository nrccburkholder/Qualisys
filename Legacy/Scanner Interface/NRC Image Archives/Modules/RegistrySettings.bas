Attribute VB_Name = "modRegistrySettings"
Option Explicit
    
    Private Const mksRegBase            As String = "Software\National Research\NRC Image Archives"
    Public Const gksRegFormLocations    As String = mksRegBase & "\Form Locations"
    
    '** Added 03-07-02 JJF
    Private Const mksRegDatabaseInfo As String = "Software\National Research\Database Info"
    Private Const mksRegMainDBDefault As String = "driver={SQL Server};server=NRC10;UID=qpsa;PWD=qpsa;database=QP_PROD"
    Public goRegMainDBConnString As RegDBServer98.RegStr
    '** End of add 03-07-02 JJF
    
    '** Removed 03-07-02 JJF
    'Private Const mksDefDatabaseConnect         As String = "driver={SQL Server};SERVER=NRC10;UID=qpsa;PWD=qpsa;DATABASE=QP_PROD"
    'Public goRegDatabaseConnect As RegDBServer98.RegStr
    '** End of remove 03-07-02 JJF
    
    Private Const mksDefAdvancedSearchFromWhere As String = "FROM ImageArchive IA " & vbCrLf & "WHERE "
    
    Public goRegSearchMode              As RegDBServer98.RegLng
    Public goRegSimpleSearchField       As RegDBServer98.RegStr
    Public goRegSimpleSearchString      As RegDBServer98.RegStr
    Public goRegAdvancedSearchFromWhere As RegDBServer98.RegStr
    
    Public goRegBatchLocation   As RegDBServer98.RegStr
    Public goRegBatchCopyTo     As RegDBServer98.RegStr
    Public goRegBatchFileName   As RegDBServer98.RegStr
    Public goRegBatchFilePath   As RegDBServer98.RegStr
    
    Public goRegMainImageColWidths      As RegDBServer98.RegStr
    Public goRegMainRestoreColWidths    As RegDBServer98.RegStr
    
Public Sub InitRegistry()
    
    '** Added 03-07-02 JJF
    Set goRegMainDBConnString = New RegDBServer98.RegStr
    goRegMainDBConnString.Register sSection:=mksRegDatabaseInfo, _
                                   sKey:="Main DB Conn String", _
                                   lHKey:=gsrsHKEYLocalMachine, _
                                   sDefault:=mksRegMainDBDefault
    '** End of add 03-07-02 JJF
    
    '** Removed 03-07-02 JJF
    'Set goRegDatabaseConnect = New RegDBServer98.RegStr
    'goRegDatabaseConnect.Register sSection:=mksRegBase, _
    '                              sKey:="Database Connect", _
    '                              lHKey:=gsrsHKEYLocalMachine, _
    '                              sDefault:=mksDefDatabaseConnect
    '** End of remove 03-07-02 JJF
    
    Set goRegSearchMode = New RegDBServer98.RegLng
    goRegSearchMode.Register sSection:=mksRegBase, _
                             sKey:="Search Mode", _
                             lHKey:=gsrsHKEYLocalMachine, _
                             lDefault:=smcSimpleSearch
    
    Set goRegSimpleSearchField = New RegDBServer98.RegStr
    goRegSimpleSearchField.Register sSection:=mksRegBase, _
                                    sKey:="Simple Search Field", _
                                    lHKey:=gsrsHKEYLocalMachine, _
                                    sDefault:=""
    
    Set goRegSimpleSearchString = New RegDBServer98.RegStr
    goRegSimpleSearchString.Register sSection:=mksRegBase, _
                                     sKey:="Simple Search String", _
                                     lHKey:=gsrsHKEYLocalMachine, _
                                     sDefault:=""
    
    Set goRegAdvancedSearchFromWhere = New RegDBServer98.RegStr
    goRegAdvancedSearchFromWhere.Register sSection:=mksRegBase, _
                                          sKey:="Advanced Search From Where", _
                                          lHKey:=gsrsHKEYLocalMachine, _
                                          sDefault:=mksDefAdvancedSearchFromWhere
    
    Set goRegBatchLocation = New RegDBServer98.RegStr
    goRegBatchLocation.Register sSection:=mksRegBase, _
                                sKey:="Batch Location", _
                                lHKey:=gsrsHKEYLocalMachine, _
                                sDefault:=""
    
    Set goRegBatchCopyTo = New RegDBServer98.RegStr
    goRegBatchCopyTo.Register sSection:=mksRegBase, _
                              sKey:="Batch Copy To", _
                              lHKey:=gsrsHKEYLocalMachine, _
                              sDefault:=""
    
    Set goRegBatchFileName = New RegDBServer98.RegStr
    goRegBatchFileName.Register sSection:=mksRegBase, _
                                sKey:="Batch Filename", _
                                lHKey:=gsrsHKEYLocalMachine, _
                                sDefault:=""
    
    Set goRegBatchFilePath = New RegDBServer98.RegStr
    goRegBatchFilePath.Register sSection:=mksRegBase, _
                                sKey:="Batch File Path", _
                                lHKey:=gsrsHKEYLocalMachine, _
                                sDefault:=""
    
    Set goRegMainImageColWidths = New RegDBServer98.RegStr
    goRegMainImageColWidths.Register sSection:=gksRegFormLocations, _
                                     sKey:="frmMain lvwImage Column Widths", _
                                     lHKey:=gsrsHKEYLocalMachine, _
                                     sDefault:=""
    
    Set goRegMainRestoreColWidths = New RegDBServer98.RegStr
    goRegMainRestoreColWidths.Register sSection:=gksRegFormLocations, _
                                     sKey:="frmMain lvwRestore Column Widths", _
                                     lHKey:=gsrsHKEYLocalMachine, _
                                     sDefault:=""
    
End Sub


