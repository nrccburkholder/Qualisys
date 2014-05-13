Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

Public Interface IResourceType
    Property Id() As Integer
End Interface

<Serializable()> _
Public Class ResourceType
    Inherits BusinessBase(Of ResourceType)
    Implements IResourceType

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mDescription As String = String.Empty
    Private mAlwaysShow As Boolean
#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IResourceType.Id
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
    Public Property AlwaysShow() As Boolean
        Get
            Return mAlwaysShow
        End Get
        Set(ByVal value As Boolean)
            If Not value = mAlwaysShow Then
                mAlwaysShow = value
                PropertyHasChanged("AlwaysShow")
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

    Public Shared Function NewResourceType(ByVal description As String) As ResourceType
        Dim mr As New ResourceType
        mr.Description = description
        Return mr
    End Function

    Public Shared Function NewResourceType() As ResourceType
        Return New ResourceType
    End Function

    Public Shared Function GetByKey(ByVal id As Integer) As ResourceType
        Return DataProvider.Instance.SelectResourceType(id)
    End Function

    Public Shared Function GetByDescription(ByVal description As String) As ResourceType
        Return DataProvider.Instance.SelectResourceTypeByDescription(description)
    End Function

    Public Shared Function GetAll() As ResourceTypeCollection
        Return DataProvider.Instance.SelectAllResourceType()
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
        Me.Id = DataProvider.Instance.InsertResourceType(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateResourceType(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteResourceType(mId)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class ResourceTypeCollection
    Inherits BusinessListBase(Of ResourceTypeCollection, ResourceType)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ResourceType = ResourceType.NewResourceType
        Me.Add(newObj)
        Return newObj
    End Function

End Class

