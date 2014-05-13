Imports NormsApplicationBusinessObjectsLibrary
Public Class EquivalentQuestions
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
    Friend WithEvents QuestionSelector1 As NormsApplication.QuestionSelector
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents txtName As System.Windows.Forms.TextBox
    Friend WithEvents SectionPanel2 As NRC.WinForms.SectionPanel
    Friend WithEvents txtDescription As System.Windows.Forms.TextBox
    Friend WithEvents chkNew As System.Windows.Forms.CheckBox
    Friend WithEvents SectionPanel5 As NRC.WinForms.SectionPanel
    Friend WithEvents chkAllComparisons As System.Windows.Forms.CheckBox
    Friend WithEvents btnSave As System.Windows.Forms.Button
    Friend WithEvents btnDelete As System.Windows.Forms.Button
    Friend WithEvents LstQuestionGroups As System.Windows.Forms.ListBox
    Friend WithEvents scpQuestionGroups As NRC.WinForms.SectionPanel
    Friend WithEvents NormList1 As NormsApplication.NormList
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.QuestionSelector1 = New NormsApplication.QuestionSelector
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.txtName = New System.Windows.Forms.TextBox
        Me.SectionPanel2 = New NRC.WinForms.SectionPanel
        Me.txtDescription = New System.Windows.Forms.TextBox
        Me.chkNew = New System.Windows.Forms.CheckBox
        Me.LstQuestionGroups = New System.Windows.Forms.ListBox
        Me.scpQuestionGroups = New NRC.WinForms.SectionPanel
        Me.SectionPanel5 = New NRC.WinForms.SectionPanel
        Me.NormList1 = New NormsApplication.NormList
        Me.btnDelete = New System.Windows.Forms.Button
        Me.btnSave = New System.Windows.Forms.Button
        Me.chkAllComparisons = New System.Windows.Forms.CheckBox
        Me.SectionPanel1.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.scpQuestionGroups.SuspendLayout()
        Me.SectionPanel5.SuspendLayout()
        Me.SuspendLayout()
        '
        'QuestionSelector1
        '
        Me.QuestionSelector1.Location = New System.Drawing.Point(68, 228)
        Me.QuestionSelector1.Name = "QuestionSelector1"
        Me.QuestionSelector1.SelectedQuestions = ""
        Me.QuestionSelector1.Size = New System.Drawing.Size(640, 304)
        Me.QuestionSelector1.TabIndex = 0
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Question Group Name"
        Me.SectionPanel1.Controls.Add(Me.txtName)
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(162, 544)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(452, 64)
        Me.SectionPanel1.TabIndex = 6
        '
        'txtName
        '
        Me.txtName.Location = New System.Drawing.Point(8, 32)
        Me.txtName.Name = "txtName"
        Me.txtName.Size = New System.Drawing.Size(424, 20)
        Me.txtName.TabIndex = 3
        Me.txtName.Text = ""
        '
        'SectionPanel2
        '
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel2.Caption = "Question Group Description"
        Me.SectionPanel2.Controls.Add(Me.txtDescription)
        Me.SectionPanel2.DockPadding.All = 1
        Me.SectionPanel2.Location = New System.Drawing.Point(162, 616)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.ShowCaption = True
        Me.SectionPanel2.Size = New System.Drawing.Size(452, 64)
        Me.SectionPanel2.TabIndex = 7
        '
        'txtDescription
        '
        Me.txtDescription.Location = New System.Drawing.Point(8, 32)
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.Size = New System.Drawing.Size(416, 20)
        Me.txtDescription.TabIndex = 3
        Me.txtDescription.Text = ""
        '
        'chkNew
        '
        Me.chkNew.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chkNew.Location = New System.Drawing.Point(11, 32)
        Me.chkNew.Name = "chkNew"
        Me.chkNew.Size = New System.Drawing.Size(128, 24)
        Me.chkNew.TabIndex = 35
        Me.chkNew.Text = "Create New Group"
        '
        'LstQuestionGroups
        '
        Me.LstQuestionGroups.Location = New System.Drawing.Point(8, 32)
        Me.LstQuestionGroups.Name = "LstQuestionGroups"
        Me.LstQuestionGroups.Size = New System.Drawing.Size(360, 108)
        Me.LstQuestionGroups.TabIndex = 36
        '
        'scpQuestionGroups
        '
        Me.scpQuestionGroups.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.scpQuestionGroups.Caption = "Select Group"
        Me.scpQuestionGroups.Controls.Add(Me.LstQuestionGroups)
        Me.scpQuestionGroups.DockPadding.All = 1
        Me.scpQuestionGroups.Location = New System.Drawing.Point(6, 56)
        Me.scpQuestionGroups.Name = "scpQuestionGroups"
        Me.scpQuestionGroups.ShowCaption = True
        Me.scpQuestionGroups.Size = New System.Drawing.Size(388, 160)
        Me.scpQuestionGroups.TabIndex = 37
        '
        'SectionPanel5
        '
        Me.SectionPanel5.AutoScroll = True
        Me.SectionPanel5.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel5.Caption = "Question Group Editor"
        Me.SectionPanel5.Controls.Add(Me.NormList1)
        Me.SectionPanel5.Controls.Add(Me.QuestionSelector1)
        Me.SectionPanel5.Controls.Add(Me.chkNew)
        Me.SectionPanel5.Controls.Add(Me.SectionPanel1)
        Me.SectionPanel5.Controls.Add(Me.btnDelete)
        Me.SectionPanel5.Controls.Add(Me.btnSave)
        Me.SectionPanel5.Controls.Add(Me.chkAllComparisons)
        Me.SectionPanel5.Controls.Add(Me.SectionPanel2)
        Me.SectionPanel5.Controls.Add(Me.scpQuestionGroups)
        Me.SectionPanel5.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel5.DockPadding.All = 1
        Me.SectionPanel5.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel5.Name = "SectionPanel5"
        Me.SectionPanel5.ShowCaption = True
        Me.SectionPanel5.Size = New System.Drawing.Size(800, 744)
        Me.SectionPanel5.TabIndex = 38
        '
        'NormList1
        '
        Me.NormList1.includeNew = False
        Me.NormList1.Location = New System.Drawing.Point(408, 56)
        Me.NormList1.Name = "NormList1"
        Me.NormList1.Size = New System.Drawing.Size(336, 160)
        Me.NormList1.TabIndex = 42
        Me.NormList1.UseProduction = False
        '
        'btnDelete
        '
        Me.btnDelete.Location = New System.Drawing.Point(431, 696)
        Me.btnDelete.Name = "btnDelete"
        Me.btnDelete.TabIndex = 40
        Me.btnDelete.Text = "Delete"
        '
        'btnSave
        '
        Me.btnSave.Location = New System.Drawing.Point(271, 696)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.TabIndex = 39
        Me.btnSave.Text = "Save"
        '
        'chkAllComparisons
        '
        Me.chkAllComparisons.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chkAllComparisons.Location = New System.Drawing.Point(434, 32)
        Me.chkAllComparisons.Name = "chkAllComparisons"
        Me.chkAllComparisons.Size = New System.Drawing.Size(224, 24)
        Me.chkAllComparisons.TabIndex = 38
        Me.chkAllComparisons.Text = "Apply to All Comparisons"
        '
        'EquivalentQuestions
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.SectionPanel5)
        Me.Name = "EquivalentQuestions"
        Me.Size = New System.Drawing.Size(800, 744)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel2.ResumeLayout(False)
        Me.scpQuestionGroups.ResumeLayout(False)
        Me.SectionPanel5.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub EquivalentQuestions_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Reset()
        QuestionSelector1.PopulateQuestions()
    End Sub

    Private Sub Reset()
        Dim QGroups As QuestionGroupCollection = QuestionGroup.GetAllQuestionGroups

        scpQuestionGroups.Visible = False
        btnDelete.Visible = True
        chkAllComparisons.Checked = True
        NormList1.Visible = False

        LstQuestionGroups.DataSource = Nothing
        LstQuestionGroups.DataSource = QGroups
        LstQuestionGroups.DisplayMember = "Name"
        LstQuestionGroups.SelectedIndex = -1
        chkNew.Checked = True
    End Sub


    Private Sub chkNew_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkNew.CheckedChanged
        If chkNew.Checked Then
            scpQuestionGroups.Visible = False
            LstQuestionGroups.SelectedIndex = -1
            txtName.Text = ""
            txtDescription.Text = ""
            QuestionSelector1.txtQuestions.Text = ""
            NormList1.lstNormsList.SelectedIndex = -1
            chkAllComparisons.Checked = True
        Else
            scpQuestionGroups.Visible = True
            LstQuestionGroups.SelectedIndex = 0
            toggleQuestionGroups()
            btnDelete.Visible = True
        End If
    End Sub

    Private Sub chkAllComparisons_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkAllComparisons.CheckedChanged
        If chkAllComparisons.Checked Then
            NormList1.Visible = False
            NormList1.lstNormsList.SelectedIndex = -1
        Else
            NormList1.Visible = True
            NormList1.lstNormsList.SelectedIndex = 0
        End If
    End Sub

    Private Sub toggleQuestionGroups()
        Dim SelectedQuestionGroup As QuestionGroup
        Dim selectedNorm As USNormSetting = Nothing
        If Not LstQuestionGroups.SelectedItem Is Nothing Then
            SelectedQuestionGroup = LstQuestionGroups.SelectedItem
            txtName.Text = SelectedQuestionGroup.Name
            txtDescription.Text = SelectedQuestionGroup.Description
            QuestionSelector1.txtQuestions.Text = SelectedQuestionGroup.QuestionsList
            If SelectedQuestionGroup.NormID <> 0 Then
                For Each norm As USNormSetting In NormList1.lstNormsList.Items
                    If norm.NormID = SelectedQuestionGroup.NormID Then
                        selectedNorm = norm
                        Exit For
                    End If
                Next
                NormList1.lstNormsList.SelectedItem = selectedNorm
                chkAllComparisons.Checked = False
            Else
                chkAllComparisons.Checked = True
            End If
        Else
            txtName.Text = ""
            txtDescription.Text = ""
            QuestionSelector1.txtQuestions.Text = ""
            NormList1.lstNormsList.SelectedItem = -1
        End If
    End Sub

    Private Sub LstQuestionGroups_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles LstQuestionGroups.SelectedIndexChanged
        toggleQuestionGroups()
    End Sub

    Private Function Validation() As Boolean
        'Verify that no questions belong to a different group
        For Each qstncore As String In QuestionSelector1.txtQuestions.Text.Split(",")
            For Each group As QuestionGroup In Me.LstQuestionGroups.Items
                For Each qstn As Question In group.Questions
                    'don't check the currently selected group
                    If chkNew.Checked Or (chkNew.Checked = False AndAlso DirectCast(Me.LstQuestionGroups.SelectedItem, QuestionGroup).ID <> group.ID) Then
                        If CInt(qstncore) = qstn.Qstncore Then
                            MessageBox.Show(qstncore + " is already part of the group '" + group.Name + "'." + vbCrLf + "Please add additional questions to that group instead of creating a new group.", "New Group Error.", MessageBoxButtons.OK, MessageBoxIcon.Error)
                            Return False
                        End If
                    End If
                Next
            Next
        Next

        If chkNew.Checked = False And LstQuestionGroups.SelectedIndex = -1 Then
            MessageBox.Show("You must select a Question Group from the list or create a new group", "No Group Selected", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return False
        ElseIf txtName.Text = "" Then
            MessageBox.Show("You must specify a name.", "Missing Name", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return False
        ElseIf txtDescription.Text = "" Then
            MessageBox.Show("You must specify a description.", "Missing Description", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return False
        ElseIf QuestionSelector1.txtQuestions.Text = "" Or QuestionSelector1.txtQuestions.Text.Split(",").Length < 2 Then
            MessageBox.Show("You must specify at least 2 questions.", "Not Enough Questions Selected", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return False
        ElseIf chkAllComparisons.Checked = False And NormList1.lstNormsList.SelectedIndex = -1 Then
            MessageBox.Show("You must select a norm or check all comparisons.", "No Norm Selected", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return False
        Else
            Return True
        End If
    End Function

    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        Dim QGroupID As Integer
        Dim NormID As Integer

        If Validation() Then
            If Not chkAllComparisons.Checked Then NormID = DirectCast(NormList1.lstNormsList.SelectedItem, USNormSetting).NormID
            If chkNew.Checked Then
                'Create New
                QuestionGroup.CreateQuestionGroup(txtName.Text, txtDescription.Text, NormID, CurrentUser.Member.MemberId, QuestionSelector1.txtQuestions.Text.Split(","))
            Else
                'Update Existing
                QGroupID = DirectCast(LstQuestionGroups.SelectedItem, QuestionGroup).ID
                QuestionGroup.UpdateQuestionGroup(QGroupID, txtName.Text, txtDescription.Text, NormID, QuestionSelector1.txtQuestions.Text.Split(","))
            End If
        End If
        Reset()
    End Sub

    Private Sub btnDelete_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        If LstQuestionGroups.SelectedIndex = -1 Then
            MessageBox.Show("You must select a Question Group from the list to delete", "No Group Selected", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        Else
            If MessageBox.Show("Are you sure you want to delete this group?", "Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Information) = DialogResult.Yes Then
                'Call Delete for Selected Group
                QuestionGroup.DeleteQuestionGroup(DirectCast(LstQuestionGroups.SelectedItem, QuestionGroup).ID)
            End If
        End If
    End Sub
End Class
