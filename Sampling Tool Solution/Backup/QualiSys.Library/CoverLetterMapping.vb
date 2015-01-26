Imports Nrc.Framework.BusinessLogic
Imports Nrc.QualiSys.Library.DataProvider

Public Class CoverLetterMapping
    Inherits BusinessBase(Of CoverLetterMapping)
    Private mSurvey_Id As Integer
    Private mSampleUnit_Id As Integer
    Private mIsDirty As Boolean
    Private mErrorId As CoverLetterMappingStatusCodes


#Region "Public Properties"

    Public Property UniqueID() As Guid

    Public Property Status() As Integer

    <Logable()> _
    Public Property CoverLetterItem_label() As String

    <Logable()> _
    Public Property Id() As Integer

    <Logable()> _
    Public Property Survey_Id As Integer
        Get
            Return mSurvey_Id
        End Get
        Set(value As Integer)
            If mSurvey_Id <> value Then
                mSurvey_Id = value
                mIsDirty = True
            End If


        End Set
    End Property

    <Logable()> _
    Public Property SampleUnit_Id As Integer
        Get
            Return mSampleUnit_Id
        End Get
        Set(value As Integer)
            If mSampleUnit_Id <> value Then
                mSampleUnit_Id = value
                mIsDirty = True
            End If

        End Set
    End Property

    Public Property SampleUnit_name() As String

    Public ReadOnly Property SampleUnitDisplayName As String
        Get
            Return String.Format("{0} ({1})", SampleUnit_name, mSampleUnit_Id)
        End Get
    End Property

    Public Property CoverLetterItemType_Id() As Integer

    <Logable()> _
    Public Property CoverLetter_name() As String

    <Logable()> _
    Public Property Artifact_name() As String

    <Logable()> _
    Public Property ArtifactItem_label() As String

    Public Property NeedsDelete() As Boolean

    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

    Public Property ErrorId() As CoverLetterMappingStatusCodes
        Get
            Return mErrorId
        End Get
        Set(ByVal value As CoverLetterMappingStatusCodes)
            If Not value = mErrorId Then
                mErrorId = value
                PropertyHasChanged("ErrorId")
            End If
        End Set
    End Property

#End Region

#Region "Factory Methods"
    Public Shared Function NewCoverLetterMapping() As CoverLetterMapping
        Dim obj As New CoverLetterMapping
        Return obj
    End Function

    Public Shared Function NewCoverLetterMapping(ByVal fId As Integer, ByVal fSurvey_Id As Integer, ByVal fSampleUnit_Id As Integer, ByVal fSampleUnit_name As String, ByVal fCoverLetterItemType_Id As Integer, ByVal fCoverLetter_name As String, ByVal fCoverLetterItem_label As String, ByVal fArtifact_name As String, ByVal fArtifact_label As String) As CoverLetterMapping
        Dim obj As New CoverLetterMapping() With {.Id = fId, .Survey_Id = fSurvey_Id, .SampleUnit_Id = fSampleUnit_Id, .SampleUnit_name = fSampleUnit_name, .CoverLetterItemType_Id = fCoverLetterItemType_Id, .CoverLetter_name = fCoverLetter_name, .CoverLetterItem_label = fCoverLetterItem_label, .Artifact_name = fArtifact_name, .ArtifactItem_label = fArtifact_label, .UniqueID = Guid.NewGuid}

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

        If NeedsDelete Then
            CoverLetterMappingProvider.Instance.DeleteCoverLetterMapping(Me)
        ElseIf IsNew Then
            Id = CoverLetterMappingProvider.Instance.InsertCoverLetterMapping(Me)
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

        If IsNew = False And NeedsDelete Then
            'Delete
            changes.AddRange(AuditLog.CompareObjects(Of CoverLetterMapping)(Me, Nothing, "Id", AuditLogObject.CoverLetterMapping))
        ElseIf IsNew = False Then
            'Update
            If IsDirty Then
                Dim original As CoverLetterMapping = CoverLetterMapping.Get(Id)
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
    ''' <summary>
    ''' Compares each element of the cover letter for matches.  Returns true if all elements are the same
    ''' </summary>
    ''' <param name="mapping"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function Equals(ByVal mapping As CoverLetterMapping) As Boolean

        Dim result As Boolean = mSurvey_Id = mapping.Survey_Id And mSampleUnit_Id = mapping.SampleUnit_Id And CoverLetterItemType_Id = mapping.CoverLetterItemType_Id _
            And CoverLetter_name = mapping.CoverLetter_name And CoverLetterItem_label = mapping.CoverLetterItem_label _
            And Artifact_name = mapping.Artifact_name And ArtifactItem_label = mapping.ArtifactItem_label

        Return result

    End Function

    ''' <summary>
    ''' Checks whether this cover letter has a match 
    ''' </summary>
    ''' <param name="mapping"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function HasMatchingCoverLetterItems(ByVal mapping As CoverLetterMapping) As Boolean

        Dim result As Boolean = mSurvey_Id = mapping.Survey_Id And mSampleUnit_Id = mapping.SampleUnit_Id And CoverLetterItemType_Id = mapping.CoverLetterItemType_Id _
            And CoverLetter_name = mapping.CoverLetter_name And CoverLetterItem_label = mapping.CoverLetterItem_label

        Return result

    End Function

    Public Function HasMismatchedArtifactItems(ByVal mapping As CoverLetterMapping) As Boolean

        Dim result As Boolean

        Dim artifact1 As String = String.Format("{0}.{1}", Artifact_name, ArtifactItem_label)
        Dim artifact2 As String = String.Format("{0}.{1}", mapping.Artifact_name, mapping.ArtifactItem_label)

        result = CoverLetter_name = mapping.CoverLetter_name And CoverLetterItem_label = mapping.CoverLetterItem_label _
            And artifact1 <> artifact2

        Return result

    End Function

    Public Function HasMatchedArtifactItems(ByVal mapping As CoverLetterMapping) As Boolean

        Dim result As Boolean

        Dim artifact1 As String = String.Format("{0}.{1}", Artifact_name, ArtifactItem_label)
        Dim artifact2 As String = String.Format("{0}.{1}", mapping.Artifact_name, mapping.ArtifactItem_label)

        result = CoverLetter_name = mapping.CoverLetter_name And CoverLetterItem_label = mapping.CoverLetterItem_label _
            And artifact1 = artifact2

        Return result

    End Function
#End Region
End Class
