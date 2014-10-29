Attribute VB_Name = "modRegistrySettings"
Option Explicit
    
    'Registry Constants
    Public Const gksRegSectionBase      As String = "Software\National Research\CommentAdmin"
    Public Const gksRegSectionForms     As String = gksRegSectionBase & "\Form Locations"
    
    Private Const mksRegDatabaseInfo    As String = "Software\National Research\Database Info"                                '** Added 04-26-02 JJF
    Private Const mksRegMainDBDefault   As String = "driver={SQL Server};server=NRC10;UID=qpsa;PWD=qpsa;database=QP_PROD"     '** Added 04-26-02 JJF
    Private Const mksRegHCMGDBDefault   As String = "driver={SQL Server};server=NRC16;UID=qpsa;PWD=qpsa;database=HCMG_Dev"    '** Added 03-10-04 JJF
    Private Const mksRegDMartDBDefault  As String = "driver={SQL Server};server=Medusa;UID=qpsa;PWD=qpsa;database=QP_Comments"     '** Added 09-29-05 JJF
    
    Public goRegMainDBConnString    As RegDBServer98.RegStr    '** Added 04-26-02 JJF
    Public goRegHCMGDBConnString    As RegDBServer98.RegStr    '** Added 03-10-04 JJF
    Public goRegDMartDBConnString   As RegDBServer98.RegStr    '** Added 09-29-05 JJF
    
    
    
    
    
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   ReadRegistry
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-26-2002
'\\
'\\ Description:    This routine reads the required registry settings
'\\                 for this application.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     03-10-04    JJF     Added the HCMG Refresh Lookup option.
'\\     09-29-05    JJF     Added the datamart connection.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub ReadRegistry()
    
    Set goRegMainDBConnString = New RegDBServer98.RegStr
    goRegMainDBConnString.Register sSection:=mksRegDatabaseInfo, _
                                   sKey:="Main DB Conn String", _
                                   lHKey:=gsrsHKEYLocalMachine, _
                                   sDefault:=mksRegMainDBDefault
    
    '** Added 03-10-04 JJF
    Set goRegHCMGDBConnString = New RegDBServer98.RegStr
    goRegHCMGDBConnString.Register sSection:=mksRegDatabaseInfo, _
                                   sKey:="HCMG DB Conn String", _
                                   lHKey:=gsrsHKEYLocalMachine, _
                                   sDefault:=mksRegHCMGDBDefault
    '** End of add 03-10-04 JJF
    
    '** Added 09-29-05 JJF
    Set goRegDMartDBConnString = New RegDBServer98.RegStr
    goRegDMartDBConnString.Register sSection:=mksRegDatabaseInfo, _
                                    sKey:="DataMart DB Conn String", _
                                    lHKey:=gsrsHKEYLocalMachine, _
                                    sDefault:=mksRegDMartDBDefault
    '** End of add 09-29-05 JJF
    
End Sub

