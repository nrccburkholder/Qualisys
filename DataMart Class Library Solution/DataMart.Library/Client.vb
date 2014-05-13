''' <summary>
''' Represents a DataMart Client
''' </summary>
<DebuggerDisplay("{Name} ({Id})")> _
Public Class Client

#Region " Private Fields "

#Region " Persisted Fields "
    Private mId As Integer
    Private mName As String
#End Region

    Private mIsDirty As Boolean
    Private mStudies As Collection(Of Study)

#End Region

#Region " Public Properties "

#Region " Persisted Properties "
    ''' <summary>
    ''' The unique identifier of the Client in the data store
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
    ''' The name of the client
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
#End Region

    ''' <summary>
    ''' A display label for this client
    ''' </summary>
    Public ReadOnly Property DisplayLabel() As String
        Get
            Return String.Format("{0} ({1})", mName, mId)
        End Get
    End Property

    ''' <summary>
    ''' Returns true if the object has been modified since it was retrieved from the data store.
    ''' </summary>
    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

    ''' <summary>
    ''' The collection of Study objects that belong to this client
    ''' </summary>
    Public ReadOnly Property Studies() As Collection(Of Study)
        Get
            If mStudies Is Nothing Then
                Throw New NotImplementedException
            End If
            Return mStudies
        End Get
    End Property
#End Region

#Region " Constructors "
    ''' <summary>
    ''' Initializes an intance of the Client class 
    ''' </summary>
    Public Sub New()
    End Sub

    ''' <summary>
    ''' Initializes an intance of the Client class with the supplied collection of child Study objects
    ''' </summary>
    ''' <param name="studies">The collection of Studies that belong to the client</param>
    Public Sub New(ByVal studies As Collection(Of Study))
        MyBase.New()
        Me.mStudies = studies
    End Sub

#End Region

#Region " DB CRUD Methods "

    ''' <summary>
    ''' Returns a Client object for the ID specified
    ''' </summary>
    ''' <param name="clientId">The ID of the Client object to return</param>
    Public Shared Function GetClient(ByVal clientId As Integer) As Client
        Return DataProvider.Instance.SelectClient(clientId)
    End Function

    ''' <summary>
    ''' Retrieves from the data store a collection of all the clients and studies that
    ''' the user has access to.
    ''' </summary>
    ''' <param name="userName">The user name to retrieve the collection of clients for.</param>
    ''' <returns>A collection of clients that the user has access to</returns>
    Public Shared Function GetClientsByUser(ByVal userName As String, ByVal depth As PopulateDepth) As Collection(Of Client)
        Select Case depth
            Case PopulateDepth.Client
                Throw New NotImplementedException
            Case PopulateDepth.Study
                Return DataProvider.Instance.SelectClientsAndStudiesByUser(userName)
            Case PopulateDepth.Survey
                Return DataProvider.Instance.SelectClientsStudiesAndSurveysByUser(userName)
            Case Else
                Throw New ArgumentOutOfRangeException("depth")
        End Select
    End Function

    ''' <summary>
    ''' Returns a collection of clients, studies and surveys that the user specified as access to
    ''' </summary>
    ''' <param name="userName">The name of the user for whom to retrive the client collection</param>
    ''' <returns></returns>
    Public Shared Function GetClientsByUser(ByVal userName As String) As Collection(Of Client)
        Return GetClientsByUser(userName, PopulateDepth.Client)
    End Function

    ''' <summary>
    ''' Specifies how deep the Client, Study, Survey object tree should be initially populated
    ''' </summary>
    ''' <remarks></remarks>
    Public Enum PopulateDepth
        Client
        Study
        Survey
    End Enum

    Public Shared Function GetHcahpsClientsByUser(ByVal userName As String, ByVal unitList As Collection(Of SampleUnit)) As Collection(Of Client)
        Return DataProvider.Instance.SelectHcahpsClientsByUser(userName, unitList)
    End Function

    Public Shared Function GetHHcahpsClientsByUser(ByVal userName As String, ByVal unitList As Collection(Of SampleUnit)) As Collection(Of Client)
        Return DataProvider.Instance.SelectHHcahpsClientsByUser(userName, unitList)
    End Function

    Public Shared Function GetCHARTClientsByUser(ByVal userName As String, ByVal unitList As Collection(Of SampleUnit)) As Collection(Of Client)
        Return DataProvider.Instance.SelectCHARTClientsByUser(userName, unitList)
    End Function
#End Region

    ''' <summary>
    ''' Marks the object as being up-to-date with the data store
    ''' </summary>
    Public Sub ResetDirtyFlag()
        Me.mIsDirty = False
    End Sub

    ''' <summary>
    ''' Returns the Client DisplayLabel
    ''' </summary>
    Public Overrides Function ToString() As String
        Return Me.DisplayLabel
    End Function

    ''' <summary>
    ''' Returns all the ExportSet objects that thave been created for the client
    ''' </summary>
    ''' <returns>Returns a collection of ExportSet objects belonging to the client</returns>
    Public Function GetExportSets(ByVal exportType As ExportSetType) As Collection(Of ExportSet)
        Return GetExportSets(Nothing, Nothing, exportType)
    End Function

    ''' <summary>
    ''' Returns all the ExportSet objects that thave been created for the client within the date range specified
    ''' </summary>
    ''' <param name="creationFilterStartDate">The starting date used to filter the results</param>
    ''' <param name="creationFilterEndDate">The ending date used to filter the results</param>
    ''' <returns>
    ''' Returns a collection of ExportSet objects belonging to the client and were created
    ''' during the date range specified.
    ''' </returns>
    Public Function GetExportSets(ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal exportType As ExportSetType) As Collection(Of ExportSet)
        Return DataProvider.Instance.SelectExportSetsByClientId(mId, creationFilterStartDate, creationFilterEndDate, exportType)
    End Function

End Class

