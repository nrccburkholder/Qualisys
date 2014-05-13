Imports NormsApplicationBusinessObjectsLibrary
Public Class NormsListDetailed
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
    Friend WithEvents lsvNorms As System.Windows.Forms.ListView
    Friend WithEvents chdNormID As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdLabel As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdDescription As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdUpdated As System.Windows.Forms.ColumnHeader
    Friend WithEvents lklOngoing As System.Windows.Forms.LinkLabel
    Friend WithEvents lklRefresh As System.Windows.Forms.LinkLabel
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.lsvNorms = New System.Windows.Forms.ListView
        Me.chdNormID = New System.Windows.Forms.ColumnHeader
        Me.chdLabel = New System.Windows.Forms.ColumnHeader
        Me.chdDescription = New System.Windows.Forms.ColumnHeader
        Me.chdUpdated = New System.Windows.Forms.ColumnHeader
        Me.lklOngoing = New System.Windows.Forms.LinkLabel
        Me.lklRefresh = New System.Windows.Forms.LinkLabel
        Me.SuspendLayout()
        '
        'lsvNorms
        '
        Me.lsvNorms.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lsvNorms.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdNormID, Me.chdLabel, Me.chdDescription, Me.chdUpdated})
        Me.lsvNorms.FullRowSelect = True
        Me.lsvNorms.HideSelection = False
        Me.lsvNorms.Location = New System.Drawing.Point(8, 0)
        Me.lsvNorms.Name = "lsvNorms"
        Me.lsvNorms.Size = New System.Drawing.Size(656, 368)
        Me.lsvNorms.TabIndex = 2
        Me.lsvNorms.View = System.Windows.Forms.View.Details
        '
        'chdNormID
        '
        Me.chdNormID.Text = "Norm ID"
        '
        'chdLabel
        '
        Me.chdLabel.Text = "Label"
        Me.chdLabel.Width = 210
        '
        'chdDescription
        '
        Me.chdDescription.Text = "Description"
        Me.chdDescription.Width = 276
        '
        'chdUpdated
        '
        Me.chdUpdated.Text = "Last Updated"
        Me.chdUpdated.Width = 105
        '
        'lklOngoing
        '
        Me.lklOngoing.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lklOngoing.Location = New System.Drawing.Point(8, 376)
        Me.lklOngoing.Name = "lklOngoing"
        Me.lklOngoing.Size = New System.Drawing.Size(144, 23)
        Me.lklOngoing.TabIndex = 10
        Me.lklOngoing.TabStop = True
        Me.lklOngoing.Text = "Select All Ongoing Norms"
        '
        'lklRefresh
        '
        Me.lklRefresh.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lklRefresh.Location = New System.Drawing.Point(592, 376)
        Me.lklRefresh.Name = "lklRefresh"
        Me.lklRefresh.Size = New System.Drawing.Size(72, 23)
        Me.lklRefresh.TabIndex = 11
        Me.lklRefresh.TabStop = True
        Me.lklRefresh.Text = "Refresh"
        '
        'NormsListDetailed
        '
        Me.Controls.Add(Me.lklRefresh)
        Me.Controls.Add(Me.lklOngoing)
        Me.Controls.Add(Me.lsvNorms)
        Me.Name = "NormsListDetailed"
        Me.Size = New System.Drawing.Size(664, 400)
        Me.ResumeLayout(False)

    End Sub

#End Region
    Private Sub lklOngoing_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lklOngoing.LinkClicked
        lsvNorms.SelectedItems.Clear()
        For Each item As ListViewItem In lsvNorms.Items
            If DirectCast(item.Tag, USNormSetting).Ongoing Then item.Selected = True
        Next
        lsvNorms.Focus()
    End Sub

    Private Sub lklRefresh_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lklRefresh.LinkClicked
        PopulateNormslist()
    End Sub

    Public Sub PopulateNormslist()
        Dim tmpListviewitem As ListViewItem
        lsvNorms.Items.Clear()
        For Each norm As USNormSetting In USNormSetting.GetAllNorms(False)
            tmpListviewitem = New ListViewItem(norm.NormID.ToString)
            tmpListviewitem.Tag = norm
            tmpListviewitem.SubItems.Add(norm.NormLabel)
            tmpListviewitem.SubItems.Add(norm.NormDescription)
            tmpListviewitem.SubItems.Add(norm.LastUpdate)
            lsvNorms.Items.Add(tmpListviewitem)
        Next
    End Sub

    Private Sub NormsListDetailed_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        PopulateNormslist()
    End Sub
End Class
