Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration

''' <summary>
''' Represents a step in the methodology for a survey.
''' </summary>
<DebuggerDisplay("{Name} ({Id})")> _
Public Class MethodologyStep
    Inherits BusinessBase(Of MethodologyStep)

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mName As String
    Private mMethodologyId As Integer
    Private mSurveyId As Integer
    Private mCoverLetterId As Integer
    Private mDaysSincePreviousStep As Integer
    Private mIsSurvey As Boolean
    Private mIsThankYouLetter As Boolean
    Private mIsFirstSurvey As Boolean
    Private mOverrideLanguageId As Nullable(Of Integer)
    Private mStepMethodId As Integer
    Private mExpirationDays As Integer
    Private mQuotaID As Nullable(Of Integer)
    Private mQuotaStopCollectionAt As Integer
    Private mDaysInField As Integer
    Private mNumberOfAttempts As Integer
    Private mIsWeekDayDayCall As Boolean = True
    Private mIsWeekDayEveCall As Boolean = True
    Private mIsSaturdayDayCall As Boolean = True
    Private mIsSaturdayEveCall As Boolean = True
    Private mIsSundayDayCall As Boolean = True
    Private mIsSundayEveCall As Boolean = True
    Private mIsCallBackOtherLang As Boolean
    Private mIsCallBackUsingTTY As Boolean
    Private mIsAcceptPartial As Boolean
    Private mIsEmailBlast As Boolean
    Private mVendorId As Nullable(Of Integer)
    Private mOrgVendorId As Nullable(Of Integer)
    Private mVendorVoviciDetail As VendorFile_VoviciDetail

    Private mLinkedStep As MethodologyStep
    Private mExpireFromStep As MethodologyStep

    Private mIsDirty As Boolean
    Private mParentCollection As MethodologyStepCollection
    Private mEmailBlastList As New EmailBlastCollection

#End Region

#Region " Public Properties "

    ''' <summary>
    ''' The QualiSys MailStepId for this mailing step.
    ''' </summary>
    <Logable()> _
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            If mId <> value Then
                mId = value
                PropertyChanged()
            End If
        End Set
    End Property

    ''' <summary>
    ''' The name of this step
    ''' </summary>
    <Logable()> _
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                PropertyChanged()
            End If
        End Set
    End Property

    ''' <summary>
    ''' The MethodologyID of this step.
    ''' </summary>
    <Logable()> _
    Public Property MethodologyId() As Integer
        Get
            Return mMethodologyId
        End Get
        Set(ByVal value As Integer)
            If mMethodologyId <> value Then
                mMethodologyId = value
                PropertyChanged()
            End If
        End Set
    End Property

    ''' <summary>
    ''' The SurveyID of this mailing step.
    ''' </summary>
    <Logable()> _
    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            If mSurveyId <> value Then
                mSurveyId = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public ReadOnly Property SequenceNumber() As Integer
        Get
            If mParentCollection IsNot Nothing Then
                Return ParentCollection.IndexOf(Me) + 1
            Else
                Return 0
            End If
        End Get
    End Property

    <Logable()> _
    Public Property CoverLetterId() As Integer
        Get
            Return mCoverLetterId
        End Get
        Set(ByVal value As Integer)
            If mCoverLetterId <> value Then
                mCoverLetterId = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property DaysSincePreviousStep() As Integer
        Get
            Return mDaysSincePreviousStep
        End Get
        Set(ByVal value As Integer)
            If mDaysSincePreviousStep <> value Then
                mDaysSincePreviousStep = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsSurvey() As Boolean
        Get
            Return mIsSurvey
        End Get
        Set(ByVal value As Boolean)
            If mIsSurvey <> value Then
                mIsSurvey = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsThankYouLetter() As Boolean
        Get
            Return mIsThankYouLetter
        End Get
        Set(ByVal value As Boolean)
            If mIsThankYouLetter <> value Then
                mIsThankYouLetter = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsFirstSurvey() As Boolean
        Get
            Return mIsFirstSurvey
        End Get
        Set(ByVal value As Boolean)
            If mIsFirstSurvey <> value Then
                mIsFirstSurvey = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property OverrideLanguageId() As Nullable(Of Integer)
        Get
            Return mOverrideLanguageId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mOverrideLanguageId = value
            PropertyChanged()
        End Set
    End Property

    <Logable()> _
    Public ReadOnly Property LinkedStepId() As Integer
        Get
            If mLinkedStep Is Nothing Then
                Return mId
            Else
                Return mLinkedStep.mId
            End If
        End Get
    End Property

    Public Property LinkedStep() As MethodologyStep
        Get
            Return mLinkedStep
        End Get
        Set(ByVal value As MethodologyStep)
            mLinkedStep = value
            PropertyChanged()
        End Set
    End Property

    <Logable()> _
    Public Property StepMethodId() As Integer
        Get
            Return mStepMethodId
        End Get
        Set(ByVal value As Integer)
            If mStepMethodId <> value Then
                mStepMethodId = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property ExpirationDays() As Integer
        Get
            Return mExpirationDays
        End Get
        Set(ByVal value As Integer)
            If mExpirationDays <> value Then
                mExpirationDays = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property QuotaID() As Nullable(Of Integer)
        Get
            Return mQuotaID
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mQuotaID = value
            PropertyChanged()
        End Set
    End Property

    Public Property QuotaIDAllReturns() As Boolean
        Get
            If mQuotaID.HasValue AndAlso mQuotaID.Value = 1 Then
                Return True
            Else
                Return False
            End If
        End Get
        Set(ByVal value As Boolean)
            If value Then
                QuotaID = 1
                QuotaStopCollectionAt = 0
            End If
        End Set
    End Property

    Public Property QuotaIDStopReturns() As Boolean
        Get
            If mQuotaID.HasValue AndAlso mQuotaID.Value = 2 Then
                Return True
            Else
                Return False
            End If
        End Get
        Set(ByVal value As Boolean)
            If value Then
                QuotaID = 2
            End If
        End Set
    End Property

    <Logable()> _
    Public Property QuotaStopCollectionAt() As Integer
        Get
            Return mQuotaStopCollectionAt
        End Get
        Set(ByVal value As Integer)
            If mQuotaStopCollectionAt <> value Then
                mQuotaStopCollectionAt = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property DaysInField() As Integer
        Get
            Return mDaysInField
        End Get
        Set(ByVal value As Integer)
            If mDaysInField <> value Then
                mDaysInField = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property NumberOfAttempts() As Integer
        Get
            Return mNumberOfAttempts
        End Get
        Set(ByVal value As Integer)
            If mNumberOfAttempts <> value Then
                mNumberOfAttempts = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsWeekDayDayCall() As Boolean
        Get
            Return mIsWeekDayDayCall
        End Get
        Set(ByVal value As Boolean)
            If mIsWeekDayDayCall <> value Then
                mIsWeekDayDayCall = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsWeekDayEveCall() As Boolean
        Get
            Return mIsWeekDayEveCall
        End Get
        Set(ByVal value As Boolean)
            If mIsWeekDayEveCall <> value Then
                mIsWeekDayEveCall = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsSaturdayDayCall() As Boolean
        Get
            Return mIsSaturdayDayCall
        End Get
        Set(ByVal value As Boolean)
            If mIsSaturdayDayCall <> value Then
                mIsSaturdayDayCall = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsSaturdayEveCall() As Boolean
        Get
            Return mIsSaturdayEveCall
        End Get
        Set(ByVal value As Boolean)
            If mIsSaturdayEveCall <> value Then
                mIsSaturdayEveCall = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsSundayDayCall() As Boolean
        Get
            Return mIsSundayDayCall
        End Get
        Set(ByVal value As Boolean)
            If mIsSundayDayCall <> value Then
                mIsSundayDayCall = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsSundayEveCall() As Boolean
        Get
            Return mIsSundayEveCall
        End Get
        Set(ByVal value As Boolean)
            If mIsSundayEveCall <> value Then
                mIsSundayEveCall = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsCallBackOtherLang() As Boolean
        Get
            Return mIsCallBackOtherLang
        End Get
        Set(ByVal value As Boolean)
            If mIsCallBackOtherLang <> value Then
                mIsCallBackOtherLang = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsCallBackUsingTTY() As Boolean
        Get
            Return mIsCallBackUsingTTY
        End Get
        Set(ByVal value As Boolean)
            If mIsCallBackUsingTTY <> value Then
                mIsCallBackUsingTTY = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsAcceptPartial() As Boolean
        Get
            Return mIsAcceptPartial
        End Get
        Set(ByVal value As Boolean)
            If mIsAcceptPartial <> value Then
                mIsAcceptPartial = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsEmailBlast() As Boolean
        Get
            Return mIsEmailBlast
        End Get
        Set(ByVal value As Boolean)
            If mIsEmailBlast <> value Then
                mIsEmailBlast = value
                PropertyChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property VendorID() As Nullable(Of Integer)
        Get
            Return mVendorID
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mVendorID = value
            PropertyChanged()
        End Set
    End Property

    ''' <summary>
    ''' Stores the original database value of the VendorID
    ''' </summary>
    Public Property OrgVendorID() As Nullable(Of Integer)
        Get
            Return mOrgVendorId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mOrgVendorId = value
        End Set
    End Property

    <Logable()> _
    Public Property VendorSurveyID() As Integer
        Get
            If mVendorVoviciDetail Is Nothing Then
                Return -1
            Else
                Return mVendorVoviciDetail.VoviciSurveyId
            End If
        End Get
        Set(ByVal value As Integer)
            If value = -1 Then  '-1 = clear value
                If mVendorVoviciDetail IsNot Nothing Then
                    mVendorVoviciDetail.MarkDelete()
                End If
            ElseIf mVendorVoviciDetail Is Nothing Then
                mVendorVoviciDetail = VendorFile_VoviciDetail.NewVendorFile_VoviciDetail
            Else
                If mVendorVoviciDetail.IsDeleted Then
                    mVendorVoviciDetail.MarkUnDelete()
                End If
            End If
            mVendorVoviciDetail.VoviciSurveyId = value
            PropertyChanged()
        End Set
    End Property

    Public Property VendorVoviciDetail() As VendorFile_VoviciDetail
        Get
            Return mVendorVoviciDetail
        End Get
        Set(ByVal value As VendorFile_VoviciDetail)
            mVendorVoviciDetail = value
            PropertyChanged()
        End Set
    End Property

    <Logable()> _
    Public ReadOnly Property ExpireFromStepId() As Integer
        Get
            If mExpireFromStep Is Nothing Then
                Return mId
            Else
                Return mExpireFromStep.mId
            End If
        End Get
    End Property

    Public Property ExpireFromStep() As MethodologyStep
        Get
            Return mExpireFromStep
        End Get
        Set(ByVal value As MethodologyStep)
            mExpireFromStep = value
            PropertyChanged()
        End Set
    End Property

    Public ReadOnly Property IncludeWithPrevStep() As String
        Get
            If LinkedStepId = mId Then
                Return "No"
            Else
                Return "Yes"
            End If
        End Get
    End Property

    Public ReadOnly Property ExpireFromStepName() As String
        Get
            If ExpireFromStepId = mId Then
                Return "This Step"
            Else
                Return mExpireFromStep.Name
            End If
        End Get
    End Property

    Public Overrides ReadOnly Property IsDirty() As Boolean
        Get
            If mVendorVoviciDetail IsNot Nothing Then
                Return (mIsDirty OrElse mEmailBlastList.IsDirty OrElse mVendorVoviciDetail.IsDirty)
            Else
                Return (mIsDirty OrElse mEmailBlastList.IsDirty)
            End If
        End Get
    End Property

    Public Property ParentCollection() As MethodologyStepCollection
        Get
            Return mParentCollection
        End Get
        Set(ByVal value As MethodologyStepCollection)
            mParentCollection = value
        End Set
    End Property

    Public Property EmailBlastList() As EmailBlastCollection
        Get
            Return mEmailBlastList
        End Get
        Set(ByVal value As EmailBlastCollection)
            mEmailBlastList = value
        End Set
    End Property

#End Region

#Region " Constructors "

    ''' <summary>
    ''' The default constructor.
    ''' </summary>
    Friend Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Public Methods "

#Region " DB CRUD Methods "

    ''' <summary>
    ''' Returns a collection of MethodologySteps objects that belong to the specified Methodology
    ''' </summary>
    ''' <param name="methodologyId">The unique identifier of the Methodology</param>
    Public Shared Function GetByMethodologyId(ByVal methodologyId As Integer) As MethodologyStepCollection

        Return MethodologyProvider.Instance.SelectMethodologyStepsByMethodologyId(methodologyId)

    End Function

    Public Shared Function [Get](ByVal id As Integer) As MethodologyStep

        Return MethodologyProvider.Instance.SelectMethodologyStep(id)

    End Function

#End Region

    Public Sub ResetDirtyFlag()

        mIsDirty = False

    End Sub

    ''' <summary>
    ''' Copies properties from a MethodologyStepType object to the MethodologyStep
    ''' </summary>
    Public Sub CopyStepTypeProperties(ByVal stepType As MethodologyStepType)

        'Copy the template fields to the step
        mSurveyId = mSurveyId
        mIsSurvey = stepType.IsSurvey
        mIsThankYouLetter = stepType.IsThankYouLetter
        mName = stepType.Name
        mStepMethodId = stepType.StepMethodId
        mExpirationDays = stepType.ExpirationDays
        mQuotaID = stepType.QuotaID
        mQuotaStopCollectionAt = stepType.QuotaStopCollectionAt
        mDaysInField = stepType.DaysInField
        mNumberOfAttempts = stepType.NumberOfAttempts
        mIsWeekDayDayCall = stepType.IsWeekDayDayCall
        mIsWeekDayEveCall = stepType.IsWeekDayEveCall
        mIsSaturdayDayCall = stepType.IsSaturdayDayCall
        mIsSaturdayEveCall = stepType.IsSaturdayEveCall
        mIsSundayDayCall = stepType.IsSundayDayCall
        mIsSundayEveCall = stepType.IsSundayEveCall
        mIsCallBackOtherLang = stepType.IsCallBackOtherLang
        mIsCallBackUsingTTY = stepType.IsCallBackUsingTTY
        mIsAcceptPartial = stepType.IsAcceptPartial
        mIsEmailBlast = stepType.IsEmailBlast

    End Sub

    ''' <summary>
    ''' Returns True if the step can be moved up in sequence
    ''' </summary>
    Public Function CanDecreaseSequence() As Boolean

        If mParentCollection IsNot Nothing Then
            Return (SequenceNumber > 1)
        Else
            Return False
        End If

    End Function

    ''' <summary>
    ''' Returns True if the step can be moved down in sequence
    ''' </summary>
    Public Function CanIncreaseSequence() As Boolean

        If mParentCollection IsNot Nothing Then
            Return (SequenceNumber < mParentCollection.Count)
        Else
            Return False
        End If

    End Function

    ''' <summary>
    ''' Moves the step down one sequence number in the methodology
    ''' </summary>
    Public Sub IncreaseSequence()

        If Not CanIncreaseSequence() Then
            Throw New InvalidOperationException("Cannot increase the sequence of this methodology step.")
        End If

        Dim newIndex As Integer = SequenceNumber
        Dim tempCollection As MethodologyStepCollection = ParentCollection
        tempCollection.Remove(Me)
        tempCollection.Insert(newIndex, Me)
        mIsDirty = True

    End Sub

    ''' <summary>
    ''' Moves the step up one sequence in the methodology
    ''' </summary>
    Public Sub DecreaseSequence()

        If Not CanDecreaseSequence() Then
            Throw New InvalidOperationException("Cannot decrease the sequence of this methodology step.")
        End If

        Dim newIndex As Integer = SequenceNumber - 2
        Dim tempCollection As MethodologyStepCollection = ParentCollection
        tempCollection.Remove(Me)
        tempCollection.Insert(newIndex, Me)
        mIsDirty = True

    End Sub

    ''' <summary>
    ''' Vendor validation rule is added on demand as it's not set during
    ''' the initial step of the methodology, but it is required at a later point.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub AddVendorValidation()

        ValidationRules.AddRule(AddressOf ValidateVendorID, "VendorID")
        ValidationRules.AddRule(AddressOf ValidateVendorSurveyID, "VendorSurveyID")
        ValidationRules.CheckRules()

    End Sub

#End Region

#Region " Private Methods "

    Private Shadows Sub PropertyChanged()

        mIsDirty = True
        ValidationRules.CheckRules()

    End Sub

#End Region

#Region "Overrides"

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mId
        End If

    End Function

    Protected Overrides Sub CreateNew()

        ValidationRules.CheckRules()

    End Sub

    Protected Overrides Sub AddBusinessRules()

        ValidationRules.AddRule(AddressOf ValidateDaysInField, "DaysInField")
        ValidationRules.AddRule(AddressOf ValidateNumberOfAttempts, "NumberOfAttempts")
        ValidationRules.AddRule(AddressOf ValidateCallTimes, "IsSundayDayCall")
        ValidationRules.AddRule(AddressOf ValidateQuota, "QuotaIDAllReturns")
        ValidationRules.AddRule(AddressOf ValidateQuotaStopAt, "QuotaStopCollectionAt")

    End Sub

#End Region

#Region "Validation Methods"

    Private Function ValidateDaysInField(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        'Validate
        Select Case StepMethodId
            Case MailingStepMethodCodes.Phone, MailingStepMethodCodes.Web, MailingStepMethodCodes.MailWeb, MailingStepMethodCodes.LetterWeb, MailingStepMethodCodes.IVR
                If ExpireFromStepId = Id Then
                    If DaysInField < 1 OrElse DaysInField >= ExpirationDays Then
                        e.Description = "Days in Field must be greater then 0 and less then expire - 1!"
                        Return False
                    End If
                Else
                    If DaysInField < 1 OrElse DaysInField >= ExpirationDays - DaysSincePreviousStep Then
                        e.Description = "Days in Field must be greater then 0 and less then expire - days since previous step!"
                        Return False
                    End If
                End If

        End Select

        Return True

    End Function

    Private Function ValidateNumberOfAttempts(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        'Validate
        Select Case StepMethodId
            Case MailingStepMethodCodes.Phone
                If NumberOfAttempts < 1 Then
                    e.Description = "Number of Attempts must be greater then 0!"
                    Return False
                End If

        End Select

        Return True

    End Function

    Private Function ValidateCallTimes(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        'Validate
        Select Case StepMethodId
            Case MailingStepMethodCodes.Phone
                If IsWeekDayDayCall = False AndAlso IsWeekDayEveCall = False AndAlso IsSaturdayDayCall = False AndAlso IsSaturdayEveCall = False AndAlso _
                   IsSundayDayCall = False AndAlso IsSundayEveCall = False Then
                    e.Description = "At least 1 call time must be selected!"
                    Return False
                End If

        End Select

        Return True

    End Function

    Private Function ValidateQuota(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        'Validate
        Select Case StepMethodId
            Case MailingStepMethodCodes.Phone, MailingStepMethodCodes.Web, MailingStepMethodCodes.MailWeb, MailingStepMethodCodes.LetterWeb
                If QuotaID.HasValue = False Then
                    e.Description = "A quota must be selected!"
                    Return False
                End If

        End Select

        Return True

    End Function

    Private Function ValidateQuotaStopAt(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        'Validate
        Select Case StepMethodId
            Case MailingStepMethodCodes.Phone, MailingStepMethodCodes.Web, MailingStepMethodCodes.MailWeb, MailingStepMethodCodes.LetterWeb
                If QuotaID.HasValue Then
                    If QuotaID.Value = 2 AndAlso QuotaStopCollectionAt < 1 Then
                        e.Description = "Stop Collection At must be greater then 0!"
                        Return False
                    End If
                End If

        End Select

        Return True

    End Function

    Private Function ValidateVendorID(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        If Not VendorID.HasValue Then
            Select Case StepMethodId
                Case MailingStepMethodCodes.Phone, MailingStepMethodCodes.Web, MailingStepMethodCodes.MailWeb, MailingStepMethodCodes.LetterWeb, MailingStepMethodCodes.IVR
                    e.Description = "Must select a vendor."
                    Return False

            End Select
        End If

        Return True

    End Function

    Private Function ValidateVendorSurveyID(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        If VendorID.HasValue Then
            If ((VendorID.Value = AppConfig.Params("QSIVerint-US-VendorID").IntegerValue) Or _
                (VendorID.Value = AppConfig.Params("QSIVerint-CA-VendorID").IntegerValue)) AndAlso VendorSurveyID = -1 Then
                e.Description = "Must select a survey for this vendor."
                Return False
            End If
        End If

        Return True

    End Function

#End Region

End Class
