Imports Nrc.QualiSys.Library.DataProvider

Public Class SampleUnit

#Region " Private Instance Fields "

#Region " Persisted Fields "
    Private mId As Integer
    Private mParentSampleUnitId As Nullable(Of Integer)
    Private mSurveyId As Integer
    Private mName As String
    Private mTarget As Integer
    Private mPriority As Integer
    Private mSelectionType As SampleSelectionType
    Private mIsHCAHPS As Boolean
    Private mIsACOCAHPS As Boolean
    Private mIsHHCAHPS As Boolean
    Private mIsCHART As Boolean
    Private mIsMNCM As Boolean
    Private mIsSuppressed As Boolean
    Private mInitialResponseRate As Integer
    Private mCriteria As Criteria
    Private mService As SampleUnitServiceType
    Private mFacilityId As Integer
    Private mCriteriaStatementId As Nullable(Of Integer)
    Private mSamplePlanId As Integer
    Private mQuestionSections As New SampleUnitSectionMappingCollection
#End Region

    Private mFacility As Facility
    Private mIsDirty As Boolean
    Private mHistoricalResponseRate As Integer
    Private mParentUnit As SampleUnit
    Private mChildUnits As Collection(Of SampleUnit)
    Private mNeedsDelete As Boolean
    Private mUnDeletableReasons As New Collection(Of String)
    Private mCannotAddChildUnitReasons As New Collection(Of String)
    Private mSurvey As Survey
    Private mHasLoadedQuestionSections As Boolean
    Private mPropertiesAreDirty As Boolean
    Private mDontSampleUnit As Boolean

#End Region

#Region " Public Properties "

#Region " Persisted Properties "

    ''' <summary>
    ''' The QualiSys SampleUnit_id
    ''' </summary>
    <Logable()> _
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    ''' <summary>
    ''' ID for the sampleplan
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property SamplePlanId() As Integer
        Get
            Return mSamplePlanId
        End Get
        Set(ByVal value As Integer)
            mSamplePlanId = value
        End Set
    End Property


    ''' <summary>
    ''' The name of the sample unit
    ''' </summary>
    <Logable()> _
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The ID of the survey to which this sample unit belongs
    ''' </summary>
    <Logable()> _
    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            If mSurveyId <> value Then
                mSurveyId = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The ID of the parent sample unit
    ''' </summary>
    <Logable()> _
    Public Property ParentSampleUnitId() As Nullable(Of Integer)
        Get
            Return mParentSampleUnitId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            If value.HasValue AndAlso mParentSampleUnitId.HasValue Then
                If value.Value <> mParentSampleUnitId.Value Then mIsDirty = True
            ElseIf value.HasValue <> mParentSampleUnitId.HasValue Then
                mPropertiesAreDirty = True
            End If
            mParentSampleUnitId = value
        End Set
    End Property

    ''' <summary>
    ''' The targeted response count for this sample unit
    ''' </summary>
    <Logable()> _
    Public Property Target() As Integer
        Get
            Return mTarget
        End Get
        Set(ByVal value As Integer)
            If mTarget <> value Then
                mTarget = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property


    ''' <summary>
    ''' The priority level set for this unit
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property Priority() As Integer
        Get
            Return mPriority
        End Get
        Set(ByVal value As Integer)
            If mPriority <> value Then
                mPriority = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property


    ''' <summary>
    ''' The type of unit
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property SelectionType() As SampleSelectionType
        Get
            Return mSelectionType
        End Get
        Set(ByVal value As SampleSelectionType)
            If mSelectionType <> value Then
                mSelectionType = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property


    ''' <summary>
    ''' This is the initial response rate supplied by the user.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks>The initial response rate is used to determine the amount of outgo needed for new
    ''' surveys.  Older surveys use the historical response rate to determine the amount of outgo needed.
    ''' </remarks>
    <Logable()> _
    Public Property InitialResponseRate() As Integer
        Get
            'Default values for methods other than target since the initial response rate is not used.
            If mSurvey.ActiveSamplePeriod Is Nothing Then Return mInitialResponseRate
            If (mSurvey.ActiveSamplePeriod.SamplingMethod = SampleSet.SamplingMethod.SpecifyOutgo OrElse mSurvey.ActiveSamplePeriod.SamplingMethod = SampleSet.SamplingMethod.Census) Then
                mInitialResponseRate = 100
            End If
            Return mInitialResponseRate
        End Get
        Set(ByVal value As Integer)
            If mInitialResponseRate <> value Then
                mInitialResponseRate = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' This is the historical response rate calculated by the system.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks>The historical response rate is used to determine the amount of outgo needed.
    ''' </remarks>
    <Logable()> _
    Public Property HistoricalResponseRate() As Integer
        Get
            Return mHistoricalResponseRate
        End Get
        Set(ByVal value As Integer)
            mHistoricalResponseRate = value
        End Set
    End Property

    ''' <summary>
    ''' Is this unit supposed to be hidden on our websites
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property IsSuppressed() As Boolean
        Get
            Return mIsSuppressed
        End Get
        Set(ByVal value As Boolean)
            If mIsSuppressed <> value Then
                mIsSuppressed = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Is this an HCAHPS compliant unit
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property IsHcahps() As Boolean
        Get
            Return mIsHCAHPS
        End Get
        Set(ByVal value As Boolean)
            If mIsHCAHPS <> value Then
                mIsHCAHPS = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Is this an HCAHPS compliant unit
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property IsACOcahps() As Boolean
        Get
            Return mIsACOCAHPS
        End Get
        Set(ByVal value As Boolean)
            If mIsACOCAHPS <> value Then
                mIsACOCAHPS = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Is this an Home Health CAHPS compliant unit
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property IsHHcahps() As Boolean
        Get
            Return mIsHHCAHPS
        End Get
        Set(ByVal value As Boolean)
            If mIsHHCAHPS <> value Then
                mIsHHCAHPS = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsCHART() As Boolean
        Get
            Return mIsCHART
        End Get
        Set(ByVal value As Boolean)
            If mIsCHART <> value Then
                mIsCHART = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsMNCM() As Boolean
        Get
            Return mIsMNCM
        End Get
        Set(ByVal value As Boolean)
            If mIsMNCM <> value Then
                mIsMNCM = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property

    Public Property CAHPSType() As CAHPSType
        Get
            If mIsCHART Then
                Return Library.CAHPSType.CHART
            ElseIf mIsHCAHPS Then
                Return Library.CAHPSType.HCAHPS
            ElseIf mIsACOCAHPS Then
                Return Library.CAHPSType.ACOCAHPS
            ElseIf mIsHHCAHPS Then
                Return Library.CAHPSType.HHCAHPS
            ElseIf mIsMNCM Then
                Return Library.CAHPSType.MNCM
            Else
                Return Library.CAHPSType.None
            End If
        End Get
        Set(ByVal value As CAHPSType)
            Select Case value
                Case Library.CAHPSType.CHART
                    mIsHCAHPS = True
                    mIsCHART = True
                    mIsACOCAHPS = False
                    mIsHHCAHPS = False
                    mIsMNCM = False
                Case Library.CAHPSType.HCAHPS
                    mIsHCAHPS = True
                    mIsCHART = False
                    mIsACOCAHPS = False
                    mIsHHCAHPS = False
                    mIsMNCM = False
                Case Library.CAHPSType.ACOCAHPS
                    mIsHCAHPS = False
                    mIsCHART = False
                    mIsACOCAHPS = True
                    mIsHHCAHPS = False
                    mIsMNCM = False
                Case Library.CAHPSType.HHCAHPS
                    mIsHCAHPS = False
                    mIsCHART = False
                    mIsACOCAHPS = False
                    mIsHHCAHPS = True
                    mIsMNCM = False
                Case Library.CAHPSType.MNCM
                    mIsHCAHPS = False
                    mIsCHART = False
                    mIsACOCAHPS = False
                    mIsHHCAHPS = False
                    mIsMNCM = True
                Case Else
                    mIsHCAHPS = False
                    mIsCHART = False
                    mIsACOCAHPS = False
                    mIsHHCAHPS = False
                    mIsMNCM = False
            End Select
        End Set
    End Property

    ''' <summary>
    ''' Are we supposed to sample this unit
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks>Only used in the static plus sampling algorithm</remarks>
    <Logable()> _
    Public Property DontSampleUnit() As Boolean
        Get
            Return mDontSampleUnit
        End Get
        Set(ByVal value As Boolean)
            If mDontSampleUnit <> value Then
                mDontSampleUnit = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Returns the sampleunitservicetype object for this unit.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks>The sampleunitservicetype object contains a hierarchical list of service types for the unit.</remarks>
    Public Property Service() As SampleUnitServiceType
        Get
            Static isLoaded As Boolean = False
            If (Not IsNew AndAlso Not isLoaded AndAlso mService Is Nothing) Then
                mService = SampleUnitServiceType.GetServiceTypeBySampleUnitId(Me.Id)
                isLoaded = True
            End If
            Return mService
        End Get
        Set(ByVal value As SampleUnitServiceType)
            mService = value
            mPropertiesAreDirty = True
        End Set
    End Property

    ''' <summary>
    ''' The ID for the criteria that this unit uses.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property CriteriaStatementId() As Nullable(Of Integer)
        Get
            If mCriteriaStatementId.HasValue Then
                Return mCriteriaStatementId.Value
            End If
            Return Nothing
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mCriteriaStatementId = value
        End Set
    End Property

    Public ReadOnly Property QuestionSections() As SampleUnitSectionMappingCollection
        Get
            'mHasLoadedQuestionSections is used so we don't repeatedly query the
            'database for units that don't have any sections mapped
            'If we lazily populated by checking mQuestionSections to see if it was
            'null, we would repeatedly check it for units that don't have mappings
            If mHasLoadedQuestionSections = False Then
                mQuestionSections = SampleUnitSectionMapping.GetBySampleUnitId(Me.Id)
                mHasLoadedQuestionSections = True
            End If
            Return mQuestionSections
        End Get
    End Property

#End Region

    ''' <summary>
    ''' The survey that this unit is part of.
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
    ''' The facility that this unit belongs to.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Facility() As Facility
        Get
            If mFacility Is Nothing Then
                mFacility = QualiSys.Library.Facility.Get(Me.FacilityId)
            End If
            Return mFacility
        End Get
        Set(ByVal value As Facility)
            mFacility = value
        End Set
    End Property

    ''' <summary>
    ''' The ID of the facility.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <Logable()> _
    Public Property FacilityId() As Integer
        Get
            Return mFacilityId
        End Get
        Set(ByVal value As Integer)
            If (mFacility IsNot Nothing AndAlso _
                mFacility.Id <> value) Then
                mFacility = Nothing
            End If
            If (mFacilityId <> value) Then
                mFacilityId = value
                mPropertiesAreDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The criteria object that this unit uses.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Criteria() As Criteria
        Get
            If mCriteria Is Nothing AndAlso Me.mCriteriaStatementId.HasValue Then
                mCriteria = QualiSys.Library.Criteria.Get(Me.mCriteriaStatementId.Value)
            End If
            Return mCriteria
        End Get
        Set(ByVal value As Criteria)
            mCriteria = value
            If (value IsNot Nothing) AndAlso value.Id.HasValue Then
                mCriteriaStatementId = value.Id.Value
            End If
        End Set
    End Property

    ''' <summary>
    ''' Returns a display label for this survey consisting of the name and ID
    ''' </summary>
    Public ReadOnly Property DisplayLabel() As String
        Get
            Return String.Format("{0} ({1})", mName, mId)
        End Get
    End Property

    ''' <summary>
    ''' The Parent Sample Unit object associated with this sample unit
    ''' </summary>
    Public ReadOnly Property ParentUnit() As SampleUnit
        Get
            Return mParentUnit
        End Get
    End Property

    ''' <summary>
    ''' The Child SampleUnit objects associated with this sample unit
    ''' </summary>
    Public ReadOnly Property ChildUnits() As Collection(Of SampleUnit)
        Get
            Return mChildUnits
        End Get
    End Property

    ''' <summary>
    ''' Indicates whether this is a new unit.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property IsNew() As Boolean
        Get
            Return (Id = 0)
        End Get
    End Property

    ''' <summary>
    ''' Indicates if the unit can be deleted from the database.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property IsDeletable() As Boolean
        Get
            mUnDeletableReasons.Clear()
            If Me.ParentUnit Is Nothing Then
                'root unit is not deletable
                mUnDeletableReasons.Add("The root unit is not deletable")
                Return False
            ElseIf IsNew Then
                'new unit is deletable
                Return True
            Else
                Return SampleUnitProvider.Instance.IsDeletable(Me.Id, mUnDeletableReasons)
            End If
        End Get
    End Property

    ''' <summary>
    ''' This is a collection of messages indicating why a unit cannot be deleted.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property UndeletableReasons() As Collection(Of String)
        Get
            Return mUnDeletableReasons
        End Get
    End Property

    ''' <summary>
    ''' Indicates if a unit needs to be deleted from the database.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property NeedsDelete() As Boolean
        Get
            Return mNeedsDelete
        End Get
    End Property

    ''' <summary>
    ''' Indicates if a unit can have children.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks>Only Exclusive units can have children.</remarks>
    Public ReadOnly Property CanHaveChildUnit() As Boolean
        Get
            If (Me.SelectionType <> SampleSelectionType.NonExclusive AndAlso _
                Me.SelectionType <> SampleSelectionType.MinorModule) Then
                Return True
            Else
                mCannotAddChildUnitReasons.Clear()
                mCannotAddChildUnitReasons.Add("Sample unit of type ""Non-Exclusive"" or ""Minor Module"" can not have child unit.")
                Return False
            End If
        End Get
    End Property

    ''' <summary>
    ''' Collection of messages indicating why a unit cannot have children.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property CannotAddChildUnitReasons() As Collection(Of String)
        Get
            Return mCannotAddChildUnitReasons
        End Get
    End Property


    ''' <summary>
    ''' Indicates if the changes have been made to the object that have not been saved to the database.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property IsDirty() As Boolean
        Get
            If mPropertiesAreDirty Then
                Return True
            ElseIf mHasLoadedQuestionSections = True AndAlso QuestionSections.IsDirty Then
                'If we haven't loaded the question sections, then we know we haven't edited them
                'and we don't need to check the mapped sections IsDirty propert.  Checking the 
                'property is very expensive.
                Return True
            ElseIf Me.mCriteria IsNot Nothing AndAlso Me.mCriteria.IsDirty Then
                'If mCriteria is nothing, then we haven't edited it and it isn't dirty
                Return True
            End If
            Return False
        End Get
    End Property

#End Region

#Region " Constructors "
    ''' <summary>
    ''' Default constructor
    ''' </summary>
    Public Sub New()
        mChildUnits = New Collection(Of SampleUnit)
    End Sub

    ''' <summary>
    ''' Constructor to use if adding a new root unit
    ''' </summary>
    ''' <param name="survey"></param>
    ''' <remarks></remarks>
    Public Sub New(ByVal survey As Survey)
        Me.New()
        If survey Is Nothing Then Throw New Exception("Error creating sampleunit.  Survey is null.")
        mSurvey = survey
        mSurveyId = survey.Id
    End Sub

    ''' <summary>
    ''' Constructor to use if adding a new unit other than the root
    ''' </summary>
    ''' <param name="parentUnit"></param>
    ''' <remarks></remarks>
    Public Sub New(ByVal parentUnit As SampleUnit)
        Me.New()
        If parentUnit Is Nothing Then
            Throw New ArgumentNullException("parentUnit")
        End If
        mParentUnit = parentUnit
        mSurvey = parentUnit.Survey
        mSurveyId = parentUnit.SurveyId
        mSamplePlanId = parentUnit.SamplePlanId
    End Sub

    ''' <summary>
    ''' Constructor to initialize the private instance data for this object
    ''' </summary>
    Public Sub New(ByVal survey As Survey, ByVal parentUnit As SampleUnit, ByVal childUnits As Collection(Of SampleUnit))
        Me.New()
        mParentUnit = parentUnit
        mSurvey = survey
        mSurveyId = survey.Id
        If (childUnits IsNot Nothing) Then mChildUnits = childUnits
    End Sub
#End Region

#Region " DB CRUD Methods "
    ''' <summary>
    ''' Returns a collection of all units belonging to a survey.
    ''' </summary>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetSampleUnitsBySurveyId(ByVal survey As Survey) As Collection(Of SampleUnit)
        Return SampleUnitProvider.Instance.SelectBySurvey(survey)
    End Function

    ''' <summary>
    ''' Returns all sample units for a survey without parent/child relationship
    ''' </summary>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetAllSampleUnitsForSurvey(ByVal survey As Survey) As Collection(Of SampleUnit)
        Return SampleUnitProvider.Instance.SelectAllForSurvey(survey)
    End Function

    ''' <summary>
    ''' Returns an instance of a specific unit.
    ''' </summary>
    ''' <param name="sampleUnitId"></param>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function [Get](ByVal sampleUnitId As Integer, ByVal survey As Survey) As SampleUnit
        Return SampleUnitProvider.Instance.[Select](sampleUnitId, survey)
    End Function

    ''' <summary>
    ''' Returns all child units belonging to a parent.
    ''' </summary>
    ''' <param name="parentSampleUnitId"></param>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetSampleUnitsByParentId(ByVal parentSampleUnitId As Integer, ByVal survey As Survey) As Collection(Of SampleUnit)
        Return SampleUnitProvider.Instance.SelectByParentId(parentSampleUnitId, survey)
    End Function

    ''' <summary>
    ''' This method will traverse the tree of units and take appropriate action on each unit.  The action 
    ''' will be an insert, update, delete, or nothing.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub Update(ByVal qualisysEmployeeId As Integer)
        If Me.ParentSampleUnitId.HasValue Then Throw New Exception("Only root units should be used aa parameters for the update method of the sampleunit class.")
        Dim changes As List(Of AuditLogChange) = GetEntireTreeChanges(Me)
        SampleUnitProvider.Instance.Update(Me, qualisysEmployeeId)
        RemoveDeletedChildren(Me)
        AuditLog.LogChanges(changes)
    End Sub

    ''' <summary>
    ''' This method will recursively remove deleted units from their parent's child unit collection
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub RemoveDeletedChildren(ByVal unit As SampleUnit)
        Dim i As Integer
        For i = (unit.ChildUnits.Count - 1) To 0 Step -1
            Dim child As SampleUnit = unit.ChildUnits(i)
            If child.NeedsDelete = True Then
                unit.ChildUnits.Remove(child)
            End If
            If child.ChildUnits.Count > 0 Then RemoveDeletedChildren(child)
        Next
    End Sub

    ''' <summary>
    ''' Recursively loops through child units and gets changes for each unit
    ''' </summary>
    ''' <param name="unit"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetEntireTreeChanges(ByVal unit As SampleUnit) As List(Of AuditLogChange)
        Dim changes As New List(Of AuditLogChange)
        changes.AddRange(unit.GetChanges())
        For Each child As SampleUnit In unit.ChildUnits
            changes.AddRange(GetEntireTreeChanges(child))
        Next

        Return changes
    End Function

    ''' <summary>
    ''' Gets a list of all changes that have been made to the object since it was loaded or created.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend Function GetChanges() As List(Of AuditLogChange)
        Dim changes As New List(Of AuditLogChange)

        If Me.IsNew = False And Me.NeedsDelete Then
            'Delete
            changes.AddRange(AuditLog.CompareObjects(Of SampleUnit)(Me, Nothing, "Id", AuditLogObject.SampleUnit))
        ElseIf Me.IsNew = False Then
            'Update
            If IsDirty Then
                Dim original As SampleUnit = SampleUnit.Get(Me.Id, Me.Survey)
                changes.AddRange(AuditLog.CompareObjects(Of SampleUnit)(original, Me, "Id", AuditLogObject.SampleUnit))
                If Me.Service IsNot Nothing Then GetServiceTypeChanges(changes, original)
            End If
        Else
            'New
            changes.AddRange(AuditLog.CompareObjects(Of SampleUnit)(Nothing, Me, "Id", AuditLogObject.SampleUnit))
        End If

        If Me.Criteria IsNot Nothing Then
            changes.AddRange(Me.Criteria.GetChanges)
        End If

        If Me.mHasLoadedQuestionSections AndAlso Me.QuestionSections.IsDirty Then
            changes.AddRange(Me.QuestionSections.GetChanges)
        End If

        Return changes
    End Function

    ''' <summary>
    ''' Gets all changes for the service types assigned to this unit.
    ''' </summary>
    ''' <param name="changes"></param>
    ''' <param name="original"></param>
    ''' <remarks></remarks>
    Private Sub GetServiceTypeChanges(ByVal changes As List(Of AuditLogChange), ByVal original As SampleUnit)
        Dim stAdds As New Collection(Of SampleUnitServiceType)
        Dim stDeletes As New Collection(Of SampleUnitServiceType)


        'Check to see if the parent is different.  If it is, then everything should be deleted and readded.
        If original.Service IsNot Nothing AndAlso Me.Service.Id <> original.Service.Id Then
            'Remove Old Parent
            changes.Add(New AuditLogChange(Me, "Id", "SampleUnitServiceType", AuditLogChangeType.Delete, original.Service.Id.ToString, Nothing, AuditLogObject.SampleUnit))
            'Remove all old children
            For Each child As SampleUnitServiceType In original.Service.ChildServices
                changes.Add(New AuditLogChange(Me, "Id", "SampleUnitServiceType", AuditLogChangeType.Delete, child.Id.ToString, Nothing, AuditLogObject.SampleUnit))
            Next
        End If

        'Make sure we have an instance of the original object, or this code will explode
        If original.Service Is Nothing Then original.Service = New SampleUnitServiceType()
        If Me.Service.Id <> original.Service.Id Then
            'Add New Parent
            changes.Add(New AuditLogChange(Me, "Id", "SampleUnitServiceType", AuditLogChangeType.Add, Nothing, Me.Service.Id.ToString, AuditLogObject.SampleUnit))
            'Add all New Children
            For Each child As SampleUnitServiceType In Me.Service.ChildServices
                changes.Add(New AuditLogChange(Me, "Id", "SampleUnitServiceType", AuditLogChangeType.Add, Nothing, child.Id.ToString, AuditLogObject.SampleUnit))
            Next
            Return
        End If

        'Check for New types
        'First add the new types to the stAdds collection.  If we find that types in the 
        'Original list, we then remove the types from the stAdds collection.
        For Each stNew As SampleUnitServiceType In Me.Service.ChildServices
            stAdds.Add(stNew)
            For Each stOrig As SampleUnitServiceType In original.Service.ChildServices
                If stNew.Id = stOrig.Id Then
                    stAdds.RemoveAt(stAdds.Count - 1)
                    Exit For
                End If
            Next
        Next

        'Check for Deleted types
        'First add the new types to the stDeletes collection.  If we find that types in the 
        'New list, we then remove the types from the stDeletes collection.
        For Each stOrig As SampleUnitServiceType In original.Service.ChildServices
            stDeletes.Add(stOrig)
            For Each stnew As SampleUnitServiceType In Me.Service.ChildServices
                If stnew.Id = stOrig.Id Then
                    stDeletes.RemoveAt(stDeletes.Count - 1)
                    Exit For
                End If
            Next
        Next

        For Each st As SampleUnitServiceType In stAdds
            changes.Add(New AuditLogChange(Me, "Id", "ServiceType", AuditLogChangeType.Add, Nothing, st.Id.ToString, AuditLogObject.SampleUnit))
        Next

        For Each st As SampleUnitServiceType In stDeletes
            changes.Add(New AuditLogChange(Me, "Id", "ServiceType", AuditLogChangeType.Delete, st.Id.ToString, Nothing, AuditLogObject.SampleUnit))
        Next
    End Sub
#End Region

#Region " Public Methods "
    ''' <summary>
    ''' Sets the needsDeleted flag on a unit and all of its children.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub Delete()
        If (Not IsDeletable) Then
            Throw New ArgumentException("This sample unit is not deletable")
        End If
        mNeedsDelete = True
        For Each unit As SampleUnit In Me.ChildUnits
            unit.Delete()
        Next
    End Sub

    ''' <summary>
    ''' Resets the is Dirty Flag to false.
    ''' </summary>
    ''' <remarks>This method should be called after saving changes.</remarks>
    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub

    ''' <summary>
    ''' Reorders the priority, removing any gaps in priority numbering
    ''' </summary>
    ''' <param name="units"></param>
    ''' <remarks></remarks>
    Public Shared Sub ReorderPriority(ByVal units As Collection(Of SampleUnit))
        If (units Is Nothing) Then Return

        'Get all distinct priorities into a sorted dictionary
        Dim list As New SortedDictionary(Of Integer, Integer)
        FillPriorityList(units, list)

        'Reorder priorities
        Dim lookupTable As New SortedDictionary(Of Integer, Integer)
        Dim priority As Integer = 1
        For Each de As KeyValuePair(Of Integer, Integer) In list
            lookupTable.Add(de.Key, priority)
            priority += 1
        Next

        'Reset priority for unit
        ReprioritizeUnit(units, lookupTable)
    End Sub

#End Region

#Region " Private Methods "
    ''' <summary>
    ''' Fills the priority list.
    ''' </summary>
    ''' <param name="units"></param>
    ''' <param name="list"></param>
    ''' <remarks></remarks>
    Private Shared Sub FillPriorityList(ByVal units As Collection(Of SampleUnit), ByVal list As SortedDictionary(Of Integer, Integer))
        If (units Is Nothing) Then Return
        For Each unit As SampleUnit In units
            If (unit.NeedsDelete) Then Continue For
            If (Not list.ContainsKey(unit.Priority)) Then
                list.Add(unit.Priority, 0)
            End If
            FillPriorityList(unit.ChildUnits, list)
        Next
    End Sub

    ''' <summary>
    ''' Reprioritizes the units.
    ''' </summary>
    ''' <param name="units"></param>
    ''' <param name="lookupTable"></param>
    ''' <remarks></remarks>
    Private Shared Sub ReprioritizeUnit(ByVal units As Collection(Of SampleUnit), ByVal lookupTable As SortedDictionary(Of Integer, Integer))
        If (units Is Nothing) Then Return
        For Each unit As SampleUnit In units
            If (unit.NeedsDelete) Then Continue For
            unit.Priority = lookupTable(unit.Priority)
            ReprioritizeUnit(unit.ChildUnits, lookupTable)
        Next
    End Sub


#End Region
End Class
