Imports Nrc.Framework.Configuration

Namespace Legacy
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
        Public Shared ReadOnly Property DataMartConnection() As String
            Get
                Return Settings("DataMartConnection")
            End Get
        End Property

        Public Shared ReadOnly Property SqlTimeout() As Integer
            Get
                Return Integer.Parse(Settings("SqlTimeout"))
            End Get
        End Property

#End Region

    End Class
End Namespace
