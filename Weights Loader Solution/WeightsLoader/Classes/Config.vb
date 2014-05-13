Imports Nrc.Framework.Configuration
Public Class Config

#Region " EnvironmentSettings Properties "
    Protected Shared mSettings As EnvironmentSettings
    Private Shared ReadOnly Property Settings() As EnvironmentSettings
        Get
            If mSettings Is Nothing Then
                mSettings = EnvironmentSettings.LoadFromConfig
            End If
            Return mSettings
        End Get
    End Property
    Public Shared ReadOnly Property EnvironmentType() As EnvironmentType
        Get
            Return Settings.CurrentEnvironment.EnvironmentType
        End Get
    End Property

    Public Shared ReadOnly Property EnvironmentName() As String
        Get
            Return Settings.CurrentEnvironment.Name
        End Get
    End Property
#End Region

#Region " Custom Configuration Properties "
    Public Shared ReadOnly Property NrcAuthConnection() As String
        Get
            Return Settings("NrcAuthConnection")
        End Get
    End Property

    Public Shared ReadOnly Property SmtpServer() As String
        Get
            Return Settings("SmtpServer")
        End Get
    End Property
#End Region

End Class
