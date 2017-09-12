Imports Nrc.Qualisys.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class SampleDefinition

#Region "Private Members"

    Private mSurvey As Survey
    Private mPeriod As SamplePeriod
    Private mStartDate As Nullable(Of Date)
    Private mEndDate As Nullable(Of Date)
    Private mIsHCAHPS As Boolean
    Private mDoOverSample As Boolean
    Private mDoHCAHPSOverSample As Boolean

    Private mParent As NewSampleDefinition
    Private mRow As DataGridViewRow

#End Region

#Region "Public Properties"

    Public ReadOnly Property Survey() As Survey
        Get
            Return mSurvey
        End Get
    End Property

    Public ReadOnly Property SurveyDisplayLabel() As String
        Get
            Return mSurvey.DisplayLabel
        End Get
    End Property

    Public ReadOnly Property Period() As SamplePeriod
        Get
            Return mPeriod
        End Get
    End Property

    Public ReadOnly Property PeriodDisplayLabel() As String
        Get
            Return mPeriod.Name
        End Get
    End Property

    Public ReadOnly Property StartDate() As Nullable(Of Date)
        Get
            Return mStartDate
        End Get
    End Property

    Public ReadOnly Property EndDate() As Nullable(Of Date)
        Get
            Return mEndDate
        End Get
    End Property

    'Public ReadOnly Property IsHCAHPS() As Boolean
    '    Get
    '        Return (mSurvey.SurveyType = SurveyTypes.Hcahps)
    '    End Get
    'End Property

    Public ReadOnly Property IsOverSample() As Boolean
        Get
            Return (mPeriod.SampleSets.Count >= mPeriod.ExpectedSamples)
        End Get
    End Property

    Public Property DoOverSample() As Boolean
        Get
            Return mDoOverSample
        End Get
        'Reset the DoHCAPSOverSample canNOT be True if DoOverSample is set to false
        Set(ByVal value As Boolean)
            If Not value Then
                mDoHCAHPSOverSample = False
            End If
            mDoOverSample = value
        End Set
    End Property

    Public Property DoHCAHPSOverSample() As Boolean
        Get
            Return mDoHCAHPSOverSample
        End Get
        'DoHCAHPSOversample can be set to True only when
        'DoOverSample and IsHCAHPS are True
        Set(ByVal value As Boolean)
            If mSurvey.AllowOverSample AndAlso DoOverSample Then 'IsHCAHPS Then 'Possible TODO: create separate property for AllowDoOverSample CJB 7/3/2014
                mDoHCAHPSOverSample = value
            Else
                mDoHCAHPSOverSample = False
            End If
        End Set
    End Property

    Public Property RowErrorText() As String
        Get
            Return mRow.Cells(0).ErrorText
        End Get
        Set(ByVal value As String)
            mRow.Cells(0).ErrorText = value
        End Set
    End Property

#End Region

#Region "Constructors"

    Public Sub New(ByVal parent As NewSampleDefinition, ByVal row As DataGridViewRow)

        mRow = row
        mParent = parent

        mSurvey = DirectCast(mRow.Tag, Survey)
        mPeriod = SampleDefinition.GetSelectedPeriod(row.Cells(mParent.NewSampleSetPeriodColumn.Index))

        If mRow.Cells(mParent.NewSampleSetStartDateColumn.Index).Value Is Nothing Then
            mStartDate = Nothing
        Else
            mStartDate = DirectCast(row.Cells(mParent.NewSampleSetStartDateColumn.Index).Value, Date)
        End If

        If mRow.Cells(mParent.NewSampleSetEndDateColumn.Index).Value Is Nothing Then
            mEndDate = Nothing
        Else
            mEndDate = DirectCast(row.Cells(mParent.NewSampleSetEndDateColumn.Index).Value, Date)
        End If

    End Sub

#End Region

#Region "Public Methods"

    Public Shared Function GetSelectedPeriod(ByVal cell As DataGridViewCell) As SamplePeriod

        Dim comboCell As DataGridViewComboBoxCell = DirectCast(cell, DataGridViewComboBoxCell)

        For Each period As SamplePeriod In comboCell.Items
            If period.Id = CType(comboCell.Value, Integer) Then
                Return period
            End If
        Next

        Return Nothing

    End Function

    ''' <summary>
    ''' Return false if can't recalculate
    ''' </summary>
    ''' <remarks></remarks>
    Public Function RecalcMedicareProportion() As Boolean

        Dim startDate As Date
        Dim surveyIsInvalid As Boolean = False
        Dim errMessage As String = String.Empty
        Dim sampleLockNotifyFailed As Boolean
        Dim sampleLockMessage As String = String.Empty

        'Determine the start date
        If mStartDate.HasValue Then
            startDate = mStartDate.Value
        Else
            startDate = Date.Now
        End If

        'If we are not going to do proportional sampling then we are out of here
        If mPeriod.ExpectedStartDate.HasValue Then 'AndAlso _
            'mPeriod.ExpectedStartDate.Value <AppConfig.Params("SwitchToPropSamplingDate").DateValue Then
            Return True
        End If

        'Get all of the medicare numbers associated with this survey
        Dim medicareNumbers As MedicareNumberList = MedicareNumber.GetBySurveyID(mSurvey.Id)

        'Recalculate the medicare proportions
        For Each medicareNum As MedicareNumber In medicareNumbers
            'Use parent medicareNum to get to correct child medicareNum by SurveyType
            If mSurvey.MedicareProportionBySurveyType Then
                Dim medicareNumST As MedicareSurveyType
                medicareNumST = MedicareSurveyType.Get(medicareNum.MedicareNumber, Survey.SurveyType)

                If medicareNumST.RecalculateProportion(startDate, CurrentUser.Member.MemberId, sampleLockNotifyFailed) Then
                    If medicareNumST.IsDirty Then
                        medicareNumST.Save()
                    End If

                    'Check for notification failure
                    If sampleLockNotifyFailed Then
                        sampleLockMessage &= vbCrLf & medicareNum.MedicareNumber
                    End If
                Else
                    'Errors were encountered while calculating the new proportion
                    errMessage &= String.Format("{0}{0}Medicare Number {1}:", vbCrLf, medicareNum.MedicareNumber)
                    For Each errString As String In medicareNumST.CalculationErrors
                        errMessage &= vbCrLf & errString
                    Next
                End If
            Else 'TODO: once HCAHPS is also MedicareProportionBySurveyType this block may be removed... CJB 9/12/2017
                If medicareNum.RecalculateProportion(startDate, CurrentUser.Member.MemberId, sampleLockNotifyFailed) Then
                    'Calculation was successful
                    If medicareNum.IsDirty Then
                        medicareNum.Save()
                    End If

                    'Check for notification failure
                    If sampleLockNotifyFailed Then
                        sampleLockMessage &= vbCrLf & medicareNum.MedicareNumber
                    End If
                Else
                    'Errors were encountered while calculating the new proportion
                    errMessage &= String.Format("{0}{0}Medicare Number {1}:", vbCrLf, medicareNum.MedicareNumber)
                    For Each errString As String In medicareNum.CalculationErrors
                        errMessage &= vbCrLf & errString
                    Next
                End If
            End If
        Next

        'Determine whether or not to show an error dialog
        If errMessage <> String.Empty Then
            errMessage = String.Format("Unable to calculate proportion(s) for Survey: {0}{1}", mSurvey.DisplayLabel, errMessage)
            MessageBox.Show(errMessage, "Proportion Calculation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        Else
            'Determine whether or not to show the sample lock notification message
            If sampleLockMessage <> String.Empty Then
                sampleLockMessage = "The system was unable to send the Sample Lock Notification" & vbCrLf & _
                                    "emails for the following Medicare Numbers:" & vbCrLf & sampleLockMessage & vbCrLf & _
                                    "Please contact the HCAHPS Compliance Team."
                MessageBox.Show(sampleLockMessage, "Error Sending Sample Lock Notification", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If

            Return True
        End If

    End Function
#End Region

#Region "Private Methods"

#End Region

End Class
