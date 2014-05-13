Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

Public Interface IMemberResource
    Property Id() As Integer
End Interface

<Serializable()> _
Public Class MemberResource
    Inherits BusinessBase(Of MemberResource)
    Implements IMemberResource

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mTitle As String = String.Empty
    Private mAuthor As String = String.Empty
    Private mFilePath As String = String.Empty
    Private mOriginalPath As String = String.Empty
    Private mAbstractHtml As String = String.Empty
    Private mAbstractPlainText As String = String.Empty
    Private mDateCreated As DateTime
    Private mDateModified As DateTime
    Private mResourceTypeId As Integer
    Private mQuestions As MemberResourceQuestionCollection = New MemberResourceQuestionCollection()
    Private mOtherTypes As MemberResourceOtherTypeCollection = New MemberResourceOtherTypeCollection()
    '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II:
    '                                   Added new group collection for mapping "clients"
    Private mGroups As MemberResourceGroupCollection = New MemberResourceGroupCollection()

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IMemberResource.Id
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
    Public Property Title() As String
        Get
            Return mTitle
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTitle Then
                mTitle = value
                PropertyHasChanged("Title")
            End If
        End Set
    End Property
    Public Property Author() As String
        Get
            Return mAuthor
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAuthor Then
                mAuthor = value
                PropertyHasChanged("Author")
            End If
        End Set
    End Property
    Public Property FilePath() As String
        Get
            Return mFilePath
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFilePath Then
                mFilePath = value
                PropertyHasChanged("FilePath")
            End If
        End Set
    End Property
    Public Property OriginalPath() As String
        Get
            Return mOriginalPath
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mOriginalPath Then
                mOriginalPath = value
                PropertyHasChanged("OriginalPath")
            End If
        End Set
    End Property
    Public Property AbstractHtml() As String
        Get
            Return mAbstractHtml
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAbstractHtml Then
                mAbstractHtml = value
                PropertyHasChanged("AbstractHtml")
            End If
        End Set
    End Property
    Public Property AbstractPlainText() As String
        Get
            Return mAbstractPlainText
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAbstractPlainText Then
                mAbstractPlainText = value
                PropertyHasChanged("AbstractPlainText")
            End If
        End Set
    End Property
    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mDateCreated Then
                mDateCreated = value
                PropertyHasChanged("DateCreated")
            End If
        End Set
    End Property
    Public Property DateModified() As Date
        Get
            Return mDateModified
        End Get
        Set(ByVal value As Date)
            If Not value = mDateModified Then
                mDateModified = value
                PropertyHasChanged("DateModified")
            End If
        End Set
    End Property
    Public Property ResourceTypeId() As Integer
        Get
            Return mResourceTypeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mResourceTypeId Then
                mResourceTypeId = value
                PropertyHasChanged("ResourceTypeId")
            End If
        End Set
    End Property

    Public ReadOnly Property ResourceType() As String
        Get
            Return Nrc.DataMart.MySolutions.Library.ResourceType.GetByKey(mResourceTypeId).Description
        End Get
    End Property

    Public ReadOnly Property AllTags() As MemberResourceTagCollection
        Get
            Dim serviceTypes As Nrc.DataMart.MySolutions.Library.ServiceTypeCollection = ServiceType.GetAll()
            Dim tags As New MemberResourceTagCollection
            For Each item As MemberResourceQuestion In Questions
                tags.Add(Id, serviceTypes.FindServiceType(item.ServiceTypeId).Name)
                tags.Add(Id, serviceTypes.FindTheme(item.ThemeId).Name)
            Next
            tags.Add(Id, ResourceType)
            For Each item As MemberResourceOtherType In OtherTypes
                tags.Add(Id, item.Description)
            Next
            Return tags
        End Get
    End Property

    Public ReadOnly Property OtherTypes() As MemberResourceOtherTypeCollection
        Get
            Return mOtherTypes
        End Get
    End Property

    Public ReadOnly Property Questions() As MemberResourceQuestionCollection
        Get
            Return mQuestions
        End Get
    End Property

    '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II:
    '                                   Added new group collection for mapping "clients"
    Public ReadOnly Property Groups() As MemberResourceGroupCollection
        Get
            Return mGroups
        End Get
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "

    Public Shared Function NewMemberResource(ByVal title As String, ByVal author As String, ByVal filePath As String, ByVal originalPath As String, ByVal abstractHtml As String, ByVal abstractPlainText As String, ByVal resourceId As Integer) As MemberResource
        Dim mr As New MemberResource
        mr.Title = title
        mr.Author = author
        mr.FilePath = filePath
        mr.OriginalPath = originalPath
        mr.AbstractHtml = abstractHtml
        mr.AbstractPlainText = abstractPlainText
        mr.ResourceTypeId = resourceId
        Return mr
    End Function

    Public Shared Function NewMemberResource() As MemberResource
        Return New MemberResource
    End Function

    Public Shared Function GetMemberResource(ByVal id As Integer) As MemberResource
        Return DataProvider.Instance.SelectMemberResource(id)
    End Function

    Public Shared Function GetMemberResourceByTitle(ByVal title As String) As MemberResource
        Return DataProvider.Instance.SelectMemberResourceByTitle(title)
    End Function

    Public Shared Function GetAllMemberResource() As MemberResourceCollection
        Return DataProvider.Instance.SelectAllMemberResource()
    End Function

    Public Shared Function GetRecentMemberResources(ByVal serviceTypeId As Integer, ByVal viewId As Integer, ByVal themeId As Integer, ByVal questionId As Integer, ByVal groupId As Integer) As MemberResourceCollection
        '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II:
        '                                   Added parameter to the SelectRecentMemberResource function to filter by groups.
        Return DataProvider.Instance.SelectRecentMemberResource(serviceTypeId, viewId, themeId, questionId, groupId)
    End Function

    Public Shared Function GetSearchMemberResourcesText(ByVal resultSet As Guid, ByVal text As String, ByVal serviceTypeId As Integer, ByVal groupId As Integer) As MemberResourceCollection
        '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II:
        '                                   Added two parameters to the SearchTextMemberResource function.
        Return DataProvider.Instance.SearchTextMemberResource(resultSet, text, serviceTypeId, groupId)
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

    Public Overrides ReadOnly Property IsDirty() As Boolean
        Get
            '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II
            Return (MyBase.IsDirty OrElse mQuestions.IsDirty OrElse mOtherTypes.IsDirty OrElse mGroups.IsDirty)
        End Get
    End Property

    Public Overrides ReadOnly Property IsValid() As Boolean
        Get
            '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II
            Return (MyBase.IsValid AndAlso mQuestions.IsValid AndAlso mOtherTypes.IsValid AndAlso mGroups.IsValid)
        End Get
    End Property
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
        Id = DataProvider.Instance.InsertMemberResource(Me)
        mQuestions.Update(Me)
        mOtherTypes.Update(Me)
        '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II
        mGroups.Update(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateMemberResource(Me)
        mQuestions.Update(Me)
        mOtherTypes.Update(Me)
        '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II
        mGroups.Update(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        mOtherTypes.Delete(Me)
        mQuestions.Delete(Me)
        '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II
        mGroups.Delete(Me)
        DataProvider.Instance.DeleteMemberResource(mId)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class MemberResourceCollection
    Inherits BusinessListBase(Of MemberResourceCollection, MemberResource)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As MemberResource = MemberResource.NewMemberResource
        Me.Add(newObj)
        Return newObj
    End Function

    Public Function Find(ByVal id As Integer) As MemberResource
        For Each item As MemberResource In Me
            If item.Id = id Then Return item
        Next
        Return Nothing
    End Function

End Class

