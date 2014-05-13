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

#Region " Environment Settings "
    'Gets the connection string associated with this environment
    'Separate connection strings are stored in web.config for each possible environment
    Public Shared ReadOnly Property QP_LoadConnection() As String
        Get
            Return Settings("QP_LoadConnection")
        End Get
    End Property
    Public Shared ReadOnly Property NrcAuthConnection() As String
        Get
            Return Settings("NrcAuthConnection")
        End Get
    End Property

    Public Shared ReadOnly Property SqlTimeout() As Integer
        Get
            Return Integer.Parse(Settings("SqlTimeout"))
        End Get
    End Property
    Public Shared ReadOnly Property PackageOwnersEmailGroup() As String
        Get
            Return Settings("PackageOwnersEmailGroup")
        End Get
    End Property

#End Region

End Class
