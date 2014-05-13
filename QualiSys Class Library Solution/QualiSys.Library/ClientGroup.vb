Imports Nrc.QualiSys.Library.DataProvider

Public Interface IClientGroup
    Property Id() As Integer
End Interface

<DebuggerDisplay("{Name} ({Id})")> _
Public Class ClientGroup
    Implements IClientGroup

#Region " Private Members "
    Private mId As Integer
    Private mName As String
    Private mReportName As String
    Private mIsActive As Boolean = True
    Private mCreated As Date

    Private mIsDirty As Boolean
    Private mClients As Collection(Of Client)

#End Region

#Region " Public Properties "

    <Logable()> _
    Public Property Id() As Integer Implements IClientGroup.Id
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    <Logable()> _
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If Not value = mName Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property ReportName() As String
        Get
            Return mReportName
        End Get
        Set(ByVal value As String)
            If Not value = mReportName Then
                mReportName = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsActive() As Boolean
        Get
            Return mIsActive
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsActive Then
                mIsActive = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property Created() As Date
        Get
            Return mCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mCreated Then
                mCreated = value
                mIsDirty = True
            End If
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property DisplayLabel() As String
        Get
            Return String.Format("{0} ({1})", mName, mId)
        End Get
    End Property

    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

    Public ReadOnly Property Clients() As Collection(Of Client)
        Get
            If mClients Is Nothing Then
                mClients = Client.GetClientsByClientGroupID(Me)
            End If
            Return mClients
        End Get
    End Property

    Public ReadOnly Property AllowDelete() As Boolean
        Get
            Return ClientGroupProvider.Instance.AllowDelete(mId)
        End Get
    End Property

    Public ReadOnly Property DisplayStatusLabel() As String
        Get
            If IsActive Then
                Return String.Format("{0}", Name)
            Else
                Return String.Format("{0} (InActive)", Name)
            End If
        End Get
    End Property
#End Region

#Region " Constructors "

    Public Sub New()

    End Sub

    Public Sub New(ByVal clients As Collection(Of Client))

        Me.New()
        mClients = clients

    End Sub

#End Region

#Region " DB CRUD Methods "

    Public Shared Function GetClientGroup(ByVal clientGroupID As Integer) As ClientGroup

        Return ClientGroupProvider.Instance.Select(clientGroupID)

    End Function

    Public Shared Function GetAll() As Collection(Of ClientGroup)
        Return ClientGroupProvider.Instance.SelectAllClientGroups()
    End Function

    Public Shared Function GetClientGroupsByUser(ByVal userName As String, ByVal depth As PopulateDepth, ByVal showAllClients As Boolean) As Collection(Of ClientGroup)

        Select Case depth
            Case PopulateDepth.Client
                Return ClientGroupProvider.Instance.SelectClientGroupsAndClientsByUser(userName, showAllClients)

            Case PopulateDepth.Study
                Return ClientGroupProvider.Instance.SelectClientGroupsClientsAndStudiesByUser(userName, showAllClients)

            Case PopulateDepth.Survey
                Return ClientGroupProvider.Instance.SelectClientGroupsClientsStudiesAndSurveysByUser(userName, showAllClients)

            Case Else
                Throw New ArgumentOutOfRangeException("depth")

        End Select

    End Function

    Public Shared Function GetClientGroupsByUser(ByVal userName As String, ByVal depth As PopulateDepth) As Collection(Of ClientGroup)

        Return GetClientGroupsByUser(userName, depth, False)

    End Function

    Public Shared Function GetClientGroupsByUser(ByVal userName As String) As Collection(Of ClientGroup)

        Return GetClientGroupsByUser(userName, PopulateDepth.Client, False)

    End Function

    Public Shared Function CreateNew(ByVal name As String, ByVal reportName As String, ByVal isActive As Boolean) As ClientGroup

        Dim newId As Integer = ClientGroupProvider.Instance.Insert(name, reportName, isActive)
        Return ClientGroupProvider.Instance.Select(newId)

    End Function

    Public Shared Sub Delete(ByVal clientGroupId As Integer)

        ClientGroupProvider.Instance.Delete(clientGroupId)

    End Sub

    Public Sub Update()

        ClientGroupProvider.Instance.Update(Me)

    End Sub

#End Region

#Region " Public Methods "

    Public Sub ResetDirtyFlag()

        mIsDirty = False

    End Sub

    Public Overrides Function ToString() As String

        Return DisplayLabel

    End Function

#End Region

End Class

