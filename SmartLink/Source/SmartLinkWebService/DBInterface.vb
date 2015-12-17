Imports System
Imports System.Data.SqlClient
Imports System.Web.Configuration
Imports System.Xml

Public Class DBInterface : Implements IDisposable
    Private _connection As SqlConnection

    Public Sub New()
        _connection = New SqlConnection(WebConfigurationManager.AppSettings("SQLConnectionString"))
        _connection.Open()
    End Sub

    Public Sub Dispose() Implements IDisposable.Dispose
        If _connection IsNot Nothing Then
            If _connection.State = Data.ConnectionState.Open Then
                _connection.Close()
                _connection.Dispose()
                _connection = Nothing
            End If
        End If
    End Sub

    ''' <summary>
    ''' Checks that we can query the database
    ''' </summary>
    Public Function Test() As Boolean
        Dim Query As String = "SELECT TOP 1 * from SmartLinkWebService"
        Using command = GetCommand(Query)
            Using reader As SqlDataReader = command.ExecuteReader()
                reader.Read()
            End Using
        End Using
    End Function

    Public Sub FindLatestVersion(ByRef version As String, ByRef url As String,
        ByRef fileName As String, ByRef FileCheckSum As String)
        Dim query As String = "SELECT TOP 1 VersionID, URL, FileName, FileCheckSum FROM VersionInfo " +
                              "ORDER BY CreatedDate DESC"

        Using command = GetCommand(query)
            Using reader As SqlDataReader = command.ExecuteReader()
                reader.Read()
                version = reader("VersionID")
                url = reader("URL")
                fileName = reader("FileName")
                FileCheckSum = reader("FileCheckSum")
            End Using
        End Using

    End Sub

    Public Function StoreUpdateRequest(ByVal clientID As String, ByVal clientVersion As String, ByVal newVersion As String) As Boolean
        Dim query As String = "INSERT INTO VersionRequest (ClientID, ClientVersion, ProvidedVersion) " +
            "VALUES(@ClientID, @ClientVersion, @ProvidedVersion)"

        Using command = GetCommand(query)
            command.Parameters.AddWithValue("ClientID", clientID)
            command.Parameters.AddWithValue("ClientVersion", clientVersion)
            command.Parameters.AddWithValue("ProvidedVersion", newVersion)

            command.ExecuteNonQuery()
        End Using

    End Function

    'Checks to see if we already have the filename and corresponding FileCheckSum in db
    Public Function FileExists(ByVal fileName As String, ByVal checkSum As String) As Boolean
        Dim query As String = "SELECT COUNT(*) FROM SmartLinkWebService WHERE FileName = @FileName AND " +
            "StartCheckSum = @CheckSum AND EndCheckSum = @CheckSum"

        Using command = GetCommand(query)
            command.Parameters.AddWithValue("FileName", fileName)
            command.Parameters.AddWithValue("CheckSum", checkSum)

            Return (command.ExecuteScalar() > 0)
        End Using

    End Function

    'Checks to see if there is a record corresponding to the ID provided
    Public Function IsInDB(ByVal id As String) As Boolean
        Dim query As String = "SELECT COUNT(*) FROM SmartLinkWebService WHERE ID = @ID"

        Using command = GetCommand(query)
            command.Parameters.AddWithValue("ID", id)

            Return (command.ExecuteScalar() > 0)
        End Using

    End Function

    'Stores the main date points of a transmission, gathered from the StartTransmission method, in a MySQL Table
    Public Function StoreStartTransmission(ByVal id As String, ByVal fileName As String, ByVal fileSize As Long,
                                           ByVal fileCheckSum As String) As Boolean
        Dim query As String = "INSERT INTO SmartLinkWebService (ID, FileName, FileSizeInBytes, StartCheckSum, StartTime, EndCheckSum, EndTime) " +
            "VALUES (@ID, @FileName, @FileSize, @StartCheckSum, GetDate(), NULL, NULL)"

        Using command = GetCommand(query)
            command.Parameters.AddWithValue("ID", id)
            command.Parameters.AddWithValue("FileName", fileName)
            command.Parameters.AddWithValue("FileSize", fileSize)
            command.Parameters.AddWithValue("StartCheckSum", fileCheckSum)

            command.ExecuteNonQuery()
        End Using

    End Function

    Public Sub FetchFileData(ByVal id As String, ByRef startCheckSum As String, ByRef fileName As String)
        Dim query As String = "SELECT TOP 1 FileName, StartCheckSum FROM SmartLinkWebService WHERE ID = @ID"

        Using command = GetCommand(query)
            command.Parameters.AddWithValue("ID", id)
            Using reader As SqlDataReader = command.ExecuteReader()
                reader.Read()
                fileName = reader("FileName")
                startCheckSum = reader("StartCheckSum")
            End Using
        End Using
    End Sub

    Public Sub StoreEndTransmission(ByVal id As String, ByVal success As Boolean, ByVal endChecksum As String)
        Dim query As String = "UPDATE SmartLinkWebService SET EndCheckSum = @EndCheckSum, Success = @Success"
        If success Then
            query += ", EndTime = GETDATE()"
        End If
        query += " WHERE ID = @ID"

        Using command = GetCommand(query)
            command.Parameters.AddWithValue("ID", id)
            command.Parameters.AddWithValue("EndCheckSum", endChecksum)
            command.Parameters.AddWithValue("Success", success)

            command.ExecuteNonQuery()
        End Using

    End Sub

    Public Function BuildReceipt(ByVal id As String) As XmlElement
        Dim query As String = "SELECT * FROM SmartLinkWebService WHERE ID = @ID"

        Using command = GetCommand(query)
            command.Parameters.AddWithValue("ID", id)
            Using reader As SqlDataReader = command.ExecuteReader()

                reader.Read()

                Dim doc As XmlDocument = New XmlDocument()
                Dim root As XmlElement = doc.CreateElement("NRC_Receipt")
                doc.AppendChild(root)

                Dim i As Integer
                For i = 0 To reader.FieldCount - 1
                    Dim setting As XmlElement = doc.CreateElement("setting")
                    setting.SetAttribute("name", reader.GetName(i))
                    setting.SetAttribute("serializeAs", Convert.ToString(reader.GetFieldType(i)))

                    Dim value As XmlElement = doc.CreateElement("value")
                    value.InnerText = reader.Item(i).ToString()

                    root.AppendChild(setting)
                    setting.AppendChild(value)
                Next

                Return root
            End Using
        End Using

    End Function

    ''' <summary>
    ''' Get a command with the proper timeout
    ''' </summary>
    Private Function GetCommand(ByRef sql As String) As SqlCommand
        Dim cmd As New SqlCommand(sql, _connection)
        Dim timeout As Integer

        If Integer.TryParse(WebConfigurationManager.AppSettings("SQLTimeoutInSeconds"), timeout) Then
            cmd.CommandTimeout = timeout
        End If

        Return cmd

    End Function

End Class
