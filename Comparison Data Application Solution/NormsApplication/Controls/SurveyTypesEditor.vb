Imports NormsApplicationBusinessObjectsLibrary
Public Class SurveyTypesEditor
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
    Friend WithEvents scpSurveyTypesEditor As NRC.WinForms.SectionPanel
    Friend WithEvents SurveyTypesList1 As NormsApplication.SurveyTypesList
    Friend WithEvents ctmSurveyTypes As System.Windows.Forms.ContextMenu
    Friend WithEvents scpNew As NRC.WinForms.SectionPanel
    Friend WithEvents btnAdd As System.Windows.Forms.Button
    Friend WithEvents txtName As System.Windows.Forms.TextBox
    Friend WithEvents mnuRename As System.Windows.Forms.MenuItem
    Friend WithEvents mnuDelete As System.Windows.Forms.MenuItem
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.scpSurveyTypesEditor = New NRC.WinForms.SectionPanel
        Me.scpNew = New NRC.WinForms.SectionPanel
        Me.btnAdd = New System.Windows.Forms.Button
        Me.txtName = New System.Windows.Forms.TextBox
        Me.SurveyTypesList1 = New NormsApplication.SurveyTypesList
        Me.ctmSurveyTypes = New System.Windows.Forms.ContextMenu
        Me.mnuRename = New System.Windows.Forms.MenuItem
        Me.mnuDelete = New System.Windows.Forms.MenuItem
        Me.scpSurveyTypesEditor.SuspendLayout()
        Me.scpNew.SuspendLayout()
        Me.SuspendLayout()
        '
        'scpSurveyTypesEditor
        '
        Me.scpSurveyTypesEditor.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.scpSurveyTypesEditor.Caption = "Survey Types Editor"
        Me.scpSurveyTypesEditor.Controls.Add(Me.scpNew)
        Me.scpSurveyTypesEditor.Controls.Add(Me.SurveyTypesList1)
        Me.scpSurveyTypesEditor.Dock = System.Windows.Forms.DockStyle.Fill
        Me.scpSurveyTypesEditor.DockPadding.All = 1
        Me.scpSurveyTypesEditor.Location = New System.Drawing.Point(0, 0)
        Me.scpSurveyTypesEditor.Name = "scpSurveyTypesEditor"
        Me.scpSurveyTypesEditor.ShowCaption = True
        Me.scpSurveyTypesEditor.Size = New System.Drawing.Size(456, 504)
        Me.scpSurveyTypesEditor.TabIndex = 0
        '
        'scpNew
        '
        Me.scpNew.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.scpNew.Caption = "New Survey Type"
        Me.scpNew.Controls.Add(Me.btnAdd)
        Me.scpNew.Controls.Add(Me.txtName)
        Me.scpNew.DockPadding.All = 1
        Me.scpNew.Location = New System.Drawing.Point(34, 296)
        Me.scpNew.Name = "scpNew"
        Me.scpNew.ShowCaption = True
        Me.scpNew.Size = New System.Drawing.Size(372, 152)
        Me.scpNew.TabIndex = 2
        '
        'btnAdd
        '
        Me.btnAdd.Location = New System.Drawing.Point(149, 104)
        Me.btnAdd.Name = "btnAdd"
        Me.btnAdd.TabIndex = 2
        Me.btnAdd.Text = "Add"
        '
        'txtName
        '
        Me.txtName.Location = New System.Drawing.Point(16, 56)
        Me.txtName.Name = "txtName"
        Me.txtName.Size = New System.Drawing.Size(340, 20)
        Me.txtName.TabIndex = 1
        Me.txtName.Text = ""
        '
        'SurveyTypesList1
        '
        Me.SurveyTypesList1.ContextMenu = Me.ctmSurveyTypes
        Me.SurveyTypesList1.Location = New System.Drawing.Point(34, 40)
        Me.SurveyTypesList1.Name = "SurveyTypesList1"
        Me.SurveyTypesList1.SelectedSurveyType = Nothing
        Me.SurveyTypesList1.Size = New System.Drawing.Size(372, 224)
        Me.SurveyTypesList1.TabIndex = 1
        '
        'ctmSurveyTypes
        '
        Me.ctmSurveyTypes.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuRename, Me.mnuDelete})
        '
        'mnuRename
        '
        Me.mnuRename.Index = 0
        Me.mnuRename.Text = "Rename"
        '
        'mnuDelete
        '
        Me.mnuDelete.Index = 1
        Me.mnuDelete.Text = "Delete"
        '
        'SurveyTypesEditor
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.scpSurveyTypesEditor)
        Me.Name = "SurveyTypesEditor"
        Me.Size = New System.Drawing.Size(456, 504)
        Me.scpSurveyTypesEditor.ResumeLayout(False)
        Me.scpNew.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub refreshList()
        SurveyTypesList1.PopulateSurveyTypes()
    End Sub
    Private Sub btnAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAdd.Click
        If txtName.Text = "" Then
            MessageBox.Show("You must Specify a Name.", "Missing Name", MessageBoxButtons.OK, MessageBoxIcon.Error)
        ElseIf NameInUse(txtName.Text) Then
            MessageBox.Show("A survey type already exists with that name.  Please specify a different name.", "Duplicate Name", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            'Create New SurveyType
            SurveyType.CreateSurveyType(txtName.Text)
            refreshList()
        End If
    End Sub

    Private Sub mnuDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuDelete.Click
        If MessageBox.Show("Are you sure you want to delete this survey type?", "Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) = DialogResult.Yes Then
            SurveyType.DeleteSurveyType(DirectCast(SurveyTypesList1.lstSurveyTypes.SelectedItem(), SurveyType).ID)
            refreshList()
        End If
    End Sub

    Private Function NameInUse(ByVal Name As String) As Boolean
        For Each svy As SurveyType In SurveyTypesList1.lstSurveyTypes.Items
            If svy.Name = Name Then Return True
        Next
        Return False
    End Function

    Private Sub mnuRename_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuRename.Click
        If txtName.Text = "" Then
            MessageBox.Show("You must Specify a Name.", "Missing Name", MessageBoxButtons.OK, MessageBoxIcon.Error)
        ElseIf NameInUse(txtName.Text) Then
            MessageBox.Show("A survey type already exists with that name.  Please specify a different name.", "Duplicate Name", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            'Create New SurveyType
            SurveyType.UpdateSurveyType(DirectCast(SurveyTypesList1.lstSurveyTypes.SelectedItem(), SurveyType).ID, txtName.Text)
            refreshList()
        End If
    End Sub

    Private Sub SurveyTypesEditor_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        SurveyTypesList1.PopulateSurveyTypes()
    End Sub
End Class
