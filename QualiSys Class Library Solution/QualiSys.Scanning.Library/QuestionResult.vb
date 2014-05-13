Imports NRC.Framework.BusinessLogic

Public Interface IQuestionResult

    Property QuestionResultId() As Integer
    Property SampleUnitID() As Integer

End Interface

<Serializable()> _
Public Class QuestionResult
	Inherits BusinessBase(Of QuestionResult)
	Implements IQuestionResult

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mQuestionResultId As Integer
    Private mLithoCodeId As Integer
    Private mErrorId As TransferErrorCodes
    Private mQstnCore As Integer
    Private mResponseVal As String
    Private mMultipleResponse As Boolean
    Private mDateCreated As Date
    Private mSampleUnitID As Integer

#End Region

#Region " Public Properties "

    Public Property QuestionResultId() As Integer Implements IQuestionResult.QuestionResultId
        Get
            Return mQuestionResultId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mQuestionResultId Then
                mQuestionResultId = value
                PropertyHasChanged("QuestionResultId")
            End If
        End Set
    End Property

    Public Property LithoCodeId() As Integer
        Get
            Return mLithoCodeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mLithoCodeId Then
                mLithoCodeId = value
                PropertyHasChanged("LithoCodeId")
            End If
        End Set
    End Property

    Public Property ErrorId() As TransferErrorCodes
        Get
            Return mErrorId
        End Get
        Set(ByVal value As TransferErrorCodes)
            If Not value = mErrorId Then
                mErrorId = value
                PropertyHasChanged("ErrorId")
            End If
        End Set
    End Property

    Public Property QstnCore() As Integer
        Get
            Return mQstnCore
        End Get
        Set(ByVal value As Integer)
            If Not value = mQstnCore Then
                mQstnCore = value
                PropertyHasChanged("QstnCore")
            End If
        End Set
    End Property

    Public Property ResponseVal() As String
        Get
            Return mResponseVal
        End Get
        Set(ByVal value As String)
            If Not value = mResponseVal Then
                mResponseVal = value
                PropertyHasChanged("ResponseVal")
            End If
        End Set
    End Property

    Public Property MultipleResponse() As Boolean
        Get
            Return mMultipleResponse
        End Get
        Set(ByVal value As Boolean)
            If Not value = mMultipleResponse Then
                mMultipleResponse = value
                PropertyHasChanged("MultipleResponse")
            End If
        End Set
    End Property

    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mDateCreated Then
                mDateCreated = value
                PropertyHasChanged("DateCreated")
            End If
        End Set
    End Property

    Public Property SampleUnitID() As Integer Implements IQuestionResult.SampleUnitID
        Get
            Return mSampleUnitID
        End Get
        Private Set(ByVal value As Integer)
            mSampleUnitID = value
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewQuestionResult() As QuestionResult

        Return New QuestionResult

    End Function

    Public Shared Function [Get](ByVal questionResultId As Integer) As QuestionResult

        Return QuestionResultProvider.Instance.SelectQuestionResult(questionResultId)

    End Function

    Public Shared Function GetByLithoCodeId(ByVal lithoCodeId As Integer) As QuestionResultCollection

        Return QuestionResultProvider.Instance.SelectQuestionResultsByLithoCodeId(lithoCodeId)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mQuestionResultId
        End If

    End Function

#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...

    End Sub

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

    Protected Overrides Sub Insert()

        QuestionResultId = QuestionResultProvider.Instance.InsertQuestionResult(Me)

    End Sub

    Protected Overrides Sub Update()

        QuestionResultProvider.Instance.UpdateQuestionResult(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        QuestionResultProvider.Instance.DeleteQuestionResult(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

#Region " Friend Methods "

    Friend Function IsValidQualiSysResult(ByVal noResponseChar As String, ByVal dontKnowResponseChar As String, ByVal refusedResponseChar As String) As Boolean

        Dim tryInt As Integer

        If Not String.IsNullOrEmpty(ResponseVal) _
            AndAlso Not (ResponseVal = "-9" OrElse ResponseVal = "-6" OrElse ResponseVal = "-5") _
            AndAlso (ResponseVal.ToUpper = noResponseChar OrElse ResponseVal.ToUpper = dontKnowResponseChar OrElse ResponseVal.ToUpper = refusedResponseChar _
                     OrElse Integer.TryParse(ResponseVal, tryInt)) _
            AndAlso ErrorId = TransferErrorCodes.None Then
            Return True
        Else
            Return False
        End If

    End Function

    Friend Function GetQualiSysResponseValue(ByVal noResponseChar As String, ByVal skipResponseChar As String, ByVal dontKnowResponseChar As String, ByVal refusedResponseChar As String) As String

        If String.IsNullOrEmpty(ResponseVal) Then
            'Return an empty string to avoid null problems
            Return String.Empty
        ElseIf ResponseVal.ToUpper = noResponseChar OrElse ResponseVal.ToUpper = skipResponseChar Then
            'These need to be changed to -9
            Return "-9"
        ElseIf ResponseVal.ToUpper = dontKnowResponseChar Then
            'These need to be changed to -6
            Return "-6"
        ElseIf ResponseVal.ToUpper = refusedResponseChar Then
            'These need to be changed to -5
            Return "-5"
        Else
            Return ResponseVal
        End If

    End Function

#End Region

End Class


