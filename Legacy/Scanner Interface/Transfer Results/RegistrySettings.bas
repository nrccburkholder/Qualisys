Attribute VB_Name = "modRegistrySettings"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      RegistrySettings.bas
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    This file contains the code required to read in all
'\\                 of the registry settings for this application.
'\\
'\\ Required References:
'\\     GalaxySoft Registration DB OLE Server 98 (GSRegSrv.dll)
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\     10-31-05    JJF     Added key for ReceiptType
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit

    Private Const mksRegDatabaseInfo As String = "Software\National Research\Database Info"
    Private Const mksRegMainDBDefault As String = "driver={SQL Server};server=NRC10;UID=qpsa;PWD=qpsa;database=QP_PROD"
    Public goRegMainDBConnString As RegDBServer98.RegStr
    
    Private Const mksRegBase As String = "Software\National Research\TransferResults"
    Private Const mklRegReceiptTypeCommentDefault As Long = 1
    Private Const mklRegReceiptTypeSurveyDefault As Long = 17
    Public goRegReceiptTypeComment As RegDBServer98.RegLng
    Public goRegReceiptTypeSurvey As RegDBServer98.RegLng
    
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
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
'\\     10-31-05    JJF     Added key for ReceiptType
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Sub ReadRegistry()
    
    Set goRegMainDBConnString = New RegDBServer98.RegStr
    goRegMainDBConnString.Register sSection:=mksRegDatabaseInfo, _
                                   sKey:="Main DB Conn String", _
                                   lHKey:=gsrsHKEYLocalMachine, _
                                   sDefault:=mksRegMainDBDefault
    
    Set goRegReceiptTypeComment = New RegDBServer98.RegLng
    goRegReceiptTypeComment.Register sSection:=mksRegBase, _
                                     sKey:="Comment Receipt Type ID", _
                                     lHKey:=gsrsHKEYLocalMachine, _
                                     lDefault:=mklRegReceiptTypeCommentDefault
    
    Set goRegReceiptTypeSurvey = New RegDBServer98.RegLng
    goRegReceiptTypeSurvey.Register sSection:=mksRegBase, _
                                    sKey:="Survey Receipt Type ID", _
                                    lHKey:=gsrsHKEYLocalMachine, _
                                    lDefault:=mklRegReceiptTypeSurveyDefault
    
End Sub


