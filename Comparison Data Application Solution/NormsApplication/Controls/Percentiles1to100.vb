Imports NormsApplicationBusinessObjectsLibrary
Public Class Percentiles1to100
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

    Private Sub Percentiles1to100_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        pnlBaseComparisonControl.Caption = "Percentiles 1 to 100"
        MyBase.mActiveQuery = New ComparisonDataQuery(ComparisonDataQuery.enuReportType.Percentiles1to100)
        MyBase.PopulateDimensions()
        MyBase.PopulateMeasures()
        MyBase.PopulateQuestions()
    End Sub

End Class
