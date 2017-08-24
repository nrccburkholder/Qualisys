Imports Nrc.Qualisys.Library
Public Class ForceRecalculate

#Region "Private Members"
    Private Const const_HCAHPS_SurveyTypeID As Integer = 2
    Private Const const_HHCAHPS_SurveyTypeID As Integer = 3
    Private Const const_OASCAHPS_SurveyTypeID As Integer = 16

    Private mMedicareNumber As MedicareNumber = Nothing
    Private mHHCAHPS_MedicareNumber As MedicareSurveyType = Nothing
    Private mOASCAHPS_MedicareNumber As MedicareSurveyType = Nothing
    Private mSurveyTypeID As Integer

#End Region

#Region "Constructors"

    Public Sub New(ByVal medicareNum As Object, Optional surveyTypeID As Integer = const_HCAHPS_SurveyTypeID)

        InitializeComponent()

        Select Case surveyTypeID
            Case const_HCAHPS_SurveyTypeID
                mMedicareNumber = CType(medicareNum, MedicareNumber)
            Case const_HHCAHPS_SurveyTypeID
                mHHCAHPS_MedicareNumber = CType(medicareNum, MedicareSurveyType)
            Case Else
                mOASCAHPS_MedicareNumber = CType(medicareNum, MedicareSurveyType)
        End Select

        'If TypeOf medicareNum Is MedicareNumber Then
        '    mMedicareNumber = CType(medicareNum, MedicareNumber)
        'Else
        '    mHHCAHPS_MedicareNumber = CType(medicareNum, MedicareSurveyType)
        'End If

        mSurveyTypeID = surveyTypeID
        InitMedicareValues()

    End Sub

#End Region

#Region "Event Handlers"

    Private Sub ForceRecalculate_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Set the section header
        'Me.Caption = String.Format("Force Recalculation For: {0} ({1})", mMedicareNumber.MedicareNumber, mMedicareNumber.Name)

        Select Case mSurveyTypeID
            Case const_HCAHPS_SurveyTypeID
                Me.Caption = String.Format("Force Recalculation For: {0} ({1})", mMedicareNumber.MedicareNumber, mMedicareNumber.Name)
            Case const_HHCAHPS_SurveyTypeID
                Me.Caption = String.Format("Force Recalculation For: {0} ({1})", mHHCAHPS_MedicareNumber.MedicareNumber, mHHCAHPS_MedicareNumber.Name)
            Case Else
                Me.Caption = String.Format("Force Recalculation For: {0} ({1})", mOASCAHPS_MedicareNumber.MedicareNumber, mOASCAHPS_MedicareNumber.Name)
        End Select

    End Sub

    Private Sub cmdCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCancel.Click

        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        Me.Close()

    End Sub

    Private Sub cmdCalculate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCalculate.Click

        Try
            'Set the wait cursor
            Me.Cursor = Cursors.WaitCursor

            Dim samplingLocked As Boolean
            Dim calculationErrors As New List(Of String)
            Select Case mSurveyTypeID
                Case const_HCAHPS_SurveyTypeID
                    samplingLocked = mMedicareNumber.SamplingLocked
                    calculationErrors = mMedicareNumber.CalculationErrors
                Case const_HHCAHPS_SurveyTypeID
                    samplingLocked = mHHCAHPS_MedicareNumber.SamplingLocked
                    calculationErrors = mHHCAHPS_MedicareNumber.CalculationErrors
                Case Else
                    samplingLocked = mOASCAHPS_MedicareNumber.SamplingLocked
                    calculationErrors = mOASCAHPS_MedicareNumber.CalculationErrors
            End Select


            If Not samplingLocked Then
                Dim message As String = String.Empty
                Dim sampleLockNotifyFailed As Boolean = False
                Dim forceRecalculate As Boolean = False

                Select Case mSurveyTypeID
                    Case const_HCAHPS_SurveyTypeID
                        forceRecalculate = mMedicareNumber.ForceRecalculate(CDate(cboCalcDates.SelectedItem), CurrentUser.MemberID, sampleLockNotifyFailed)
                    Case const_HHCAHPS_SurveyTypeID
                        forceRecalculate = mHHCAHPS_MedicareNumber.ForceRecalculate(CDate(cboCalcDates.SelectedItem), CurrentUser.MemberID, sampleLockNotifyFailed)
                    Case Else
                        forceRecalculate = mOASCAHPS_MedicareNumber.ForceRecalculate(CDate(cboCalcDates.SelectedItem), CurrentUser.MemberID, sampleLockNotifyFailed)
                End Select

                If forceRecalculate Then
                    'Display a success message to the user
                    message = "Calculation Successful."

                    'Determine if we need to notify the user of a sample lock
                    If samplingLocked Then
                        message &= vbCrLf & vbCrLf & "Sampling has been locked due to the new proportion" & vbCrLf &
                                                     "exceeding the allowable threshold."

                        'Determine if we need to display the sample lock notification failed message
                        If sampleLockNotifyFailed Then
                            message &= vbCrLf & vbCrLf & "The system was unable to send a notification to the" & vbCrLf &
                                                         "HCAHPSThresholdExceeded email group."
                        End If
                    End If

                    MessageBox.Show(message, "Proportion Calculation", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Me.DialogResult = Windows.Forms.DialogResult.OK
                    Me.Close()
                Else
                    'Display an error message to the user
                    message = "Calculation Failed!." & vbCrLf
                    For Each errString As String In calculationErrors
                        message &= vbCrLf & errString
                    Next
                    MessageBox.Show(message, "Proportion Calculation Error!", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End If
            Else
                'Tell the user that they need to unlock sampling first
                MessageBox.Show("Sampling must first be unlocked before calculating the proportion.", "Proportion Calculation Error!", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If

        Catch ex As Exception
            Globals.ReportException(ex, "Proportion Calculation Error")

        Finally
            'Reset the wait cursor
            Me.Cursor = Me.DefaultCursor

        End Try

    End Sub

#End Region

#Region "Private Methods"

    Private Sub InitMedicareValues()

        Dim setMonth As Integer = 0
        Dim index As Integer = 0
        Dim globalRecalcDates As MedicareGlobalCalcDateCollection

        Select Case mSurveyTypeID
            Case const_HCAHPS_SurveyTypeID
                globalRecalcDates = mMedicareNumber.MedicareGlobalDates
            Case const_HHCAHPS_SurveyTypeID
                globalRecalcDates = mHHCAHPS_MedicareNumber.MedicareGlobalDates
            Case Else
                globalRecalcDates = mOASCAHPS_MedicareNumber.MedicareGlobalDates
        End Select

        Dim monthList As New List(Of Integer)

        For Each item As MedicareGlobalCalcDate In globalRecalcDates
            monthList.Add(item.ReCalcMonth)
        Next
        monthList.Sort()

        Dim dte As Date = Now
        For j As Integer = 0 To monthList.Count - 1
            If dte.Month >= monthList(j) Then
                setMonth = monthList(j)
                index = j
            End If
        Next

        cboCalcDates.Items.Add(CDate(setMonth & "/1/" & dte.Year))
        If monthList(0) = setMonth Then
            cboCalcDates.Items.Add(CDate(monthList(monthList.Count - 1) & "/1/" & (dte.Year - 1)))
        Else
            cboCalcDates.Items.Add(CDate(monthList(index - 1) & "/1/" & dte.Year))
        End If

    End Sub

#End Region

End Class
