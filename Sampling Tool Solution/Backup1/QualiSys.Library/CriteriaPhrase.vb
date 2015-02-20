Public Class CriteriaPhrase
    Implements ICloneable

#Region "Private Fields"
    Private mId As Integer
    Private mClauses As Collection(Of CriteriaClause)
    Private mCriteriaStatementId As Integer
#End Region

#Region "Public Properties"
    ''' <summary>
    ''' The ID of the criteria object this phrase belongs to
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property CriteriaStatementId() As Integer
        Get
            Return mCriteriaStatementId
        End Get
        Set(ByVal value As Integer)
            mCriteriaStatementId = value
        End Set
    End Property

    ''' <summary>
    ''' Collection of criteria clauses
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property Clauses() As Collection(Of CriteriaClause)
        Get
            If mClauses Is Nothing Then
                mClauses = CriteriaClause.GetByCriteriaStatementIdAndPhraseId(mCriteriaStatementId, mId)
            End If
            Return mClauses
        End Get
    End Property

    ''' <summary>
    ''' The ID
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

#End Region

#Region "DB CRUD"
    ''' <summary>
    ''' Gets all phrases for a criteria object
    ''' </summary>
    ''' <param name="criteriaStatementId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetByCriteriaStatementId(ByVal criteriaStatementId As Integer) As Collection(Of CriteriaPhrase)
        Return DataProvider.CriteriaProvider.Instance.SelectCriteriaPhraseByCriteriaStatementId(criteriaStatementId)
    End Function

#End Region

    ''' <summary>
    ''' Creates a deep copy of the object
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function Clone() As Object Implements System.ICloneable.Clone
        Dim phrase As New CriteriaPhrase
        phrase.mId = mId
        phrase.mCriteriaStatementId = mCriteriaStatementId
        phrase.mClauses = New Collection(Of CriteriaClause)

        For Each clause As CriteriaClause In Me.Clauses
            phrase.mClauses.Add(DirectCast(clause.Clone(), CriteriaClause))
        Next

        Return phrase
    End Function
End Class
