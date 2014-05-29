<DebuggerDisplay("{Name} ({Id})")> _
Public Class MedicareExport

#Region " Private Fields "

    Private mMedicareNumber As String = String.Empty
    Private mMedicareName As String = String.Empty
    Private mClientGroupName As String = String.Empty
    Private mFacilityName As String = String.Empty
    Private mClientName As String = String.Empty
    Private mStudyName As String = String.Empty
    Private mSurveyName As String = String.Empty
    Private mClientGroupId As Nullable(Of Integer)
    Private mClientId As Integer
    Private mStudyId As Integer
    Private mSurveyId As Integer
    Private mAccountDirector As String = String.Empty
    Private mSurveyTypeId As Integer
    Private mSampleUnitId As Integer
    Private mParentSampleUnitId As Nullable(Of Integer)
    Private mSampleUnitName As String = String.Empty
    Private mIsHcahps As Boolean
    Private mIsHHcahps As Boolean
    Private mIsACOcahps As Boolean
    Private mIsCHART As Boolean
    Private mIsMNCM As Boolean
    Private mIsSelected As Boolean

#End Region

#Region " Public Properties "

    Public Property MedicareNumber() As String
        Get
            Return mMedicareNumber
        End Get
        Set(ByVal value As String)
            If mMedicareNumber <> value Then
                mMedicareNumber = value
            End If
        End Set
    End Property

    Public Property MedicareName() As String
        Get
            Return mMedicareName
        End Get
        Set(ByVal value As String)
            If mMedicareName <> value Then
                mMedicareName = value
            End If
        End Set
    End Property

    Public Property ClientGroupName() As String
        Get
            Return mClientGroupName
        End Get
        Set(ByVal value As String)
            If mClientGroupName <> value Then
                mClientGroupName = value
            End If
        End Set
    End Property

    Public Property FacilityName() As String
        Get
            Return mFacilityName
        End Get
        Set(ByVal value As String)
            If mFacilityName <> value Then
                mFacilityName = value
            End If
        End Set
    End Property

    Public Property ClientName() As String
        Get
            Return mClientName
        End Get
        Set(ByVal value As String)
            If mClientName <> value Then
                mClientName = value
            End If
        End Set
    End Property

    Public Property StudyName() As String
        Get
            Return mStudyName
        End Get
        Set(ByVal value As String)
            If mStudyName <> value Then
                mStudyName = value
            End If
        End Set
    End Property

    Public Property SurveyName() As String
        Get
            Return mSurveyName
        End Get
        Set(ByVal value As String)
            If mSurveyName <> value Then
                mSurveyName = value
            End If
        End Set
    End Property

    Public Property ClientGroupId() As Nullable(Of Integer)
        Get
            Return mClientGroupId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mClientGroupId = value
        End Set
    End Property

    Public Property ClientId() As Integer
        Get
            Return mClientId
        End Get
        Set(ByVal value As Integer)
            If mClientId <> value Then
                mClientId = value
            End If
        End Set
    End Property

    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Set(ByVal value As Integer)
            If mStudyId <> value Then
                mStudyId = value
            End If
        End Set
    End Property

    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            If mSurveyId <> value Then
                mSurveyId = value
            End If
        End Set
    End Property

    Public Property AccountDirector() As String
        Get
            Return mAccountDirector
        End Get
        Set(ByVal value As String)
            If mAccountDirector <> value Then
                mAccountDirector = value
            End If
        End Set
    End Property

    Public Property SurveyTypeId() As Integer
        Get
            Return mSurveyTypeId
        End Get
        Set(ByVal value As Integer)
            If mSurveyTypeId <> value Then
                mSurveyTypeId = value
            End If
        End Set
    End Property

    Public Property SampleUnitId() As Integer
        Get
            Return mSampleUnitId
        End Get
        Set(ByVal value As Integer)
            If mSampleUnitId <> value Then
                mSampleUnitId = value
            End If
        End Set
    End Property

    Public Property ParentSampleUnitId() As Nullable(Of Integer)
        Get
            Return mParentSampleUnitId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mParentSampleUnitId = value
        End Set
    End Property

    Public Property SampleUnitName() As String
        Get
            Return mSampleUnitName
        End Get
        Set(ByVal value As String)
            If mSampleUnitName <> value Then
                mSampleUnitName = value
            End If
        End Set
    End Property

    Public Property IsHcahps() As Boolean
        Get
            Return mIsHcahps
        End Get
        Set(ByVal value As Boolean)
            mIsHcahps = value
        End Set
    End Property

    Public Property IsCHART() As Boolean
        Get
            Return mIsCHART
        End Get
        Set(ByVal value As Boolean)
            mIsCHART = value
        End Set
    End Property

    Public Property IsHHcahps() As Boolean
        Get
            Return mIsHHcahps
        End Get
        Set(ByVal value As Boolean)
            mIsHHcahps = value
        End Set
    End Property

    Public Property IsACOcahps() As Boolean
        Get
            Return mIsACOcahps
        End Get
        Set(ByVal value As Boolean)
            mIsACOcahps = value
        End Set
    End Property

    Public Property IsMNCM() As Boolean
        Get
            Return mIsMNCM
        End Get
        Set(ByVal value As Boolean)
            mIsMNCM = value
        End Set
    End Property

    Public Property Selected() As Boolean
        Get
            Return mIsSelected
        End Get
        Set(ByVal value As Boolean)
            mIsSelected = value
        End Set
    End Property

#End Region

#Region " Public Methods "

#Region " DB CRUD Methods "

    Public Shared Function GetAllByDistinctMedicareNumber(ByVal exportSetType As ExportSetType, ByVal activeOnly As Boolean) As Collection(Of MedicareExport)
        Return DataProvider.Instance.SelectAllByDistinctMedicareNumber(exportSetType, activeOnly)
    End Function

    Public Shared Function GetAllByDistinctSampleUnit(ByVal exportSetType As ExportSetType) As Collection(Of MedicareExport)
        Return DataProvider.Instance.SelectAllByDistinctSampleUnit(exportSetType)
    End Function

    Public Shared Function [Get](ByVal medicareNumber As String) As MedicareExport
        Return DataProvider.Instance.SelectMedicareExport(medicareNumber)
    End Function

#End Region

#End Region


End Class
