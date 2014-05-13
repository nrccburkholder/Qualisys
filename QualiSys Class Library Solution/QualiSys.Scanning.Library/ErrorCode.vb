Imports NRC.Framework.BusinessLogic

Public Interface IErrorCode

    Property ErrorId() As TransferErrorCodes

End Interface

<Serializable()> _
Public Class ErrorCode
	Inherits BusinessBase(Of ErrorCode)
	Implements IErrorCode

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mErrorId As TransferErrorCodes
    Private mErrorDesc As String = String.Empty
    Private mDateCreated As Date

#End Region

#Region " Public Properties "

    Public Property ErrorId() As TransferErrorCodes Implements IErrorCode.ErrorId
        Get
            Return mErrorId
        End Get
        Private Set(ByVal value As TransferErrorCodes)
            If Not value = mErrorId Then
                mErrorId = value
                PropertyHasChanged("ErrorId")
            End If
        End Set
    End Property

    Public Property ErrorDesc() As String
        Get
            Return mErrorDesc
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mErrorDesc Then
                mErrorDesc = value
                PropertyHasChanged("ErrorDesc")
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

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewErrorCode() As ErrorCode

        Return New ErrorCode

    End Function

    Public Shared Function [Get](ByVal errorId As Integer) As ErrorCode

        Return ErrorCodeProvider.Instance.SelectErrorCode(errorId)

    End Function

    Public Shared Function GetAll() As ErrorCodeCollection

        Return ErrorCodeProvider.Instance.SelectAllErrorCodes()

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mErrorId
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

#End Region

#Region " Public Methods "

#End Region

End Class


