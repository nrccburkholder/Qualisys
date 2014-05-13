Imports NormsApplicationBusinessObjectsLibrary
Public Class PopulateNorms
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
    Friend WithEvents btnPopulate As System.Windows.Forms.Button
    Friend WithEvents lblPercentComplete As System.Windows.Forms.Label
    Friend WithEvents pgbNorms As System.Windows.Forms.ProgressBar
    Friend WithEvents NormsListDetailed1 As NormsApplication.NormsListDetailed
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.btnCancel = New System.Windows.Forms.Button
        Me.NormsListDetailed1 = New NormsApplication.NormsListDetailed
        Me.btnPopulate = New System.Windows.Forms.Button
        Me.lblPercentComplete = New System.Windows.Forms.Label
        Me.pgbNorms = New System.Windows.Forms.ProgressBar
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.AutoScroll = True
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Populate Norms"
        Me.SectionPanel1.Controls.Add(Me.btnCancel)
        Me.SectionPanel1.Controls.Add(Me.NormsListDetailed1)
        Me.SectionPanel1.Controls.Add(Me.btnPopulate)
        Me.SectionPanel1.Controls.Add(Me.lblPercentComplete)
        Me.SectionPanel1.Controls.Add(Me.pgbNorms)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(712, 688)
        Me.SectionPanel1.TabIndex = 0
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Arrow
        Me.btnCancel.Enabled = False
        Me.btnCancel.Location = New System.Drawing.Point(319, 656)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 11
        Me.btnCancel.Text = "Cancel"
        '
        'NormsListDetailed1
        '
        Me.NormsListDetailed1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NormsListDetailed1.Location = New System.Drawing.Point(28, 48)
        Me.NormsListDetailed1.Name = "NormsListDetailed1"
        Me.NormsListDetailed1.Size = New System.Drawing.Size(656, 496)
        Me.NormsListDetailed1.TabIndex = 9
        '
        'btnPopulate
        '
        Me.btnPopulate.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnPopulate.Location = New System.Drawing.Point(319, 552)
        Me.btnPopulate.Name = "btnPopulate"
        Me.btnPopulate.TabIndex = 2
        Me.btnPopulate.Text = "Populate"
        '
        'lblPercentComplete
        '
        Me.lblPercentComplete.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.lblPercentComplete.Enabled = False
        Me.lblPercentComplete.Location = New System.Drawing.Point(252, 624)
        Me.lblPercentComplete.Name = "lblPercentComplete"
        Me.lblPercentComplete.Size = New System.Drawing.Size(208, 23)
        Me.lblPercentComplete.TabIndex = 7
        Me.lblPercentComplete.TextAlign = System.Drawing.ContentAlignment.TopCenter
        '
        'pgbNorms
        '
        Me.pgbNorms.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pgbNorms.Enabled = False
        Me.pgbNorms.Location = New System.Drawing.Point(108, 584)
        Me.pgbNorms.Name = "pgbNorms"
        Me.pgbNorms.Size = New System.Drawing.Size(496, 23)
        Me.pgbNorms.TabIndex = 6
        '
        'PopulateNorms
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "PopulateNorms"
        Me.Size = New System.Drawing.Size(712, 688)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region
    'define delegates for async
    Private Delegate Sub DoLongProcessDelegate()
    Private Delegate Sub UpdateUIDelegate()
    Private Delegate Sub FinishLongProcessDelegate(ByVal ar As IAsyncResult)
    Private mAborted As Boolean = False


    Private Sub btnPopulate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPopulate.Click
        If NormsListDetailed1.lsvNorms.SelectedItems.Count = 0 Then Return

        pgbNorms.Enabled = True
        btnCancel.Enabled = True
        lblPercentComplete.Text = "0% Completed"
        lblPercentComplete.Enabled = True
        pgbNorms.Minimum = 0
        pgbNorms.Maximum = NormsListDetailed1.lsvNorms.SelectedItems.Count
        pgbNorms.Step = 1
        pgbNorms.Value = 0

        'Set the cursor
        Me.Cursor = Cursors.WaitCursor
        'Create the delegates
        Dim method As New DoLongProcessDelegate(AddressOf callNormPopulate)
        Dim callback As New AsyncCallback(AddressOf FinishLongProcess)

        'Call the method asynchonously, passing in the callback delegate
        method.BeginInvoke(callback, method)
    End Sub

    Private Sub FinishLongProcess(ByVal ar As IAsyncResult)
        If Me.InvokeRequired Then
            Me.BeginInvoke(New FinishLongProcessDelegate(AddressOf FinishLongProcess), New Object() {ar})
            Return
        End If

        'This is called after the async thread has finished
        Try
            If Not mAborted Then
                DirectCast(ar.AsyncState, DoLongProcessDelegate).EndInvoke(ar)
                MessageBox.Show("Population of norms was successful.", "Population Successful", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Else
                MessageBox.Show("Population canceled", "Cancel", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show(ex.Message, "Error Populating Norms", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
        AfterPopulate()
    End Sub

    Private Sub AfterPopulate()
        'Clean up
        Me.Cursor = Cursors.Default
        lblPercentComplete.Enabled = False
        btnCancel.Enabled = False
        pgbNorms.Enabled = False
        pgbNorms.Value = 0
        NormsListDetailed1.PopulateNormslist()
        lblPercentComplete.Text = ""
    End Sub

    Private Sub UpdateUI()
        If InvokeRequired Then
            BeginInvoke(New UpdateUIDelegate(AddressOf UpdateUI), Nothing)
            Return
        End If

        'Update the UI elements
        pgbNorms.PerformStep()
        lblPercentComplete.Text = String.Format("{0}% Completed", CInt((pgbNorms.Value / pgbNorms.Maximum) * 100))
    End Sub

    Private Sub callNormPopulate()
        For Each norm As ListViewItem In NormsListDetailed1.lsvNorms.SelectedItems
            If mAborted = True Then Return
            DirectCast(norm.Tag, USNormSetting).PopulateNorm()
            UpdateUI()
        Next
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        mAborted = True
        btnCancel.Enabled = False
    End Sub
End Class
