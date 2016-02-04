Imports System.Data
'Imports Aspose.Words
Imports MailMergePrep.Library
Imports PS.Framework.BusinessLogic
Imports System.Diagnostics

Public Class MailMergeSection
#Region " Fields "
    Dim mNavigator As ReportNavigator
    Dim mMMBase As MailMergePrepBase = Nothing
    Dim mValidatedSurveyDataTable As DataTable
#End Region
#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mNavigator = TryCast(navCtrl, ReportNavigator)

    End Sub

    Public Overrides Sub ActivateSection()
        'AddHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Public Overrides Sub InactivateSection()
        'RemoveHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub
#End Region
#Region " Event Handlers "
    Private Sub cmdSaveSettings_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        SaveSettings()
    End Sub
    Private Sub MailMergeSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        EndProgress()
        If System.IO.Directory.Exists(Config.DefaultDataPath) Then
            Me.OpenFileDialog1.InitialDirectory = Config.DefaultDataPath
        End If
        If System.IO.Directory.Exists(Config.DefaultDocPath) Then
            Me.FolderBrowserDialog1.SelectedPath = Config.DefaultDocPath
        End If
        'txtSurveyDataFile.Text = My.Settings.SurveyDataFile
        'txtTemplateDirectory.Text = My.Settings.TemplateDirectory
        HideValidationUI()
    End Sub
    Private Sub cmdSurveyDateFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSurveyDateFile.Click
        Dim result As DialogResult = Me.OpenFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtSurveyDataFile.Text = Me.OpenFileDialog1.FileName
        End If
    End Sub
    Private Sub cmdTemplateDirectory_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdTemplateDirectory.Click
        Dim result As DialogResult = Me.FolderBrowserDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtTemplateDirectory.Text = Me.FolderBrowserDialog1.SelectedPath
        End If
    End Sub
    Private Sub cmdCorrectedFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCorrectedFile.Click
        Dim result As DialogResult = Me.SaveFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtCorrectFile.Text = Me.SaveFileDialog1.FileName
        End If
    End Sub
    Private Sub cmdSaveCorrected_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSaveCorrected.Click
        If txtCorrectFile.Text.Length > 0 Then
            Try
                MailMergeData.SaveDataTableToCSV(Me.mValidatedSurveyDataTable, Me.txtCorrectFile.Text)
                MessageBox.Show("Your new file was successfully saved.")
            Catch ex As Exception
                Globals.ReportException(ex)
            End Try
        Else
            MessageBox.Show("You must first enter a file to save.", "File Corrections", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
    End Sub
    Private Sub cmdMailMerge_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdMailMerge.Click
        Cursor.Current = Cursors.WaitCursor
        Try
            Dim win() As Process = Nothing
            win = Process.GetProcessesByName("WINWORD")
            If win.Length > 0 Then
                MessageBox.Show("Please close all instances of Microsoft Word prior to merging the survey(s).", "Survey Merge", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Else
                StartProgress()
                ValidateMailMerge(False)
                MailMerge()
                If Not Me.mMMBase.ValidationMessages.ErrorsExist Then
                    MessageBox.Show("Merge successfully completed.  " & Me.mMMBase.MMData.TotalRecordCount & " records merged.", "Merge Action", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Else
                    MessageBox.Show("Merge encountered errors, please correct and try again.", "Merge Action", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                End If
            End If
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            EndProgress()
            Cursor.Current = Cursors.Default
        End Try
    End Sub
    Private Sub cmdValidate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdValidate.Click
        Cursor.Current = Cursors.WaitCursor
        Try
            Dim win() As Process = Nothing
            win = Process.GetProcessesByName("WINWORD")
            If win.Length > 0 Then
                MessageBox.Show("Please close all instances of Microsoft Word prior to validation.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Else
                StartProgress()
                ValidateMailMerge(True)
                If Not Me.mMMBase.ValidationMessages.ErrorsExist Then
                    MessageBox.Show("Validate successfully completed.  " & Me.mMMBase.MMData.TotalRecordCount & " total records validated.", "Validate Action", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Else
                    MessageBox.Show("Validate encountered errors, please correct and try again.", "Validate Action", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                End If
            End If
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            EndProgress()
            Cursor.Current = Cursors.Default
        End Try
    End Sub
    Private Sub cmdReValidate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdReValidate.Click
        Cursor.Current = Cursors.WaitCursor
        Try
            Dim win() As Process = Nothing
            win = Process.GetProcessesByName("WINWORD")
            If win.Length > 0 Then
                MessageBox.Show("Please close all instances of Microsoft Word prior to validating the survey(s).", "Survey Merge", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Else
                StartProgress()
                ValidateMailMerge(True, True)
                If Not Me.mMMBase.ValidationMessages.ErrorsExist Then
                    MessageBox.Show("Re-Validate successfully completed.  " & Me.mMMBase.MMData.TotalRecordCount & " records validated.", "Validate Action", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Else
                    MessageBox.Show("Re-Validate encountered errors, please correct and try again.", "Validate Action", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                End If
            End If
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            Cursor.Current = Cursors.Default
            EndProgress()
        End Try
    End Sub
    Private Sub cmdReMerge_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdReMerge.Click
        Cursor.Current = Cursors.WaitCursor
        Try
            Dim win() As Process = Nothing
            win = Process.GetProcessesByName("WINWORD")
            If win.Length > 0 Then
                MessageBox.Show("Please close all instances of Microsoft Word prior to merging the survey(s).", "Survey Merge", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Else
                StartProgress()
                ValidateMailMerge(False, True)
                MailMerge()
                If Not Me.mMMBase.ValidationMessages.ErrorsExist Then
                    MessageBox.Show("Re-Merge successfully completed.  " & Me.mMMBase.MMData.TotalRecordCount & " records merged.", "Merge Action", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Else
                    MessageBox.Show("Re-Merge encountered errors, please correct and try again.", "Merge Action", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                End If
            End If
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            EndProgress()
            Cursor.Current = Cursors.Default
        End Try
    End Sub
    Private Sub cmdShowPreview_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdShowPreview.Click
        Dim filePath As String = CStr(cboPreview.SelectedItem)
        If System.IO.File.Exists(filePath) Then
            Dim psi As New ProcessStartInfo(filePath)
            Process.Start(filePath)
        Else
            MessageBox.Show("Invalid Preview File Selected.", "Preview", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
    End Sub
    Private Sub cmdSetInstructions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSetInstructions.Click
        SetTemplateInstructions()
    End Sub
#End Region

#Region " Private Methods "
    Private Sub SetTemplateInstructions()
        Try
            txtInstructions.Text = ""
            txtSpecialInstructions.Text = ""
            Dim templateID As Integer = MailMergeTemplateInstruction.GetTemplateIDFromDirectory(Me.txtTemplateDirectory.Text)
            If templateID <= 0 Then
                MessageBox.Show("Could not derive template ID from Template Directory.", "Set Instructions", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Else
                Dim obj As MailMergeTemplateInstruction = MailMergeTemplateInstruction.GetMailMergeTemplateInstruction(templateID)
                If obj.Instructions.Length = 0 AndAlso obj.SpecialInstructions.Length = 0 Then
                    MessageBox.Show("No instructions exist for template: " & templateID & ".", "Set Instructions", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Else
                    txtInstructions.Text = obj.Instructions
                    txtSpecialInstructions.Text = obj.SpecialInstructions
                    MessageBox.Show("Instructions have been recieved from the database.", "Set Instructions", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            End If
        Catch ex As Exception
            Globals.ReportException(ex)
        End Try
    End Sub
    Private Sub StartProgress()
        Dim frm As MainForm = TryCast(Me.ParentForm, MainForm)
        frm.lblStatus.Text = "Processing, please wait."
        My.Application.DoEvents()
    End Sub
    Private Sub EndProgress()
        Dim frm As MainForm = TryCast(Me.ParentForm, MainForm)
        frm.lblStatus.Text = "Ready."
    End Sub
    ''' <summary>
    ''' This method is no longer used. (At this time).
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub SaveSettings()
        'My.Settings.SurveyDataFile = txtSurveyDataFile.Text
        'My.Settings.TemplateDirectory = txtTemplateDirectory.Text
        'MessageBox.Show("Your settings have been saved.", "Settings Change", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub
    Private Sub MailMerge()
        mMMBase.Transfer()
        DisplayValidation()
    End Sub
    Private Sub ValidateMailMerge(ByVal valiadtionOnly As Boolean, Optional ByVal validatedDT As Boolean = False)
        HideValidationUI()
        mMMBase = MailMergePrepBase.NewMailMergePrepBase(txtSurveyDataFile.Text, txtTemplateDirectory.Text, txtMergeName.Text, txtInstructions.Text, txtSpecialInstructions.Text, CurrentUser.UserName)
        If Not validatedDT Then
            mMMBase.Load()
        Else
            mMMBase.Load(mValidatedSurveyDataTable)
        End If
        Me.mValidatedSurveyDataTable = Nothing
        mMMBase.Validate()
        If Not Me.mMMBase.ValidationMessages.ErrorsExist Then
            Dim preview As Validation.ObjectValidations = mMMBase.GeneratePreview()
            SetPreview(preview)
        End If
        If valiadtionOnly Then
            DisplayValidation()
        End If
    End Sub
    Private Sub SetPreview(ByVal preview As Validation.ObjectValidations)
        lblPreviewMerge.Visible = True
        cboPreview.Visible = True
        cmdShowPreview.Visible = True
        cboPreview.Items.Clear()
        For Each item As Validation.ObjectValidation In preview.MyValidations
            cboPreview.Items.Add(item.Message)
        Next
        cboPreview.SelectedIndex = 0
    End Sub
    Private Sub HidePreviewDisplay()
        lblPreviewMerge.Visible = False
        cboPreview.Visible = False
        cmdShowPreview.Visible = False
    End Sub
    Private Sub DisplayValidation()
        If Not mMMBase.ValidationMessages.ErrorsExist Then
            grpInformation.Visible = True
            grpInformation.Text = "Informational Messages"
            lblMessageType.Text = "Validation/Merge Successful"
            dgInformation.DataSource = mMMBase.ValidationMessages.MyValidations
            dgInformation.Columns("ValidationID").Visible = False
            dgInformation.Columns("StackTrace").Visible = False
            dgInformation.Columns("Message").AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
        Else
            If mMMBase.MMData IsNot Nothing AndAlso mMMBase.MMData.HasDataError Then
                SetEditableValidationGrid()
            Else
                grpInformation.Visible = True
                grpInformation.Text = "Error Messages"
                lblMessageType.Text = "Validation/Merge Error(s) - Please correct and try again."
                dgInformation.DataBindings.Clear()
                dgInformation.DataSource = mMMBase.ValidationMessages.MyValidations
                dgInformation.Columns("ValidationID").Visible = False
                dgInformation.Columns("Message").AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
            End If
        End If
    End Sub
    Private Sub SetEditableValidationGrid()
        'TODO: Need to set columns and move bs so I can retrieve.
        grpInformation.Visible = False
        grpDataErrors.Visible = True
        bsValidationErrors.DataSource = mMMBase.ValidationMessages.MyValidations
        dgErrors.DataSource = bsValidationErrors
        dgErrors.Columns("ValidationID").Visible = False
        dgErrors.Columns("ClassName").Visible = False
        dgErrors.Columns("MethodName").Visible = False
        dgErrors.Columns("Message").AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
        mValidatedSurveyDataTable = mMMBase.MMData.GetInValidSurveyDataTable
        bsDataErrors.DataSource = mValidatedSurveyDataTable
        bsDataErrors.Filter = "ISVALID = False"
        dgDataCorrections.DataSource = bsDataErrors
    End Sub
    Private Sub HideValidationUI()
        grpInformation.Visible = False
        grpDataErrors.Visible = False
    End Sub
#End Region

    
End Class
