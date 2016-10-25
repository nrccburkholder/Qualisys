Public Class AppConfig
    Inherits NRC.Configuration.AppConfigWrapper

    Private Shared mInstance As New AppConfig

    'Singleton Constructor is private 
    Private Sub New()
    End Sub

    'Returns the Singleton instance 
    Public Shared ReadOnly Property Instance() As AppConfig
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

    Public Enum LocaleEnum
        USA
        Canada
    End Enum

#Region " Application Configuration Settings "

    Public ReadOnly Property DataExchangeConnection() As String
        Get
            Return EnvironmentSetting("DataExchangeConnection")
        End Get
    End Property

    Public ReadOnly Property SiteUrl() As String
        Get
            Return EnvironmentSetting("SiteUrl")
        End Get
    End Property

    Public ReadOnly Property NRCPickerUrl() As String
        Get
            Return EnvironmentSetting("NRCPickerUrl")
        End Get
    End Property
    Public ReadOnly Property WWWNRCPickerUrl() As String
        Get
            Return EnvironmentSetting("WWWNRCPickerUrl")
        End Get
    End Property

    Public ReadOnly Property PostedFilePath() As String
        Get
            Return EnvironmentSetting("PostedFilePath")
        End Get
    End Property

    Public ReadOnly Property UploadedFilePath() As String
        Get
            Return EnvironmentSetting("UploadedFilePath")
        End Get
    End Property

    Public ReadOnly Property SMTPServer() As String
        Get
            Return EnvironmentSetting("SMTPServer")
        End Get
    End Property

    Public ReadOnly Property ClientSupportEmail() As String
        Get
            Return EnvironmentSetting("ClientSupportEmail")
        End Get
    End Property

    Public ReadOnly Property DataExchangeFromAddress() As String
        Get
            Return EnvironmentSetting("DataExchangeFromAddress")
        End Get
    End Property

    Public ReadOnly Property WebAdminEmail() As String
        Get
            Return EnvironmentSetting("WebAdminEmail")
        End Get
    End Property

    Public ReadOnly Property UseSSL() As Boolean
        Get
            Return (EnvironmentSetting("UseSSL").ToLower.Trim = "true")
        End Get
    End Property

    Public ReadOnly Property Locale() As LocaleEnum
        Get
            Select Case EnvironmentSetting("Locale").ToUpper
                Case "USA"
                    Return LocaleEnum.USA
                Case "CANADA"
                    Return LocaleEnum.Canada
                Case Else
                    Return LocaleEnum.USA
            End Select
        End Get
    End Property

    Public ReadOnly Property BrandName() As String
        Get
            Select Case Locale
                Case LocaleEnum.USA
                    Return "National Research Corporation"
                Case LocaleEnum.Canada
                    Return "National Research Corporation Canada"
            End Select
        End Get
    End Property

    Public ReadOnly Property PrivacyLocale() As String
        Get
            Select Case Locale
                Case LocaleEnum.USA
                    Return "http://www.nationalresearch.com/privacy-policy"
                Case LocaleEnum.Canada
                    Return "http://www.nationalresearch.ca/privacy-policy"
            End Select
        End Get
    End Property

    Public ReadOnly Property DefaultPassword() As String
        Get
            Return EnvironmentSetting("DefaultPassword")
        End Get
    End Property
#End Region

End Class
