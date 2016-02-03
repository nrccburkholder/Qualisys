Imports PS.Framework.Configuration
Imports System.Configuration

Public Class Config

#Region " EnvironmentSettings Properties "


    Protected Shared mSettings As PS.Framework.Configuration.EnvironmentSettings = Nothing

    Private Shared ReadOnly Property Settings() As EnvironmentSettings
        Get
            If mSettings Is Nothing Then
                mSettings = DirectCast(ConfigurationManager.GetSection("EnvironmentSettings"), PS.Framework.Configuration.EnvironmentSettings)
            End If
            Return mSettings
        End Get
    End Property

    Public Shared ReadOnly Property EnvironmentName() As String
        Get
            Return Settings.CurrentEnvironment.Name
        End Get
    End Property

    Private Shared ReadOnly Property CurrentEnvironment() As PS.Framework.Configuration.Environment
        Get
            Return Settings.CurrentEnvironment
        End Get
    End Property
#End Region

#Region " Custom Configuration Properties "
    Public Shared ReadOnly Property Printer() As String
        Get
            Return Settings.GlobalSettings("Printer").Value
        End Get
    End Property
    Public Shared ReadOnly Property TempPath() As String
        Get
            Return Settings.GlobalSettings("TempPath").Value
        End Get
    End Property
    Public Shared ReadOnly Property SqlTimeout() As Long
        Get
            Return CLng(Settings.GlobalSettings("SqlTimeout").Value)
        End Get
    End Property
    Public Shared ReadOnly Property BundlingReport() As String
        Get
            Return CurrentEnvironment.Settings("BundlingReport").Value
        End Get
    End Property
    Public Shared ReadOnly Property MergeQueueStatus() As String
        Get
            Return CurrentEnvironment.Settings("MergeQueueStatus").Value
        End Get
    End Property
    Public Shared ReadOnly Property SmtpServer() As String
        Get
            Return CurrentEnvironment.Settings("SmtpServer").Value
        End Get
    End Property
    Public Shared ReadOnly Property TransferPath() As String
        Get
            Return CurrentEnvironment.Settings("TransferPath").Value
        End Get
    End Property
    Public Shared ReadOnly Property DefaultTransferPath() As String
        Get
            Return CurrentEnvironment.Settings("DefaultTransferPath").Value
        End Get
    End Property
    Public Shared ReadOnly Property DefaultDocPath() As String
        Get
            Return CurrentEnvironment.Settings("DefaultDocPath").Value
        End Get
    End Property
    Public Shared ReadOnly Property DefaultDataPath() As String
        Get
            Return CurrentEnvironment.Settings("DefaultDataPath").Value
        End Get
    End Property
    Public Shared ReadOnly Property ReportServer() As String
        Get
            Return CurrentEnvironment.Settings("ReportServer").Value
        End Get
    End Property
    Public Shared ReadOnly Property TestDBConnection() As String
        Get
            Return CurrentEnvironment.Settings("TestDBConnection").Value
        End Get
    End Property
#End Region

End Class
