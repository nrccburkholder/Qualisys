Imports NRC.Framework.BusinessLogic

Public Interface IPopMapping

    Property PopMappingId() As Integer
    Property FieldName() As String

End Interface

<Serializable()> _
Public Class PopMapping
	Inherits BusinessBase(Of PopMapping)
	Implements IPopMapping

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mPopMappingId As Integer
    Private mLithoCodeId As Integer
    Private mErrorId As TransferErrorCodes = TransferErrorCodes.None
    Private mQstnCore As Integer
    Private mPopMappingText As String = String.Empty
    Private mFieldName As String

#End Region

#Region " Public Properties "

    Public Property PopMappingId() As Integer Implements IPopMapping.PopMappingId
        Get
            Return mPopMappingId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mPopMappingId Then
                mPopMappingId = value
                PropertyHasChanged("PopMappingId")
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

    Public Property PopMappingText() As String
        Get
            Return mPopMappingText
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPopMappingText Then
                mPopMappingText = value
                PropertyHasChanged("PopMappingText")
            End If
        End Set
    End Property

    Public Property FieldName() As String Implements IPopMapping.FieldName
        Get
            Return mFieldName
        End Get
        Private Set(ByVal value As String)
            mFieldName = value
        End Set
    End Property

#End Region

#Region " Readonly Properties "

    Public ReadOnly Property SetClause() As String
        Get
            If mPopMappingText.Length = 0 Then
                Return String.Format("{0} = NULL", mFieldName)
            Else
                Return String.Format("{0} = '{1}'", mFieldName, mPopMappingText)
            End If
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub
#End Region

#Region " Factory Methods "

    Public Shared Function NewPopMapping() As PopMapping

        Return New PopMapping

    End Function

    Public Shared Function [Get](ByVal id As Integer) As PopMapping

        Return PopMappingProvider.Instance.SelectPopMapping(id)

    End Function

    Public Shared Function GetByLithoCodeId(ByVal lithoCodeId As Integer) As PopMappingCollection

        Return PopMappingProvider.Instance.SelectPopMappingsByLithoCodeId(lithoCodeId)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mPopMappingId
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

        PopMappingId = PopMappingProvider.Instance.InsertPopMapping(Me)

    End Sub

    Protected Overrides Sub Update()

        PopMappingProvider.Instance.UpdatePopMapping(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        PopMappingProvider.Instance.DeletePopMapping(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


