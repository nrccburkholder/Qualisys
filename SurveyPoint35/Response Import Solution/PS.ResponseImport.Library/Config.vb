﻿Imports PS.Framework.Configuration
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
    Public Shared ReadOnly Property SmtpServer() As String
        Get
            Return CurrentEnvironment.Settings("SmtpServer").Value
        End Get
    End Property
    Public Shared ReadOnly Property NrcAuthConnection() As String
        Get
            Return CurrentEnvironment.Settings("NrcAuthConnection").Value
        End Get
    End Property
    Public Shared ReadOnly Property QMSConnection() As String
        Get
            Return CurrentEnvironment.Settings("QMSConnection").Value
        End Get
    End Property
    Public Shared ReadOnly Property SurveyAdminConnection() As String
        Get
            Return CurrentEnvironment.Settings("SurveyAdminConnection").Value
        End Get
    End Property
    Public Shared ReadOnly Property SqlTimeout() As Long
        Get
            Return CLng(Settings.GlobalSettings("SqlTimeout").Value)
        End Get
    End Property
    Public Shared ReadOnly Property EmailFrom() As String
        Get
            Return Settings.GlobalSettings("EmailFrom").Value
        End Get
    End Property
    Public Shared ReadOnly Property EmailTo() As String
        Get
            Return Settings.GlobalSettings("EmailTo").Value
        End Get
    End Property
    Public Shared ReadOnly Property TestNRCConnection() As String
        Get
            Return CurrentEnvironment.Settings("TestNRC").Value
        End Get
    End Property
#End Region

End Class
