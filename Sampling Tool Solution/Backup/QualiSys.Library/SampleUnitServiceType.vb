Public Class SampleUnitServiceType

#Region " Private Fields "

#Region " Persisted Fields "

    Private mId As Integer
    Private mName As String

#End Region

    Private mParentService As SampleUnitServiceType
    Private mChildServices As Collection(Of SampleUnitServiceType)
    Private mIsDirty As Boolean
    Private Shared mAllServiceTypes As Collection(Of SampleUnitServiceType)

#End Region

#Region " Public Properties "

    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If (mName <> value) Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public Property ParentService() As SampleUnitServiceType
        Get
            Return mParentService
        End Get
        Set(ByVal value As SampleUnitServiceType)
            If (mParentService Is Nothing AndAlso value Is Nothing) Then Return

            If ((mParentService Is Nothing AndAlso value IsNot Nothing) OrElse _
                (mParentService IsNot Nothing AndAlso value Is Nothing) OrElse _
                (mParentService.Id <> value.Id) _
                ) Then
                mParentService = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public ReadOnly Property ChildServices() As Collection(Of SampleUnitServiceType)
        Get
            Return mChildServices
        End Get
        'Set(ByVal value As Collection(Of ServiceType))
        '    mChildServices = value
        '    mIsDirty = True
        'End Set
    End Property

    Public ReadOnly Property DisplayLabel() As String
        Get
            Return mName
        End Get
    End Property

    ''' <summary>
    ''' Indicates if the changes have been made to the object that have not been saved to the database.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New()
        Me.mChildServices = New Collection(Of SampleUnitServiceType)
    End Sub

    Public Sub New(ByVal id As Integer, ByVal name As String)
        Me.New()
        Me.mId = id
        Me.mName = name
    End Sub

    Public Sub New(ByVal id As Integer, ByVal name As String, ByVal parentService As SampleUnitServiceType)
        Me.New()
        Me.mId = id
        Me.mName = name
        Me.mParentService = parentService
    End Sub

#End Region

#Region " Public Methods "

    ''' <summary>
    ''' Resets the is Dirty Flag to false.
    ''' </summary>
    ''' <remarks>This method should be called after saving changes.</remarks>
    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub

    Public Shared Function FindServiceTypeById(ByVal serviceTypes As Collection(Of SampleUnitServiceType), ByVal serviceId As Integer) As SampleUnitServiceType
        For Each type As SampleUnitServiceType In serviceTypes
            If (type.Id = serviceId) Then Return type
            If (type.ChildServices IsNot Nothing) Then
                For Each subType As SampleUnitServiceType In type.ChildServices
                    If (subType.Id = serviceId) Then Return subType
                Next
            End If
        Next
        Return Nothing
    End Function

    Public Shared Function GetAllServiceTypes() As Collection(Of SampleUnitServiceType)
        If (mAllServiceTypes Is Nothing) Then
            mAllServiceTypes = DataProvider.SampleUnitServiceTypeProvider.Instance.SelectServiceTypes()
        End If
        Return mAllServiceTypes
    End Function

    Public Shared Function GetServiceTypeBySampleUnitId(ByVal sampleUnitId As Integer) As SampleUnitServiceType
        Return DataProvider.SampleUnitServiceTypeProvider.Instance.SelectServiceTypeBySampleUnitId(sampleUnitId)
    End Function

    Public Shared Function ServiceCollectionContains(ByVal serviceCollection As Collection(Of SampleUnitServiceType), ByVal service As SampleUnitServiceType) As Boolean
        If (serviceCollection Is Nothing) Then Return False
        For Each item As SampleUnitServiceType In serviceCollection
            If (item.Id = service.Id) Then Return True
        Next
        Return False
    End Function

    Public Overrides Function ToString() As String
        Return Me.DisplayLabel
    End Function

#End Region

End Class
