Imports NormsApplicationBusinessObjectsLibrary
Public Class EditDimension
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
    Friend WithEvents btnSave As System.Windows.Forms.Button
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents SectionPanel2 As NRC.WinForms.SectionPanel
    Friend WithEvents SectionPanel3 As NRC.WinForms.SectionPanel
    Friend WithEvents ctlQuestionSelector As NormsApplication.QuestionSelector
    Friend WithEvents txtName As System.Windows.Forms.TextBox
    Friend WithEvents txtDescription As System.Windows.Forms.TextBox
    Friend WithEvents ctlSurveyTypesList As NormsApplication.SurveyTypesList
    Friend WithEvents DimensionSelector1 As NormsApplication.DimensionSelector
    Friend WithEvents btnDelete As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.ctlQuestionSelector = New NormsApplication.QuestionSelector
        Me.btnSave = New System.Windows.Forms.Button
        Me.txtName = New System.Windows.Forms.TextBox
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.SectionPanel2 = New NRC.WinForms.SectionPanel
        Me.txtDescription = New System.Windows.Forms.TextBox
        Me.SectionPanel3 = New NRC.WinForms.SectionPanel
        Me.btnDelete = New System.Windows.Forms.Button
        Me.DimensionSelector1 = New NormsApplication.DimensionSelector
        Me.ctlSurveyTypesList = New NormsApplication.SurveyTypesList
        Me.SectionPanel1.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.SectionPanel3.SuspendLayout()
        Me.SuspendLayout()
        '
        'ctlQuestionSelector
        '
        Me.ctlQuestionSelector.Location = New System.Drawing.Point(16, 248)
        Me.ctlQuestionSelector.Name = "ctlQuestionSelector"
        Me.ctlQuestionSelector.SelectedQuestions = ""
        Me.ctlQuestionSelector.Size = New System.Drawing.Size(648, 312)
        Me.ctlQuestionSelector.TabIndex = 0
        '
        'btnSave
        '
        Me.btnSave.Location = New System.Drawing.Point(408, 760)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.TabIndex = 5
        Me.btnSave.Text = "Save"
        '
        'txtName
        '
        Me.txtName.Location = New System.Drawing.Point(8, 32)
        Me.txtName.Name = "txtName"
        Me.txtName.Size = New System.Drawing.Size(424, 20)
        Me.txtName.TabIndex = 3
        Me.txtName.Text = ""
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Dimension Name"
        Me.SectionPanel1.Controls.Add(Me.txtName)
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(232, 568)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(432, 64)
        Me.SectionPanel1.TabIndex = 4
        '
        'SectionPanel2
        '
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel2.Caption = "Dimension Description"
        Me.SectionPanel2.Controls.Add(Me.txtDescription)
        Me.SectionPanel2.DockPadding.All = 1
        Me.SectionPanel2.Location = New System.Drawing.Point(232, 664)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.ShowCaption = True
        Me.SectionPanel2.Size = New System.Drawing.Size(432, 64)
        Me.SectionPanel2.TabIndex = 5
        '
        'txtDescription
        '
        Me.txtDescription.Location = New System.Drawing.Point(8, 32)
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.Size = New System.Drawing.Size(416, 20)
        Me.txtDescription.TabIndex = 4
        Me.txtDescription.Text = ""
        '
        'SectionPanel3
        '
        Me.SectionPanel3.AutoScroll = True
        Me.SectionPanel3.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel3.Caption = "Edit/View Dimensions"
        Me.SectionPanel3.Controls.Add(Me.btnDelete)
        Me.SectionPanel3.Controls.Add(Me.DimensionSelector1)
        Me.SectionPanel3.Controls.Add(Me.ctlSurveyTypesList)
        Me.SectionPanel3.Controls.Add(Me.SectionPanel1)
        Me.SectionPanel3.Controls.Add(Me.SectionPanel2)
        Me.SectionPanel3.Controls.Add(Me.ctlQuestionSelector)
        Me.SectionPanel3.Controls.Add(Me.btnSave)
        Me.SectionPanel3.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel3.DockPadding.All = 1
        Me.SectionPanel3.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel3.Name = "SectionPanel3"
        Me.SectionPanel3.ShowCaption = True
        Me.SectionPanel3.Size = New System.Drawing.Size(784, 808)
        Me.SectionPanel3.TabIndex = 6
        '
        'btnDelete
        '
        Me.btnDelete.Location = New System.Drawing.Point(552, 760)
        Me.btnDelete.Name = "btnDelete"
        Me.btnDelete.TabIndex = 6
        Me.btnDelete.Text = "Delete"
        '
        'DimensionSelector1
        '
        Me.DimensionSelector1.Location = New System.Drawing.Point(16, 32)
        Me.DimensionSelector1.Name = "DimensionSelector1"
        Me.DimensionSelector1.SelectedDimensions = ""
        Me.DimensionSelector1.SingleSelect = NormsApplication.DimensionSelector.SelectionType.SingleSelect
        Me.DimensionSelector1.Size = New System.Drawing.Size(752, 216)
        Me.DimensionSelector1.TabIndex = 9
        '
        'ctlSurveyTypesList
        '
        Me.ctlSurveyTypesList.Location = New System.Drawing.Point(16, 568)
        Me.ctlSurveyTypesList.Name = "ctlSurveyTypesList"
        Me.ctlSurveyTypesList.SelectedSurveyType = Nothing
        Me.ctlSurveyTypesList.Size = New System.Drawing.Size(208, 224)
        Me.ctlSurveyTypesList.TabIndex = 7
        '
        'EditDimension
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.SectionPanel3)
        Me.Name = "EditDimension"
        Me.Size = New System.Drawing.Size(784, 808)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel2.ResumeLayout(False)
        Me.SectionPanel3.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private mStandard As Boolean
    Private mSelectedDimension As Dimension

    Public Property isStandard() As Boolean
        Get
            Return mStandard
        End Get
        Set(ByVal Value As Boolean)
            mstandard = Value
        End Set
    End Property

    Private Sub User_changed(ByVal UserName As String) Handles DimensionSelector1.UserChanged
        If mStandard = True Then
            If UserName = " Standard" Or UserName = CurrentUser.UserName Then
                btnSave.Visible = True
                btnDelete.Visible = True
            Else
                btnSave.Visible = False
                btnDelete.Visible = False
            End If
        Else
            If UserName = CurrentUser.UserName Then
                btnSave.Visible = True
                btnDelete.Visible = True
            Else
                btnSave.Visible = False
                btnDelete.Visible = False
            End If
        End If
    End Sub

    Private Sub CreateDimension_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        DimensionSelector1.PopulateDimensions()
        ctlQuestionSelector.PopulateQuestions()
        ctlSurveyTypesList.PopulateSurveyTypes()
        If DimensionSelector1.lstUsers.SelectedValue IsNot Nothing Then
            User_changed(DirectCast(DimensionSelector1.lstUsers.SelectedValue, NormUser).Name)
        End If
    End Sub

    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        If Validation() Then
            Dimension.UpdateDimension(mSelectedDimension.ID, txtName.Text, txtDescription.Text, ctlSurveyTypesList.SelectedSurveyType.ID, ctlQuestionSelector.SelectedQuestions.Split(","))
        End If
    End Sub

    Private Sub DimensionSelector1_DimensionChanged(ByVal Dimen As NormsApplicationBusinessObjectsLibrary.Dimension) Handles DimensionSelector1.DimensionChanged
        mSelectedDimension = Dimen
        ctlQuestionSelector.txtQuestions.Text = Dimen.QuestionsList
        txtName.Text = Dimen.ShortName
        txtDescription.Text = Dimen.Description
        For Each survey As SurveyType In ctlSurveyTypesList.lstSurveyTypes.Items
            If Dimen.SvyType.ID = survey.ID Then
                ctlSurveyTypesList.lstSurveyTypes.SelectedItem = survey
                Exit For
            End If
        Next
    End Sub

    Private Function Validation() As Boolean
        If txtName.Text = "" Then
            MessageBox.Show("You must specify a name.", "Missing Name", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return False
        ElseIf txtDescription.Text = "" Then
            MessageBox.Show("You must specify a description.", "Missing Description", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return False
        ElseIf ctlQuestionSelector.txtQuestions.Text = "" Then
            MessageBox.Show("You must specify at least 1 question.", "Not Enough Questions Selected", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return False
        Else
            Return True
        End If
    End Function

    Private Sub btnDelete_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        Dim Response As DialogResult
        Response = MessageBox.Show("Are you sure you want to delete this Dimension?", "Delete", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning)
        If Response = DialogResult.OK Then
            Dimension.DeleteDimension(mSelectedDimension.ID)
        End If
    End Sub
End Class
