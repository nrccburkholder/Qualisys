Imports Nrc.SurveyPoint.Library

Public Class ExportSection
#Region "Private Members"

    Private mSubSection As Section
    Private mMode As ExportConfigurationButtonEnum

    Friend WithEvents mNavigator As ExportNavigator

#End Region

#Region "Baseclass Overrides"

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavigator = DirectCast(navCtrl, ExportNavigator)

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        If mSubSection Is Nothing Then
            Return True
        Else
            Return mSubSection.AllowInactivate
        End If

    End Function

#End Region

#Region "Events"

    Private Sub mNavigator_ButtonClicked(ByVal sender As Object, ByVal e As ExportButtonClickedEventArgs) Handles mNavigator.ButtonClicked

        'TODO: Check with Jeff about memory allocation; 
        If Not mSubSection Is Nothing Then mSubSection = Nothing


        'Check to see if we are allowed to switch views
        If Not AllowInactivate() Then
            Exit Sub
        End If

        'Clear the current control
        Me.Controls.Clear()

        'Create the new control

        Select Case e.ButtonClicked
            Case ExportConfigurationButtonEnum.Configuration
                mMode = ExportConfigurationButtonEnum.Configuration
                mSubSection = New ExportConfigurationSection(Me, e.ExportGroupID)

            Case ExportConfigurationButtonEnum.Run
                mMode = ExportConfigurationButtonEnum.Run
                mSubSection = New ExportRunSection(e.ExportGroupID)


            Case ExportConfigurationButtonEnum.ReRun
                mMode = ExportConfigurationButtonEnum.ReRun
                Dim exportFileLog As ExportFileLog = exportFileLog.Get(e.LogFileID)
                mSubSection = New ExportRunSection(exportFileLog)



            Case ExportConfigurationButtonEnum.ViewLog
                mMode = ExportConfigurationButtonEnum.ViewLog
                mSubSection = New ViewExportLogSection(Me, e.ExportGroupID)

            Case ExportConfigurationButtonEnum.NewExportGroup
                mMode = ExportConfigurationButtonEnum.NewExportGroup
                'Create the new control if there's none already created
                If Not mSubSection Is Nothing Then mSubSection = Nothing
                mSubSection = New ExportConfigurationSection(Me)


        End Select

        'Display the new control
        mSubSection.Dock = DockStyle.Fill
        Me.Controls.Add(mSubSection)

    End Sub

    Private Sub mNavigator_ExportGroupSelected(ByVal sender As Object, ByVal e As ExportGroupSelectedEventArgs) Handles mNavigator.ExportGroupSelected

  

        'Check to see if we are allowed to switch views
        If Not AllowInactivate() Then
            Exit Sub
        End If
        'If no export exists and a sub section does, remove it.
        If e.SelectedExportGroupID = 0 AndAlso Not mSubSection Is Nothing Then
            Me.Controls.Remove(mSubSection)
            mSubSection = Nothing
            'Create the new control if there's none already created
        ElseIf mSubSection Is Nothing Then
            mSubSection = New ExportConfigurationSection(Me, e.SelectedExportGroupID)
            'Display the new control
            mSubSection.Dock = DockStyle.Fill
            Me.Controls.Add(mSubSection)
        Else
            Select Case mMode
                Case ExportConfigurationButtonEnum.Configuration
                    TryCast(mSubSection, ExportConfigurationSection).LoadExportGroup(e.SelectedExportGroupID)
                Case ExportConfigurationButtonEnum.NewExportGroup
                    TryCast(mSubSection, ExportConfigurationSection).LoadExportGroup(e.SelectedExportGroupID)
                Case ExportConfigurationButtonEnum.Delete
                    TryCast(mSubSection, ExportConfigurationSection).LoadExportGroup(e.SelectedExportGroupID)
                Case ExportConfigurationButtonEnum.Run
                    If e.SelectedExportGroupID > 0 Then TryCast(mSubSection, ExportRunSection).LoadExportGroup(mMode, e.SelectedExportGroupID)
                Case ExportConfigurationButtonEnum.ReRun
                    If e.SelectedExportGroupID > 0 Then TryCast(mSubSection, ExportRunSection).LoadExportGroup(ExportConfigurationButtonEnum.Run, e.SelectedExportGroupID)
                Case ExportConfigurationButtonEnum.ViewLog
                    If e.SelectedExportGroupID > 0 Then TryCast(mSubSection, ViewExportLogSection).LoadExportGroup(e.SelectedExportGroupID)
            End Select


        End If

    End Sub
    Private Sub mNavigator_ShowModeChanged(ByVal sender As Object, ByVal e As ShowModeChangedEventArgs) Handles mNavigator.ShowModeChanged
        Dim LogSection As ViewExportLogSection = TryCast(mSubSection, ViewExportLogSection)
        LogSection.SetShowSelectedMode(e.ShowSelected)
    End Sub


#End Region

#Region "Public Methods"

    Public Sub RerunLogItem(ByVal logItem As ExportFileLog)

        'Clear the current control
        Me.Controls.Clear()

        'Create the new control
        'mSubSection = New ExportRunSection(logItem.ExportGroupID, logItem.StartDate, logItem.EndDate, CType(logItem.MarkSubmitted, Boolean))

        'mNavigator.ReRunButtonProcedure(ExportConfigurationButtonEnum.Run, logItem.StartDate, logItem.EndDate, CType(logItem.MarkSubmitted, Boolean))

        mNavigator.ReRunButtonProcedure(logItem)

        mMode = ExportConfigurationButtonEnum.ReRun

        'Display the new control
        mSubSection.Dock = DockStyle.Fill
        Me.Controls.Add(mSubSection)

    End Sub

#End Region



End Class
