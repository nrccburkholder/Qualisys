Imports Nrc.Framework.Configuration
Public Class Config
    Protected Shared mSettingsTable As DataTable
    Private Shared Function LoadConfigFromXml() As DataTable
        Dim ds As New DataSet
        ds.ReadXml("NrcConfig.xml")
        Return ds.Tables("settings")
    End Function
    Public Shared ReadOnly Property SettingsTable() As DataTable
        Get
            If mSettingsTable Is Nothing Then
                mSettingsTable = LoadConfigFromXml()
            End If
            Return mSettingsTable
        End Get
    End Property
    Public Shared ReadOnly Property Settings(ByVal SettingName As String) As String
        Get
            If SettingsTable.Rows.Count() > 0 Then
                Return SettingsTable.Rows(0).Item(SettingName).ToString
            Else
                Throw New Exception("Could not read settings from config.xml")
            End If
        End Get
    End Property
#Region " Custom Configuration Properties "
    Public Shared ReadOnly Property NrcPickerRegKey() As String
        Get
            Return Settings("NrcPickerRegKey")
        End Get
    End Property
    Public Shared ReadOnly Property ConfigConnectionKeyName() As String
        Get
            Return Settings("ConfigConnectionKeyName")
        End Get
    End Property
    Public Shared ReadOnly Property SQLTimeOutKeyName() As String
        Get
            Return Settings("SQLTimeOutKeyName")
        End Get
    End Property
    Public Shared ReadOnly Property SMTPServerKeyName() As String
        Get
            Return Settings("SMTPServerKeyName")
        End Get
    End Property
    Public Shared ReadOnly Property TestingSQLTimeOutValue() As String
        Get
            Return Settings("TestingSQLTimeOutValue")
        End Get
    End Property
    Public Shared ReadOnly Property ProductionSQLTimeOutValue() As String
        Get
            Return Settings("ProductionSQLTimeOutValue")
        End Get
    End Property
    Public Shared ReadOnly Property DevelopmentSMTPServerValue() As String
        Get
            Return Settings("DevelopmentSMTPServerValue")
        End Get
    End Property
    Public Shared ReadOnly Property StagingSQLTimeOutValue() As String
        Get
            Return Settings("StagingSQLTimeOutValue")
        End Get
    End Property
    Public Shared ReadOnly Property TestingSMTPServer() As String
        Get
            Return Settings("TestingSMTPServer")
        End Get
    End Property
    Public Shared ReadOnly Property StagingSMTPServer() As String
        Get
            Return Settings("StagingSMTPServer")
        End Get
    End Property
    Public Shared ReadOnly Property ProductionSMTPServer() As String
        Get
            Return Settings("ProductionSMTPServer")
        End Get
    End Property
    Public Shared ReadOnly Property TestingConfigurationConnection() As String
        Get
            Return Settings("TestingConfigurationConnection")
        End Get
    End Property
    Public Shared ReadOnly Property StagingConfigurationConnection() As String
        Get
            Return Settings("StagingConfigurationConnection")
        End Get
    End Property
    Public Shared ReadOnly Property ProductionConfigurationConnection() As String
        Get
            Return Settings("ProductionConfigurationConnection")
        End Get
    End Property
#End Region
End Class
