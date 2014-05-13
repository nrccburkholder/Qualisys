Imports Nrc.Framework.BusinessLogic

Public Interface IManagedContent
    Property Id() As Integer
    Property Category() As String
    Property Key() As String
End Interface

<Serializable()> _
Public Class ManagedContent
    Inherits BusinessBase(Of ManagedContent)
    Implements IManagedContent

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mCategory As String = String.Empty
    Private mKey As String = String.Empty
    Private mContent As String = String.Empty
    Private mTeaser As String = String.Empty
    Private mIsActive As Boolean
    Private mDateCreated As DateTime
    Private mDateModified As DateTime
#End Region

#Region " Public Properties "
    Public Property Id() As Integer Implements IManagedContent.Id
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
    Public Property Category() As String Implements IManagedContent.Category
        Get
            Return mCategory
        End Get
        Private Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCategory Then
                mCategory = value
                PropertyHasChanged("Category")
            End If
        End Set
    End Property
    Public Property Key() As String Implements IManagedContent.Key
        Get
            Return mKey
        End Get
        Private Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mKey Then
                mKey = value
                PropertyHasChanged("Key")
            End If
        End Set
    End Property
    Public Property Content() As String
        Get
            Return mContent
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mContent Then
                mContent = value
                PropertyHasChanged("Content")
            End If
        End Set
    End Property
    Public Property Teaser() As String
        Get
            Return mTeaser
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTeaser Then
                mTeaser = value
                PropertyHasChanged("Teaser")
            End If
        End Set
    End Property
    Public Property IsActive() As Boolean
        Get
            Return mIsActive
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsActive Then
                mIsActive = value
                PropertyHasChanged("IsActive")
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

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods"
    Public Shared Function NewManagedContent(ByVal category As String, ByVal key As String) As ManagedContent
        Dim mc As New ManagedContent
        mc.Category = category
        mc.Key = key
        Return mc
    End Function

    Public Shared Function NewManagedContent() As ManagedContent
        Return New ManagedContent
    End Function

    Public Shared Function GetByKey(ByVal category As String, ByVal key As String) As ManagedContent
        Return DataProvider.Instance.SelectManagedContentByKey(category, key)
    End Function

    Public Shared Function GetByCategory(ByVal category As String, ByVal includeInactive As Boolean) As ManagedContentCollection
        Return DataProvider.Instance.SelectManagedContentByCategory(category, includeInactive)
    End Function

    Public Shared Function GetAll(ByVal includeInactive As Boolean) As ManagedContentCollection
        Return DataProvider.Instance.SelectAllManagedContent(includeInactive)
    End Function

    Public Shared Function GetCategoryList() As List(Of String)
        Return DataProvider.Instance.SelectManagedContentCategories
    End Function

    Public Shared Function GetKeyList(ByVal category As String) As List(Of String)
        Return DataProvider.Instance.SelectManagedContentKeys(category)
    End Function
   
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mCategory
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
        Id = DataProvider.Instance.InsertManagedContent(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateManagedContent(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteManagedContent(mCategory, mKey)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class ManagedContentCollection
    Inherits BusinessListBase(Of ManagedContentCollection, ManagedContent)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ManagedContent = ManagedContent.NewManagedContent
        Me.Add(newObj)
        Return newObj
    End Function

    Public Function Find(ByVal category As String, ByVal key As String) As ManagedContent
        For Each mc As ManagedContent In Me
            If mc.Category = category AndAlso mc.Key = key Then
                Return mc
            End If
        Next

        Return Nothing
    End Function

End Class

