Imports NormsApplicationBusinessObjectsLibrary
Public Class ctlQuestionUsers
    Inherits NormsApplication.ctlBaseComparisonControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
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
    '    Friend WithEvents tbPFilter As System.Windows.Forms.TabPage
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.tbPFilter = New System.Windows.Forms.TabPage
        Me.pnlBaseComparisonControl.SuspendLayout()
        Me.SuspendLayout()
        '
        'btnSubmit
        '
        Me.btnSubmit.Name = "btnSubmit"
        '
        'pnlBaseComparisonControl
        '
        Me.pnlBaseComparisonControl.DockPadding.All = 1
        Me.pnlBaseComparisonControl.Name = "pnlBaseComparisonControl"
        Me.pnlBaseComparisonControl.Controls.SetChildIndex(Me.btnSubmit, 0)
        Me.pnlBaseComparisonControl.Controls.SetChildIndex(Me.btnClear, 0)
        '
        'btnClear
        '
        Me.btnClear.Name = "btnClear"
        '
        'tbPFilter
        '
        Me.tbPFilter.Location = New System.Drawing.Point(4, 22)
        Me.tbPFilter.Name = "tbPFilter"
        Me.tbPFilter.Size = New System.Drawing.Size(784, 638)
        Me.tbPFilter.TabIndex = 0
        Me.tbPFilter.Text = "Filter Statement"
        '
        'ctlQuestionUsers
        '
        Me.Name = "ctlQuestionUsers"
        Me.pnlBaseComparisonControl.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region


    Private Sub QuestionUsers_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        pnlBaseComparisonControl.Caption = "Question Users"
        MyBase.mActiveQuery = New ComparisonDataQuery(ComparisonDataQuery.enuReportType.QuestionUsers)
        MyBase.ctlDimensionSelector.Visible = False
        MyBase.ctlUseFacilitiesCheck.Visible = False
        MyBase.ctlMeasureGrouping.Visible = False
        MyBase.ctlDimensionSelector.Enabled = False
        MyBase.ctlUseFacilitiesCheck.Enabled = False
        MyBase.ctlMeasureGrouping.Enabled = False
        MyBase.PopulateQuestions()
    End Sub
End Class
