Imports Nrc.DataMart.Library
Imports System.Windows.Forms

Public Class PredefinitionWizardDialog

#Region " Private Members "

    Private mDateSelectionMode As CreateDefinitionControl.DateMode
    Private mExportSetType As ExportSetType
    Private mNavigator As ClientStudySurveyNavigator
    Private mNewExportSets As Collection(Of ExportSet)
    Private mTeams As Collection(Of Team)
    Private mWeekNumber As Integer
    Private mInitializing As Boolean = False
    Private mIsDeleting As Boolean = False

#End Region

#Region " Public Properties "

    Public ReadOnly Property Teams() As Collection(Of Team)
        Get
            If mTeams Is Nothing Then
                mTeams = Team.GetTwoDigitTeams
            End If
            Return mTeams
        End Get
    End Property

    Public ReadOnly Property DateSelectionMode() As CreateDefinitionControl.DateMode
        Get
            Return mDateSelectionMode
        End Get
    End Property


    Public ReadOnly Property ExportSetType() As ExportSetType
        Get
            Return mExportSetType
        End Get
    End Property


    Public ReadOnly Property Navigator() As ClientStudySurveyNavigator
        Get
            Return mNavigator
        End Get
    End Property


    Public ReadOnly Property NewExportSets() As Collection(Of ExportSet)
        Get
            Return mNewExportSets
        End Get
    End Property
#End Region

#Region " Constructors "

    Public Sub New(ByVal dateSelMode As CreateDefinitionControl.DateMode, ByVal exportSetType As ExportSetType, ByVal navigator As ClientStudySurveyNavigator)

        'This call is required by the Windows Form Designer.
        mInitializing = True
        InitializeComponent()

        'Save parameters
        mDateSelectionMode = dateSelMode
        mExportSetType = exportSetType
        mNavigator = navigator

        'Add any initialization after the InitializeComponent() call.
        InitializeScreen()
        mInitializing = False

    End Sub

#End Region

#Region " Control Events "

    Private Sub PredefinitionWizardDialog_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'If mExportSetType = ExportSetType.CmsHcahps OrElse mExportSetType = ExportSetType.CmsChart Then
        '    Me.CreateTeamPanel.Visible = True
        'Else
        '    Me.CreateTeamPanel.Visible = False
        'End If
    End Sub


    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click

        'Validate
        If Not AreDefinedDefinitionRowsValid() Then Exit Sub

        'Create the definitions and schedule them if required
        If CreateAndScheduleDefinitions() Then
            Me.DialogResult = System.Windows.Forms.DialogResult.OK
            Me.Close()
        End If

    End Sub


    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()

    End Sub


    Private Sub CreateDefinitionIntervalUpDown_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CreateDefinitionIntervalUpDown.ValueChanged

        If mInitializing Then Exit Sub

        SetSummaryLabel()

    End Sub


    Private Sub CreateDefinitionIntervalTypeComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CreateDefinitionIntervalTypeComboBox.SelectedIndexChanged

        If mInitializing Then Exit Sub

        InitializeSummary()
        SetSummaryLabel()

    End Sub


    Private Sub CreateDefinitionCutoffStartDate_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CreateDefinitionCutoffStartDate.ValueChanged

        If mInitializing Then Exit Sub

        SetSummaryLabel()

    End Sub


    Private Sub CreateDefinitionCutoffStartMonthComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CreateDefinitionCutoffStartMonthComboBox.SelectedIndexChanged

        If mInitializing Then Exit Sub

        SetEarliestScheduleStartDate()

    End Sub


    Private Sub CreateDefinitionCutoffStartYearComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CreateDefinitionCutoffStartYearComboBox.SelectedIndexChanged

        If mInitializing Then Exit Sub

        SetEarliestScheduleStartDate()

    End Sub


    Private Sub CreateDefinitionMonthlyDateRadioButton_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles CreateDefinitionMonthlyDateRadioButton.CheckedChanged

        If mInitializing Then Exit Sub

        SetSummaryLabel()

    End Sub


    Private Sub CreateDefinitionMonthlyDayRadioButton_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles CreateDefinitionMonthlyDayRadioButton.CheckedChanged

        If mInitializing Then Exit Sub

        SetSummaryLabel()

    End Sub


    Private Sub ScheduleFileYesTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ScheduleFileYesTSButton.Click

        ScheduleFileYesTSButton.Checked = True
        ScheduleFileNoTSButton.Checked = False
        InitializeScheduleFileCreation()

    End Sub


    Private Sub ScheduleFileNoTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ScheduleFileNoTSButton.Click

        ScheduleFileYesTSButton.Checked = False
        ScheduleFileNoTSButton.Checked = True
        InitializeScheduleFileCreation()

    End Sub


    Private Sub DefinedDefinitionCreateTSButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles DefinedDefinitionCreateTSButton.Click

        PopulateDefinedDefinitionGrid()

    End Sub


    Private Sub DefinedDefinitionDeleteTSButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles DefinedDefinitionDeleteTSButton.Click

        DefinedDefinitionDeleteRow()

    End Sub


    Private Sub DefinedDefinitionCreateMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DefinedDefinitionCreateMenuItem.Click

        PopulateDefinedDefinitionGrid()

    End Sub


    Private Sub DefinedDefinitionDeleteMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DefinedDefinitionDeleteMenuItem.Click

        DefinedDefinitionDeleteRow()

    End Sub


    Private Sub DefinedDefinitionGridView_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles DefinedDefinitionGridView.MouseDown

        'If this is not the right mouse button then we are out of here
        If e.Button <> Windows.Forms.MouseButtons.Right Then Exit Sub

        'Determine where we are in the grid
        Dim hitTest As DataGridView.HitTestInfo = DefinedDefinitionGridView.HitTest(e.X, e.Y)

        Select Case hitTest.Type
            Case DataGridViewHitTestType.Cell
                'Make sure the cell that was clicked on is selected
                'DefinedDefinitionGridView.Rows(hitTest.RowIndex).Cells(hitTest.ColumnIndex).Selected = True
                DefinedDefinitionGridView.CurrentCell = DefinedDefinitionGridView.Rows(hitTest.RowIndex).Cells(hitTest.ColumnIndex)

                'Setup the menu item availability
                DefinedDefinitionCreateMenuItem.Enabled = True
                DefinedDefinitionDeleteMenuItem.Enabled = True

            Case DataGridViewHitTestType.RowHeader
                'Make sure the row that was clicked on is selected
                DefinedDefinitionGridView.CurrentCell = DefinedDefinitionGridView.Rows(hitTest.RowIndex).Cells(0)
                DefinedDefinitionGridView.Rows(hitTest.RowIndex).Selected = True

                'Setup the menu item availability
                DefinedDefinitionCreateMenuItem.Enabled = True
                DefinedDefinitionDeleteMenuItem.Enabled = True

            Case Else
                'Setup the menu item availability
                DefinedDefinitionCreateMenuItem.Enabled = True
                DefinedDefinitionDeleteMenuItem.Enabled = False

        End Select

    End Sub


    Private Sub DefinedDefinitionGridView_EditingControlShowing(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewEditingControlShowingEventArgs) Handles DefinedDefinitionGridView.EditingControlShowing

        If e.Control.GetType.Name = "DataGridViewComboBoxEditingControl" Then
            Dim cboBox As ComboBox = TryCast(e.Control, ComboBox)
            If cboBox IsNot Nothing Then
                RemoveHandler cboBox.SelectionChangeCommitted, AddressOf DefinedDefinitionGridViewComboBox_SelectedIndexChanged
                AddHandler cboBox.SelectionChangeCommitted, AddressOf DefinedDefinitionGridViewComboBox_SelectedIndexChanged
            End If
        ElseIf e.Control.GetType.Name = "DataGridViewCalendarEditingControl" Then
            Dim calendar As DateTimePicker = TryCast(e.Control, DateTimePicker)
            If calendar IsNot Nothing Then
                RemoveHandler calendar.ValueChanged, AddressOf DefinedDefinitionGridViewCalendar_ValueChanged
                AddHandler calendar.ValueChanged, AddressOf DefinedDefinitionGridViewCalendar_ValueChanged
            End If
        ElseIf e.Control.GetType.Name = "DataGridViewTextBoxEditingControl" Then
            Dim txtBox As TextBox = TryCast(e.Control, TextBox)
            If txtBox IsNot Nothing Then
                RemoveHandler txtBox.TextChanged, AddressOf DefinedDefinitionGridViewTextBox_TextChanged
                AddHandler txtBox.TextChanged, AddressOf DefinedDefinitionGridViewTextBox_TextChanged
            End If
        End If

    End Sub


    Private Sub DefinedDefinitionGridViewComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)

        If mIsDeleting Then Exit Sub

        'Get a reference to the combobox
        Dim cboBox As ComboBox = CType(sender, ComboBox)

        'Get a reference to the current grid cell
        Dim currentCell As DataGridViewCell = DefinedDefinitionGridView.CurrentCell

        'Set the cell value based on the combobox selection
        currentCell.Value = cboBox.SelectedValue

        'Take care of other column specific tasks
        Select Case currentCell.ColumnIndex
            Case DefinedDefinitionMonthColumn.Index, DefinedDefinitionYearColumn.Index
                'Reset the start and end dates
                Dim month As Integer = GetMonth(currentCell.OwningRow)
                Dim year As Integer = GetYear(currentCell.OwningRow)
                Dim startDate As Date = Date.Parse(month.ToString & "/1/" & year.ToString)
                Dim endDate As Date = startDate.AddMonths(1).AddDays(-1)
                currentCell.OwningRow.Cells(DefinedDefinitionStartDateColumn.Index).Value = startDate.ToShortDateString
                currentCell.OwningRow.Cells(DefinedDefinitionEndDateColumn.Index).Value = endDate.ToShortDateString

                'Reset the name
                Dim name As String
                Dim dateSet As New ExportDateSet
                dateSet.SetByMonthYear(month, year)
                If String.IsNullOrEmpty(CreateDefinitionNameTextBox.Text) Then
                    name = dateSet.MonthYearLabel
                Else
                    name = String.Format("{0} - {1}", CreateDefinitionNameTextBox.Text, dateSet.MonthYearLabel)
                End If
                currentCell.OwningRow.Cells(DefinedDefinitionNameColumn.Index).Value = name

        End Select

        'Validate the row
        IsDefinedDefinitionRowValid(currentCell.OwningRow)

    End Sub


    Private Sub DefinedDefinitionGridViewCalendar_ValueChanged(ByVal sender As Object, ByVal e As EventArgs)

        If mIsDeleting Then Exit Sub

        'Get a reference to the combobox
        Dim calendar As DateTimePicker = CType(sender, DateTimePicker)

        'Get a reference to the current grid cell
        Dim currentCell As DataGridViewCell = DefinedDefinitionGridView.CurrentCell

        'Set the cell value based on the combobox selection
        currentCell.Value = calendar.Value

        'Take care of other column specific tasks
        Select Case currentCell.ColumnIndex
            Case DefinedDefinitionStartDateColumn.Index, DefinedDefinitionEndDateColumn.Index
                'Reset the name
                Dim name As String
                Dim startDate As Date = GetStartDate(currentCell.OwningRow)
                Dim endDate As Date = GetEndDate(currentCell.OwningRow)
                If String.IsNullOrEmpty(CreateDefinitionNameTextBox.Text) Then
                    name = String.Format("{0}-{1}", startDate.ToShortDateString, endDate.ToShortDateString)
                Else
                    name = String.Format("{0} - {1}-{2}", CreateDefinitionNameTextBox.Text, startDate.ToString("yyyyMMdd"), endDate.ToString("yyyyMMdd"))
                End If
                currentCell.OwningRow.Cells(DefinedDefinitionNameColumn.Index).Value = name

        End Select

        'Validate the row
        IsDefinedDefinitionRowValid(currentCell.OwningRow)

    End Sub


    Private Sub DefinedDefinitionGridViewTextBox_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        If mIsDeleting Then Exit Sub

        'Get a reference to the textbox
        Dim txtBox As TextBox = CType(sender, TextBox)

        'Get a reference to the current grid cell
        Dim currentCell As DataGridViewCell = DefinedDefinitionGridView.CurrentCell

        'Set the cell value based on the textbox value
        currentCell.Value = txtBox.Text

        'Take care of other column specific tasks
        Select Case currentCell.ColumnIndex
            Case DefinedDefinitionNameColumn.Index
                'Do nothing

        End Select

        'Validate the row
        IsDefinedDefinitionRowValid(currentCell.OwningRow)

    End Sub

#End Region

#Region " Private Methods "

    Private Sub InitializeFileTypesComboBox()

        'Create the collection of file types
        Dim fileTypes As New List(Of FileTypeItem)
        With fileTypes
            .Add(New FileTypeItem(ExportFileType.DBase, "dBase File (.dbf)", "dbf"))
            .Add(New FileTypeItem(ExportFileType.Csv, "CSV File (.csv)", "csv"))
            .Add(New FileTypeItem(ExportFileType.Xml, "XML File (.xml)", "xml"))
        End With

        'Populate the file types combo boxes
        With ScheduleFileTypeComboBox
            .DataSource = fileTypes
            .DisplayMember = "Label"
            .ValueMember = "ExportFileType"
        End With
        With DefinedDefinitionFileTypeColumn
            .DataSource = fileTypes
            .DisplayMember = "Label"
            .ValueMember = "ExportFileType"
        End With

        'Pre-select the first type in the list
        Select Case mExportSetType
            Case Library.ExportSetType.CmsChart, Library.ExportSetType.CmsHHcahps, Library.ExportSetType.CmsHcahps
                ScheduleFileTypeComboBox.SelectedIndex = 2

            Case Else
                ScheduleFileTypeComboBox.SelectedIndex = 0

        End Select

    End Sub


    Private Sub InitializeMonthComboBox()

        'Create the collection of months
        Dim months As New List(Of MonthListItem)
        With months
            .Add(New MonthListItem("January", 1))
            .Add(New MonthListItem("February", 2))
            .Add(New MonthListItem("March", 3))
            .Add(New MonthListItem("April", 4))
            .Add(New MonthListItem("May", 5))
            .Add(New MonthListItem("June", 6))
            .Add(New MonthListItem("July", 7))
            .Add(New MonthListItem("August", 8))
            .Add(New MonthListItem("September", 9))
            .Add(New MonthListItem("October", 10))
            .Add(New MonthListItem("November", 11))
            .Add(New MonthListItem("December", 12))
        End With

        'Populate the month combo box
        With CreateDefinitionCutoffStartMonthComboBox
            .DataSource = months
            .DisplayMember = "MonthName"
            .ValueMember = "MonthNumber"
            .SelectedValue = Date.Today.Month
        End With
        With DefinedDefinitionMonthColumn
            .DataSource = months
            .DisplayMember = "MonthName"
            .ValueMember = "MonthNumber"
        End With

    End Sub


    Private Sub InitializeYearComboBox()

        'Get the first year to be in the list (this year - 5)
        Dim startYear As Integer = Date.Today.Year - 5

        'Create the collection of years
        Dim years As New List(Of ListItem(Of Integer))
        For cnt As Integer = 0 To 10
            years.Add(New ListItem(Of Integer)((startYear + cnt).ToString, startYear + cnt))
        Next

        'Populate the list
        With CreateDefinitionCutoffStartYearComboBox
            .DataSource = years
            .DisplayMember = "Label"
            .ValueMember = "Value"
            .SelectedValue = Date.Today.Year
        End With
        With DefinedDefinitionYearColumn
            .DataSource = years
            .DisplayMember = "Label"
            .ValueMember = "Value"
        End With

    End Sub


    Private Sub InitializeScreen()

        'Setup all the combo boxes
        CreateDefinitionIntervalTypeComboBox.SelectedIndex = 0
        InitializeFileTypesComboBox()
        InitializeMonthComboBox()
        InitializeYearComboBox()

        'Clear the create definition part of the screen
        CreateDefinitionFlowLayoutPanel.Controls.Clear()
        '20071204
        If mExportSetType = ExportSetType.CmsHcahps OrElse mExportSetType = ExportSetType.CmsChart Then
            CreateDefinitionFlowLayoutPanel.Controls.Add(CreateTeamPanel)
            For Each T As Team In Teams
                cboTeam.Items.Add(T.Id)
            Next
            Dim createToolItem As ToolStripItem = DefinedDefinitionToolStrip.Items("DefinedDefinitionCreateTSButton")
            createToolItem.Visible = False
        End If

        'Add the common parts of the create definition part of the screen
        CreateDefinitionFlowLayoutPanel.Controls.Add(CreateDefinitionNamePanel)

        'Set the visibility of the common defined definition columns in the grid
        DefinedDefinitionClientColumn.Visible = True
        DefinedDefinitionStudyColumn.Visible = True
        DefinedDefinitionSurveyColumn.Visible = True
        DefinedDefinitionNameColumn.Visible = True

        'Take care of date selection mode specific setup
        Select Case mDateSelectionMode
            Case CreateDefinitionControl.DateMode.SingleMonth
                'Add the required create definition sections
                CreateDefinitionFlowLayoutPanel.Controls.Add(CreateDefinitionCutoffStartMonthPanel)
                CreateDefinitionFlowLayoutPanel.Controls.Add(CreateDefinitionQuantityPanel)

                'Set the appropriate column visibility
                DefinedDefinitionUnitColumn.Visible = True
                DefinedDefinitionStartDateColumn.Visible = False
                DefinedDefinitionEndDateColumn.Visible = False
                DefinedDefinitionMonthColumn.Visible = True
                DefinedDefinitionYearColumn.Visible = True

                'Set the schedule file defaults
                With ScheduleFileDirectsOnlyCheckBox
                    .Enabled = False
                    .Checked = True
                End With
                With ScheduleFileReturnsOnlyCheckBox
                    .Enabled = False
                    .Checked = False
                End With

            Case CreateDefinitionControl.DateMode.StartAndEndDate
                'Add the required create definition sections
                CreateDefinitionFlowLayoutPanel.Controls.Add(CreateDefinitionCutoffStartDatePanel)
                CreateDefinitionFlowLayoutPanel.Controls.Add(CreateDefinitionRecurrencePanel)
                CreateDefinitionFlowLayoutPanel.Controls.Add(CreateDefinitionSummaryFlowLayoutPanel)

                'Set the appropriate column visibility
                DefinedDefinitionUnitColumn.Visible = False
                DefinedDefinitionStartDateColumn.Visible = True
                DefinedDefinitionEndDateColumn.Visible = True
                DefinedDefinitionMonthColumn.Visible = False
                DefinedDefinitionYearColumn.Visible = False

                'Set the schedule file defaults
                With ScheduleFileDirectsOnlyCheckBox
                    .Enabled = True
                    .Checked = True
                End With
                With ScheduleFileReturnsOnlyCheckBox
                    .Enabled = True
                    .Checked = True
                End With

        End Select

        'Setup the returns only and directs only columns
        Select Case Me.mExportSetType
            Case Library.ExportSetType.CmsChart, Library.ExportSetType.CmsHHcahps, Library.ExportSetType.CmsHcahps
                With DefinedDefinitionReturnsOnlyColumn
                    .ReadOnly = True
                    .DefaultCellStyle.BackColor = SystemColors.Control
                End With
                With DefinedDefinitionDirectsOnlyColumn
                    .ReadOnly = True
                    .DefaultCellStyle.BackColor = SystemColors.Control
                End With
                Me.IncludePhoneFields.Visible = False

            Case Else
                With DefinedDefinitionReturnsOnlyColumn
                    .ReadOnly = False
                    .DefaultCellStyle.BackColor = SystemColors.Window
                End With
                With DefinedDefinitionDirectsOnlyColumn
                    .ReadOnly = False
                    .DefaultCellStyle.BackColor = SystemColors.Window
                End With
                Me.IncludePhoneFields.Visible = True

        End Select

        InitializeScheduleFileCreation()
        InitializeSummary()
        SetSummaryLabel()

    End Sub


    Private Sub InitializeScheduleFileCreation()

        If ScheduleFileYesTSButton.Checked Then
            ScheduleFilePanel.Enabled = True
            DefinedDefinitionFileTypeColumn.Visible = True
            DefinedDefinitionReturnsOnlyColumn.Visible = True
            DefinedDefinitionDirectsOnlyColumn.Visible = True
            DefinedDefinitionScheduleDateColumn.Visible = True
        Else
            ScheduleFilePanel.Enabled = False
            DefinedDefinitionFileTypeColumn.Visible = False
            DefinedDefinitionReturnsOnlyColumn.Visible = False
            DefinedDefinitionDirectsOnlyColumn.Visible = False
            DefinedDefinitionScheduleDateColumn.Visible = False
        End If

    End Sub


    Private Sub InitializeSummary()

        CreateDefinitionSummaryFlowLayoutPanel.Controls.Clear()
        If CreateDefinitionIntervalTypeComboBox.SelectedItem.ToString = "Weeks" Then
            CreateDefinitionSummaryFlowLayoutPanel.Controls.Add(CreateDefinitionWeeklySummaryPanel)
        Else
            CreateDefinitionSummaryFlowLayoutPanel.Controls.Add(CreateDefinitionMonthlySummaryPanel)
        End If

    End Sub


    Private Sub SetEarliestScheduleStartDate()

        'Determine the earliest schedule start date
        Dim dateSets As Collection(Of ExportDateSet) = GetDateSets()
        If dateSets.Count = 0 Then
            With ScheduleFileStartDate
                .MinDate = DateTimePicker.MinimumDateTime
                .Value = Now
                .MinDate = Now.AddDays(-1)
            End With
        Else
            With ScheduleFileStartDate
                .MinDate = DateTimePicker.MinimumDateTime
                .Value = dateSets(0).EndDate.AddDays(1)
                .MinDate = dateSets(0).EndDate.AddDays(1)
            End With
        End If

    End Sub


    Private Sub SetSummaryLabel()

        'Get the recurrence interval
        Dim interval As Integer = CInt(CreateDefinitionIntervalUpDown.Value)

        'Build the summary label
        If CreateDefinitionIntervalTypeComboBox.SelectedItem.ToString = "Weeks" Then
            'The recurrence type is weeks
            If CreateDefinitionIntervalUpDown.Value = 1 Then
                'The user has selected 1 week
                CreateDefinitionWeeklyLabel.Text = String.Format("Each {0} of every week", CreateDefinitionCutoffStartDate.Value.DayOfWeek.ToString)
            Else
                'The user has selected more than one week
                CreateDefinitionWeeklyLabel.Text = String.Format("Each {0} of every {1} weeks", CreateDefinitionCutoffStartDate.Value.DayOfWeek.ToString, CInt(CreateDefinitionIntervalUpDown.Value).ToString)
            End If
        Else
            'The recurrence type is months
            Dim daySuffix As String

            'Get the suffix string to be used with the day
            Select Case CreateDefinitionCutoffStartDate.Value.Day
                Case 1, 21, 31
                    daySuffix = "st"
                Case 2, 22
                    daySuffix = "nd"
                Case 3, 23
                    daySuffix = "rd"
                Case Else
                    daySuffix = "th"
            End Select

            'Get the month text
            Dim monthText As String = "month"
            If interval > 1 Then
                monthText = interval & " months"
            End If

            'Set the monthly date option display string
            CreateDefinitionMonthlyDateRadioButton.Text = String.Format("The {0}{1} day of every {2}", CreateDefinitionCutoffStartDate.Value.Day, daySuffix, monthText)

            'Determine the week number during the month
            Dim weekNum As Integer = 0
            Dim testDate As Date = CreateDefinitionCutoffStartDate.Value
            While testDate.Month = CreateDefinitionCutoffStartDate.Value.Month
                weekNum += 1
                testDate = testDate.AddDays(-7)
            End While

            'Get the display label for the week number
            Dim weekNumLabel As String
            Select Case weekNum
                Case 1
                    weekNumLabel = "1st"
                    mWeekNumber = weekNum

                Case 2
                    weekNumLabel = "2nd"
                    mWeekNumber = weekNum

                Case 3
                    weekNumLabel = "3rd"
                    mWeekNumber = weekNum

                Case 4
                    If CreateDefinitionCutoffStartDate.Value.Month = CreateDefinitionCutoffStartDate.Value.AddDays(7).Month Then
                        'This is not the last week of the month so use '4th'
                        weekNumLabel = "4th"
                        mWeekNumber = weekNum
                    Else
                        'This is the last week of the month
                        weekNumLabel = "last"
                        mWeekNumber = 9
                    End If
                Case Else
                    'This is the fifth week of the month so it must be the last
                    weekNumLabel = "last"
                    mWeekNumber = 9
            End Select

            'Set the monthly day option display string
            CreateDefinitionMonthlyDayRadioButton.Text = String.Format("The {0} {1} of every {2}", weekNumLabel, CreateDefinitionCutoffStartDate.Value.DayOfWeek.ToString, monthText)
        End If

        'Determine the earliest schedule start date
        Dim dateSets As Collection(Of ExportDateSet) = GetDateSets()
        If dateSets.Count = 0 Then
            With ScheduleFileStartDate
                .MinDate = DateTimePicker.MinimumDateTime
                .Value = Now
                .MinDate = Now.AddDays(-1)
            End With
        Else
            With ScheduleFileStartDate
                .MinDate = DateTimePicker.MinimumDateTime
                .Value = dateSets(0).EndDate.AddDays(1)
                .MinDate = dateSets(0).EndDate.AddDays(1)
            End With
        End If

        'Determine the earliest schedule start date
        SetEarliestScheduleStartDate()

    End Sub


    Private Sub PopulateDefinedDefinitionGrid()

        'Set the cursor
        Me.Cursor = Cursors.WaitCursor

        'Clear the grid
        DefinedDefinitionGridView.Rows.Clear()

        'Create a collection of DateSets
        Dim dateSets As Collection(Of ExportDateSet) = GetDateSets()

        'Populate the grid
        Select Case mExportSetType
            Case Library.ExportSetType.Standard
                'Add a record for each survey and each date
                DefinedDefinitionGridView.SuspendLayout()
                For Each srvy As Survey In mNavigator.SelectedSurveys
                    'Add this survey and all of it's date sets
                    For Each datSet As ExportDateSet In dateSets
                        'Add this export set definition to the grid
                        AddDefinedDefinitionRow(srvy, datSet)
                    Next
                Next
                DefinedDefinitionGridView.ResumeLayout()

            Case Library.ExportSetType.CmsHcahps, Library.ExportSetType.CmsHHcahps, Library.ExportSetType.CmsChart
                'Get a dictionary to hold the sampleunits with errors or warnings
                Dim warningUnitList As New Dictionary(Of Integer, SampleUnit)
                Dim skipWarningUnits As Boolean = False

                'If the user is scheduling file creation then we need to validate
                If Me.ScheduleFileYesTSButton.Checked Then
                    'Initialize the error and warning strings
                    Dim errorMessage As String = String.Empty
                    Dim warningMessage As String = String.Empty

                    'Validate the medicare number for each unit is only assigned to that unit
                    For Each unit As SampleUnit In mNavigator.SelectedUnits
                        'Call the validation routine
                        Dim errMsg As String = String.Empty
                        ExportSet.AllowIndividualExport(unit.Id, mExportSetType, errMsg)

                        'Deal with the results
                        If Not String.IsNullOrEmpty(errMsg) Then
                            'We have encountered an error so save it
                            If errorMessage.Length > 0 Then
                                errorMessage &= vbCrLf
                            End If
                            errorMessage &= errMsg

                        End If
                    Next

                    'Take action with any errors or warnings encountered
                    If Not String.IsNullOrEmpty(errorMessage) Then
                        'Errors were encountered so notify the user and head out of dodge
                        errorMessage = "The following errors were encountered:" & vbCrLf & vbCrLf & _
                                       errorMessage & vbCrLf & vbCrLf & _
                                       "No export definitions will be created!"
                        MessageBox.Show(errorMessage, "Error Creating Export Definitions", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        Me.Cursor = Cursors.Default
                        Exit Sub
                    End If
                End If

                'If we made it to here then add a record for each unit and each date
                DefinedDefinitionGridView.SuspendLayout()
                For Each unit As SampleUnit In mNavigator.SelectedUnits
                    'Determine if we are to skip this sampleunit
                    If Not skipWarningUnits OrElse (skipWarningUnits And Not warningUnitList.ContainsKey(unit.Id)) Then
                        'Add this unit and all of it's date sets
                        For Each datSet As ExportDateSet In dateSets
                            'Add this export set definition to the grid
                            AddDefinedDefinitionRow(unit, datSet)
                        Next
                    End If
                Next
                DefinedDefinitionGridView.ResumeLayout()

        End Select

        'Reset the cursor
        Me.Cursor = Cursors.Default

    End Sub


    Private Function GetDateSets() As Collection(Of ExportDateSet)

        Dim dateSets As Collection(Of ExportDateSet)

        Select Case mDateSelectionMode
            Case CreateDefinitionControl.DateMode.SingleMonth
                'We are dealing with single month setting
                'Get the date sets
                dateSets = ExportDateSet.GetBySingleMonth(CType(CreateDefinitionCutoffStartMonthComboBox.SelectedValue, Integer), _
                                                          CType(CreateDefinitionCutoffStartYearComboBox.SelectedValue, Integer), _
                                                          CType(CreateDefinitionQuantityUpDown2.Value, Integer), _
                                                          ScheduleFileYesTSButton.Checked, ScheduleFileStartDate.Value)

            Case Else 'CreateDefinitionControl.DateMode.StartAndEndDate
                'We are dealing with the recurrence setting
                'Get the interval type
                Dim intervalType As ExportDateSet.IntervalTypes
                If CreateDefinitionIntervalTypeComboBox.SelectedItem.ToString = "Weeks" Then
                    intervalType = ExportDateSet.IntervalTypes.Weeks
                Else
                    intervalType = ExportDateSet.IntervalTypes.Months
                End If

                'Get the monthly type
                Dim monthlyType As ExportDateSet.MonthlyTypes
                If CreateDefinitionMonthlyDateRadioButton.Checked Then
                    monthlyType = ExportDateSet.MonthlyTypes.SpecificDate
                Else
                    monthlyType = ExportDateSet.MonthlyTypes.DayOfWeek
                End If

                'Get the date sets
                dateSets = ExportDateSet.GetByStartAndEndDate(CreateDefinitionCutoffStartDate.Value, CType(CreateDefinitionIntervalUpDown.Value, Integer), _
                                                              intervalType, monthlyType, CType(CreateDefinitionQuantityUpDown1.Value, Integer), mWeekNumber, _
                                                              ScheduleFileYesTSButton.Checked, ScheduleFileStartDate.Value)

        End Select

        'Return the date sets
        Return dateSets

    End Function


    Private Function AddDefinedDefinitionRow(ByVal srvy As Survey, ByVal dateSet As ExportDateSet) As DataGridViewRow

        Dim name As String

        'Get the name
        If String.IsNullOrEmpty(CreateDefinitionNameTextBox.Text) Then
            name = String.Format("{0}-{1}", dateSet.StartDate.ToShortDateString, dateSet.EndDate.ToShortDateString)
        Else
            name = String.Format("{0} - {1}-{2}", CreateDefinitionNameTextBox.Text, dateSet.StartDate.ToString("yyyyMMdd"), Format(dateSet.EndDate, "yyyyMMdd"))
        End If
        name = Nrc.Framework.IO.Path.CleanFileName(name)

        'Add the row
        Dim rowIndex As Integer = DefinedDefinitionGridView.Rows.Add()
        Dim row As DataGridViewRow = DefinedDefinitionGridView.Rows(rowIndex)

        'Populate the row
        With row
            .Cells(DefinedDefinitionClientColumn.Index).Value = srvy.Study.Client.DisplayLabel
            .Cells(DefinedDefinitionStudyColumn.Index).Value = srvy.Study.DisplayLabel
            .Cells(DefinedDefinitionSurveyColumn.Index).Value = srvy.DisplayLabel
            .Cells(DefinedDefinitionSurveyIDColumn.Index).Value = srvy.Id
            .Cells(DefinedDefinitionNameColumn.Index).Value = name
            .Cells(DefinedDefinitionStartDateColumn.Index).Value = dateSet.StartDate.ToShortDateString
            .Cells(DefinedDefinitionEndDateColumn.Index).Value = dateSet.EndDate.ToShortDateString
            .Cells(DefinedDefinitionMonthColumn.Index).Value = dateSet.StartDate.Month
            .Cells(DefinedDefinitionYearColumn.Index).Value = dateSet.StartDate.Year
            .Cells(DefinedDefinitionFileTypeColumn.Index).Value = ScheduleFileTypeComboBox.SelectedValue
            .Cells(DefinedDefinitionReturnsOnlyColumn.Index).Value = ScheduleFileReturnsOnlyCheckBox.Checked
            .Cells(DefinedDefinitionDirectsOnlyColumn.Index).Value = ScheduleFileDirectsOnlyCheckBox.Checked
            .Cells(DefinedDefinitionIncludePhone.Index).Value = IncludePhoneFields.Checked
            .Cells(DefinedDefinitionScheduleDateColumn.Index).Value = dateSet.RunDate.ToShortDateString
        End With

        'Return the row
        Return row

    End Function


    Private Function AddDefinedDefinitionRow(ByVal unit As SampleUnit, ByVal dateSet As ExportDateSet) As DataGridViewRow

        Dim name As String

        'Get the name
        If String.IsNullOrEmpty(CreateDefinitionNameTextBox.Text) Then
            name = dateSet.MonthYearLabel
        Else
            name = String.Format("{0} - {1}", CreateDefinitionNameTextBox.Text, dateSet.MonthYearLabel)
        End If

        'Add the row
        Dim srvy As Survey = Survey.GetSurvey(unit.SurveyId)
        Dim row As DataGridViewRow = AddDefinedDefinitionRow(srvy, dateSet)

        'Populate the row
        With row
            .Cells(DefinedDefinitionUnitColumn.Index).Value = unit.DisplayLabel
            .Cells(DefinedDefinitionUnitIDColumn.Index).Value = unit.Id
            .Cells(DefinedDefinitionNameColumn.Index).Value = name
        End With

        'Return the row
        Return row

    End Function


    Private Function CreateAndScheduleDefinitions() As Boolean

        Try
            'Set the wait cursor
            Me.Cursor = Cursors.WaitCursor

            'Get a collection of the new export sets
            Dim newExportSet As ExportSet
            mNewExportSets = New Collection(Of ExportSet)
            Dim newScheduleSets As New Collection(Of ExportSet)
            Select Case mExportSetType
                Case ExportSetType.Standard
                    For Each row As DataGridViewRow In DefinedDefinitionGridView.Rows
                        'Create the export set
                        newExportSet = ExportSet.CreateNewExportSet(GetName(row), GetSurveyID(row), GetStartDate(row), _
                                                                    GetEndDate(row), mExportSetType, CurrentUser.UserName)

                        'Add the export set to the collection
                        mNewExportSets.Add(newExportSet)

                        'Schedule this export file if required
                        If ScheduleFileYesTSButton.Checked Then
                            'Clear the collection
                            newScheduleSets.Clear()

                            'Add this export set
                            newScheduleSets.Add(newExportSet)

                            'Schedule the export
                            ScheduledExport.CreateNew(newScheduleSets, GetRunDate(row), GetReturnsOnly(row), GetDirectsOnly(row), GetIncludePhone(row), _
                                                      GetFileType(row), Nrc.Framework.IO.Path.CleanFileName(GetName(row)), CurrentUser.UserName)
                        End If
                    Next

                Case ExportSetType.CmsHcahps, Library.ExportSetType.CmsHHcahps, ExportSetType.CmsChart
                    For Each row As DataGridViewRow In DefinedDefinitionGridView.Rows
                        'Create the export set
                        newExportSet = ExportSet.CreateNewExportSet(GetName(row), GetSurveyID(row), GetSampleUnitID(row), _
                                                                    GetStartDate(row), GetEndDate(row), mExportSetType, _
                                                                    CurrentUser.UserName)

                        'Add the export set to the collection
                        mNewExportSets.Add(newExportSet)

                        'Schedule this export file if required
                        If ScheduleFileYesTSButton.Checked Then
                            'Clear the collection
                            newScheduleSets.Clear()

                            'Add this export set
                            newScheduleSets.Add(newExportSet)

                            'Create standardized CMS export file name
                            Dim tempExportSets As New Collection(Of ExportSet)
                            tempExportSets.Add(newExportSet)

                            'Schedule the export
                            ScheduledExport.CreateNew(newScheduleSets, GetRunDate(row), GetReturnsOnly(row), GetDirectsOnly(row), GetIncludePhone(row), _
                                                      GetFileType(row), ExistingDefinitionsControl.GetExportFileName(tempExportSets(0), cboTeam.Text), CurrentUser.UserName)
                        End If
                    Next

            End Select

            'Set the return value
            Return True

        Catch ex As Exception
            'Report the exception to the user
            ReportException(ex, "Error Creating Exports")

            'Set the return value
            Return False

        Finally
            'Reset the cursor
            Me.Cursor = Cursors.Default

        End Try

    End Function


    Private Sub DefinedDefinitionDeleteRow()

        mIsDeleting = True
        If DefinedDefinitionGridView.CurrentRow IsNot Nothing Then
            DefinedDefinitionGridView.Rows.RemoveAt(DefinedDefinitionGridView.CurrentRow.Index)
        End If
        mIsDeleting = False

    End Sub

#End Region

#Region " Private Methods - Grid Data Retrieval "

    Private Function GetSurveyID(ByVal row As DataGridViewRow) As Integer

        Return CType(row.Cells(DefinedDefinitionSurveyIDColumn.Index).Value, Integer)

    End Function

    Private Function GetSampleUnitID(ByVal row As DataGridViewRow) As Integer

        Return CType(row.Cells(DefinedDefinitionUnitIDColumn.Index).Value, Integer)

    End Function


    Private Function GetName(ByVal row As DataGridViewRow) As String

        Return row.Cells(DefinedDefinitionNameColumn.Index).Value.ToString

    End Function


    Private Function GetStartDate(ByVal row As DataGridViewRow) As Date

        Return CType(row.Cells(DefinedDefinitionStartDateColumn.Index).Value, Date)

    End Function


    Private Function GetEndDate(ByVal row As DataGridViewRow) As Date

        Return CType(row.Cells(DefinedDefinitionEndDateColumn.Index).Value, Date)

    End Function


    Private Function GetMonth(ByVal row As DataGridViewRow) As Integer

        Return CType(row.Cells(DefinedDefinitionMonthColumn.Index).Value, Integer)

    End Function


    Private Function GetYear(ByVal row As DataGridViewRow) As Integer

        Return CType(row.Cells(DefinedDefinitionYearColumn.Index).Value, Integer)

    End Function


    Private Function GetFileType(ByVal row As DataGridViewRow) As ExportFileType

        Return CType(row.Cells(Me.DefinedDefinitionFileTypeColumn.Index).Value, ExportFileType)

    End Function


    Private Function GetReturnsOnly(ByVal row As DataGridViewRow) As Boolean

        Return CType(row.Cells(Me.DefinedDefinitionReturnsOnlyColumn.Index).Value, Boolean)

    End Function


    Private Function GetDirectsOnly(ByVal row As DataGridViewRow) As Boolean

        Return CType(row.Cells(Me.DefinedDefinitionDirectsOnlyColumn.Index).Value, Boolean)

    End Function

    Private Function GetIncludePhone(ByVal row As DataGridViewRow) As Boolean

        Return CType(row.Cells(Me.DefinedDefinitionIncludePhone.Index).Value, Boolean)

    End Function


    Private Function GetRunDate(ByVal row As DataGridViewRow) As Date

        Return CType(row.Cells(DefinedDefinitionScheduleDateColumn.Index).Value, Date)

    End Function


    Private Sub SetError(ByRef cell As DataGridViewCell, ByVal cellError As String)

        Dim rowError As New System.Text.StringBuilder(String.Empty)

        'Set this cell's error
        cell.ErrorText = cellError

        'Set the row's error
        For Each currentCell As DataGridViewCell In cell.OwningRow.Cells
            If currentCell.ErrorText IsNot Nothing AndAlso currentCell.ErrorText.Length > 0 Then
                'Add puctuation if there is already something in the string
                If rowError.Length > 0 Then rowError.Append("," & vbCrLf)

                'Add this cell's error
                rowError.AppendFormat("{0}: {1}", currentCell.OwningColumn.HeaderText, currentCell.ErrorText)
            End If
        Next
        cell.OwningRow.ErrorText = rowError.ToString

    End Sub


    Private Function AreDefinedDefinitionRowsValid() As Boolean

        Dim foundInvalid As Boolean = False

        'Validate every row
        For Each row As DataGridViewRow In DefinedDefinitionGridView.Rows
            If Not IsDefinedDefinitionRowValid(row) Then
                foundInvalid = True
            End If
        Next

        'If we found invalid rows then notify the user
        If foundInvalid Then
            MessageBox.Show("One or more errors exist!" & vbCrLf & vbCrLf & "Please correct the errors and try again.", "Export Definition Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        Else
            Return True
        End If

    End Function


    Private Function IsDefinedDefinitionRowValid(ByVal row As DataGridViewRow) As Boolean

        'Get a reference to all of the cells to be validated
        Dim nameCell As DataGridViewCell = row.Cells(DefinedDefinitionNameColumn.Index)
        Dim endDateCell As DataGridViewCell = row.Cells(DefinedDefinitionEndDateColumn.Index)
        Dim runDateCell As DataGridViewCell = row.Cells(DefinedDefinitionScheduleDateColumn.Index)

        'Validate the row
        Return (IsDefinedDefinitionNameValid(nameCell) And _
                IsDefinedDefinitionEndDateValid(endDateCell) And _
                IsDefinedDefinitionScheduleDateValid(runDateCell))

    End Function


    Private Function IsDefinedDefinitionNameValid(ByVal cell As DataGridViewCell) As Boolean

        If String.IsNullOrEmpty(cell.Value.ToString) Then
            'The Name must be filled in
            SetError(cell, "The Name must be provided!")
            Return False
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function


    Private Function IsDefinedDefinitionEndDateValid(ByVal cell As DataGridViewCell) As Boolean

        'Get the start and end date
        Dim startDate As Date = GetStartDate(cell.OwningRow)
        Dim endDate As Date = GetEndDate(cell.OwningRow)

        'Validate
        If endDate < startDate Then
            'End date must be greater than start date
            SetError(cell, "The End Date must be greater than the Start Date!")
            Return False
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function


    Private Function IsDefinedDefinitionScheduleDateValid(ByVal cell As DataGridViewCell) As Boolean

        'Get the run and end date
        Dim runDate As Date = GetRunDate(cell.OwningRow)
        Dim endDate As Date = GetEndDate(cell.OwningRow)

        'Validate
        If runDate < endDate Then
            'Run date must be greater than end date
            SetError(cell, "The Run On Date must be greater than the End Date!")
            Return False
        End If

        'If we made it here then all is well
        SetError(cell, "")
        Return True

    End Function

#End Region

    Private Sub cboTeam_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboTeam.SelectedIndexChanged
        If mExportSetType = ExportSetType.CmsHcahps OrElse mExportSetType = ExportSetType.CmsHHcahps OrElse mExportSetType = ExportSetType.ACOCAHPS OrElse mExportSetType = ExportSetType.CmsChart Then
            Dim createToolItem As ToolStripItem = DefinedDefinitionToolStrip.Items("DefinedDefinitionCreateTSButton")
            'If Not String.IsNullOrEmpty(CreateDefinitionNameTextBox.Text) Then
            createToolItem.Visible = True
            'End If
        End If
    End Sub

End Class
