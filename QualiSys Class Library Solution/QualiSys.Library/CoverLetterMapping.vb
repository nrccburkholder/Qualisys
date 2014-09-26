Imports Nrc.Framework.BusinessLogic
Imports Nrc.QualiSys.Library.DataProvider

Public Class CoverLetterMapping
    Inherits BusinessBase(Of CoverLetterMapping)

    Private mId As Integer
    Private mSurvey_Id As Integer
    Private mSampleUnit_Id As Integer
    Private mSampleUnit_name As String
    Private mCoverLetterItemType_Id As Integer
    Private mCoverId As Integer
    Private mCoverLetter_name As String
    Private mCoverLetterItem_Id As Integer
    Private mCoverLetterItem_label As String
    Private mArtifactPage_Id As Integer
    Private mArtifact_Id As Integer
    Private mArtifact_name As String
    Private mArtifact_label As String
    Private mNeedsDelete As Boolean
    Private mStatus As Integer
    Private mUniqueID As Guid


#Region "Public Properties"

    Public Property UniqueID As Guid
        Get
            Return mUniqueID
        End Get
        Set(value As Guid)
            mUniqueID = value
        End Set
    End Property

    Public Property Status As Integer
        Get
            Return mStatus
        End Get
        Set(value As Integer)
            mStatus = value
        End Set
    End Property

    Public Property Artifact_Id As Integer
        Get
            Return mArtifact_Id
        End Get
        Set(value As Integer)
            mArtifact_Id = value
        End Set
    End Property


    Public Property CoverLetterItem_label As String
        Get
            Return mCoverLetterItem_label
        End Get
        Set(value As String)
            mCoverLetterItem_label = value
        End Set
    End Property

    Public Property Id As Integer
        Get
            Return mId
        End Get
        Set(value As Integer)
            mId = value
        End Set
    End Property

    Public Property Survey_Id As Integer
        Get
            Return mSurvey_Id
        End Get
        Set(value As Integer)
            mSurvey_Id = value
        End Set
    End Property

    Public Property SampleUnit_Id As Integer
        Get
            Return mSampleUnit_Id
        End Get
        Set(value As Integer)
            mSampleUnit_Id = value
        End Set
    End Property

    Public Property SampleUnit_name As String
        Get
            Return mSampleUnit_name
        End Get
        Set(value As String)
            mSampleUnit_name = value
        End Set
    End Property

    Public ReadOnly Property SampleUnitDisplayName As String
        Get
            Return String.Format("{0} ({1})", mSampleUnit_name, mSampleUnit_Id)
        End Get
    End Property

    Public Property CoverLetterItemType_Id As Integer
        Get
            Return mCoverLetterItemType_Id
        End Get
        Set(value As Integer)
            mCoverLetterItemType_Id = value
        End Set
    End Property

    Public Property CoverId As Integer
        Get
            Return mCoverId
        End Get
        Set(value As Integer)
            mCoverId = value
        End Set
    End Property

    Public Property CoverLetter_name As String
        Get
            Return mCoverLetter_name
        End Get
        Set(value As String)
            mCoverLetter_name = value
        End Set
    End Property

    Public Property CoverLetterItem_Id As Integer
        Get
            Return mCoverLetterItem_Id
        End Get
        Set(value As Integer)
            mCoverLetterItem_Id = value
        End Set
    End Property

    Public Property Artifact_name As String
        Get
            Return mArtifact_name
        End Get
        Set(value As String)
            mArtifact_name = value
        End Set
    End Property

    Public Property ArtifactPage_Id As Integer
        Get
            Return mArtifactPage_Id
        End Get
        Set(value As Integer)
            mArtifactPage_Id = value
        End Set
    End Property

    Public Property Artifact_label As String
        Get
            Return mArtifact_label
        End Get
        Set(value As String)
            mArtifact_label = value
        End Set
    End Property

    Public Property NeedsDelete() As Boolean
        Get
            Return mNeedsDelete
        End Get
        Set(ByVal value As Boolean)
            mNeedsDelete = value
        End Set
    End Property
#End Region

#Region "Constructors"

    Public Sub New()

    End Sub
#End Region

#Region "Factory Methods"
    Public Shared Function NewCoverLetterMapping() As CoverLetterMapping
        Dim obj As New CoverLetterMapping
        Return obj
    End Function

    Public Shared Function NewCoverLetterMapping(ByVal fId As Integer, ByVal fSurvey_Id As Integer, ByVal fSampleUnit_Id As Integer, ByVal fSampleUnit_name As String, ByVal fCoverLetterItemType_Id As Integer, ByVal fCoverId As Integer, ByVal fCoverLetter_name As String, ByVal fCoverLetterItem_Id As Integer, ByVal fCoverLetterItem_label As String, ByVal fArtifactPage_Id As Integer, ByVal fArtifact_name As String, ByVal fArtifact_Id As Integer, ByVal fArtifact_label As String) As CoverLetterMapping
        Dim obj As New CoverLetterMapping

        'obj.Id = fId
        'obj.Survey_Id = fSurvey_Id
        'obj.SampleUnit_Id = fSampleUnit_Id
        'obj.SampleUnit_name = fSampleUnit_name
        'obj.CoverLetterItemType_Id = fCoverLetterItemType_Id(1 = TextBox, 2 = Graphic)
        'obj.CoverId = fCoverId(SEL_Cover.CoverID)
        'obj.CoverLetter_name = fCoverLetter_name(SEL_Cover.Description)
        'obj.CoverLetterItem_Id = fCoverLetterItem_Id(SEL_TextBox.QPC_ID)
        'obj.CoverLetterItem_label = fCoverLetterItem_label(SEL_TextBox.Label)
        'obj.ArtifactPage_Id = fArtifactPage_Id(SEL_Cover.CoverID)
        'obj.Artifact_name = fArtifact_name(SEL_Cover.Description)
        'obj.Artifact_Id = fArtifact_Id(SEL_TextBox.QPC_ID)
        'obj.Artifact_label = fArtifact_label(SEL_TextBox.Label)

        obj.Id = fId
        obj.Survey_Id = fSurvey_Id
        obj.SampleUnit_Id = fSampleUnit_Id
        obj.SampleUnit_name = fSampleUnit_name
        obj.CoverLetterItemType_Id = fCoverLetterItemType_Id
        obj.CoverId = fCoverId
        obj.CoverLetter_name = fCoverLetter_name
        obj.CoverLetterItem_Id = fCoverLetterItem_Id
        obj.CoverLetterItem_label = fCoverLetterItem_label
        obj.ArtifactPage_Id = fArtifactPage_Id
        obj.Artifact_name = fArtifact_name
        obj.Artifact_Id = fArtifact_Id
        obj.Artifact_label = fArtifact_label
        obj.UniqueID = Guid.NewGuid

        Return obj
    End Function

    Public Shared Function GetCoverLetterMappingsBySurveyId(ByVal SurveyId As Integer) As List(Of CoverLetterMapping) 'Collection
        Return CoverLetterMappingProvider.Instance.SelectCoverLetterMappingsBySurveyId(SurveyId)
    End Function
#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object
        Return 0
    End Function

#End Region

#Region "CRUD"
    Public Shared Function [Get](ByVal Id As Integer) As CoverLetterMapping
        Return CoverLetterMappingProvider.Instance.[Select](Id)
    End Function

    ''' <summary>
    ''' This method will traverse the Mapping Grid and take appropriate action on each unit.  The action 
    ''' will be an insert, update, delete, or nothing.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub UpdateObj()

        If Me.NeedsDelete Then
            CoverLetterMappingProvider.Instance.DeleteCoverLetterMapping(Me)
        ElseIf Me.IsNew Then
            Me.Id = CoverLetterMappingProvider.Instance.InsertCoverLetterMapping(Me)
        Else
            CoverLetterMappingProvider.Instance.UpdateCoverLetterMapping(Me)
        End If

        Dim changes As List(Of AuditLogChange) = GetChanges()
        AuditLog.LogChanges(changes)

    End Sub



    ''' <summary>
    ''' Gets a list of all changes that have been made to the object since it was loaded or created.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend Function GetChanges() As List(Of AuditLogChange)
        Dim changes As New List(Of AuditLogChange)

        If Me.IsNew = False And Me.NeedsDelete Then
            'Delete
            changes.AddRange(AuditLog.CompareObjects(Of CoverLetterMapping)(Me, Nothing, "Id", AuditLogObject.CoverLetterMapping))
        ElseIf Me.IsNew = False Then
            'Update
            If IsDirty Then
                Dim original As CoverLetterMapping = CoverLetterMapping.Get(Me.Id)
                changes.AddRange(AuditLog.CompareObjects(Of CoverLetterMapping)(original, Me, "Id", AuditLogObject.CoverLetterMapping))
            End If
        Else
            'New
            changes.AddRange(AuditLog.CompareObjects(Of CoverLetterMapping)(Nothing, Me, "Id", AuditLogObject.CoverLetterMapping))
        End If


        Return changes
    End Function
#End Region

#Region "Public Methods"
    Public Function Equals(ByVal mapping As CoverLetterMapping) As Boolean

        Dim result As Boolean

        result = mSurvey_Id = mapping.Survey_Id And mSampleUnit_Id = mapping.SampleUnit_Id And mCoverLetterItemType_Id = mapping.CoverLetterItemType_Id And _
            mCoverLetter_name = mapping.CoverLetter_name And mCoverLetterItem_label = mapping.CoverLetterItem_label And _
            mArtifact_name = mapping.Artifact_name And mArtifact_label = mapping.Artifact_label

        Return result

    End Function
#End Region
End Class
