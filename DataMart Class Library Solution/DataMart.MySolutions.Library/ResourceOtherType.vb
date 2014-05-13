Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

Public Interface IResourceOtherType
    Property Id() As Integer
End Interface

<Serializable()> _
Public Class ResourceOtherType
    Inherits BusinessBase(Of ResourceOtherType)
    Implements IResourceOtherType

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mDescription As String = String.Empty
#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IResourceOtherType.Id
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

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "

    Public Shared Function NewResourceOtherType(ByVal description As String) As ResourceOtherType
        Dim mr As New ResourceOtherType
        mr.Description = description
        Return mr
    End Function

    Public Shared Function NewResourceOtherType() As ResourceOtherType
        Return New ResourceOtherType
    End Function

    Public Shared Function GetByKey(ByVal id As Integer) As ResourceOtherType
        Return DataProvider.Instance.SelectResourceOtherType(id)
    End Function

    Public Shared Function GetByDescription(ByVal description As String) As ResourceOtherType
        Return DataProvider.Instance.SelectResourceOtherTypeByDescription(description)
    End Function

    Public Shared Function GetAll() As ResourceOtherTypeCollection
        Return DataProvider.Instance.SelectAllResourceOtherType()
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

    Protected Overrides Sub Insert()
        Me.Id = DataProvider.Instance.InsertResourceOtherType(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateResourceOtherType(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteResourceOtherType(mId)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class ResourceOtherTypeCollection
    Inherits BusinessListBase(Of ResourceOtherTypeCollection, ResourceOtherType)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ResourceOtherType = ResourceOtherType.NewResourceOtherType
        Me.Add(newObj)
        Return newObj
    End Function

End Class

