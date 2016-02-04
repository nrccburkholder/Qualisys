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
    Public Shared ReadOnly Property SqlTimeout() As Long
        Get
            Return CLng(Settings.GlobalSettings("SqlTimeout").Value)
        End Get
    End Property
    Public Shared ReadOnly Property RecordsPerSubJob() As Integer
        Get
            Return CInt(Settings.GlobalSettings("RecordsPerSubJob").Value)
        End Get
    End Property
    Public Shared ReadOnly Property SmtpServer() As String
        Get
            Return CurrentEnvironment.Settings("SmtpServer").Value
        End Get
    End Property    
    Public Shared ReadOnly Property ReportServer() As String
        Get
            Return CurrentEnvironment.Settings("ReportServer").Value
        End Get
    End Property
    Public Shared ReadOnly Property MergePath() As String
        Get
            Return CurrentEnvironment.Settings("MergePath").Value
        End Get
    End Property
    Public Shared ReadOnly Property PrintPath() As String
        Get
            Return CurrentEnvironment.Settings("PrintPath").Value
        End Get
    End Property
    Public Shared ReadOnly Property TempMergePath() As String
        Get
            Return CurrentEnvironment.Settings("TempMergePath").Value
        End Get
    End Property
    Public Shared ReadOnly Property TempDocPath() As String
        Get
            Return CurrentEnvironment.Settings("TempDocPath").Value
        End Get
    End Property
    Public Shared ReadOnly Property TempPrintPath() As String
        Get
            Return CurrentEnvironment.Settings("TempPrintPath").Value
        End Get
    End Property
#End Region

End Class

