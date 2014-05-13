Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

Public Interface IMemberResourceQuestion
    Property Id() As Integer
End Interface

<Serializable()> _
Public Class MemberResourceQuestion
    Inherits BusinessBase(Of MemberResourceQuestion)
    Implements IMemberResourceQuestion

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mDocumentId As Integer
    Private mServiceTypeId As Integer
    Private mViewId As Integer
    Private mThemeId As Integer
    Private mQuestionId As Integer
#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IMemberResourceQuestion.Id
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
    Public Property DocumentId() As Integer
        Get
            Return mDocumentId
        End Get
        Set(ByVal value As Integer)
            If Not value = mDocumentId Then
                mDocumentId = value
                PropertyHasChanged("DocumentId")
            End If
        End Set
    End Property
    Public Property ServiceTypeId() As Integer
        Get
            Return mServiceTypeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mServiceTypeId Then
                mServiceTypeId = value
                PropertyHasChanged("ServiceTypeId")
            End If
        End Set
    End Property
    Public Property ViewId() As Integer
        Get
            Return mViewId
        End Get
        Set(ByVal value As Integer)
            If Not value = mViewId Then
                mViewId = value
                PropertyHasChanged("ViewId")
            End If
        End Set
    End Property
    Public Property ThemeId() As Integer
        Get
            Return mThemeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mThemeId Then
                mThemeId = value
                PropertyHasChanged("ThemeId")
            End If
        End Set
    End Property
    Public Property QuestionId() As Integer
        Get
            Return mQuestionId
        End Get
        Set(ByVal value As Integer)
            If Not value = mQuestionId Then
                mQuestionId = value
                PropertyHasChanged("QuestionId")
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

    Public Shared Function NewMemberResourceQuestion(ByVal serviceTypeId As Integer, ByVal viewId As Integer, ByVal themeId As Integer, ByVal questionId As Integer) As MemberResourceQuestion
        Dim mr As New MemberResourceQuestion
        mr.ServiceTypeId = serviceTypeId
        mr.ViewId = viewId
        mr.ThemeId = themeId
        mr.QuestionId = questionId
        Return mr
    End Function

    Public Shared Function NewMemberResourceQuestion() As MemberResourceQuestion
        Return New MemberResourceQuestion
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
        Me.Id = DataProvider.Instance.InsertMemberResourceQuestion(Me)
    End Sub

    Friend Overloads Sub Insert(ByVal resource As MemberResource)
        If Not Me.IsDirty Then Exit Sub
        Me.DocumentId = resource.Id
        Insert()
        Me.MarkOld()
    End Sub

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateMemberResourceQuestion(Me)
    End Sub

    Friend Overloads Sub Update(ByVal resource As MemberResource)
        If Not Me.IsDirty Then Exit Sub
        Me.DocumentId = resource.Id
        Update()
        Me.MarkClean()
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteMemberResourceQuestion(mId)
    End Sub

    Friend Sub DeleteSelf()
        DataProvider.Instance.DeleteMemberResourceQuestion(mId)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class MemberResourceQuestionCollection
    Inherits BusinessListBase(Of MemberResourceQuestionCollection, MemberResourceQuestion)

    Public Sub New()
        Me.MarkAsChild()
    End Sub

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As MemberResourceQuestion = MemberResourceQuestion.NewMemberResourceQuestion
        Me.Add(newObj)
        Return newObj
    End Function

    Friend Sub Delete(ByVal resource As MemberResource)
        Me.RaiseListChangedEvents = False
        Try
            For Each obj As MemberResourceQuestion In Me
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
            For Each obj As MemberResourceQuestion In DeletedList
                obj.DeleteSelf()
            Next
            DeletedList.Clear()
            For Each obj As MemberResourceQuestion In Me
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

    Public Function Find(ByVal serviceTypeId As Integer, ByVal viewId As Integer, ByVal themeId As Integer, ByVal questionId As Integer) As MemberResourceQuestion
        For Each question As MemberResourceQuestion In Me
            If question.ServiceTypeId = serviceTypeId AndAlso question.ViewId = viewId AndAlso question.ThemeId = themeId AndAlso question.QuestionId = questionId Then
                Return question
            End If
        Next
        Return Nothing
    End Function

End Class

