Imports Nrc.QualiSys.Library.DataProvider
Imports NRC.Framework.BusinessLogic

Public Interface IClient
    Property Id() As Integer
End Interface

<DebuggerDisplay("{Name} ({Id})")> _
Public Class Client
    Implements IClient

#Region " Private Members "

    Private mId As Integer
    Private mName As String
    Private mOrgName As String
    Private mIsActive As Boolean = True
    Private mClientGroupID As Integer = -1

    Private mIsDirty As Boolean
    Private mClientGroup As ClientGroup
    Private mStudies As Collection(Of Study)

#End Region

#Region " Public Properties "

    <Logable()> _
    Public Property Id() As Integer Implements IClient.Id
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

    Public Property OrgName() As String
        Get
            Return mOrgName
        End Get
        Set(ByVal value As String)
            If Not value = mOrgName Then
                mOrgName = value
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
    Public Property ClientGroupID() As Integer
        Get
            Return mClientGroupID
        End Get
        Set(ByVal value As Integer)
            If Not value = mClientGroupID Then
                mClientGroupID = value
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

    Public ReadOnly Property ClientGroup() As ClientGroup
        Get
            If mClientGroup Is Nothing Then
                mClientGroup = Nrc.QualiSys.Library.ClientGroup.GetClientGroup(mClientGroupID)
            End If
            Return mClientGroup
        End Get
    End Property

    Public ReadOnly Property Studies() As Collection(Of Study)
        Get
            If mStudies Is Nothing Then
                mStudies = Study.GetStudiesByClientId(Me)
            End If
            Return mStudies
        End Get
    End Property

    Public ReadOnly Property AllowDelete() As Boolean
        Get
            Return ClientProvider.Instance.AllowDelete(mId)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

    End Sub

    Public Sub New(ByVal parentGroup As ClientGroup)

        Me.New()
        mClientGroup = parentGroup

    End Sub

    Public Sub New(ByVal parentGroup As ClientGroup, ByVal studies As Collection(Of Study))

        Me.New(parentGroup)
        mStudies = studies

    End Sub

#End Region

#Region " DB CRUD Methods "

    Public Shared Function GetClient(ByVal clientId As Integer) As Client

        Return ClientProvider.Instance.[Select](clientId)

    End Function

    Public Shared Function GetClientsByUser(ByVal userName As String, ByVal depth As PopulateDepth, ByVal showAllClients As Boolean) As Collection(Of Client)

        Select Case depth
            Case PopulateDepth.Client
                Throw New NotImplementedException

            Case PopulateDepth.Study
                Return ClientProvider.Instance.SelectClientsAndStudiesByUser(userName, showAllClients)

            Case PopulateDepth.Survey
                Return ClientProvider.Instance.SelectClientsStudiesAndSurveysByUser(userName, showAllClients)

            Case Else
                Throw New ArgumentOutOfRangeException("depth")

        End Select

    End Function

    Public Shared Function GetClientsByUser(ByVal userName As String, ByVal depth As PopulateDepth) As Collection(Of Client)

        Return GetClientsByUser(userName, depth, False)

    End Function

    Public Shared Function GetClientsByUser(ByVal userName As String) As Collection(Of Client)

        Return GetClientsByUser(userName, PopulateDepth.Client, False)

    End Function

    Public Shared Function GetClientsByClientGroupID(ByVal clientGroup As ClientGroup) As Collection(Of Client)

        Return ClientProvider.Instance.SelectClientsByClientGroupID(clientGroup)

    End Function

    Public Shared Function CreateNew(ByVal clientName As String, ByVal isActive As Boolean, ByVal clientGroupID As Integer) As Client

        Dim newId As Integer = ClientProvider.Instance.Insert(clientName, isActive, clientGroupID)
        Return ClientProvider.Instance.Select(newId)

    End Function

    Public Shared Sub Delete(ByVal clientId As Integer)

        ClientProvider.Instance.Delete(clientId)

    End Sub

    Public Sub Update()

        ClientProvider.Instance.Update(Me)

    End Sub

#End Region

#Region " Public Methods "

    'Public Function GetSampleUnitLinkings() As SampleUnitLinkingCollection

    '    Return SampleUnitLinking.GetSampleUnitLinkingsByClientId(mId)

    'End Function

    'Public Sub UpdateSampleUnitLinkings(ByVal linkings As SampleUnitLinkingCollection)

    '    SampleUnitLinkingProvider.Instance.DeleteByClientId(mId)
    '    For Each link As SampleUnitLinking In linkings
    '        SampleUnitLinkingProvider.Instance.Insert(link.FromSampleUnitId, link.ToSampleUnitId)
    '    Next

    'End Sub

    Public Sub ResetDirtyFlag()

        mIsDirty = False

    End Sub

    Public Overrides Function ToString() As String

        Return DisplayLabel

    End Function

#End Region

End Class

