Imports Nrc.SurveyPoint.Library

Public Class ExportNavigator
    'TP RO Export GroupCollection.
    Private mExportGroups As ExportGroupTreeCollection

    'Used for routing with context menu.
    Private mSelectedExportGroupID As Integer = 0
    Private mLoaded As Boolean

    Public Event ButtonClicked As EventHandler(Of ExportButtonClickedEventArgs)
    Public Event ExportGroupSelected As EventHandler(Of ExportGroupSelectedEventArgs)
    Public Event ShowModeChanged As EventHandler(Of ShowModeChangedEventArgs)

    Private Sub ConfigurationButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ConfigurationButton.Click

        Me.ExportGroupsGridView.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.CellFocus
        Me.ExportGroupsGridView.Appearance.FocusedCell.BackColor = Color.CornflowerBlue
        Me.ExportGroupsGridView.Appearance.FocusedCell.ForeColor = Color.White
        Me.ExportGroupGrid.Enabled = True

        RunButtonProcedure(ExportConfigurationButtonEnum.Configuration)
       
    End Sub

    Private Sub RunButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunButton.Click

        Me.ExportGroupsGridView.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.CellFocus
        Me.ExportGroupsGridView.Appearance.FocusedCell.BackColor = Color.CornflowerBlue
        Me.ExportGroupsGridView.Appearance.FocusedCell.ForeColor = Color.White
        Me.ExportGroupGrid.Enabled = True

        RunButtonProcedure(ExportConfigurationButtonEnum.Run)

    End Sub

    Private Sub LogButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LogButton.Click

        If Me.btnShowAll.Checked Then
            Me.ExportGroupsGridView.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.None
            Me.ExportGroupsGridView.Appearance.FocusedCell.BackColor = Color.White
            Me.ExportGroupsGridView.Appearance.FocusedCell.ForeColor = Color.Black
            Me.ExportGroupGrid.Enabled = False
        Else
            Me.ExportGroupsGridView.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.CellFocus
            Me.ExportGroupsGridView.Appearance.FocusedCell.BackColor = Color.CornflowerBlue
            Me.ExportGroupsGridView.Appearance.FocusedCell.ForeColor = Color.White
            Me.ExportGroupGrid.Enabled = True
        End If


        RunButtonProcedure(ExportConfigurationButtonEnum.ViewLog)

    End Sub

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mExportGroups = ExportGroupTree.GetAll
        Me.ExportGroupBindingSource.DataSource = mExportGroups

        ShowButtonsForMode(ExportConfigurationButtonEnum.Configuration)

       

    End Sub

    Private Sub ExportGroupGrid_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportGroupGrid.Click
        'Do nothing here.  This method is used to internally set focus to the selected row.
    End Sub

    ''' <summary>Selects an export group when the navigator first loads.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ClientExportNavigator_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Me.mLoaded = False Then
            Dim exportGroupItem As ExportGroupTree = ExportGroupTree.NewExportGroup            
            exportGroupItem = TryCast(ExportGroupBindingSource.Current, ExportGroupTree)
            If Not exportGroupItem Is Nothing Then
                RaiseEvent ExportGroupSelected(Me, New ExportGroupSelectedEventArgs(exportGroupItem.ExportGroupID, Me.btnShowSelected.Checked))
                Me.mLoaded = True
            End If
        End If
    End Sub

    Private Sub NewExportGroupButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewExportGroupButton.Click
        RaiseEvent ButtonClicked(Me, New ExportButtonClickedEventArgs(ExportConfigurationButtonEnum.NewExportGroup))
    End Sub

    Private Sub CopyExportGroupButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CopyExportGroupButton.Click
        CopyExportGroup()
    End Sub

    Private Sub CopyExportGroup()
        'Get the currently selected record
        Dim exportGroupItem As ExportGroupTree = ExportGroupTree.NewExportGroup
        exportGroupItem = TryCast(ExportGroupBindingSource.Current, ExportGroupTree)
        If Not exportGroupItem Is Nothing Then
            Dim copyDialog As New ExportGroupCopyDialog(exportGroupItem.Name)
            If copyDialog.ShowDialog() = DialogResult.OK Then
                Dim newExportName As String = copyDialog.NewExportName
                copyDialog.Close()
                'TODO:  Refresh export set with new group selected.
                Dim newExportID As Integer = ExportGroup.CopyExport(exportGroupItem.ExportGroupID, newExportName)
                ResetExportGroupList(newExportID)

            End If
        Else
            MessageBox.Show("You must first select an export group to copy.")
        End If
    End Sub

    ''' <summary>When a new group is saved or copied, this resets the navigator to the correct grid.</summary>
    ''' <param name="exportGroupID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub ResetExportGroupList(ByVal exportGroupID As Integer)
        mExportGroups = ExportGroupTree.GetAll
        Me.ExportGroupBindingSource.DataSource = mExportGroups
        If exportGroupID > 0 Then
            Dim i As Integer
            For i = 0 To Me.ExportGroupsGridView.RowCount - 1
                Dim handle As Integer
                handle = Me.ExportGroupsGridView.GetRowHandle(i)
                Dim exportGroup As ExportGroupTree = CType(Me.ExportGroupGrid.DefaultView.GetRow(handle), ExportGroupTree)
                If exportGroup.ExportGroupID = exportGroupID Then
                    'Me.ExportGroupsGridView.SelectRow(handle)
                    Me.ExportGroupsGridView.FocusedRowHandle = handle
                    'RaiseEvent ExportGroupSelected(Me, New ExportGroupSelectedEventArgs(exportGroupID))
                    Exit For
                End If
            Next
        End If
    End Sub

    ''' <summary>Deletes an existing export group (if no export is currently being
    ''' run)</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080507 - Tony Piccoli</term>
    ''' <description>Put in logic to handle if you have deleted the last export
    ''' group.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Sub DeleteExportGroup()
        Dim exportGroupItem As ExportGroupTree = ExportGroupTree.NewExportGroup
        exportGroupItem = TryCast(ExportGroupBindingSource.Current, ExportGroupTree)
        If Not exportGroupItem Is Nothing Then
            Dim msg As String = "Are you sure you want to delete '" & exportGroupItem.Name & " (" & exportGroupItem.ExportGroupID.ToString & ")'?"
            If MessageBox.Show(msg, "Export Group Deletion", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) = DialogResult.OK Then
                If ExportGroup.CheckForRunningExport() Then
                    MessageBox.Show("You may not delete this export group while an export is being run.")
                Else
                    ExportGroup.DeleteExportGroupAll(exportGroupItem.ExportGroupID)
                    Me.mExportGroups = ExportGroupTree.GetAll
                    Me.ExportGroupBindingSource.DataSource = Me.mExportGroups
                    'Get the currently selected record
                    exportGroupItem = ExportGroupTree.NewExportGroup
                    exportGroupItem = TryCast(ExportGroupBindingSource.Current, ExportGroupTree)
                    If Not exportGroupItem Is Nothing Then
                        RaiseEvent ExportGroupSelected(Me, New ExportGroupSelectedEventArgs(exportGroupItem.ExportGroupID))
                    Else
                        RaiseEvent ExportGroupSelected(Me, New ExportGroupSelectedEventArgs(0))
                    End If
                End If
            End If
        Else
            MessageBox.Show("You must first select an export group to delete.")
        End If
    End Sub

    Private Sub DeleteExportGroupButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteExportGroupButton.Click
        DeleteExportGroup()
    End Sub

    Private Sub btnShowAll_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnShowAll.Click

        ' Steve Kennedy - comment this code
        Me.btnShowSelected.Checked = Not Me.btnShowAll.Checked
        Me.ExportGroupsGridView.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.None
        Me.ExportGroupsGridView.Appearance.FocusedCell.BackColor = Color.White
        Me.ExportGroupsGridView.Appearance.FocusedCell.ForeColor = Color.Black
        Me.ExportGroupGrid.Enabled = False
    End Sub
    Private Sub btnShowSelected_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnShowSelected.Click

        ' Steve Kennedy - comment this code
        Me.btnShowAll.Checked = Not Me.btnShowSelected.Checked
        Me.ExportGroupsGridView.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.CellFocus
        Me.ExportGroupsGridView.Appearance.FocusedCell.BackColor = Color.CornflowerBlue
        Me.ExportGroupsGridView.Appearance.FocusedCell.ForeColor = Color.White
        Me.ExportGroupGrid.Enabled = True
    End Sub
    Private Sub btnShowSelected_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnShowSelected.CheckedChanged
        RaiseEvent ShowModeChanged(Me, New ShowModeChangedEventArgs(Me.btnShowSelected.Checked))
    End Sub

    Private Sub ExportGroupGrid_MouseClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles ExportGroupGrid.MouseClick


        'Need to call the click event first as it internally sets focus to the selected grid row.
        ExportGroupGrid_Click(sender, Nothing)
        If e.Button = Windows.Forms.MouseButtons.Right Then
            Dim exportGroupItem As ExportGroupTree = ExportGroupTree.NewExportGroup
            exportGroupItem = TryCast(ExportGroupBindingSource.Current, ExportGroupTree)
            'Only do if an export group exists.
            If Not exportGroupItem Is Nothing Then
                Me.mSelectedExportGroupID = exportGroupItem.ExportGroupID
                ConfigurationMenuStrip.Show(Me.ExportGroupGrid, e.Location)
            End If
        ElseIf e.Button = Windows.Forms.MouseButtons.Left Then
            'Get the currently selected record
            Dim exportGroupItem As ExportGroupTree = ExportGroupTree.NewExportGroup
            exportGroupItem = TryCast(ExportGroupBindingSource.Current, ExportGroupTree)
            'Only raise an event if the export group exists.
            If Not exportGroupItem Is Nothing Then
                RaiseEvent ExportGroupSelected(Me, New ExportGroupSelectedEventArgs(exportGroupItem.ExportGroupID, Me.btnShowSelected.Checked))
            End If
        End If
    End Sub

    Private Sub NewToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewToolStripMenuItem.Click
        RaiseEvent ButtonClicked(Me, New ExportButtonClickedEventArgs(ExportConfigurationButtonEnum.NewExportGroup))
    End Sub

    Private Sub CopyToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CopyToolStripMenuItem.Click
        CopyExportGroup()
    End Sub

    Private Sub DeleteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteToolStripMenuItem.Click
        DeleteExportGroup()
    End Sub

    Private Sub RunToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunToolStripMenuItem.Click
        RunButtonProcedure(ExportConfigurationButtonEnum.Run)
    End Sub

    Private Sub LogToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LogToolStripMenuItem.Click
        RunButtonProcedure(ExportConfigurationButtonEnum.ViewLog)
    End Sub

    Private Sub ShowButtonsForMode(ByVal screenMode As ExportConfigurationButtonEnum)

        'TODO: Steve Kennedy - Comment This Code

        Me.ConfigurationButton.Enabled = True
        Me.RunButton.Enabled = True
        Me.LogButton.Enabled = True

        Me.btnShowAll.Visible = False
        Me.btnShowSelected.Visible = False

        Me.CopyExportGroupButton.Visible = False
        Me.NewExportGroupButton.Visible = False
        Me.DeleteExportGroupButton.Visible = False

        ConfigurationMenuStrip.Items("NewToolStripMenuItem").Visible = False
        ConfigurationMenuStrip.Items("CopyToolStripMenuItem").Visible = False
        ConfigurationMenuStrip.Items("DeleteToolStripMenuItem").Visible = False
        ConfigurationMenuStrip.Items("ToolStripSeparator").Visible = False

        ConfigurationMenuStrip.Items("ConfigurationToolStripMenuItem").Enabled = False
        ConfigurationMenuStrip.Items("RunToolStripMenuItem").Enabled = False
        ConfigurationMenuStrip.Items("LogToolStripMenuItem").Enabled = False

        Select Case screenMode

            Case ExportConfigurationButtonEnum.Configuration
                Me.ConfigurationButton.Enabled = False
                Me.CopyExportGroupButton.Visible = True
                Me.NewExportGroupButton.Visible = True
                Me.DeleteExportGroupButton.Visible = True

                ConfigurationMenuStrip.Items("NewToolStripMenuItem").Visible = True
                ConfigurationMenuStrip.Items("CopyToolStripMenuItem").Visible = True
                ConfigurationMenuStrip.Items("DeleteToolStripMenuItem").Visible = True
                ConfigurationMenuStrip.Items("ToolStripSeparator").Visible = True

                ConfigurationMenuStrip.Items("RunToolStripMenuItem").Enabled = True
                ConfigurationMenuStrip.Items("LogToolStripMenuItem").Enabled = True

            Case ExportConfigurationButtonEnum.Run
                Me.RunButton.Enabled = False

                ConfigurationMenuStrip.Items("ConfigurationToolStripMenuItem").Enabled = True
                ConfigurationMenuStrip.Items("LogToolStripMenuItem").Enabled = True

            Case ExportConfigurationButtonEnum.ViewLog
                Me.LogButton.Enabled = False
                Me.btnShowAll.Visible = True
                Me.btnShowSelected.Visible = True

                ConfigurationMenuStrip.Items("ConfigurationToolStripMenuItem").Enabled = True
                ConfigurationMenuStrip.Items("RunToolStripMenuItem").Enabled = True

        End Select


    End Sub

    Friend Sub RunButtonProcedure(ByVal screenMode As ExportConfigurationButtonEnum)

        'TODO: Steve Kennedy comment this code


        'Grab the selected export group item from the tree
        Dim exportGroupItem As ExportGroupTree = ExportGroupTree.NewExportGroup
        exportGroupItem = TryCast(ExportGroupBindingSource.Current, ExportGroupTree)

        If Not exportGroupItem Is Nothing Then
            ShowButtonsForMode(screenMode)

            Select Case screenMode
                Case ExportConfigurationButtonEnum.Run
                    RaiseEvent ButtonClicked(Me, New ExportButtonClickedEventArgs(ExportConfigurationButtonEnum.Run, exportGroupItem.ExportGroupID))
                Case ExportConfigurationButtonEnum.Configuration
                    RaiseEvent ButtonClicked(Me, New ExportButtonClickedEventArgs(ExportConfigurationButtonEnum.Configuration, exportGroupItem.ExportGroupID))
                Case ExportConfigurationButtonEnum.ViewLog
                    RaiseEvent ButtonClicked(Me, New ExportButtonClickedEventArgs(ExportConfigurationButtonEnum.ViewLog, exportGroupItem.ExportGroupID))
            End Select
        Else
            If screenMode = ExportConfigurationButtonEnum.Run OrElse screenMode = ExportConfigurationButtonEnum.ViewLog Then
                MessageBox.Show("You must first select an export group.")
            End If
        End If

    End Sub


    Friend Overloads Sub ReRunButtonProcedure(ByVal screenMode As ExportConfigurationButtonEnum, ByVal startDate As Nullable(Of Date), ByVal endDate As Nullable(Of Date), ByVal isSubmitted As Boolean)

        'TODO: Steve Kennedy comment this code

        'Grab the selected export group item from the tree
        Dim exportGroupItem As ExportGroupTree = ExportGroupTree.NewExportGroup
        exportGroupItem = TryCast(ExportGroupBindingSource.Current, ExportGroupTree)

        If Not exportGroupItem Is Nothing Then
            ShowButtonsForMode(screenMode)
            RaiseEvent ButtonClicked(Me, New ExportButtonClickedEventArgs(ExportConfigurationButtonEnum.ReRun, exportGroupItem.ExportGroupID, startDate, endDate, isSubmitted))
        End If

    End Sub



    Friend Overloads Sub ReRunButtonProcedure(ByVal logfile As ExportFileLog)

        'Grab the selected export group item from the tree
        Dim exportGroupItem As ExportGroupTree = ExportGroupTree.NewExportGroup
        exportGroupItem = TryCast(ExportGroupBindingSource.Current, ExportGroupTree)

        If Not exportGroupItem Is Nothing Then
            RunButtonProcedure(ExportConfigurationButtonEnum.Run)
            RaiseEvent ButtonClicked(Me, New ExportButtonClickedEventArgs(logfile.ExportLogFileID))
        End If

    End Sub

    Private Sub ExportGroupBindingSource_CurrentChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportGroupBindingSource.CurrentChanged
        If Me.btnShowSelected.Checked Then
            Dim exportGroupItem As ExportGroupTree = ExportGroupTree.NewExportGroup
            exportGroupItem = TryCast(ExportGroupBindingSource.Current, ExportGroupTree)
            If Not exportGroupItem Is Nothing Then
                RaiseEvent ExportGroupSelected(Me, New ExportGroupSelectedEventArgs(exportGroupItem.ExportGroupID))
            End If
        End If
    End Sub

    Private Sub ConfigurationToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ConfigurationToolStripMenuItem.Click
        RunButtonProcedure(ExportConfigurationButtonEnum.Configuration)
    End Sub

End Class
