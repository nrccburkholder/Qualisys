Public Class SP
    Public Shared ReadOnly GetTop1PendingFromQueue As String = "dbo.MM_GetTop1PendingFromQueue"
    Public Shared ReadOnly PingMailMergeDB As String = "dbo.MM_PingMailMergeDB"
    Public Shared ReadOnly InsertMMFile As String = "dbo.MM_InsertMMFile"
    Public Shared ReadOnly InsertMMSubJob As String = "dbo.MM_InsertMMSubJob"
    Public Shared ReadOnly CompleteQueueJob As String = "dbo.MM_CompleteQueueJob"
End Class
