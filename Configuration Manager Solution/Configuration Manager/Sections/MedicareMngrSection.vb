Imports Nrc.Qualisys.Library
Imports Nrc.Qualisys.Library.DataProvider

Public Class MedicareMngrSection

#Region "Private Members"
    Private Const const_HCAHPS_SurveyTypeID As Integer = 2
    Private Const const_HHCAHPS_SurveyTypeID As Integer = 3
    Private Const const_OASCAHPS_SurveyTypeID As Integer = 16
    Private Const const_Apply_ValidationType As Int16 = 1
    Private Const const_ForceCalc_ValidationType As Int16 = 2
    Private Const const_UnlockSampling_ValidationType As Int16 = 3
    Private Const const_AllowInactivate_ValidationType As Int16 = 4

    Private WithEvents mNavControl As MedicareMngrNavigator
    Private mGlobalDef As MedicareGlobalCalculationDefault

    'HCAHPS
    Private mMedicareNumber As MedicareNumber
    Private mSampleUnlocked As Boolean

    'HHCAHPS 
    Private mHHCAHPS_MedicareNumber As MedicareSurveyType
    Private mHHCAHPS_SampleUnlocked As Boolean

    'OASCAHPS
    Private mOASCAHPS_MedicareNumber As MedicareSurveyType
    Private mOASCAHPS_SampleUnlocked As Boolean

#End Region

#Region "Private Properties"
    Private ReadOnly Property GlobalDef() As MedicareGlobalCalculationDefault
        Get
            If mGlobalDef Is Nothing Then
                mGlobalDef = MedicareGlobalCalculationDefault.GetAll()(1)
            End If
            Return mGlobalDef
        End Get
    End Property

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
        Dim showSaveMessage As Boolean = False
        Dim tabName As String = ""
        If mMedicareNumber Is Nothing Then
            mHHCAHPS_MedicareNumber = Nothing
            mOASCAHPS_MedicareNumber = Nothing
        End If

        If mMedicareNumber IsNot Nothing AndAlso mMedicareNumber.IsDirty Then
            showSaveMessage = True
            tabName = "HCAHPS, "
        End If

        If mHHCAHPS_MedicareNumber IsNot Nothing AndAlso mHHCAHPS_MedicareNumber.IsDirty Then
            showSaveMessage = True
            tabName = tabName + "HHCAHPS, "
        End If

        If mOASCAHPS_MedicareNumber IsNot Nothing AndAlso mOASCAHPS_MedicareNumber.IsDirty Then
            showSaveMessage = True
            tabName = tabName + "OASCAHPS, "
        End If

        If showSaveMessage Then
            tabName = tabName.Substring(0, tabName.Length - 2)
            MessageBox.Show("You have unsaved changes on the following tab(s): " + tabName + ". Please save or cancel.", "Unsaved Changes", MessageBoxButtons.OK)
            Return False
        Else
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
            mHHCAHPS_MedicareNumber = newMedicareSurveyType(const_HHCAHPS_SurveyTypeID)
            mOASCAHPS_MedicareNumber = newMedicareSurveyType(const_OASCAHPS_SurveyTypeID)
        Else
            mHHCAHPS_MedicareNumber = Nothing
            mOASCAHPS_MedicareNumber = Nothing
        End If

        'Populate the screen
        PopulateMedicareSection()

        If e.MedicareNumber IsNot Nothing Then
            mMedicareNumber.BeginEdit()
        End If
        If mHHCAHPS_MedicareNumber IsNot Nothing Then
            mHHCAHPS_MedicareNumber.BeginEdit()
        End If
        If mOASCAHPS_MedicareNumber IsNot Nothing Then
            mOASCAHPS_MedicareNumber.BeginEdit()
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
        SurveyTypeMedicareReCalcButton_Click(mHHCAHPS_MedicareNumber, const_HHCAHPS_SurveyTypeID)
    End Sub

    Private Sub HHCAHPSMedicareCalcHistoryButton_Click(sender As Object, e As EventArgs) Handles HHCAHPS_MedicareCalcHistoryButton.Click
        Dim dlg As PropCalcHistory = New PropCalcHistory(mHHCAHPS_MedicareNumber, const_HHCAHPS_SurveyTypeID)
        dlg.ShowDialog()
    End Sub

    Private Sub HHCAHPSMedicareUnlockSamplingButton_Click(sender As Object, e As EventArgs) Handles HHCAHPS_MedicareUnlockSamplingButton.Click
        SurveyTypeMedicareUnlockSamplingButton_Click(mHHCAHPS_MedicareNumber, const_HHCAHPS_SurveyTypeID)
    End Sub

    Private Sub HHCAHPS_ApplyButton_Click(sender As Object, e As EventArgs) Handles HHCAHPS_ApplyButton.Click
        SurveyTypeApplyButton_Click(mHHCAHPS_MedicareNumber, const_HHCAHPS_SurveyTypeID)
    End Sub

    Private Sub HHCAHPS_CancelButton_Click(sender As Object, e As EventArgs) Handles HHCAHPS_CancelButton.Click
        SurveyTypeCancelButton_Click(mHHCAHPS_MedicareNumber)
    End Sub

#End Region

#Region "OASCAHPS Event Handlers"
    Private Sub OASCAHPS_MedicareReCalcButton_Click(sender As Object, e As EventArgs) Handles OASCAHPS_MedicareReCalcButton.Click
        SurveyTypeMedicareReCalcButton_Click(mOASCAHPS_MedicareNumber, const_OASCAHPS_SurveyTypeID)
    End Sub

    Private Sub OASCAHPS_MedicareCalcHistoryButton_Click(sender As Object, e As EventArgs) Handles OASCAHPS_MedicareCalcHistoryButton.Click
        Dim dlg As PropCalcHistory = New PropCalcHistory(mOASCAHPS_MedicareNumber, const_OASCAHPS_SurveyTypeID)
        dlg.ShowDialog()
    End Sub

    Private Sub OASCAHPS_MedicareUnlockSamplingButton_Click(sender As Object, e As EventArgs) Handles OASCAHPS_MedicareUnlockSamplingButton.Click
        SurveyTypeMedicareUnlockSamplingButton_Click(mOASCAHPS_MedicareNumber, const_OASCAHPS_SurveyTypeID)
    End Sub

    Private Sub OASCAHPS_ApplyButton_Click(sender As Object, e As EventArgs) Handles OASCAHPS_ApplyButton.Click
        SurveyTypeApplyButton_Click(mOASCAHPS_MedicareNumber, const_OASCAHPS_SurveyTypeID)
    End Sub

    Private Sub OASCAHPS_CancelButton_Click(sender As Object, e As EventArgs) Handles OASCAHPS_CancelButton.Click
        SurveyTypeCancelButton_Click(mOASCAHPS_MedicareNumber)
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
        PopulateMedicareSection_OASCAHPS()

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

            If CurrentUser.MayOverrideSamplingRate Then
                HHCAHPS_SwitchFromOverrideDateDateTimePicker.Enabled = True
                HHCAHPS_SamplingRateNumericUpDown.Enabled = True
            Else
                HHCAHPS_SwitchFromOverrideDateDateTimePicker.Enabled = False
                HHCAHPS_SamplingRateNumericUpDown.Enabled = False
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

    Private Sub PopulateMedicareSection_OASCAHPS()
        'Clear the screen and all bindings
        With OASCAHPS_AnnualReturnTargetNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With
        With OASCAHPS_ChangeThresholdNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With

        With OASCAHPS_SwtichFromEstimatedDateDateTimePicker
            .DataBindings.Clear()
            .Value = New Date(1900, 1, 1)
        End With
        With OASCAHPS_EstimatedAnnualVolumeNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With
        With OASCAHPS_EstimatedResponseRateNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With

        With OASCAHPS_SwitchFromOverrideDateDateTimePicker
            .DataBindings.Clear()
            .Value = New Date(1900, 1, 1)
        End With
        With OASCAHPS_SamplingRateNumericUpDown
            .DataBindings.Clear()
            .Value = 0
        End With

        With OASCAHPS_InactiveCheckBox
            .DataBindings.Clear()
            .Checked = False
        End With
        With OASCAHPS_NonSubmittingCheckbox
            .DataBindings.Clear()
            .Checked = False
        End With

        OASCAHPS_SamplingLockTextBox.Text = ""

        OASCAHPS_AnnualEligibleVolumeNumericUpDown.Value = 0
        OASCAHPS_HistoricResponseRateNumericUpDown.Value = 0

        OASCAHPS_LastCalcDateTextBox.Text = ""
        OASCAHPS_LastCalcTypeTextBox.Text = ""
        OASCAHPS_CalcProportionNumericUpDown.Value = 0
        OASCAHPS_ProportionUsedNumericUpDown.Value = 0

        'MedicareErrorProvider.DataSource = Nothing

        If mOASCAHPS_MedicareNumber IsNot Nothing Then
            'Populate the screen
            OASCAHPS_AnnualReturnTargetNumericUpDown.DataBindings.Add("Value", mOASCAHPS_MedicareNumber, "AnnualReturnTarget", False, DataSourceUpdateMode.OnPropertyChanged)
            OASCAHPS_ChangeThresholdNumericUpDown.DataBindings.Add("Value", mOASCAHPS_MedicareNumber, "ProportionChangeThresholdDisplay", False, DataSourceUpdateMode.OnPropertyChanged)
            OASCAHPS_EstimatedAnnualVolumeNumericUpDown.DataBindings.Add("Value", mOASCAHPS_MedicareNumber, "EstAnnualVolume", False, DataSourceUpdateMode.OnPropertyChanged)
            OASCAHPS_EstimatedResponseRateNumericUpDown.DataBindings.Add("Value", mOASCAHPS_MedicareNumber, "EstResponseRateDisplay", False, DataSourceUpdateMode.OnPropertyChanged)
            OASCAHPS_SwtichFromEstimatedDateDateTimePicker.DataBindings.Add("Value", mOASCAHPS_MedicareNumber, "SwitchToCalcDate", False, DataSourceUpdateMode.OnPropertyChanged)
            OASCAHPS_InactiveCheckBox.DataBindings.Add("Checked", mOASCAHPS_MedicareNumber, "IsInactive", False, DataSourceUpdateMode.OnPropertyChanged)
            OASCAHPS_NonSubmittingCheckbox.DataBindings.Add("Checked", mOASCAHPS_MedicareNumber, "NonSubmitting", False, DataSourceUpdateMode.OnPropertyChanged)
            OASCAHPS_SamplingRateNumericUpDown.DataBindings.Add("Value", mOASCAHPS_MedicareNumber, "SamplingRateOverrideDisplay", False, DataSourceUpdateMode.OnPropertyChanged)
            OASCAHPS_SwitchFromOverrideDateDateTimePicker.DataBindings.Add("Value", mOASCAHPS_MedicareNumber, "SwitchFromRateOverrideDate", False, DataSourceUpdateMode.OnPropertyChanged)

            If Date.Compare(mOASCAHPS_MedicareNumber.SwitchToCalcDate, Date.Now) < 0 Then
                OASCAHPS_SwtichFromEstimatedDateDateTimePicker.Enabled = False
                OASCAHPS_EstimatedAnnualVolumeNumericUpDown.Enabled = False
                OASCAHPS_EstimatedResponseRateNumericUpDown.Enabled = False
            Else
                OASCAHPS_SwtichFromEstimatedDateDateTimePicker.Enabled = True
                OASCAHPS_EstimatedAnnualVolumeNumericUpDown.Enabled = True
                OASCAHPS_EstimatedResponseRateNumericUpDown.Enabled = True
            End If

            If CurrentUser.MayOverrideSamplingRate Then
                OASCAHPS_SwitchFromOverrideDateDateTimePicker.Enabled = True
                OASCAHPS_SamplingRateNumericUpDown.Enabled = True
            Else
                OASCAHPS_SwitchFromOverrideDateDateTimePicker.Enabled = False
                OASCAHPS_SamplingRateNumericUpDown.Enabled = False
            End If

            'Unbound controls
            DisplaySamplingLock_OASCAHPS(mOASCAHPS_MedicareNumber.SamplingLocked)

            OASCAHPS_AnnualEligibleVolumeNumericUpDown.Value = mOASCAHPS_MedicareNumber.AnnualEligibleVolume
            OASCAHPS_HistoricResponseRateNumericUpDown.Value = mOASCAHPS_MedicareNumber.HistoricResponseRateDisplay

            'History Information
            If mOASCAHPS_MedicareNumber.LastRecalcDateCalculated = Date.MinValue Then
                OASCAHPS_LastCalcDateTextBox.Text = "Never"
            Else
                OASCAHPS_LastCalcDateTextBox.Text = mOASCAHPS_MedicareNumber.LastRecalcDateCalculated.ToString
            End If

            If mOASCAHPS_MedicareNumber.LastRecalcPropCalcType Is Nothing Then
                OASCAHPS_LastCalcTypeTextBox.Text = "Unknown"
            Else
                OASCAHPS_LastCalcTypeTextBox.Text = mOASCAHPS_MedicareNumber.LastRecalcPropCalcType.MedicarePropCalcTypeName
            End If

            OASCAHPS_CalcProportionNumericUpDown.Value = mOASCAHPS_MedicareNumber.LastRecalcProportionDisplay

            If mOASCAHPS_MedicareNumber.LastRecalcHistory IsNot Nothing AndAlso mOASCAHPS_MedicareNumber.LastRecalcHistory.MedicarePropDataTypeID = MedicareProportionDataTypes.RateOverride Then
                OASCAHPS_ProportionUsedNumericUpDown.Value = mOASCAHPS_MedicareNumber.LastRecalcHistory.SamplingRateOverrideDisplay
            Else
                OASCAHPS_ProportionUsedNumericUpDown.Value = OASCAHPS_CalcProportionNumericUpDown.Value
            End If
        Else
            OASCAHPS_SamplingLockTextBox.Text = ""
        End If

        'Set sample unlock flag
        mOASCAHPS_SampleUnlocked = False

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

    Private Sub DisplaySamplingLock_OASCAHPS(ByVal locked As Boolean)
        With OASCAHPS_SamplingLockTextBox
            If locked Then
                .Text = "Locked"
                .ForeColor = Color.Red
            Else
                .Text = "Unlocked"
                .ForeColor = System.Drawing.SystemColors.WindowText
            End If
        End With

        OASCAHPS_MedicareUnlockSamplingButton.Enabled = locked
    End Sub

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
                If mOASCAHPS_MedicareNumber IsNot Nothing Then
                    DisplaySamplingLock_OASCAHPS(mOASCAHPS_MedicareNumber.SamplingLocked)
                Else
                    DisplaySamplingLock_OASCAHPS(False)
                End If
                OASCAHPS_MedicareCalcHistoryButton.Enabled = True
                OASCAHPS_MedicareReCalcButton.Enabled = True
        End Select

    End Sub

    Private Function IsSurveyTypeMedicareInvalid(ByRef medicareNumber As MedicareSurveyType, validationType As Int16) As Boolean

        Dim showInvalidMessage As Boolean = False
        Dim message As String = ""
        Dim caption As String = ""
        Select Case validationType
            Case const_Apply_ValidationType
                caption = "Invalid Medicare Number"
            Case const_ForceCalc_ValidationType
                caption = "Recalc Proportion"
            Case const_UnlockSampling_ValidationType
                caption = "Unlock Sampling"
            Case const_AllowInactivate_ValidationType
                caption = "Invalid Medicare Number"
            Case Else
                caption = "Invalid Medicare Number"
        End Select

        If medicareNumber IsNot Nothing Then
            If medicareNumber.IsDirty And Not medicareNumber.IsValid Then
                showInvalidMessage = True
                For currentPos As Integer = 0 To medicareNumber.BrokenRulesCollection.Count - 1
                    Select Case medicareNumber.BrokenRulesCollection.Item(currentPos).Property.ToLower
                        Case "annualreturntarget"
                            message = message + "Annual Target must be greater than 0." + vbCrLf
                        Case "proportionchangethresholddisplay"
                            message = message + "Proportion Change Threshold must be at least 1%." + vbCrLf
                        Case Else
                    End Select
                Next
            End If

            If CurrentUser.MayOverrideSamplingRate Then
                If Date.Compare(medicareNumber.SwitchFromRateOverrideDate.Date, Date.Now().Date) >= 0 Then
                    If medicareNumber.SamplingRateOverrideDisplay <= CDec(0.99) Then
                        message = message + "If Switch from Override Date is in the future, Sampling Rate must be at least 1%." + vbCrLf
                        showInvalidMessage = True
                    End If
                Else
                    If Date.Compare(medicareNumber.SwitchToCalcDate.Date, #1/1/1900#) = 0 OrElse medicareNumber.EstAnnualVolume <= 0 OrElse medicareNumber.EstResponseRateDisplay <= CDec(0.99) Then
                        message = message + "Switch from Estimated Date must be populated, Estimated Annual Volume must be greater than 0, Estimated Response Rate must be at least 1%." + vbCrLf
                        showInvalidMessage = True
                    End If
                End If
            Else
                If Date.Compare(medicareNumber.SwitchToCalcDate.Date, #1/1/1900#) = 0 OrElse medicareNumber.EstAnnualVolume <= 0 OrElse medicareNumber.EstResponseRateDisplay <= CDec(0.99) Then
                    message = message + "Switch from Estimated Date must be populated, Estimated Annual Volume must be greater than 0, Estimated Response Rate must be at least 1%." + vbCrLf
                    showInvalidMessage = True
                End If

            End If
        End If

        If showInvalidMessage Then
            message = message + "Please correct and try again." + vbCrLf
            MessageBox.Show(message, caption, MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If

        Return showInvalidMessage

    End Function

    Private Sub SurveyTypeMedicareReCalcButton_Click(ByRef medicareNumber As MedicareSurveyType, surveyTypeID As Integer)

        If IsSurveyTypeMedicareInvalid(medicareNumber, const_ForceCalc_ValidationType) Then
            Exit Sub
        End If

        If medicareNumber.IsDirty Then
            MessageBox.Show("You must save changes before you can recalculate the proportion.", "Recalc Proportion", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Exit Sub
        End If

        Dim dlg As ForceRecalculate = New ForceRecalculate(medicareNumber, surveyTypeID)

        If dlg.ShowDialog() = DialogResult.OK Then
            Dim medicareCommon As MedicareCommon = New MedicareCommon(mMedicareNumber.MedicareNumber, mMedicareNumber.Name)

            medicareNumber.ApplyEdit()
            medicareNumber.Save()

            If surveyTypeID = const_HHCAHPS_SurveyTypeID Then
                If mHHCAHPS_SampleUnlocked Then medicareCommon.LogUnlockSample(CurrentUser.MemberID, surveyTypeID)
            Else
                If mOASCAHPS_SampleUnlocked Then medicareCommon.LogUnlockSample(CurrentUser.MemberID, surveyTypeID)
            End If

            medicareNumber.BeginEdit()
            PopulateMedicareSection()
            End If

    End Sub

    Private Sub SurveyTypeMedicareUnlockSamplingButton_Click(ByRef medicareNumber As MedicareSurveyType, surveyTypeID As Integer)
        If Not medicareNumber.SamplingLocked Then Exit Sub

        If IsSurveyTypeMedicareInvalid(medicareNumber, const_UnlockSampling_ValidationType) Then
            Exit Sub
        End If

        'Lets unlock it
        If MessageBox.Show("Are you sure you wish to unlock sampling for this medicare number?", "Unlock Sampling", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
            'User says do it
            medicareNumber.SamplingLocked = False
            'Set sample unlock flag. Written to log table during save.
            If surveyTypeID = const_HHCAHPS_SurveyTypeID Then
                mHHCAHPS_SampleUnlocked = True
                DisplaySamplingLock_HHCAHPS(medicareNumber.SamplingLocked)
            Else
                mOASCAHPS_SampleUnlocked = True
                DisplaySamplingLock_OASCAHPS(medicareNumber.SamplingLocked)
            End If
        End If
    End Sub

    Private Sub SurveyTypeApplyButton_Click(ByRef medicareNumber As MedicareSurveyType, surveyTypeID As Int16)

        If IsSurveyTypeMedicareInvalid(medicareNumber, const_Apply_ValidationType) Then
            Exit Sub
        End If

        If medicareNumber IsNot Nothing AndAlso medicareNumber.IsDirty Then

            medicareNumber.ApplyEdit()
            medicareNumber.Save()

            If surveyTypeID = const_HHCAHPS_SurveyTypeID Then
                If mHHCAHPS_SampleUnlocked Then
                    Dim medicareCommon As MedicareCommon = New MedicareCommon(mMedicareNumber.MedicareNumber, mMedicareNumber.Name)
                    medicareCommon.LogUnlockSample(CurrentUser.MemberID, const_HHCAHPS_SurveyTypeID)
                    mHHCAHPS_SampleUnlocked = False
                End If
            Else
                If mOASCAHPS_SampleUnlocked Then
                    Dim medicareCommon As MedicareCommon = New MedicareCommon(mMedicareNumber.MedicareNumber, mMedicareNumber.Name)
                    medicareCommon.LogUnlockSample(CurrentUser.MemberID, const_OASCAHPS_SurveyTypeID)
                    mOASCAHPS_SampleUnlocked = False
                End If

            End If

            medicareNumber.BeginEdit()

        End If

        If mMedicareNumber.IsNew() Then
            mMedicareNumber.ProportionCalcTypeID = MedicareProportionCalcTypes.Estimated
            mMedicareNumber.EstAnnualVolume = 1
            mMedicareNumber.IsActive = False
            mMedicareNumber.ApplyEdit()
            mMedicareNumber.Save()
            mMedicareNumber.BeginEdit()
            With MedicareNumberTextBox
                .DataBindings.Clear()
                .Text = ""
            End With
            With MedicareNameTextBox
                .DataBindings.Clear()
                .Text = ""
            End With
            PopulateMedicareSection_HCAHPS()
        End If

    End Sub

    Private Sub SurveyTypeCancelButton_Click(ByRef medicareNumber As MedicareSurveyType)
        Dim isDirty As Boolean = False
        If medicareNumber IsNot Nothing Then
            isDirty = medicareNumber.IsDirty
        End If

        If isDirty Then
            If MessageBox.Show("Are you sure you wish to cancel all changes?", "Cancel Changes", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
                'The user has chosen to undo all changes
                medicareNumber.CancelEdit()

                PopulateMedicareSection()
                medicareNumber.BeginEdit()

            End If
        End If

    End Sub

    Private Function newMedicareSurveyType(surveyTypeID As Int16) As MedicareSurveyType
        Dim medicareNumber As MedicareSurveyType = Nothing

        medicareNumber = MedicareSurveyTypeProvider.Instance.Select(mMedicareNumber.MedicareNumber, surveyTypeID)

        If medicareNumber Is Nothing Then

            medicareNumber = MedicareSurveyType.NewMedicareSurveyType(GlobalDef)
            medicareNumber.BeginPopulate()

            medicareNumber.MedicareNumber = mMedicareNumber.MedicareNumber
            medicareNumber.Name = mMedicareNumber.Name
            medicareNumber.SurveyTypeID = surveyTypeID

            Dim quarterNumber As Integer = (Date.Now().Month() - 1) \ 3 + 1
            Dim firstDayOfQuarterNextYear As New DateTime(Date.Now().Year + 1, (quarterNumber - 1) * 3 + 1, 1)

            medicareNumber.EstResponseRate = GlobalDef.RespRate
            medicareNumber.SwitchToCalcDate = firstDayOfQuarterNextYear
            medicareNumber.AnnualReturnTarget = GlobalDef.AnnualReturnTarget
            medicareNumber.SamplingLocked = False
            medicareNumber.ProportionChangeThreshold = GlobalDef.ProportionChangeThreshold
            medicareNumber.IsActive = True
            medicareNumber.NonSubmitting = False
            medicareNumber.SwitchFromRateOverrideDate = New Date(1900, 1, 1)

            medicareNumber.EndPopulate()
            medicareNumber.IsMedicareNew = True
            medicareNumber.IsMedicareDirty = False
        End If

        Return medicareNumber

    End Function

#End Region

End Class
