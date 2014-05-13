Public Class SQLDTSTask
    Private _Name As String
    Private _Description As String
    Private _SourceConnectionID As Integer
    Private _SourceObject As String
    Private _DestConnectionID As Integer
    Private _DestObject As String
    Private _Transformations As New SQLDTSTransformationCollection

    Public Property Name() As String
        Get
            Return Me._Name
        End Get
        Set(ByVal Value As String)
            Me._Name = Value
        End Set
    End Property
    Public Property Description() As String
        Get
            Return Me._Description
        End Get
        Set(ByVal Value As String)
            Me._Description = Value
        End Set
    End Property
    Public Property SourceConnectionID() As Integer
        Get
            Return Me._SourceConnectionID
        End Get
        Set(ByVal Value As Integer)
            Me._SourceConnectionID = Value
        End Set
    End Property
    Public Property SourceObject() As String
        Get
            Return Me._SourceObject
        End Get
        Set(ByVal Value As String)
            Me._SourceObject = Value
        End Set
    End Property
    Public Property DestConnectionID() As Integer
        Get
            Return Me._DestConnectionID
        End Get
        Set(ByVal Value As Integer)
            Me._DestConnectionID = Value
        End Set
    End Property
    Public Property DestObject() As String
        Get
            Return Me._DestObject
        End Get
        Set(ByVal Value As String)
            Me._DestObject = Value
        End Set
    End Property
    Public Property Transformations() As SQLDTSTransformationCollection
        Get
            Return Me._Transformations
        End Get
        Set(ByVal Value As SQLDTSTransformationCollection)
            Me._Transformations = Value
        End Set
    End Property

End Class
Public Class SQLDTSTaskCollection
    Inherits CollectionBase

    Default Public Property Item(ByVal index As Integer) As SQLDTSTask
        Get
            Return DirectCast(MyBase.List.Item(index), SQLDTSTask)
        End Get
        Set(ByVal Value As SQLDTSTask)
            MyBase.List.Item(index) = Value
        End Set
    End Property

    Public Sub Add(ByVal task As SQLDTSTask)
        MyBase.List.Add(task)
    End Sub
End Class
