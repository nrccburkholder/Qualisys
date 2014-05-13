Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

Public Interface INotifyMethod
    Property Id() As Byte
End Interface

<Serializable()> _
Public Class NotifyMethod
    Inherits BusinessBase(Of NotifyMethod)
    Implements INotifyMethod

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Byte
    Private mLabel As String = String.Empty
#End Region

#Region " Public Properties "

    Public Property Id() As Byte Implements INotifyMethod.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Byte)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property
    Public Property Label() As String
        Get
            Return mLabel
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLabel Then
                mLabel = value
                PropertyHasChanged("Label")
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

    Public Shared Function NewNotifyMethod(ByVal label As String) As NotifyMethod
        Dim mr As New NotifyMethod
        mr.Label = label
        Return mr
    End Function

    Public Shared Function NewNotifyMethod() As NotifyMethod
        Return New NotifyMethod
    End Function

    Public Shared Function GetByKey(ByVal id As Integer) As NotifyMethod
        Return DataProvider.Instance.SelectNotifyMethod(id)
    End Function

    Public Shared Function GetAll() As NotifyMethodCollection
        Return DataProvider.Instance.SelectAllNotifyMethod()
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

<Serializable()> _
Public Class NotifyMethodCollection
    Inherits BusinessListBase(Of NotifyMethodCollection, NotifyMethod)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As NotifyMethod = NotifyMethod.NewNotifyMethod
        Me.Add(newObj)
        Return newObj
    End Function

End Class

