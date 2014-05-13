Imports NRC.Framework.BusinessLogic

Public Interface IEmailBlastOption
    Property EmailBlastId() As Integer
End Interface

<Serializable()> _
Public Class EmailBlastOption
    Inherits BusinessBase(Of EmailBlastOption)
    Implements IEmailBlastOption

#Region " Private Fields "
    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mEmailBlastId As Integer
    Private mValue As String = String.Empty
#End Region

#Region " Public Properties "
    Public Property EmailBlastId() As Integer Implements IEmailBlastOption.EmailBlastId
        Get
            Return mEmailBlastId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mEmailBlastId Then
                mEmailBlastId = value
                PropertyHasChanged("EmailBlastId")
            End If
        End Set
    End Property
    Public Property Value() As String
        Get
            Return mValue
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mValue Then
                mValue = value
                PropertyHasChanged("Value")
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
    Public Shared Function NewEmailBlastOption() As EmailBlastOption
        Return New EmailBlastOption
    End Function

    Public Shared Function [Get](ByVal emailBlastId As Integer) As EmailBlastOption
        Return EmailBlastOptionProvider.Instance.SelectEmailBlastOption(emailBlastId)
    End Function

    Public Shared Function GetAll() As EmailBlastOptionCollection
        Return EmailBlastOptionProvider.Instance.SelectAllEmailBlastOptions()
    End Function
#End Region
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mEmailBlastId
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
        EmailBlastId = EmailBlastOptionProvider.Instance.InsertEmailBlastOption(Me)
    End Sub

    Protected Overrides Sub Update()
        EmailBlastOptionProvider.Instance.UpdateEmailBlastOption(Me)
    End Sub
    Protected Overrides Sub DeleteImmediate()
        EmailBlastOptionProvider.Instance.DeleteEmailBlastOption(Me)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


