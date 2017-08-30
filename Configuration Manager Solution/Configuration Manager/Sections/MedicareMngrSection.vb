Imports Nrc.Qualisys.Library
Imports Nrc.Qualisys.Library.DataProvider

Public Class MedicareMngrSection

#Region "Private Members"
    Private Const const_HCAHPS_SurveyTypeID As Integer = 2
    Private Const const_HHCAHPS_SurveyTypeID As Integer = 3
    Private Const const_OASCAHPS_SurveyTypeID As Integer = 16

    Private WithEvents mNavControl As MedicareMngrNavigator
    Private mMedicareNumber As MedicareNumber
    Private mSampleUnlocked As Boolean

    Private mHHCAHPS_MedicareNumber As MedicareSurveyType
    Private mHHCAHPS_SampleUnlocked As Boolean

    'TODO: OAS

#End Region

#Region "Base Class Overrides"

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavControl = TryCast(navCtrl, MedicareMngrNavigator)
        If mNavControl Is Nothing Then
            Throw New ArgumentException("The MedicareMngrSection control expects a navigation control of type MedicareMngrNavigator")
        End If

    End Sub

    Public Overrides Sub ActivateSection()

        mNavControl.RefreshMedicareNumbers()

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        If mMedicareNumber Is Nothing Then
            Return True
        ElseIf mMedicareNumber.IsDirty Then
            If MessageBox.Show("Do you wish to save the changes to this Medicare Number?", "Save Medicare Number", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) = DialogResult.Yes Then
                'Let's check to see if we are valid
                If mMedicareNumber.IsValid Then
                    'Everything looks good so go ahead and save it
                    mMedicareNumber.ApplyEdit()
                    mMedicareNumber.Save()
                    Return True
                Else
                    'There is invalid data so tell the user to fix it.
                    MessageBox.Show("Invalid data exists.  Please correct and try again.", "Invalid Medicare Number", MessageBoxButtons.OK)
                    Return False
                End If
            Else
                'The user has chosen not to save the changes.
                mMedicareNumber.CancelEdit()
                Return True
            End If
        Else
            mMedicareNumber.CancelEdit()
            Return True
        End If

    End Function

    Public Overrides Sub InactivateSection()

    End Sub

#End Region

#Region "Common Event Handlers"

    Private Sub mNavControl_MedicareSelectionChanged(ByVal sender As Object, ByVal e As MedicareSelectionChangedEventArgs) Handles mNavControl.MedicareSelectionChanged

        'Set member variables
        mMedicareNumber = e.MedicareNumber
        If e.MedicareNumber IsNot Nothing Then
            mHHCAHPS_MedicareNumber = MedicareSurveyTypeProvider.Instance.Select(mMedicareNumber.MedicareNumber, const_HHCAHPS_SurveyTypeID)
            If mHHCAHPS_MedicareNumber Is Nothing Then
                Dim globalDef As MedicareGlobalCalculationDefault = MedicareGlobalCalculationDefault.GetAll()(1)

                mHHCAHPS_MedicareNumber = MedicareSurveyType.NewMedicareSurveyType(globalDef)

                mHHCAHPS_MedicareNumber.MedicareNumber = mMedicareNumber.MedicareNumber
                mHHCAHPS_MedicareNumber.Name = mMedicareNumber.Name
                mHHCAHPS_MedicareNumber.SurveyTypeID = const_HHCAHPS_SurveyTypeID

                Dim quarterNumber As Integer = (Date.Now().Month() - 1) \ 3 + 1
                Dim firstDayOfQuarterNextYear As New DateTime(Date.Now().Year + 1, (quarterNumber - 1) * 3 + 1, 1)
                'mHHCAHPS_MedicareNumber.EstAnnualVolume = 0
                mHHCAHPS_MedicareNumber.EstResponseRate = globalDef.RespRate
                mHHCAHPS_MedicareNumber.SwitchToCalcDate = firstDayOfQuarterNextYear
                mHHCAHPS_MedicareNumber.AnnualReturnTarget = globalDef.AnnualReturnTarget
                mHHCAHPS_MedicareNumber.SamplingLocked = False
                mHHCAHPS_MedicareNumber.ProportionChangeThreshold = globalDef.ProportionChangeThreshold
                mHHCAHPS_MedicareNumber.IsActive = True
                mHHCAHPS_MedicareNumber.NonSubmitting = False
                mHHCAHPS_MedicareNumber.SwitchFromRateOverrideDate = New Date(1900, 1, 1)

            End If

            'TODO: OAS
        End If

        'Populate the screen
        PopulateMedicareSection()

        If e.MedicareNumber IsNot Nothing Then
            mMedicareNumber.BeginEdit()
        End If

    End Sub

    Private Sub mNavControl_MedicareSelectionChanging(ByVal sender As Object, ByVal e As MedicareSelectionChangingEventArgs) Handles mNavControl.MedicareSelectionChanging

        e.Cancel = Not AllowInactivate()

    End Sub

#End Region

#Region "HCAHPS Event Handlers"
    Private Sub EstimatedRadioButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EstimatedRadioButton.Click

        If EstimatedRadioButton.Checked Then
            mMedicareNumber.ProportionCalcTypeID = MedicareProportionCalcTypes.Estimated
            HistoricRadioButton.Checked = False
        Else
            HistoricRadioButton.Checked = True
        End If

    End Sub

    Private Sub HistoricRadioButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles HistoricRadioButton.Click

        If HistoricRadioButton.Checked Then
            mMedicareNumber.ProportionCalcTypeID = MedicareProportionCalcTypes.Historical
            EstimatedRadioButton.Checked = False
        Else
            EstimatedRadioButton.Checked = True
        End If

    End Sub

    Private Sub MedicareReCalcButton_Click(sender As Object, e As EventArgs) Handles MedicareReCalcButton.Click
        If Not mMedicareNumber.IsValid Then
            MessageBox.Show("Invalid data exists.  Please correct and try again.", "Recalc Proportion", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        If mMedicareNumber.IsDirty Then
            MessageBox.Show("You must save changes before you can recalculate the proportion.", "Recalc Proportion", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Exit Sub
        End If

        Dim dlg As ForceRecalculate = New ForceRecalculate(mMedicareNumber)
        If dlg.ShowDialog() = DialogResult.OK Then
            mMedicareNumber.ApplyEdit()
            mMedicareNumber.Save()
            If mSampleUnlocked Then mMedicareNumber.LogUnlockSample(CurrentUser.MemberID)
            mMedicareNumber.BeginEdit()
            PopulateMedicareSection()
        End If
    End Sub

    Private Sub MedicareCalcHistoryButton_Click(sender As Object, e As EventArgs) Handles MedicareCalcHistoryButton.Click
        Dim dlg As PropCalcHistory = New PropCalcHistory(mMedicareNumber)
        dlg.ShowDialog()
    End Sub

    Private Sub MedicareUnlockSamplingButton_Click(sender As Object, e As EventArgs) Handles MedicareUnlockSamplingButton.Click
        If Not mMedicareNumber.SamplingLocked Then Exit Sub

        If Not mMedicareNumber.IsValid Then
            MessageBox.Show("Invalid data exists.  Please correct and try again.", "Unlock Sampling", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        'Lets unlock it
        If MessageBox.Show("Are you sure you wish to unlock sampling for this medicare number?", "Unlock Sampling", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
            'User says do it
            mMedicareNumber.SamplingLocked = False
            'Set sample unlock flag. Written to log table during save.
            mSampleUnlocked = True
            DisplaySamplingLock(mMedicareNumber.SamplingLocked)
        End If

    End Sub

    Private Sub HCAHPS_ApplyButton_Click(sender As Object, e As EventArgs) Handles HCAHPS_ApplyButton.Click

        If mMedicareNumber.IsDirty And Not mMedicareNumber.IsValid Then
            MessageBox.Show("Invalid data exists.  Please correct and try again.", "Invalid Medicare Number", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            If mMedicareNumber.IsDirty Then
                mMedicareNumber.ApplyEdit()
                mMedicareNumber.Save()
                If mSampleUnlocked Then
                    mMedicareNumber.LogUnlockSample(CurrentUser.MemberID)
                    mSampleUnlocked = False
                End If
                mMedicareNumber.BeginEdit()
            End If
        End If

    End Sub

    Private Sub HCAHPS_CancelButton_Click(sender As Object, e As EventArgs) Handles HCAHPS_CancelButton.Click
        If mMedicareNumber.IsDirty Then
            If MessageBox.Show("Are you sure you wish to cancel all changes?", "Cancel Changes", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
                'The user has chosen to undo all changes
                mMedicareNumber.CancelEdit()

                PopulateMedicareSection()
                mMedicareNumber.BeginEdit()
            End If
        End If

    End Sub

#End Region

#Region "HHCAHPS Event Handlers"

    Private Sub HHCAHPSMedicareReCalcButton_Click(sender As Object, e As EventArgs) Handles HHCAHPS_MedicareReCalcButton.Click

        Dim showInvalidMessage As Boolean = False
        Dim message As String = ""

        If mHHCAHPS_MedicareNumber IsNot Nothing Then
            If mHHCAHPS_MedicareNumber.IsDirty And Not mHHCAHPS_MedicareNumber.IsValid Then
                showInvalidMessage = True
                For currentPos As Integer = 0 To mHHCAHPS_MedicareNumber.BrokenRulesCollection.Count - 1
                    Select Case mHHCAHPS_MedicareNumber.BrokenRulesCollection.Item(currentPos).Property.ToLower
                        Case "annualreturntarget"
                            message = message + vbCrLf + "Annual Target must be greater than 0."
                        Case "proportionchangethresholddisplay"
                            message = message + vbCrLf + "Proportion Change Threshold must be at least 1%."
                        Case Else
                    End Select
                Next
            End If

            If Date.Compare(mHHCAHPS_MedicareNumber.SwitchFromRateOverrideDate.Date, Date.Now().Date) >= 0 Then
                If mHHCAHPS_MedicareNumber.SamplingRateOverrideDisplay <= CDec(0.99) Then
                    message = message + vbCrLf + "If Switch from Override Date is in the future, Sampling Rate must be at least 1%."
                    showInvalidMessage = True
                End If
            Else
                If Date.Compare(mHHCAHPS_MedicareNumber.SwitchToCalcDate.Date, #1/1/1900#) = 0 OrElse mHHCAHPS_MedicareNumber.EstAnnualVolume <= 0 OrElse mHHCAHPS_MedicareNumber.EstResponseRateDisplay <= CDec(0.99) Then
                    message = message + vbCrLf + "Switch from Estimated Date must be populated, Estimated Annual Volume must be greater than 0, Estimated Response Rate must be at least 1%."
                    showInvalidMessage = True
                End If
            End If
        End If

        If showInvalidMessage Then
            message = message + vbCrLf + "Please correct and try again."
            MessageBox.Show(message, "Recalc Proportion", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return
        End If

        If mHHCAHPS_MedicareNumber.IsDirty Then
            MessageBox.Show("You must save changes before you can recalculate the proportion.", "Recalc Proportion", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Exit Sub
        End If

        Dim dlg As ForceRecalculate = New ForceRecalculate(mHHCAHPS_MedicareNumber, const_HHCAHPS_SurveyTypeID)

        If dlg.ShowDialog() = DialogResult.OK Then
            Dim medicareCommon As MedicareCommon = New MedicareCommon(mMedicareNumber.MedicareNumber, mMedicareNumber.Name)

            mHHCAHPS_MedicareNumber.ApplyEdit()
            mHHCAHPS_MedicareNumber.Save()
            If mHHCAHPS_SampleUnlocked Then medicareCommon.LogUnlockSample(CurrentUser.MemberID, const_HHCAHPS_SurveyTypeID)
            mHHCAHPS_MedicareNumber.BeginEdit()
            PopulateMedicareSection()
        End If
    End Sub

    Private Sub HHCAHPSMedicareCalcHistoryButton_Click(sender As Object, e As EventArgs) Handles HHCAHPS_MedicareCalcHistoryButton.Click
        Dim dlg As PropCalcHistory = New PropCalcHistory(mHHCAHPS_MedicareNumber, const_HHCAHPS_SurveyTypeID)
        dlg.ShowDialog()
    End Sub

    Private Sub HHCAHPSMedicareUnlockSamplingButton_Click(sender As Object, e As EventArgs) Handles HHCAHPS_MedicareUnlockSamplingButton.Click
        If Not mHHCAHPS_MedicareNumber.SamplingLocked Then Exit Sub

        If Not mHHCAHPS_MedicareNumber.IsValid Then
            MessageBox.Show("Invalid data exists.  Please correct and try again.", "Unlock Sampling", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        'Lets unlock it
        If MessageBox.Show("Are you sure you wish to unlock sampling for this medicare number?", "Unlock Sampling", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
            'User says do it
            mHHCAHPS_MedicareNumber.SamplingLocked = False
            'Set sample unlock flag. Written to log table during save.
            mHHCAHPS_SampleUnlocked = True
            DisplaySamplingLock_HHCAHPS(mHHCAHPS_MedicareNumber.SamplingLocked)
        End If
    End Sub

    Private Sub HHCAHPS_ApplyButton_Click(sender As Object, e As EventArgs) Handles HHCAHPS_ApplyButton.Click

        Dim showInvalidMessage As Boolean = False
        Dim message As String = ""

        If mHHCAHPS_MedicareNumber IsNot Nothing Then
            If mHHCAHPS_MedicareNumber.IsDirty And Not mHHCAHPS_MedicareNumber.IsValid Then
                showInvalidMessage = True
                For currentPos As Integer = 0 To mHHCAHPS_MedicareNumber.BrokenRulesCollection.Count - 1
                    Select Case mHHCAHPS_MedicareNumber.BrokenRulesCollection.Item(currentPos).Property.ToLower
                        Case "annualreturntarget"
                            message = message + vbCrLf + "Annual Target must be greater than 0."
                        Case "proportionchangethresholddisplay"
                            message = message + vbCrLf + "Proportion Change Threshold must be at least 1%."
                        Case Else
                    End Select
                Next
            End If

            If Date.Compare(mHHCAHPS_MedicareNumber.SwitchFromRateOverrideDate.Date, Date.Now().Date) >= 0 Then
                If mHHCAHPS_MedicareNumber.SamplingRateOverrideDisplay <= CDec(0.99) Then
                    message = message + vbCrLf + "If Switch from Override Date is in the future, Sampling Rate must be at least 1%."
                    showInvalidMessage = True
                End If
            Else
                If Date.Compare(mHHCAHPS_MedicareNumber.SwitchToCalcDate.Date, #1/1/1900#) = 0 OrElse mHHCAHPS_MedicareNumber.EstAnnualVolume <= 0 OrElse mHHCAHPS_MedicareNumber.EstResponseRateDisplay <= CDec(0.99) Then
                    message = message + vbCrLf + "Switch from Estimated Date must be populated, Estimated Annual Volume must be greater than 0, Estimated Response Rate must be at least 1%."
                    showInvalidMessage = True
                End If
            End If
        End If

        If showInvalidMessage Then
            MessageBox.Show(message, "Invalid HHCAHPS Medicare Number", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            If mHHCAHPS_MedicareNumber IsNot Nothing Then

                If mHHCAHPS_MedicareNumber.IsDirty Then

                    Dim isOverrideDateBlank As Boolean = False
                    Dim isOverrideRateBlank As Boolean = True
                    Dim showInvalidOverrideMessage As Boolean = False
                    Dim isOverrideDateValid As Boolean = True

                    If Date.Compare(mHHCAHPS_MedicareNumber.SwitchFromRateOverrideDate.Date, #1/1/1900#) = 0 Then
                        isOverrideDateBlank = True
                    Else
                        If Date.Compare(mHHCAHPS_MedicareNumber.SwitchFromRateOverrideDate.Date, Date.Now().Date) < 0 Then
                            isOverrideDateValid = False
                        End If
                    End If

                    If mHHCAHPS_MedicareNumber.SamplingRateOverride > CDec(0) Then
                        isOverrideRateBlank = False
                    End If

                    If Not isOverrideDateValid And mHHCAHPS_MedicareNumber.IsNew Then
                        MessageBox.Show("""Switch from Overeride Date"" can't be in the past for new medicare number.  Please correct and try again.", "Invalid Medicare Number", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        showInvalidOverrideMessage = True
                    End If

                    If ((Not showInvalidOverrideMessage) And ((isOverrideDateBlank And Not isOverrideRateBlank) Or (Not isOverrideDateBlank And isOverrideRateBlank))) Then
                        MessageBox.Show("Invalid ""Switch from Overeride Date"" or ""Sampling Date"" exists.  Please correct and try again.", "Invalid Medicare Number", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        showInvalidOverrideMessage = True
                    End If

                    If (Not showInvalidOverrideMessage) Then
                        mHHCAHPS_MedicareNumber.MedicareNumber = mMedicareNumber.MedicareNumber
                        mHHCAHPS_MedicareNumber.Name = mMedicareNumber.Name
                        mHHCAHPS_MedicareNumber.ApplyEdit()
                        mHHCAHPS_MedicareNumber.Save()
                        If mHHCAHPS_SampleUnlocked Then
                            Dim medicareCommon As MedicareCommon = New MedicareCommon(mMedicareNumber.MedicareNumber, mMedicareNumber.Name)
                            medicareCommon.LogUnlockSample(CurrentUser.MemberID, const_HHCAHPS_SurveyTypeID)
                            mHHCAHPS_SampleUnlocked = False
                        End If

                        mHHCAHPS_MedicareNumber.BeginEdit()

                    End If

                End If
            End If

        End If
    End Sub

    Private Sub HHCAHPS_CancelButton_Click(sender As Object, e As EventArgs) Handles HHCAHPS_CancelButton.Click
        Dim HHCAHPS_IsDirty As Boolean = False
        If mHHCAHPS_MedicareNumber IsNot Nothing Then
            HHCAHPS_IsDirty = mHHCAHPS_MedicareNumber.IsDirty
        End If

        If HHCAHPS_IsDirty Then
            If MessageBox.Show("Are you sure you wish to cancel all changes?", "Cancel Changes", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
                'The user has chosen to undo all changes
                mHHCAHPS_MedicareNumber.CancelEdit()

                PopulateMedicareSection()
                mHHCAHPS_MedicareNumber.BeginEdit()

            End If
        End If

    End Sub

#End Region

    'TODO: OAS Event Handlers
#Region "Public Methods"

#End Region

#Region "Private Methods"

    Private Sub PopulateMedicareSection()

        'Set the wait cursor
        Cursor = Cursors.WaitCursor

        'Clear the screen and all bindings
        'Common ones
        With MedicareManagementSectionPanel
            .Caption = "Medicare Number:"
            .Enabled = False
        End With
        With MedicareNumberTextBox
            .DataBindings.Clear()
            .Text = ""
        End With
        With MedicareNameTextBox
            .DataBindings.Clear()
            .Text = ""
        End With

        PopulateMedicareSection_HCAHPS()
        PopulateMedicareSection_HHCAHPS()
        'TODO: OAS

        'Select the MedicareNumberTextBox
        MedicareNumberTextBox.Focus()

        'Reset the wait cursor
        Cursor = DefaultCursor

    End Sub

    Private Sub PopulateMedicareSection_HCAHPS()
        'Clear the screen and all bindings
        With AnnualReturnTargetNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With
        With ChangeThresholdNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With

        With EstimatedAnnualVolumeNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With
        With EstimatedResponseRateNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With
        With EstimatedIneligibleRateNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With
        With SwitchToCalcOnDateEdit
            .DataBindings.Clear()
            .EditValue = Date.MinValue
        End With

        With ForceCensusSampleCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With

        With InactiveCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With NonSubmittingCheckbox
            .DataBindings.Clear()
            .Checked = False
        End With
        SamplingLockTextBox.Text = ""
        AnnualEligibleVolumeNumericUpDown.Value = 0
        HistoricResponseRateNumericUpDown.Value = 0
        HistoricWarningPictureBox.Visible = False
        HistoricWarningLabel.Visible = False
        HistoricRadioButton.Checked = False
        EstimatedRadioButton.Checked = False
        LastCalcDateTextBox.Text = ""
        LastCalcTypeTextBox.Text = ""
        CalcProportionNumericUpDown.Value = 0
        ProportionUsedNumericUpDown.Value = 0

        MedicareErrorProvider.DataSource = Nothing

        If mMedicareNumber IsNot Nothing Then
            'Set the section header
            With MedicareManagementSectionPanel
                .Caption = String.Format("Medicare Number: {0} ({1})", mMedicareNumber.MedicareNumber, mMedicareNumber.Name)
                .Enabled = True
            End With

            'Populate the screen
            With MedicareNumberTextBox
                .DataBindings.Add("Text", mMedicareNumber, "MedicareNumber")
                .ReadOnly = (Not mMedicareNumber.IsNew)
            End With
            MedicareNameTextBox.DataBindings.Add("Text", mMedicareNumber, "Name", False, DataSourceUpdateMode.OnPropertyChanged)
            AnnualReturnTargetNumericUpDown.DataBindings.Add("Value", mMedicareNumber, "AnnualReturnTarget", False, DataSourceUpdateMode.OnPropertyChanged)
            ChangeThresholdNumericUpDown.DataBindings.Add("Value", mMedicareNumber, "ProportionChangeThresholdDisplay", False, DataSourceUpdateMode.OnPropertyChanged)
            EstimatedAnnualVolumeNumericUpDown.DataBindings.Add("Value", mMedicareNumber, "EstAnnualVolume", False, DataSourceUpdateMode.OnPropertyChanged)
            EstimatedResponseRateNumericUpDown.DataBindings.Add("Value", mMedicareNumber, "EstResponseRateDisplay", False, DataSourceUpdateMode.OnPropertyChanged)
            EstimatedIneligibleRateNumericUpDown.DataBindings.Add("Value", mMedicareNumber, "EstIneligibleRateDisplay", False, DataSourceUpdateMode.OnPropertyChanged)
            SwitchToCalcOnDateEdit.DataBindings.Add("EditValue", mMedicareNumber, "SwitchToCalcDate", False, DataSourceUpdateMode.OnPropertyChanged)
            ForceCensusSampleCheckBox.DataBindings.Add("Checked", mMedicareNumber, "CensusForced", False, DataSourceUpdateMode.OnPropertyChanged)
            InactiveCheckBox.DataBindings.Add("Checked", mMedicareNumber, "IsInactive", False, DataSourceUpdateMode.OnPropertyChanged)
            NonSubmittingCheckbox.DataBindings.Add("Checked", mMedicareNumber, "NonSubmitting", False, DataSourceUpdateMode.OnPropertyChanged)

            'Unbound controls
            DisplaySamplingLock(mMedicareNumber.SamplingLocked)
            AnnualEligibleVolumeNumericUpDown.Value = mMedicareNumber.AnnualEligibleVolume
            HistoricResponseRateNumericUpDown.Value = mMedicareNumber.HistoricResponseRateDisplay

            HistoricWarningPictureBox.Visible = (Not mMedicareNumber.CanUseHistoric())
            HistoricWarningLabel.Visible = (Not mMedicareNumber.CanUseHistoric())

            If mMedicareNumber.ProportionCalcTypeID = MedicareProportionCalcTypes.Historical Then
                HistoricRadioButton.Checked = True
                EstimatedRadioButton.Checked = False
            Else
                EstimatedRadioButton.Checked = True
                HistoricRadioButton.Checked = False
            End If

            'History information
            If mMedicareNumber.LastRecalcDateCalculated = Date.MinValue Then
                LastCalcDateTextBox.Text = "Never"
            Else
                LastCalcDateTextBox.Text = mMedicareNumber.LastRecalcDateCalculated.ToString
            End If

            If mMedicareNumber.LastRecalcPropCalcType Is Nothing Then
                LastCalcTypeTextBox.Text = "Unknown"
            Else
                LastCalcTypeTextBox.Text = mMedicareNumber.LastRecalcPropCalcType.MedicarePropCalcTypeName
            End If

            CalcProportionNumericUpDown.Value = mMedicareNumber.LastRecalcProportionDisplay

            If mMedicareNumber.LastRecalcCensusForced Then
                ProportionUsedNumericUpDown.Value = 100
            Else
                ProportionUsedNumericUpDown.Value = CalcProportionNumericUpDown.Value
            End If

            'Setup the error provider
            MedicareErrorProvider.DataSource = mMedicareNumber
        End If

        'Set sample unlock flag
        mSampleUnlocked = False

    End Sub

    Private Sub PopulateMedicareSection_HHCAHPS()
        'Clear the screen and all bindings
        With HHCAHPS_AnnualReturnTargetNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With
        With HHCAHPS_ChangeThresholdNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With

        With HHCAHPS_SwtichFromEstimatedDateDateTimePicker
            .DataBindings.Clear()
            .Value = New Date(1900, 1, 1)
        End With
        With HHCAHPS_EstimatedAnnualVolumeNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With
        With HHCAHPS_EstimatedResponseRateNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With

        With HHCAHPS_SwitchFromOverrideDateDateTimePicker
            .DataBindings.Clear()
            .Value = New Date(1900, 1, 1)
        End With
        With HHCAHPS_SamplingRateNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With

        With HHCAHPS_InactiveCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With HHCAHPS_NonSubmittingCheckbox
            .DataBindings.Clear()
            .Checked = False
        End With

        HHCAHPS_SamplingLockTextBox.Text = ""

        HHCAHPS_AnnualEligibleVolumeNumericUpDown.Value = 0
        HHCAHPS_HistoricResponseRateNumericUpDown.Value = 0

        HHCAHPS_LastCalcDateTextBox.Text = ""
        HHCAHPS_LastCalcTypeTextBox.Text = ""
        HHCAHPS_CalcProportionNumericUpDown.Value = 0
        HHCAHPS_ProportionUsedNumericUpDown.Value = 0

        'MedicareErrorProvider.DataSource = Nothing

        If mHHCAHPS_MedicareNumber IsNot Nothing Then
            'Populate the screen
            HHCAHPS_AnnualReturnTargetNumericUpDown.DataBindings.Add("Value", mHHCAHPS_MedicareNumber, "AnnualReturnTarget", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPS_ChangeThresholdNumericUpDown.DataBindings.Add("Value", mHHCAHPS_MedicareNumber, "ProportionChangeThresholdDisplay", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPS_EstimatedAnnualVolumeNumericUpDown.DataBindings.Add("Value", mHHCAHPS_MedicareNumber, "EstAnnualVolume", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPS_EstimatedResponseRateNumericUpDown.DataBindings.Add("Value", mHHCAHPS_MedicareNumber, "EstResponseRateDisplay", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPS_SwtichFromEstimatedDateDateTimePicker.DataBindings.Add("Value", mHHCAHPS_MedicareNumber, "SwitchToCalcDate", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPS_InactiveCheckBox.DataBindings.Add("Checked", mHHCAHPS_MedicareNumber, "IsInactive", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPS_NonSubmittingCheckbox.DataBindings.Add("Checked", mHHCAHPS_MedicareNumber, "NonSubmitting", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPS_SamplingRateNumericUpDown.DataBindings.Add("Value", mHHCAHPS_MedicareNumber, "SamplingRateOverrideDisplay", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPS_SwitchFromOverrideDateDateTimePicker.DataBindings.Add("Value", mHHCAHPS_MedicareNumber, "SwitchFromRateOverrideDate", False, DataSourceUpdateMode.OnPropertyChanged)

            If Date.Compare(mHHCAHPS_MedicareNumber.SwitchToCalcDate, Date.Now) < 0 Then
                HHCAHPS_SwtichFromEstimatedDateDateTimePicker.Enabled = False
                HHCAHPS_EstimatedAnnualVolumeNumericUpDown.Enabled = False
                HHCAHPS_EstimatedResponseRateNumericUpDown.Enabled = False
            Else
                HHCAHPS_SwtichFromEstimatedDateDateTimePicker.Enabled = True
                HHCAHPS_EstimatedAnnualVolumeNumericUpDown.Enabled = True
                HHCAHPS_EstimatedResponseRateNumericUpDown.Enabled = True
            End If


            'Unbound controls
            DisplaySamplingLock_HHCAHPS(mHHCAHPS_MedicareNumber.SamplingLocked)

            HHCAHPS_AnnualEligibleVolumeNumericUpDown.Value = mHHCAHPS_MedicareNumber.AnnualEligibleVolume
            HHCAHPS_HistoricResponseRateNumericUpDown.Value = mHHCAHPS_MedicareNumber.HistoricResponseRateDisplay

            'History Information
            If mHHCAHPS_MedicareNumber.LastRecalcDateCalculated = Date.MinValue Then
                HHCAHPS_LastCalcDateTextBox.Text = "Never"
            Else
                HHCAHPS_LastCalcDateTextBox.Text = mHHCAHPS_MedicareNumber.LastRecalcDateCalculated.ToString
            End If

            If mHHCAHPS_MedicareNumber.LastRecalcPropCalcType Is Nothing Then
                HHCAHPS_LastCalcTypeTextBox.Text = "Unknown"
            Else
                HHCAHPS_LastCalcTypeTextBox.Text = mHHCAHPS_MedicareNumber.LastRecalcPropCalcType.MedicarePropCalcTypeName
            End If

            HHCAHPS_CalcProportionNumericUpDown.Value = mHHCAHPS_MedicareNumber.LastRecalcProportionDisplay

            If mHHCAHPS_MedicareNumber.LastRecalcHistory IsNot Nothing AndAlso mHHCAHPS_MedicareNumber.LastRecalcHistory.MedicarePropDataTypeID = MedicareProportionDataTypes.RateOverride Then
                HHCAHPS_ProportionUsedNumericUpDown.Value = mHHCAHPS_MedicareNumber.LastRecalcHistory.SamplingRateOverrideDisplay
            Else
                HHCAHPS_ProportionUsedNumericUpDown.Value = HHCAHPS_CalcProportionNumericUpDown.Value
            End If
        Else
            HHCAHPS_SamplingLockTextBox.Text = ""
        End If

        'Set sample unlock flag
        mHHCAHPS_SampleUnlocked = False

    End Sub

    Private Sub DisplaySamplingLock(ByVal locked As Boolean)
        With SamplingLockTextBox
            If locked Then
                .Text = "Locked"
                .ForeColor = Color.Red
            Else
                .Text = "Unlocked"
                .ForeColor = System.Drawing.SystemColors.WindowText
            End If
        End With

        MedicareUnlockSamplingButton.Enabled = locked
    End Sub

    Private Sub DisplaySamplingLock_HHCAHPS(ByVal locked As Boolean)
        With HHCAHPS_SamplingLockTextBox
            If locked Then
                .Text = "Locked"
                .ForeColor = Color.Red
            Else
                .Text = "Unlocked"
                .ForeColor = System.Drawing.SystemColors.WindowText
            End If
        End With

        HHCAHPS_MedicareUnlockSamplingButton.Enabled = locked
    End Sub

    'TODO: OAS

    Private Sub CAHPSTabControl_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CAHPSTabControl.SelectedIndexChanged
        Select Case CAHPSTabControl.SelectedIndex
            Case 0
                DisplaySamplingLock(mMedicareNumber.SamplingLocked)
                MedicareCalcHistoryButton.Enabled = True
                MedicareReCalcButton.Enabled = True
            Case 1
                If mHHCAHPS_MedicareNumber IsNot Nothing Then
                    DisplaySamplingLock_HHCAHPS(mHHCAHPS_MedicareNumber.SamplingLocked)
                Else
                    DisplaySamplingLock_HHCAHPS(False)
                End If
                HHCAHPS_MedicareCalcHistoryButton.Enabled = True
                HHCAHPS_MedicareReCalcButton.Enabled = True
            Case Else
        End Select

    End Sub

#End Region

End Class
