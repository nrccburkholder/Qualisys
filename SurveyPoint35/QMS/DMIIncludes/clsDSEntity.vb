Public MustInherit Class clsDSEntity

    Protected _ds As DataSet
    Protected _oConn As SqlClient.SqlConnection
    Protected _sDSName As String = "NONE"
    Protected _sbErrorMessage As New Text.StringBuilder()

    'constructor
    Public Sub New(ByVal oConn As SqlClient.SqlConnection)
        _oConn = oConn
        SetTypedDataSet()

    End Sub

    'set _ds to typed dataset
    Protected MustOverride Sub SetTypedDataSet()

    'clean up method
    Public Sub Close()
        _oConn = Nothing
        _ds = Nothing
        CleanUpEntityObjects()

    End Sub

    'clean up dbEntity objects
    Protected MustOverride Sub CleanUpEntityObjects()

    Public Property ErrorMsg() As String
        Get
            Return _sbErrorMessage.ToString

        End Get
        Set(ByVal Value As String)
            _sbErrorMessage.Append(Value)

        End Set
    End Property
#Region "Fill functions"
    'fill all parent tables
    Protected MustOverride Sub FillLookupTables(ByVal drCriteria As DataRow)

    'fill all child tables, after main table has been filled
    Protected MustOverride Sub FillChildTables(ByVal drCriteria As DataRow)

    'fill main table
    Protected MustOverride Sub FillMainTable(ByVal drCriteria As DataRow)

    'fills lookups, main, then child tables
    Public Overridable Sub Fill(ByVal drCriteria As DataRow)
        FillLookupTables(drCriteria)
        FillMainTable(drCriteria)
        FillChildTables(drCriteria)

    End Sub

#End Region

#Region "Dataset property and functions"
    'Get and set entity dataset
    Public Overridable Property DataSet() As DataSet
        Get
            _ds.DataSetName = _sDSName
            Return _ds

        End Get
        Set(ByVal Value As DataSet)
            _ds = Value

        End Set
    End Property

    'Set and get unique dataset name
    Public Property DSName() As String
        Get
            Return _ds.DataSetName

        End Get
        Set(ByVal Value As String)
            _sDSName = Value

        End Set
    End Property

    'Verifies dataset name and reconsitutes dataset
    Public Overridable Function DSVerify(ByVal ds As DataSet) As Boolean

        'Is dataset empty
        If Not IsNothing(ds) Then
            'Does dataset have correct name
            If ds.DataSetName = _sDSName Then
                'Dataset successfully verified
                _ds = ds
                Return True

            End If
        End If

        'Input dataset not verified
        Return False

    End Function

#End Region

End Class
