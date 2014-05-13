Imports Nrc.Framework.BusinessLogic.Configuration

Public Class Config


#Region " Environment Settings "
    'Gets the connection string associated with this environment
    'Separate connection strings are stored in web.config for each possible environment
    Public Shared ReadOnly Property QP_LoadConnection() As String
        Get
            Return AppConfig.QLoaderConnection
        End Get
    End Property

    Public Shared ReadOnly Property SqlTimeout() As Integer
        Get
            Return AppConfig.SqlTimeout
        End Get
    End Property

#End Region

End Class
