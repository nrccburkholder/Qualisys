Attribute VB_Name = "modRegistrySettings"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright � National Research Corporation
'\\
'\\ File Name:      RegistrySettings.bas
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   09-06-2000
'\\
'\\ Description:    This file contains the code required to read in all
'\\                 of the registry settings for this application.
'\\
'\\ Required References:
'\\     GalaxySoft Registration DB OLE Server 98 (GSRegSrv.dll)
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     03-07-02    JJF     Added registry objects for the database
'\\                         connections.
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    Private Const mksRegBase As String = "Software\National Research\Imported Not Transfered"
    Public Const gksRegFormLocations As String = mksRegBase & "\Form Locations"
    Public Const gksRegQueries As String = mksRegBase & "\Queries"
    
    Private Const mksRegDatabaseInfo As String = "Software\National Research\Database Info"
    
    Private Const mksRegMainDBDefault As String = "driver={SQL Server};server=NRC10;UID=qpsa;PWD=qpsa;database=QP_PROD"
    
    Public goRegMainDBConnString As RegDBServer98.RegStr
    
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright � National Research Corporation
'\\
'\\ Routine Name:   ReadRegistry
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    This routine reads the required registry settings
'\\                 for this application.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub ReadRegistry()
    
    Set goRegMainDBConnString = New RegDBServer98.RegStr
    goRegMainDBConnString.Register sSection:=mksRegDatabaseInfo, _
                                   sKey:="Main DB Conn String", _
                                   lHKey:=gsrsHKEYLocalMachine, _
                                   sDefault:=mksRegMainDBDefault
    
End Sub


