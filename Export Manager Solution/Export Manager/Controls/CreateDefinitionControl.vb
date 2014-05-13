Imports System.ComponentModel
Imports Nrc.DataMart.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class CreateDefinitionControl

    Public Enum DateMode
        None = 0
        StartAndEndDate = 1
        SingleMonth = 2
    End Enum

    Public Enum CreationOptions
        None = 0
        ExportToIndividualFiles = 1
        ExportToCombinedFile = 2
    End Enum

    Private mNewDefinitionCount As Integer
    Private mDateSelectionMode As DateMode = DateMode.StartAndEndDate
    Private mAllowCreateDefinition As Boolean
    Private mExportSetType As ExportSetType
    Private WithEvents mNavigator As ClientStudySurveyNavigator

#Region " NewExportSetsCreated Event "
    Public Class NewExportSetsCreatedEventArgs
        Inherits System.EventArgs

        Private mNewExportSets As Collection(Of ExportSet)
        Private mOptions As CreationOptions = CreationOptions.None


        Public ReadOnly Property NewExportSets() As Collection(Of ExportSet)
            Get
                Return mNewExportSets
            End Get
        End Property
        Public ReadOnly Property CreationOptions() As CreationOptions
            Get
                Return mOptions
            End Get
        End Property

        Public Sub New(ByVal newExportSets As Collection(Of ExportSet))
            Me.New(newExportSets, CreationOptions.None)
        End Sub

        Public Sub New(ByVal newExportSets As Collection(Of ExportSet), ByVal options As CreationOptions)
            Me.mNewExportSets = newExportSets
            Me.mOptions = options
        End Sub

    End Class
    Public Event NewExportSetsCreated As EventHandler(Of NewExportSetsCreatedEventArgs)
    Protected Sub OnNewExportSetsCreated(ByVal e As NewExportSetsCreatedEventArgs)
        RaiseEvent NewExportSetsCreated(Me, e)
    End Sub
#End Region

    Public Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.Enabled = False
        Me.InitializeMonthList()
        Me.InitializeYearList()
        Me.InitializeDateFields()
    End Sub

#Region " Private Properties "
    Private ReadOnly Property IsControlEnabled() As Boolean
        Get
            Select Case Me.mExportSetType
                Case Library.ExportSetType.Standard
                    Return (mNavigator.SelectedClientIds.Count = 0 _
                        AndAlso mNavigator.SelectedStudyIds.Count = 0 _
                        AndAlso mNavigator.SelectedSurveyIds.Count > 0 _
                        AndAlso mNavigator.SelectedUnitIds.Count = 0)
                Case Library.ExportSetType.CmsHcahps, Library.ExportSetType.CmsHHcahps, Library.ExportSetType.CmsChart
                    Return (mNavigator.SelectedClientIds.Count = 0 _
                        AndAlso mNavigator.SelectedStudyIds.Count = 0 _
                        AndAlso mNavigator.SelectedSurveyIds.Count = 0 _
                        AndAlso mNavigator.SelectedUnitIds.Count > 0)
            End Select

            Return False
        End Get
    End Property

    Private ReadOnly Property IsCreateDefinitionButtonEnabled() As Boolean
        Get
            If Me.NewExportName.Text.Trim.Length = 0 Then
                Return False
            End If

            If Me.NewExportStartDate.Value > Me.NewExportEndDate.Value Then
                Return False
            End If

            Return True
        End Get
    End Property

    Private ReadOnly Property IsCreateDefinitionAndExportCombinedButtonEnabled() As Boolean
        Get
            Select Case mExportSetType
                Case Library.ExportSetType.Standard
                    If mNavigator.SelectedSurveyIds.Count < 2 Then
                        Return False
                    End If
                    If mNavigator.SelectedSurveyIds.Count > AppConfig.Params("EMMaxExportCombinationCount").IntegerValue Then
                        Return False
                    End If
                Case Library.ExportSetType.CmsHcahps, Library.ExportSetType.CmsHHcahps, Library.ExportSetType.CmsChart
                    If mNavigator.SelectedUnitIds.Count < 2 Then
                        Return False
                    End If
                    If mNavigator.SelectedUnitIds.Count > AppConfig.Params("EMMaxExportCombinationCount").IntegerValue Then
                        Return False
                    End If
            End Select

            Return True
        End Get
    End Property
#End Region

#Region " Public Properties "
    <Browsable(False)> _
    Public Property Navigator() As ClientStudySurveyNavigator
        Get
            Return mNavigator
        End Get
        Set(ByVal value As ClientStudySurveyNavigator)
            mNavigator = value
        End Set
    End Property

    Public Property DateSelectionMode() As DateMode
        Get
            Return mDateSelectionMode
        End Get
        Set(ByVal value As DateMode)
            If value <> mDateSelectionMode Then
                mDateSelectionMode = value
                Me.InitializeDateFields()
            End If
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

#Region " Event Handlers "
    Private Sub CreateDefinitionControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Initialize the export creation date range
        'Default to last quarter
        Me.NewExportStartDate.Value = Me.GetLastQuarterStartDate
        Me.NewExportEndDate.Value = Me.NewExportStartDate.Value.AddMonths(3).AddDays(-1)
    End Sub

    ''' <summary>When the client, study, or survey is selected/changed</summary>
    Private Sub mNavigator_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mNavigator.SelectionChanged

        Dim exportCount As Integer = 0
        Select Case mExportSetType
            Case Library.ExportSetType.Standard
                exportCount = Me.mNavigator.SelectedSurveyIds.Count
            Case Library.ExportSetType.CmsHcahps, Library.ExportSetType.CmsHHcahps, Library.ExportSetType.CmsChart
                exportCount = Me.mNavigator.SelectedUnitIds.Count
        End Select
        Me.NewExportCountLabel.Text = String.Format("{0} Export Definition(s) will be created.", exportCount)
        Me.Enabled = Me.IsControlEnabled
        Me.CreateDefinitionButton.Enabled = Me.IsCreateDefinitionButtonEnabled
        Me.CreateDefinitionAndExportCombined.Enabled = Me.IsCreateDefinitionAndExportCombinedButtonEnabled
    End Sub

    Private Sub CreateDefinitionButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CreateDefinitionButton.ButtonClick
        Me.CreateDefinition(CreationOptions.None)
    End Sub

    Private Sub CreateDefinitionAndExportIndividual_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CreateDefinitionAndExportIndividual.Click
        Me.CreateDefinition(CreationOptions.ExportToIndividualFiles)
    End Sub

    Private Sub CreateDefinitionAndExportCombined_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CreateDefinitionAndExportCombined.Click
        Me.CreateDefinition(CreationOptions.ExportToCombinedFile)
    End Sub

    Private Sub ExportSetName_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles NewExportName.TextChanged
        Me.CreateDefinitionButton.Enabled = Me.IsCreateDefinitionButtonEnabled
    End Sub

    Private Sub EncounterStartDate_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles NewExportStartDate.TextChanged, NewExportEndDate.TextChanged
        Me.CreateDefinitionButton.Enabled = Me.IsCreateDefinitionButtonEnabled
    End Sub

    Private Sub PredefineButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PredefineButton.Click

        Dim dialog As New PredefinitionWizardDialog(mDateSelectionMode, mExportSetType, mNavigator)
        If dialog.ShowDialog() = DialogResult.OK Then
            'Raise the event to notify listeners that new export sets have been created
            Dim eArgs As New NewExportSetsCreatedEventArgs(dialog.NewExportSets, CreationOptions.None)
            Me.OnNewExportSetsCreated(eArgs)
        End If

    End Sub
#End Region

#Region " Private Methods "
    Private Sub InitializeMonthList()
        Dim months As New List(Of MonthListItem)
        months.Add(New MonthListItem("January", 1))
        months.Add(New MonthListItem("February", 2))
        months.Add(New MonthListItem("March", 3))
        months.Add(New MonthListItem("April", 4))
        months.Add(New MonthListItem("May", 5))
        months.Add(New MonthListItem("June", 6))
        months.Add(New MonthListItem("July", 7))
        months.Add(New MonthListItem("August", 8))
        months.Add(New MonthListItem("September", 9))
        months.Add(New MonthListItem("October", 10))
        months.Add(New MonthListItem("November", 11))
        months.Add(New MonthListItem("December", 12))
        Me.MonthList.DisplayMember = "MonthName"
        Me.MonthList.ValueMember = "MonthNumber"
        Me.MonthList.DataSource = months
        Me.MonthList.SelectedValue = Date.Today.Month
    End Sub

    Private Sub InitializeYearList()
        Dim startYear As Integer = Date.Today.Year - 5

        For i As Integer = 0 To 10
            Me.YearList.Items.Add(startYear + i)
        Next

        Me.YearList.SelectedItem = Date.Today.Year
    End Sub

    Private Sub InitializeDateFields()
        Me.InputPanel.Controls.Clear()
        Me.InputPanel.Controls.Add(Me.NameLabel)
        Me.InputPanel.Controls.Add(Me.NewExportName)

        Select Case mDateSelectionMode
            Case DateMode.StartAndEndDate
                Me.InputPanel.Controls.Add(Me.StartDateLabel)
                Me.InputPanel.Controls.Add(Me.NewExportStartDate)
                Me.InputPanel.Controls.Add(Me.EndDateLabel)
                Me.InputPanel.Controls.Add(Me.NewExportEndDate)
            Case DateMode.SingleMonth
                Me.InputPanel.Controls.Add(Me.MonthLabel)
                Me.InputPanel.Controls.Add(Me.MonthList)
                Me.InputPanel.Controls.Add(Me.YearLabel)
                Me.InputPanel.Controls.Add(Me.YearList)
            Case Else
                Me.InputPanel.Controls.Add(Me.StartDateLabel)
                Me.InputPanel.Controls.Add(Me.NewExportStartDate)
                Me.InputPanel.Controls.Add(Me.EndDateLabel)
                Me.InputPanel.Controls.Add(Me.NewExportEndDate)
        End Select

    End Sub

    Private Function GetLastQuarterStartDate() As Date
        Dim qtrStart As Date = Date.Now
        qtrStart = qtrStart.AddMonths(-3)
        Dim qtrMonth As Integer = CType(Math.Ceiling(qtrStart.Month / 3), Integer)
        qtrMonth = (qtrMonth * 3) - 2

        Return Date.Parse(String.Format("{0}/1/{1}", qtrMonth, qtrStart.Year))
    End Function

    Private Sub CreateDefinition(ByVal options As CreationOptions)
        Try
            Me.ParentForm.Cursor = Cursors.WaitCursor
            Dim newExportSets As New Collection(Of ExportSet)

            Select Case mExportSetType
                Case ExportSetType.Standard
                    For Each id As Integer In Me.mNavigator.SelectedSurveyIds
                        newExportSets.Add(ExportSet.CreateNewExportSet(Me.NewExportName.Text, id, NewExportStartDate.Value, NewExportEndDate.Value, ExportSetType.Standard, CurrentUser.UserName))
                    Next
                Case ExportSetType.CmsHcahps
                    Dim month As Integer = CType(MonthList.SelectedValue, Integer)
                    Dim year As Integer = CType(YearList.SelectedItem, Integer)
                    Dim startDate As Date = Date.Parse(month & "/1/" & year)
                    Dim endDate As Date = startDate.AddMonths(1).AddDays(-1)

                    For Each unit As SampleUnit In Me.mNavigator.SelectedUnits
                        newExportSets.Add(ExportSet.CreateNewExportSet(Me.NewExportName.Text, unit.SurveyId, unit.Id, startDate, endDate, ExportSetType.CmsHcahps, CurrentUser.UserName))
                    Next
                Case ExportSetType.CmsHHcahps
                    Dim month As Integer = CType(MonthList.SelectedValue, Integer)
                    Dim year As Integer = CType(YearList.SelectedItem, Integer)
                    Dim startDate As Date = Date.Parse(month & "/1/" & year)
                    Dim endDate As Date = startDate.AddMonths(1).AddDays(-1)

                    For Each unit As SampleUnit In Me.mNavigator.SelectedUnits
                        newExportSets.Add(ExportSet.CreateNewExportSet(Me.NewExportName.Text, unit.SurveyId, unit.Id, startDate, endDate, ExportSetType.CmsHHcahps, CurrentUser.UserName))
                    Next
                Case ExportSetType.CmsChart
                    Dim month As Integer = CType(MonthList.SelectedValue, Integer)
                    Dim year As Integer = CType(YearList.SelectedItem, Integer)
                    Dim startDate As Date = Date.Parse(month & "/1/" & year)
                    Dim endDate As Date = startDate.AddMonths(1).AddDays(-1)

                    For Each unit As SampleUnit In Me.mNavigator.SelectedUnits
                        newExportSets.Add(ExportSet.CreateNewExportSet(Me.NewExportName.Text, unit.SurveyId, unit.Id, startDate, endDate, ExportSetType.CmsChart, CurrentUser.UserName))
                    Next
            End Select

            'Raise the event to notify listeners that new export sets have been created
            Dim e As New NewExportSetsCreatedEventArgs(newExportSets, options)
            Me.OnNewExportSetsCreated(e)

            'Reset controls
            Me.NewExportName.Text = ""
            Me.CreateDefinitionButton.Enabled = Me.IsCreateDefinitionButtonEnabled
        Finally
            Me.ParentForm.Cursor = Cursors.Default
        End Try
    End Sub

#End Region


End Class
