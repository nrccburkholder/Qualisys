Imports Nrc.Qualisys.Library

Public MustInherit Class SurveyPropertiesModule
    Inherits ConfigurationModule

#Region " Private Members "

    Private mEndConfigCallBack As EndConfigCallBackMethod
    Private mStudy As Library.Study
    Private mSurvey As Library.Survey
    Private mEditingSurvey As Survey
    Private mIsNew As Boolean
    Private mIsEditable As Boolean = True
    Private mInformation As String

#End Region

#Region " Protected Properties "

    Protected Property EndConfigCallBack() As EndConfigCallBackMethod
        Get
            Return mEndConfigCallBack
        End Get
        Set(ByVal value As EndConfigCallBackMethod)
            mEndConfigCallBack = value
        End Set
    End Property

    Protected Property Survey() As Library.Survey
        Get
            Return mSurvey
        End Get
        Set(ByVal value As Library.Survey)
            mSurvey = value
        End Set
    End Property

#End Region

#Region " Public Properties "

    Public Property Study() As Library.Study
        Get
            Return mStudy
        End Get
        Protected Set(ByVal value As Library.Study)
            mStudy = value
        End Set
    End Property

    Public Property EditingSurvey() As Library.Survey
        Get
            Return mEditingSurvey
        End Get
        Protected Set(ByVal value As Library.Survey)
            mEditingSurvey = value
        End Set
    End Property

    Public Property IsNew() As Boolean
        Get
            Return mIsNew
        End Get
        Protected Set(ByVal value As Boolean)
            mIsNew = value
        End Set
    End Property

    Public Property IsEditable() As Boolean
        Get
            Return mIsEditable
        End Get
        Protected Set(ByVal value As Boolean)
            mIsEditable = value
        End Set
    End Property

    Public Property Information() As String
        Get
            Return mInformation
        End Get
        Protected Set(ByVal value As String)
            mInformation = value
        End Set
    End Property

#End Region

#Region " Constructors "

    Protected Sub New(ByVal configPanel As Panel)

        MyBase.New(configPanel)

    End Sub

#End Region

#Region " Protected Methods "

    Protected Overridable Sub Reset()

        mEndConfigCallBack = Nothing
        mStudy = Nothing
        mSurvey = Nothing
        mEditingSurvey = Nothing
        mIsNew = False
        mIsEditable = True
        mInformation = Nothing

    End Sub

#End Region

End Class
