Imports Nrc.SurveyPoint.Library
Imports Nrc.Framework.BusinessLogic
Public Class ImportExportSection
#Region " Fields "
    Friend WithEvents mImportExportNavigator As ImportExportNavigator
    Private WithEvents mExportDefintion As SPTI_ExportDefinition = Nothing
    Private mSourceTemplates As SPTI_FileTemplateCollection = Nothing
    Private mExportTemplates As SPTI_FileTemplateCollection = Nothing
    Private mdeDupDialgForm As ExportDefQMSDeDupRule
#End Region
#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mImportExportNavigator = TryCast(navCtrl, ImportExportNavigator)

    End Sub
    Public Overrides Sub ActivateSection()
        MyBase.ActivateSection()
        Me.mImportExportNavigator.LoadDefinitions()
    End Sub
#End Region
#Region " Constructors "
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()
    End Sub
#End Region
#Region " Event Handlers "
    Private Sub mNavigator_ExportDefinitionSelected(ByVal sender As Object, ByVal e As ExportDefintionSelectedEventArgs) Handles mImportExportNavigator.ExportDefintionUserAction
        ' Add any initialization after the InitializeComponent() call.
        Me.mSourceTemplates = SPTI_FileTemplate.GetAll
        Me.mExportTemplates = SPTI_FileTemplate.GetAll
        Me.cboSourceTemplates.DataSource = Me.mSourceTemplates
        Me.cboSourceTemplates.DisplayMember = "Name"
        Me.cboExportTemplates.DataSource = Me.mExportTemplates
        Me.cboExportTemplates.DisplayMember = "Name"

        Dim exportDefID As Integer = e.ExportDefinitionID

        If e.ExportDefintionAction = ExportDefinitionActions.Selected Then
            If exportDefID = 0 Then 'New
                Me.mExportDefintion = Nrc.SurveyPoint.Library.SPTI_ExportDefinition.NewSPTI_ExportDefinition
            Else
                Me.mExportDefintion = Nrc.SurveyPoint.Library.SPTI_ExportDefinition.Get(exportDefID)
            End If
            LoadScreen()
        End If
    End Sub
    Private Sub cmdCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCancel.Click
        If MessageBox.Show("Are you sure you with to cancel and lose any changes?", "Warning", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) = DialogResult.OK Then
            Me.mExportDefintion = Nrc.SurveyPoint.Library.SPTI_ExportDefinition.Get(Me.mExportDefintion.ExportDefinitionID)
            LoadScreen()
        End If
    End Sub
    Private Sub cmdSourceFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSourceFile.Click
        If Me.txtSourceFile.Text.Trim <> "" Then
            Dim mInitDir As String = Mid(Me.txtSourceFile.Text, 1, Me.txtSourceFile.Text.LastIndexOf("\"c) + 1)
            If System.IO.Directory.Exists(mInitDir) Then
                Me.OpenFileDialog1.InitialDirectory = mInitDir
            End If
        End If
        If Me.OpenFileDialog1.ShowDialog() = DialogResult.OK Then
            Me.txtSourceFile.Text = Me.OpenFileDialog1.FileName
            Me.OpenFileDialog1.FileName = ""
        End If
    End Sub
    Private Sub cmdExportPath_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdExportPath.Click
        If Me.txtExportFilePath.Text.Trim <> "" Then
            Dim mInitDir As String = Mid(Me.txtExportFilePath.Text, 1, Me.txtExportFilePath.Text.LastIndexOf("\"c) + 1)
            If System.IO.Directory.Exists(mInitDir) Then
                Me.SaveFileDialog1.InitialDirectory = mInitDir
            End If
        End If
        If Me.SaveFileDialog1.ShowDialog() = DialogResult.OK Then
            Me.txtExportFilePath.Text = Me.SaveFileDialog1.FileName
            Me.SaveFileDialog1.FileName = ""
        End If
    End Sub
    Private Sub cmdAddExportFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdAddExportFile.Click
        Dim ef As SPTI_ExportDefintionFile = SPTI_ExportDefintionFile.NewSPTI_ExportDefintionFile()
        ef.Name = Me.txtExportFileName.Text
        ef.PathandFileName = Me.txtExportFilePath.Text
        ef.ExportDefinitionID = Me.mExportDefintion.ExportDefinitionID
        Me.mExportDefintion.ExportFiles.Add(ef)
        Me.bsExportFiles.DataSource = Me.mExportDefintion.ExportFiles
        Me.txtExportFileName.SelectAll()
    End Sub
    Private Sub cmdEditExportFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdEditExportFile.Click
        Dim OldEF As SPTI_ExportDefintionFile
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdExportFilesGridView.GetSelectedRows
            rowHandle = i
        Next
        OldEF = TryCast(Me.grdExportFiles.DefaultView.GetRow(rowHandle), SPTI_ExportDefintionFile)
        If Not OldEF Is Nothing Then
            OldEF.Name = Me.txtExportFileName.Text
            OldEF.PathandFileName = Me.txtExportFilePath.Text
            OldEF.ExportDefinitionID = Me.mExportDefintion.ExportDefinitionID
            Me.bsExportFiles.DataSource = Me.mExportDefintion.ExportFiles
            Me.grdExportFiles.DataSource = Me.bsExportFiles
            'Me.grdExportFilesGridView.RefreshData()
            'Me.grdExportFilesGridView.SelectRow(rowHandle)
            Me.txtExportFileName.SelectAll()
        End If
        
    End Sub
    Private Sub cmdDeleteExportFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdDeleteExportFile.Click
        Dim OldEF As SPTI_ExportDefintionFile
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdExportFilesGridView.GetSelectedRows
            rowHandle = i
        Next
        OldEF = TryCast(Me.grdExportFiles.DefaultView.GetRow(rowHandle), SPTI_ExportDefintionFile)
        If Not OldEF Is Nothing Then
            Me.mExportDefintion.ExportFiles.RemoveExportDefinitionFile(OldEF)
            Me.grdExportFiles.DataSource = bsExportFiles
            Me.grdExportFilesGridView.RefreshData()
        End If
        Me.txtExportFileName.SelectAll()
    End Sub
    Private Sub cmdAddRule_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdAddRule.Click
        Dim file As SPTI_ExportDefintionFile = Nothing
        'file = TryCast(Me.bsExportFiles.Current, SPTI_ExportDefintionFile)
        'If Not file Is Nothing Then
        '    file.SplitRule = Me.txtSplitRule.Text
        '    bsExportFiles.ResetCurrentItem()
        'End If
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdExportFileWithRulesView.GetSelectedRows
            rowHandle = i
        Next
        file = TryCast(Me.grdExportFileWithRules.DefaultView.GetRow(rowHandle), SPTI_ExportDefintionFile)
        If Not file Is Nothing Then
            file.SplitRule = Me.txtSplitRule.Text
            Me.bsExportFiles.DataSource = Me.mExportDefintion.ExportFiles
            Me.grdExportFiles.DataSource = bsExportFiles
            Me.grdExportFilesGridView.RefreshData()
        End If
    End Sub
    Private Sub cmdClearRule_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdClearRule.Click    
        Dim file As SPTI_ExportDefintionFile = Nothing
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdExportFileWithRulesView.GetSelectedRows
            rowHandle = i
        Next
        file = TryCast(Me.grdExportFileWithRules.DefaultView.GetRow(rowHandle), SPTI_ExportDefintionFile)
        If Not file Is Nothing Then
            file.SplitRule = ""
            Me.bsExportFiles.DataSource = Me.mExportDefintion.ExportFiles
            Me.grdExportFiles.DataSource = bsExportFiles
            Me.grdExportFilesGridView.RefreshData()
        End If
    End Sub
    Private Sub cmdClearDeDupRule_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdClearDeDupRule.Click        
        Dim bsExportFile As SPTI_ExportDefintionFile = TryCast(Me.bsExportFiles.Current, SPTI_ExportDefintionFile)
        If Not bsExportFile Is Nothing Then
            If Not bsExportFile.DBDeDupRule Is Nothing Then
                If bsExportFile.FileID > 0 Then
                    SPTI_DeDupRule.DeleteDeDupRuleAndChildren(bsExportFile.FileID)
                End If
                bsExportFile.DBDeDupRule = Nothing
            End If
        End If        
        Me.bsExportFiles.DataSource = Me.mExportDefintion.ExportFiles
        RefreshDeDupScreenItems()
    End Sub
    Private Sub cmdAddDeDupRule_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdAddDeDupRule.Click
        Dim file As SPTI_ExportDefintionFile = Nothing
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdExportFileWithDeDupRulesView.GetSelectedRows
            rowHandle = i
        Next
        file = TryCast(Me.grdExportFileWithDeDupRules.DefaultView.GetRow(rowHandle), SPTI_ExportDefintionFile)
        If Not file Is Nothing Then            
            mdeDupDialgForm = New ExportDefQMSDeDupRule(Me.mExportDefintion, file)
            AddHandler mdeDupDialgForm.DedupRuleChanged, AddressOf DeDupDialogHandler
            mdeDupDialgForm.ShowDialog()
        Else
            MessageBox.Show("You have not select a valid export file to add a de-dup rule to.")
        End If
    End Sub
    Private Sub cmdOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdOK.Click
        LoadFromScreen()
        Dim rules As Validation.BrokenRulesCollection = Nothing
        rules = Me.mExportDefintion.ValidateAll
        If rules Is Nothing Then
            Me.mExportDefintion.Save()            
            LoadScreen()
            MessageBox.Show("Export Definition has been saved.", "Export Definition Save", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Else
            Dim dlg As New ValidationErrorsDialog(rules)
            dlg.ShowDialog()
        End If
    End Sub
    Private Sub cmdRun_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdRun.Click
        LoadFromScreen()
        'You can't property validate the existance of an export file, so you must manually check the count.
        If Me.mExportDefintion.ExportFiles.Count < 1 Then
            MessageBox.Show("You must have at least one export file to run.", "Export Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        Else
            Dim rules As Validation.BrokenRulesCollection = Nothing
            rules = Me.mExportDefintion.ValidateAll
            If rules Is Nothing Then
                'You  must save when you run so you can property log and journal the export def.
                Me.mExportDefintion.Save()
                LoadScreen()
                Dim dlg As New ExportDefinitionStatusDialog(Me.mExportDefintion)
                dlg.Show()
                Dim tempEDID As Integer = Me.mExportDefintion.ExportDefinitionID
                Me.mExportDefintion = Nothing
                Me.mExportDefintion = SPTI_ExportDefinition.Get(tempEDID)
            Else
                Dim dlg As New ValidationErrorsDialog(rules)
                dlg.ShowDialog()
            End If
        End If        
    End Sub
    Private Sub bsExportFiles_CurrentChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles bsExportFiles.CurrentChanged
        Dim col As SPTI_ExportDefintionFile
        Dim bindSource As System.Windows.Forms.BindingSource
        bindSource = TryCast(sender, System.Windows.Forms.BindingSource)
        col = TryCast(bindSource.Current, SPTI_ExportDefintionFile)
        If Not col Is Nothing Then
            SetColInputs(col)
        End If
    End Sub
    Private Sub TabControl1_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TabControl1.SelectedIndexChanged
        RefreshDeDupScreenItems()
    End Sub
    Private Sub DeDupDialogHandler(ByVal sender As Object, ByVal e As DeDupRuleSelectedEventArgs)
        RefreshDeDupScreenItems()
        RemoveHandler mdeDupDialgForm.DedupRuleChanged, AddressOf DeDupDialogHandler
    End Sub
    Private Sub ImportExportSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.cboSIStartDate.Items.Clear()
        For i As Integer = 1 To 36
            Me.cboSIStartDate.Items.Add(i)
        Next
    End Sub
#End Region
#Region " Private Methods "
    Private Sub LoadScreen()
        If Me.mExportDefintion.HasHeader Then
            Me.chkHasHeader.Checked = True
        Else
            Me.chkHasHeader.Checked = False
        End If
        Me.txtExportDefinitionName.Text = Me.mExportDefintion.Name
        Me.txtDescription.Text = Me.mExportDefintion.Description
        If Not Me.mExportDefintion.SourceFile Is Nothing Then
            Me.txtSourceFileName.Text = Me.mExportDefintion.SourceFile.Name
            Me.txtSourceFile.Text = Me.mExportDefintion.SourceFile.PathandFileName
        Else
            Me.txtSourceFileName.Text = ""
            Me.txtSourceFile.Text = ""
        End If
        If Me.mExportDefintion.ExportFiles Is Nothing OrElse Me.mExportDefintion.ExportFiles.Count = 0 Then
            Me.txtExportFileName.Text = ""
            Me.txtExportFilePath.Text = ""
        End If
        If Me.mExportDefintion.SourceFileTemplateID = 0 Then
            Me.cboSourceTemplates.SelectedIndex = 0
        Else
            For i As Integer = 0 To Me.cboSourceTemplates.Items.Count
                If CType(Me.cboSourceTemplates.Items(i), SPTI_FileTemplate).FileTemplateID = Me.mExportDefintion.SourceFileTemplateID Then
                    Me.cboSourceTemplates.SelectedIndex = i
                    Exit For
                End If
            Next
        End If
        If Me.mExportDefintion.ExportFileTemplateID = 0 Then
            Me.cboExportTemplates.SelectedIndex = 0
        Else
            For i As Integer = 0 To Me.cboExportTemplates.Items.Count
                If CType(Me.cboExportTemplates.Items(i), SPTI_FileTemplate).FileTemplateID = Me.mExportDefintion.ExportFileTemplateID Then
                    Me.cboExportTemplates.SelectedIndex = i
                    Exit For
                End If
            Next
        End If
        'Pop the file dedup list box by what the selected source template is.
        Me.lstSourceTemplateColsForFileDeDup.Items.Clear()
        Dim cboTemplate As SPTI_FileTemplate = TryCast(Me.cboSourceTemplates.SelectedItem, SPTI_FileTemplate)
        If Not cboTemplate Is Nothing Then
            For Each col As SPTI_ColumnDefinition In cboTemplate.ColumnDefinitions
                Me.lstSourceTemplateColsForFileDeDup.Items.Add(col.Name)
            Next
        End If
        'Select the file dedup rules.
        If Me.mExportDefintion.FileDeDupRule.Length > 0 Then
            Dim strArray() As String = Me.mExportDefintion.FileDeDupRule.Split(","c)
            For i As Integer = 0 To Me.lstSourceTemplateColsForFileDeDup.Items.Count - 1
                For Each str As String In strArray
                    If str = CStr(Me.lstSourceTemplateColsForFileDeDup.Items(i)) Then
                        Me.lstSourceTemplateColsForFileDeDup.SelectedIndex = i
                        Exit For
                    End If
                Next
            Next
        End If
        Me.cboSIStartDate.SelectedItem = Me.mExportDefintion.SIDeDupStartDate
        'Me.bsExportFiles.Clear()
        Me.bsExportFiles.DataSource = Me.mExportDefintion.ExportFiles
        RefreshDeDupScreenItems()
    End Sub
    Private Sub LoadFromScreen()
        Me.mExportDefintion.Name = Me.txtExportDefinitionName.Text
        Me.mExportDefintion.Description = Me.txtDescription.Text
        If Me.mExportDefintion.SourceFile Is Nothing Then
            Me.mExportDefintion.SourceFile = SPTI_ExportDefintionFile.NewSPTI_ExportDefintionFile(Me.mExportDefintion.ExportDefinitionID, Me.txtSourceFileName.Text, Me.txtSourceFile.Text, True)
        End If
        Me.mExportDefintion.SourceFile.Name = Me.txtSourceFileName.Text
        Me.mExportDefintion.SourceFile.PathandFileName = Me.txtSourceFile.Text
        Me.mExportDefintion.SourceFileTemplateID = CType(Me.cboSourceTemplates.SelectedItem, SPTI_FileTemplate).FileTemplateID
        Me.mExportDefintion.ExportFileTemplateID = CType(Me.cboExportTemplates.SelectedItem, SPTI_FileTemplate).FileTemplateID
        If Me.chkHasHeader.Checked Then
            Me.mExportDefintion.HasHeader = True
        Else
            Me.mExportDefintion.HasHeader = False
        End If
        Me.mExportDefintion.FileDeDupRule = ""
        Dim colList As String = ""
        For Each item As Object In Me.lstSourceTemplateColsForFileDeDup.SelectedItems
            colList += CStr(item) & ","
        Next
        Me.mExportDefintion.SIDeDupStartDate = CInt(Me.cboSIStartDate.SelectedItem)
        If colList.Length > 0 Then
            colList = colList.Substring(0, colList.Length - 1)
        End If
        Me.mExportDefintion.FileDeDupRule = colList
    End Sub
    Private Sub SetColInputs(ByVal col As SPTI_ExportDefintionFile)
        Me.txtExportFileName.Text = col.Name
        Me.txtExportFilePath.Text = col.PathandFileName
        'Me.txtFileDeDupRule.Text = col.FileDeDupRule
        'Me.txtDeDupRule.Text = col.DeDupRule
        Me.txtSplitRule.Text = col.SplitRule
        SetDeDupScreen(col)
    End Sub
    Private Sub RefreshDeDupScreenItems()
        Dim edFile As SPTI_ExportDefintionFile
        Dim rowHandle As Integer = 0
        For Each i As Integer In Me.grdExportFilesGridView.GetSelectedRows
            rowHandle = i
        Next        
        edFile = TryCast(Me.grdExportFiles.DefaultView.GetRow(rowHandle), SPTI_ExportDefintionFile)
        If Not edFile Is Nothing Then
            SetDeDupScreen(edFile)        
        End If
    End Sub
    Private Sub SetDeDupScreen(ByVal file As SPTI_ExportDefintionFile)
        If Not file.DBDeDupRule Is Nothing Then
            Me.lblRuleName.Text = file.DBDeDupRule.Name
            If file.DBDeDupRule.ActiveSI Then
                Me.chkRuleSIActive.Checked = True
            Else
                Me.chkRuleSIActive.Checked = False
            End If            
            If Not file.DBDeDupRule.DeDupRuleClientIDs Is Nothing AndAlso file.DBDeDupRule.DeDupRuleClientIDs.Count > 0 Then
                Dim tempString As String = String.Empty
                For Each item As SPTI_DeDupRuleClientID In file.DBDeDupRule.DeDupRuleClientIDs
                    tempString += item.ClientID & ","
                Next
                tempString = tempString.Substring(0, tempString.Length - 1)
                Me.lblClientIDs.Text = tempString
            Else
                Me.lblClientIDs.Text = ""
            End If
            If Not file.DBDeDupRule.DeDupRuleColumnMaps Is Nothing AndAlso file.DBDeDupRule.DeDupRuleColumnMaps.Count > 0 Then
                Dim tempString As String = String.Empty
                For Each item As SPTI_DeDupRuleColumnMap In file.DBDeDupRule.DeDupRuleColumnMaps
                    tempString += "([" & item.QMSColumnName & "] = [" & item.FileTemplateColumnName & "]) and "
                Next
                tempString = tempString.Substring(0, tempString.Length - 4)
                Me.txtSearchCriteria.Text = tempString
            Else
                Me.txtSearchCriteria.Text = ""
            End If
        Else
            lblRuleName.Text = ""            
            Me.chkRuleSIActive.Checked = False
            lblClientIDs.Text = ""
            Me.txtSearchCriteria.Text = ""
        End If
    End Sub
#End Region

    
End Class
