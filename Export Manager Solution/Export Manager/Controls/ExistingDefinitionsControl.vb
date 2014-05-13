Imports Nrc.DataMart.Library
Imports System.ComponentModel
Imports Nrc.Framework.BusinessLogic.Configuration

''' <summary>This control show a data grid housing all exported definitions for a survey.  The user may delete, schedule for export, direct export, or view a history of exports for an export definition from here.</summary>
''' <CreateBy>Jeff Fleming</CreateBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExistingDefinitionsControl

    Private mShowUnitColumn As Boolean
    Private mShowStartDateColumn As Boolean = True
    Private mShowEndDateColumn As Boolean = True
    Private mShowStartMonthColumn As Boolean
    Private mShowCutoffFieldColumn As Boolean = True
    Private mExportSetType As ExportSetType
    Private WithEvents mNavigator As ClientStudySurveyNavigator
    Private mNewId As Integer = 0
    Private Property ORYXQueue() As Collection(Of ExportSet)
        Get
            If mORYXQueue Is Nothing Then
                mORYXQueue = New Collection(Of ExportSet)
            End If
            Return mORYXQueue
        End Get
        Set(ByVal value As Collection(Of ExportSet))
            mORYXQueue = value
        End Set
    End Property
    Private mORYXQueue As Collection(Of ExportSet)

#Region " Public Properties "
    ''' <summary>This property Links this control with a navigator control.  This allows the control to change when the user navigates to another survey.</summary>
    ''' <value>The navigator control associated with this control.</value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    <Browsable(False)> _
    Public Property Navigator() As ClientStudySurveyNavigator
        Get
            Return mNavigator
        End Get
        Set(ByVal value As ClientStudySurveyNavigator)
            mNavigator = value
        End Set
    End Property
    ''' <summary>Unit columns are specific to HCAHPS and show when the HCAHPS tab is selected.</summary>
    ''' <value>Boolean</value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    <Browsable(True)> _
    Public Property ShowUnitColumn() As Boolean
        Get
            Return mShowUnitColumn
        End Get
        Set(ByVal value As Boolean)
            mShowUnitColumn = value
            Me.InitializeColumnVisibility()
        End Set
    End Property
    Public Property ShowStartDateColumn() As Boolean
        Get
            Return mShowStartDateColumn
        End Get
        Set(ByVal value As Boolean)
            mShowStartDateColumn = value
            Me.InitializeColumnVisibility()
        End Set
    End Property
    Public Property ShowEndDateColumn() As Boolean
        Get
            Return mShowEndDateColumn
        End Get
        Set(ByVal value As Boolean)
            mShowEndDateColumn = value
            Me.InitializeColumnVisibility()
        End Set
    End Property
    Public Property ShowStartMonthColumn() As Boolean
        Get
            Return mShowStartMonthColumn
        End Get
        Set(ByVal value As Boolean)
            mShowStartMonthColumn = value
            Me.InitializeColumnVisibility()
        End Set
    End Property
    Public Property ShowCutoffFieldColumn() As Boolean
        Get
            Return mShowCutoffFieldColumn
        End Get
        Set(ByVal value As Boolean)
            mShowCutoffFieldColumn = value
            Me.InitializeColumnVisibility()
        End Set
    End Property

    <Browsable(False)> _
    Public Property ExportSetType() As ExportSetType
        Get
            Return mExportSetType
        End Get
        Set(ByVal value As ExportSetType)
            mExportSetType = value
        End Set
    End Property

#End Region

#Region " Constructors "
    Public Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.InitializeColumnVisibility()
    End Sub
#End Region

#Region " Private Properties "
    ''' <summary>Loops through the datagrid and adds each record selected to a generic export set collection.</summary>
    ''' <value>Collection of ExportSet objects</value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property SelectedExportSets() As Collection(Of ExportSet)
        Get
            Dim sets As New Collection(Of ExportSet)
            For Each row As DataGridViewRow In Me.ExistingExportsGrid.SelectedRows
                Dim export As ExportSet = TryCast(row.Tag, ExportSet)
                If export IsNot Nothing Then
                    sets.Add(export)
                End If
            Next

            Return sets
        End Get
    End Property

    ''' <summary>Only enable the delete button if a record in the data grid is selected.</summary>
    ''' <value>Boolean</value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property IsDeleteButtonEnabled() As Boolean
        Get
            If Me.ExistingExportsGrid.SelectedRows.Count = 0 Then
                Return False
            End If

            Return True

        End Get
    End Property

    ''' <summary>Only enable a rebuild if at least one record has been selected.</summary>
    ''' <value>Boolean</value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property IsRebuildButtonEnabled() As Boolean
        Get
            If Me.ExistingExportsGrid.SelectedRows.Count = 0 Then
                Return False
            End If

            Return True

        End Get
    End Property

    ''' <summary>Only enable the export button if at least one record has been selected.</summary>
    ''' <value></value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property IsExportButtonEnabled() As Boolean
        Get
            If Me.ExistingExportsGrid.SelectedRows.Count = 0 Then
                Return False
            End If

            Return True
        End Get
    End Property

    ''' <summary>Checks that at least one definition record has been selected.</summary>
    ''' <value>Boolean</value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property IsExportIndividualButtonEnabled() As Boolean
        Get
            Return Me.IsExportButtonEnabled
        End Get
    End Property

    ''' <summary>Check that at least 2 definition records have been selected.</summary>
    ''' <value>boolean</value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property IsExportCombinedButtonEnabled() As Boolean
        Get
            If Me.ExistingExportsGrid.SelectedRows.Count < 2 Then
                Return False
            End If

            Return True
        End Get
    End Property

    ''' <summary>You must have 1 and only 1 defintion record selected to view its history.</summary>
    ''' <value>boolean</value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property IsHistoryButtonEnabled() As Boolean
        Get
            If Me.ExistingExportsGrid.SelectedRows.Count <> 1 Then
                Return False
            End If

            Return True
        End Get
    End Property
#End Region

#Region " Event Handlers "

    ''' <summary>Control load event that initalized filter date values.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExistingDefinitionsControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Initialize the filter date range
        'Default to last year
        Me.FilterEndDate.Value = Date.Parse(String.Format("{0}/{1}/{2}", Date.Now.Month, Date.Now.Day, Date.Now.Year))
        Me.FilterStartDate.Value = Me.FilterEndDate.Value.AddYears(-1)
    End Sub

    ''' <summary>Events handler that tells the control when the client, study, or survey has changed in then navigator.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub mNavigator_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mNavigator.SelectionChanged
        Me.PopulateExportList()
    End Sub

    Private Sub FilterDate_KeyUp(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles FilterStartDate.KeyUp, FilterEndDate.KeyUp
        If e.KeyCode = Keys.Enter Then
            Me.PopulateExportList()
            Me.EnableExportSetToolStripButtons()
        End If
    End Sub

    ''' <summary>Event handler for the delete button click</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub DeleteButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteButton.Click
        Me.DeleteCommand()
    End Sub

    ''' <summary>Event handler for the filter button click</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub FilterButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FilterButton.Click
        Me.FilterStartDate.Focus()
        Me.FilterEndDate.Focus()
        Me.PopulateExportList()
        Me.EnableExportSetToolStripButtons()
    End Sub

    ''' <summary>When user right clicks a row, if not selected, then deselect other rows before selecting.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExistingExportsGrid_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles ExistingExportsGrid.MouseDown
        'Need to do some special handling when user right-clicks the datagridview
        If e.Button = Windows.Forms.MouseButtons.Right Then
            Dim hitInfo As DataGridView.HitTestInfo
            hitInfo = Me.ExistingExportsGrid.HitTest(e.X, e.Y)
            If hitInfo.Type = DataGridViewHitTestType.Cell Then
                Dim row As DataGridViewRow = Me.ExistingExportsGrid.Rows(hitInfo.RowIndex)
                If Not row.Selected Then
                    If (Control.ModifierKeys And Keys.Control) = Keys.Control Then
                        row.Selected = True
                    Else
                        Me.DeselectAllRows()
                        row.Selected = True
                    End If
                End If
            End If
        End If
    End Sub

    ''' <summary>event handler for data grid selection changes.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExistingExportsGrid_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ExistingExportsGrid.SelectionChanged
        Me.EnableExportSetToolStripButtons()
    End Sub

    ''' <summary>Evenet handler for history menu item.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ShowHistoryMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ShowHistoryMenuItem.Click
        Me.ShowHistoryCommand()
    End Sub

    ''' <summary>Event handler for Export button click</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportButton_ButtonClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportButton.ButtonClick
        Me.ExportButton.ShowDropDown()
    End Sub

    ''' <summary>Event handler for individual export button click</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportIndividualButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportIndividualButton.Click
        Me.ExportIndividualCommand(False)
    End Sub

    ''' <summary>Event handler for combined export button click</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportCombinedButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportCombinedButton.Click
        Me.ExportCombinedCommand(False)
    End Sub

    ''' <summary>Evenet handler for individual shedule button click</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ScheduleIndividualButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ScheduleIndividualButton.Click
        Me.ExportIndividualCommand(True)
    End Sub

    ''' <summary>Event handler for combined shedule button click.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ScheduleCombinedButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ScheduleCombinedButton.Click
        Me.ExportCombinedCommand(True)
    End Sub

    ''' <summary>Evenet handler for show history button click.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ShowHistoryButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ShowHistoryButton.Click
        Me.ShowHistoryCommand()
    End Sub

    ''' <summary>Event handler for delete button click</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub DeleteMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteMenuItem.Click
        Me.DeleteCommand()
    End Sub

    ''' <summary>Event handler for export individual menu item click.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportIndividualMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportIndividualMenuItem.Click
        Me.ExportIndividualCommand(False)
    End Sub

    ''' <summary>Event handler for combined export menu item click</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportCombinedMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportCombinedMenuItem.Click
        Me.ExportCombinedCommand(False)
    End Sub

    ''' <summary>Event handler for scheduled individual menu item click.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ScheduleIndividualMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ScheduleIndividualMenuItem.Click
        Me.ExportIndividualCommand(True)
    End Sub

    ''' <summary>Event handler for sheduled combined menu item click</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ScheduleCombinedMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ScheduleCombinedMenuItem.Click
        Me.ExportCombinedCommand(True)
    End Sub
#End Region

#Region " Public Methods "
    ''' <summary>Calls the method to re populate the export list (data grid)</summary>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub RefreshExportList()
        Me.PopulateExportList()
    End Sub

    ''' <summary>Checks a collection of export sets against the list currently in the data grid and selects the matches.</summary>
    ''' <param name="exportSets"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <remarks>Currently ussed when the user creates a new definition (export set), it populates and highlights the newly create export set in the data grid.</remarks>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub SelectExportSets(ByVal exportSets As Collection(Of ExportSet))
        'Get a list of the selected ids
        Dim selectedIds As New List(Of Integer)
        For Each es As ExportSet In exportSets
            selectedIds.Add(es.Id)
        Next

        'Select each row that is in the list of ids 
        For Each row As DataGridViewRow In Me.ExistingExportsGrid.Rows
            Dim export As ExportSet = TryCast(row.Tag, ExportSet)
            If export IsNot Nothing AndAlso selectedIds.Contains(export.Id) Then
                row.Selected = True
            Else
                row.Selected = False
            End If
        Next
    End Sub

    ''' <summary>Calls the method to export, with parameter letting the method no it is not to be scheduled.</summary>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub ExportSelectedSetsToIndividualFiles()
        Me.ExportIndividualCommand(False)
    End Sub

    ''' <summary>Calls the method to export combined, with parameter letting the method no it is not to be scheduled.</summary>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub ExportSelectedSetsToCombinedFile()
        Me.ExportCombinedCommand(False)
    End Sub
#End Region

#Region " Private Methods "
    ''' <summary>Initialilzes the existing exports grid columns. checked for column visibility and auto sizing.</summary>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub InitializeColumnVisibility()
        'Set column visibility
        Me.UnitDgColumn.Visible = mShowUnitColumn
        Me.StartDateDgColumn.Visible = mShowStartDateColumn
        Me.EndDateDgColumn.Visible = mShowEndDateColumn
        Me.StartMonthDgColumn.Visible = mShowStartMonthColumn
        Me.CutoffFieldDgColumn.Visible = mShowCutoffFieldColumn

        'Set all columns to autosize to "All Cells"
        Me.UnitDgColumn.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells
        Me.StartDateDgColumn.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells
        Me.EndDateDgColumn.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells
        Me.StartMonthDgColumn.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells
        Me.CutoffFieldDgColumn.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells

        'Determine which column should be set to "Fill" mode
        If mShowCutoffFieldColumn Then
            Me.CutoffFieldDgColumn.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
        ElseIf mShowStartMonthColumn Then
            Me.StartMonthDgColumn.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
        ElseIf mShowEndDateColumn Then
            Me.EndDateDgColumn.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
        ElseIf mShowStartDateColumn Then
            Me.StartMonthDgColumn.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
        Else
            Me.CreationDateDgColumn.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
        End If
    End Sub

    ''' <summary>Clears and call method to re-populates the existing export grid from seletec client, study, survey values.</summary>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <remarks>Currently, these values are derived from the navigator control.</remarks>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub PopulateExportList()
        Me.ExistingExportsGrid.Rows.Clear()

        Dim masterList As Collection(Of ExportSet)
        Dim clients As Collection(Of Client) = Me.mNavigator.SelectedClients
        Dim studies As Collection(Of Study) = Me.mNavigator.SelectedStudies
        Dim surveys As Collection(Of Survey) = Me.mNavigator.SelectedSurveys
        Dim units As Collection(Of SampleUnit) = Me.mNavigator.SelectedUnits
        masterList = ExportSet.GetExportSets(clients, studies, surveys, units, Me.FilterStartDate.Value, Me.FilterEndDate.Value, mExportSetType)

        Me.FillExportSetList(masterList)
        'Me.ExistingExportsGrid.Sort()
    End Sub

    ''' <summary>Populates the existing export grid based on passed in collection of export sets.  Also, assigns context menu to each row.</summary>
    ''' <param name="exports"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub FillExportSetList(ByVal exports As Collection(Of ExportSet))
        Dim items(9) As String
        Dim srvy As Survey
        Dim unit As SampleUnit
        Dim newIndex As Integer

        For Each export As ExportSet In exports
            srvy = Me.mNavigator.FindSurvey(export.SurveyId)
            unit = Me.mNavigator.FindUnit(export.SampleUnitId)
            items(0) = srvy.Study.Client.DisplayLabel
            items(1) = srvy.Study.DisplayLabel
            items(2) = srvy.DisplayLabel
            If unit IsNot Nothing Then
                items(3) = unit.DisplayLabel
            Else
                items(3) = ""
            End If
            items(4) = export.Name
            items(5) = export.CreatedDate.ToString
            items(6) = export.StartDate.ToShortDateString
            items(7) = export.EndDate.ToShortDateString
            items(8) = export.StartDate.ToString("MMMM yyyy")
            items(9) = export.ReportDateField

            newIndex = Me.ExistingExportsGrid.Rows.Add(items)
            Me.ExistingExportsGrid.Rows(newIndex).Tag = export
            Me.ExistingExportsGrid.Rows(newIndex).ContextMenuStrip = Me.ExportSetsContextMenu
        Next
    End Sub

    ''' <summary>Finds the current quarter month from the current date.</summary>
    ''' <returns>A date in the format of quarterMonth/1/quarterYear</returns>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function GetLastQuarterStartDate() As Date
        Dim qtrStart As Date = Date.Now
        qtrStart = qtrStart.AddMonths(-3)
        Dim qtrMonth As Integer = CType(Math.Ceiling(qtrStart.Month / 3), Integer)
        qtrMonth = (qtrMonth * 3) - 2

        Return Date.Parse(String.Format("{0}/1/{1}", qtrMonth, qtrStart.Year))
    End Function

    ''' <summary>
    ''' The configuration file for the user inteface will define two restrictions on how many exports can be combined together.
    ''' This method will evaluate a set of exports and determine if they meet the rules of eligibility for a combined export.
    ''' </summary>
    ''' <param name="exportList">The list of export to check</param>
    ''' <param name="errorMessage">A ByRef string that will contain the error message if the function returns false</param>
    ''' <returns>Returns True if the exports can be combined together otherwise returns False.</returns>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function AllowCombinedExport(ByVal exportList As Collection(Of ExportSet), ByRef errorMessage As String) As Boolean
        'Check to total export count
        If exportList.Count > AppConfig.Params("EMMaxExportCombinationCount").IntegerValue Then
            errorMessage = String.Format("You cannot combine more than {0} export definitions into one file.", AppConfig.Params("EMMaxExportCombinationCount").IntegerValue)
            Return False
        End If

        'Check the date range covered by the set
        Dim minStartDate As Date = Date.MaxValue
        Dim maxEndDate As Date = Date.MinValue
        For Each export As ExportSet In exportList
            If export.StartDate < minStartDate Then
                minStartDate = export.StartDate
            End If
            If export.EndDate > maxEndDate Then
                maxEndDate = export.EndDate
            End If
        Next
        Dim diff As TimeSpan = maxEndDate.Subtract(minStartDate)

        'If the date range is too many years than don't allow combination
        If diff.Days > (AppConfig.Params("EMMaxExportCombinationYearDifference").IntegerValue * 365) Then
            errorMessage = String.Format("You cannot combine export definitions into one file if their total date range covers more than {0} year(s).", AppConfig.Params("EMMaxExportCombinationYearDifference").IntegerValue)
            Return False
        End If

        'Verify that the export sets are compatible
        If Not ExportSet.AllowCombinedExport(exportList, errorMessage) Then
            Return False
        End If

        'Must be okay to combine
        Return True
    End Function

    ''' <summary>Evaluates whether a single file (export) or multiple (export list) can be individually exported.</summary>
    ''' <param name="exportList">The list of export to check</param>
    ''' <param name="errorMessage">A ByRef string that will contain the error message if the function returns false</param>
    ''' <param name="warningMessage">A byRef string that will contain a warning message if needed.</param>
    ''' <returns>Returns true if the file(s) can be exported individually.</returns>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <remarks>Currently the waring message is never set.</remarks>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function AllowIndividualExport(ByVal exportList As Collection(Of ExportSet), ByRef errorMessage As String, ByRef warningMessage As String) As Boolean
        errorMessage = ""
        warningMessage = ""

        'Keeps track of when we switch to a different medicare number
        Dim isCheckingNewMedicareNumber As Boolean = True

        If Me.mExportSetType = Library.ExportSetType.CmsChart OrElse Me.mExportSetType = Library.ExportSetType.CmsHHcahps OrElse Me.mExportSetType = Library.ExportSetType.CmsHcahps Then
            'Check to see if any of the selected sets contain the same medicare number
            For i As Integer = exportList.Count - 1 To 0 Step -1
                Dim unit As SampleUnit
                unit = SampleUnit.Get(exportList(i).SampleUnitId)
                'Loop through all other exportsets to see if any others have the same medicare number
                For j As Integer = i - 1 To 0 Step -1
                    Dim checkUnit As SampleUnit = SampleUnit.Get(exportList(j).SampleUnitId)
                    'If the units are different and share the same medicare number, then they
                    'shouldn't be exported to individual files
                    If unit.Id <> checkUnit.Id AndAlso unit.MedicareNumber = checkUnit.MedicareNumber AndAlso exportList(j).StartDate = exportList(i).StartDate AndAlso exportList(j).EndDate = exportList(i).EndDate Then
                        If isCheckingNewMedicareNumber Then
                            If Not String.IsNullOrEmpty(errorMessage) Then errorMessage += vbCrLf & vbCrLf
                            errorMessage += "The medicare number '" & unit.MedicareNumber & _
                            "' assigned to sample unit " & unit.DisplayLabel & " (export set name: " & exportList(i).Name & ") is also assigned to other HCAHPS units for the month of " & exportList(j).StartDate.ToString("MMMM") & ".  " & _
                            "Please select export definitions from all units and create a combined file." & _
                            " Other export definitions for the month of " & exportList(j).StartDate.ToString("MMMM") & " for medicare number '" & unit.MedicareNumber & "' are listed below."

                        End If

                        'Dim unitSurvey As Survey = Survey.GetSurvey(checkUnit.SurveyId)
                        'Dim unitStudy As Study = unitSurvey.Study
                        'Dim unitClient As Client = unitStudy.Client

                        'errorMessage += vbCrLf + "Month:" + exportList(j).StartDate.ToString("MMMM") + " Client:" + unitClient.DisplayLabel + " Study:" + unitStudy.DisplayLabel + " Survey:" + unitSurvey.DisplayLabel + " Unit:" + checkUnit.DisplayLabel
                        errorMessage += vbCrLf & vbTab & "sample unit: " & checkUnit.DisplayLabel & " export set name: " & exportList(j).Name
                        'Remove the unit from the list so it isn't checked again.
                        exportList.RemoveAt(j)
                        'Decrement the indicator since we removed 1 item from the list
                        i -= 1
                        isCheckingNewMedicareNumber = False
                    End If
                Next
                isCheckingNewMedicareNumber = True
            Next

            If Not String.IsNullOrEmpty(errorMessage) Then Return False
        End If

        'For each set, see if it is valid to export it by itself
        For Each export As ExportSet In exportList
            Dim errMsg As String = ""

            If Not export.AllowIndividualExport(errMsg) Then
                errorMessage = errMsg
                Return False

            End If
        Next

        Return True
    End Function

    ''' <summary>Enables and Disables tool strip buttons based on control properties that hold the logic for each button.</summary>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub EnableExportSetToolStripButtons()
        Me.DeleteButton.Enabled = Me.IsDeleteButtonEnabled
        Me.DeleteMenuItem.Enabled = Me.IsDeleteButtonEnabled

        Me.ExportButton.Enabled = Me.IsExportButtonEnabled

        Me.ExportIndividualButton.Enabled = Me.IsExportIndividualButtonEnabled
        Me.ExportIndividualMenuItem.Enabled = Me.IsExportButtonEnabled

        Me.ExportCombinedButton.Enabled = Me.IsExportCombinedButtonEnabled
        Me.ExportCombinedMenuItem.Enabled = Me.IsExportCombinedButtonEnabled

        Me.ScheduleButton.Enabled = Me.IsExportButtonEnabled

        Me.ScheduleIndividualButton.Enabled = Me.IsExportIndividualButtonEnabled
        Me.ScheduleIndividualMenuItem.Enabled = Me.IsExportIndividualButtonEnabled

        Me.ScheduleCombinedButton.Enabled = Me.IsExportCombinedButtonEnabled
        Me.ScheduleCombinedMenuItem.Enabled = Me.IsExportCombinedButtonEnabled

        Me.ShowHistoryButton.Enabled = Me.IsHistoryButtonEnabled
        Me.ShowHistoryMenuItem.Enabled = Me.IsHistoryButtonEnabled
    End Sub

    ''' <summary>Deletes the selected list of exports and repopulates the export list (data grid).</summary>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub DeleteCommand()
        Dim finalErrorMessage As String = ""

        Try
            Dim msg As String = Me.ExistingExportsGrid.SelectedRows.Count & " export definition(s) will be deleted.  Are you sure you want to continue?"
            If MessageBox.Show(msg, "Confirm Delete?", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) = DialogResult.OK Then
                Me.ParentForm.Cursor = Cursors.WaitCursor

                For Each export As ExportSet In Me.SelectedExportSets
                    'Try to delete each one and capture a big error message if any fail
                    Dim errorMessage As String = ""
                    If Not export.Delete(CurrentUser.UserName, errorMessage) Then
                        finalErrorMessage &= export.Name & ": " & errorMessage & vbCrLf
                    End If
                Next

                Me.PopulateExportList()
                Me.EnableExportSetToolStripButtons()
            End If
        Finally
            Me.ParentForm.Cursor = Cursors.Default

            'If there were errors while deleting then show the message...
            If finalErrorMessage.Length > 0 Then
                MessageBox.Show(finalErrorMessage, "Error deleting export definition", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
        End Try
    End Sub

    ''' <summary>
    ''' This method presents a option to the user to override the requirement for creating a CMS export file 
    ''' when all the sample units of the same Medicare ID are not selected. 
    ''' The override of this requirement is capture in the log file. 
    ''' </summary>
    ''' <param name="scheduleForExport"></param>
    ''' <remarks></remarks>
    Private Sub ExportIndividualCommand(ByVal scheduleForExport As Boolean)
        Dim errorMessage As String = ""
        Dim warningMessage As String = ""
        Dim ExportIndividualFilesErrorDialog As New ExportIndividualFilesErrorDialog(errorMessage, Me.SelectedExportSets, False, scheduleForExport)

        If Not Me.AllowIndividualExport(Me.SelectedExportSets, errorMessage, warningMessage) Then
            ExportIndividualFilesErrorDialog = New ExportIndividualFilesErrorDialog(errorMessage, Me.SelectedExportSets, False, scheduleForExport)
            ExportIndividualFilesErrorDialog.ShowDialog()
        End If

        If Not ExportIndividualFilesErrorDialog.DialogResult = Windows.Forms.DialogResult.OK Then
            If Not String.IsNullOrEmpty(warningMessage) Then
                If MessageBox.Show(warningMessage & vbCrLf & "Do you wish to continue?", "Confirm Export File Creation", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) _
                    = DialogResult.Cancel Then
                    Exit Sub
                End If
            End If

            If Me.SelectedExportSets.Count > 1 Then
                If MainForm.CmsDefinitionTab.IsActive = True OrElse MainForm.CHARTExportsTab.IsActive = True Then
                    Dim dialog As New ExportManyFilesDialog(Me.SelectedExportSets, scheduleForExport)
                    dialog.ShowDialog()
                    mNewId = dialog.GetNewId()
                Else
                    Dim dialog As New ExportManyFilesDialog(Me.SelectedExportSets, scheduleForExport)
                    dialog.ShowDialog()
                    mNewId = dialog.GetNewId()
                End If
            Else
                If MainForm.CmsDefinitionTab.IsActive = True OrElse MainForm.CHARTExportsTab.IsActive = True Then
                    Dim FileName As String = GetExportFileName(Me.SelectedExportSets(0))
                    If ExportIndividualFilesErrorDialog.DialogResult = DialogResult.Yes Then
                        Dim sampUnitId As Integer = Me.SelectedExportSets(0).SampleUnitId
                        FileName = FileName & "_" & sampUnitId
                    End If
                    Dim dialog As New ExportSingleFileDialog(Me.SelectedExportSets, FileName, scheduleForExport)
                    dialog.ShowDialog()
                    mNewId = dialog.GetNewId()
                Else
                    Dim dialog As New ExportSingleFileDialog(Me.SelectedExportSets, "", scheduleForExport)
                    dialog.ShowDialog()
                    mNewId = dialog.GetNewId()
                End If
            End If
        End If
        If mNewId <> 0 AndAlso (ExportIndividualFilesErrorDialog.DialogResult = Windows.Forms.DialogResult.Yes OrElse Not Environment.UserInteractive) Then
            errorMessage = " Multiple Medicare Numbers encountered.  Overridden."
            DataProvider.Instance.UpdateExportFileErrorMessage(mNewId, errorMessage)
            errorMessage = ""
        End If
    End Sub

    ''' <summary>This method creates a unique file name based on team number, medicare
    ''' name-number, create date for exported documents.</summary>
    ''' <param name="IndividualExportSet"></param>
    ''' <returns>The file name for an exported document</returns>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20071203 - TP</term>
    ''' <description>Made the method static and overloaded so that it can be called from
    ''' other custom controls in the section.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Shared Function GetExportFileName(ByVal IndividualExportSet As ExportSet) As String
        Return GetExportFileName(IndividualExportSet, "")
    End Function

    ''' <summary>This method creates a unique file name based on team number, medicare
    ''' name-number, create date for exported documents.</summary>
    ''' <param name="IndividualExportSet"></param>
    ''' <returns>The file name for an exported document</returns>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20071203 - TP</term>
    ''' <description>Made the method static and overloaded so that it can be called from
    ''' other custom controls in the section.</description></item>
    ''' <item>
    ''' <term>20071229 - TP</term>
    ''' <description>Clean the file name of invalid chars before returning.  This avoids invalid file names.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Shared Function GetExportFileName(ByVal IndividualExportSet As ExportSet, ByVal pstrTeamNumber As String) As String
        Dim sampUnitId As Integer = IndividualExportSet.SampleUnitId
        Dim sampUnit As SampleUnit
        sampUnit = SampleUnit.Get(sampUnitId)
        'TP 20071219
        Dim medicareName As String
        If sampUnit.MedicareName.Length > 20 Then
            medicareName = sampUnit.MedicareName.Substring(0, 20)
        Else
            medicareName = sampUnit.MedicareName
        End If
        Dim exportFileName As String = pstrTeamNumber & "_" & medicareName & "_" & sampUnit.MedicareNumber & "_" & IndividualExportSet.StartDate.Year.ToString & "_" & IndividualExportSet.StartDate.Month.ToString.PadLeft(2, "0"c)
        'Dim exportFileName As String = pstrTeamNumber & "_" & sampUnit.MedicareName & "_" & sampUnit.MedicareNumber & "_" & IndividualExportSet.StartDate.Year.ToString & "_" & IndividualExportSet.StartDate.Month.ToString.PadLeft(2, "0"c)
        'Return exportFileName
        'TP 20071229
        Return Nrc.Framework.IO.Path.CleanFileName(exportFileName)
    End Function

    'Public Shared Function GetExportFileName(ByVal IndividualExportSets As Collection(Of ExportSet), ByVal pstrTeamNumber As String) As String        
    '    Dim sampUnitId As Integer = IndividualExportSets.Item(0).SampleUnitId
    '    Dim sampUnit As SampleUnit
    '    sampUnit = SampleUnit.Get(sampUnitId)
    '    Dim exportFileName As String = pstrTeamNumber & "_" & sampUnit.MedicareName & "_" & sampUnit.MedicareNumber & "_" & IndividualExportSets.Item(0).StartDate.Year.ToString & "_" & IndividualExportSets.Item(0).StartDate.Month.ToString
    '    Return exportFileName
    'End Function
    ''' <summary>
    ''' Check to see if the exportsets selected are from more than 1 study
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function MultipleStudyVerification() As Boolean
        Dim initialStudyId As Integer = 0
        If Me.SelectedExportSets.Count > 0 Then initialStudyId = Survey.GetSurvey(Me.SelectedExportSets(0).SurveyId).StudyId
        For Each es As ExportSet In Me.SelectedExportSets
            If initialStudyId <> Survey.GetSurvey(es.SurveyId).StudyId Then
                Return True
            End If
        Next
        Return False
    End Function

    Private Sub ExportCombinedCommand(ByVal scheduleForExport As Boolean)
        Dim errorMessage As String = ""
        If Me.AllowCombinedExport(Me.SelectedExportSets, errorMessage) Then
            If MultipleStudyVerification() Then
                If MessageBox.Show("You are trying to combine exports from multiple studies.  Are you sure you want to do this?", "Exporting From Multiple Studies", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) = DialogResult.Yes Then
                Else
                    Exit Sub
                End If
            End If
            If MainForm.CmsDefinitionTab.IsActive = True OrElse MainForm.CHARTExportsTab.IsActive = True Then
                Dim dialog As New ExportSingleFileDialog(Me.SelectedExportSets, GetExportFileName(Me.SelectedExportSets(0)), scheduleForExport)
                dialog.ShowDialog()
            Else
                Dim dialog As New ExportSingleFileDialog(Me.SelectedExportSets, "", scheduleForExport)
                dialog.ShowDialog()
            End If
        Else

            'MessageBox.Show(errorMessage, "Export Combination Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Dim ExportIndividualFilesErrorDialog As New ExportIndividualFilesErrorDialog(errorMessage, Me.SelectedExportSets, True, scheduleForExport)
            ExportIndividualFilesErrorDialog.ShowDialog()


        End If
    End Sub

    Private Sub ShowHistoryCommand()
        Dim es As ExportSet = DirectCast(Me.ExistingExportsGrid.SelectedRows(0).Tag, ExportSet)
        Dim historyDialog As New ExportHistoryDialog(es)
        historyDialog.ShowDialog()
    End Sub

    Private Sub DeselectAllRows()
        Dim rowList As New List(Of DataGridViewRow)
        For Each row As DataGridViewRow In Me.ExistingExportsGrid.SelectedRows
            rowList.Add(row)
        Next
        For Each row As DataGridViewRow In rowList
            row.Selected = False
        Next
    End Sub
#End Region

    Private Sub ExportORYXData_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportORYXDataToolStripMenuItem.Click, ExportOryxDataToolStripMenuItem2.Click
        Dim dlg As New ExportOryxDialog(SelectedExportSets)
        dlg.ShowDialog()
    End Sub

    Private Sub ExportQueuedORYXData_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportQueuedORYXDataToolStripMenuItem.Click
        ExportQueuedData()
    End Sub
    Private Sub ExportQueuedORYXDataToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportQueuedORYXDataToolStripMenuItem1.Click
        ExportQueuedData()
    End Sub
    Private Sub ExportQueuedData()
        Dim dlg As New ExportOryxDialog(ORYXQueue)
        Dim result As DialogResult = dlg.ShowDialog()
        If result = DialogResult.OK Or result = DialogResult.Abort Then
            ORYXQueue.Clear()
        End If
    End Sub
    Private Sub QueueOryxSelection()
        For Each x As ExportSet In SelectedExportSets
            If Not ORYXQueue.Contains(x) Then
                ORYXQueue.Add(x)
            End If
        Next
    End Sub
    Private Sub QueueForORYXExport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles QueueForORYXExportToolStripMenuItem1.Click
        QueueOryxSelection()
    End Sub
    Private Sub QueueForORYXExportToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles QueueForORYXExportToolStripMenuItem.Click
        QueueOryxSelection()
    End Sub
    Private Sub ClearORYXQueueToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ClearORYXQueueToolStripMenuItem.Click
        ORYXQueue.Clear()
    End Sub

    Private Sub ExportORYXDataToolStripMenuItem1_DropDownOpening(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportORYXDataToolStripMenuItem1.DropDownOpening
        ExportQueuedORYXDataToolStripMenuItem.Enabled = (ORYXQueue.Count > 0)
    End Sub

End Class
