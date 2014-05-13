Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

Public Interface IMemberResourceOtherType
    Property DocumentId() As Integer
    Property OtherTypeId() As Integer
End Interface

<Serializable()> _
Public Class MemberResourceOtherType
    Inherits BusinessBase(Of MemberResourceOtherType)
    Implements IMemberResourceOtherType

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mDocumentId As Integer
    Private mOtherTypeId As Integer
    Private mDescription As String = String.Empty
#End Region

#Region " Public Properties "

    Public Property DocumentId() As Integer Implements IMemberResourceOtherType.DocumentId
        Get
            Return mDocumentId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mDocumentId Then
                mDocumentId = value
                PropertyHasChanged("DocumentId")
            End If
        End Set
    End Property
    Public Property OtherTypeId() As Integer Implements IMemberResourceOtherType.OtherTypeId
        Get
            Return mOtherTypeId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mOtherTypeId Then
                mOtherTypeId = value
                PropertyHasChanged("OtherTypeId")
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
        Me.MarkAsChild()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "

    Public Shared Function NewMemberResourceOtherType(ByVal otherTypeId As Integer) As MemberResourceOtherType
        Dim mr As New MemberResourceOtherType
        mr.OtherTypeId = otherTypeId
        Return mr
    End Function

    Public Shared Function NewMemberResourceOtherType() As MemberResourceOtherType
        Return New MemberResourceOtherType
    End Function

#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        Return mInstanceGuid
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
        DataProvider.Instance.InsertMemberResourceOtherType(Me)
    End Sub

    Friend Overloads Sub Insert(ByVal resource As MemberResource)
        If Not Me.IsDirty Then Exit Sub
        Me.DocumentId = resource.Id
        Insert()
        Me.MarkOld()
    End Sub

    Friend Overloads Sub Update(ByVal resource As MemberResource)
        If Not Me.IsDirty Then Exit Sub
        Me.DocumentId = resource.Id
        Update()
        Me.MarkClean()
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteMemberResourceOtherType(mDocumentId, mOtherTypeId)
    End Sub

    Friend Sub DeleteSelf()
        DataProvider.Instance.DeleteMemberResourceOtherType(mDocumentId, mOtherTypeId)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class MemberResourceOtherTypeCollection
    Inherits BusinessListBase(Of MemberResourceOtherTypeCollection, MemberResourceOtherType)

    Public Sub New()
        Me.MarkAsChild()
    End Sub

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As MemberResourceOtherType = MemberResourceOtherType.NewMemberResourceOtherType
        Me.Add(newObj)
        Return newObj
    End Function

    Friend Sub Delete(ByVal resource As MemberResource)
        Me.RaiseListChangedEvents = False
        Try
            For Each obj As MemberResourceOtherType In Me
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
            For Each obj As MemberResourceOtherType In DeletedList
                obj.DeleteSelf()
            Next
            DeletedList.Clear()
            For Each obj As MemberResourceOtherType In Me
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

    Public Function Find(ByVal otherTypeId As Integer) As MemberResourceOtherType
        For Each tag As MemberResourceOtherType In Me
            If tag.OtherTypeId = otherTypeId Then
                Return tag
            End If
        Next
        Return Nothing
    End Function

End Class

