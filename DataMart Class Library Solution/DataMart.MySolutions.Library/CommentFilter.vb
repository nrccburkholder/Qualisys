Imports Nrc.Framework.BusinessLogic

<Serializable()> _
Public Class CommentFilter
    Inherits BusinessBase(Of CommentFilter)


#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mStudyTableColumnId As Integer
    Private mGroupId As Integer
    Private mName As String = String.Empty
    Private mIsDisplayed As Boolean
    Private mIsExported As Boolean
    Private mIsDisplayedOnServiceAlert As Boolean
    Private mIsExportedOnServiceAlert As Boolean
    Private mAllowGroupBy As Boolean
#End Region

#Region " Public Properties "
    Public Property StudyTableColumnId() As Integer
        Get
            Return mStudyTableColumnId
        End Get
        Set(ByVal value As Integer)
            If mStudyTableColumnId <> value Then
                mStudyTableColumnId = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    Public Property GroupId() As Integer
        Get
            Return mGroupId
        End Get
        Set(ByVal value As Integer)
            If mGroupId <> value Then
                mGroupId = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property

    Public Property IsDisplayed() As Boolean
        Get
            Return mIsDisplayed
        End Get
        Set(ByVal value As Boolean)
            If mIsDisplayed <> value Then
                mIsDisplayed = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    Public Property IsExported() As Boolean
        Get
            Return mIsExported
        End Get
        Set(ByVal value As Boolean)
            If mIsExported <> value Then
                mIsExported = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    Public Property IsDisplayedOnServiceAlert() As Boolean
        Get
            Return mIsDisplayedOnServiceAlert
        End Get
        Set(ByVal value As Boolean)
            If mIsDisplayedOnServiceAlert <> value Then
                mIsDisplayedOnServiceAlert = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    Public Property IsExportedOnServiceAlert() As Boolean
        Get
            Return mIsExportedOnServiceAlert
        End Get
        Set(ByVal value As Boolean)
            If mIsExportedOnServiceAlert <> value Then
                mIsExportedOnServiceAlert = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    Public Property AllowGroupBy() As Boolean
        Get
            Return mAllowGroupBy
        End Get
        Set(ByVal value As Boolean)
            If mAllowGroupBy <> value Then
                mAllowGroupBy = value
                PropertyHasChanged()
            End If
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
    End Sub
#End Region

#Region " Overrides "
    Protected Overrides Function GetIdValue() As Object
        Return mInstanceGuid
    End Function

    Public Overrides Function ToString() As String
        Return mName
    End Function

    Protected Overrides Sub AddBusinessRules()
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "Name")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("Name", 20))
        Me.ValidationRules.AddRule(AddressOf ValidateNameChars, "Name")
    End Sub
#End Region

#Region " Validation Methods "
    Private Function ValidateNameChars(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If Name.Contains(" ") Then
            e.Description = "The filter name cannot contain spaces."
            Return False
        ElseIf Name.Contains("/") OrElse Name.Contains("\") Then
            e.Description = "The filter name cannot contain slashes."
            Return False
        ElseIf Name.Contains("-") Then
            e.Description = "The filter name cannot contain dashes."
            Return False
        Else
            Return True
        End If
    End Function
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()

    End Sub

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateCommentFilter(Me)
        MarkClean()
    End Sub

    Protected Overrides Sub Insert()
        DataProvider.Instance.InsertCommentFilter(Me)
        MarkOld()
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteCommentFilter(mStudyTableColumnId, mGroupId)
    End Sub

#End Region

#Region " Factory Methods "
    Public Shared Function NewCommentFilter() As CommentFilter
        Dim obj As New CommentFilter
        obj.CreateNew()
        Return obj
    End Function
    Public Shared Function GetByGroupId(ByVal groupId As Integer) As CommentFilterCollection
        Return DataProvider.Instance.SelectCommentFiltersByGroupId(groupId)
    End Function
#End Region


End Class

<Serializable()> _
Public Class CommentFilterCollection
    Inherits Nrc.Framework.BusinessLogic.BusinessListBase(Of CommentFilterCollection, CommentFilter)

    Protected Overrides Function AddNewCore() As Object
        Return CommentFilter.NewCommentFilter
    End Function

    Protected Overrides Sub InsertItem(ByVal index As Integer, ByVal item As CommentFilter)
        For Each filter As CommentFilter In Me
            If filter.StudyTableColumnId = item.StudyTableColumnId Then
                Throw New ArgumentException("Comment filter has a StudyTableColumnId that is already in the collection")
            End If
        Next
        MyBase.InsertItem(index, item)
    End Sub

End Class
