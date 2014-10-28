Attribute VB_Name = "modRegistrySettings"
Option Explicit

    Private Const mkstrRegDatabaseInfo As String = "Software\National Research\Database Info"
    
    Private Const mkstrRegMainDBDefault As String = "driver={SQL Server};server=NRC10;UID=qpsa;PWD=qpsa;database=QP_PROD"
    Private Const mkstrRegHCMGDBDefault As String = "driver={SQL Server};server=NRC16;UID=qpsa;PWD=qpsa;database=HCMG_Dev"
    
    Public gobjRegMainDBConnString As RegDBServer98.RegStr
    Public gobjRegHCMGDBConnString As RegDBServer98.RegStr

Public Sub ReadRegistry()
    
    Set gobjRegMainDBConnString = New RegDBServer98.RegStr
    gobjRegMainDBConnString.Register sSection:=mkstrRegDatabaseInfo, _
                                     sKey:="Main DB Conn String", _
                                     lHKey:=gsrsHKEYLocalMachine, _
                                     sDefault:=mkstrRegMainDBDefault
    
    Set gobjRegHCMGDBConnString = New RegDBServer98.RegStr
    gobjRegHCMGDBConnString.Register sSection:=mkstrRegDatabaseInfo, _
                                     sKey:="HCMG DB Conn String", _
                                     lHKey:=gsrsHKEYLocalMachine, _
                                     sDefault:=mkstrRegHCMGDBDefault
    
End Sub


Public Sub CloseRegistry()
    
    Set gobjRegMainDBConnString = Nothing
    Set gobjRegHCMGDBConnString = Nothing
    
End Sub


