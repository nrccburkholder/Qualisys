Public Class QSIDataFormQuestion

#Region " Private Members "

    Private mQstnCore As Integer
    Private mQuestionText As String = String.Empty
    Private mSampleUnitId As Integer
    Private mPageNumber As Integer
    Private mBeginColumn As Integer
    Private mResponseWidth As Integer
    Private mReadMethodId As Integer

    Private mScaleItems As New Collection(Of QSIDataFormQuestionItem)

#End Region

#Region " Public Properties "

    Public Property QstnCore() As Integer
        Get
            Return mQstnCore
        End Get
        Set(ByVal value As Integer)
            mQstnCore = value
        End Set
    End Property

    Public Property QuestionText() As String
        Get
            Return mQuestionText
        End Get
        Set(ByVal value As String)
            mQuestionText = value.Trim
        End Set
    End Property

    Public Property SampleUnitId() As Integer
        Get
            Return mSampleUnitId
        End Get
        Set(ByVal value As Integer)
            mSampleUnitId = value
        End Set
    End Property

    Public Property PageNumber() As Integer
        Get
            Return mPageNumber
        End Get
        Set(ByVal value As Integer)
            mPageNumber = value
        End Set
    End Property

    Public Property BeginColumn() As Integer
        Get
            Return mBeginColumn
        End Get
        Set(ByVal value As Integer)
            mBeginColumn = value
        End Set
    End Property

    Public Property ResponseWidth() As Integer
        Get
            Return mResponseWidth
        End Get
        Set(ByVal value As Integer)
            mResponseWidth = value
        End Set
    End Property

    Public Property ReadMethodId() As Integer
        Get
            Return mReadMethodId
        End Get
        Set(ByVal value As Integer)
            mReadMethodId = value
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property ScaleItems() As Collection(Of QSIDataFormQuestionItem)
        Get
            Return mScaleItems
        End Get
    End Property

#End Region

#Region " Constructors "

#End Region

#Region " Public Methods "

#End Region

End Class


