Imports NRC.Framework.BusinessLogic

Public Interface IReceiptType

    Property Id() As Integer

End Interface

<Serializable()> _
Public Class ReceiptType
    Inherits BusinessBase(Of ReceiptType)
    Implements IReceiptType

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mName As String = String.Empty
    Private mDescription As String = String.Empty
    Private mUIDisplay As Boolean
    Private mTranslationCode As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IReceiptType.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mName Then
                mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property

    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDescription Then
                mDescription = value
                PropertyHasChanged("Description")
            End If
        End Set
    End Property

    Public Property UIDisplay() As Boolean
        Get
            Return mUIDisplay
        End Get
        Set(ByVal value As Boolean)
            If Not value = mUIDisplay Then
                mUIDisplay = value
                PropertyHasChanged("UIDisplay")
            End If
        End Set
    End Property

    Public Property TranslationCode() As String
        Get
            Return mTranslationCode
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTranslationCode Then
                mTranslationCode = value
                PropertyHasChanged("TranslationCode")
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

    Public Shared Function NewReceiptType() As ReceiptType

        Return New ReceiptType

    End Function

    Public Shared Function GetAll() As ReceiptTypeCollection

        Return ReceiptTypeProvider.Instance.SelectAllReceiptTypes()

    End Function
#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mId
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
