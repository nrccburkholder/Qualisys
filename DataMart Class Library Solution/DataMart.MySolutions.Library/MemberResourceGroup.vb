Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

Public Interface IMemberResourceGroup
    Property Id() As Integer
End Interface

''' <summary>
''' Class representing an organization unit group.
''' </summary>
''' <remarks>
'''   <para>
'''   Rick Christenham (09/07/2007): NRC eToolkit Enhancement II:
'''                                  Adapted from MemberResourceQuestion.vb.
'''   </para>
''' </remarks>
<Serializable()> _
Public Class MemberResourceGroup
    Inherits BusinessBase(Of MemberResourceGroup)
    Implements IMemberResourceGroup

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private _id As Integer
    Private _documentId As Integer
    Private _groupId As Integer
#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IMemberResourceGroup.Id
        Get
            Return _id
        End Get
        Private Set(ByVal value As Integer)
            If Not value = _id Then
                _id = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property
    Public Property DocumentId() As Integer
        Get
            Return _documentId
        End Get
        Set(ByVal value As Integer)
            If Not value = _documentId Then
                _documentId = value
                PropertyHasChanged("DocumentId")
            End If
        End Set
    End Property
    Public Property GroupId() As Integer
        Get
            Return _groupId
        End Get
        Set(ByVal value As Integer)
            If Not value = _groupId Then
                _groupId = value
                PropertyHasChanged("GroupId")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.MarkAsChild()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "

    Public Shared Function NewMemberResourceGroup(ByVal groupId As Integer) As MemberResourceGroup
        Dim mr As New MemberResourceGroup
        mr.GroupId = groupId
        Return mr
    End Function

    Public Shared Function NewMemberResourceGroup() As MemberResourceGroup
        Return New MemberResourceGroup
    End Function

#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return _Id
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
        Me.Id = DataProvider.Instance.InsertMemberResourceGroup(Me)
    End Sub

    Friend Overloads Sub Insert(ByVal resource As MemberResource)
        If Not Me.IsDirty Then Exit Sub
        Me.DocumentId = resource.Id
        Insert()
        Me.MarkOld()
    End Sub

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateMemberResourceGroup(Me)
    End Sub

    Friend Overloads Sub Update(ByVal resource As MemberResource)
        If Not Me.IsDirty Then Exit Sub
        Me.DocumentId = resource.Id
        Update()
        Me.MarkClean()
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteMemberResourceGroup(_Id)
    End Sub

    Friend Sub DeleteSelf()
        DataProvider.Instance.DeleteMemberResourceGroup(_Id)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class MemberResourceGroupCollection
    Inherits BusinessListBase(Of MemberResourceGroupCollection, MemberResourceGroup)

    Public Sub New()
        Me.MarkAsChild()
    End Sub

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As MemberResourceGroup = MemberResourceGroup.NewMemberResourceGroup
        Me.Add(newObj)
        Return newObj
    End Function

    Friend Sub Delete(ByVal resource As MemberResource)
        Me.RaiseListChangedEvents = False
        Try
            For Each obj As MemberResourceGroup In Me
                obj.DeleteSelf()
            Next
            Me.Clear()
        Finally
            Me.RaiseListChangedEvents = True
        End Try
    End Sub

    Friend Sub Update(ByVal resource As MemberResource)
        Me.RaiseListChangedEvents = False
        Try
            For Each obj As MemberResourceGroup In DeletedList
                obj.DeleteSelf()
            Next
            DeletedList.Clear()
            For Each obj As MemberResourceGroup In Me
                If obj.IsNew Then
                    obj.Insert(resource)
                Else
                    obj.Update(resource)
                End If
            Next
        Finally
            Me.RaiseListChangedEvents = True
        End Try
    End Sub

    Public Function Find(ByVal groupId As Integer) As MemberResourceGroup
        For Each group As MemberResourceGroup In Me
            If group.GroupId = groupId Then
                Return group
            End If
        Next
        Return Nothing
    End Function

End Class


