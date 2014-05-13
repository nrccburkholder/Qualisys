Imports NRC.Framework.BusinessLogic
Imports NRC.Framework.BusinessLogic.Configuration

Public Interface IDataFile

    Property Id() As Integer

End Interface

<Serializable()> _
Public Class DataFile
	Inherits BusinessBase(Of DataFile)
	Implements IDataFile

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mClientId As Integer
    Private mStudyId As Integer
    Private mSurveyId As Integer
    Private mFileTypeId As Integer
    Private mPervasiveMapName As String = String.Empty
    Private mFileLocation As String = String.Empty
    Private mFileName As String = String.Empty
    Private mFileSize As Integer
    Private mRecords As Integer
    Private mdatReceived As Date
    Private mdatBegin As Date
    Private mdatEnd As Date
    Private mLoaded As Integer
    Private mdatMinDate As Date
    Private mdatMaxDate As Date
    Private mdatDeleted As Date
    Private mDataSetId As Integer
    Private mAssocDataFiles As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IDataFile.Id
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

    Public Property ClientId() As Integer
        Get
            Return mClientId
        End Get
        Set(ByVal value As Integer)
            If Not value = mClientId Then
                mClientId = value
                PropertyHasChanged("ClientId")
            End If
        End Set
    End Property

    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Set(ByVal value As Integer)
            If Not value = mStudyId Then
                mStudyId = value
                PropertyHasChanged("StudyId")
            End If
        End Set
    End Property

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

    Public Property FileTypeId() As Integer
        Get
            Return mFileTypeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mFileTypeId Then
                mFileTypeId = value
                PropertyHasChanged("FileTypeId")
            End If
        End Set
    End Property

    Public Property PervasiveMapName() As String
        Get
            Return mPervasiveMapName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPervasiveMapName Then
                mPervasiveMapName = value
                PropertyHasChanged("PervasiveMapName")
            End If
        End Set
    End Property

    Public Property FileLocation() As String
        Get
            Return mFileLocation
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFileLocation Then
                mFileLocation = value
                PropertyHasChanged("FileLocation")
            End If
        End Set
    End Property

    Public Property FileName() As String
        Get
            Return mFileName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFileName Then
                mFileName = value
                PropertyHasChanged("FileName")
            End If
        End Set
    End Property

    Public Property FileSize() As Integer
        Get
            Return mFileSize
        End Get
        Set(ByVal value As Integer)
            If Not value = mFileSize Then
                mFileSize = value
                PropertyHasChanged("FileSize")
            End If
        End Set
    End Property

    Public Property Records() As Integer
        Get
            Return mRecords
        End Get
        Set(ByVal value As Integer)
            If Not value = mRecords Then
                mRecords = value
                PropertyHasChanged("Records")
            End If
        End Set
    End Property

    Public Property datReceived() As Date
        Get
            Return mdatReceived
        End Get
        Set(ByVal value As Date)
            If Not value = mdatReceived Then
                mdatReceived = value
                PropertyHasChanged("datReceived")
            End If
        End Set
    End Property

    Public Property datBegin() As Date
        Get
            Return mdatBegin
        End Get
        Set(ByVal value As Date)
            If Not value = mdatBegin Then
                mdatBegin = value
                PropertyHasChanged("datBegin")
            End If
        End Set
    End Property

    Public Property datEnd() As Date
        Get
            Return mdatEnd
        End Get
        Set(ByVal value As Date)
            If Not value = mdatEnd Then
                mdatEnd = value
                PropertyHasChanged("datEnd")
            End If
        End Set
    End Property

    Public Property Loaded() As Integer
        Get
            Return mLoaded
        End Get
        Set(ByVal value As Integer)
            If Not value = mLoaded Then
                mLoaded = value
                PropertyHasChanged("Loaded")
            End If
        End Set
    End Property

    Public Property datMinDate() As Date
        Get
            Return mdatMinDate
        End Get
        Set(ByVal value As Date)
            If Not value = mdatMinDate Then
                mdatMinDate = value
                PropertyHasChanged("datMinDate")
            End If
        End Set
    End Property

    Public Property datMaxDate() As Date
        Get
            Return mdatMaxDate
        End Get
        Set(ByVal value As Date)
            If Not value = mdatMaxDate Then
                mdatMaxDate = value
                PropertyHasChanged("datMaxDate")
            End If
        End Set
    End Property

    Public Property datDeleted() As Date
        Get
            Return mdatDeleted
        End Get
        Set(ByVal value As Date)
            If Not value = mdatDeleted Then
                mdatDeleted = value
                PropertyHasChanged("datDeleted")
            End If
        End Set
    End Property

    Public Property DataSetId() As Integer
        Get
            Return mDataSetId
        End Get
        Set(ByVal value As Integer)
            If Not value = mDataSetId Then
                mDataSetId = value
                PropertyHasChanged("DataSetId")
            End If
        End Set
    End Property

    Public Property AssocDataFiles() As String
        Get
            Return mAssocDataFiles
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAssocDataFiles Then
                mAssocDataFiles = value
                PropertyHasChanged("AssocDataFiles")
            End If
        End Set
    End Property

    Public ReadOnly Property ReportURL() As String
        Get
            Return String.Format("{0}{1}&rs:Command=Render&rc:Parameters=false&DataFile_id={2}", AppConfig.Params("PrevReportServer").StringValue, AppConfig.Params("PrevValidationReport").StringValue, Id)
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewDataFile() As DataFile

        Return New DataFile

    End Function

    Public Shared Function [Get](ByVal id As Integer) As DataFile

        Return DataFileProvider.Instance.SelectDataFile(id)

    End Function

    Public Shared Function GetAll() As DataFileCollection

        Return DataFileProvider.Instance.SelectAllDataFiles()

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object
        If IsNew Then
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

    Protected Overrides Sub Insert()

        Id = DataFileProvider.Instance.InsertDataFile(Me)

    End Sub

    Protected Overrides Sub Update()

        DataFileProvider.Instance.UpdateDataFile(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        DataFileProvider.Instance.DeleteDataFile(Me)

    End Sub

#End Region

#Region " Public Methods "

    Public Sub Apply()

        DataFileProvider.Instance.Apply(Me)

    End Sub

    'Returns True if valid; False if invalid
    Public Function Validate() As Boolean

        Return DataFileProvider.Instance.Validate(Me)

    End Function

    Public Sub ChangeState(ByVal stateID As DataFileStates, ByVal stateParam As String)

        DataFileStateProvider.Instance.ChangeDataFileState(mId, stateID, stateParam)

    End Sub

#End Region

End Class


