Public Class CriteriaClause
    Implements ICloneable

#Region "Enums"
    ''' <summary>
    ''' List of operators that can be used when creating a criteria clause.
    ''' </summary>
    ''' <remarks></remarks>
    Public Enum Operators
        None = 0
        Equals = 1
        NotEqual = 2
        GreaterThan = 3
        GreaterThanOrEqual = 4
        LessThan = 5
        LessThanOrEqual = 6
        [In] = 7
        Between = 8
        [Is] = 9
        [IsNot] = 10
        NotIn = 11
    End Enum
#End Region

#Region "Private Fields"
    Private mOperator As Operators
    Private mStudyTableColumn As StudyTableColumn
    Private mStudyTable As StudyTable
    Private mHighValue As String
    Private mLowValue As String
    Private mValueList As Collection(Of CriteriaInValue)
    Private mCriteriaPhraseId As Integer
    Private mCriteriaStatementId As Integer
    Private mId As Integer

    Private mIsDirty As Boolean
#End Region

#Region "Public Properties"
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
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    ''' <summary>
    ''' The ID of the criteria object that this clause belongs to.
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
    ''' The ID of the criteria phrase object that this clause belongs to.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property CriteriaPhraseId() As Integer
        Get
            Return mCriteriaPhraseId
        End Get
        Set(ByVal value As Integer)
            mCriteriaPhraseId = value
        End Set
    End Property

    ''' <summary>
    ''' The operator that this clause uses
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property [Operator]() As Operators
        Get
            Return mOperator
        End Get
        Set(ByVal value As Operators)
            If mOperator <> value Then
                mOperator = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Returns a collection of values if the operator is In or NotIn.  Otherwise it returns an empty collection
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property ValueList() As Collection(Of CriteriaInValue)
        Get
            If mValueList Is Nothing Then
                If (mOperator = Operators.[In] OrElse mOperator = Operators.NotIn) Then
                    mValueList = CriteriaInValue.GetByCriteriaClauseId(Me.mId)
                Else
                    mValueList = New Collection(Of CriteriaInValue)
                End If
            End If

            Return mValueList
        End Get
    End Property

    ''' <summary>
    ''' Returns the value if the operator is something other than between, In, or NotIn.  If it is between or notBetween, it is the low value for the range.
    ''' An empty string is returned for In or NotIn.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property LowValue() As String
        Get
            Return mLowValue
        End Get
        Set(ByVal value As String)
            If mLowValue <> value Then
                mLowValue = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Returns the high value if the operator is between.  Otherwise, an empty string is returned.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property HighValue() As String
        Get
            Return mHighValue
        End Get
        Set(ByVal value As String)
            If mHighValue <> value Then
                mHighValue = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Creates the string value that is displayed in the criteria editor
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property DisplayValue() As String
        Get
            Dim dispValue As String = ""

            Select Case mOperator
                Case Operators.[In], Operators.NotIn  'In-List
                    For Each inValue As CriteriaInValue In ValueList
                        dispValue &= IIf(dispValue.Length > 0, ",", "").ToString & inValue.Value
                    Next

                Case Operators.Between              'Low and High
                    dispValue = mLowValue & "," & mHighValue

                Case Operators.[Is], Operators.[IsNot]  'Null
                    dispValue = "NULL"

                Case Else                           'Low only
                    dispValue = mLowValue

            End Select

            Return dispValue
        End Get
    End Property

    ''' <summary>
    ''' Identifies the database table that the column belongs to
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property StudyTable() As StudyTable
        Get
            Return mStudyTable
        End Get
        Set(ByVal value As StudyTable)
            If value Is Nothing Then
                Throw New ArgumentNullException("value", "You cannot set the StudyTable property to NULL")
            End If
            If mStudyTable Is Nothing OrElse mStudyTable.Id <> value.Id Then
                mStudyTable = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Identifies the database column that this clause uses.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property StudyTableColumn() As StudyTableColumn
        Get
            Return mStudyTableColumn
        End Get
        Set(ByVal value As StudyTableColumn)
            If value Is Nothing Then
                Throw New ArgumentNullException("value", "You cannot set the StudyTableColumn property to NULL")
            End If
            If mStudyTableColumn Is Nothing OrElse mStudyTableColumn.Id <> value.Id Then
                mStudyTableColumn = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Displays the column name with an alias for the table it belongs to
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property AliasedColumnName() As String
        Get
            If mStudyTable IsNot Nothing AndAlso mStudyTableColumn IsNot Nothing Then
                Return mStudyTable.Name & "." & mStudyTableColumn.Name
            Else
                Return ""
            End If
        End Get
    End Property

    ''' <summary>
    ''' Displays that column name as it appears in the bigView
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property BigViewColumnName() As String
        Get
            If mStudyTable IsNot Nothing AndAlso mStudyTableColumn IsNot Nothing Then
                Return mStudyTable.Name & mStudyTableColumn.Name
            Else
                Return ""
            End If
        End Get
    End Property
#End Region


#Region "DB CRUD"
    ''' <summary>
    ''' Creates all criteria clauses that exist for the specified phrase and statement
    ''' </summary>
    ''' <param name="criteriaStatementId"></param>
    ''' <param name="criteriaPhraseId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetByCriteriaStatementIdAndPhraseId(ByVal criteriaStatementId As Integer, ByVal criteriaPhraseId As Integer) As Collection(Of CriteriaClause)
        Return DataProvider.CriteriaProvider.Instance.SelectCriteriaClauseByStatementAndPhraseId(criteriaStatementId, criteriaPhraseId)
    End Function
#End Region

#Region "Public Methods"
    ''' <summary>
    ''' Gets the string representation of the operator
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function OperatorName() As String
        Dim opName As String = ""

        Select Case mOperator
            Case Operators.Equals
                opName = "="
            Case Operators.NotEqual
                opName = "<>"
            Case Operators.GreaterThan
                opName = ">"
            Case Operators.GreaterThanOrEqual
                opName = ">="
            Case Operators.LessThan
                opName = "<"
            Case Operators.LessThanOrEqual
                opName = "<="
            Case Operators.[In]
                opName = "IN"
            Case Operators.NotIn
                opName = "NOT IN"
            Case Operators.Between
                opName = "BETWEEN"
            Case Operators.[Is]
                opName = "IS"
            Case Operators.[IsNot]
                opName = "IS NOT"
        End Select

        Return opName
    End Function

    ''' <summary>
    ''' Creates a deep clone of the object
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function Clone() As Object Implements System.ICloneable.Clone
        Dim clause As New CriteriaClause
        clause.mOperator = mOperator
        clause.mStudyTableColumn = mStudyTableColumn
        clause.mStudyTable = mStudyTable
        clause.mHighValue = mHighValue
        clause.mLowValue = mLowValue
        clause.mCriteriaPhraseId = mCriteriaPhraseId
        clause.mCriteriaStatementId = mCriteriaStatementId
        clause.mId = mId
        clause.mIsDirty = mIsDirty
        clause.mValueList = New Collection(Of CriteriaInValue)

        For Each value As CriteriaInValue In Me.ValueList
            clause.mValueList.Add(DirectCast(value.Clone(), CriteriaInValue))
        Next

        Return clause
    End Function
#End Region
End Class
