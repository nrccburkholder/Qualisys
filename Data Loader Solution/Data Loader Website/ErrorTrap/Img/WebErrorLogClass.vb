Imports System.Web.mail
Imports NRC.DataLoader.WebErrorLogClass
Imports Log = NRC.NRCAuthLib.SecurityLog
Imports Nrc.NRCAuthLib.FormsAuth

Public Class WebErrorLogClass
    Inherits PublicMemberLibrary

    Public Shared Function StartLog(ByVal ex As Exception) As String
        Dim Status As String = ""
        Dim ExceptionCheck As New Exception
        Try
            PublishException(ex)
        Catch exc As Exception
            ExceptionCheck = exc
        End Try
        If Len(ExceptionCheck.ToString) > 0 Then
            Status = ExceptionCheck.ToString
        Else
            Status = "Logged"
        End If
        Return Status
    End Function


#Region " Private Properties "
    Private ReadOnly Property LogEvents() As Boolean
        Get
            Return True
        End Get
    End Property
#End Region

    'Logs an exception to the Exception Manager.
    Private Shared Sub PublishException(ByVal ex As Exception)
        'Create a NV Collection of "Additional Info."
        If IsAuthenticated Then
            Log.LogWebException(mUserName, mSessionID, mSiteFriendlyNames, mURL, mPageName, mHandled, ex.Message, ex.GetType.ToString, ex.StackTrace)
        Else
            Log.LogWebException("", mSessionID, mSiteFriendlyNames, mURL, mPageName, mHandled, ex.Message, ex.GetType.ToString, ex.StackTrace)
        End If
    End Sub
End Class
