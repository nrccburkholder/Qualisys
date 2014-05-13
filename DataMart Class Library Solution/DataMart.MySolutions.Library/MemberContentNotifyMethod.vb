Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

Public Interface IMemberContentNotifyMethod
    Property MemberId() As Integer
End Interface

<Serializable()> _
Public Class MemberContentNotifyMethod
    Inherits BusinessBase(Of MemberContentNotifyMethod)
    Implements IMemberContentNotifyMethod

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mMemberId As Integer
    Private mContentNotifyMethod As EmailNotifyMethod
#End Region

#Region " Public Properties "

    Public Property MemberId() As Integer Implements IMemberContentNotifyMethod.MemberId
        Get
            Return mMemberId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mMemberId Then
                mMemberId = value
                PropertyHasChanged("MemberId")
            End If
        End Set
    End Property
    Public Property ContentNotifyMethod() As EmailNotifyMethod
        Get
            Return mContentNotifyMethod
        End Get
        Set(ByVal value As EmailNotifyMethod)
            If Not value = mContentNotifyMethod Then
                mContentNotifyMethod = value
                PropertyHasChanged("ContentNotifyMethod")
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

    Public Shared Function NewMemberNotifyMethod() As MemberContentNotifyMethod
        Return New MemberContentNotifyMethod
    End Function

    Public Shared Function GetContentNotifyMemberIds(ByVal notifyMethod As EmailNotifyMethod) As Integer()
        Return DataProvider.Instance.SelectContentNotifyMemberIds(notifyMethod)
    End Function

#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mMemberId
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
Public Class MemberNotifyMethodCollection
    Inherits BusinessListBase(Of MemberNotifyMethodCollection, MemberContentNotifyMethod)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As MemberContentNotifyMethod = MemberContentNotifyMethod.NewMemberNotifyMethod
        Me.Add(newObj)
        Return newObj
    End Function

End Class

