VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FileSystemAPI"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Public Function FileCopy(pstrSourceFile As String, pstrDestFile As String) As Boolean
    On Error GoTo FileCopyError
    FileCopy = True
    If CheckSpace(pstrSourceFile, pstrDestFile) Then
        VBA.FileCopy pstrSourceFile, pstrDestFile
    Else
        MsgBox "Out of disk space, unable to copy file " & pstrDestFile, _
                    vbOKOnly, _
                    "Copying File"
        Err.Raise vbObjectError + 20000, "FileSystemAPI.FileCopy", "Out of disk space"
    End If
    Return
FileCopyError:
    FileCopy = False
    MsgBox Err.Description, vbOKOnly, "Copying File"
End Function

Public Function CheckSpace(pstrSourceFile As String, pstrDestFile As String) As Boolean
    Dim strPathName As String
    Dim lngSlashPos As Long
    Dim lngSectorsPerCluster As Long
    Dim lngBytesPerSector As Long
    Dim lngNumberOfFreeClusters As Long
    Dim lngTotalNumberOfClusters As Long
    Dim lngFileSize As Long
    
    On Error GoTo CheckSpaceError
    CheckSpace = False
    lngFileSize = VBA.FileLen(pstrSourceFile)
    lngSlashPos = InStr(1, pstrDestFile, "/", vbTextCompare)
    Do While InStr(lngSlashPos + 1, pstrDestFile, "/", vbTextCompare) > 0
        lngSlashPos = InStr(lngSlashPos + 1, pstrDestFile, "/", vbTextCompare)
    Loop
    
    If lngSlashPos <= 0 Then
        strPathName = ""
    Else
        strPathName = Mid(plng.pstrDestFile, 1, lngSlashPos - 1)
    End If
    
    GetDiskFreeSpace strPathName, _
                lngSectorsPerCluster, _
                lngBytesPerSector, _
                lngNumberOfFreeClusters, _
                lngTotalNumberOfClusters
    If lngFileSize < (lngBytesPerSector * lngSectorsPerCluster * lngNumberOfFreeClusters) Then
        CheckSpace = True
    End If
CheckSpaceError:
                
End Function
