Imports Nrc.Qualisys.Library

Public Class MedicareMngrSection

#Region "Private Members"

    Private WithEvents mNavControl As MedicareMngrNavigator
    Private mMedicareNumber As MedicareNumber
    Private mSampleUnlocked As Boolean
    Private mHHCAHPS_SampleUnlocked As Boolean

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

#Region "Event Handlers"

    Private Sub mNavControl_MedicareSelectionChanged(ByVal sender As Object, ByVal e As MedicareSelectionChangedEventArgs) Handles mNavControl.MedicareSelectionChanged

        'Set member variables
        mMedicareNumber = e.MedicareNumber

        'Populate the screen
        PopulateMedicareSection()

        If e.MedicareNumber IsNot Nothing Then
            mMedicareNumber.BeginEdit()
        End If

    End Sub

    Private Sub mNavControl_MedicareSelectionChanging(ByVal sender As Object, ByVal e As MedicareSelectionChangingEventArgs) Handles mNavControl.MedicareSelectionChanging

        e.Cancel = Not AllowInactivate()

    End Sub

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

    Private Sub ApplyButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ApplyButton.Click

        If mMedicareNumber.IsDirty Then
            If mMedicareNumber.IsValid Then
                mMedicareNumber.ApplyEdit()
                mMedicareNumber.Save()
                If mSampleUnlocked Then mMedicareNumber.LogUnlockSample(CurrentUser.MemberID)
                mMedicareNumber.BeginEdit()
            Else
                'There is invalid data so tell the user to fix it.
                MessageBox.Show("Invalid data exists.  Please correct and try again.", "Invalid Medicare Number", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If
        End If

    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        If mMedicareNumber.IsDirty Then
            If MessageBox.Show("Are you sure you wish to cancel all changes?", "Cancel Changes", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
                'The user has chosen to undo all changes
                mMedicareNumber.CancelEdit()
                PopulateMedicareSection()
                mMedicareNumber.BeginEdit()
            End If
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

#End Region

#Region "Public Methods"

#End Region

#Region "Private Methods"

    Private Sub PopulateMedicareSection()

        'Set the wait cursor
        Cursor = Cursors.WaitCursor

        'Clear the screen and all bindings
        'Common ones
        With MedicareMngrSectionPanel
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
            With MedicareMngrSectionPanel
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
        With HHCAHPSAnnualReturnTargetNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With
        With HHCAHPSChangeThresholdNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With

        With HHCAHPSSwtichFromEstimatedDateDateTimePicker
            .DataBindings.Clear()
            .Value = New Date(1900, 1, 1)
        End With
        With HHCAHPSEstimatedAnnualVolumeNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With
        With HHCAHPSEstimatedResponseRateNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With

        With HHCAHPSSwitchFromOverrideDateDateTimePicker
            .DataBindings.Clear()
            .Value = New Date(1900, 1, 1)
        End With
        With HHCAHPSSamplingRateNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With

        With HHCAHPSInactiveCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With HHCAHPSNonSubmittingCheckbox
            .DataBindings.Clear()
            .Checked = False
        End With

        HHCAHPSSamplingLockTextBox.Text = ""

        HHCAHPSAnnualEligibleVolumeNumericUpDown.Value = 0
        HHCAHPSHistoricResponseRateNumericUpDown.Value = 0

        HHCAHPSLastCalcDateTextBox.Text = ""
        HHCAHPSLastCalcTypeTextBox.Text = ""
        HHCAHPSCalcProportionNumericUpDown.Value = 0
        HHCAHPSProportionUsedNumericUpDown.Value = 0

        MedicareErrorProvider.DataSource = Nothing

        If mMedicareNumber IsNot Nothing Then
            'Populate the screen
            HHCAHPSAnnualReturnTargetNumericUpDown.DataBindings.Add("Value", mMedicareNumber, "HHCAHPS_AnnualReturnTarget", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPSChangeThresholdNumericUpDown.DataBindings.Add("Value", mMedicareNumber, "HHCAHPS_ProportionChangeThresholdDisplay", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPSEstimatedAnnualVolumeNumericUpDown.DataBindings.Add("Value", mMedicareNumber, "HHCAHPS_EstAnnualVolume", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPSEstimatedResponseRateNumericUpDown.DataBindings.Add("Value", mMedicareNumber, "HHCAHPS_EstResponseRateDisplay", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPSSwtichFromEstimatedDateDateTimePicker.DataBindings.Add("Value", mMedicareNumber, "HHCAHPS_SwitchToCalcDate", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPSInactiveCheckBox.DataBindings.Add("Checked", mMedicareNumber, "HHCAHPS_IsInactive", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPSNonSubmittingCheckbox.DataBindings.Add("Checked", mMedicareNumber, "HHCAHPS_NonSubmitting", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPSSamplingRateNumericUpDown.DataBindings.Add("Value", mMedicareNumber, "HHCAHPS_SamplingRateOverrideDisplay", False, DataSourceUpdateMode.OnPropertyChanged)
            HHCAHPSSwitchFromOverrideDateDateTimePicker.DataBindings.Add("Value", mMedicareNumber, "HHCAHPS_SwitchFromRateOverrideDate", False, DataSourceUpdateMode.OnPropertyChanged)

            'Unbound controls
            'TODO: uncomment this once we have the historic data
            'DisplaySamplingLock_HHCAHPS(mMedicareNumber.HHCAHPS_SamplingLocked)
            'HHCAHPSAnnualEligibleVolumeNumericUpDown.Value = mMedicareNumber.HHCAHPS_AnnualEligibleVolume
            'HHCAHPSHistoricResponseRateNumericUpDown.Value = mMedicareNumber.HHCAHPS_HistoricResponseRateDisplay

            'History information
            'TODO: uncomment this once we have the historic data
            'If mMedicareNumber.HHCAHPS_LastRecalcDateCalculated = Date.MinValue Then
            '    HHCAHPSLastCalcDateTextBox.Text = "Never"
            'Else
            '    HHCAHPSLastCalcDateTextBox.Text = mMedicareNumber.HHCAHPS_LastRecalcDateCalculated.ToString
            'End If

            'If mMedicareNumber.HHCAHPS_LastRecalcPropCalcType Is Nothing Then
            '    HHCAHPSLastCalcTypeTextBox.Text = "Unknown"
            'Else
            '    HHCAHPSLastCalcTypeTextBox.Text = mMedicareNumber.HHCAHPS_LastRecalcPropCalcType.MedicarePropCalcTypeName
            'End If

            'HHCAHPSCalcProportionNumericUpDown.Value = mMedicareNumber.HHCAHPS_LastRecalcProportionDisplay

            'If mMedicareNumber.HHCAHPS_LastRecalcCensusForced Then
            '    HHCAHPSProportionUsedNumericUpDown.Value = 100
            'Else
            '    HHCAHPSProportionUsedNumericUpDown.Value = HHCAHPSCalcProportionNumericUpDown.Value
            'End If

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
        With HHCAHPSSamplingLockTextBox
            If locked Then
                .Text = "Locked"
                .ForeColor = Color.Red
            Else
                .Text = "Unlocked"
                .ForeColor = System.Drawing.SystemColors.WindowText
            End If
        End With

        HHCAHPSMedicareUnlockSamplingButton.Enabled = locked
    End Sub

    Private Sub CAHPSTabControl_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CAHPSTabControl.SelectedIndexChanged
        Select Case CAHPSTabControl.SelectedIndex
            Case 0
                DisplaySamplingLock(mMedicareNumber.SamplingLocked)
                MedicareCalcHistoryButton.Enabled = True
                MedicareReCalcButton.Enabled = True
            Case 1
                DisplaySamplingLock_HHCAHPS(mMedicareNumber.HHCAHPS_SamplingLocked)
                HHCAHPSMedicareCalcHistoryButton.Enabled = True
                HHCAHPSMedicareReCalcButton.Enabled = True
            Case Else
        End Select

    End Sub

#End Region

End Class
