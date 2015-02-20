Imports Nrc.Framework.BusinessLogic
Imports Nrc.QualiSys.Library.DataProvider

Public Interface ISampleUnitSectionMapping
    Property Id() As Integer
End Interface

<Serializable()> _
Public Class SampleUnitSectionMapping
    Inherits BusinessBase(Of SampleUnitSectionMapping)
    Implements ISampleUnitSectionMapping

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mSampleUnitId As Integer
    Private mSectionId As Integer
    Private mSurveyId As Integer
#End Region

#Region " Public Properties "
    <Logable()> _
    Public Property Id() As Integer Implements ISampleUnitSectionMapping.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property

    <Logable()> _
    Public Property SampleUnitId() As Integer
        Get
            Return mSampleUnitId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSampleUnitId Then
                mSampleUnitId = value
                PropertyHasChanged("SampleUnitId")
            End If
        End Set
    End Property

    <Logable()> _
    Public Property QuestionSectionId() As Integer
        Get
            Return mSectionId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSectionId Then
                mSectionId = value
                PropertyHasChanged("SectionId")
            End If
        End Set
    End Property

    <Logable()> _
    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyId Then
                mSurveyId = value
                PropertyHasChanged("SurveyId")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewSampleUnitSectionMapping() As SampleUnitSectionMapping
        Dim obj As New SampleUnitSectionMapping
        obj.CreateNew()
        Return obj
    End Function

    Public Shared Function NewSampleUnitSectionMapping(ByVal surveyId As Integer, ByVal sampleUnitId As Integer, ByVal sectionId As Integer) As SampleUnitSectionMapping
        Dim obj As New SampleUnitSectionMapping
        obj.QuestionSectionId = sectionId
        obj.SurveyId = surveyId
        obj.SampleUnitId = sampleUnitId
        obj.CreateNew()
        Return obj
    End Function

    Public Shared Function GetBySampleUnitId(ByVal sampleUnitId As Integer) As SampleUnitSectionMappingCollection
        Return SampleUnitSectionMappingProvider.Instance.SelectSampleUnitSectionMappingsBySampleUnitId(SampleUnitId)
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mId
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Public Overrides Sub Delete()
        If Me.IsChild Then
            Me.Parent.RemoveChild(Me)
        Else
            MyBase.Delete()
        End If
    End Sub

    Protected Overrides Sub Insert()
        Id = SampleUnitSectionMappingProvider.Instance.InsertSampleUnitSectionMapping(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        SampleUnitSectionMappingProvider.Instance.DeleteSampleUnitSectionMapping(mId)
    End Sub

#End Region

#Region " Public Methods "
#End Region

End Class

