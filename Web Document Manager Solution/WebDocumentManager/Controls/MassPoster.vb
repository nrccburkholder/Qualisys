Imports NRC.DataMart.WebDocumentManager.Library
Imports NRC.NRCAuthLib
Public Class MassPoster
    Inherits System.Windows.Forms.UserControl

    Private docs As New MassPostDocumentCollection
    Friend WithEvents MassPostDocumentGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents MassPostDocumentBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents DocumentsGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colTreeGroupName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPostingOutcomeLabel As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colGroupName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colOrgUnitName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPostErrorMessage As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFolderPath As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFileName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNodePath As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colWebLabel As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ReplaceCheckBox As System.Windows.Forms.CheckBox
    Private mMember As Member
    Friend WithEvents FileDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents btnExportToExcel As System.Windows.Forms.Button
    Friend WithEvents btnExportPDF As System.Windows.Forms.Button
    Private mBatch As DocumentBatch

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
    Friend WithEvents SectionPanel1 As Nrc.WinForms.SectionPanel
    Friend WithEvents ofdMassPost As System.Windows.Forms.OpenFileDialog
    Friend WithEvents btnPost As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.ofdMassPost = New System.Windows.Forms.OpenFileDialog
        Me.SectionPanel1 = New Nrc.WinForms.SectionPanel
        Me.btnExportPDF = New System.Windows.Forms.Button
        Me.btnExportToExcel = New System.Windows.Forms.Button
        Me.MassPostDocumentGridControl = New DevExpress.XtraGrid.GridControl
        Me.MassPostDocumentBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.DocumentsGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colTreeGroupName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colPostingOutcomeLabel = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colGroupName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colOrgUnitName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colPostErrorMessage = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFolderPath = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFileName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNodePath = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colWebLabel = New DevExpress.XtraGrid.Columns.GridColumn
        Me.ReplaceCheckBox = New System.Windows.Forms.CheckBox
        Me.btnPost = New System.Windows.Forms.Button
        Me.FileDialog = New System.Windows.Forms.SaveFileDialog
        Me.SectionPanel1.SuspendLayout()
        CType(Me.MassPostDocumentGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MassPostDocumentBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DocumentsGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'ofdMassPost
        '
        Me.ofdMassPost.Filter = "excel (*.xls)|*.xls"
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "Mass Postings"
        Me.SectionPanel1.Controls.Add(Me.btnExportPDF)
        Me.SectionPanel1.Controls.Add(Me.btnExportToExcel)
        Me.SectionPanel1.Controls.Add(Me.MassPostDocumentGridControl)
        Me.SectionPanel1.Controls.Add(Me.ReplaceCheckBox)
        Me.SectionPanel1.Controls.Add(Me.btnPost)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(898, 664)
        Me.SectionPanel1.TabIndex = 1
        '
        'btnExportPDF
        '
        Me.btnExportPDF.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnExportPDF.Image = Global.NRCWebDocumentManager.My.Resources.Resources.pdf
        Me.btnExportPDF.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btnExportPDF.Location = New System.Drawing.Point(683, 35)
        Me.btnExportPDF.Name = "btnExportPDF"
        Me.btnExportPDF.Size = New System.Drawing.Size(102, 24)
        Me.btnExportPDF.TabIndex = 14
        Me.btnExportPDF.Text = "Export to PDF"
        Me.btnExportPDF.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageBeforeText
        Me.btnExportPDF.UseVisualStyleBackColor = True
        Me.btnExportPDF.Visible = False
        '
        'btnExportToExcel
        '
        Me.btnExportToExcel.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnExportToExcel.Image = Global.NRCWebDocumentManager.My.Resources.Resources.Excel16
        Me.btnExportToExcel.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.btnExportToExcel.Location = New System.Drawing.Point(791, 35)
        Me.btnExportToExcel.Name = "btnExportToExcel"
        Me.btnExportToExcel.Size = New System.Drawing.Size(102, 24)
        Me.btnExportToExcel.TabIndex = 12
        Me.btnExportToExcel.Text = "Export to Excel"
        Me.btnExportToExcel.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageBeforeText
        Me.btnExportToExcel.UseVisualStyleBackColor = True
        '
        'MassPostDocumentGridControl
        '
        Me.MassPostDocumentGridControl.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MassPostDocumentGridControl.DataSource = Me.MassPostDocumentBindingSource
        Me.MassPostDocumentGridControl.EmbeddedNavigator.Name = ""
        Me.MassPostDocumentGridControl.Location = New System.Drawing.Point(2, 63)
        Me.MassPostDocumentGridControl.MainView = Me.DocumentsGridView
        Me.MassPostDocumentGridControl.Name = "MassPostDocumentGridControl"
        Me.MassPostDocumentGridControl.Size = New System.Drawing.Size(891, 557)
        Me.MassPostDocumentGridControl.TabIndex = 2
        Me.MassPostDocumentGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.DocumentsGridView})
        '
        'MassPostDocumentBindingSource
        '
        Me.MassPostDocumentBindingSource.DataSource = GetType(Nrc.DataMart.WebDocumentManager.Library.MassPostDocument)
        '
        'DocumentsGridView
        '
        Me.DocumentsGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colTreeGroupName, Me.colPostingOutcomeLabel, Me.colGroupName, Me.colOrgUnitName, Me.colPostErrorMessage, Me.colFolderPath, Me.colFileName, Me.colNodePath, Me.colWebLabel})
        Me.DocumentsGridView.GridControl = Me.MassPostDocumentGridControl
        Me.DocumentsGridView.Name = "DocumentsGridView"

        Me.DocumentsGridView.OptionsBehavior.Editable = False
        Me.DocumentsGridView.OptionsCustomization.AllowGroup = False
        Me.DocumentsGridView.OptionsView.ColumnAutoWidth = False
        Me.DocumentsGridView.OptionsView.ShowGroupPanel = False
        Me.DocumentsGridView.OptionsView.ShowAutoFilterRow = True
        Me.DocumentsGridView.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colPostErrorMessage, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colTreeGroupName
        '
        Me.colTreeGroupName.Caption = "Tree Group Name"
        Me.colTreeGroupName.FieldName = "TreeGroupName"
        Me.colTreeGroupName.Name = "colTreeGroupName"
        Me.colTreeGroupName.OptionsColumn.ReadOnly = True
        Me.colTreeGroupName.Visible = True
        Me.colTreeGroupName.VisibleIndex = 6
        Me.colTreeGroupName.Width = 115
        '
        'colPostingOutcomeLabel
        '
        Me.colPostingOutcomeLabel.Caption = "Post Outcome"
        Me.colPostingOutcomeLabel.FieldName = "PostingOutcomeLabel"
        Me.colPostingOutcomeLabel.Name = "colPostingOutcomeLabel"
        Me.colPostingOutcomeLabel.Visible = True
        Me.colPostingOutcomeLabel.VisibleIndex = 7
        Me.colPostingOutcomeLabel.Width = 113
        '
        'colGroupName
        '
        Me.colGroupName.Caption = "Group Name"
        Me.colGroupName.FieldName = "GroupName"
        Me.colGroupName.Name = "colGroupName"
        Me.colGroupName.OptionsColumn.ReadOnly = True
        Me.colGroupName.Visible = True
        Me.colGroupName.VisibleIndex = 1
        Me.colGroupName.Width = 114
        '
        'colOrgUnitName
        '
        Me.colOrgUnitName.Caption = "Org Unit Name"
        Me.colOrgUnitName.FieldName = "OrgUnitName"
        Me.colOrgUnitName.Name = "colOrgUnitName"
        Me.colOrgUnitName.OptionsColumn.ReadOnly = True
        Me.colOrgUnitName.Visible = True
        Me.colOrgUnitName.VisibleIndex = 0
        Me.colOrgUnitName.Width = 108
        '
        'colPostErrorMessage
        '
        Me.colPostErrorMessage.Caption = "Post Message"
        Me.colPostErrorMessage.FieldName = "PostMessage"
        Me.colPostErrorMessage.Name = "colPostErrorMessage"
        Me.colPostErrorMessage.Visible = True
        Me.colPostErrorMessage.VisibleIndex = 8
        Me.colPostErrorMessage.Width = 391
        '
        'colFolderPath
        '
        Me.colFolderPath.Caption = "Folder Path"
        Me.colFolderPath.FieldName = "FolderPath"
        Me.colFolderPath.Name = "colFolderPath"
        Me.colFolderPath.OptionsColumn.ReadOnly = True
        Me.colFolderPath.Visible = True
        Me.colFolderPath.VisibleIndex = 3
        Me.colFolderPath.Width = 151
        '
        'colFileName
        '
        Me.colFileName.Caption = "File Name"
        Me.colFileName.FieldName = "FileName"
        Me.colFileName.Name = "colFileName"
        Me.colFileName.OptionsColumn.ReadOnly = True
        Me.colFileName.Visible = True
        Me.colFileName.VisibleIndex = 4
        Me.colFileName.Width = 119
        '
        'colNodePath
        '
        Me.colNodePath.Caption = "Node Path"
        Me.colNodePath.FieldName = "NodePath"
        Me.colNodePath.Name = "colNodePath"
        Me.colNodePath.OptionsColumn.ReadOnly = True
        Me.colNodePath.Visible = True
        Me.colNodePath.VisibleIndex = 2
        Me.colNodePath.Width = 160
        '
        'colWebLabel
        '
        Me.colWebLabel.Caption = "Web Label"
        Me.colWebLabel.FieldName = "WebLabel"
        Me.colWebLabel.Name = "colWebLabel"
        Me.colWebLabel.OptionsColumn.ReadOnly = True
        Me.colWebLabel.Visible = True
        Me.colWebLabel.VisibleIndex = 5
        Me.colWebLabel.Width = 146
        '
        'ReplaceCheckBox
        '
        Me.ReplaceCheckBox.AutoSize = True
        Me.ReplaceCheckBox.Location = New System.Drawing.Point(16, 40)
        Me.ReplaceCheckBox.Name = "ReplaceCheckBox"
        Me.ReplaceCheckBox.Size = New System.Drawing.Size(162, 17)
        Me.ReplaceCheckBox.TabIndex = 8
        Me.ReplaceCheckBox.Text = "Replace Existing Documents"
        Me.ReplaceCheckBox.UseVisualStyleBackColor = True
        '
        'btnPost
        '
        Me.btnPost.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnPost.Location = New System.Drawing.Point(397, 637)
        Me.btnPost.Name = "btnPost"
        Me.btnPost.Size = New System.Drawing.Size(104, 23)
        Me.btnPost.TabIndex = 2
        Me.btnPost.Text = "Post"
        '
        'MassPoster
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "MassPoster"
        Me.Size = New System.Drawing.Size(898, 664)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel1.PerformLayout()
        CType(Me.MassPostDocumentGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MassPostDocumentBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DocumentsGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
#End Region

    Public Sub OpenNewSpreadsheet(ByVal pMember As Member, ByVal pBatch As DocumentBatch)
        Dim strFileName As String

        mMember = pMember
        mBatch = pBatch
        If ofdMassPost.ShowDialog = DialogResult.OK Then
            strFileName = ofdMassPost.FileName
            docs = MassPostDocument.GetDocuments(strFileName, mMember)
            Me.MassPostDocumentBindingSource.DataSource = docs
        End If

        TogglePostButton()
    End Sub

    Private Sub TogglePostButton()
        Me.btnPost.Enabled = Not WasPostingSuccessful()
    End Sub

    Private Function WasPostingSuccessful() As Boolean
        'Display a message to user
        For Each doc As MassPostDocument In Me.docs
            If doc.IsPostSuccessful = False Then
                Return False
            End If
        Next

        Return True
    End Function

    Private Sub Post(ByVal docCollection As MassPostDocumentCollection, ByVal OverWrite As Boolean)
        Dim treeGroupId As Integer
        Dim newDocID As Integer 'Dummy value for the Posting call
        Dim newDocNodeID As Integer 'Dummy value for the Posting call
        Dim memberName As String = Nothing 'Dummy value for the IsDocument Posted call
        Dim startNodeId As Integer
        Dim duplicateDocumentNodeId As Integer
        Dim newNodeId As Integer
        For Each doc As MassPostDocument In docCollection.Copy
            'Don't Post a document that already successfully posted.
            If doc.IsPostSuccessful = False Then
                newDocNodeID = 0
                treeGroupId = 0
                newDocID = 0
                startNodeId = 0
                duplicateDocumentNodeId = 0
                newNodeId = 0
                Try
                    startNodeId = MassPostDocument.StartNodeId(CurrentUser.OrgUnitsList, doc.OrgUnitName, doc.GroupName)
                    If startNodeId <> 0 Then
                        treeGroupId = TreeGroup.GetTreeGroupID(doc.TreeGroupName)
                        If treeGroupId = 0 Then
                            'If the treeGroupID is nothing, then the treeGroupName is bad
                            doc.PostMessage = "Tree Group Name does not exist"
                        Else
                            If MassPostDocument.IsDuplicate(startNodeId, doc.NodePath, doc.WebLabel, duplicateDocumentNodeId) AndAlso OverWrite = False Then
                                'A document with the same name in the same folder already exists and should not be deleted
                                doc.PostMessage = "A document with the same name already exists."
                            Else
                                Try
                                    newNodeId = MassPostDocument.NodeId(startNodeId, doc.NodePath, CurrentUser.Member)
                                    Document.Post(newNodeId, doc.FolderPath + "\" + doc.FileName, doc.WebLabel, treeGroupId, mMember.MemberId, Document.documentTypes.docTypeOther, duplicateDocumentNodeId, newDocID, newDocNodeID, , mBatch.Id)
                                    doc.DocumentNodeId = newDocNodeID
                                    doc.PostMessage = ""
                                Catch ex As Exception
                                    doc.PostMessage = ex.Message
                                End Try
                            End If
                        End If
                    Else
                        'If startNode does not exist, then the ou or group doesn't exist
                        doc.PostMessage = "OrgUnit or Group does not exist or you do not have access to the OrgUnit or Group"
                    End If
                Catch ex As Exception
                    'Other General errors
                    doc.PostMessage = ex.Message
                    MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End If
        Next

    End Sub


    Private Sub btnPost_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPost.Click
        Try
            Me.Cursor = Cursors.WaitCursor
            'Save the batch if it hasn't already been saved.
            If mBatch.IsNew Then mBatch.Save()

            Post(docs, ReplaceCheckBox.Checked)
            Me.DocumentsGridView.RefreshData()

            If WasPostingSuccessful() Then
                MessageBox.Show("All documents were posted successfully", "Posting Successful", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Else
                MessageBox.Show("Not all documents were posted successfully.  Please review the Outcome column in the grid.", "Posting Errors", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End If

        Catch ex As Exception
            Throw ex
        Finally
            Me.Cursor = Cursors.Default
            TogglePostButton()
        End Try

    End Sub

    Private Sub ExportButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExportToExcel.Click
        FileDialog.Filter = "Excel Files|*.xls"
        FileDialog.Title = "Export Data to Excel"
        FileDialog.FileName = ""
        If FileDialog.ShowDialog = DialogResult.OK Then
            Me.DocumentsGridView.ExportToXls(FileDialog.FileName)
            System.Diagnostics.Process.Start(FileDialog.FileName)
        End If
    End Sub

    Private Sub btnExportPDF_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExportPDF.Click
        FileDialog.Filter = "PDF|*.pdf"
        FileDialog.Title = "Export Data to PDF"
        FileDialog.FileName = ""
        If FileDialog.ShowDialog = DialogResult.OK Then
            'TODO: this pdf looks bad - columns too skinny
    
            Me.DocumentsGridView.ExportToPdf(FileDialog.FileName)
            System.Diagnostics.Process.Start(FileDialog.FileName)
        End If
    End Sub
End Class


