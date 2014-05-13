Imports Microsoft.Win32
Imports System.Security.Permissions
Imports System.Data.SqlClient
Imports EnvironmentManager.library

Public NotInheritable Class EnvironmentController
    Private Const CurrentEnvironmentKeyName As String = "CurrentEnvironmentName"
    Public Shared Event ErrorOccurred(ByVal Sender As Object, ByVal e As IO.ErrorEventArgs)
    Public Shared Event EnvironmentChanged(ByVal Sender As Object, ByVal e As EventArgs)
#Region "Private Fields"
    Private Shared mSQLTimeOutValue As Nullable(Of Integer) = Nothing
    Private Shared mMessage As New System.Text.StringBuilder
    Private Shared mRegPath As String
    Private Shared mConfigConnectionValue As String
    Private Shared mSmtpServerValue As String
    'Private Shared mKeyData As Byte()
    'Private Shared mVectorData As Byte()
    'Private Shared mCryptoHelper As Nrc.Framework.Security.CryptoHelper
    Private Shared mEnvironmentCountChanged As Boolean = True

    Private RegistryMonitor As RegistryUtils.RegistryMonitor

#End Region
#Region "Private Properties"
    Private Shared ReadOnly Property RegPath() As String
        Get
            If String.IsNullOrEmpty(mRegPath) Then
                mRegPath = String.Format("{0}\{1}", "HKEY_LOCAL_MACHINE", Config.NrcPickerRegKey)
            End If
            Return mRegPath
        End Get
    End Property
    Private Shared Function GetSMTPServerValueFromRegistry() As String
        Dim RegKey As RegistryKey = Nothing
        Try
            RegKey = Registry.LocalMachine.OpenSubKey(Config.NrcPickerRegKey)
            If RegKey IsNot Nothing Then
                Dim SMTPServer As String = RegKey.GetValue(Config.SMTPServerKeyName).ToString
                RegKey.Close()
                RegKey = Nothing
                Return SMTPServer
            End If
            Return String.Empty
        Finally
            If RegKey IsNot Nothing Then
                RegKey.Close()
            End If
        End Try
    End Function
#End Region
#Region "Public Properties"
    Public Shared Property SMTPServerValue() As String
        Get
            If String.IsNullOrEmpty(mSmtpServerValue) Then
                mSmtpServerValue = GetSMTPServerValueFromRegistry()
            End If
            Return mSmtpServerValue
        End Get
        Set(ByVal value As String)
            Dim RegKey As RegistryKey = Nothing
            Try
                RegKey = Registry.LocalMachine.OpenSubKey(Config.NrcPickerRegKey, True)
                If RegKey IsNot Nothing Then
                    RegKey.SetValue(Config.SMTPServerKeyName, value)
                    mSmtpServerValue = value
                    RegKey.Close()
                    RegKey = Nothing
                End If
            Finally
                If RegKey IsNot Nothing Then
                    RegKey.Close()
                End If
            End Try
        End Set
    End Property
    Public Shared Property ConfigConnectionValue() As String
        Get
            If String.IsNullOrEmpty(mConfigConnectionValue) Then
                mConfigConnectionValue = GetConfigConnectionValueFromRegistry()
            End If
            Return mConfigConnectionValue
        End Get
        Set(ByVal value As String)
            Dim stringvalue As String = value
            stringvalue = Config.mCryptoHelper.EncryptString(value)
            Dim RegKey As RegistryKey = Nothing
            Try
                RegKey = Registry.LocalMachine.OpenSubKey(Config.NrcPickerRegKey, True)
                If RegKey IsNot Nothing Then
                    RegKey.SetValue(Config.ConfigConnectionKeyName, stringvalue)
                    mConfigConnectionValue = value
                    QualproParamsProvider.Instance.QualisysConnectionString = value
                End If
            Finally
                If RegKey IsNot Nothing Then
                    RegKey.Close()
                End If
            End Try
        End Set
    End Property
    Public Shared Property CurrentEnvironmentName() As String
        Get
            Return Config.CurrentEnvironmentName
        End Get
        Set(ByVal value As String)
            Dim stringvalue As String = value
            stringvalue = Config.mCryptoHelper.EncryptString(value)
            Dim RegKey As RegistryKey = Nothing
            Try
                RegKey = Registry.LocalMachine.OpenSubKey(Config.NrcPickerRegKey, True)
                If RegKey IsNot Nothing Then
                    RegKey.SetValue(CurrentEnvironmentKeyName, stringvalue)
                    Config.CurrentEnvironmentName = value
                End If
            Finally
                If RegKey IsNot Nothing Then
                    RegKey.Close()
                End If
            End Try
        End Set
    End Property
    'Public Shared Property CurrentEnvironmentNameOld() As String
    '    Get
    '        Try
    '            If String.IsNullOrEmpty(Config.CurrentEnvironmentName) Then
    '                Config.CurrentEnvironmentName = Nrc.Framework.BusinessLogic.Configuration.AppConfig.EnvironmentName
    '            End If
    '            Return Config.CurrentEnvironmentName
    '        Catch ex As Exception
    '            Message.AppendLine(ex.Message)
    '            'probably something happend in Data access layer
    '            'mCurrentEnvironment = GetCurrentEnvironmentFromRegistry()
    '            Config.CurrentEnvironmentName = GetCurrentEnvironmentFromRegistry()
    '            Return Config.CurrentEnvironmentName
    '        End Try
    '    End Get
    '    Set(ByVal value As String)
    '        If Not String.IsNullOrEmpty(value) Then
    '            Config.CurrentEnvironmentName = value
    '            SwitchRegValuesToTheEnvironmentDefaults(value)
    '        End If
    '    End Set
    'End Property
    Public Shared Property SQLTimeOutValue() As Nullable(Of Integer)
        Get
            If Not mSQLTimeOutValue.HasValue Then
                mSQLTimeOutValue = GetSQLTimeOutValueFromRegistry()
            End If
            Return mSQLTimeOutValue
        End Get
        Set(ByVal value As Nullable(Of Integer))
            Dim RegKey As RegistryKey = Nothing
            Try
                RegKey = Registry.LocalMachine.OpenSubKey(Config.NrcPickerRegKey, True)
                If RegKey IsNot Nothing Then
                    RegKey.SetValue(Config.SQLTimeOutKeyName, value)
                    mSQLTimeOutValue = value
                    RegKey.Close()
                End If
            Finally
                If RegKey IsNot Nothing Then
                    RegKey.Close()
                End If
            End Try
        End Set
    End Property
    Public Shared Property Message() As System.Text.StringBuilder
        Get
            Return mMessage
        End Get
        Set(ByVal value As System.Text.StringBuilder)
            mMessage = value
        End Set
    End Property
    Public Shared ReadOnly Property IsRegistrySetUP() As Boolean
        Get
            Dim RegKey As RegistryKey = Nothing
            Try
                RegKey = Registry.LocalMachine.OpenSubKey(Config.NrcPickerRegKey, True)
                If RegKey IsNot Nothing Then
                    Return RegKey.GetValue(Config.ConfigConnectionKeyName) IsNot Nothing AndAlso _
                            RegKey.GetValue(Config.SMTPServerKeyName) IsNot Nothing AndAlso _
                            RegKey.GetValue(Config.SQLTimeOutKeyName) IsNot Nothing AndAlso _
                            RegKey.GetValue(CurrentEnvironmentKeyName) IsNot Nothing
                Else
                    Return False
                End If
            Catch ex As Exception
                Message.Append(ex.Message)
                Return False
            Finally
                If RegKey IsNot Nothing Then
                    RegKey.Close()
                End If
            End Try
        End Get
    End Property
    Public Shared Property EnvironmentCountChanged() As Boolean
        Get
            Return mEnvironmentCountChanged
        End Get
        Set(ByVal value As Boolean)
            mEnvironmentCountChanged = value
        End Set
    End Property
#End Region
#Region "Private Methods"
    Private Shared Function GetConfigConnectionValueFromRegistry() As String
        Dim RegKey As RegistryKey = Nothing
        Try
            RegKey = Registry.LocalMachine.OpenSubKey(Config.NrcPickerRegKey)
            If RegKey Is Nothing Then
                'The key doesn't exist, try to create.
                RegKey = Registry.LocalMachine.OpenSubKey(Config.NrcPickerRegKey)
            End If

            If RegKey IsNot Nothing Then
                Dim ConfigConnectionString As String = RegKey.GetValue(Config.ConfigConnectionKeyName).ToString
                RegKey.Close()
                RegKey = Nothing
                Try
                    Return Config.mCryptoHelper.DecryptString(ConfigConnectionString)
                Catch ex As Exception
                    'Give a chance to edit manually if it's messed up in the registry and the
                    'program fails on decryption.
                    MessageBox.Show(ex.Message)
                End Try
                Return ConfigConnectionString
            End If
            Return String.Empty
        Finally
            If RegKey IsNot Nothing Then
                RegKey.Close()
            End If
        End Try
    End Function
    Private Shared Sub CreateRegistryKeys()
        Dim RegKey As RegistryKey = Nothing
        Try
            RegKey = Registry.LocalMachine.OpenSubKey(Config.NrcPickerRegKey, True)
            If RegKey Is Nothing Then
                RegKey = Registry.LocalMachine.CreateSubKey(Config.NrcPickerRegKey)
            End If
            If RegKey Is Nothing Then
                Throw New Exception("Failed to read\write to Registry")
            End If

        Finally
            If RegKey IsNot Nothing Then
                RegKey.Close()
            End If
        End Try
    End Sub
    Public Shared Function GetCurrentEnvironmentFromRegistry() As String
        Dim RegKey As RegistryKey = Nothing
        Try
            RegKey = Registry.LocalMachine.OpenSubKey(Config.NrcPickerRegKey)

            If RegKey IsNot Nothing Then
                Dim currentEnvironmentName As String = CStr(RegKey.GetValue(CurrentEnvironmentKeyName))
                RegKey.Close()
                Return Config.mCryptoHelper.DecryptString(currentEnvironmentName)
            End If
            Return Nothing
        Finally
            If RegKey IsNot Nothing Then
                RegKey.Close()
            End If
        End Try
    End Function
    Private Shared Function GetSQLTimeOutValueFromRegistry() As Nullable(Of Integer)
        Dim RegKey As RegistryKey = Nothing
        Try
            RegKey = Registry.LocalMachine.OpenSubKey(Config.NrcPickerRegKey)

            If RegKey IsNot Nothing Then
                Dim TimeOutValue As Integer = RegKey.GetValue(Config.SQLTimeOutKeyName)
                RegKey.Close()
                Return TimeOutValue
            End If
            Return Nothing
        Finally
            If RegKey IsNot Nothing Then
                RegKey.Close()
            End If
        End Try
    End Function
    Private Shared Function IsValid(ByVal pConnectionString As String, ByVal pSmtpServer As String, ByVal pSqlTimeOut As String) As Boolean
        Message.Remove(0, Message.Length)
        Return IsValidConnString(pConnectionString) And IsValidSqlTimeOut(pSqlTimeOut)
    End Function
    Private Shared Function IsValidSqlTimeOut(ByVal pSqlTimeOut As String) As Boolean
        If IsNumeric(pSqlTimeOut) Then
            Dim val As Integer = CInt(pSqlTimeOut)
            If (val >= 200 And val <= 1200) Then
                Return True
            Else
                Message.AppendLine("SQLTimeOutValue is out of range (200-1200)")
            End If
        Else
            Message.AppendLine("SQLTimeOutValue should be a number between 200 and 1200")
        End If
        Return False
    End Function
    Private Shared Function IsValidConnString(ByVal pConnectionString As String) As Boolean
        Return TestConnection(pConnectionString)
    End Function
    Private Shared Function TestConnection(ByVal pConnectionString As String) As Boolean
        Using cnn As New SqlConnection(pConnectionString)
            Try
                cnn.Open()
                cnn.Close()
                Return True
            Catch ex As Exception
                Message.AppendLine(ex.Message)
                If cnn IsNot Nothing AndAlso cnn.State = ConnectionState.Open Then
                    cnn.Close()
                End If
                Return False
            End Try
        End Using
    End Function
    Private Sub OnError(ByVal sender As Object, ByVal e As IO.ErrorEventArgs)
        StopRegistryMonitor()
    End Sub
    Private Sub OnRegChanged(ByVal sender As Object, ByVal e As EventArgs)
        RaiseEvent EnvironmentChanged(sender, e)
    End Sub

#End Region
#Region "Public Methods"
    Public Shared Sub SetEnvironmentTo(ByVal environment As String)
        If Config.EnvironmentExists(environment) Then
            If Not IsRegistrySetUP Then
                CreateRegistryKeys()
            End If
            'the sequence of assignments is important, don't change it!
            CurrentEnvironmentName = environment
            ConfigConnectionValue = Config.ConfigurationConnection
            SMTPServerValue = Config.SMTPServer
            SQLTimeOutValue = Config.SQLTimeOutValue
        End If
    End Sub
    Public Sub StopRegistryMonitor()
        If Not RegistryMonitor Is Nothing Then
            RegistryMonitor.Stop()
            RemoveHandler RegistryMonitor.RegChanged, AddressOf OnRegChanged
            RemoveHandler RegistryMonitor.ErrEvent, AddressOf OnError
            RegistryMonitor = Nothing
        End If
    End Sub
    Public Shared Function Save(ByVal pConnectionString As String, ByVal pSmtpServer As String, ByVal pSqlTimeOut As String) As Boolean
        If IsValid(pConnectionString, pSmtpServer, pSqlTimeOut) Then
            ConfigConnectionValue = pConnectionString
            SMTPServerValue = pSmtpServer
            SQLTimeOutValue = CInt(pSqlTimeOut)
            RaiseEvent EnvironmentChanged(Nothing, New System.EventArgs)
            Return True
        End If
        Return False
    End Function
    Public Sub StartMonitoring()
        RegistryMonitor = New RegistryUtils.RegistryMonitor(RegPath)
        AddHandler RegistryMonitor.RegChanged, AddressOf OnRegChanged
        AddHandler RegistryMonitor.ErrEvent, AddressOf OnError
        RegistryMonitor.Start()
    End Sub
    Public Shared Sub Reset()
        mConfigConnectionValue = String.Empty
        mSmtpServerValue = String.Empty
        mSQLTimeOutValue = Nothing
        SetEnvironmentTo(CurrentEnvironmentName)
    End Sub

    'Returns true if the current environment name is the same in the registry and the config file
    Public Shared Function IsCurrentEnvironmentSynched()
        Return String.Equals(GetCurrentEnvironmentFromRegistry(), Config.CurrentEnvironmentName, StringComparison.CurrentCultureIgnoreCase)
    End Function
#End Region
End Class
