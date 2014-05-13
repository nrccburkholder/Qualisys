Public Class NotifyPdfMissing
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        'EnableThemes(Me)

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
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents lvwApb As NRC.WinForms.NRCListView
    Friend WithEvents chdApID As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdDocumentName As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdJobID As NRC.WinForms.NRCColumnHeader
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(NotifyPdfMissing))
        Me.btnOK = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.lvwApb = New NRC.WinForms.NRCListView
        Me.chdApID = New System.Windows.Forms.ColumnHeader
        Me.chdDocumentName = New System.Windows.Forms.ColumnHeader
        Me.chdJobID = New NRC.WinForms.NRCColumnHeader
        Me.SuspendLayout()
        '
        'btnOK
        '
        Me.btnOK.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnOK.Location = New System.Drawing.Point(352, 304)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.TabIndex = 2
        Me.btnOK.Text = "OK"
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(432, 304)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 3
        Me.btnCancel.Text = "Cancel"
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(24, 24)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(496, 16)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "PDF are not generated for these AP reports. These reports will be excluded from p" & _
        "osting."
        '
        'lvwApb
        '
        Me.lvwApb.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwApb.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdApID, Me.chdDocumentName, Me.chdJobID})
        Me.lvwApb.Location = New System.Drawing.Point(24, 48)
        Me.lvwApb.Name = "lvwApb"
        Me.lvwApb.Size = New System.Drawing.Size(488, 240)
        Me.lvwApb.SortColumn = -1
        Me.lvwApb.SortOrder = NRC.WinForms.SortOrder.NotSorted
        Me.lvwApb.TabIndex = 1
        Me.lvwApb.View = System.Windows.Forms.View.Details
        '
        'chdApID
        '
        Me.chdApID.Text = "AP ID"
        Me.chdApID.Width = 120
        '
        'chdDocumentName
        '
        Me.chdDocumentName.Text = "Document Name"
        Me.chdDocumentName.Width = 150
        '
        'chdJobID
        '
        Me.chdJobID.DataType = NRC.WinForms.DataType._Unknown
        Me.chdJobID.Text = "Job ID"
        Me.chdJobID.Width = 65
        '
        'NotifyPdfMissing
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(536, 350)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.lvwApb)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MinimizeBox = False
        Me.Name = "NotifyPdfMissing"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "APB Report Posting"
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Members"

    Public Enum ListField
        ApID = 0
        DocumentName = 1
        JobID = 2
        ItemIndex = 3
    End Enum

#End Region

#Region " Event Handlers"

    Private Sub lvwApb_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwApb.SizeChanged
        ListViewResize(CType(sender, ListView), ListField.DocumentName)
    End Sub

#End Region

#Region " Private Methods"

    Private Sub ListViewResize(ByVal lvw As ListView, ByVal resizableColumnIndex As Integer)
        If (lvw Is Nothing OrElse lvw.Columns.Count = 0) Then Return
        Dim width As Integer
        Dim column As ColumnHeader
        Dim columnId As Integer = 0

        With lvw
            width = .Width
            For Each column In .Columns
                If (columnId <> resizableColumnIndex) Then
                    width -= column.Width
                End If
                columnId += 1
            Next
            width -= ComponentSize.ScrollBar
            If width < 50 Then width = 50
            .Columns(resizableColumnIndex).Width = width
        End With

    End Sub

#End Region

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        Me.DialogResult = DialogResult.OK
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.DialogResult = DialogResult.Cancel
    End Sub

    Private Sub NotifyPdfMissing_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ListViewResize(lvwApb, ListField.DocumentName)
    End Sub
End Class
