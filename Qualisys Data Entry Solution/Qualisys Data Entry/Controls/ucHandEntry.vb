Public Class ucHandEntry
    Inherits System.Windows.Forms.UserControl
    Implements IWorkSection

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
    Friend WithEvents spnHand As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents lblRangeHand As System.Windows.Forms.Label
    Friend WithEvents lblRangeCaptionHand As System.Windows.Forms.Label
    Friend WithEvents txtHand As System.Windows.Forms.TextBox
    Friend WithEvents btnAdvanceHand As System.Windows.Forms.Button
    Friend WithEvents shdHand As SectionHeader
    Friend WithEvents lblQstnCountHand As System.Windows.Forms.Label
    Friend WithEvents btnNextQstnHand As System.Windows.Forms.Button
    Friend WithEvents btnPrevQstnHand As System.Windows.Forms.Button
    Friend WithEvents lblCurQstnHand As System.Windows.Forms.Label
    Friend WithEvents lblCurQstnCaptionHand As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.spnHand = New Nrc.Framework.WinForms.SectionPanel
        Me.lblRangeHand = New System.Windows.Forms.Label
        Me.lblRangeCaptionHand = New System.Windows.Forms.Label
        Me.txtHand = New System.Windows.Forms.TextBox
        Me.btnAdvanceHand = New System.Windows.Forms.Button
        Me.shdHand = New SectionHeader
        Me.lblQstnCountHand = New System.Windows.Forms.Label
        Me.btnNextQstnHand = New System.Windows.Forms.Button
        Me.btnPrevQstnHand = New System.Windows.Forms.Button
        Me.lblCurQstnHand = New System.Windows.Forms.Label
        Me.lblCurQstnCaptionHand = New System.Windows.Forms.Label
        Me.spnHand.SuspendLayout()
        Me.shdHand.SuspendLayout()
        Me.SuspendLayout()
        '
        'spnHand
        '
        Me.spnHand.BackColor = System.Drawing.SystemColors.Control
        Me.spnHand.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnHand.Caption = "Handwritten - 1441C01 - 12345678"
        Me.spnHand.Controls.Add(Me.lblRangeHand)
        Me.spnHand.Controls.Add(Me.lblRangeCaptionHand)
        Me.spnHand.Controls.Add(Me.txtHand)
        Me.spnHand.Controls.Add(Me.btnAdvanceHand)
        Me.spnHand.Controls.Add(Me.shdHand)
        Me.spnHand.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spnHand.DockPadding.All = 1
        Me.spnHand.Location = New System.Drawing.Point(0, 0)
        Me.spnHand.Name = "spnHand"
        Me.spnHand.ShowCaption = True
        Me.spnHand.Size = New System.Drawing.Size(688, 576)
        Me.spnHand.TabIndex = 5
        '
        'lblRangeHand
        '
        Me.lblRangeHand.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblRangeHand.Location = New System.Drawing.Point(96, 92)
        Me.lblRangeHand.Name = "lblRangeHand"
        Me.lblRangeHand.Size = New System.Drawing.Size(584, 16)
        Me.lblRangeHand.TabIndex = 9
        Me.lblRangeHand.Text = "42 characters"
        '
        'lblRangeCaptionHand
        '
        Me.lblRangeCaptionHand.Location = New System.Drawing.Point(12, 92)
        Me.lblRangeCaptionHand.Name = "lblRangeCaptionHand"
        Me.lblRangeCaptionHand.Size = New System.Drawing.Size(84, 16)
        Me.lblRangeCaptionHand.TabIndex = 8
        Me.lblRangeCaptionHand.Text = "Valid Range Is:"
        '
        'txtHand
        '
        Me.txtHand.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtHand.Location = New System.Drawing.Point(8, 64)
        Me.txtHand.Name = "txtHand"
        Me.txtHand.Size = New System.Drawing.Size(672, 21)
        Me.txtHand.TabIndex = 7
        Me.txtHand.Text = ""
        '
        'btnAdvanceHand
        '
        Me.btnAdvanceHand.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnAdvanceHand.Location = New System.Drawing.Point(8, 544)
        Me.btnAdvanceHand.Name = "btnAdvanceHand"
        Me.btnAdvanceHand.Size = New System.Drawing.Size(88, 24)
        Me.btnAdvanceHand.TabIndex = 6
        Me.btnAdvanceHand.Text = "Advance (F10)"
        '
        'shdHand
        '
        Me.shdHand.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.shdHand.Controls.Add(Me.lblQstnCountHand)
        Me.shdHand.Controls.Add(Me.btnNextQstnHand)
        Me.shdHand.Controls.Add(Me.btnPrevQstnHand)
        Me.shdHand.Controls.Add(Me.lblCurQstnHand)
        Me.shdHand.Controls.Add(Me.lblCurQstnCaptionHand)
        Me.shdHand.Location = New System.Drawing.Point(1, 27)
        Me.shdHand.Name = "shdHand"
        Me.shdHand.Size = New System.Drawing.Size(686, 28)
        Me.shdHand.TabIndex = 5
        '
        'lblQstnCountHand
        '
        Me.lblQstnCountHand.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblQstnCountHand.Location = New System.Drawing.Point(592, 8)
        Me.lblQstnCountHand.Name = "lblQstnCountHand"
        Me.lblQstnCountHand.Size = New System.Drawing.Size(52, 16)
        Me.lblQstnCountHand.TabIndex = 4
        Me.lblQstnCountHand.Text = "1 of 3"
        Me.lblQstnCountHand.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'btnNextQstnHand
        '
        Me.btnNextQstnHand.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnNextQstnHand.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnNextQstnHand.Location = New System.Drawing.Point(644, 8)
        Me.btnNextQstnHand.Name = "btnNextQstnHand"
        Me.btnNextQstnHand.Size = New System.Drawing.Size(24, 16)
        Me.btnNextQstnHand.TabIndex = 3
        Me.btnNextQstnHand.Text = ">"
        '
        'btnPrevQstnHand
        '
        Me.btnPrevQstnHand.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnPrevQstnHand.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnPrevQstnHand.Location = New System.Drawing.Point(568, 8)
        Me.btnPrevQstnHand.Name = "btnPrevQstnHand"
        Me.btnPrevQstnHand.Size = New System.Drawing.Size(24, 16)
        Me.btnPrevQstnHand.TabIndex = 2
        Me.btnPrevQstnHand.Text = "<"
        '
        'lblCurQstnHand
        '
        Me.lblCurQstnHand.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblCurQstnHand.Location = New System.Drawing.Point(112, 8)
        Me.lblCurQstnHand.Name = "lblCurQstnHand"
        Me.lblCurQstnHand.Size = New System.Drawing.Size(444, 16)
        Me.lblCurQstnHand.TabIndex = 1
        Me.lblCurQstnHand.Text = "What would you change about your stay? - Other"
        '
        'lblCurQstnCaptionHand
        '
        Me.lblCurQstnCaptionHand.BackColor = System.Drawing.Color.Transparent
        Me.lblCurQstnCaptionHand.Location = New System.Drawing.Point(12, 8)
        Me.lblCurQstnCaptionHand.Name = "lblCurQstnCaptionHand"
        Me.lblCurQstnCaptionHand.Size = New System.Drawing.Size(96, 16)
        Me.lblCurQstnCaptionHand.TabIndex = 0
        Me.lblCurQstnCaptionHand.Text = "Current Question:"
        '
        'ucHandEntry
        '
        Me.Controls.Add(Me.spnHand)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "ucHandEntry"
        Me.Size = New System.Drawing.Size(688, 576)
        Me.spnHand.ResumeLayout(False)
        Me.shdHand.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Event WorkBegining(ByVal sender As Object, ByVal e As WorkBeginingEventArgs) Implements IWorkSection.WorkBegining
    Public Event WorkEnding(ByVal sender As Object, ByVal e As WorkEndingEventArgs) Implements IWorkSection.WorkEnding

    Public Sub BeginWork(ByVal batchID As Integer, ByVal template As String, ByVal isVerification As Boolean) Implements IWorkSection.BeginWork

    End Sub

    Public Function EndWork() As Boolean Implements IWorkSection.EndWork

    End Function

    Public ReadOnly Property IsWorking() As Boolean Implements IWorkSection.IsWorking
        Get

        End Get
    End Property

End Class
