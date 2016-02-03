Imports Nrc.Framework.Configuration
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

    Public Shared ReadOnly Property TempFileDirectory() As String
        Get
            Return Settings("TempFileDirectory")
        End Get
    End Property


#End Region

#Region " Custom Configuration Properties "    
    Public Shared ReadOnly Property MaxNumberOfRespondentsPerExport() As Long
        Get
            Return Long.Parse(Settings("MaxNumberOfRespondentsPerExport"))
        End Get
    End Property
    Public Shared ReadOnly Property RespondentFields() As String
        Get
            Return Settings("RespondentFields")
        End Get
    End Property
#End Region
End Class
