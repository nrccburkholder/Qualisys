Option Strict On
Option Explicit On

Imports Nrc.Framework.BusinessLogic

Public Interface IIndexSearchResult
    Property Id() As Integer
End Interface

<Serializable()> _
Public Class IndexSearchResult
    Inherits BusinessBase(Of IndexSearchResult)
    Implements IIndexSearchResult

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mTitle As String = String.Empty
    Private mRank As Integer
    Private mResultSet As Guid
#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IIndexSearchResult.Id
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
    Public Property Rank() As Integer
        Get
            Return mRank
        End Get
        Set(ByVal value As Integer)
            If Not value = mRank Then
                mRank = value
                PropertyHasChanged("Rank")
            End If
        End Set
    End Property
    Public Property ResultSet() As Guid
        Get
            Return mResultSet
        End Get
        Set(ByVal value As Guid)
            If Not value = mResultSet Then
                mResultSet = value
                PropertyHasChanged("ResultSet")
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

    Public Shared Function NewIndexSearchResult(ByVal title As String, ByVal resultSet As Guid) As IndexSearchResult
        Dim mr As New IndexSearchResult
        mr.Title = title
        mr.ResultSet = resultSet
        Return mr
    End Function

    Public Shared Function NewIndexSearchResult() As IndexSearchResult
        Return New IndexSearchResult
    End Function

    Public Shared Function GetIndexServerSearchResults(ByVal resultSet As Guid, ByVal text As String) As IndexSearchResultCollection
        Return DataProvider.Instance.SearchIndexSearchResult(resultSet, text)
    End Function

    Public Shared Sub ClearIndexSearchResult(ByVal resultSet As Guid)
        DataProvider.Instance.ClearIndexSearchResult(resultSet)
    End Sub

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
        Id = DataProvider.Instance.InsertIndexSearchResult(Me)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class IndexSearchResultCollection
    Inherits BusinessListBase(Of IndexSearchResultCollection, IndexSearchResult)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As IndexSearchResult = IndexSearchResult.NewIndexSearchResult
        Me.Add(newObj)
        Return newObj
    End Function

End Class

