Imports Nrc.QualiSys.Library.DataProvider

''' <summary>
''' Represents one of the standard Types of MethodologySteps.
''' </summary>
''' <remarks>The MethodologyStepType defines important attributes about the MethodologyStep.
''' This class is used like a template to copy from when creating MethodologyStep objects</remarks>
<DebuggerDisplay("{Name} ({Id})")> _
Public Class MethodologyStepType

#Region " Private Fields "

    Private mId As Integer
    Private mName As String
    Private mIsSurvey As Boolean
    Private mIsThankYouLetter As Boolean
    Private mStepMethodId As Integer
    Private mIsCoverLetterRequired As Boolean
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

#End Region

#Region " Public Properties "

    ''' <summary>The unique identifier of the MethodologyStepType</summary>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    ''' <summary>The name of the MethodologyStepType</summary>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Friend Set(ByVal value As String)
            mName = value
        End Set
    End Property

    ''' <summary>Returns True if the step is a survey</summary>
    Public Property IsSurvey() As Boolean
        Get
            Return mIsSurvey
        End Get
        Friend Set(ByVal value As Boolean)
            mIsSurvey = value
        End Set
    End Property

    ''' <summary>Returns True if the step is a Thank You Letter</summary>
    Public Property IsThankYouLetter() As Boolean
        Get
            Return mIsThankYouLetter
        End Get
        Friend Set(ByVal value As Boolean)
            mIsThankYouLetter = value
        End Set
    End Property

    ''' <summary>Returns the Step Method ID</summary>
    Public Property StepMethodId() As Integer
        Get
            Return mStepMethodId
        End Get
        Friend Set(ByVal value As Integer)
            mStepMethodId = value
        End Set
    End Property

    ''' <summary>Returns True if a cover letter must be specified for this step</summary>
    Public Property IsCoverLetterRequired() As Boolean
        Get
            Return mIsCoverLetterRequired
        End Get
        Set(ByVal value As Boolean)
            mIsCoverLetterRequired = value
        End Set
    End Property

    Public Property ExpirationDays() As Integer
        Get
            Return mExpirationDays
        End Get
        Set(ByVal value As Integer)
            mExpirationDays = value
        End Set
    End Property

    Public Property QuotaID() As Nullable(Of Integer)
        Get
            Return mQuotaID
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mQuotaID = value
        End Set
    End Property

    Public Property QuotaStopCollectionAt() As Integer
        Get
            Return mQuotaStopCollectionAt
        End Get
        Set(ByVal value As Integer)
            mQuotaStopCollectionAt = value
        End Set
    End Property

    Public Property DaysInField() As Integer
        Get
            Return mDaysInField
        End Get
        Set(ByVal value As Integer)
            mDaysInField = value
        End Set
    End Property

    Public Property NumberOfAttempts() As Integer
        Get
            Return mNumberOfAttempts
        End Get
        Set(ByVal value As Integer)
            mNumberOfAttempts = value
        End Set
    End Property

    Public Property IsWeekDayDayCall() As Boolean
        Get
            Return mIsWeekDayDayCall
        End Get
        Set(ByVal value As Boolean)
            mIsWeekDayDayCall = value
        End Set
    End Property

    Public Property IsWeekDayEveCall() As Boolean
        Get
            Return mIsWeekDayEveCall
        End Get
        Set(ByVal value As Boolean)
            mIsWeekDayEveCall = value
        End Set
    End Property

    Public Property IsSaturdayDayCall() As Boolean
        Get
            Return mIsSaturdayDayCall
        End Get
        Set(ByVal value As Boolean)
            mIsSaturdayDayCall = value
        End Set
    End Property

    Public Property IsSaturdayEveCall() As Boolean
        Get
            Return mIsSaturdayEveCall
        End Get
        Set(ByVal value As Boolean)
            mIsSaturdayEveCall = value
        End Set
    End Property

    Public Property IsSundayDayCall() As Boolean
        Get
            Return mIsSundayDayCall
        End Get
        Set(ByVal value As Boolean)
            mIsSundayDayCall = value
        End Set
    End Property

    Public Property IsSundayEveCall() As Boolean
        Get
            Return mIsSundayEveCall
        End Get
        Set(ByVal value As Boolean)
            mIsSundayEveCall = value
        End Set
    End Property

    Public Property IsCallBackOtherLang() As Boolean
        Get
            Return mIsCallBackOtherLang
        End Get
        Set(ByVal value As Boolean)
            mIsCallBackOtherLang = value
        End Set
    End Property

    Public Property IsCallBackUsingTTY() As Boolean
        Get
            Return mIsCallBackUsingTTY
        End Get
        Set(ByVal value As Boolean)
            mIsCallBackUsingTTY = value
        End Set
    End Property

    Public Property IsAcceptPartial() As Boolean
        Get
            Return mIsAcceptPartial
        End Get
        Set(ByVal value As Boolean)
            mIsAcceptPartial = value
        End Set
    End Property

    Public Property IsEmailBlast() As Boolean
        Get
            Return mIsEmailBlast
        End Get
        Set(ByVal value As Boolean)
            mIsEmailBlast = value
        End Set
    End Property

#End Region

#Region " Constructors "

    Friend Sub New()

    End Sub

#End Region

#Region " Public Methods "

    Public Shared Function GetAll() As Collection(Of MethodologyStepType)

        Return MethodologyProvider.Instance.SelectAllMethodologyStepTypes()

    End Function

#End Region

End Class
