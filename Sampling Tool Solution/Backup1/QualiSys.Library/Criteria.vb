Public Class Criteria
    Implements ICloneable

    Private mId As Nullable(Of Integer)
    Private mName As String = String.Empty
    Private mStudyId As Integer
    Private mInitialCriteriaStatement As String

    Private mPhrases As Collection(Of CriteriaPhrase)

    ''' <summary>
    ''' Creates a new study object for the specified study
    ''' </summary>
    ''' <param name="studyId"></param>
    ''' <remarks></remarks>
    Public Sub New(ByVal studyId As Integer)

        mStudyId = studyId

    End Sub

#Region " Public Properties "

#Region " Persisted Properties "

    ''' <summary>
    ''' The ID
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property Id() As Nullable(Of Integer)
        Get
            If mId.HasValue Then
                Return mId.Value
            End If
            Return Nothing
        End Get
        Friend Set(ByVal value As Nullable(Of Integer))
            mId = value
        End Set
    End Property

    ''' <summary>
    ''' The name
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            mName = value
        End Set
    End Property

    ''' <summary>
    ''' The ID for the study that this criteria belongs to
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Set(ByVal value As Integer)
            mStudyId = value
        End Set
    End Property

    ''' <summary>
    ''' This property returns the current value for the string value of the statement.  It should be used
    ''' instead of the InitialCriteriaStatement if changes have been made to the object.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public ReadOnly Property CriteriaStatement() As String
        Get
            If mPhrases Is Nothing Then
                Return mInitialCriteriaStatement
            Else
                Return BuildCriteriaStatement(False, False)
            End If
        End Get
    End Property

    ''' <summary>
    ''' Builds the criteria string using the collections of phrases
    ''' </summary>
    ''' <param name="useAliasedColumnNames"></param>
    ''' <param name="useLineFeedPhrase"></param>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks>By setting different values for the parameters, the consumer can create a statement that is suitable
    ''' for displaying to the user, or a statement that is appropriate for saving in the criteriastmt table in the database.</remarks>
    Public ReadOnly Property CriteriaStatementDisplay(ByVal useAliasedColumnNames As Boolean, ByVal useLineFeedPhrase As Boolean) As String
        Get
            Return BuildCriteriaStatement(useAliasedColumnNames, useLineFeedPhrase)
        End Get
    End Property

#End Region

    ''' <summary>
    ''' Verifies that a criteria statement and study ID are present
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property IsValid() As Boolean
        Get
            If CriteriaStatement() <> "" AndAlso mStudyId <> 0 Then
                Return True
            Else : Return False
            End If
        End Get
    End Property

    ''' <summary>
    ''' Contains a collection of criteria phrases
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property Phrases() As Collection(Of CriteriaPhrase)
        Get
            If mPhrases Is Nothing Then
                If mId.HasValue Then
                    mPhrases = CriteriaPhrase.GetByCriteriaStatementId(mId.Value)
                Else
                    mPhrases = New Collection(Of CriteriaPhrase)
                End If
            End If
            Return mPhrases
        End Get
    End Property

    ''' <summary>
    ''' This property is the string value of the statement prior to changes being made
    ''' </summary>
    ''' <value></value>
    ''' <remarks></remarks>
    Public WriteOnly Property InitialCriteriaStatement() As String
        Set(ByVal value As String)
            mInitialCriteriaStatement = value
        End Set
    End Property

    ''' <summary>
    ''' Boolean value indicating whether changes have been made to the object since it was loaded from the database.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property IsDirty() As Boolean
        Get
            If mInitialCriteriaStatement = CriteriaStatement() Then
                Return False
            End If
            Return True
        End Get
    End Property

#End Region

#Region "Private Functions"

    ''' <summary>
    ''' This function creates the actual string value for criteria 
    ''' </summary>
    ''' <param name="useAliasedColumnNames"></param>
    ''' <param name="useLineFeedPhrase"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function BuildCriteriaStatement(ByVal useAliasedColumnNames As Boolean, ByVal useLineFeedPhrase As Boolean) As String

        Dim statement As New Text.StringBuilder("")

        For Each phrase As CriteriaPhrase In Phrases
            If statement.Length > 0 Then
                If useLineFeedPhrase Then statement.AppendLine()
                statement.Append(" OR (")
            Else
                statement.Append("(")
            End If

            Dim piece As New Text.StringBuilder("")

            For Each clause As CriteriaClause In phrase.Clauses
                If piece.Length <> 0 Then piece.Append(" AND ")

                If useAliasedColumnNames Then
                    piece.Append(clause.AliasedColumnName)
                Else
                    piece.Append(clause.BigViewColumnName)
                End If

                Select Case clause.Operator
                    Case CriteriaClause.Operators.Between
                        piece.Append(String.Format(" BETWEEN {0} AND {1}", ApplyParenthesis(clause, clause.LowValue), ApplyParenthesis(clause, clause.HighValue)))

                    Case CriteriaClause.Operators.Equals
                        piece.Append(" = " & ApplyParenthesis(clause, clause.LowValue))

                    Case CriteriaClause.Operators.GreaterThan
                        piece.Append(" > " & ApplyParenthesis(clause, clause.LowValue))

                    Case CriteriaClause.Operators.GreaterThanOrEqual
                        piece.Append(" >= " & ApplyParenthesis(clause, clause.LowValue))

                    Case CriteriaClause.Operators.[In]
                        piece.Append(" IN (")
                        piece.Append(BuildInList(clause))
                        piece.Append(") ")

                    Case CriteriaClause.Operators.[Is]
                        piece.Append(" IS NULL")

                    Case CriteriaClause.Operators.[IsNot]
                        piece.Append(" IS NOT NULL")

                    Case CriteriaClause.Operators.LessThan
                        piece.Append(" < " & ApplyParenthesis(clause, clause.LowValue))

                    Case CriteriaClause.Operators.LessThanOrEqual
                        piece.Append(" <= " & ApplyParenthesis(clause, clause.LowValue))

                    Case CriteriaClause.Operators.NotEqual
                        piece.Append(" <> " & ApplyParenthesis(clause, clause.LowValue))

                    Case CriteriaClause.Operators.NotIn
                        piece.Append(" NOT IN (")
                        piece.Append(BuildInList(clause))
                        piece.Append(") ")

                End Select
            Next

            statement.Append(piece.ToString)
            statement.Append(")")
        Next

        Return statement.ToString

    End Function

    ''' <summary>
    ''' Converts the collection of in list values into a comma separated string
    ''' </summary>
    ''' <param name="clause"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Shared Function BuildInList(ByVal clause As CriteriaClause) As String

        Dim inList As New Text.StringBuilder("")

        For Each item As CriteriaInValue In clause.ValueList
            If inList.Length > 0 Then inList.Append(",")
            inList.Append(ApplyParenthesis(clause, item.Value))
        Next

        Return inList.ToString

    End Function

    ''' <summary>
    ''' Determines whether parenthesis need to be added to the value by looking at the data type of the column
    ''' </summary>
    ''' <param name="clause"></param>
    ''' <param name="value"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Shared Function ApplyParenthesis(ByVal clause As CriteriaClause, ByVal value As String) As String

        If clause.StudyTableColumn.DataType = StudyTableColumnDataTypes.DateTime Or clause.StudyTableColumn.DataType = StudyTableColumnDataTypes.String Then
            Return String.Format("""{0}""", value)
        Else
            Return value
        End If

    End Function

#End Region

#Region "DB CRUD"

    ''' <summary>
    ''' Retrieves and populates a criteria statement object from the database
    ''' </summary>
    ''' <param name="criteriaStatementId">The ID of the criteria statement to retreive</param>
    Public Shared Function [Get](ByVal criteriaStatementId As Integer) As Criteria

        Return DataProvider.CriteriaProvider.Instance.SelectCriteria(criteriaStatementId)

    End Function

#End Region

    ''' <summary>
    ''' Gets a list of all changes that have been made to the object since it was loaded or created.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend Function GetChanges() As List(Of AuditLogChange)

        Dim changes As New List(Of AuditLogChange)

        If Id.HasValue = False Then
            changes.AddRange(AuditLog.CompareObjects(Of Criteria)(Nothing, Me, "Id", AuditLogObject.Criteria))
        ElseIf IsDirty Then
            Dim original As Criteria = Criteria.Get(Id.Value)
            changes.AddRange(AuditLog.CompareObjects(Of Criteria)(original, Me, "Id", AuditLogObject.Criteria))
        End If

        Return changes

    End Function

    ''' <summary>
    ''' Creates a deep copy of the object
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks>This is typically used to allow us to rollback changes to the object if the user decides to cancel
    ''' changes they are currently making.</remarks>
    Public Function Clone() As Object Implements System.ICloneable.Clone

        Dim c As New Criteria(mStudyId)

        c.mId = mId
        c.mName = mName
        c.mInitialCriteriaStatement = mInitialCriteriaStatement
        c.mPhrases = New Collection(Of CriteriaPhrase)

        For Each phrase As CriteriaPhrase In Phrases
            c.mPhrases.Add(DirectCast(phrase.Clone(), CriteriaPhrase))
        Next

        Return c

    End Function

    ''' <summary>
    ''' Restores the object to a prior state.
    ''' </summary>
    ''' <param name="original"></param>
    ''' <remarks></remarks>
    Public Sub UndoChanges(ByVal original As Criteria)

        mId = original.mId
        mName = original.mName
        mInitialCriteriaStatement = original.mInitialCriteriaStatement
        mPhrases = original.mPhrases

    End Sub

End Class
