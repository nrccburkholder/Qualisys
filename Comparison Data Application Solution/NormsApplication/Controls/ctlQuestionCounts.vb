Imports NormsApplicationBusinessObjectsLibrary
Public Class ctlQuestionCounts
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
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        components = New System.ComponentModel.Container
    End Sub

#End Region


    Private Sub QuestionCounts_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        pnlBaseComparisonControl.Caption = "Question Counts"
        MyBase.mActiveQuery = New ComparisonDataQuery(ComparisonDataQuery.enuReportType.questionCounts)
        MyBase.ctlDimensionSelector.Visible = False
        MyBase.ctlUseFacilitiesCheck.Visible = False
        MyBase.ctlMeasureGrouping.Visible = False
        MyBase.ctlDimensionSelector.Enabled = False
        MyBase.ctlUseFacilitiesCheck.Enabled = False
        MyBase.ctlMeasureGrouping.Enabled = False
        MyBase.PopulateQuestions()
    End Sub


End Class
