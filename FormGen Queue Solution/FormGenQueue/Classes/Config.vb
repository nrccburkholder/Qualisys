Imports Nrc.Framework.BusinessLogic.Configuration
Public Class Config

#Region " EnvironmentSettings Properties "
    Public Shared ReadOnly Property EnvironmentType() As EnvironmentTypes
        Get
            Return AppConfig.EnvironmentType
        End Get
    End Property

    Public Shared ReadOnly Property EnvironmentName() As String
        Get
            Return AppConfig.EnvironmentName
        End Get
    End Property
#End Region

#Region " Custom Configuration Properties "


#End Region

End Class
