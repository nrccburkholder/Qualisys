Imports NormsApplicationBusinessObjectsLibrary
Public Class CreateDimension
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
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.ctlQuestionSelector = New NormsApplication.QuestionSelector
        Me.btnSave = New System.Windows.Forms.Button
        Me.txtName = New System.Windows.Forms.TextBox
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.SectionPanel2 = New NRC.WinForms.SectionPanel
        Me.txtDescription = New System.Windows.Forms.TextBox
        Me.SectionPanel3 = New NRC.WinForms.SectionPanel
        Me.ctlSurveyTypesList = New NormsApplication.SurveyTypesList
        Me.SectionPanel1.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.SectionPanel3.SuspendLayout()
        Me.SuspendLayout()
        '
        'ctlQuestionSelector
        '
        Me.ctlQuestionSelector.Location = New System.Drawing.Point(8, 36)
        Me.ctlQuestionSelector.Name = "ctlQuestionSelector"
        Me.ctlQuestionSelector.SelectedQuestions = ""
        Me.ctlQuestionSelector.Size = New System.Drawing.Size(648, 312)
        Me.ctlQuestionSelector.TabIndex = 0
        '
        'btnSave
        '
        Me.btnSave.Location = New System.Drawing.Point(400, 544)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.TabIndex = 2
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
        Me.SectionPanel1.Location = New System.Drawing.Point(224, 356)
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
        Me.SectionPanel2.Location = New System.Drawing.Point(224, 452)
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
        Me.txtDescription.TabIndex = 3
        Me.txtDescription.Text = ""
        '
        'SectionPanel3
        '
        Me.SectionPanel3.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel3.Caption = "Create Dimensions"
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
        Me.SectionPanel3.Size = New System.Drawing.Size(672, 592)
        Me.SectionPanel3.TabIndex = 6
        '
        'ctlSurveyTypesList
        '
        Me.ctlSurveyTypesList.Location = New System.Drawing.Point(8, 352)
        Me.ctlSurveyTypesList.Name = "ctlSurveyTypesList"
        Me.ctlSurveyTypesList.SelectedSurveyType = Nothing
        Me.ctlSurveyTypesList.Size = New System.Drawing.Size(208, 224)
        Me.ctlSurveyTypesList.TabIndex = 7
        '
        'CreateDimension
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.SectionPanel3)
        Me.Name = "CreateDimension"
        Me.Size = New System.Drawing.Size(672, 592)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel2.ResumeLayout(False)
        Me.SectionPanel3.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private mStandard As Boolean

    Public Property isStandard() As Boolean
        Get
            Return mStandard
        End Get
        Set(ByVal Value As Boolean)
            mstandard = value
        End Set
    End Property

    Private Sub CreateDimension_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ctlQuestionSelector.PopulateQuestions()
        ctlSurveyTypesList.PopulateSurveyTypes()
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

    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        If Validate() Then
            Dimension.CreateDimension(txtName.Text, txtDescription.Text, ctlSurveyTypesList.SelectedSurveyType.ID, CurrentUser.Member.MemberId, ctlQuestionSelector.SelectedQuestions.Split(","), mStandard)
            txtName.Text = ""
            txtDescription.Text = ""
            ctlQuestionSelector.txtQuestions.Text = ""
        End If
    End Sub
End Class
