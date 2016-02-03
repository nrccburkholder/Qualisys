Option Strict On

Public Class clsPersistedJobStorage

    Public Const JOB_NOT_FOUND As Integer = clsJobStatus.JOB_NOT_FOUND
    Private Shared oHT As Hashtable = New Hashtable()
    Private Shared oLock As Object = New Object()


    Public Shared Sub SetJobStorageValue(ByVal sJobID As String, ByVal sPropertyKey As String, ByVal oData As Object)
        Dim oPropertyBag As Hashtable

        SyncLock oLock
            If oHT.ContainsKey(sJobID) Then
                oPropertyBag = CType(oHT(sJobID), Hashtable)
            Else
                oPropertyBag = New Hashtable()
                oHT(sJobID) = oPropertyBag
            End If

            oPropertyBag(sPropertyKey) = oData
        End SyncLock
    End Sub

    Public Shared Function GetJobStorageValue(ByVal sJobID As String, ByVal sPropertyKey As String) As Object
        'base method
        Dim oData As Object = Nothing

        SyncLock oLock
            If oHT.ContainsKey(sJobID) Then
                Dim oPropertyBag As Hashtable = CType(oHT(sJobID), Hashtable)
                If (oPropertyBag.ContainsKey(sPropertyKey)) Then
                    oData = oPropertyBag(sPropertyKey)
                End If
            End If
        End SyncLock

        Return oData
    End Function

    Public Shared Sub RemoveJobStorageValue(ByVal sJobID As String, ByVal sPropertyKey As String)
        SyncLock oLock
            If oHT.ContainsKey(sJobID) Then
                Dim oPropertyBag As Hashtable = CType(oHT(sJobID), Hashtable)

                If (oPropertyBag.ContainsKey(sPropertyKey)) Then
                    oPropertyBag.Remove(sPropertyKey)
                End If

                If (oPropertyBag.Count < 1) Then
                    oHT.Remove(sJobID)
                End If
            End If
        End SyncLock
    End Sub

    Public Shared Sub ClearJobStorage(ByVal sJobID As String)
        SyncLock oLock
            If oHT.ContainsKey(sJobID) Then
                oHT.Remove(sJobID)
            End If
        End SyncLock
    End Sub
End Class
