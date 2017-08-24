Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.Notification
Imports Nrc.Framework.BusinessLogic.Configuration

<Serializable()>
Public Class MedicareCommon

#Region "Private Fields"

    Private mMedicareNumber As String = String.Empty
    Private mName As String = String.Empty
    Private mMedicareGlobalDates As MedicareGlobalCalcDateCollection

#End Region

#Region "Public Properties"
    Public Property MedicareNumber() As String
        Get
            Return mMedicareNumber
        End Get
        Set(ByVal value As String)
            If mMedicareNumber <> value Then
                mMedicareNumber = value
            End If
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
            End If
        End Set
    End Property

    Private ReadOnly Property MedicareGlobalDates() As MedicareGlobalCalcDateCollection
        Get
            If Me.mMedicareGlobalDates Is Nothing Then
                Me.mMedicareGlobalDates = MedicareGlobalCalcDate.GetAll()
            End If
            Return Me.mMedicareGlobalDates
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal medicareNum As String, ByVal medicareName As String)

        Me.MedicareNumber = medicareNum
        Me.Name = medicareName

    End Sub

#End Region

#Region "Public Methods"

    Public Function GetPropSampleDate(ByVal sampleDate As Date) As Date

        Dim dateList As List(Of Integer) = GetOrderedRecalcDates()
        Dim dateNow As Date = CDate(String.Format("{0}/1/{1}", sampleDate.Month, sampleDate.Year))

        'Get the most current date that has alread passed.
        Dim setCalcDate As Date = dateNow
        For i As Integer = 0 To dateList.Count - 1
            Dim dateItem As Date = CDate(String.Format("{0}/1/{1}", dateList(i), sampleDate.Year))
            If dateNow >= dateItem Then
                setCalcDate = dateItem
            End If
        Next

        Return setCalcDate

    End Function

    ''' <summary>Helper method to order the global recal dates.</summary>
    ''' <returns></returns>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function GetOrderedRecalcDates() As List(Of Integer)

        Dim dateList As New List(Of Integer)

        For Each calcDate As MedicareGlobalCalcDate In MedicareGlobalDates
            dateList.Add(calcDate.ReCalcMonth)
        Next
        dateList.Sort()

        Return dateList

    End Function

    Public Function GetHistoricValues(ByVal sampleDate As Date, ByRef annualEligibleVolume As Integer, ByRef historicResponseRate As Decimal, Optional ByVal surveyTypeID As Integer = 2) As Boolean

        Dim propSampleDate As Date = GetPropSampleDate(sampleDate)
        Dim canUseHistoric As Boolean = MedicareProvider.Instance.HasHistoricValues(MedicareNumber, propSampleDate, surveyTypeID)

        If canUseHistoric Then
            annualEligibleVolume = MedicareProvider.Instance.GetHistoricAnnualVolume(MedicareNumber, propSampleDate, surveyTypeID)
            historicResponseRate = MedicareProvider.Instance.GetHistoricRespRate(MedicareNumber, propSampleDate, surveyTypeID)
        Else
            annualEligibleVolume = 0
            historicResponseRate = 0
        End If

        Return canUseHistoric

    End Function

    Public Sub SendSamplingLockNotification(ByVal lastRecalcDateCalculated As Date, ByVal lastRecalcProportion As Decimal, ByVal currCalc As MedicareRecalcHistory, ByVal surveyTypeID As Integer)

        Dim toList As New List(Of String)
        Dim ccList As New List(Of String)
        Dim recipientNoteText As String = String.Empty
        Dim recipientNoteHtml As String = String.Empty
        Dim environment As String = String.Empty

        'Get the listing of sample unit information for the email
        Dim lockDataTable As DataTable = MedicareProvider.Instance.SelectLockedSampleUnitsByMedicareNumber(MedicareNumber)

        'Determine who the recipients are going to be
        toList.Add("HCAHPSThresholdExceeded@NationalResearch.com")

        'Add the account directors from QualiSys to the CC list
        Dim studies As New List(Of Integer)
        For Each row As DataRow In lockDataTable.Rows
            'Get the study object associated with this row and add the account director email
            Dim studyID As Integer = CInt(row("StudyID"))
            If Not studies.Contains(studyID) Then
                studies.Add(studyID)
                Dim curStudy As Study = Study.GetStudy(studyID)
                If Not ccList.Contains(curStudy.AccountDirector.Email) Then
                    ccList.Add(curStudy.AccountDirector.Email)
                End If
            End If
        Next

        'Determine recipients based on environment
        If AppConfig.EnvironmentType <> EnvironmentTypes.Production Then
            'We are not in production
            'Add the real recipients to the note
            recipientNoteText = String.Format("{0}{0}Production To:{0}", vbCrLf)
            For Each email As String In toList
                recipientNoteText &= email & vbCrLf
            Next
            recipientNoteText &= String.Format("{0}Production CC:{0}", vbCrLf)
            For Each email As String In ccList
                recipientNoteText &= email & vbCrLf
            Next
            recipientNoteHtml = recipientNoteText.Replace(vbCrLf, "<BR/>")

            'Clear the lists
            toList.Clear()
            ccList.Clear()

            'Populate the ToList with the Testing group only
            toList.Add("Testing@NationalResearch.com")

            'Set the environment string
            environment = String.Format("({0})", AppConfig.EnvironmentName)
        End If

        'Create the message
        Dim lockMessage As Message = New Message("MedicareProportionChangeThresholdExceeded", "")

        'Set the message properties
        With lockMessage
            'To recipient
            For Each email As String In toList
                .To.Add(email)
            Next

            'CC recipient
            For Each email As String In ccList
                .Cc.Add(email)
            Next

            'Add the replacement values
            With .ReplacementValues
                .Add("MedicareNumber", MedicareNumber)
                .Add("MedicareName", Name)
                .Add("PrevCalcDate", lastRecalcDateCalculated.ToString)
                .Add("PrevCalcProp", lastRecalcProportion.ToString("0.0000%"))
                .Add("CurrCalcDate", currCalc.DateCalculated.ToString)
                .Add("CurrCalcProp", currCalc.ProportionCalcPct.ToString("0.0000%"))
                .Add("RecipientNoteText", recipientNoteText)
                .Add("RecipientNoteHtml", recipientNoteHtml)
                .Add("Environment", environment)
                .Add("RecalcHistoryLink", String.Format("{0}&MedicareNumber={1}", AppConfig.Params("CMRecalcHistoryReport").StringValue, MedicareNumber))
                'TODO: change to use the following URL once Ted is done with the report changes
                '.Add("RecalcHistoryLink", String.Format("{0}&MedicareNumber={1}&SurveyTypeID={2}", AppConfig.Params("CMRecalcHistoryReport").StringValue, MedicareNumber, surveyTypeID))
            End With

            'Add the replacement tables
            With .ReplacementTables
                .Add("LockedUnits_Text", lockDataTable)
                .Add("LockedUnits_Html", lockDataTable)
            End With

            'Send the message
            .Send()
        End With

    End Sub

    Public Sub LogUnlockSample(ByVal memberId As Integer, ByVal surveyTypeID As Integer)

        MedicareProvider.Instance.LogUnlockSample(MedicareNumber, memberId, Date.Now, surveyTypeID)

    End Sub

    Public Function NeedToRecalculateProportion(ByVal sampleDate As Date, ByVal lastRecalcPropSampleCalcDate As Date) As Boolean

        Dim setCalcDate As Date = GetPropSampleDate(sampleDate)

        ' If the last calc'd date is before the set calc date, then you are OK.
        Return (setCalcDate > lastRecalcPropSampleCalcDate)

    End Function

#End Region

End Class

