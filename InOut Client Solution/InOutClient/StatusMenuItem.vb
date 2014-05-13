Imports Nrc.InOutClient.InOutService

Public Class StatusMenuItem
    Inherits MenuItem

    Private mStatus As StatusInfo

    Public ReadOnly Property Status() As StatusInfo
        Get
            Return mStatus
        End Get
    End Property

    Sub New(ByVal text As String)
        MyBase.New(text)
    End Sub
    Sub New(ByVal text As String, ByVal onClick As EventHandler)
        MyBase.New(text, onClick)
    End Sub
    Sub New(ByVal text As String, ByVal onClick As EventHandler, ByVal status As StatusInfo)
        MyBase.New(text, onClick)
        mStatus = status
    End Sub

End Class
