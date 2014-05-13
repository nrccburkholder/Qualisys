Imports System.Data.SqlClient
Imports System.Text
Imports EnvironmentManager.library
Public Class ExportToSQLForm
#Region "Private Fields"
    Dim mTemplate As SQLScriptGenerator
    Dim mCurrentFileName As String
    Private Shared mDictionaryOfConnectionStrings As New Dictionary(Of String, String)
    Dim mExecuteToConnection As SqlConnection

#End Region
#Region "Private Properties"
    Private Property SQLScript() As String
        Get
            Return Me.RichTextBox1.Text
        End Get
        Set(ByVal value As String)
            Me.RichTextBox1.Text = value
            RefreshDisplay()
        End Set
    End Property
    Private ReadOnly Property CanSave() As Boolean
        Get
            Return Not String.IsNullOrEmpty(SQLScript)
        End Get
    End Property
    Private ReadOnly Property CanExecute() As Boolean
        Get
            'Return Not String.IsNullOrEmpty(ExecuteToConnectionString) AndAlso Not String.IsNullOrEmpty(SQLScript)
            Return DictionaryOfConnectionStrings.Count > 0 AndAlso Not String.IsNullOrEmpty(SQLScript)
        End Get
    End Property
    Private Shared Property DictionaryOfConnectionStrings() As Dictionary(Of String, String)
        Get
            Return mDictionaryOfConnectionStrings
        End Get
        Set(ByVal value As Dictionary(Of String, String))
            mDictionaryOfConnectionStrings = value
        End Set
    End Property
    Private Property ExecuteToConnection() As SqlConnection
        Get
            Return mExecuteToConnection
        End Get
        Set(ByVal value As SqlConnection)
            mExecuteToConnection = value
        End Set
    End Property
    Private Property CurrentFileName() As String
        Get
            Return mCurrentFileName
        End Get
        Set(ByVal value As String)
            mCurrentFileName = value
        End Set
    End Property

#End Region
#Region "Public Properties"

#End Region
#Region "Public Methods"
    Public Sub New(ByVal connectionString As String, ByVal filterExpression As String, Optional ByVal tableName As String = "QualPro_Params")
        InitializeComponent()

        Dim Schema As New TableSchema(connectionString, tableName)
        mTemplate = New SQLScriptGenerator(Schema)
        mTemplate.WhereClause = filterExpression
        RefreshDisplay()
    End Sub
    Public Sub New(ByVal connectionString As String, Optional ByVal paramList As List(Of SqlClient.SqlParameter) = Nothing, Optional ByVal tableName As String = "QualPro_Params")

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Dim Schema As New TableSchema(connectionString, tableName)
        mTemplate = New SQLScriptGenerator(Schema)
        mTemplate.FilterParameters = paramList
        RefreshDisplay()
    End Sub

#End Region
#Region "Private Methods"
    Private Sub RefreshDisplay()
        Me.TestToolStripButton.Enabled = CanExecute
        Me.ExecuteToolStripButton.Enabled = CanExecute
        Me.SaveAsToolStripButton.Enabled = CanSave
        Me.SaveToolStripButton.Enabled = CanSave
    End Sub

    Private Sub PopulateTargetDatabaseList()
        'We need this only once. If there's a need to repopulate just clear the dictionary.
        If DictionaryOfConnectionStrings.Count > 0 Then Exit Sub
        For Each EnvName As String In Config.EnvironmentSettings.Environments.Keys
            If Not DictionaryOfConnectionStrings.ContainsKey(EnvName) Then
                DictionaryOfConnectionStrings.Add(EnvName, Config.EnvironmentSettings.Environments(EnvName).Settings("ConfigurationConnection").PlainValue)
            End If
        Next
    End Sub

    Private Sub ExecuteScriptForAllSelectedTargets(Optional ByVal testAndRollback As Boolean = False)
        Dim Messages As New StringBuilder
        For Each item As DevExpress.XtraEditors.Controls.CheckedListBoxItem In CLBTargetDataBases.Items
            If item.CheckState = CheckState.Checked Then
                Dim DBConnectionName As String = CStr(item.Value)
                Dim DbConnectionString As String = DictionaryOfConnectionStrings(DBConnectionName)
                Try
                    Messages.AppendLine(String.Format("{0} in {1}.", RunSQLScript(DbConnectionString, testAndRollback), DBConnectionName))
                Catch ex As Exception
                    MessageBox.Show(ex.Message)
                End Try
            End If
        Next
        Me.txtCurrentConnection.Text = Messages.ToString
    End Sub

    Private Function RunSQLScript(ByVal DbConnectionString As String, Optional ByVal testAndRollback As Boolean = False) As String
        Using ExecuteToConnection = New SqlClient.SqlConnection(DbConnectionString)
            Using cmd As New SqlClient.SqlCommand(Me.SQLScript, ExecuteToConnection)
                Try
                    ExecuteToConnection.Open()
                    ' Start a local transaction
                    Using transaction As SqlClient.SqlTransaction = ExecuteToConnection.BeginTransaction("TestTransaction")
                        cmd.Transaction = transaction
                        Dim AffectedRows As Integer = cmd.ExecuteNonQuery()
                        If testAndRollback Then
                            transaction.Rollback()
                            Return String.Format("Test Success: {0} rows will be affected ", AffectedRows)
                        Else
                            transaction.Commit()
                            Return String.Format("Success!  {0} rows are affected ", AffectedRows)
                        End If
                    End Using
                Catch ex As Exception
                    MessageBox.Show(ex.Message, "Failed!", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Return "Failed"
                End Try
            End Using
        End Using
    End Function

    Private Sub ExportToSQL()
        Dim SaveFileDialog As New SaveFileDialog()
        SaveFileDialog.Filter = "SQL files (*.sql)|*.sql|All files (*.*)|*.*"
        SaveFileDialog.FilterIndex = 1
        SaveFileDialog.RestoreDirectory = True
        If SaveFileDialog.ShowDialog() = DialogResult.OK Then
            TSQLOutputLink.CreateDocument()
            TSQLOutputLink.PrintingSystem.ExportToText(SaveFileDialog.FileName)
            CurrentFileName = SaveFileDialog.FileName
        End If
    End Sub

    Private Sub GenerateSQLText()
        mTemplate.UseStoredProcedure = Me.UseSPCheckBox.Checked
        mTemplate.StoredProcedureName = Me.SPNameTextBox.Text
        SQLScript = mTemplate.GetInsertStatements()
    End Sub

#End Region
#Region "Event Handlers"
    Private Sub ExportToSQLForm_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        PopulateTargetDatabaseList()
        For Each key As String In DictionaryOfConnectionStrings.Keys
            Me.CLBTargetDataBases.Items.Add(key)
        Next
        GenerateSQLText()
    End Sub

    Private Sub OpenToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OpenToolStripButton.Click
        Dim OpenFileDialog As New OpenFileDialog
        OpenFileDialog.Filter = "SQL files (*.sql)|*.sql|All files (*.*)|*.*"
        OpenFileDialog.FilterIndex = 1
        OpenFileDialog.RestoreDirectory = True
        If OpenFileDialog.ShowDialog() = DialogResult.OK Then
            Try
                Me.SQLScript = System.IO.File.ReadAllText(OpenFileDialog.FileName)
                CurrentFileName = OpenFileDialog.FileName
            Catch ex As Exception
                MessageBox.Show(ex.Message, String.Format("Failed to open {0}.", OpenFileDialog.FileName), MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub

    Private Sub SaveAsToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveAsToolStripButton.Click
        ExportToSQL()
    End Sub

    Private Sub IgnoreIdentityCheckBox_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles IgnoreIdentityCheckBox.CheckedChanged
        If mTemplate IsNot Nothing Then
            mTemplate.IgnoreIdentityColumn = IgnoreIdentityCheckBox.Checked
        End If
    End Sub

    Private Sub UseSPCheckBox_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UseSPCheckBox.CheckedChanged
        If mTemplate IsNot Nothing Then
            mTemplate.UseStoredProcedure = UseSPCheckBox.Checked
            Me.SPNameTextBox.Enabled = UseSPCheckBox.Checked
        End If
    End Sub

    Private Sub SaveToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveToolStripButton.Click
        Me.SQLScript = Me.RichTextBox1.Text
        If String.IsNullOrEmpty(CurrentFileName) Then
            ExportToSQL()
        Else
            TSQLOutputLink.CreateDocument()
            TSQLOutputLink.PrintingSystem.ExportToText(CurrentFileName)
        End If
    End Sub

    Private Sub PrintToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PrintToolStripButton.Click
        TSQLOutputLink.ShowPreview()
    End Sub

    Private Sub GenerateSQLButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GenerateSQLButton.Click
        GenerateSQLText()
    End Sub

    Private Sub ExecuteToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExecuteToolStripButton.Click
        ExecuteScriptForAllSelectedTargets()
    End Sub

    Private Sub TestToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TestToolStripButton.Click
        ExecuteScriptForAllSelectedTargets(True)
    End Sub

    Private Sub CLBTargetDataBases_SelectedValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CLBTargetDataBases.SelectedValueChanged
        Me.txtCurrentConnection.Text = DictionaryOfConnectionStrings(CStr(Me.CLBTargetDataBases.SelectedValue))
    End Sub


#End Region


End Class
