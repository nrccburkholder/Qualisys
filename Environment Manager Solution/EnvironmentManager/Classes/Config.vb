Imports System.Xml
Imports System.Xml.Serialization
Imports System.io
Imports Nrc.Framework.Configuration
Public Class Config
    Public Const SerializedConfigFileName As String = "NrcConfig.xml"
    Private Shared mEnvironmentSettings As Nrc.Framework.Configuration.EnvironmentSettings
    Private Shared mKeyData As Byte()
    Private Shared mVectorData As Byte()
    Public Shared mCryptoHelper As Nrc.Framework.Security.CryptoHelper

    Shared Sub New()
        mKeyData = New Byte() {78, 82, 67, 32, 68, 66, 67, 111, 110, 110, 101, 99, 116, 105, 111, 110}
        mVectorData = New Byte() {78, 82, 67, 83, 81, 76, 68, 66}
        mCryptoHelper = Nrc.Framework.Security.CryptoHelper.CreateTripleDESCryptoHelper(mKeyData, mVectorData)
        SetupNrcAuthSettings()
    End Sub
#Region "Public Properties"
    Public Shared ReadOnly Property EnvironmentSettings() As Nrc.Framework.Configuration.EnvironmentSettings
        Get
            If mEnvironmentSettings Is Nothing Then
                Dim file As New FileInfo(SerializedConfigFileName)
                mEnvironmentSettings = Nrc.Framework.Configuration.EnvironmentSettings.Deserialize(file)
            End If
            Return mEnvironmentSettings
        End Get
    End Property
    Public Shared Property Setting(ByVal name As String) As String
        Get
            Return EnvironmentSettings(name)
        End Get
        Set(ByVal value As String)
            SetSettingValue(name, value)
        End Set
    End Property
    'NewValue must be plain text NOT Encrypted
    Private Shared Function IsSettingEncrypted(ByVal settingName As String) As Boolean
        Dim Encrypted As Boolean
        If EnvironmentSettings.GlobalSettings(settingName) IsNot Nothing Then
            Encrypted = EnvironmentSettings.GlobalSettings(settingName).IsEncrypted
        Else
            Encrypted = CurrentEnvironment.Settings(settingName).IsEncrypted
        End If
        Return Encrypted
    End Function
    Public Shared Sub SetSettingValue(ByVal settingName As String, ByVal NewValue As String)
        'Check if the setting is encrypted in the xml file 
        Dim Encrypted As Boolean = IsSettingEncrypted(settingName)

        Dim SettingValue As String
        If Encrypted Then
            'Encrypt the value since NewValue is not Encrypted
            SettingValue = mCryptoHelper.EncryptString(NewValue)
        Else
            SettingValue = NewValue
        End If

        Dim NewSetting As New Setting(settingName, SettingValue, Encrypted)

        Dim OldSetting As Setting = EnvironmentSettings.GlobalSettings(settingName)
        If OldSetting Is Nothing Then
            OldSetting = CurrentEnvironment.Settings(settingName)
            If OldSetting IsNot Nothing Then
                CurrentEnvironment.Settings.Remove(settingName)
                CurrentEnvironment.Settings.Add(NewSetting)
            End If
        Else
            EnvironmentSettings.GlobalSettings.Remove(settingName)
            EnvironmentSettings.GlobalSettings.Add(NewSetting)
        End If
    End Sub
    Public Shared Sub Save()
        EnvironmentSettings.Serialize(SerializedConfigFileName)
    End Sub
    Public Shared Sub ResetEnvironmentSettings()
        mEnvironmentSettings = Nothing
    End Sub
    Public Shared Function EnvironmentExists(ByVal name As String) As Boolean
        For Each environmentName As String In EnvironmentSettings.Environments.Keys
            If String.Equals(name, environmentName, StringComparison.CurrentCultureIgnoreCase) Then
                Return True
            End If
        Next
        Return False
    End Function
    Public Shared Property CurrentEnvironmentName() As String
        Get
            Return EnvironmentSettings.CurrentEnvironmentName
        End Get
        Set(ByVal value As String)
            If Not String.Equals(EnvironmentSettings.CurrentEnvironmentName, value, StringComparison.CurrentCultureIgnoreCase) Then
                EnvironmentSettings.CurrentEnvironmentName = value
                If Not String.IsNullOrEmpty(value) Then
                    SetupNrcAuthSettings()
                    Save()
                End If
            End If
        End Set
    End Property
    Public Shared ReadOnly Property CurrentEnvironment() As Nrc.Framework.Configuration.Environment
        Get
            Return EnvironmentSettings.CurrentEnvironment
        End Get
    End Property
#Region "Wrapper Properties"
    Public Shared ReadOnly Property NrcPickerRegKey() As String
        Get
            Return Setting("NrcPickerRegKey")
        End Get
    End Property
    Public Shared ReadOnly Property ConfigConnectionKeyName() As String
        Get
            Return Setting("ConfigConnectionKeyName")
        End Get
    End Property
    Public Shared ReadOnly Property SQLTimeOutKeyName() As String
        Get
            Return Setting("SQLTimeOutKeyName")
        End Get
    End Property
    Public Shared ReadOnly Property SMTPServerKeyName() As String
        Get
            Return Setting("SMTPServerKeyName")
        End Get
    End Property
    Public Shared ReadOnly Property SQLTimeOutValue() As String
        Get
            Return Setting("SQLTimeOutValue")
        End Get
    End Property
    Public Shared ReadOnly Property ConfigurationConnection() As String
        Get
            Return Setting("ConfigurationConnection")
        End Get
    End Property
    Public Shared ReadOnly Property SMTPServer() As String
        Get
            Return Setting("SMTPServer")
        End Get
    End Property
    Public Shared ReadOnly Property NrcAuthConnection() As String
        Get
            Return Setting("NrcAuthConnection")
        End Get
    End Property
#End Region
#End Region
    Public Shared Sub SetupNrcAuthSettings()
        Nrc.NRCAuthLib.StaticConfig.NRCAuthConnection = Config.NrcAuthConnection
    End Sub
    Private Shared mSuperAdminUsers As List(Of SuperAdmin)
    Public Shared ReadOnly Property SuperAdminUsers() As List(Of SuperAdmin)
        Get
            If mSuperAdminUsers Is Nothing Then
                mSuperAdminUsers = New List(Of SuperAdmin)
                For Each SuperAdminUser As String In Setting("SuperAdminUsers").Split(","c)
                    mSuperAdminUsers.Add(New SuperAdmin(SuperAdminUser))
                Next
            End If
            Return mSuperAdminUsers
        End Get
    End Property
    Public Shared Sub ResetSuperAdminUsers()
        mSuperAdminUsers = Nothing
    End Sub
End Class
