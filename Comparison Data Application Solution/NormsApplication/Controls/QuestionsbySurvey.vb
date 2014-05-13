Imports NormsApplicationBusinessObjectsLibrary
Public Class QuestionsbySurvey
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
    Friend WithEvents btnSave As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.QuestionSelector1 = New NormsApplication.QuestionSelector
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.btnSave = New System.Windows.Forms.Button
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'QuestionSelector1
        '
        Me.QuestionSelector1.Location = New System.Drawing.Point(44, 48)
        Me.QuestionSelector1.Name = "QuestionSelector1"
        Me.QuestionSelector1.SelectedQuestions = ""
        Me.QuestionSelector1.Size = New System.Drawing.Size(640, 304)
        Me.QuestionSelector1.TabIndex = 1
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Survey Questions"
        Me.SectionPanel1.Controls.Add(Me.btnSave)
        Me.SectionPanel1.Controls.Add(Me.QuestionSelector1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(728, 504)
        Me.SectionPanel1.TabIndex = 2
        '
        'btnSave
        '
        Me.btnSave.Location = New System.Drawing.Point(327, 392)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.TabIndex = 41
        Me.btnSave.Text = "Save"
        '
        'QuestionsbySurvey
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "QuestionsbySurvey"
        Me.Size = New System.Drawing.Size(728, 504)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        SurveyType.UpdateSurveyTypeQuestions(QuestionSelector1.lstSurveyTypes.SelectedItem, QuestionSelector1.txtQuestions.Text.Split(","))
        QuestionSelector1.RefreshQuestions()
    End Sub

    Private Sub QuestionsbySurvey_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        QuestionSelector1.btnAddQuestions.Visible = False
        QuestionSelector1.PopulateQuestions()
    End Sub

    Private Sub QuestionSelector1_SelectedSurveyTypeChanged() Handles QuestionSelector1.SelectedQuestionsChanged
        Dim questionsList As String = String.Empty
        For Each qstn As Question In QuestionSelector1.lstQuestions.Items
            questionsList += ", " & qstn.Qstncore.ToString
        Next
        QuestionSelector1.txtQuestions.Text = questionsList.Substring(2)
    End Sub
End Class
