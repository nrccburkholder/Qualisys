Public Class AppConfig
    Inherits NRC.Configuration.AppConfigWrapper

    Private Shared mInstance As New AppConfig

    'Singleton Constructor is private 
    Private Sub New()
    End Sub

    'Returns the Singleton instance 
    Public Shared ReadOnly Property Instance() As NRC.NRCAuthLib.AppConfig
        Get
            Return mInstance
        End Get
    End Property

    'Determines the Environment Identifier for matching with the Configuration Environment Settings 
    Public Overrides ReadOnly Property EnvironmentIdentifier() As String
        Get
            Return System.Web.HttpContext.Current.Request.Url.Host
        End Get
    End Property

    Public Overrides ReadOnly Property EnvironmentType() As AppEnvironment
        Get
            If StaticConfig.IsEnvironmentTypeSet Then
                Select Case StaticConfig.EnvironmentType
                    Case StaticConfig.Environment.Development
                        Return Configuration.AppConfigWrapper.AppEnvironment.Development
                    Case StaticConfig.Environment.Testing
                        Return Configuration.AppConfigWrapper.AppEnvironment.Testing
                    Case StaticConfig.Environment.Production
                        Return Configuration.AppConfigWrapper.AppEnvironment.Production
                End Select
            Else
                Return MyBase.EnvironmentType
            End If
        End Get
    End Property

#Region " Application Configuration Settings "

    Public ReadOnly Property SMTPServer() As String
        Get
            If StaticConfig.IsSmtpServerSet Then
                Return StaticConfig.SMTPServer
            Else
                Return EnvironmentSetting("SMTPServer")
            End If
        End Get
    End Property

    Public ReadOnly Property MailFromAccount() As String
        Get
            If StaticConfig.IsMailFromAccountSet Then
                Return StaticConfig.MailFromAccount
            Else
                Return EnvironmentSetting("MailFromAccount")
            End If
        End Get
    End Property

    Public ReadOnly Property SiteUrl() As String
        Get
            If StaticConfig.IsSiteUrlSet Then
                Return StaticConfig.SiteUrl
            Else
                Return EnvironmentSetting("SiteUrl")
            End If
        End Get
    End Property

    Public ReadOnly Property NRCPickerUrl() As String
        Get
            If StaticConfig.IsNRCPickerUrlSet Then
                Return StaticConfig.NRCPickerUrl
            Else
                Return EnvironmentSetting("NRCPickerUrl")
            End If
        End Get
    End Property

    Public ReadOnly Property WWWNRCPickerUrl() As String
        Get
            If StaticConfig.IsWWWNRCPickerUrlSet Then
                Return StaticConfig.WWWNRCPickerUrl
            End If
            Return EnvironmentSetting("WWWNRCPickerUrl")
        End Get
    End Property

    Public ReadOnly Property NRCAuthConnection() As String
        Get
            If StaticConfig.IsNRCAuthConnectionSet Then
                Return StaticConfig.NRCAuthConnection
            Else
                Return EnvironmentSetting("NRCAuthConnection")
            End If
        End Get
    End Property

    Public ReadOnly Property DataMartConnection() As String
        Get
            If StaticConfig.IsDataMartConnectionSet Then
                Return StaticConfig.DataMartConnection
            Else
                Return EnvironmentSetting("DataMartConnection")
            End If
        End Get
    End Property

#End Region

End Class

#Region " StaticConfig Class "
'This class is for forward compatitibility with .NET 2.0 libraries
'to avoid conflicts with the .NET 1.1 version of Environment Settings
'and the .NET 2.0 version of Environment Settings
Public Class StaticConfig
    Private Shared mIsSmtpServerSet As Boolean = False
    Private Shared mIsMailFromAccountSet As Boolean = False
    Private Shared mIsSiteUrlSet As Boolean = False
    Private Shared mIsNRCPickerUrlSet As Boolean = False
    Private Shared mIsWWWNRCPickerUrlSet As Boolean = False
    Private Shared mIsNRCAuthConnectionSet As Boolean = False
    Private Shared mIsDataMartConnectionSet As Boolean = False
    Private Shared mIsEnvironmentTypeSet As Boolean = False

    Private Shared mSmtpServer As String
    Private Shared mMailFromAccount As String
    Private Shared mSiteUrl As String
    Private Shared mNRCPickerUrl As String
    Private Shared mWWWNRCPickerUrl As String
    Private Shared mNRCAuthConnection As String
    Private Shared mDataMartConnection As String
    Private Shared mEnvironmentType As Environment

    Public Enum Environment
        Production = 0
        Testing = 1
        Development = 2
    End Enum

    Public Shared ReadOnly Property IsSmtpServerSet() As Boolean
        Get
            Return mIsSmtpServerSet
        End Get
    End Property

    Public Shared ReadOnly Property IsMailFromAccountSet() As Boolean
        Get
            Return mIsMailFromAccountSet
        End Get
    End Property

    Public Shared ReadOnly Property IsSiteUrlSet() As Boolean
        Get
            Return mIsSiteUrlSet
        End Get
    End Property

    Public Shared ReadOnly Property IsNRCPickerUrlSet() As Boolean
        Get
            Return mIsNRCPickerUrlSet
        End Get
    End Property
    Public Shared ReadOnly Property IsWWWNRCPickerUrlSet() As Boolean
        Get
            Return mIsWWWNRCPickerUrlSet
        End Get
    End Property

    Public Shared ReadOnly Property IsNRCAuthConnectionSet() As Boolean
        Get
            Return mIsNRCAuthConnectionSet
        End Get
    End Property

    Public Shared ReadOnly Property IsDataMartConnectionSet() As Boolean
        Get
            Return mIsDataMartConnectionSet
        End Get
    End Property

    Public Shared ReadOnly Property IsEnvironmentTypeSet() As Boolean
        Get
            Return mIsEnvironmentTypeSet
        End Get
    End Property

    Public Shared Property SMTPServer() As String
        Get
            Return mSmtpServer
        End Get
        Set(ByVal Value As String)
            mSmtpServer = Value
            mIsSmtpServerSet = True
        End Set
    End Property

    Public Shared Property MailFromAccount() As String
        Get
            Return mMailFromAccount
        End Get
        Set(ByVal Value As String)
            mMailFromAccount = Value
            mIsMailFromAccountSet = True
        End Set
    End Property

    Public Shared Property SiteUrl() As String
        Get
            Return mSiteUrl
        End Get
        Set(ByVal Value As String)
            mSiteUrl = Value
            mIsSiteUrlSet = True
        End Set
    End Property

    Public Shared Property WWWNRCPickerUrl() As String
        Get
            Return mWWWNRCPickerUrl
        End Get
        Set(ByVal Value As String) 'mh 20090209 - I don't think anything ever sets these properties
            mWWWNRCPickerUrl = Value
            mIsWWWNRCPickerUrlSet = True
        End Set
    End Property

    Public Shared Property NRCPickerUrl() As String
        Get
            Return mNRCPickerUrl
        End Get
        Set(ByVal Value As String)
            mNRCPickerUrl = Value
            mIsNRCPickerUrlSet = True
        End Set
    End Property

    Public Shared Property NRCAuthConnection() As String
        Get
            Return mNRCAuthConnection
        End Get
        Set(ByVal Value As String)
            mNRCAuthConnection = Value
            mIsNRCAuthConnectionSet = True
        End Set
    End Property

    Public Shared Property DataMartConnection() As String
        Get
            Return mDataMartConnection
        End Get
        Set(ByVal Value As String)
            mDataMartConnection = Value
            mIsDataMartConnectionSet = True
        End Set
    End Property

    Public Shared Property EnvironmentType() As Environment
        Get
            Return mEnvironmentType
        End Get
        Set(ByVal Value As Environment)
            mEnvironmentType = Value
            mIsEnvironmentTypeSet = True
        End Set
    End Property
End Class
#End Region
