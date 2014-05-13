Option Explicit On 
Option Strict On

Imports Nrc.Qualisys.QLoader.Library20

Public Class frmLoadToLive
    Inherits NRC.Framework.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal package As DTSPackage)

        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        mPackage = package

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
    Friend WithEvents CloseButton As System.Windows.Forms.Button
    Friend WithEvents AddToQueueButton As System.Windows.Forms.Button
    Friend WithEvents FieldSelectionTableLayoutPanel As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents AvailableFieldsPanel As System.Windows.Forms.Panel
    Friend WithEvents AvailableFieldsListBox As System.Windows.Forms.ListBox
    Friend WithEvents AvailableFieldsLabel As System.Windows.Forms.Label
    Friend WithEvents FieldSelectionButtonsPanel As System.Windows.Forms.Panel
    Friend WithEvents UnselectAllButton As System.Windows.Forms.Button
    Friend WithEvents SelectAllButton As System.Windows.Forms.Button
    Friend WithEvents SelectButton As System.Windows.Forms.Button
    Friend WithEvents UnselectButton As System.Windows.Forms.Button
    Friend WithEvents SelectedFieldsPanel As System.Windows.Forms.Panel
    Friend WithEvents SelectedFieldsListBox As System.Windows.Forms.ListBox
    Friend WithEvents SelectedFieldsLabel As System.Windows.Forms.Label
    Friend WithEvents sfdSave As System.Windows.Forms.SaveFileDialog
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.CloseButton = New System.Windows.Forms.Button
        Me.sfdSave = New System.Windows.Forms.SaveFileDialog
        Me.AddToQueueButton = New System.Windows.Forms.Button
        Me.FieldSelectionTableLayoutPanel = New System.Windows.Forms.TableLayoutPanel
        Me.AvailableFieldsPanel = New System.Windows.Forms.Panel
        Me.AvailableFieldsListBox = New System.Windows.Forms.ListBox
        Me.AvailableFieldsLabel = New System.Windows.Forms.Label
        Me.FieldSelectionButtonsPanel = New System.Windows.Forms.Panel
        Me.UnselectAllButton = New System.Windows.Forms.Button
        Me.SelectAllButton = New System.Windows.Forms.Button
        Me.SelectButton = New System.Windows.Forms.Button
        Me.UnselectButton = New System.Windows.Forms.Button
        Me.SelectedFieldsPanel = New System.Windows.Forms.Panel
        Me.SelectedFieldsListBox = New System.Windows.Forms.ListBox
        Me.SelectedFieldsLabel = New System.Windows.Forms.Label
        Me.FieldSelectionTableLayoutPanel.SuspendLayout()
        Me.AvailableFieldsPanel.SuspendLayout()
        Me.FieldSelectionButtonsPanel.SuspendLayout()
        Me.SelectedFieldsPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Load To Live"
        Me.mPaneCaption.Size = New System.Drawing.Size(489, 26)
        Me.mPaneCaption.Text = "Load To Live"
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.CloseButton.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CloseButton.Location = New System.Drawing.Point(408, 253)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(75, 23)
        Me.CloseButton.TabIndex = 3
        Me.CloseButton.Text = "Close"
        '
        'sfdSave
        '
        Me.sfdSave.DefaultExt = "xls"
        Me.sfdSave.Filter = "Excel Files|.xls"
        '
        'AddToQueueButton
        '
        Me.AddToQueueButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.AddToQueueButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.AddToQueueButton.Location = New System.Drawing.Point(304, 253)
        Me.AddToQueueButton.Name = "AddToQueueButton"
        Me.AddToQueueButton.Size = New System.Drawing.Size(98, 23)
        Me.AddToQueueButton.TabIndex = 2
        Me.AddToQueueButton.Text = "Add to Queue"
        '
        'FieldSelectionTableLayoutPanel
        '
        Me.FieldSelectionTableLayoutPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FieldSelectionTableLayoutPanel.ColumnCount = 3
        Me.FieldSelectionTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.FieldSelectionTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 60.0!))
        Me.FieldSelectionTableLayoutPanel.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.FieldSelectionTableLayoutPanel.Controls.Add(Me.AvailableFieldsPanel, 0, 0)
        Me.FieldSelectionTableLayoutPanel.Controls.Add(Me.FieldSelectionButtonsPanel, 1, 0)
        Me.FieldSelectionTableLayoutPanel.Controls.Add(Me.SelectedFieldsPanel, 2, 0)
        Me.FieldSelectionTableLayoutPanel.Location = New System.Drawing.Point(4, 33)
        Me.FieldSelectionTableLayoutPanel.Name = "FieldSelectionTableLayoutPanel"
        Me.FieldSelectionTableLayoutPanel.RowCount = 1
        Me.FieldSelectionTableLayoutPanel.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100.0!))
        Me.FieldSelectionTableLayoutPanel.Size = New System.Drawing.Size(483, 214)
        Me.FieldSelectionTableLayoutPanel.TabIndex = 1
        '
        'AvailableFieldsPanel
        '
        Me.AvailableFieldsPanel.Controls.Add(Me.AvailableFieldsListBox)
        Me.AvailableFieldsPanel.Controls.Add(Me.AvailableFieldsLabel)
        Me.AvailableFieldsPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.AvailableFieldsPanel.Location = New System.Drawing.Point(3, 3)
        Me.AvailableFieldsPanel.Name = "AvailableFieldsPanel"
        Me.AvailableFieldsPanel.Size = New System.Drawing.Size(205, 208)
        Me.AvailableFieldsPanel.TabIndex = 0
        '
        'AvailableFieldsListBox
        '
        Me.AvailableFieldsListBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AvailableFieldsListBox.IntegralHeight = False
        Me.AvailableFieldsListBox.Location = New System.Drawing.Point(0, 19)
        Me.AvailableFieldsListBox.Name = "AvailableFieldsListBox"
        Me.AvailableFieldsListBox.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.AvailableFieldsListBox.Size = New System.Drawing.Size(205, 189)
        Me.AvailableFieldsListBox.Sorted = True
        Me.AvailableFieldsListBox.TabIndex = 1
        '
        'AvailableFieldsLabel
        '
        Me.AvailableFieldsLabel.Location = New System.Drawing.Point(-1, 3)
        Me.AvailableFieldsLabel.Name = "AvailableFieldsLabel"
        Me.AvailableFieldsLabel.Size = New System.Drawing.Size(100, 16)
        Me.AvailableFieldsLabel.TabIndex = 0
        Me.AvailableFieldsLabel.Text = "Available Fields:"
        '
        'FieldSelectionButtonsPanel
        '
        Me.FieldSelectionButtonsPanel.Controls.Add(Me.UnselectAllButton)
        Me.FieldSelectionButtonsPanel.Controls.Add(Me.SelectAllButton)
        Me.FieldSelectionButtonsPanel.Controls.Add(Me.SelectButton)
        Me.FieldSelectionButtonsPanel.Controls.Add(Me.UnselectButton)
        Me.FieldSelectionButtonsPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FieldSelectionButtonsPanel.Location = New System.Drawing.Point(214, 3)
        Me.FieldSelectionButtonsPanel.Name = "FieldSelectionButtonsPanel"
        Me.FieldSelectionButtonsPanel.Size = New System.Drawing.Size(54, 208)
        Me.FieldSelectionButtonsPanel.TabIndex = 1
        '
        'UnselectAllButton
        '
        Me.UnselectAllButton.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.UnselectAllButton.Location = New System.Drawing.Point(7, 137)
        Me.UnselectAllButton.Name = "UnselectAllButton"
        Me.UnselectAllButton.Size = New System.Drawing.Size(40, 24)
        Me.UnselectAllButton.TabIndex = 3
        Me.UnselectAllButton.Text = "<<"
        '
        'SelectAllButton
        '
        Me.SelectAllButton.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SelectAllButton.Location = New System.Drawing.Point(7, 41)
        Me.SelectAllButton.Name = "SelectAllButton"
        Me.SelectAllButton.Size = New System.Drawing.Size(40, 24)
        Me.SelectAllButton.TabIndex = 0
        Me.SelectAllButton.Text = ">>"
        '
        'SelectButton
        '
        Me.SelectButton.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SelectButton.Location = New System.Drawing.Point(7, 73)
        Me.SelectButton.Name = "SelectButton"
        Me.SelectButton.Size = New System.Drawing.Size(40, 24)
        Me.SelectButton.TabIndex = 1
        Me.SelectButton.Text = ">"
        '
        'UnselectButton
        '
        Me.UnselectButton.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.UnselectButton.Location = New System.Drawing.Point(7, 105)
        Me.UnselectButton.Name = "UnselectButton"
        Me.UnselectButton.Size = New System.Drawing.Size(40, 24)
        Me.UnselectButton.TabIndex = 2
        Me.UnselectButton.Text = "<"
        '
        'SelectedFieldsPanel
        '
        Me.SelectedFieldsPanel.Controls.Add(Me.SelectedFieldsListBox)
        Me.SelectedFieldsPanel.Controls.Add(Me.SelectedFieldsLabel)
        Me.SelectedFieldsPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SelectedFieldsPanel.Location = New System.Drawing.Point(274, 3)
        Me.SelectedFieldsPanel.Name = "SelectedFieldsPanel"
        Me.SelectedFieldsPanel.Size = New System.Drawing.Size(206, 208)
        Me.SelectedFieldsPanel.TabIndex = 2
        '
        'SelectedFieldsListBox
        '
        Me.SelectedFieldsListBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SelectedFieldsListBox.IntegralHeight = False
        Me.SelectedFieldsListBox.Location = New System.Drawing.Point(0, 19)
        Me.SelectedFieldsListBox.Name = "SelectedFieldsListBox"
        Me.SelectedFieldsListBox.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.SelectedFieldsListBox.Size = New System.Drawing.Size(206, 189)
        Me.SelectedFieldsListBox.Sorted = True
        Me.SelectedFieldsListBox.TabIndex = 1
        '
        'SelectedFieldsLabel
        '
        Me.SelectedFieldsLabel.Location = New System.Drawing.Point(-1, 3)
        Me.SelectedFieldsLabel.Name = "SelectedFieldsLabel"
        Me.SelectedFieldsLabel.Size = New System.Drawing.Size(104, 16)
        Me.SelectedFieldsLabel.TabIndex = 0
        Me.SelectedFieldsLabel.Text = "Selected Fields:"
        '
        'frmLoadToLive
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 14)
        Me.AutoSize = True
        Me.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.CancelButton = Me.CloseButton
        Me.Caption = "Load To Live"
        Me.ClientSize = New System.Drawing.Size(491, 284)
        Me.ControlBox = False
        Me.Controls.Add(Me.FieldSelectionTableLayoutPanel)
        Me.Controls.Add(Me.CloseButton)
        Me.Controls.Add(Me.AddToQueueButton)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Sizable
        Me.MinimumSize = New System.Drawing.Size(507, 300)
        Me.Name = "frmLoadToLive"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Controls.SetChildIndex(Me.AddToQueueButton, 0)
        Me.Controls.SetChildIndex(Me.CloseButton, 0)
        Me.Controls.SetChildIndex(Me.FieldSelectionTableLayoutPanel, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.FieldSelectionTableLayoutPanel.ResumeLayout(False)
        Me.AvailableFieldsPanel.ResumeLayout(False)
        Me.FieldSelectionButtonsPanel.ResumeLayout(False)
        Me.SelectedFieldsPanel.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Members "

    Private mPackage As DTSPackage

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property SelectedFields(ByVal dataFileID As Integer) As LoadToLiveDefinitionCollection
        Get
            'Collect the fields selected for update
            Dim definitions As New LoadToLiveDefinitionCollection
            Dim tableNames As New List(Of String)

            For Each item As Object In SelectedFieldsListBox.Items
                'Parse the table name and field name
                Dim tableField As String() = item.ToString.Split("."c)

                'Determine if we need to add the match fields for this table
                If Not tableNames.Contains(tableField(0)) Then
                    'Add this table name to the list so we won't add these match fields again
                    tableNames.Add(tableField(0))

                    'Add the match fields for this table
                    Dim dest As DTSDestination = mPackage.Destinations.Item(tableField(0))
                    For Each col As DestinationColumn In dest.Columns
                        If col.IsMatchField Then
                            'Add the field
                            Dim matchDef As LoadToLiveDefinition = LoadToLiveDefinition.NewLoadToLiveDefinition
                            With matchDef
                                .DataFileId = dataFileID
                                .TableName = dest.TableName
                                .FieldName = col.ColumnName
                                .IsMatchField = True
                                .DataType = col.DataType
                            End With
                            definitions.Add(matchDef)
                        End If
                    Next
                End If

                'Add the field
                Dim definition As LoadToLiveDefinition = LoadToLiveDefinition.NewLoadToLiveDefinition
                With definition
                    .DataFileId = dataFileID
                    .TableName = tableField(0)
                    .FieldName = tableField(1)
                    .IsMatchField = False
                    .DataType = mPackage.Destinations.Item(tableField(0)).Columns(tableField(1)).DataType
                End With
                definitions.Add(definition)
            Next

            Return definitions
        End Get
    End Property

#End Region

#Region " Event Handlers "

    Private Sub frmLoadToLive_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'Loop through every destination table possible
        For Each dest As DTSDestination In mPackage.Destinations
            'If this table is used in package
            If dest.UsedInPackage Then
                'Now for each column in this destination table
                For Each col As DestinationColumn In dest.Columns
                    'If this is not a system field or match field then add it!
                    If Not col.IsSystemField AndAlso Not col.IsMatchField AndAlso col.ColumnName.ToUpper <> "NEWRECORDDATE" Then
                        'Add this field to the AvailableFieldsListBox
                        AvailableFieldsListBox.Items.Add(String.Format("{0}.{1}", dest.TableName, col.ColumnName))
                    End If
                Next
            End If
        Next

        SetButtons()

    End Sub

    Private Sub SelectAllButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SelectAllButton.Click

        For Each item As Object In AvailableFieldsListBox.Items
            SelectedFieldsListBox.Items.Add(item)
        Next

        AvailableFieldsListBox.Items.Clear()

        SetButtons()

    End Sub

    Private Sub SelectButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SelectButton.Click

        Dim selectedItems As Windows.Forms.ListBox.SelectedObjectCollection = AvailableFieldsListBox.SelectedItems
        Dim removedItems As New List(Of Object)

        For Each item As Object In selectedItems
            SelectedFieldsListBox.Items.Add(item)
            removedItems.Add(item)
        Next
        For Each item As Object In removedItems
            AvailableFieldsListBox.Items.Remove(item)
        Next

        SetButtons()

    End Sub

    Private Sub UnselectButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UnselectButton.Click

        Dim selectedItems As Windows.Forms.ListBox.SelectedObjectCollection = SelectedFieldsListBox.SelectedItems
        Dim removedItems As New List(Of Object)

        For Each item As Object In selectedItems
            AvailableFieldsListBox.Items.Add(item)
            removedItems.Add(item)
        Next
        For Each item As Object In removedItems
            SelectedFieldsListBox.Items.Remove(item)
        Next

        SetButtons()

    End Sub

    Private Sub UnselectAllButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UnselectAllButton.Click

        For Each item As Object In SelectedFieldsListBox.Items
            AvailableFieldsListBox.Items.Add(item)
        Next

        SelectedFieldsListBox.Items.Clear()

        SetButtons()

    End Sub

    Private Sub AddToQueueButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddToQueueButton.Click

        DialogResult = Windows.Forms.DialogResult.OK
        Close()

    End Sub

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click

        Close()

    End Sub

#End Region

#Region " Private Methods "

    Private Sub SetButtons()

        SelectAllButton.Enabled = (AvailableFieldsListBox.Items.Count > 0)
        SelectButton.Enabled = (AvailableFieldsListBox.Items.Count > 0)

        UnselectButton.Enabled = (SelectedFieldsListBox.Items.Count > 0)
        UnselectAllButton.Enabled = (SelectedFieldsListBox.Items.Count > 0)

        AddToQueueButton.Enabled = (SelectedFieldsListBox.Items.Count > 0)

    End Sub

    'Private Sub LoadFile()

    '    'Make sure the package is valid
    '    If Not mPackage.IsValid Then
    '        Throw New Exception("Invalid package setup.  Please ensure that all destination columns have been mapped.")
    '    End If

    '    Dim dataFileID As Integer
    '    Dim file As DataFile = Nothing

    '    Try
    '        'Create a new DataFile object and set the properties
    '        file = New DataFile
    '        With file
    '            .FileSize = CInt(mFile.Length)
    '            .OriginalFileName = mFile.Name
    '            .FileName = mFile.Extension
    '            .Folder = mPackage.DataStorePath & "\"
    '            .RecordCount = mRecordCount
    '            .DataSetType = mPackage.Source.DataSetType
    '            .IsDRGUpdate = False
    '            .IsLoadToLive = True
    '        End With

    '        'Add the file to the queue
    '        dataFileID = file.QueueDataFile(mPackage.PackageID, mPackage.Version)

    '        'Now copy the file to the network location specified in app.config
    '        CopyFileToNetwork(dataFileID.ToString)

    '        file.ChangeState(DataFileStates.FileQueued, "Loaded by " & CurrentUser.LoginName, CurrentUser.MemberId)

    '        'Make sure package is not locked
    '        If mPackage.LockStatus = PackageLockStates.Unlocked Then
    '            'Lock the package
    '            mPackage.LockPackage()

    '            'Mark file as "Loading"
    '            file.ChangeState(DataFileStates.FileLoading, "", CurrentUser.MemberId)

    '            'Execute the package
    '            mPackage.ExecutePackage(file, False)

    '            'Mark file as "Checking Duplicates"
    '            file.ChangeState(DataFileStates.LoadToLiveCheckingDups, "", CurrentUser.MemberId)

    '            'Check for duplicates
    '            If CheckForDuplicates(file) Then
    '                'Save the update fields

    '                'Mark file as "Awaiting Update"
    '                file.ChangeState(DataFileStates.LoadToLiveAwaitingUpdate, "", CurrentUser.MemberId)
    '            Else
    '                'Mark file as "Abandoned"
    '                file.ChangeState(DataFileStates.Abandoned, String.Format("Load to Live abandoned by {0}", CurrentUser.LoginName), CurrentUser.MemberId)
    '            End If
    '        End If

    '    Catch ex As PackageLockException
    '        ReportException(ex, String.Format("Exception: Could not load DataFile_id {0}: Package {1} is already locked.", dataFileID, ex.PackageID))

    '    Catch ex As Exception
    '        'Mark the file as abandoned
    '        If Not file Is Nothing Then
    '            file.ChangeState(DataFileStates.Abandoned, String.Format("DTS Exception: {0}", ex.Message), CurrentUser.MemberId)
    '        End If

    '        ReportException(ex, String.Format("Exception: Could not load DataFile_id {0}", dataFileID))

    '    Finally
    '        'Unlock the package if we need to...
    '        If Not mPackage Is Nothing AndAlso mPackage.LockStatus = PackageLockStates.LockedByMe Then
    '            mPackage.UnlockPackage()
    '        End If

    '        file = Nothing

    '    End Try

    'End Sub

    'Private Function CheckForDuplicates(ByVal file As DataFile) As Boolean

    '    Dim duplicates As DataTable = Nothing
    '    Dim updateFields As New Dictionary(Of String, List(Of String))

    '    'Collect the fields selected for update
    '    For Each item As Object In SelectedFieldsListBox.Items
    '        Dim tableField As String() = item.ToString.Split("."c)

    '        'Check to see if the table already exists
    '        If Not updateFields.ContainsKey(tableField(0)) Then
    '            'Add the table
    '            updateFields.Add(tableField(0), New List(Of String))
    '        End If

    '        'Add the field
    '        updateFields.Item(tableField(0)).Add(tableField(1))
    '    Next

    '    'Check each selected table for duplicates
    '    For Each table As String In updateFields.Keys
    '        duplicates = file.LoadToLiveDuplicateCheck(table, mTableMatchFields.Item(table), updateFields.Item(table))
    '    Next

    'End Function

#End Region

End Class
