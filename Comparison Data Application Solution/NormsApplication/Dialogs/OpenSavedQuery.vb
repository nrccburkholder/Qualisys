Imports NormsApplicationBusinessObjectsLibrary
Public Class OpenSavedQuery
    Inherits NRC.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal Querylist As ComparisonDataQueryLightCollection)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        Dim tmpListviewitem As ListViewItem
        lsvQueries.Items.Clear()
        For Each query As ComparisonDataQueryLight In Querylist
            tmpListviewitem = New ListViewItem(query.Label)
            tmpListviewitem.Tag = query.ID
            tmpListviewitem.SubItems.Add(query.Description)
            tmpListviewitem.SubItems.Add(query.WhoCreated)
            tmpListviewitem.SubItems.Add(query.WhenCreated)
            lsvQueries.Items.Add(tmpListviewitem)
        Next

    End Sub

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
    Friend WithEvents colLabel As NRC.WinForms.SortableColumn
    Friend WithEvents colDescription As NRC.WinForms.SortableColumn
    Friend WithEvents colWhoCreated As NRC.WinForms.SortableColumn
    Friend WithEvents colWhenCreated As NRC.WinForms.SortableColumn
    Friend WithEvents btnOpen As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents lsvQueries As NRC.WinForms.SortableListView
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.lsvQueries = New NRC.WinForms.SortableListView
        Me.colLabel = New NRC.WinForms.SortableColumn
        Me.colDescription = New NRC.WinForms.SortableColumn
        Me.colWhoCreated = New NRC.WinForms.SortableColumn
        Me.colWhenCreated = New NRC.WinForms.SortableColumn
        Me.btnOpen = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Open Query"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(814, 26)
        '
        'lsvQueries
        '
        Me.lsvQueries.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colLabel, Me.colDescription, Me.colWhoCreated, Me.colWhenCreated})
        Me.lsvQueries.FullRowSelect = True
        Me.lsvQueries.GridLines = True
        Me.lsvQueries.Location = New System.Drawing.Point(32, 48)
        Me.lsvQueries.MultiSelect = False
        Me.lsvQueries.Name = "lsvQueries"
        Me.lsvQueries.Size = New System.Drawing.Size(760, 200)
        Me.lsvQueries.TabIndex = 1
        Me.lsvQueries.View = System.Windows.Forms.View.Details
        '
        'colLabel
        '
        Me.colLabel.DataType = NRC.WinForms.SortableColumn.ColumnDataType.Text
        Me.colLabel.Text = "Label"
        Me.colLabel.Width = 193
        '
        'colDescription
        '
        Me.colDescription.DataType = NRC.WinForms.SortableColumn.ColumnDataType.Text
        Me.colDescription.Text = "Description"
        Me.colDescription.Width = 311
        '
        'colWhoCreated
        '
        Me.colWhoCreated.DataType = NRC.WinForms.SortableColumn.ColumnDataType.Text
        Me.colWhoCreated.Text = "Who Created"
        Me.colWhoCreated.Width = 124
        '
        'colWhenCreated
        '
        Me.colWhenCreated.DataType = NRC.WinForms.SortableColumn.ColumnDataType.Text
        Me.colWhenCreated.Text = "When Created"
        Me.colWhenCreated.Width = 128
        '
        'btnOpen
        '
        Me.btnOpen.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnOpen.Location = New System.Drawing.Point(168, 280)
        Me.btnOpen.Name = "btnOpen"
        Me.btnOpen.TabIndex = 2
        Me.btnOpen.Text = "Open"
        '
        'btnCancel
        '
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Location = New System.Drawing.Point(368, 280)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 3
        Me.btnCancel.Text = "Cancel"
        '
        'OpenSavedQuery
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.Caption = "Open Query"
        Me.ClientSize = New System.Drawing.Size(816, 320)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnOpen)
        Me.Controls.Add(Me.lsvQueries)
        Me.DockPadding.All = 1
        Me.Name = "OpenSavedQuery"
        Me.Text = "OpenSavedQuery"
        Me.Controls.SetChildIndex(Me.lsvQueries, 0)
        Me.Controls.SetChildIndex(Me.btnOpen, 0)
        Me.Controls.SetChildIndex(Me.btnCancel, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)

    End Sub

#End Region
    Private mSelectedQuery As ComparisonDataQuery

#Region "Public Properties"
    Public ReadOnly Property SelectedQuery() As ComparisonDataQuery
        Get
            Return mSelectedQuery
        End Get
    End Property

#End Region

    Private Sub btnOpen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOpen.Click
        mSelectedQuery = ComparisonDataQuery.GetSavedQuery(CInt(lsvQueries.SelectedItems(0).Tag))
        Me.DialogResult = DialogResult.OK
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.DialogResult = DialogResult.Cancel
    End Sub
End Class
