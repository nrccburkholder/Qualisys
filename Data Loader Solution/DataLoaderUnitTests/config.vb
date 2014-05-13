Imports Nrc.Framework.Configuration
'TODO:  Do not forget to reset your references to the following:
'Nrc.Framework
'Nrc.Framework.BusinessLogic
'NRC.NRCAuthLib
''' <summary>Holds the environment settings and db connectin string info for the application.</summary>
''' <Creator>Jeff Fleming</Creator>
''' <DateCreated>11/8/2007</DateCreated>
''' <DateModified>11/8/2007</DateModified>
''' <ModifiedBy>Tony Piccoli</ModifiedBy>
Public Class Config

#Region " EnvironmentSettings Properties "
#If Config = "Production" Then
    Private Const mConfiguration As String="Production"
#ElseIf Config = "Staging" Then
    Private Const mConfiguration As String = "Staging"
#ElseIf Config = "Testing" Then
    Private Const mConfiguration As String = "Testing"
#ElseIf Config = "Development" Then
    Private Const mConfiguration As String = "Development"
#Else
    Private Const mConfiguration As String = "Unknown"
#End If

    Protected Shared mSettings As EnvironmentSettings

    ''' <summary>Loads and returns an EnvironementSettings object based on config file and when environment you are running in.</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Private Shared ReadOnly Property Settings() As EnvironmentSettings
        Get
            If mSettings Is Nothing Then
                mSettings = EnvironmentSettings.LoadFromConfig
                If String.IsNullOrEmpty(mSettings.CurrentEnvironmentName) Then
                    mSettings.CurrentEnvironmentName = mConfiguration
                End If
            End If
            Return mSettings
        End Get
    End Property
    ''' <summary></summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property EnvironmentType() As EnvironmentType
        Get
            Return Settings.CurrentEnvironment.EnvironmentType
        End Get
    End Property

    ''' <summary></summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property EnvironmentName() As String
        Get
            Return Settings.CurrentEnvironment.Name
        End Get
    End Property
#End Region

#Region " Custom Configuration Properties "
    ''' <summary>SMTP Server based on which enironement your in (DEV, Stage, Prod, etc)</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property SmtpServer() As String
        Get
            Return Settings("SmtpServer")
        End Get
    End Property
    ''' <summary>Conn string for NRC Auth connection based on which environment your in (Dev, stage, prod, etc)</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property NrcAuthConnection() As String
        Get
            Return Settings("NrcAuthConnection")
        End Get
    End Property
#End Region

End Class
