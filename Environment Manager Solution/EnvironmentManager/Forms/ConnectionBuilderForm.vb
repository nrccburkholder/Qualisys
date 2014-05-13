Imports System.Data.SqlClient
Imports EnvironmentManager.library
Public Class ConnectionBuilderForm
    Private mAuthenticationModeSelected As Boolean
    Private mServerList As ListOfServers
    Private mMyConnectionStringBuilder As New SqlConnectionStringBuilder

    Private Property ServerList() As ListOfServers
        Get
            Return mServerList
        End Get
        Set(ByVal value As ListOfServers)
            mServerList = value
        End Set
    End Property
    'Public Sub New()
    '    InitializeComponent()

    '    'PopulateServerList()
    'End Sub
    '    Private Sub PopulateServerList()
    '        Dim s As System.Data.Sql.SqlDataSourceEnumerator = Data.Sql.SqlDataSourceEnumerator.Instance
    '        ServerList = ServerProperty.GetServerList(s.GetDataSources())
    '        Me.cboServers.DisplayMember = "ServerName"
    '        Me.cboServers.DataSource = ServerList
    '        cboServers.SelectedIndex = 0
    '    End Sub
    Private Sub UpdateDisplay()
        Me.pnlCredentials.Enabled = NeedCredentials
        Me.gbAuthentication.Enabled = Not String.IsNullOrEmpty(SelectedServer)
        Me.mAuthenticationModeSelected = Me.rbSQLAuth.Checked Or Me.rbWindowsAuth.Checked
        Me.cboDatabases.Enabled = mAuthenticationModeSelected
        Me.btnTest.Enabled = Not String.IsNullOrEmpty(SelectedDatabaseName)
        Me.btnOK.Enabled = Me.btnTest.Enabled
    End Sub
    Private Sub rbWindowsAuth_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles rbWindowsAuth.CheckedChanged
        UpdateDisplay()
    End Sub
    Private Function GetDatabaseList() As List(Of String)
        If Not mAuthenticationModeSelected Then Return Nothing
        If String.IsNullOrEmpty(SelectedServer) Then Return Nothing
        Dim list As New List(Of String)
        MyConnectionStringBuilder.Clear()
        MyConnectionStringBuilder.DataSource = SelectedServer
        MyConnectionStringBuilder("Initial Catalog") = "master"
        If IntegratedSecurity Then
            MyConnectionStringBuilder("Integrated Security") = "True"
        Else
            MyConnectionStringBuilder("User") = Username
            MyConnectionStringBuilder("Password") = Password
        End If
        Using cnn As New SqlClient.SqlConnection
            cnn.ConnectionString = MyConnectionStringBuilder.ToString
            Try
                cnn.Open()
            Catch ex As Exception
                MessageBox.Show("Failed to connect to " & SelectedServer)
                Return list
            End Try
            Using cmd As New SqlClient.SqlCommand
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandText = "sp_databases"
                cmd.CommandTimeout = 600
                cmd.Connection = cnn
                Using rdr As Data.SqlClient.SqlDataReader = cmd.ExecuteReader()
                    While rdr.Read
                        list.Add(rdr.GetValue(0).ToString())
                    End While
                End Using
            End Using
        End Using
        Return List
    End Function
#Region "Private Properties"

    Private Property MyConnectionStringBuilder() As SqlConnectionStringBuilder
        Get
            Return mMyConnectionStringBuilder
        End Get
        Set(ByVal value As SqlConnectionStringBuilder)
            mMyConnectionStringBuilder = value
        End Set
    End Property
    Private ReadOnly Property Password() As String
        Get
            Return txtPassword.Text
        End Get
    End Property
    Public ReadOnly Property SelectedDatabaseName() As String
        Get
            Return cboDatabases.Text
        End Get
    End Property
    Dim mSelectedServer As String
    Private Property SelectedServer() As String
        Get
            Return mSelectedServer
        End Get
        Set(ByVal value As String)
            mSelectedServer = value
        End Set
    End Property
    Private ReadOnly Property NeedCredentials() As Boolean
        Get
            Return rbSQLAuth.Checked
        End Get
    End Property
    Private ReadOnly Property Username() As String
        Get
            Return txtUserName.Text
        End Get
    End Property
    Private ReadOnly Property IntegratedSecurity() As Boolean
        Get
            Return rbWindowsAuth.Checked
        End Get
    End Property

#End Region
    Dim mServerNameIsTyped As Boolean = False
    Private Sub SelectServer(ByVal serverName As String)
        If Not String.IsNullOrEmpty(serverName) Then
            SelectedServer = serverName
            Me.rbWindowsAuth.Checked = False
            Me.rbSQLAuth.Checked = False
            Me.cboDatabases.DataSource = Nothing
            SelectedServer = serverName
            UpdateDisplay()
        End If
    End Sub

    Private Sub cboServers_Enter(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboServers.Enter
        UpdateDisplay()
    End Sub
    Private Sub cboServers_LostFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboServers.LostFocus
        If mServerNameIsTyped Then
            SelectServer(cboServers.Text)
            mServerNameIsTyped = False
            UpdateDisplay()
        End If
    End Sub
    Private Sub cboServers_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboServers.SelectedIndexChanged
        SelectServer(cboServers.Text)
    End Sub

    Private Sub rbSQLAuth_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles rbSQLAuth.CheckedChanged
        UpdateDisplay()
    End Sub
    Public ReadOnly Property ConnectionString() As String
        Get
            MyConnectionStringBuilder("Initial Catalog") = Me.SelectedDatabaseName
            Return MyConnectionStringBuilder.ToString
        End Get
    End Property

    Private Sub cboDatabases_Enter(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboDatabases.Enter
        If cboDatabases.DataSource Is Nothing Then
            Me.cboDatabases.DataSource = GetDatabaseList()
            UpdateDisplay()
        End If
    End Sub

    Private Sub cboServers_TextUpdate(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboServers.TextUpdate
        mServerNameIsTyped = True
    End Sub

    Private Sub btnTest_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnTest.Click
        Using cnn As New SqlConnection(Me.ConnectionString)
            Try
                cnn.Open()
                MessageBox.Show("Connection Succeeded")
            Catch ex As Exception
                MessageBox.Show(ex.Message, "Connection Failed!", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Using
    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        Me.DialogResult = DialogResult.OK
        Me.Close()
    End Sub

End Class