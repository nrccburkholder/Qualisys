''' <summary>
''' Represents a DataMart Study
''' </summary>
<DebuggerDisplay("{Name} ({Id})")> _
Public Class Study

#Region " Private Members "

#Region " Persisted Fields "
    Private mId As Integer
    Private mClientId As Integer
    Private mName As String
    Private mAccountDirectorName As String
#End Region

    Private mIsDirty As Boolean
    Private mClient As Client
    Private mSurveys As Collection(Of Survey)

#End Region

#Region " Public Properties "

#Region " Persisted Properties "
    ''' <summary>
    ''' The ID of the Study in the data store
    ''' </summary>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    ''' <summary>
    ''' The ID of the Client to which this Study belongs
    ''' </summary>
    Public Property ClientId() As Integer
        Get
            Return mClientId
        End Get
        Set(ByVal Value As Integer)
            If Not Value = mClientId Then
                mClientId = Value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The name of the study
    ''' </summary>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal Value As String)
            If Not Value = mName Then
                mName = Value
                mIsDirty = True
            End If
        End Set
    End Property

    '''' <summary>
    '''' The name the account director for the study.
    '''' </summary>
    'Public Property AccountDirectorName() As String
    '    Get
    '        Return mAccountDirectorName
    '    End Get
    '    Set(ByVal value As String)
    '        mAccountDirectorName = value
    '    End Set
    'End Property

#End Region

    ''' <summary>
    ''' A display label for this study
    ''' </summary>
    Public ReadOnly Property DisplayLabel() As String
        Get
            Return String.Format("{0} ({1})", mName, mId)
        End Get
    End Property

    ''' <summary>
    ''' Returns True if this object has been modified since it was retrived from the data store
    ''' </summary>
    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

    ''' <summary>
    ''' The Client object to which this study belongs
    ''' </summary>
    Public ReadOnly Property Client() As Client
        Get
            If mClient Is Nothing Then
                mClient = Nrc.DataMart.Library.Client.GetClient(mClientId)
            End If
            Return mClient
        End Get
    End Property

    ''' <summary>
    ''' The collection of Survey objects that belong to this study
    ''' </summary>
    Public ReadOnly Property Surveys() As Collection(Of Survey)
        Get
            If mSurveys Is Nothing Then
                mSurveys = Survey.GetSurveysByStudyId(Me.Id)
            End If
            Return mSurveys
        End Get
    End Property
#End Region

#Region " Constructors "
    ''' <summary>
    ''' Initializes an instance of the Study class
    ''' </summary>
    Public Sub New()
    End Sub

    ''' <summary>
    ''' Initializes an instance of the Study class and sets the parent client object
    ''' </summary>
    ''' <param name="parentClient">The client object to which this study belongs</param>
    Public Sub New(ByVal parentClient As Client)
        Me.New()
        Me.mClient = parentClient
    End Sub

    ''' <summary>
    ''' Initializes an instance of the Study class, sets the parent client 
    ''' object, and sets the collection of surveys that belong to the study
    ''' </summary>
    ''' <param name="parentClient">The client object to which this study belongs</param>
    ''' <param name="surveys">The collection of survey objects that belong to this study</param>
    Public Sub New(ByVal parentClient As Client, ByVal surveys As Collection(Of Survey))
        Me.New(parentClient)
        Me.mSurveys = surveys
    End Sub
#End Region

#Region " DB CRUD Methods "

    ''' <summary>
    ''' Retrieves and populates a study object from the data store
    ''' </summary>
    ''' <param name="studyId">The ID of the study to retrieve.</param>
    Public Shared Function GetStudy(ByVal studyId As Integer) As Study
        Return DataProvider.Instance.SelectStudy(studyId)
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
    ''' Returns all the ExportSet objects that thave been created for the study
    ''' </summary>
    ''' <returns>Returns a collection of ExportSet objects belonging to the study</returns>
    Public Function GetExportSets(ByVal exportType As ExportSetType) As Collection(Of ExportSet)
        Return GetExportSets(Nothing, Nothing, exportType)
    End Function

    ''' <summary>
    ''' Returns all the ExportSet objects that thave been created for the study within the date range specified
    ''' </summary>
    ''' <param name="creationFilterStartDate">The starting date used to filter the results</param>
    ''' <param name="creationFilterEndDate">The ending date used to filter the results</param>
    ''' <returns>
    ''' Returns a collection of ExportSet objects belonging to the study and were created
    ''' during the date range specified.
    ''' </returns>
    Public Function GetExportSets(ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal exportType As ExportSetType) As Collection(Of ExportSet)
        Return DataProvider.Instance.SelectExportSetsByStudyId(mId, creationFilterStartDate, creationFilterEndDate, exportType)
    End Function
End Class
