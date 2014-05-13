Imports NRC.Qualisys.QualisysDataEntry.Library
Public Class frmStats
    Inherits Nrc.Framework.WinForms.DialogForm

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
    Friend WithEvents colStage As System.Windows.Forms.ColumnHeader
    Friend WithEvents colAmount As System.Windows.Forms.ColumnHeader
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents lvwStats As System.Windows.Forms.ListView
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.lvwStats = New System.Windows.Forms.ListView
        Me.colStage = New System.Windows.Forms.ColumnHeader
        Me.colAmount = New System.Windows.Forms.ColumnHeader
        Me.btnOK = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "System Statistics"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(246, 26)
        '
        'lvwStats
        '
        Me.lvwStats.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colStage, Me.colAmount})
        Me.lvwStats.FullRowSelect = True
        Me.lvwStats.GridLines = True
        Me.lvwStats.HideSelection = False
        Me.lvwStats.Location = New System.Drawing.Point(16, 40)
        Me.lvwStats.Name = "lvwStats"
        Me.lvwStats.Size = New System.Drawing.Size(216, 168)
        Me.lvwStats.TabIndex = 1
        Me.lvwStats.View = System.Windows.Forms.View.Details
        '
        'colStage
        '
        Me.colStage.Text = "Stage"
        Me.colStage.Width = 107
        '
        'colAmount
        '
        Me.colAmount.Text = "Amount"
        Me.colAmount.Width = 105
        '
        'btnOK
        '
        Me.btnOK.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnOK.Location = New System.Drawing.Point(80, 232)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.TabIndex = 2
        Me.btnOK.Text = "OK"
        '
        'frmStats
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.Caption = "System Statistics"
        Me.ClientSize = New System.Drawing.Size(248, 273)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.lvwStats)
        Me.DockPadding.All = 1
        Me.Name = "frmStats"
        Me.Text = "frmStats"
        Me.Controls.SetChildIndex(Me.lvwStats, 0)
        Me.Controls.SetChildIndex(Me.btnOK, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub frmStats_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim tbl As DataTable = Batch.GetSystemStats
        Dim row As DataRow
        If Not tbl Is Nothing AndAlso Not tbl.Rows.Count = 0 Then
            row = tbl.Rows(0)
            Dim toBeKeyed As Integer = DbHelper.CheckNull(Of Integer)(row("ToBeKeyed"), 0)
            Dim toBeKeyVerified As Integer = DbHelper.CheckNull(Of Integer)(row("ToBeKeyVerified"), 0)
            Dim toBeCoded As Integer = DbHelper.CheckNull(Of Integer)(row("ToBeCoded"), 0)
            Dim toBeCodeVerified As Integer = DbHelper.CheckNull(Of Integer)(row("ToBeCodeVerified"), 0)
            Dim toBeFinalized As Integer = DbHelper.CheckNull(Of Integer)(row("ToBeFinalized"), 0)
            Dim msg As New System.Text.StringBuilder
            Dim item As ListViewItem

            item = New ListViewItem("To Be Keyed")
            item.SubItems.Add(New ListViewItem.ListViewSubItem(item, toBeKeyed.ToString))
            lvwStats.Items.Add(item)

            item = New ListViewItem("To Be Key Verified")
            item.SubItems.Add(New ListViewItem.ListViewSubItem(item, toBeKeyVerified.ToString))
            lvwStats.Items.Add(item)

            item = New ListViewItem("To Be Coded")
            item.SubItems.Add(New ListViewItem.ListViewSubItem(item, toBeCoded.ToString))
            lvwStats.Items.Add(item)

            item = New ListViewItem("To Be Code Verified")
            item.SubItems.Add(New ListViewItem.ListViewSubItem(item, toBeCodeVerified.ToString))
            lvwStats.Items.Add(item)

            item = New ListViewItem("To Be Finalized")
            item.SubItems.Add(New ListViewItem.ListViewSubItem(item, toBeFinalized.ToString))
            lvwStats.Items.Add(item)

            tbl.Dispose()
        End If

    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        Me.DialogResult = Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub
End Class
