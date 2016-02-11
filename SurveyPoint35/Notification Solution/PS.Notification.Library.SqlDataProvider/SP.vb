Public Class SP
    Public Shared ReadOnly InsertEmailQueue As String = "dbo.PS_InsertEmailQueue"
    Public Shared ReadOnly GetTop50EmailsToSend As String = "dbo.PS_GetTop50EmailsToSend"
    Public Shared ReadOnly PingSurveyAdminDB As String = "dbo.PS_PingSurveyAdminDB"
    Public Shared ReadOnly RecordSent As String = "dbo.PS_RecordEmailSent"
End Class
