Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic


Public Interface IFacility
    Property Id() As Integer
End Interface

<Serializable()> _
Public Class Facility
    Inherits Nrc.Framework.BusinessLogic.BusinessBase(Of Facility)
    Implements IFacility

    Public Enum ClassificationStatus
        Unknown = 0
        Yes = 1
        No = 2
    End Enum

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mName As String = String.Empty
    Private mCity As String = String.Empty
    Private mState As String = String.Empty
    Private mCountry As String = String.Empty
    Private mAdmitNumber As Nullable(Of Integer)
    Private mBedSize As Nullable(Of Integer)
    Private mIsPediatric As ClassificationStatus
    Private mIsTeaching As ClassificationStatus
    Private mIsTrauma As ClassificationStatus
    Private mIsReligious As ClassificationStatus
    Private mIsGovernment As ClassificationStatus
    Private mIsRural As ClassificationStatus
    Private mIsForProfit As ClassificationStatus
    Private mIsRehab As ClassificationStatus
    Private mIsCancerCenter As ClassificationStatus
    Private mIsPicker As ClassificationStatus
    Private mIsFreeStanding As ClassificationStatus
    Private mAhaId As Nullable(Of Integer)
    Private mMedicareNumber As MedicareNumber
    Private mIsHcahpsAssigned As Boolean
    Dim mRegionId As Integer
#End Region

#Region " Public Properties "
    <Logable()> _
    Public Property Id() As Integer Implements IFacility.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If mId <> value Then
                mId = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property Name() As String
        Get
            Return (mName)
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property City() As String
        Get
            Return mCity
        End Get
        Set(ByVal value As String)
            If mCity <> value Then
                mCity = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public Property State() As String
        Get
            Return mState
        End Get
        Set(ByVal value As String)
            If mState <> value Then
                mState = value
                Select Case State
                    Case "AS", "GU", "MH", "PR", "VI"
                        'Associated Areas
                        mRegionId = 6
                    Case "IL", "IN", "MI", "OH", "WI"
                        'East North Central
                        mRegionId = 7
                    Case "AL", "KY", "MS", "TN"
                        'East South Central
                        mRegionId = 3
                    Case "NJ", "NY", "PA"
                        'Mid Atlantic
                        mRegionId = 10
                    Case "AZ", "CO", "ID", "MT", "NM", "NV", "UT", "WY"
                        'Mountain
                        mRegionId = 1
                    Case "CT", "MA", "ME", "NH", "RI", "VT"
                        'New England
                        mRegionId = 9
                    Case "AK", "CA", "HI", "OR", "WA"
                        'Pacific
                        mRegionId = 2
                    Case "DC", "DE", "FL", "GA", "MD", "NC", "SC", "VA", "WV"
                        'South Atlantic
                        mRegionId = 4
                    Case "IA", "KS", "MN", "MO", "ND", "NE", "SD"
                        'West North Central
                        mRegionId = 8
                    Case "AR", "LA", "OK", "TX"
                        'West South Central
                        mRegionId = 5
                    Case "NA"
                        mRegionId = Nothing
                End Select
                PropertyHasChanged()
                PropertyHasChanged("RegionId")
            End If
        End Set
    End Property

    <Logable()> _
    Public Property Country() As String
        Get
            Return mCountry
        End Get
        Set(ByVal value As String)
            If mCountry <> value Then
                mCountry = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    <Logable()> _
    Public ReadOnly Property RegionId() As Integer
        Get
            Return mRegionId
        End Get
        
    End Property

    <Logable()> _
    Public Property AdmitNumber() As Nullable(Of Integer)
        Get
            Return mAdmitNumber
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mAdmitNumber = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property BedSize() As Nullable(Of Integer)
        Get
            Return mBedSize
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mBedSize = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property IsPediatric() As ClassificationStatus
        Get
            Return mIsPediatric
        End Get
        Set(ByVal value As ClassificationStatus)
            mIsPediatric = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property IsTeaching() As ClassificationStatus
        Get
            Return mIsTeaching
        End Get
        Set(ByVal value As ClassificationStatus)
            mIsTeaching = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property IsTrauma() As ClassificationStatus
        Get
            Return mIsTrauma
        End Get
        Set(ByVal value As ClassificationStatus)
            mIsTrauma = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property IsReligious() As ClassificationStatus
        Get
            Return mIsReligious
        End Get
        Set(ByVal value As ClassificationStatus)
            mIsReligious = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property IsGovernment() As ClassificationStatus
        Get
            Return mIsGovernment
        End Get
        Set(ByVal value As ClassificationStatus)
            mIsGovernment = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property IsRural() As ClassificationStatus
        Get
            Return mIsRural
        End Get
        Set(ByVal value As ClassificationStatus)
            mIsRural = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property IsForProfit() As ClassificationStatus
        Get
            Return mIsForProfit
        End Get
        Set(ByVal value As ClassificationStatus)
            mIsForProfit = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property IsRehab() As ClassificationStatus
        Get
            Return mIsRehab
        End Get
        Set(ByVal value As ClassificationStatus)
            mIsRehab = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property IsCancerCenter() As ClassificationStatus
        Get
            Return mIsCancerCenter
        End Get
        Set(ByVal value As ClassificationStatus)
            mIsCancerCenter = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
     Public Property IsPicker() As ClassificationStatus
        Get
            Return mIsPicker
        End Get
        Set(ByVal value As ClassificationStatus)
            mIsPicker = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property IsFreeStanding() As ClassificationStatus
        Get
            Return mIsFreeStanding
        End Get
        Set(ByVal value As ClassificationStatus)
            mIsFreeStanding = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property AhaId() As Nullable(Of Integer)
        Get
            Return mAhaId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mAhaId = value
            PropertyHasChanged()
        End Set
    End Property

    <Logable()> _
    Public Property MedicareNumber() As MedicareNumber
        Get
            Return mMedicareNumber
        End Get
        Set(ByVal value As MedicareNumber)
            If mMedicareNumber <> value Then
                mMedicareNumber = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    Public Property IsHcahpsAssigned() As Boolean
        Get
            Return mIsHcahpsAssigned
        End Get
        Set(ByVal value As Boolean)
            mIsHcahpsAssigned = value
        End Set
    End Property

    Public ReadOnly Property DisplayLabel() As String
        Get
            Return String.Format("{0} ({1})", mName, mId)
        End Get
    End Property
#End Region

#Region "Overrides"
    Protected Overrides Function GetIdValue() As Object
        If IsNew Then
            Return mInstanceGuid
        Else
            Return Id
        End If
    End Function

    Protected Overrides Sub AddBusinessRules()
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "Name")
        Me.ValidationRules.AddRule(AddressOf ValidateAHANumber, "AhaId")
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "City")
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "State")
        Me.ValidationRules.AddRule(AddressOf ValidateMedicareNumber, "MedicareNumber")
    End Sub
#End Region

#Region "Validation Methods"

    Private Function ValidateAHANumber(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        'Validate
        If Me.AhaId.HasValue Then
            If Me.AhaId.Value <= 0 Then
                'The AHA Number must be greater than 0
                e.Description = "The AHA Number must be greater than 0!"
                Return False
            End If
        End If
        Return True
    End Function

    Private Function ValidateMedicareNumber(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        'Validate
        If Me.IsHcahpsAssigned Then
            If Me.MedicareNumber Is Nothing Then
                'The medicare number cannot be blank
                e.Description = "You must provide a Medicare Number because this facility is assigned to at least one HCAHPS sample unit!"
                Return False
            End If
        End If
        Return True
    End Function

#End Region

#Region " Constructors "
    Private Sub New()
        Me.mCountry = "US"
    End Sub

    Friend Sub New(ByVal id As Integer)
        Me.mId = id
        Me.mCountry = "US"
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewFacility() As Facility
        Dim obj As New Facility
        obj.CreateNew()
        Return obj
    End Function
#End Region

#Region "Public Methods"

    Public Sub AssignToClient(ByVal clientId As Integer)
        FacilityProvider.Instance.AssignFacilityToClient(mId, clientId)
    End Sub

    Public Sub UnassignFromClient(ByVal clientId As Integer)
        FacilityProvider.Instance.UnassignFacilityFromClient(mId, clientId)
    End Sub

    'A facility can only be deleted if it is not mapped to any units.
    Public Function AllowDelete() As Boolean
        Return FacilityProvider.Instance.AllowDelete(mId)
    End Function

    'A facility can only be unassigned if it is not mapped to any units for the client.
    Public Function AllowUnassignment(ByVal clientId As Integer) As Boolean
        Return FacilityProvider.Instance.AllowUnassignment(mId, clientId)
    End Function

    Public Overrides Function ToString() As String
        Return Me.DisplayLabel
    End Function

#End Region

#Region " DB CRUD Methods "
    Public Shared Function [Get](ByVal facilityId As Integer) As Facility
        Return FacilityProvider.Instance.Select(facilityId)
    End Function

    'Public Shared Function GetAll() As Collection(Of Facility)
    '    Return FacilityProvider.Instance.SelectAll
    'End Function

    'Public Shared Function GetAllBindingListView() As BindingListView(Of Facility)
    '    Return FacilityProvider.Instance.SelectAllBindingListView
    'End Function

    Public Shared Function GetAll() As FacilityList
        Return FacilityProvider.Instance.SelectAll
    End Function

    ''' <summary>
    ''' Returns a list of Facility objects for the given Client 
    ''' </summary>
    ''' <param name="clientId">The Client ID by which to filter the facility list</param>
    Public Shared Function GetByClientId(ByVal clientId As Integer) As FacilityList
        Return FacilityProvider.Instance.SelectByClientId(clientId)
    End Function
    'Public Shared Function GetByClientId(ByVal clientId As Integer) As Collection(Of Facility)
    '    Return FacilityProvider.Instance.SelectByClientId(clientId)
    'End Function

    Public Shared Function GetByAhaId(ByVal ahaId As Integer) As Collection(Of Facility)
        Return FacilityProvider.Instance.SelectByAhaId(ahaId)
    End Function

    'Override base classes delete so we can verify that the facility is deletable.
    Public Overrides Sub Delete()
        If Me.AllowDelete Then
            MyBase.Delete()
        Else
            Throw New FacilityDeletionException("This facility is currently assigned to 1 or more sampleunits and cannot be deleted!")
        End If
    End Sub

    Protected Overrides Sub DeleteImmediate()
        Dim changes As List(Of AuditLogChange) = GetChanges()
        FacilityProvider.Instance.Delete(Me.Id)
        AuditLog.LogChanges(changes)
    End Sub

    Protected Overrides Sub Update()
        Dim changes As List(Of AuditLogChange) = GetChanges()
        FacilityProvider.Instance.Update(Me)
        AuditLog.LogChanges(changes)
    End Sub

    Protected Overrides Sub Insert()
        Dim changes As List(Of AuditLogChange) = GetChanges()
        FacilityProvider.Instance.Insert(Me)
        AuditLog.LogChanges(changes)
    End Sub

    Protected Overrides Sub CreateNew()
        ValidationRules.CheckRules()
    End Sub

#End Region

#Region "Private Methods"
    Private Function GetChanges() As List(Of AuditLogChange)
        Dim changes As New List(Of AuditLogChange)
        If IsDeleted AndAlso IsNew = False Then
            changes.AddRange(AuditLog.CompareObjects(Of Facility)(Me, Nothing, "Id", AuditLogObject.Facility))
        ElseIf Me.IsNew Then
            changes.AddRange(AuditLog.CompareObjects(Of Facility)(Nothing, Me, "Id", AuditLogObject.Facility))
        ElseIf IsDirty Then
            Dim original As Facility = Facility.Get(Me.Id)
            changes.AddRange(AuditLog.CompareObjects(Of Facility)(original, Me, "Id", AuditLogObject.Facility))
        End If
        Return changes
    End Function
#End Region


End Class

