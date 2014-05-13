Imports Nrc.Framework.BusinessLogic
Imports NRC.NRCAuthLib

Public Interface IDocumentBatch
    Property Id() As Integer
    Property CreationDate() As Date
    Property AuthorId() As Integer
End Interface

<Serializable()> _
Public Class DocumentBatch
    Inherits BusinessBase(Of DocumentBatch)
    Implements IDocumentBatch

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mName As String = String.Empty
    Private mAuthorId As Integer
    Private mCreationDate As Date
    Private mAuthor As Member

#End Region

#Region " Public Properties "
    Public Property Id() As Integer Implements IDocumentBatch.Id
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
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mName Then
                mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property
    Public Property AuthorId() As Integer Implements IDocumentBatch.AuthorId
        Get
            Return mAuthorId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mAuthorId Then
                mAuthorId = value
                PropertyHasChanged("AuthorId")
            End If
        End Set
    End Property

    Public ReadOnly Property Author() As Member
        Get
            If mAuthor Is Nothing Then
                mAuthor = Member.GetMember(Me.AuthorId)
            End If
            Return mAuthor
        End Get
    End Property

    Public ReadOnly Property AuthorName() As String
        Get
            Return Author.Name
        End Get
    End Property

    Public Property CreationDate() As Date Implements IDocumentBatch.CreationDate
        Get
            Return mCreationDate
        End Get
        Private Set(ByVal value As Date)
            If Not value = mCreationDate Then
                mCreationDate = value
                PropertyHasChanged("CreationDate")
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
    Public Shared Function NewDocumentBatch(ByVal memberId As Integer) As DocumentBatch
        Dim newBatch As New DocumentBatch
        newBatch.AuthorId = memberId
        Return newBatch
    End Function

    Public Shared Function NewDocumentBatch() As DocumentBatch
        Return New DocumentBatch
    End Function

    Public Shared Function [Get](ByVal batchId As Integer) As DocumentBatch
        Return DataProvider.Instance.SelectDocumentBatch(batchId)
    End Function

    ''' <summary>
    ''' Returns a collection of Document Batches created within the date range specified.  This function will only return batches that have 1 or more document nodes currently
    ''' assigned.
    ''' </summary>
    ''' <param name="fromDate"></param>
    ''' <param name="toDate"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetByDateRange(ByVal fromDate As Date, ByVal toDate As Date) As DocumentBatchCollection
        Return DataProvider.Instance.SelectDocumentBatchesByDateRange(fromDate, toDate)
    End Function

    Public Shared Function IsBatchNameUsed(ByVal name As String) As Boolean
        Return DataProvider.Instance.CheckIfBatchNameInUse(name)
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
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "Name")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("Name", 50))
        Me.ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.IntegerMinValueRuleArgs("AuthorId", 1))
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here
        Me.CreationDate = Now
        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        Id = DataProvider.Instance.InsertDocumentBatch(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteDocumentBatch(mId)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class DocumentBatchCollection
    Inherits BusinessListBase(Of DocumentBatchCollection, DocumentBatch)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As DocumentBatch = DocumentBatch.NewDocumentBatch
        Me.Add(newObj)
        Return newObj
    End Function
End Class

