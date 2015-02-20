Public Class BusinessRule

#Region "Enums"
    Public Enum BusinessRuleType
        None = 0
        DQ = 1
        Newborn = 2
        Provider = 3
        MinorExclusion = 4
        BadAddress = 5
        BadPhone = 6
    End Enum

#End Region

#Region "Private Fields"
    Private mId As Integer
    Private mCriteriaId As Integer
    Private mCriteria As Criteria
    Private mRuleType As BusinessRuleType
    Private mSurvey As Survey

    Private mIsDirty As Boolean
    Private mNeedsDeleted As Boolean
#End Region

    ''' <summary>
    ''' Creates a new instance of a business rule for a given survey using the supplied criteria
    ''' </summary>
    ''' <param name="survey"></param>
    ''' <param name="criteria"></param>
    ''' <remarks></remarks>
    Public Sub New(ByVal survey As Survey, ByVal criteria As Criteria)
        mCriteria = criteria
        mSurvey = survey
    End Sub

#Region "public Properties"
    ''' <summary>
    ''' The survey that this business rule belongs to.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Survey() As Survey
        Get
            Return mSurvey
        End Get
        Set(ByVal value As Survey)
            mSurvey = value
        End Set
    End Property

    ''' <summary>
    ''' Indicates that this object needs to be deleted from the database
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property NeedsDeleted() As Boolean
        Get
            Return mNeedsDeleted
        End Get
        Set(ByVal value As Boolean)
            mNeedsDeleted = value
            mIsDirty = True
        End Set
    End Property

    ''' <summary>
    ''' The ID for the criteria.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property CriteriaId() As Integer
        Get
            Return mCriteriaId
        End Get
        Set(ByVal value As Integer)
            mCriteriaId = value
        End Set
    End Property

    ''' <summary>
    ''' The ID of this business rule
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Set(ByVal value As Integer)
            mId = value
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
            Return mIsDirty Or Criteria.IsDirty
        End Get
    End Property

    ''' <summary>
    ''' The criteria object for this business rule.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Criteria() As Criteria
        Get
            Return mCriteria
        End Get
        Set(ByVal value As Criteria)
            mCriteria = value
        End Set
    End Property

    ''' <summary>
    ''' What type of rule is this business rule.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property RuleType() As BusinessRuleType
        Get
            Return mRuleType
        End Get
        Set(ByVal value As BusinessRuleType)
            mRuleType = value
        End Set
    End Property

    ''' <summary>
    ''' The name for the business rule object.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks>The name for the business rule object is actually the name of the criteria object it contains.</remarks>
    Public ReadOnly Property Name() As String
        Get
            Return mCriteria.Name
        End Get
    End Property

#End Region
  
#Region "DB CRUD"
    ''' <summary>
    ''' Gets an instance of an existing business rule
    ''' </summary>
    ''' <param name="businessRuleId"></param>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function [Get](ByVal businessRuleId As Integer, ByVal survey As Survey) As BusinessRule
        Return DataProvider.BusinessRuleProvider.Instance.SelectBusinessRule(businessRuleId, survey)
    End Function

    ''' <summary>
    ''' Gets all business rules for a survey
    ''' </summary>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetBySurvey(ByVal survey As Survey) As Collection(Of BusinessRule)
        Return DataProvider.BusinessRuleProvider.Instance.SelectBusinessRulesBySurvey(survey)
    End Function
#End Region

    ''' <summary>
    ''' Gets a list of all changes that have been made to the object since it was loaded or created.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend Function GetChanges() As List(Of AuditLogChange)
        Dim changes As New List(Of AuditLogChange)
        If NeedsDeleted AndAlso Me.Id <> 0 Then
            changes.AddRange(AuditLog.CompareObjects(Of BusinessRule)(Me, Nothing, "Id", AuditLogObject.BusinessRule))
        ElseIf Me.Id = 0 Then
            changes.AddRange(AuditLog.CompareObjects(Of BusinessRule)(Nothing, Me, "Id", AuditLogObject.BusinessRule))
        ElseIf IsDirty Then
            Dim original As BusinessRule = BusinessRule.Get(Me.Id, Me.Survey)
            changes.AddRange(AuditLog.CompareObjects(Of BusinessRule)(original, Me, "Id", AuditLogObject.BusinessRule))
        End If
        changes.AddRange(Me.Criteria.GetChanges())
        Return changes
    End Function

    ''' <summary>
    ''' Resets the is Dirty Flag to false.
    ''' </summary>
    ''' <remarks>This method should be called after saving changes.</remarks>
    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub
End Class
