Imports NRC.Framework.BusinessLogic

Public Interface IQSIDataResult

    Property ResultId() As Integer

End Interface

<Serializable()> _
Public Class QSIDataResult
	Inherits BusinessBase(Of QSIDataResult)
	Implements IQSIDataResult

#Region " Private Members "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mResultId As Integer
    Private mFormId As Integer
    Private mQstnCore As Integer
    Private mResponseValue As Integer

#End Region

#Region " Public Properties "

    Public Property ResultId() As Integer Implements IQSIDataResult.ResultId
        Get
            Return mResultId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mResultId Then
                mResultId = value
                PropertyHasChanged("ResultId")
            End If
        End Set
    End Property

    Public Property FormId() As Integer
        Get
            Return mFormId
        End Get
        Set(ByVal value As Integer)
            If Not value = mFormId Then
                mFormId = value
                PropertyHasChanged("FormId")
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

    Public Property ResponseValue() As Integer
        Get
            Return mResponseValue
        End Get
        Set(ByVal value As Integer)
            If Not value = mResponseValue Then
                mResponseValue = value
                PropertyHasChanged("ResponseValue")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewQSIDataResult() As QSIDataResult

        Return New QSIDataResult

    End Function

    Public Shared Function [Get](ByVal resultId As Integer) As QSIDataResult

        Return QSIDataResultProvider.Instance.SelectQSIDataResult(resultId)

    End Function

    Public Shared Function GetByFormId(ByVal formId As Integer) As QSIDataResultCollection

        Return QSIDataResultProvider.Instance.SelectQSIDataResultsByFormId(formId)

    End Function

    Public Shared Sub DeleteByFormId(ByVal formId As Integer)

        QSIDataResultProvider.Instance.DeleteQSIDataResultsByFormId(formId)

    End Sub

    Public Shared Sub DeleteByQstnCore(ByVal formId As Integer, ByVal qstnCore As Integer)

        QSIDataResultProvider.Instance.DeleteQSIDataResultsByQstnCore(formId, qstnCore)

    End Sub

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mResultId
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

        ResultId = QSIDataResultProvider.Instance.InsertQSIDataResult(Me)

    End Sub

    Protected Overrides Sub Update()

        QSIDataResultProvider.Instance.UpdateQSIDataResult(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        QSIDataResultProvider.Instance.DeleteQSIDataResult(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


