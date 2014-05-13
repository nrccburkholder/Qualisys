Imports NormsApplicationBusinessObjectsLibrary
Public Class PromoteNorms
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
    Friend WithEvents lblPercentComplete As System.Windows.Forms.Label
    Friend WithEvents pgbNorms As System.Windows.Forms.ProgressBar
    Friend WithEvents NormsListDetailed1 As NormsApplication.NormsListDetailed
    Friend WithEvents btnPromoteProperties As System.Windows.Forms.Button
    Friend WithEvents btnPromoteAll As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnPromoteAll = New System.Windows.Forms.Button
        Me.NormsListDetailed1 = New NormsApplication.NormsListDetailed
        Me.btnPromoteProperties = New System.Windows.Forms.Button
        Me.lblPercentComplete = New System.Windows.Forms.Label
        Me.pgbNorms = New System.Windows.Forms.ProgressBar
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.AutoScroll = True
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Promote Norms"
        Me.SectionPanel1.Controls.Add(Me.btnCancel)
        Me.SectionPanel1.Controls.Add(Me.btnPromoteAll)
        Me.SectionPanel1.Controls.Add(Me.NormsListDetailed1)
        Me.SectionPanel1.Controls.Add(Me.btnPromoteProperties)
        Me.SectionPanel1.Controls.Add(Me.lblPercentComplete)
        Me.SectionPanel1.Controls.Add(Me.pgbNorms)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(712, 696)
        Me.SectionPanel1.TabIndex = 0
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Arrow
        Me.btnCancel.Enabled = False
        Me.btnCancel.Location = New System.Drawing.Point(319, 656)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 13
        Me.btnCancel.Text = "Cancel"
        '
        'btnPromoteAll
        '
        Me.btnPromoteAll.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnPromoteAll.Location = New System.Drawing.Point(412, 520)
        Me.btnPromoteAll.Name = "btnPromoteAll"
        Me.btnPromoteAll.Size = New System.Drawing.Size(160, 23)
        Me.btnPromoteAll.TabIndex = 11
        Me.btnPromoteAll.Text = "Promote Properties and Data"
        '
        'NormsListDetailed1
        '
        Me.NormsListDetailed1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NormsListDetailed1.Location = New System.Drawing.Point(24, 48)
        Me.NormsListDetailed1.Name = "NormsListDetailed1"
        Me.NormsListDetailed1.Size = New System.Drawing.Size(656, 456)
        Me.NormsListDetailed1.TabIndex = 9
        '
        'btnPromoteProperties
        '
        Me.btnPromoteProperties.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnPromoteProperties.Location = New System.Drawing.Point(140, 520)
        Me.btnPromoteProperties.Name = "btnPromoteProperties"
        Me.btnPromoteProperties.Size = New System.Drawing.Size(160, 23)
        Me.btnPromoteProperties.TabIndex = 2
        Me.btnPromoteProperties.Text = "Promote Properties"
        '
        'lblPercentComplete
        '
        Me.lblPercentComplete.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.lblPercentComplete.Enabled = False
        Me.lblPercentComplete.Location = New System.Drawing.Point(244, 600)
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
        Me.pgbNorms.Location = New System.Drawing.Point(100, 560)
        Me.pgbNorms.Name = "pgbNorms"
        Me.pgbNorms.Size = New System.Drawing.Size(496, 23)
        Me.pgbNorms.TabIndex = 6
        '
        'PromoteNorms
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "PromoteNorms"
        Me.Size = New System.Drawing.Size(712, 696)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region
    'define delegates for async
    Private Delegate Sub DoLongProcessDelegate(ByVal all As Boolean)
    Private Delegate Sub UpdateUIDelegate()
    Private Delegate Sub FinishLongProcessDelegate(ByVal ar As IAsyncResult)
    Private mAborted As Boolean = False

    Private Sub btnPromoteAll_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPromoteAll.Click
        Promote(True)
    End Sub

    Private Sub btnPromoteProperties_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPromoteProperties.Click
        Promote(False)
    End Sub

    Private Sub Promote(ByVal all As Boolean)
        If NormsListDetailed1.lsvNorms.SelectedItems.Count = 0 Then Return

        mAborted = False
        btnPromoteAll.Enabled = False
        btnPromoteProperties.Enabled = False
        btnCancel.Enabled = True
        pgbNorms.Enabled = True
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
        method.BeginInvoke(all, callback, method)

    End Sub

    Private Sub FinishLongProcess(ByVal ar As IAsyncResult)
        If Me.InvokeRequired Then
            Me.BeginInvoke(New FinishLongProcessDelegate(AddressOf FinishLongProcess), New Object() {ar})
            Return
        End If

        'This is called after the async thread has finished
        Try
            'Call endInvoke;  If any errors occurred, an exception will be thrown
            If Not mAborted Then
                DirectCast(ar.AsyncState, DoLongProcessDelegate).EndInvoke(ar)
                MessageBox.Show("Promotion of norms was successful.", "Promotion Successful", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Else
                MessageBox.Show("Promotion canceled", "Cancel", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show(ex.Message, "Error Promoting Norms", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

        'Clean up
        AfterPromotion()
    End Sub

    Private Sub AfterPromotion()
        'Clean up
        btnPromoteAll.Enabled = True
        btnPromoteProperties.Enabled = True
        btnCancel.Enabled = False
        Me.Cursor = Cursors.Default
        lblPercentComplete.Enabled = False
        pgbNorms.Value = 0
        pgbNorms.Enabled = False
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

    Private Sub callNormPopulate(ByVal all As Boolean)
        For Each norm As ListViewItem In NormsListDetailed1.lsvNorms.SelectedItems
            If mAborted = True Then Return
            DataAccess.PromoteNorms(all, DirectCast(norm.Tag, USNormSetting).NormID)
            UpdateUI()
        Next
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        mAborted = True
        btnCancel.Enabled = False
    End Sub
End Class
