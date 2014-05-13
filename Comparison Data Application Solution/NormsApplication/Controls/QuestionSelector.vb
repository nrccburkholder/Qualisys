Imports NormsApplicationBusinessObjectsLibrary
Public Class QuestionSelector
    Inherits System.Windows.Forms.UserControl

    Public Event SelectedQuestionsChanged()

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
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents btnAddQuestions As System.Windows.Forms.Button
    Friend WithEvents lstQuestions As System.Windows.Forms.ListBox
    Friend WithEvents lstSurveyTypes As System.Windows.Forms.ListBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents txtQuestions As System.Windows.Forms.TextBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.btnAddQuestions = New System.Windows.Forms.Button
        Me.lstQuestions = New System.Windows.Forms.ListBox
        Me.lstSurveyTypes = New System.Windows.Forms.ListBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.txtQuestions = New System.Windows.Forms.TextBox
        Me.Label6 = New System.Windows.Forms.Label
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Select Questions"
        Me.SectionPanel1.Controls.Add(Me.btnAddQuestions)
        Me.SectionPanel1.Controls.Add(Me.lstQuestions)
        Me.SectionPanel1.Controls.Add(Me.lstSurveyTypes)
        Me.SectionPanel1.Controls.Add(Me.Label1)
        Me.SectionPanel1.Controls.Add(Me.Label2)
        Me.SectionPanel1.Controls.Add(Me.txtQuestions)
        Me.SectionPanel1.Controls.Add(Me.Label6)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(656, 304)
        Me.SectionPanel1.TabIndex = 0
        '
        'btnAddQuestions
        '
        Me.btnAddQuestions.Location = New System.Drawing.Point(304, 192)
        Me.btnAddQuestions.Name = "btnAddQuestions"
        Me.btnAddQuestions.Size = New System.Drawing.Size(43, 23)
        Me.btnAddQuestions.TabIndex = 18
        Me.btnAddQuestions.Text = "Add"
        '
        'lstQuestions
        '
        Me.lstQuestions.Location = New System.Drawing.Point(256, 88)
        Me.lstQuestions.Name = "lstQuestions"
        Me.lstQuestions.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.lstQuestions.Size = New System.Drawing.Size(368, 95)
        Me.lstQuestions.TabIndex = 15
        '
        'lstSurveyTypes
        '
        Me.lstSurveyTypes.Location = New System.Drawing.Point(24, 88)
        Me.lstSurveyTypes.Name = "lstSurveyTypes"
        Me.lstSurveyTypes.Size = New System.Drawing.Size(152, 95)
        Me.lstSurveyTypes.TabIndex = 14
        '
        'Label1
        '
        Me.Label1.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(264, 56)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(208, 23)
        Me.Label1.TabIndex = 13
        Me.Label1.Text = "Questions"
        '
        'Label2
        '
        Me.Label2.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(24, 56)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(176, 28)
        Me.Label2.TabIndex = 12
        Me.Label2.Text = "Survey Types"
        '
        'txtQuestions
        '
        Me.txtQuestions.Location = New System.Drawing.Point(24, 232)
        Me.txtQuestions.Multiline = True
        Me.txtQuestions.Name = "txtQuestions"
        Me.txtQuestions.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtQuestions.Size = New System.Drawing.Size(600, 56)
        Me.txtQuestions.TabIndex = 16
        Me.txtQuestions.Text = ""
        '
        'Label6
        '
        Me.Label6.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label6.Location = New System.Drawing.Point(24, 208)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(152, 16)
        Me.Label6.TabIndex = 17
        Me.Label6.Text = "Selected Question(s) "
        '
        'QuestionSelector
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "QuestionSelector"
        Me.Size = New System.Drawing.Size(656, 312)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region "Public Properties"

#End Region
    Public Property SelectedQuestions() As String
        Get
            Return txtQuestions.Text
        End Get
        Set(ByVal Value As String)
            txtQuestions.Text = Value
        End Set
    End Property

#Region "Private Methods"

    Private Sub lstSurveyTypes_SelectedValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lstSurveyTypes.SelectedValueChanged
        RefreshQuestions()
    End Sub

    Private Sub AddQuestions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddQuestions.Click
        Dim SelectedValues As String = ""
        Dim tmpSelectedItem As Question
        If lstQuestions.SelectedItems.Count > 0 Then
            For Each tmpSelectedItem In lstQuestions.SelectedItems
                SelectedValues = SelectedValues & tmpSelectedItem.Qstncore.ToString & ","
            Next
            SelectedValues = SelectedValues.Substring(0, SelectedValues.Length - 1)
            If txtQuestions.Text = "" Then
                txtQuestions.Text = SelectedValues
            Else
                txtQuestions.Text = txtQuestions.Text & "," & SelectedValues
            End If
        End If

    End Sub
#End Region

#Region "Public Methods"

    Public Sub PopulateQuestions()
        Dim SurveyTypes As DataSet
        Dim SurveyList As New SurveyTypesCollection
        SurveyTypes = DataAccess.GetSurveyTypes()
        For Each row As DataRow In SurveyTypes.Tables(0).Rows
            SurveyList.Add(SurveyType.getSurveyTypefromDataRow(row))
        Next
        lstSurveyTypes.DataSource = SurveyList
        lstSurveyTypes.DisplayMember = "Name"
    End Sub

    Public Sub RefreshQuestions()
        Dim SurveyQuestions As DataSet
        Dim QuestionsList As New QuestionsCollection

        If Not Me.DesignMode Then
            SurveyQuestions = DataAccess.GetSurveyQuestions(DirectCast(lstSurveyTypes.SelectedItem, SurveyType).ID)
            For Each row As DataRow In SurveyQuestions.Tables(0).Rows
                QuestionsList.Add(Question.getQuestionfromDataRow(row))
            Next
        End If
        lstQuestions.DataSource = QuestionsList
        lstQuestions.DisplayMember = "Name"
        RaiseEvent SelectedQuestionsChanged()
    End Sub
#End Region

End Class
