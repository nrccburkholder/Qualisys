Imports Nrc.Qualisys.QualisysDataEntry.Library
Imports System.Data.OleDb
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class ucFileImport
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents txtFilePath As System.Windows.Forms.TextBox
    Friend WithEvents lblFile As System.Windows.Forms.Label
    Friend WithEvents spnImport As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents btnBrowse As System.Windows.Forms.Button
    Friend WithEvents ofdOpenFile As System.Windows.Forms.OpenFileDialog
    Friend WithEvents btnImport As System.Windows.Forms.Button
    Friend WithEvents cboLitho As System.Windows.Forms.ComboBox
    Friend WithEvents cboQstnCore As System.Windows.Forms.ComboBox
    Friend WithEvents cboResult As System.Windows.Forms.ComboBox
    Friend WithEvents pbProgress As System.Windows.Forms.ProgressBar
    Friend WithEvents lblStatus As System.Windows.Forms.Label
    Friend WithEvents grpColumns As System.Windows.Forms.GroupBox
    Friend WithEvents grpFile As System.Windows.Forms.GroupBox
    Friend WithEvents grpStatus As System.Windows.Forms.GroupBox
    Friend WithEvents txtErrors As System.Windows.Forms.TextBox
    Friend WithEvents lblQstnCore As System.Windows.Forms.Label
    Friend WithEvents lblResult As System.Windows.Forms.Label
    Friend WithEvents lblLitho As System.Windows.Forms.Label

    Private Sub InitializeComponent()
        Me.txtFilePath = New System.Windows.Forms.TextBox
        Me.lblFile = New System.Windows.Forms.Label
        Me.spnImport = New Nrc.Framework.WinForms.SectionPanel
        Me.grpStatus = New System.Windows.Forms.GroupBox
        Me.lblStatus = New System.Windows.Forms.Label
        Me.pbProgress = New System.Windows.Forms.ProgressBar
        Me.grpFile = New System.Windows.Forms.GroupBox
        Me.btnBrowse = New System.Windows.Forms.Button
        Me.grpColumns = New System.Windows.Forms.GroupBox
        Me.lblQstnCore = New System.Windows.Forms.Label
        Me.cboQstnCore = New System.Windows.Forms.ComboBox
        Me.cboResult = New System.Windows.Forms.ComboBox
        Me.lblResult = New System.Windows.Forms.Label
        Me.lblLitho = New System.Windows.Forms.Label
        Me.cboLitho = New System.Windows.Forms.ComboBox
        Me.btnImport = New System.Windows.Forms.Button
        Me.txtErrors = New System.Windows.Forms.TextBox
        Me.ofdOpenFile = New System.Windows.Forms.OpenFileDialog
        Me.spnImport.SuspendLayout()
        Me.grpStatus.SuspendLayout()
        Me.grpFile.SuspendLayout()
        Me.grpColumns.SuspendLayout()
        Me.SuspendLayout()
        '
        'txtFilePath
        '
        Me.txtFilePath.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtFilePath.Location = New System.Drawing.Point(88, 48)
        Me.txtFilePath.Name = "txtFilePath"
        Me.txtFilePath.ReadOnly = True
        Me.txtFilePath.Size = New System.Drawing.Size(280, 21)
        Me.txtFilePath.TabIndex = 0
        '
        'lblFile
        '
        Me.lblFile.Location = New System.Drawing.Point(8, 48)
        Me.lblFile.Name = "lblFile"
        Me.lblFile.Size = New System.Drawing.Size(80, 23)
        Me.lblFile.TabIndex = 1
        Me.lblFile.Text = "Data File Path:"
        Me.lblFile.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'spnImport
        '
        Me.spnImport.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.spnImport.Caption = "Import File"
        Me.spnImport.Controls.Add(Me.grpStatus)
        Me.spnImport.Controls.Add(Me.grpFile)
        Me.spnImport.Controls.Add(Me.grpColumns)
        Me.spnImport.Controls.Add(Me.txtErrors)
        Me.spnImport.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spnImport.Location = New System.Drawing.Point(0, 0)
        Me.spnImport.Name = "spnImport"
        Me.spnImport.Padding = New System.Windows.Forms.Padding(1)
        Me.spnImport.ShowCaption = True
        Me.spnImport.Size = New System.Drawing.Size(416, 672)
        Me.spnImport.TabIndex = 2
        '
        'grpStatus
        '
        Me.grpStatus.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grpStatus.Controls.Add(Me.lblStatus)
        Me.grpStatus.Controls.Add(Me.pbProgress)
        Me.grpStatus.Location = New System.Drawing.Point(16, 400)
        Me.grpStatus.Name = "grpStatus"
        Me.grpStatus.Size = New System.Drawing.Size(384, 120)
        Me.grpStatus.TabIndex = 12
        Me.grpStatus.TabStop = False
        Me.grpStatus.Text = "Status"
        '
        'lblStatus
        '
        Me.lblStatus.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblStatus.Location = New System.Drawing.Point(16, 82)
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(352, 30)
        Me.lblStatus.TabIndex = 1
        '
        'pbProgress
        '
        Me.pbProgress.Location = New System.Drawing.Point(16, 48)
        Me.pbProgress.Name = "pbProgress"
        Me.pbProgress.Size = New System.Drawing.Size(312, 23)
        Me.pbProgress.TabIndex = 0
        '
        'grpFile
        '
        Me.grpFile.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grpFile.Controls.Add(Me.btnBrowse)
        Me.grpFile.Controls.Add(Me.txtFilePath)
        Me.grpFile.Controls.Add(Me.lblFile)
        Me.grpFile.Location = New System.Drawing.Point(16, 40)
        Me.grpFile.Name = "grpFile"
        Me.grpFile.Size = New System.Drawing.Size(384, 128)
        Me.grpFile.TabIndex = 11
        Me.grpFile.TabStop = False
        Me.grpFile.Text = "Data File"
        '
        'btnBrowse
        '
        Me.btnBrowse.Location = New System.Drawing.Point(88, 80)
        Me.btnBrowse.Name = "btnBrowse"
        Me.btnBrowse.Size = New System.Drawing.Size(80, 23)
        Me.btnBrowse.TabIndex = 3
        Me.btnBrowse.Text = "Browse..."
        '
        'grpColumns
        '
        Me.grpColumns.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grpColumns.Controls.Add(Me.lblQstnCore)
        Me.grpColumns.Controls.Add(Me.cboQstnCore)
        Me.grpColumns.Controls.Add(Me.cboResult)
        Me.grpColumns.Controls.Add(Me.lblResult)
        Me.grpColumns.Controls.Add(Me.lblLitho)
        Me.grpColumns.Controls.Add(Me.cboLitho)
        Me.grpColumns.Controls.Add(Me.btnImport)
        Me.grpColumns.Location = New System.Drawing.Point(16, 192)
        Me.grpColumns.Name = "grpColumns"
        Me.grpColumns.Size = New System.Drawing.Size(384, 184)
        Me.grpColumns.TabIndex = 10
        Me.grpColumns.TabStop = False
        Me.grpColumns.Text = "Data Columns"
        '
        'lblQstnCore
        '
        Me.lblQstnCore.Location = New System.Drawing.Point(16, 80)
        Me.lblQstnCore.Name = "lblQstnCore"
        Me.lblQstnCore.Size = New System.Drawing.Size(100, 23)
        Me.lblQstnCore.TabIndex = 8
        Me.lblQstnCore.Text = "QstnCore Column:"
        '
        'cboQstnCore
        '
        Me.cboQstnCore.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboQstnCore.Location = New System.Drawing.Point(120, 80)
        Me.cboQstnCore.Name = "cboQstnCore"
        Me.cboQstnCore.Size = New System.Drawing.Size(200, 21)
        Me.cboQstnCore.TabIndex = 7
        '
        'cboResult
        '
        Me.cboResult.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboResult.Location = New System.Drawing.Point(120, 112)
        Me.cboResult.Name = "cboResult"
        Me.cboResult.Size = New System.Drawing.Size(200, 21)
        Me.cboResult.TabIndex = 7
        '
        'lblResult
        '
        Me.lblResult.Location = New System.Drawing.Point(16, 112)
        Me.lblResult.Name = "lblResult"
        Me.lblResult.Size = New System.Drawing.Size(100, 23)
        Me.lblResult.TabIndex = 8
        Me.lblResult.Text = "Result Column:"
        '
        'lblLitho
        '
        Me.lblLitho.Location = New System.Drawing.Point(16, 48)
        Me.lblLitho.Name = "lblLitho"
        Me.lblLitho.Size = New System.Drawing.Size(100, 23)
        Me.lblLitho.TabIndex = 8
        Me.lblLitho.Text = "Litho Column:"
        '
        'cboLitho
        '
        Me.cboLitho.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboLitho.Location = New System.Drawing.Point(120, 48)
        Me.cboLitho.Name = "cboLitho"
        Me.cboLitho.Size = New System.Drawing.Size(200, 21)
        Me.cboLitho.TabIndex = 7
        '
        'btnImport
        '
        Me.btnImport.Location = New System.Drawing.Point(16, 144)
        Me.btnImport.Name = "btnImport"
        Me.btnImport.Size = New System.Drawing.Size(75, 23)
        Me.btnImport.TabIndex = 4
        Me.btnImport.Text = "Import"
        '
        'txtErrors
        '
        Me.txtErrors.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtErrors.Location = New System.Drawing.Point(16, 528)
        Me.txtErrors.Multiline = True
        Me.txtErrors.Name = "txtErrors"
        Me.txtErrors.ReadOnly = True
        Me.txtErrors.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtErrors.Size = New System.Drawing.Size(384, 128)
        Me.txtErrors.TabIndex = 2
        '
        'ofdOpenFile
        '
        Me.ofdOpenFile.Filter = "DBF Files|*.DBF|Comma Delimited Text|*.CSV|Phone/Web Files|*.CMT;*.RTD|All Files|" & _
            "*.*"
        Me.ofdOpenFile.Title = "Select a file to import..."
        '
        'ucFileImport
        '
        Me.Controls.Add(Me.spnImport)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "ucFileImport"
        Me.Size = New System.Drawing.Size(416, 672)
        Me.spnImport.ResumeLayout(False)
        Me.spnImport.PerformLayout()
        Me.grpStatus.ResumeLayout(False)
        Me.grpFile.ResumeLayout(False)
        Me.grpFile.PerformLayout()
        Me.grpColumns.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Members "

    Private mColumns() As Column
    Private mMaxScanRows As Integer = 25
    Private mUndoRegistryHack As Boolean

#End Region

#Region " Control Events "

    'Browse button CLICK - Allows the user to select a file to import
    Private Sub btnBrowse_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBrowse.Click

        'Show the dialog
        If ofdOpenFile.ShowDialog() = DialogResult.OK Then
            'Set the file path label
            txtFilePath.Text = ofdOpenFile.FileName
            Dim file As New System.IO.FileInfo(ofdOpenFile.FileName)

            If file.Extension.ToUpper = ".CMT" OrElse file.Extension.ToUpper = ".RTD" Then
                'This is a phone/web file
                'Disable the column selection group except for the import button
                EnableGroup(grpColumns, False)
                btnImport.Enabled = True
            Else
                'Get the list of columns from the file
                mColumns = GetColumns(file)

                'Populate the column dropdown lists with the column names
                PopulateDropDowns()

                'Now enable the column selection group
                EnableGroup(grpColumns, True)
            End If

            'Clear the status
            lblStatus.Text = String.Empty
        End If

    End Sub

    'Control LOAD - Initialize the form
    Private Sub ucFileImport_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Initialize()

    End Sub

    'Import button CLICK - Import the data into SQL
    Private Sub btnImport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnImport.Click

        Dim file As New System.IO.FileInfo(txtFilePath.Text)

        'Make sure all the input is valid
        If IsValidInput(file) Then
            Try
                'Turn on the status group
                EnableGroup(grpStatus, True)
                Windows.Forms.Cursor.Current = Cursors.WaitCursor

                'Import
                ImportData(file)

            Catch ex As Exception
                MessageBox.Show(ex.Message, "Import Exception", MessageBoxButtons.OK, MessageBoxIcon.Error)

            Finally
                EnableGroup(grpColumns, False)
                EnableGroup(grpStatus, False)
                Windows.Forms.Cursor.Current = Cursor

            End Try
        End If

    End Sub

#End Region

#Region " Private Methods "

    'Initialize the controls
    Private Sub Initialize()

        EnableGroup(grpFile, True)
        EnableGroup(grpColumns, False)
        EnableGroup(grpStatus, False)

    End Sub

    'Fill the column dropdown lists with the column names
    Private Sub PopulateDropDowns()

        Dim col As Column
        cboLitho.Items.Clear()
        cboQstnCore.Items.Clear()
        cboResult.Items.Clear()

        For Each col In mColumns
            cboLitho.Items.Add(col)
            cboQstnCore.Items.Add(col)
            cboResult.Items.Add(col)

            'Autoselect...
            If ContainsText(col.ColumnName, "litho") Then cboLitho.SelectedItem = col
            If ContainsText(col.ColumnName, "qstncore") Then cboQstnCore.SelectedItem = col
            If ContainsText(col.ColumnName, "result") Then cboResult.SelectedItem = col
        Next

    End Sub

    Private Function ContainsText(ByVal containerText As String, ByVal searchText As String) As Boolean

        Return (containerText.ToLower.IndexOf(searchText.ToLower) > -1)

    End Function

    'Validates all the input values
    Private Function IsValidInput(ByVal file As System.IO.FileInfo) As Boolean

        If file.Extension.ToUpper <> ".CMT" AndAlso file.Extension.ToUpper <> ".RTD" Then
            'Each column drop down must be selected
            If cboLitho.Text.Length = 0 OrElse cboResult.Text.Length = 0 OrElse cboQstnCore.Text.Length = 0 Then
                MessageBox.Show("You must select a database column for each of the required data.", "Column Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End If

            'Column drop downs must be unique
            If cboLitho.Text = cboQstnCore.Text OrElse _
                cboLitho.Text = cboResult.Text OrElse _
                cboResult.Text = cboQstnCore.Text Then
                MessageBox.Show("Each column of data must map to a different database column.", "Column Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return False
            End If
        End If

        'The file must exist
        If Not file.Exists Then
            MessageBox.Show("The specified file does not exist!", "File Not Found Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        End If

        'Okay, I guess we are good
        Return True

    End Function

    Private Function GetColumns(ByVal file As System.IO.FileInfo) As Column()

        Dim tblName As String = file.Name
        Dim SQL As String = "SELECT TOP 10 * FROM " & tblName
        Dim i As Integer

        Using con As OleDbConnection = GetConnection(file)
            'Open the connection and read out the schema for a "SELECT *"
            con.Open()
            Dim cmd As New OleDbCommand(SQL, con)

            Using reader As IDataReader = cmd.ExecuteReader
                Using tblSchema As DataTable = reader.GetSchemaTable
                    Dim cols(tblSchema.Rows.Count - 1) As Column

                    'Now store each column name to our array
                    For i = 0 To tblSchema.Rows.Count - 1
                        cols(i) = New Column(tblSchema.Rows(i)("ColumnName").ToString)
                    Next

                    'return the array
                    Return cols
                End Using
            End Using
        End Using

    End Function

    'Imports each of the specified columns into QualiSys QDE tables
    Private Sub ImportData(ByVal file As System.IO.FileInfo)

        If file.Extension.ToUpper = ".CMT" OrElse file.Extension.ToUpper = ".RTD" Then
            ImportDataPhoneWeb(file)
        Else
            ImportDataOleDb(file)
        End If

    End Sub

    Private Sub ImportDataPhoneWeb(ByVal file As System.IO.FileInfo)

        Dim line As String = String.Empty
        Dim comma1 As Integer
        Dim comma2 As Integer
        Dim comma3 As Integer
        Dim comma4 As Integer
        Dim barcode As String = String.Empty
        Dim lithoCode As String = String.Empty
        Dim qstnCore As Integer
        Dim cmntText As String = String.Empty
        Dim done As Boolean = False
        Dim btch As Batch
        Dim rowCount As Integer
        Dim successCount As Integer
        Dim failCount As Integer

        Const qstnCoreOffset As Integer = 500000

        'Get the row count
        Using rdr As System.IO.TextReader = file.OpenText
            line = rdr.ReadLine
            While line IsNot Nothing
                rowCount += 1
                line = rdr.ReadLine
            End While
            rdr.Close()
        End Using

        'Exit if the file does not have anything in it
        If rowCount <= 0 Then
            Exit Sub
        End If

        'Process the file
        Using rdr As System.IO.TextReader = file.OpenText
            'Setup the progress bar
            pbProgress.Maximum = rowCount
            pbProgress.Minimum = 0
            pbProgress.Value = 0

            txtErrors.Text = ""
            btch = Batch.InsertNewBatch(CurrentUser.LoginName, Batch.BatchOriginType.LoadedFromFile)

            'Get the first line of the file
            line = rdr.ReadLine()

            'Loop through the file and import each row
            While line IsNot Nothing
                'Skip the line if it is empty
                If line.Trim.Length > 0 Then
                    'Get the barcode
                    comma1 = line.IndexOf(",")
                    barcode = line.Substring(0, comma1)

                    'Convert the barcode to a LithoCode
                    lithoCode = Litho.BarcodeToLitho(barcode)

                    'Get the comments
                    Do Until done
                        If AppConfig.Params("QSIIncludeQuestionTextInCMT").IntegerValue = 0 Then
                            'Question Text is not in the file
                            'Find the comma between the QstnCore and the comment
                            comma2 = line.IndexOf(",", comma1 + 1)

                            'Find the closing quotation mark of the comment string
                            comma3 = line.IndexOf(Chr(34), comma2 + 2)

                            'Find the comma at the end of the comment string
                            comma3 = line.IndexOf(",", comma3)
                            If comma3 < 0 Then
                                comma3 = line.Length
                                done = True
                            Else
                                done = False
                            End If

                            'Get the QstnCore
                            qstnCore = CInt(line.Substring(comma1 + 1, comma2 - comma1 - 1)) - qstnCoreOffset

                            'Get the comment text
                            cmntText = line.Substring(comma2 + 1, comma3 - comma2 - 1)

                            'Prepare for next pass
                            comma1 = comma3
                        Else
                            'Question Text is in the file
                            'Find the comma between the QstnCore and the comment
                            comma2 = line.IndexOf(",", comma1 + 1)

                            'Find the closing quotation mark of the question text
                            comma3 = line.IndexOf(Chr(34), comma2 + 2)

                            'Find the comma between the question text and the comment string
                            comma3 = line.IndexOf(",", comma3)

                            'Find the closing quotation mark of the comment string
                            comma4 = line.IndexOf(Chr(34), comma3 + 2)

                            'Find the comma at the end of the comment string
                            comma4 = line.IndexOf(",", comma4)
                            If comma4 < 0 Then
                                comma4 = line.Length
                                done = True
                            Else
                                done = False
                            End If

                            'Get the QstnCore
                            qstnCore = CInt(line.Substring(comma1 + 1, comma2 - comma1 - 1)) - qstnCoreOffset

                            'Get the comment text
                            cmntText = line.Substring(comma3 + 1, comma4 - comma3 - 1)

                            'Prepare for next pass
                            comma1 = comma4
                        End If

                        'Strip the quotes from the comment text if they exist
                        If cmntText.StartsWith(CStr(Chr(34))) Then
                            cmntText = cmntText.Substring(1)
                        End If

                        If cmntText.EndsWith(CStr(Chr(34))) Then
                            cmntText = cmntText.Substring(0, cmntText.Length - 1)
                        End If

                        'Write this comment to the QDE table
                        Try
                            Comment.ImportCommentData(btch.BatchID, lithoCode, qstnCore, cmntText)
                            successCount += 1

                        Catch ex As Exception
                            failCount += 1
                            txtErrors.AppendText(String.Format("Record {0} Litho {1} - {2}{3}", (successCount + 1), IIf(lithoCode = "", "?", lithoCode), ex.Message, vbCrLf))
                            Dim failedCommentImportLogEntry As Log = New Log("Failed Comment Import", String.Format("Record {0} Litho {1} - {2}", (successCount + 1), IIf(lithoCode = "", "?", lithoCode), ex.Message))

                        End Try
                    Loop
                End If

                'Update the status
                pbProgress.Value += 1

                'Get the next line from the file
                line = rdr.ReadLine()
                done = False
            End While

            'Close the file
            rdr.Close()
        End Using

        'Finalize the batch
        btch.UpdateBatchIgnoreFlags(False)

        'Show status
        lblStatus.Text = String.Format("{0} record(s) imported successfully with {1} error(s).", successCount, failCount)
        pbProgress.Value = 0

    End Sub

    Private Sub ImportDataOleDb(ByVal file As System.IO.FileInfo)

        Dim tblName As String = file.Name
        Dim con As OleDbConnection = Nothing
        'Select statement will only use the columns the user defined
        Dim SQL As String = String.Format("SELECT [{0}] AS LITHO, [{1}] AS QSTNCORE, [{2}] AS RESULT FROM [{3}]", cboLitho.Text, cboQstnCore.Text, cboResult.Text, tblName)
        Dim cmd As OleDbCommand
        Dim adpt As OleDbDataAdapter
        Dim tblData As New DataTable
        Dim row As DataRow
        Dim successCount As Integer = 0
        Dim failCount As Integer = 0
        Dim btch As Batch

        Try
            'Modify the registry to aide in column type recognition
            PerformJETProviderRegistryHack()
            con = GetConnection(file)
            cmd = New OleDbCommand(SQL, con)
            adpt = New OleDbDataAdapter(cmd)

            'Fill the dataTable
            adpt.Fill(tblData)

            'Setup the progress bar
            pbProgress.Maximum = tblData.Rows.Count
            pbProgress.Minimum = 0
            pbProgress.Value = 0

            txtErrors.Text = ""
            btch = Batch.InsertNewBatch(CurrentUser.LoginName, Batch.BatchOriginType.LoadedFromFile)

            'For each row, insert the comment into the QDEComments table
            For Each row In tblData.Rows
                Try
                    Comment.ImportCommentData(btch.BatchID, row("LITHO").ToString, CInt(row("QSTNCORE")), row("RESULT").ToString)
                    successCount += 1
                Catch ex As Exception
                    failCount += 1
                    txtErrors.AppendText(String.Format("Record {0} Litho {1} - {2}{3}", (successCount + 1), IIf(row("LITHO").ToString = "", "?", row("LITHO").ToString), ex.Message, vbCrLf))
                    'SK 10-02-2008 If logging is on, this failure will be logged, including ex.message
                    Dim failedCommentImportLogEntry As Log = New Log("Failed Comment Import", String.Format("Record {0} Litho {1} - {2}", (successCount + 1), IIf(row("LITHO").ToString = "", "?", row("LITHO").ToString), ex.Message))
                End Try
                pbProgress.Value += 1
            Next

            btch.UpdateBatchIgnoreFlags(False)

            'Show status
            lblStatus.Text = String.Format("{0} record(s) imported successfully with {1} error(s).", successCount, failCount)
            pbProgress.Value = 0

        Finally
            If Not con Is Nothing Then con.Close()
            'Undo our registry changes
            UndoJETProviderRegistryHack()

        End Try

    End Sub

    Private Sub PerformJETProviderRegistryHack()

        'The JET OLEDB provider by default scans the first 25 lines of a text file to determine column types
        'If none of the comments in the first 25 lines are longer than 255 characters then it will call the
        'column a "TEXT" column and all comments longer than 255 characters in the remaining rows will be
        'truncated.  Changing this registry key tell JET to scan more records before determining the types
        Try
            Dim key As Microsoft.Win32.RegistryKey = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("SOFTWARE\Microsoft\Jet\4.0\Engines\Text", True)
            mMaxScanRows = CType(key.GetValue("MaxScanRows"), Integer)
            key.SetValue("MaxScanRows", 10000)
            mUndoRegistryHack = True

        Catch ex As Exception
            Throw New Exception("Unable to modify 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Jet\4.0\Engines\Text\MaxScanRows' registry key", ex)

        End Try

    End Sub

    Private Sub UndoJETProviderRegistryHack()

        If mUndoRegistryHack Then
            Try
                Dim key As Microsoft.Win32.RegistryKey = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("SOFTWARE\Microsoft\Jet\4.0\Engines\Text", True)
                key.SetValue("MaxScanRows", mMaxScanRows)
                mUndoRegistryHack = False

            Catch ex As Exception
                Throw New Exception("Unable to modify 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Jet\4.0\Engines\Text\MaxScanRows' registry key", ex)

            End Try
        End If

    End Sub

    Private Function GetConnection(ByVal file As System.IO.FileInfo) As OleDbConnection

        Dim conString As String

        Select Case file.Extension.ToUpper
            Case ".DBF"
                conString = String.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=dBASE IV;", file.DirectoryName)

            Case ".CSV"
                conString = String.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties='TEXT;DriverId=27;FIL=text;MaxBufferSize=2048;PageTimeout=30;'", file.DirectoryName)

            Case Else
                Throw New ArgumentException("A file was specified with an unsupported file type extension.")

        End Select

        Return New OleDbConnection(conString)

    End Function

    'Enable/Disable all controls in a group
    Private Sub EnableGroup(ByVal grp As GroupBox, ByVal enable As Boolean)

        For Each ctrl As Control In grp.Controls
            ctrl.Enabled = enable
        Next

    End Sub

#End Region

#Region " Column Structure "

    Private Structure Column

        Public ColumnName As String
        Public IsUsed As Boolean

        Sub New(ByVal name As String)

            ColumnName = name
            IsUsed = False

        End Sub

        Public Overrides Function ToString() As String

            Return ColumnName

        End Function

    End Structure

#End Region

End Class

