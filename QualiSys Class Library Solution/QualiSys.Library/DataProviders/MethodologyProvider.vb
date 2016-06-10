Namespace DataProvider
    Public MustInherit Class MethodologyProvider

#Region " Singleton Implementation "

        Private Shared mInstance As MethodologyProvider
        Private Const mProviderName As String = "MethodologyProvider"

        Public Shared ReadOnly Property Instance() As MethodologyProvider
            <DebuggerHidden()> _
                Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of MethodologyProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

        Protected Sub New()

        End Sub

        Public MustOverride Function [Select](ByVal methodologyId As Integer) As Methodology
        Public MustOverride Function SelectBySurveyId(ByVal surveyId As Integer) As Collection(Of Methodology)
        Public MustOverride Function SelectMethodologyStepsByMethodologyId(ByVal methodologyId As Integer) As MethodologyStepCollection
        Public MustOverride Function SelectStandardMethodologySteps(ByVal standardMethodologyId As Integer) As MethodologyStepCollection
        Public MustOverride Function SelectStandardMethodology(ByVal standardMethodologyId As Integer) As StandardMethodology
        'Public MustOverride Function SelectStandardMethodologiesBySurveyType(ByVal srvyType As SurveyTypes) As Collection(Of StandardMethodology)
        Public MustOverride Function SelectAllMethodologyStepTypes() As Collection(Of MethodologyStepType)
        Public MustOverride Function SelectMethodologyStep(ByVal Id As Integer) As MethodologyStep

        Public MustOverride Function Insert(ByVal meth As Methodology) As Integer

        Public MustOverride Sub Update(ByVal meth As Methodology)
        Public MustOverride Sub UpdateVendor(ByVal meth As Methodology)
        Public MustOverride Sub UpdateActiveState(ByVal methodologyId As Integer, ByVal isActive As Boolean)

        Public MustOverride Sub Delete(ByVal methodologyId As Integer)

        Public MustOverride Function SelectStandardMethodologiesBySurveyType(ByVal srvyType As SurveyTypes, ByVal subType As SubType) As Collection(Of StandardMethodology)

        Protected Shared Function CreateMethodology(ByVal id As Integer, ByVal surveyId As Integer, ByVal allowEdit As Boolean, ByVal isCustomizable As Boolean, ByVal dateCreated As DateTime, ByVal standardMethodologyId As Integer) As Methodology

            Dim meth As New Methodology(standardMethodologyId)

            meth.Id = id
            meth.SurveyId = surveyId
            meth.AllowEdit = allowEdit
            meth.IsCustomizable = isCustomizable
            meth.DateCreated = dateCreated
            meth.ResetDirtyFlag()

            Return meth

        End Function

        Protected Shared Function CreateMethodologyStep(ByVal id As Integer) As MethodologyStep

            Dim methStep As New MethodologyStep()

            methStep.Id = id

            Return methStep

        End Function

        Protected Shared Function CreateMethodologyStepType(ByVal id As Integer, ByVal isSurvey As Boolean, ByVal isThankYou As Boolean, ByVal name As String, ByVal stepMethodId As Integer, ByVal isCoverLetterRequired As Boolean, ByVal expirationDays As Integer, ByVal quotaID As Nullable(Of Integer), ByVal quotaStopCollectionAt As Integer, ByVal daysInField As Integer, ByVal numberOfAttempts As Integer, ByVal isWeekDayDayCall As Boolean, ByVal isWeekDayEveCall As Boolean, ByVal isSaturdayDayCall As Boolean, ByVal isSaturdayEveCall As Boolean, ByVal isSundayDayCall As Boolean, ByVal isSundayEveCall As Boolean, ByVal isCallBackOtherLang As Boolean, ByVal isCallBackUsingTTY As Boolean, ByVal isAcceptPartial As Boolean, ByVal isEmailBlast As Boolean, ByVal isExcludePII As Boolean) As MethodologyStepType

            Dim stepType As New MethodologyStepType

            stepType.Id = id
            stepType.IsSurvey = isSurvey
            stepType.IsThankYouLetter = isThankYou
            stepType.Name = name
            stepType.StepMethodId = stepMethodId
            stepType.IsCoverLetterRequired = isCoverLetterRequired
            stepType.ExpirationDays = expirationDays
            stepType.QuotaID = quotaID
            stepType.QuotaStopCollectionAt = quotaStopCollectionAt
            stepType.DaysInField = daysInField
            stepType.NumberOfAttempts = numberOfAttempts
            stepType.IsWeekDayDayCall = isWeekDayDayCall
            stepType.IsWeekDayEveCall = isWeekDayEveCall
            stepType.IsSaturdayDayCall = isSaturdayDayCall
            stepType.IsSaturdayEveCall = isSaturdayEveCall
            stepType.IsSundayDayCall = isSundayDayCall
            stepType.IsSundayEveCall = isSundayEveCall
            stepType.IsCallBackOtherLang = isCallBackOtherLang
            stepType.IsCallBackUsingTTY = isCallBackUsingTTY
            stepType.IsAcceptPartial = isAcceptPartial
            stepType.IsEmailBlast = isEmailBlast
            stepType.IsExcludePII = isExcludePII

            Return stepType

        End Function

        Protected Shared Function CreateStandardMethodology(ByVal id As Integer, ByVal name As String, ByVal isCustomizable As Boolean, ByVal isExpired As Boolean) As StandardMethodology

            Dim standard As New StandardMethodology

            standard.Id = id
            standard.Name = name
            standard.IsCustomizable = isCustomizable
            standard.IsExpired = isExpired

            Return standard

        End Function

        Protected NotInheritable Class ReadOnlyAccessor

            Private Sub New()

            End Sub

            Public Shared WriteOnly Property MethodologyId(ByVal obj As Methodology) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

            Public Shared WriteOnly Property MethodologyStepId(ByVal obj As MethodologyStep) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

        End Class

    End Class

End Namespace

