Imports Microsoft.Win32

Namespace Configuration

    Public Class AppConfig

#Region "Private Members"

        Private Shared mConfigInitialized As Boolean = False
        Private Shared mConfigConnection As String = String.Empty
        Private Shared mSqlTimeout As Integer = 0
        Private Shared mSMTPServer As String = String.Empty

        Private Shared mParams As ParamCollection = Nothing

#End Region

#Region "Public Properties"

#Region "Registry Parameters"

        Friend Shared ReadOnly Property ConfigConnection() As String
            Get
                If Not mConfigInitialized Then
                    Initialize()
                End If

                Return mConfigConnection
            End Get
        End Property

        Public Shared ReadOnly Property SqlTimeout() As Integer
            Get
                If Not mConfigInitialized Then
                    Initialize()
                End If

                Return mSqlTimeout
            End Get
        End Property

        Public Shared ReadOnly Property SMTPServer() As String
            Get
                If Not mConfigInitialized Then
                    Initialize()
                End If

                Return mSMTPServer
            End Get
        End Property

#End Region

#Region "Database Parameters"

        Public Shared ReadOnly Property Params() As ParamCollection
            Get
                If mParams Is Nothing Then
                    mParams = Param.GetAll
                End If

                Return mParams
            End Get
        End Property

        Public Shared ReadOnly Property EnvironmentName() As String
            Get
                Return Params("EnvName").StringValue
            End Get
        End Property

        Public Shared ReadOnly Property EnvironmentType() As EnvironmentTypes
            Get
                Return DirectCast(Params("EnvName").IntegerValue, EnvironmentTypes)
            End Get
        End Property

        Public Shared ReadOnly Property CountryName() As String
            Get
                Return Params("Country").StringValue
            End Get
        End Property

        Public Shared ReadOnly Property CountryID() As CountryIDs
            Get
                Return DirectCast(Params("Country").IntegerValue, CountryIDs)
            End Get
        End Property

        Public Shared ReadOnly Property QualisysConnection() As String
            Get
                Return Params("QualisysConnection").StringValue
            End Get
        End Property

        Public Shared ReadOnly Property QLoaderConnection() As String
            Get
                Return Params("QLoaderConnection").StringValue
            End Get
        End Property

        Public Shared ReadOnly Property DataLoadConnection() As String
            Get
                Return Params("DataLoadConnection").StringValue
            End Get
        End Property

        Public Shared ReadOnly Property DataMartConnection() As String
            Get
                Return Params("DataMartConnection").StringValue
            End Get
        End Property

        Public Shared ReadOnly Property NrcAuthConnection() As String
            Get
                Return Params("NrcAuthConnection").StringValue
            End Get
        End Property

        Public Shared ReadOnly Property NotificationConnection() As String
            Get
                Return Params("NotificationConn").StringValue
            End Get
        End Property

        Public Shared ReadOnly Property QueueConnection() As String
            Get
                Return Params("QueueConnection").StringValue
            End Get
        End Property

        Public Shared ReadOnly Property ScanConnection() As String
            Get
                Return Params("ScanConnection").StringValue
            End Get
        End Property

        Public Shared ReadOnly Property WorkflowConnection() As String
            Get
                Return Params("WorkflowConnection").StringValue
            End Get
        End Property

#End Region

#End Region

#Region "Public Methods"

#End Region

#Region "Private Methods"

        Private Shared Sub Initialize()

            Try
                Dim keyData As Byte() = New Byte() {78, 82, 67, 32, 68, 66, 67, 111, 110, 110, 101, 99, 116, 105, 111, 110}
                Dim vectorData As Byte() = New Byte() {78, 82, 67, 83, 81, 76, 68, 66}
                Dim cryptoHelper As Nrc.Framework.Security.CryptoHelper = Nrc.Framework.Security.CryptoHelper.CreateTripleDESCryptoHelper(keyData, vectorData)

                'Open the registry key
                Dim regKey As RegistryKey = Registry.LocalMachine.OpenSubKey("Software\NRCPicker")

                'Get the connection string from the registry and decrypt it
                Dim encryptedConnection As String = regKey.GetValue("Configuration Connection").ToString
                mConfigConnection = cryptoHelper.DecryptString(encryptedConnection)

                'Read the remaining values from the registry
                mSqlTimeout = CInt(regKey.GetValue("SQL Command Timeout"))
                mSMTPServer = regKey.GetValue("SMTP Server").ToString

                'Set the initialized flag
                mConfigInitialized = True

            Catch ex As Exception
                Throw New ConfigurationException("Your registry is not properly configured to run this application.", ex)

            End Try

        End Sub

#End Region

    End Class

End Namespace

