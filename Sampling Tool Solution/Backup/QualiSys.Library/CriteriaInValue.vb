Public Class CriteriaInValue
    Implements ICloneable

#Region "Private Fields"

    Private mId As Integer
    Private mValue As String
    Private mCriteriaClauseId As Integer

    Private mIsDirty As Boolean

#End Region

#Region "Public Properties"
    ''' <summary>
    ''' Creates a new object with no value
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub New()
    End Sub

    ''' <summary>
    ''' Creates a new object with the specified value
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub New(ByVal val As String)
        mValue = val
        mIsDirty = True
    End Sub

    ''' <summary>
    ''' The ID of the criteria clause that this value belongs to
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property CriteriaClauseId() As Integer
        Get
            Return mCriteriaClauseId
        End Get
        Set(ByVal value As Integer)
            mCriteriaClauseId = value
        End Set
    End Property

    ''' <summary>
    ''' The value
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Value() As String
        Get
            Return mValue
        End Get
        Set(ByVal value As String)
            If mValue <> value Then
                mValue = value
                mIsDirty = True
            End If
        End Set
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
            If mId <> value Then
                mIsDirty = True
                mId = value
            End If
        End Set
    End Property

#End Region


#Region "DB CRUD"

    Public Shared Function GetByCriteriaClauseId(ByVal criteriaClauseId As Integer) As Collection(Of CriteriaInValue)
        Return DataProvider.CriteriaProvider.Instance.SelectCriteriaInListByCriteriaClause(criteriaClauseId)
    End Function

#End Region

    Public Function Clone() As Object Implements System.ICloneable.Clone
        Dim value As New CriteriaInValue

        value.mId = mId
        value.mValue = mValue
        value.mCriteriaClauseId = mCriteriaClauseId
        value.mIsDirty = mIsDirty

        Return value
    End Function

End Class
