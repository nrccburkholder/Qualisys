Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

''' <summary>
''' Business object that holds a collection of tags for a member resource
''' </summary>
''' <remarks>
''' A tag for a member resource includes 
''' </remarks>
<Serializable()> _
Public Class MemberResourceTag
    Inherits BusinessBase(Of MemberResourceTag)

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mDocumentId As Integer
    Private mDescription As String = String.Empty
#End Region

#Region " Public Properties "

    Public Property DocumentId() As Integer
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
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Private Set(ByVal value As String)
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

    Friend Shared Function NewMemberResourceTag(ByVal documentId As Integer, ByVal description As String) As MemberResourceTag
        Dim mr As New MemberResourceTag
        mr.DocumentId = documentId
        mr.Description = description
        Return mr
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

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class MemberResourceTagCollection
    Inherits BusinessListBase(Of MemberResourceTagCollection, MemberResourceTag)

    Friend Overloads Sub Add(ByVal documentId As Integer, ByVal description As String)
        If FindDescription(description) IsNot Nothing Then Return
        MyBase.Add(MemberResourceTag.NewMemberResourceTag(documentId, description))
    End Sub

    Public Function FindDescription(ByVal description As String) As MemberResourceTag
        For Each item As MemberResourceTag In Me
            If String.Equals(item.Description, description, StringComparison.CurrentCultureIgnoreCase) Then Return item
        Next
        Return Nothing
    End Function

End Class

