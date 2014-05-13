''' <summary>Represents a DataMart survey</summary>
<DebuggerDisplay("{Name} ({Id})")> _
Public Class Survey

#Region " Private Instance Fields "

#Region " Persisted Fields "
    Private mId As Integer
    Private mName As String
    Private mDescription As String
    Private mStudyId As Integer
#End Region

    Private mIsDirty As Boolean
    Private mStudy As Study
    Private mQuestions As Collection(Of Question)
#End Region

#Region " Public Properties "

#Region " Persisted Properties "
    ''' <summary>
    ''' The ID of the survey in the data store
    ''' </summary>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            If mId <> value Then
                mId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The name of the survey
    ''' </summary>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The description of the survey
    ''' </summary>
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            mDescription = value
        End Set
    End Property


    ''' <summary>
    ''' The ID of the study to which the survey belongs
    ''' </summary>
    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Set(ByVal value As Integer)
            If mStudyId <> value Then
                mStudyId = value
                mIsDirty = True
            End If
        End Set
    End Property
#End Region

    ''' <summary>
    ''' Returns a display label for this survey consisting of the name and ID
    ''' </summary>
    Public ReadOnly Property DisplayLabel() As String
        Get
            Return String.Format("{0} ({1})", mName, mId)
        End Get
    End Property

    ''' <summary>
    ''' The Study object to which this survey belongs
    ''' </summary>
    Public ReadOnly Property Study() As Study
        Get
            If mStudy Is Nothing Then
                mStudy = Nrc.DataMart.Library.Study.GetStudy(mStudyId)
            End If

            Return mStudy
        End Get
    End Property

    ''' <summary>
    ''' The collection of Questions that are used on this survey
    ''' </summary>
    Public ReadOnly Property Questions() As Collection(Of Question)
        Get
            If mQuestions Is Nothing Then
                mQuestions = Nrc.DataMart.Library.Question.GetQuestionsbySurveyId(Me.mId)
            End If

            Return mQuestions
        End Get
    End Property

    ''' <summary>
    ''' Returns true if the object has been modified since it was retrieved from the data store.
    ''' </summary>
    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return Me.mIsDirty
        End Get
    End Property
#End Region

#Region " Constructors "
    ''' <summary>Initializes an instance of the Survey class</summary>
    Public Sub New()
    End Sub

    ''' <summary>Initializes an instance of the Survey class and sets the sets the parent study instance
    ''' </summary>
    ''' <param name="parentStudy">The study object to which this survey belongs</param>
    Public Sub New(ByVal parentStudy As Study)
        Me.New()
        Me.mStudy = parentStudy
    End Sub
#End Region

#Region " DB CRUD Methods "
    ''' <summary>
    ''' Retrieves and populates a survey object from the data store
    ''' </summary>
    ''' <param name="surveyId">The ID of the survey to retreive</param>
    Public Shared Function GetSurvey(ByVal surveyId As Integer) As Survey
        Return DataProvider.Instance.SelectSurvey(surveyId)
    End Function

    Public Shared Function GetSurveysByStudyId(ByVal studyId As Integer) As Collection(Of Survey)
        Return DataProvider.Instance.SelectSurveysByStudyId(studyId)
    End Function
#End Region

    ''' <summary>Marks the object as being up-to-date with the data store</summary>
    Public Sub ResetDirtyFlag()
        Me.mIsDirty = False
    End Sub

    ''' <summary>
    ''' Returns the Survey DisplayLabel
    ''' </summary>
    Public Overrides Function ToString() As String
        Return Me.DisplayLabel
    End Function

    ''' <summary>
    ''' Returns all the ExportSet objects that thave been created for the survey
    ''' </summary>
    ''' <returns>Returns a collection of ExportSet objects belonging to the survey</returns>
    Public Function GetExportSets(ByVal exportType As ExportSetType) As Collection(Of ExportSet)
        Return GetExportSets(Nothing, Nothing, exportType)
    End Function

    ''' <summary>
    ''' Returns all the ExportSet objects that thave been created for the survey within the date range specified
    ''' </summary>
    ''' <param name="creationFilterStartDate">The starting date used to filter the results</param>
    ''' <param name="creationFilterEndDate">The ending date used to filter the results</param>
    ''' <returns>
    ''' Returns a collection of ExportSet objects belonging to the survey and were created
    ''' during the date range specified.
    ''' </returns>
    Public Function GetExportSets(ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal exportType As ExportSetType) As Collection(Of ExportSet)
        Return DataProvider.Instance.SelectExportSetsBySurveyId(mId, creationFilterStartDate, creationFilterEndDate, exportType)
    End Function


End Class
