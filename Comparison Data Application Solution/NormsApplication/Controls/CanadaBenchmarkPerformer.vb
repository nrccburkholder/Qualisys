Option Explicit On 
Option Strict On

Imports System.Data.SqlClient
Imports NormsApplicationBusinessObjectsLibrary

Public Class CanadaBenchmarkPerformer
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
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents SectionPanel2 As NRC.WinForms.SectionPanel
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents optQuestion As System.Windows.Forms.RadioButton
    Friend WithEvents optDimension As System.Windows.Forms.RadioButton
    Friend WithEvents cboNorm As System.Windows.Forms.ComboBox
    Friend WithEvents btnSubmit As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents lstDimension As System.Windows.Forms.ListBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.SectionPanel2 = New NRC.WinForms.SectionPanel
        Me.Label2 = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.optQuestion = New System.Windows.Forms.RadioButton
        Me.optDimension = New System.Windows.Forms.RadioButton
        Me.cboNorm = New System.Windows.Forms.ComboBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.btnSubmit = New System.Windows.Forms.Button
        Me.lstDimension = New System.Windows.Forms.ListBox
        Me.SectionPanel1.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Canadian Norm Benchmark Performer"
        Me.SectionPanel1.Controls.Add(Me.SectionPanel2)
        Me.SectionPanel1.Controls.Add(Me.btnSubmit)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(520, 440)
        Me.SectionPanel1.TabIndex = 0
        '
        'SectionPanel2
        '
        Me.SectionPanel2.AutoScroll = True
        Me.SectionPanel2.AutoScrollMinSize = New System.Drawing.Size(517, 364)
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel2.Caption = ""
        Me.SectionPanel2.Controls.Add(Me.Label2)
        Me.SectionPanel2.Controls.Add(Me.GroupBox1)
        Me.SectionPanel2.Controls.Add(Me.cboNorm)
        Me.SectionPanel2.Controls.Add(Me.Label1)
        Me.SectionPanel2.Dock = System.Windows.Forms.DockStyle.Top
        Me.SectionPanel2.DockPadding.All = 1
        Me.SectionPanel2.Location = New System.Drawing.Point(1, 27)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.ShowCaption = False
        Me.SectionPanel2.Size = New System.Drawing.Size(518, 365)
        Me.SectionPanel2.TabIndex = 0
        '
        'Label2
        '
        Me.Label2.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(40, 328)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(440, 16)
        Me.Label2.TabIndex = 3
        Me.Label2.Text = "Note: Benchmark performer is decided based on norm staging data."
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.lstDimension)
        Me.GroupBox1.Controls.Add(Me.optQuestion)
        Me.GroupBox1.Controls.Add(Me.optDimension)
        Me.GroupBox1.Location = New System.Drawing.Point(40, 88)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(440, 232)
        Me.GroupBox1.TabIndex = 2
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Benchmark Performer Based on"
        '
        'optQuestion
        '
        Me.optQuestion.Checked = True
        Me.optQuestion.Location = New System.Drawing.Point(24, 24)
        Me.optQuestion.Name = "optQuestion"
        Me.optQuestion.Size = New System.Drawing.Size(80, 24)
        Me.optQuestion.TabIndex = 0
        Me.optQuestion.TabStop = True
        Me.optQuestion.Text = "Question"
        '
        'optDimension
        '
        Me.optDimension.Location = New System.Drawing.Point(24, 56)
        Me.optDimension.Name = "optDimension"
        Me.optDimension.Size = New System.Drawing.Size(80, 24)
        Me.optDimension.TabIndex = 1
        Me.optDimension.Text = "Dimension"
        '
        'cboNorm
        '
        Me.cboNorm.DisplayMember = "Text"
        Me.cboNorm.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboNorm.Location = New System.Drawing.Point(40, 48)
        Me.cboNorm.Name = "cboNorm"
        Me.cboNorm.Size = New System.Drawing.Size(440, 21)
        Me.cboNorm.TabIndex = 1
        Me.cboNorm.ValueMember = "Value"
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(40, 24)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(80, 21)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Select a Norm"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'btnSubmit
        '
        Me.btnSubmit.Location = New System.Drawing.Point(40, 408)
        Me.btnSubmit.Name = "btnSubmit"
        Me.btnSubmit.TabIndex = 1
        Me.btnSubmit.Text = "Submit"
        '
        'lstDimension
        '
        Me.lstDimension.DisplayMember = "Text"
        Me.lstDimension.Location = New System.Drawing.Point(112, 64)
        Me.lstDimension.Name = "lstDimension"
        Me.lstDimension.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.lstDimension.Size = New System.Drawing.Size(304, 147)
        Me.lstDimension.TabIndex = 2
        Me.lstDimension.ValueMember = "Value"
        '
        'CanadaBenchmarkPerformer
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "CanadaBenchmarkPerformer"
        Me.Size = New System.Drawing.Size(520, 440)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel2.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Sub Start()
        Dim items As ArrayList
        Dim rdr As SqlDataReader = Nothing

        'Initial norm combo box
        Try
            Dim compTypeID As Integer
            Dim compName As String

            items = New ArrayList
            rdr = DataAccess.SelectCanadaBenchmarkNorm
            Do While rdr.Read
                compTypeID = CInt(rdr("CompType_ID"))
                compName = CStr(rdr("Selection_Box"))
                items.Add(New ListBoxItem(compTypeID, compName + " (" & compTypeID & ")"))
            Loop

            cboNorm.BeginUpdate()
            cboNorm.DataSource = items
            If cboNorm.Items.Count > 0 Then cboNorm.SelectedIndex = 0
            cboNorm.EndUpdate()

        Catch ex As Exception
            Throw ex
        Finally
            If Not rdr Is Nothing Then
                rdr.Close()
                rdr = Nothing
            End If
        End Try

        'Initial dimension combo box
        Try
            Dim dimensionID As Integer
            Dim dimensionName As String

            items = New ArrayList
            rdr = DataAccess.SelectDimensionList(CurrentUser.Member.MemberId, 0)
            Do While rdr.Read
                dimensionID = CInt(rdr("Dimension_ID"))
                dimensionName = CStr(rdr("strDimension_NM"))
                items.Add(New ListBoxItem(dimensionID, dimensionName + " (" & dimensionID & ")"))
            Loop

            lstDimension.BeginUpdate()
            lstDimension.DataSource = items
            lstDimension.EndUpdate()

        Catch ex As Exception
            Throw ex
        Finally
            If Not rdr Is Nothing Then
                rdr.Close()
                rdr = Nothing
            End If
        End Try

        optQuestion.Checked = True
    End Sub

    Private Sub QuestionRadioButton_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles optQuestion.CheckedChanged
        lstDimension.Enabled = False
    End Sub

    Private Sub DimensionRadioButton_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles optDimension.CheckedChanged
        lstDimension.Enabled = True
    End Sub

    Private Sub SubmitButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Dim compTypeID As Integer
        Dim dimensions As String = String.Empty

        If (cboNorm.SelectedIndex < 0) Then
            cboNorm.Focus()
            MessageBox.Show("Select a norm to continue", "Benchmark Performer", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        compTypeID = CInt(cboNorm.SelectedValue)

        If (optDimension.Checked) Then
            If (lstDimension.SelectedItems.Count = 0) Then
                lstDimension.Focus()
                Dim msg As String
                msg = "Select at least one dimension to continue." + vbCrLf + "If no dimension appears in the list, go to dimension creation tool to define dimension."
                MessageBox.Show(msg, "Benchmark Performer", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            dimensions = ""
            For Each item As ListBoxItem In lstDimension.SelectedItems
                If (dimensions <> "") Then dimensions += ","
                dimensions += item.Value.ToString
            Next
            dimensions = System.Web.HttpUtility.UrlEncode(dimensions)
        End If

        Dim reportViewer As New frmReportReviewer

        If (optQuestion.Checked) Then
            reportViewer.LoadCanadaQuestionBenchmarkPerformerReport(compTypeID)
        Else
            reportViewer.LoadCanadaDimensionBenchmarkPerformerReport(compTypeID, dimensions)
        End If
        reportViewer.ShowDialog(Me)

    End Sub

End Class
