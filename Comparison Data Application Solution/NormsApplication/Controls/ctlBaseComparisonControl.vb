Imports NormsApplicationBusinessObjectsLibrary

Public Class ctlBaseComparisonControl
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
    Protected WithEvents btnSubmit As System.Windows.Forms.Button
    Protected WithEvents pnlBaseComparisonControl As NRC.WinForms.SectionPanel
    Protected WithEvents btnClear As System.Windows.Forms.Button
    Friend WithEvents tbcComparison As System.Windows.Forms.TabControl
    Friend WithEvents tbPFilter As System.Windows.Forms.TabPage
    Friend WithEvents tbpQuestionDimensions As System.Windows.Forms.TabPage
    Friend WithEvents ctlFilterBuilder As NormsApplication.FilterBuilder
    Friend WithEvents ctlDateChooser As NormsApplication.Date_Chooser
    Friend WithEvents ctlDimensionSelector As NormsApplication.DimensionSelector
    Friend WithEvents ctlQuestionSelector As NormsApplication.QuestionSelector
    Friend WithEvents ctlUseFacilitiesCheck As NormsApplication.UseFacilitiesCheck
    Friend WithEvents ctlMinClientCheck As NormsApplication.MinClientCheck
    Friend WithEvents ctlMeasureGrouping As NormsApplication.MeasureGroupSelector
    Friend WithEvents tbpAdditionalOptions As System.Windows.Forms.TabPage
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.pnlBaseComparisonControl = New NRC.WinForms.SectionPanel
        Me.tbcComparison = New System.Windows.Forms.TabControl
        Me.tbPFilter = New System.Windows.Forms.TabPage
        Me.ctlFilterBuilder = New NormsApplication.FilterBuilder
        Me.tbpQuestionDimensions = New System.Windows.Forms.TabPage
        Me.ctlDimensionSelector = New NormsApplication.DimensionSelector
        Me.ctlQuestionSelector = New NormsApplication.QuestionSelector
        Me.tbpAdditionalOptions = New System.Windows.Forms.TabPage
        Me.ctlUseFacilitiesCheck = New NormsApplication.UseFacilitiesCheck
        Me.ctlMinClientCheck = New NormsApplication.MinClientCheck
        Me.ctlMeasureGrouping = New NormsApplication.MeasureGroupSelector
        Me.ctlDateChooser = New NormsApplication.Date_Chooser
        Me.btnClear = New System.Windows.Forms.Button
        Me.btnSubmit = New System.Windows.Forms.Button
        Me.pnlBaseComparisonControl.SuspendLayout()
        Me.tbcComparison.SuspendLayout()
        Me.tbPFilter.SuspendLayout()
        Me.tbpQuestionDimensions.SuspendLayout()
        Me.tbpAdditionalOptions.SuspendLayout()
        Me.SuspendLayout()
        '
        'pnlBaseComparisonControl
        '
        Me.pnlBaseComparisonControl.AutoScroll = True
        Me.pnlBaseComparisonControl.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.pnlBaseComparisonControl.Caption = ""
        Me.pnlBaseComparisonControl.Controls.Add(Me.tbcComparison)
        Me.pnlBaseComparisonControl.Controls.Add(Me.btnClear)
        Me.pnlBaseComparisonControl.Controls.Add(Me.btnSubmit)
        Me.pnlBaseComparisonControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlBaseComparisonControl.DockPadding.All = 1
        Me.pnlBaseComparisonControl.Location = New System.Drawing.Point(0, 0)
        Me.pnlBaseComparisonControl.Name = "pnlBaseComparisonControl"
        Me.pnlBaseComparisonControl.ShowCaption = True
        Me.pnlBaseComparisonControl.Size = New System.Drawing.Size(808, 776)
        Me.pnlBaseComparisonControl.TabIndex = 0
        '
        'tbcComparison
        '
        Me.tbcComparison.Controls.Add(Me.tbPFilter)
        Me.tbcComparison.Controls.Add(Me.tbpQuestionDimensions)
        Me.tbcComparison.Controls.Add(Me.tbpAdditionalOptions)
        Me.tbcComparison.Location = New System.Drawing.Point(8, 48)
        Me.tbcComparison.Name = "tbcComparison"
        Me.tbcComparison.SelectedIndex = 0
        Me.tbcComparison.Size = New System.Drawing.Size(792, 664)
        Me.tbcComparison.TabIndex = 33
        '
        'tbPFilter
        '
        Me.tbPFilter.Controls.Add(Me.ctlFilterBuilder)
        Me.tbPFilter.Location = New System.Drawing.Point(4, 22)
        Me.tbPFilter.Name = "tbPFilter"
        Me.tbPFilter.Size = New System.Drawing.Size(784, 638)
        Me.tbPFilter.TabIndex = 0
        Me.tbPFilter.Text = "Filter Statement"
        '
        'ctlFilterBuilder
        '
        Me.ctlFilterBuilder.Location = New System.Drawing.Point(0, 0)
        Me.ctlFilterBuilder.Name = "ctlFilterBuilder"
        Me.ctlFilterBuilder.Size = New System.Drawing.Size(792, 520)
        Me.ctlFilterBuilder.TabIndex = 0
        Me.ctlFilterBuilder.UseProduction = True
        '
        'tbpQuestionDimensions
        '
        Me.tbpQuestionDimensions.Controls.Add(Me.ctlDimensionSelector)
        Me.tbpQuestionDimensions.Controls.Add(Me.ctlQuestionSelector)
        Me.tbpQuestionDimensions.Location = New System.Drawing.Point(4, 22)
        Me.tbpQuestionDimensions.Name = "tbpQuestionDimensions"
        Me.tbpQuestionDimensions.Size = New System.Drawing.Size(784, 638)
        Me.tbpQuestionDimensions.TabIndex = 2
        Me.tbpQuestionDimensions.Text = "Questions/Dimensions"
        '
        'ctlDimensionSelector
        '
        Me.ctlDimensionSelector.Location = New System.Drawing.Point(10, 320)
        Me.ctlDimensionSelector.Name = "ctlDimensionSelector"
        Me.ctlDimensionSelector.SelectedDimensions = ""
        Me.ctlDimensionSelector.SingleSelect = NormsApplication.DimensionSelector.SelectionType.MultipleSelect
        Me.ctlDimensionSelector.Size = New System.Drawing.Size(750, 322)
        Me.ctlDimensionSelector.TabIndex = 1
        '
        'ctlQuestionSelector
        '
        Me.ctlQuestionSelector.Location = New System.Drawing.Point(10, 8)
        Me.ctlQuestionSelector.Name = "ctlQuestionSelector"
        Me.ctlQuestionSelector.SelectedQuestions = ""
        Me.ctlQuestionSelector.Size = New System.Drawing.Size(646, 312)
        Me.ctlQuestionSelector.TabIndex = 0
        '
        'tbpAdditionalOptions
        '
        Me.tbpAdditionalOptions.Controls.Add(Me.ctlUseFacilitiesCheck)
        Me.tbpAdditionalOptions.Controls.Add(Me.ctlMinClientCheck)
        Me.tbpAdditionalOptions.Controls.Add(Me.ctlMeasureGrouping)
        Me.tbpAdditionalOptions.Controls.Add(Me.ctlDateChooser)
        Me.tbpAdditionalOptions.Location = New System.Drawing.Point(4, 22)
        Me.tbpAdditionalOptions.Name = "tbpAdditionalOptions"
        Me.tbpAdditionalOptions.Size = New System.Drawing.Size(784, 638)
        Me.tbpAdditionalOptions.TabIndex = 3
        Me.tbpAdditionalOptions.Text = "Dates/Additional Options"
        '
        'ctlUseFacilitiesCheck
        '
        Me.ctlUseFacilitiesCheck.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ctlUseFacilitiesCheck.Location = New System.Drawing.Point(156, 498)
        Me.ctlUseFacilitiesCheck.Name = "ctlUseFacilitiesCheck"
        Me.ctlUseFacilitiesCheck.Size = New System.Drawing.Size(472, 104)
        Me.ctlUseFacilitiesCheck.TabIndex = 30
        Me.ctlUseFacilitiesCheck.UseFacilities = False
        '
        'ctlMinClientCheck
        '
        Me.ctlMinClientCheck.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ctlMinClientCheck.Location = New System.Drawing.Point(156, 190)
        Me.ctlMinClientCheck.MinClientCheck = True
        Me.ctlMinClientCheck.Name = "ctlMinClientCheck"
        Me.ctlMinClientCheck.Size = New System.Drawing.Size(472, 104)
        Me.ctlMinClientCheck.TabIndex = 29
        '
        'ctlMeasureGrouping
        '
        Me.ctlMeasureGrouping.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ctlMeasureGrouping.Location = New System.Drawing.Point(156, 344)
        Me.ctlMeasureGrouping.Name = "ctlMeasureGrouping"
        Me.ctlMeasureGrouping.Size = New System.Drawing.Size(472, 104)
        Me.ctlMeasureGrouping.TabIndex = 28
        '
        'ctlDateChooser
        '
        Me.ctlDateChooser.Anchor = CType((System.Windows.Forms.AnchorStyles.Left Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ctlDateChooser.Location = New System.Drawing.Point(156, 36)
        Me.ctlDateChooser.Maxdate = New Date(2005, 4, 20, 10, 39, 47, 765)
        Me.ctlDateChooser.Mindate = New Date(2005, 4, 20, 10, 39, 47, 765)
        Me.ctlDateChooser.Name = "ctlDateChooser"
        Me.ctlDateChooser.Size = New System.Drawing.Size(472, 104)
        Me.ctlDateChooser.TabIndex = 0
        '
        'btnClear
        '
        Me.btnClear.Location = New System.Drawing.Point(460, 728)
        Me.btnClear.Name = "btnClear"
        Me.btnClear.Size = New System.Drawing.Size(96, 23)
        Me.btnClear.TabIndex = 31
        Me.btnClear.Text = "Clear Selections"
        '
        'btnSubmit
        '
        Me.btnSubmit.Location = New System.Drawing.Point(252, 728)
        Me.btnSubmit.Name = "btnSubmit"
        Me.btnSubmit.TabIndex = 23
        Me.btnSubmit.Text = "Submit"
        '
        'ctlBaseComparisonControl
        '
        Me.AutoScroll = True
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.Controls.Add(Me.pnlBaseComparisonControl)
        Me.Name = "ctlBaseComparisonControl"
        Me.Size = New System.Drawing.Size(808, 776)
        Me.pnlBaseComparisonControl.ResumeLayout(False)
        Me.tbcComparison.ResumeLayout(False)
        Me.tbPFilter.ResumeLayout(False)
        Me.tbpQuestionDimensions.ResumeLayout(False)
        Me.tbpAdditionalOptions.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

	Protected mActiveQuery As New ComparisonDataQuery

#Region "Public Properties"
	Public Property ActiveQuery As ComparisonDataQuery
		Get
			Return mActiveQuery
		End Get
		Set (ByVal Value as ComparisonDataQuery)
            mActiveQuery = Value
            loadPreviousSettings()
		End Set
	End Property

#End Region


    Protected Function VerifyQuestionsDimensions() As Boolean
        If ctlQuestionSelector.SelectedQuestions = "" And ctlDimensionSelector.SelectedDimensions = "" Then
            MsgBox("You must select at least 1 question or dimension.", MsgBoxStyle.Critical, "Verification of Question and Dimension Selections")
            Return False
        End If
        Return True
    End Function

    Protected Function FilterValue() As String
        Return ctlFilterBuilder.FilterValue()
    End Function

    Protected Function MinDate() As DateTime
        Return ctlDateChooser.Mindate
    End Function

    Protected Function MaxDate() As DateTime
        Return ctlDateChooser.Maxdate
    End Function

    Protected Function MinClientCheck() As Boolean
        Return ctlMinClientCheck.MinClientCheck
    End Function

    Protected Function UseFacilities() As Boolean
        Return ctlUseFacilitiesCheck.UseFacilities
    End Function

    Protected Function SelectedGroupID() As Integer
        Return ctlMeasureGrouping.SelectedGroupID()
    End Function

    Protected Function DimensionsList() As String
        If ctlDimensionSelector.SelectedDimensions <> "" Then
            Return ctlDimensionSelector.SelectedDimensions
        Else
            Return ""
        End If
    End Function

    Protected Function QuestionsList() As String
        If ctlQuestionSelector.SelectedQuestions <> "" Then
            Return ctlQuestionSelector.SelectedQuestions
        Else
            Return ""
        End If
    End Function

    Protected Sub PopulateMeasures()
        ctlMeasureGrouping.PopulateMeasures()
    End Sub

    Protected Sub PopulateQuestions()
        ctlQuestionSelector.PopulateQuestions()
    End Sub

    Protected Sub PopulateDimensions()
        ctlDimensionSelector.PopulateDimensions()
    End Sub

    Private Sub Reset()
        ctlFilterBuilder.txtCriteria.Text = ""
        ctlDimensionSelector.txtDimensions.Text = ""
        ctlQuestionSelector.txtQuestions.Text = ""
        ctlUseFacilitiesCheck.chkFacilityPercentiles.Checked = False
        ctlMinClientCheck.chkMinClientCheck.Checked = True
        ctlMeasureGrouping.PopulateMeasures()
        ctlFilterBuilder.lstNormsList.SelectedIndex = -1
        ctlFilterBuilder.lstFilterValues.SelectedIndex = -1
        ctlFilterBuilder.lstFilterColumns.SelectedIndex = -1
        mActiveQuery = New ComparisonDataQuery(mActiveQuery.ReportType)
    End Sub

    Private Sub btnClear_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClear.Click
        Reset()
    End Sub

    Private Sub ctlFilterBuilder_NormCriteriaAdded(ByVal startDate As DateTime, ByVal enddate As DateTime) Handles ctlFilterBuilder.NormCriteriaAdded
        ctlDateChooser.dtpMindate.Value = startDate
        ctlDateChooser.dtpMaxdate.Value = enddate
    End Sub

    Protected Sub UpdateActiveQuery()
        If ctlMeasureGrouping.Enabled Then
            For Each group As Groupings In DataAccess.GetMeasures
                If ctlMeasureGrouping.SelectedGroupID = group.GroupingID Then
                    mActiveQuery.GroupingType = group
                    Exit For
                End If
            Next
        End If
        If ctlQuestionSelector.Enabled Then mActiveQuery.QuestionList = QuestionsList()
        If ctlDimensionSelector.Enabled Then mActiveQuery.DimensionList = DimensionsList()
        mActiveQuery.Criteria = FilterValue()
        If ctlMinClientCheck.Enabled Then mActiveQuery.IncludeCustomQuestions = ctlMinClientCheck.MinClientCheck
        mActiveQuery.MinDate = MinDate.Date
        mActiveQuery.MaxDate = MaxDate.Date
        If ctlUseFacilitiesCheck.Enabled Then mActiveQuery.UseFacilites = ctlUseFacilitiesCheck.UseFacilities
    End Sub

    Private Function getParams() As ParametersCollection
        Dim Params As New ParametersCollection
        With mActiveQuery
            Params.Add(.Criteria)
            Params.Add(.MinDate.ToShortDateString)
            Params.Add(.MaxDate.ToShortDateString + " 23:59:59")
            Select Case mActiveQuery.ReportType
                Case ComparisonDataQuery.enuReportType.QuestionUsers, ComparisonDataQuery.enuReportType.QuestionCounts
                    Params.Add(.QuestionList)
                    If .IncludeCustomQuestions Then
                        Params.Add("1")
                    Else : Params.Add("0")
                    End If
                Case ComparisonDataQuery.enuReportType.Frequencies
                    Params.Add(.QuestionList)
                    Params.Add(.DimensionList)
                    If .IncludeCustomQuestions Then
                        Params.Add("1")
                    Else : Params.Add("0")
                    End If
                Case ComparisonDataQuery.enuReportType.AverageScores, ComparisonDataQuery.enuReportType.GroupRanksAndScores, ComparisonDataQuery.enuReportType.Percentiles1to100
                    Params.Add(.QuestionList)
                    Params.Add(.DimensionList)
                    If .IncludeCustomQuestions Then
                        Params.Add("1")
                    Else : Params.Add("0")
                    End If
                    If .UseFacilites Then
                        Params.Add("1")
                    Else : Params.Add("0")
                    End If
                    Params.Add(.GroupingType.GroupingID.ToString)
            End Select
        End With
        Return Params

    End Function

    Private Sub loadPreviousSettings()
        With mActiveQuery
            If ctlMeasureGrouping.Enabled Then
                For Each group As Groupings In ctlMeasureGrouping.cboMeasure.Items
                    If group.GroupingID = .GroupingType.GroupingID Then ctlMeasureGrouping.cboMeasure.SelectedItem = group
                Next
            End If
            If ctlQuestionSelector.Enabled Then ctlQuestionSelector.txtQuestions.Text = .QuestionList
            If ctlDimensionSelector.Enabled Then ctlDimensionSelector.txtDimensions.Text = .DimensionList
            ctlFilterBuilder.txtCriteria.Text = .Criteria
            If ctlMinClientCheck.Enabled Then ctlMinClientCheck.chkMinClientCheck.Checked = .IncludeCustomQuestions
            ctlDateChooser.Mindate = .MinDate
            ctlDateChooser.Maxdate = .MaxDate
            If ctlUseFacilitiesCheck.Enabled Then ctlUseFacilitiesCheck.chkFacilityPercentiles.Checked = .UseFacilites
        End With
    End Sub

    Private Sub SaveNewQuery()
        Dim newID As Integer
        Dim labelAndDescriptionDialog As New QueryLabelandDescriptionDialog
        labelAndDescriptionDialog.ShowDialog()
        If labelAndDescriptionDialog.DialogResult = DialogResult.OK Then
            mActiveQuery.Label = labelAndDescriptionDialog.txtLabel.Text
            mActiveQuery.Description = labelAndDescriptionDialog.txtDescription.Text
            newID = ComparisonDataQuery.Insert(mActiveQuery.ReportType, mActiveQuery.Label, mActiveQuery.Description, True, CurrentUser.Member.MemberId, getParams())
            mActiveQuery.UpdateSaving(newID)
        End If
    End Sub

    Protected Sub Submit()
        Dim strURL As String = String.Empty
        Dim newID As Integer
        UpdateActiveQuery()
        Try
            If mActiveQuery.NeedsSave Then
                Dim UpdateDialog As New UpdateQueryDialog
                'Check to see if this is a new query or existing one.  If isSelectable is true, it is an existing query
                If mActiveQuery.IsSelectable Then
                    'Ask if they want to update, saveAs, or don't save
                    UpdateDialog.ShowDialog()
                    If UpdateDialog.SelectedButton = UpdateQueryDialog.ButtonPressed.Save Then
                        'Delete doesn't truly delete.  It just sets the isSelectable property to false
                        newID = ComparisonDataQuery.Update(mActiveQuery.ReportType, mActiveQuery.Label, mActiveQuery.Description, CurrentUser.Member.MemberId, getParams(), mActiveQuery.ParentReportID)
                        mActiveQuery.UpdateSaving(newID)
                    ElseIf UpdateDialog.SelectedButton = UpdateQueryDialog.ButtonPressed.SaveAs Then
                        SaveNewQuery()
                    End If
                Else
                    'Ask if they want to save
                    UpdateDialog.btnSaveAs.Visible = False
                    UpdateDialog.ShowDialog()
                    If UpdateDialog.SelectedButton = UpdateQueryDialog.ButtonPressed.Save Then
                        SaveNewQuery()
                    End If
                End If
            End If

            'If they have chosen to save the query in prior code, the NeedsSave property will return false
            'Therefore, this code is only run if they picked cancel when prompted to save
            If mActiveQuery.NeedsSave Then
                'When they hit submit we will create a new report in the database.  We do not specify label or description
                'since they have not asked us to save this for later retrieval
                newID = ComparisonDataQuery.Insert(mActiveQuery.ReportType, mActiveQuery.Label, mActiveQuery.Description, False, CurrentUser.Member.MemberId, getParams())
                mActiveQuery.ID = newID
                mActiveQuery.IsSelectable = False
                'We don't set the needs save property to false here because this report is 
                'different from the original so we still want to ask them to save changes
            End If
        Catch ex As Exception
            ReportException(ex, "Error Saving")
            Exit Sub
        End Try

        Select Case mActiveQuery.ReportType
            Case ComparisonDataQuery.enuReportType.DemographicCounts
                strURL = Config.ReportServer + "Demographic+Counts&rs:Command=Render&rc:Parameters=false&NormReport_ID=" + mActiveQuery.ID.ToString
            Case ComparisonDataQuery.enuReportType.QuestionUsers
                strURL = Config.ReportServer + "Question+Users&rs:Command=Render&rc:Parameters=false&NormReport_ID=" + mActiveQuery.ID.ToString
            Case ComparisonDataQuery.enuReportType.QuestionCounts
                strURL = Config.ReportServer + "Question+Counts&rs:Command=Render&rc:Parameters=false&NormReport_ID=" + mActiveQuery.ID.ToString
            Case ComparisonDataQuery.enuReportType.Frequencies
                strURL = Config.ReportServer + "Frequencies&rs:Command=Render&rc:Parameters=false&NormReport_ID=" + mActiveQuery.ID.ToString
            Case ComparisonDataQuery.enuReportType.AverageScores
                strURL = Config.ReportServer + "Scores&rs:Command=Render&rc:Parameters=false&NormReport_ID=" + mActiveQuery.ID.ToString
            Case ComparisonDataQuery.enuReportType.GroupRanksAndScores
                strURL = Config.ReportServer + "Group+Scores+And+Percentiles&rs:Command=Render&rc:Parameters=false&NormReport_ID=" + mActiveQuery.ID.ToString
            Case ComparisonDataQuery.enuReportType.Percentiles1to100
                strURL = Config.ReportServer + "Percentiles+1+to+100&rs:Command=Render&rc:Parameters=false&NormReport_ID=" + mActiveQuery.ID.ToString
        End Select
        System.Diagnostics.Process.Start("IExplore", strURL)
        ComparisonDataQuery.LogSubmittedReport(mActiveQuery.ID, CurrentUser.Member.MemberId)
    End Sub

    Private Sub btnSubmit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Submit()
    End Sub
End Class
